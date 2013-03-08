#include "../../../inc/mgpuscan.h"
#include "../../../util/cucpp.h"
#include <sstream>

struct scanEngine_d {
	ContextPtr context;
	ModulePtr module;
	FunctionPtr pass[3];
	DeviceMemPtr blockScanMem;
	DeviceMemPtr rangeMem;
	int numBlocks;
};


scanStatus_t scanCreateEngine(const char* cubin, scanEngine_t* engine) {
	std::auto_ptr<scanEngine_d> e(new scanEngine_d);
	
	CUresult result = AttachCuContext(&e->context);
	if(CUDA_SUCCESS != result) return SCAN_STATUS_INVALID_CONTEXT;

	if(2 != e->context->Device()->ComputeCapability().first)
		return SCAN_STATUS_UNSUPPORTED_DEVICE;

	result = e->context->LoadModuleFilename(cubin, &e->module);
	if(CUDA_SUCCESS != result) return SCAN_STATUS_KERNEL_NOT_FOUND;

	for(int i(0); i < 3; ++i) {
		std::ostringstream oss;
		oss<< "GlobalScanPass"<< (i + 1);
		result = e->module->GetFunction(oss.str(), make_int3(256, 1, 1),
			&e->pass[i]);
		if(CUDA_SUCCESS != result) return SCAN_STATUS_KERNEL_ERROR;
	}

	int numSMs = e->context->Device()->Attributes().multiprocessorCount;

	// Launch 4 256-thread blocks per SM.
	e->numBlocks = 4 * numSMs;

	// Allocate a uint per thread block plus a uint for the scan total.
	result = e->context->MemAlloc<uint>(e->numBlocks + 1, &e->blockScanMem);
	if(CUDA_SUCCESS != result) return SCAN_STATUS_DEVICE_ALLOC_FAILED;

	result = e->context->MemAlloc<uint2>(e->numBlocks, &e->rangeMem);

	*engine = e.release();
	return SCAN_STATUS_SUCCESS;
}

scanStatus_t scanDestroyEngine(scanEngine_t engine) {
	if(engine) delete engine;
	return SCAN_STATUS_SUCCESS;
}

scanStatus_t scanArray(scanEngine_t engine, CUdeviceptr data, int count,
	uint* scanTotal, bool inclusive) {

	if(!engine) return SCAN_STATUS_INVALID_VALUE;

	// Each block should process 256 * 8 values. We'll dub a 256 * 8 interval a
	// brick so as not to confuse it with a thread block.
	int numBricks = DivUp(count, 256 * 8);
	int numBlocks = std::min(numBricks, engine->numBlocks);

	// Distribute the work along complete bricks.
	div_t brickDiv = div(numBricks, numBlocks);
	std::vector<int2> ranges(numBlocks);
	for(int i(0); i < numBlocks; ++i) {
		int2 range;
		range.x = i ? ranges[i - 1].y : 0;
		int bricks = (i < brickDiv.rem) ? (brickDiv.quot + 1) : brickDiv.quot;
		range.y = std::min(range.x + bricks * 256 * 8, count);
		ranges[i] = range;
	}
	engine->rangeMem->FromHost(ranges);

	CuCallStack callStack;
	callStack.Push(data, engine->rangeMem, engine->blockScanMem);
	CUresult result = engine->pass[0]->Launch(numBlocks, 1, callStack);
	if(CUDA_SUCCESS != result) return SCAN_STATUS_LAUNCH_ERROR;

	callStack.Reset();
	callStack.Push(engine->blockScanMem, numBlocks);
	result = engine->pass[1]->Launch(1, 1, callStack);
	if(CUDA_SUCCESS != result) return SCAN_STATUS_LAUNCH_ERROR;

	// Retrieve the scan total from the end of blockScanMem.
	if(scanTotal)
		engine->blockScanMem->ToHostByte(scanTotal, sizeof(uint) * numBlocks,
			sizeof(uint));


	callStack.Reset();
	callStack.Push(data, engine->rangeMem, engine->blockScanMem, 
		(int)inclusive);
	result = engine->pass[2]->Launch(numBlocks, 1, callStack);
	if(CUDA_SUCCESS != result) return SCAN_STATUS_LAUNCH_ERROR;

	return SCAN_STATUS_SUCCESS;
}

