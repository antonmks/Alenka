#include <vector>
#include "../../../inc/mgpuscan.h"
#include "../../../util/cucpp.h"

#ifdef _MSC_VER
#include <random>
#else
#include <tr1/random>
#endif

std::tr1::mt19937 mt19937;

int main(int argc, char** argv) {
	cuInit(0);

	DevicePtr device;
	CUresult result = CreateCuDevice(0, &device);

	ContextPtr context;
	result = CreateCuContext(device, 0, &context);

	scanEngine_t engine;
	scanStatus_t status = scanCreateEngine(
		"../../src/mgpuscan/globalscan.cubin", &engine);

	int count = 1<< 19;
	std::vector<int> vals(count);

	std::tr1::uniform_int<int> r(0, 15);
	for(int i(0); i < count; ++i)
		vals[i] = r(mt19937);

	DeviceMemPtr deviceMem;
	result = context->MemAlloc(vals, &deviceMem);

	uint scanTotal;
	status = scanArray(engine, deviceMem->Handle(), count, &scanTotal, false);
	std::vector<int> deviceScan;
	deviceMem->ToHost(deviceScan);

	std::vector<int> hostScan(count);
	for(int i(1); i < count; ++i) {
		hostScan[i] = hostScan[i - 1] + vals[i - 1];
		
	}

	scanDestroyEngine(engine);

	bool success = hostScan == deviceScan;
	if(success) printf("Global scan success.\n");
	else printf("Global scan failure.\n");

	return 0;
}
