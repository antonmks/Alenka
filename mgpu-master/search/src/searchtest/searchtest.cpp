#include "searchtest.h"
#include "../../../inc/mgpusearch.h"

#ifdef _MSC_VER
#include <random>
#else
#include <tr1/random>
#endif

// Define all the permutations for benchmarking. The actual iterations taken
// for each array size/query size pair is the product of their second counts.

const int NumArraySizes = 10;
const int ArraySizes[NumArraySizes][2] = {
	{ 50000, 1500 },		
	{ 100000, 1000 },	// 100 K
	{ 500000, 750 },
	{ 1000000, 500 },	// 1M
	{ 5000000, 200 },
	{ 10000000, 150 },	// 10M
	{ 20000000, 80 },	// 20M
	{ 40000000, 50 },	// 40M
	{ 60000000, 30 },	// 60M
	{ 80000000, 20 },	// 80M
};

const int NumQuerySizes = 3;
const int QuerySizes[3][2] = {
	{ 1000, 20 },
	{ 10000, 10 },
	{ 100000, 2 },
};

const int NumTests = 4;

std::tr1::mt19937 mt19937;

template<typename T>
void FillVec(std::vector<T>& vec, int count) {
	std::tr1::uniform_int<T> r(0, 20);
	T cur = 0;
	vec.resize(count);
	for(int i(0); i < count; ++i) {
		vec[i] = cur;
		if(0 == r(mt19937)) ++cur;
	}
}


////////////////////////////////////////////////////////////////////////////////
// Benchmark MGPU Search

template<typename T>
double MgpuBenchmark(searchEngine_t engine, int count, CuDeviceMem* values,
	searchType_t type, CuDeviceMem* btree, int numIterations, int numQueries,
	CuDeviceMem* keys, CuDeviceMem* indices, const T* valuesHost,
	const T* keysHost) {

	CuEventTimer timer;
	timer.Start();
	
	int size = (SEARCH_TYPE_INT32 == type) ? 4 : 8;
	int offset = 0;
	printf("TTT %d %d \n", count , numQueries);
	for(int it(0); it < numIterations; ++it) {
		offset += RoundUp(numQueries, 32);
		if(offset + numQueries > MaxQuerySize) offset = 0;		
        
		searchStatus_t status = searchKeys(engine, count, type, 
			values->Handle(), SEARCH_ALGO_LOWER_BOUND,
			keys->Handle() + offset * size, numQueries, btree->Handle(),
			indices->Handle());
		if(SEARCH_STATUS_SUCCESS != status) {
			printf("FAIL!\n");
			exit(0);
		}
	}

	double elapsed = timer.Stop();
	double throughput = (double)numQueries * numIterations / elapsed;

	// Verify the results for the last set of queries run.
	std::vector<uint> results(numQueries);
	indices->ToHost(results);

	for(int i(0); i < numQueries; ++i) {
		const T* lower = std::lower_bound(valuesHost, valuesHost + count, 
			keysHost[offset + i]);
		if((lower - valuesHost) != results[i]) {
			printf("Failure in MGPU Search.\n");
			exit(0);
		}
	}

	return throughput;
}


////////////////////////////////////////////////////////////////////////////////
// Loop for running multiple tests over all query sizes (for the same sized
// data) for both MGPU and thrust.

template<typename T>
void BenchmarkLoop(CuContext* context, searchEngine_t engine, int count,
	int numIterations, double* mgpuBenchmarks, double* thrustBenchmarks) {

	////////////////////////////////////////////////////////////////////////////
	// Prepare the device assets.
	printf("ARRAY = %d elements.\n", count);

	// Fill the array with sorted values of random repetition.
	std::vector<T> values;
	FillVec(values, count);

	// Get a list of randomized keys for lower_bound search.
	std::vector<T> keys(MaxQuerySize);
	std::tr1::uniform_int<T> r(0, values.back());
	for(int i(0); i < MaxQuerySize; ++i)
		keys[i] = r(mt19937);

	// Move both arrays to device memory.
	DeviceMemPtr valuesDevice, keysDevice;
	CUresult result = context->MemAlloc(values, &valuesDevice);
	result = context->MemAlloc(keys, &keysDevice);

	// Allocate result space.
	DeviceMemPtr indicesDevice;
	result = context->MemAlloc<uint>(MaxQuerySize, &indicesDevice);

	if(CUDA_SUCCESS != result) {
		printf("Error allocating.\n");
		exit(0);
	}

	// Build the b-tree for MGPU Search.
	searchType_t type = (8 == sizeof(T)) ? SEARCH_TYPE_INT64 : 
		SEARCH_TYPE_INT32;

	int treeSize = searchTreeSize(count, type);
	DeviceMemPtr btreeDevice;
	result = context->ByteAlloc(treeSize, &btreeDevice);

	searchStatus_t status = searchBuildTree(engine, count, type, 
		valuesDevice->Handle(), btreeDevice->Handle());


	////////////////////////////////////////////////////////////////////////////
	

	for(int q(0); q < NumQuerySizes; ++q) {
		int querySize = QuerySizes[q][0];
		int iterations = numIterations * QuerySizes[q][1];

		mgpuBenchmarks[q] = 0;
		thrustBenchmarks[q] = 0;
		printf("\t(%d, %d):\n", count, querySize);

		for(int t(0); t < NumTests; ++t) {
			// Test MGPU
			double throughput = MgpuBenchmark(engine, count, valuesDevice,
				type, btreeDevice, iterations, querySize, keysDevice,
				indicesDevice, &values[0], &keys[0]);
			printf("\t\t%10.3f M/s\t\t", throughput / 1.0e6);
			mgpuBenchmarks[q] = std::max(mgpuBenchmarks[q], throughput);

			// Test thrust
			throughput = ThrustBenchmark(count, valuesDevice, iterations,
				querySize, keysDevice, indicesDevice, &values[0], &keys[0]);
			printf("\t\t%10.3f M/s\n", throughput / 1.0e6);
			thrustBenchmarks[q] = std::max(thrustBenchmarks[q], throughput);
		}
	}
	printf("\n");
}


typedef double Throughputs[NumArraySizes][NumQuerySizes];

void PrintResults(Throughputs throughputs) {
	for(int s(0); s < NumArraySizes; ++s) {
		for(int q(0); q < NumQuerySizes; ++q)
			printf("\t%10.3f M/s\t\t", throughputs[s][q] / 1.0e6);
		printf("\n");
	}
	printf("\n");
}



int main(int argc, char** argv) {

	cuInit(0);

	DevicePtr device;
	CreateCuDevice(0, &device);

	ContextPtr context;
	CreateCuContext(device, 0, &context);

	searchEngine_t engine = 0;
	searchStatus_t status = searchCreate("../../src/cubin/search.cubin",
		&engine);

	double mgpuThroughputs[2][NumArraySizes][NumQuerySizes];
	double thrustThroughputs[2][NumArraySizes][NumQuerySizes];

	for(int s(0); s < NumArraySizes; ++s) {

		// 32-bit
		printf("32-bit key search:\n");
		BenchmarkLoop<int>(context, engine, ArraySizes[s][0], ArraySizes[s][1],
			mgpuThroughputs[0][s], thrustThroughputs[0][s]);

		// 64-bit
		printf("64-bit key search:\n");
		BenchmarkLoop<int64>(context, engine, ArraySizes[s][0], 
			ArraySizes[s][1], mgpuThroughputs[1][s], thrustThroughputs[1][s]);
	}
	printf("\nTIMINGS SUMMARY\n\n");

	printf("MGPU Search 32-bit:\n");
	PrintResults(mgpuThroughputs[0]);

	printf("MGPU Search 64-bit:\n");
	PrintResults(mgpuThroughputs[1]);

	printf("thrust 32-bit:\n");
	PrintResults(thrustThroughputs[0]);

	printf("thrust 64-bit:\n");
	PrintResults(thrustThroughputs[1]);
	
	searchDestroy(engine);
}

