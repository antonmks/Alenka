#include "../../../util/cucpp.h"
#include <cstdio>

#ifdef _MSC_VER
#include <random>
#else
#include <tr1/random>
#endif

std::tr1::mt19937 mt19937;

void PrintArray(const float* values, int count) {
	printf("%d elements.\n", count);
	while(count > 0) {
		printf("\t");
		int c = std::min(8, count);
		for(int i(0); i < c; ++i)
			printf("%5.2f  ", values[i]);
		count -= c;
		values += c;
		printf("\n");
	}
}


int main(int argc, char** argv) {
	CUresult result = cuInit(0);

	DevicePtr device;
	result = CreateCuDevice(0, &device);
	if(CUDA_SUCCESS != result || 2 != device->ComputeCapability().first) {
		printf("Could not create device or device is not Fermi.\n");
		return 0;
	}

	ContextPtr context;
	result = CreateCuContext(device, 0, &context);

	ModulePtr module;
	result = context->LoadModuleFilename(
		"../../src/ballotscan/ballotscan.cubin", &module);

	// Load the four kernels.
	FunctionPtr pScanWarp, bScanWarp, pScanBlock, bScanBlock;
	module->GetFunction("ParallelScanWarp", make_int3(32, 1, 1), &pScanWarp);
	module->GetFunction("BallotScanWarp", make_int3(32, 1, 1), &bScanWarp);
	module->GetFunction("ParallelScanBlock", make_int3(256, 1, 1), &pScanBlock);
	module->GetFunction("BallotScanBlock", make_int3(256, 1, 1), &bScanBlock);

	std::tr1::uniform_real<float> r(-10.0f, 20.0f);
	std::vector<float> test1(32), test2(256);
	for(int i(0); i < 32; ++i) {
		float x = r(mt19937);
		if(x < 0) x = -1.0f;
		test1[i] = x;
	}
	for(int i(0); i < 256; ++i) {
		float x = r(mt19937);
		if(x < 0) x = -1.0f;
		test2[i] = x;
	}

	DeviceMemPtr sourceDevice1, sourceDevice2, destDevice, countDevice;
	context->MemAlloc(test1, &sourceDevice1);
	context->MemAlloc(test2, &sourceDevice2);
	context->MemAlloc<float>(256, &destDevice);
	context->MemAlloc<int>(1, &countDevice);

	std::vector<float> host(256);
	int count;


	////////////////////////////////////////////////////////////////////////////
	// Test warp scan

	printf("Input test array for warp scan:\n");
	PrintArray(&test1[0], 32);
	printf("\n");

	CuCallStack callStack;
	callStack.Push(sourceDevice1, destDevice, countDevice);

	// Test ParallelScanWarp
	result = pScanWarp->Launch(1, 1, callStack);
	countDevice->ToHost(&count, 1);
	destDevice->ToHost(&host[0], count);
	printf("ParallelScanWarp output:\n");
	PrintArray(&host[0], count);
	printf("\n");

	// Test BallotScanWarp
	result = bScanWarp->Launch(1, 1, callStack);
	countDevice->ToHost(&count, 1);
	destDevice->ToHost(&host[0], count);
	printf("BallotScanWarp output:\n");
	PrintArray(&host[0], count);
	printf("\n");
	

	////////////////////////////////////////////////////////////////////////////
	// Test block scan

	printf("Input test array for block scan:\n");
	PrintArray(&test2[0], 256);
	printf("\n");

	callStack.Reset();
	callStack.Push(sourceDevice2, destDevice, countDevice);

	// Test ParallelScanBlock
	result = pScanBlock->Launch(1, 1, callStack);
	countDevice->ToHost(&count, 1);
	destDevice->ToHost(&host[0], count);
	printf("ParallelScanBlock output:\n");
	PrintArray(&host[0], count);
	printf("\n");

	// Test BallotScanBlock
	result = bScanBlock->Launch(1, 1, callStack);
	countDevice->ToHost(&count, 1);
	destDevice->ToHost(&host[0], count);
	printf("BallotScanBlock output:\n");
	PrintArray(&host[0], count);
	printf("\n");




}
