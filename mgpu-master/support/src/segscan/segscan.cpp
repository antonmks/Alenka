#include "../../../util/cucpp.h"
#include <cstdio>
#include <vector>

#ifdef _MSC_VER
#include <random>
#else
#include <tr1/random>
#endif


std::tr1::mt19937 mt19937;
std::tr1::uniform_int<uint> r(0, 3);
std::tr1::uniform_int<uint> r2(0, 7);

void SegmentedScan(uint* packed, int count) {
	int last = 0;
	for(int i(0); i < count; ++i) {
		uint start = 0x80000000 & packed[i];
		uint x = 0x7fffffff & packed[i];
		if(start) last = 0;
		packed[i] = last;
		last += x;
	}
}

void PrintSegScan(const uint* packed, int count) {
	while(count) {
		int line = std::min(count, 16);
		for(int i(0); i < line; ++i) {
			char number[16];
			number[0] = (0x80000000 & packed[i]) ? '*' : ' ';
			_itoa(0x7fffffff & packed[i], number + 1, 10);
			int len = strlen(number);
			for(int j(len); j < 4; ++j)
				printf(" ");
			printf("%s", number);
		}
		printf("\n");
		packed += line;
		count -= line;
	}
}


uint GenPacked(bool first) {
	uint x = r(mt19937);
	if(first || !r2(mt19937))
		x |= 1<< 31;
	return x;
}

int main(int argc, char** argv) {

	cuInit(0);
	DevicePtr device;
	CUresult result = CreateCuDevice(0, &device);

	ContextPtr context;
	result = CreateCuContext(device, 0, &context);

	ModulePtr module;
	result = context->LoadModuleFilename("../../src/segscan/segscan.cubin",
		&module);
	FunctionPtr func1, func2, func3;
	
	module->GetFunction("SegScanWarp", make_int3(32, 1, 1), &func1);
	module->GetFunction("SegScanWarp8", make_int3(32, 1, 1), &func2);
	module->GetFunction("SegScanBlock8", make_int3(256, 1, 1), &func3);

	int WarpSize = 32;
	int BlockSize = 256;
	int NumWarps = BlockSize / WarpSize;
	int ValuesPerThread = 8;



	////////////////////////////////////////////////////////////////////////////
	// 
	std::vector<uint> host1(WarpSize);
	for(int i(0); i < WarpSize; ++i) 
		host1[i] = GenPacked(0 == i);

	DeviceMemPtr device1;
	result = context->MemAlloc(host1, &device1);

	printf("Warp segmented scan (1 val/thread):\n");
	PrintSegScan(&host1[0], WarpSize);

	SegmentedScan(&host1[0], WarpSize);
	printf("\nCPU segmented scan:\n");
	PrintSegScan(&host1[0], WarpSize);

	CuCallStack callStack;
	callStack.Push(device1, device1);
	func1->Launch(1, 1, callStack);

	device1->ToHost(&host1[0]);
	printf("\nGPU segmented scan:\n");
	PrintSegScan(&host1[0], WarpSize);

	printf("\n\n");


	////////////////////////////////////////////////////////////////////////////
	// 

	int numValues = WarpSize * ValuesPerThread;
	std::vector<uint> host2(numValues);
	for(int i(0); i < numValues; ++i)
		host2[i] = GenPacked(0 == i);

	DeviceMemPtr device2;
	result = context->MemAlloc(host2, &device2);

	printf("Warp segmented scan (8 vals/thread):\n");
	PrintSegScan(&host2[0], numValues);

	SegmentedScan(&host2[0], numValues);
	printf("\nCPU segmented scan:\n");
	PrintSegScan(&host2[0], numValues);


	callStack.Reset();
	callStack.Push(device2, device2);
	func2->Launch(1, 1, callStack);

	device2->ToHost(&host2[0]);
	printf("\nGPU segmented scan:\n");
	PrintSegScan(&host2[0], numValues);

	printf("\n\n");



	////////////////////////////////////////////////////////////////////////////
	// 
	
	numValues = WarpSize * NumWarps * ValuesPerThread;
	std::vector<uint> host3(numValues);
	for(int i(0); i < numValues; ++i)
		host3[i] = GenPacked(0 == i);

	DeviceMemPtr device3;
	result = context->MemAlloc(host3, &device3);

	printf("Block segmented scan (8 vals/thread):\n");
	PrintSegScan(&host3[0], numValues);

	SegmentedScan(&host3[0], numValues);
	printf("\nCPU segmented scan:\n");
	PrintSegScan(&host3[0], numValues);

	callStack.Reset();
	callStack.Push(device3, device3);
	func3->Launch(1, 1, callStack);

	device3->ToHost(host3);
	printf("\nGPU segmented scan:\n");
	PrintSegScan(&host3[0], numValues);

	printf("\n\n");


	return 0;
}
