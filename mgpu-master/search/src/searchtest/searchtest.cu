#include "../../../inc/mgpusearch.h"
#include "../../../util/cucpp.h"
#include <vector>
#include <algorithm>
#include <thrust/device_ptr.h>
#include <thrust/binary_search.h>

#ifdef _MSC_VER
#include <random>
#else
#include <tr1/random>
#endif

typedef __int64 int64;

// Define all the permutations for benchmarking. The actual iterations taken
// for each array size/query size pair is the product of their second counts.

const int NumArraySizes = 10;
const int ArraySizes[NumArraySizes][2] = {
	{ 50000, 3000 },		
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

const int NumQuerySizes = 5;
const int MaxQuerySize = 1000000;
const int QuerySizes[5][2] = {
	{ 1000, 10 },
	{ 10000, 3 },
	{ 100000, 1 },
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
// Benchmark thrust


template<typename T>
double ThrustBenchmark(int count, CuDeviceMem* values, int numIterations,
	int numQueries,	CuDeviceMem* keys, CuDeviceMem* indices, 
	const T* valuesHost, const T* keysHost) {

	CuEventTimer timer;
	timer.Start();

	int offset = 0;
	for(int it(0); it < numIterations; ++it) {
		offset += RoundUp(numQueries, 32);
		if(offset + numQueries > MaxQuerySize) offset = 0;

		typedef thrust::device_ptr<T> P;
		P valuesP = P((T*)values->Handle());
		P keysP = P(((T*)keys->Handle()) + offset);
		
		thrust::device_ptr<uint> outputP((uint*)indices->Handle());
		thrust::lower_bound(
			valuesP, valuesP + count,
			keysP, keysP + numQueries,
			outputP);
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
			printf("Failure in thrust Search.\n");
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
		}
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

	for(int s(6); s < NumArraySizes; ++s) {

		// 32-bit
		printf("32-bit key search:\n");
		BenchmarkLoop<int>(context, engine, ArraySizes[s][0], ArraySizes[s][1],
			mgpuThroughputs[0][s], thrustThroughputs[0][s]);

		// 64-bit
		printf("64-bit key search:\n");
		BenchmarkLoop<int64>(context, engine, ArraySizes[s][0], 
			ArraySizes[s][1], mgpuThroughputs[1][s], thrustThroughputs[1][s]);
	}



	searchDestroy(engine);
}

/*

int main(int argc, char** argv) {

	typedef int64 T;
	searchType_t type = SEARCH_TYPE_INT64;

	cuInit(0);

	DevicePtr device;
	CreateCuDevice(0, &device);

	ContextPtr context;
	CreateCuContext(device, 0, &context);

	searchEngine_t engine = 0;
	searchStatus_t status = searchCreate("../../src/cubin/search.cubin",
		&engine);

	std::vector<T> values;
	FillVec(values, NumElements);

	DeviceMemPtr deviceData, deviceTree, deviceResults;
	context->MemAlloc(values, &deviceData);

	int treeSize = searchTreeSize(NumElements, type);

	context->ByteAlloc(treeSize, &deviceTree);

	status = searchBuildTree(engine, NumElements, type, 
		deviceData->Handle(), deviceTree->Handle());

	T last = values.back();

	// SEARCH
	const int NumQueries = 10000;
	T keys[NumQueries];
	for(int i(0); i < NumQueries; ++i) {
		float delta = (float)last / NumQueries;
		keys[i] = (int)(delta / 2 + i * delta);
	}
//	keys[NumQueries - 1] = 1000000;

	DeviceMemPtr keysDevice, indicesDevice;
	context->MemAlloc(keys, NumQueries, &keysDevice);
	context->MemAlloc<uint>(NumQueries, &indicesDevice);
	status = searchKeys(engine, NumElements, type, 
		deviceData->Handle(), SEARCH_ALGO_UPPER_BOUND, keysDevice->Handle(),
		NumQueries, deviceTree->Handle(), indicesDevice->Handle());

	std::vector<int> indicesHost;
	indicesDevice->ToHost(indicesHost);

	for(int i(0); i < NumQueries; ++i) {
		int j = indicesHost[i];
	//	printf("%I64d %d: (%I64d, %I64d)\n", keys[i], j, values[j - 1], values[j]);
		printf("%d\n", j);
	}

	searchDestroy(engine);
}*/

/*
struct BTreeCPU {
	int count;
	std::vector<int> data;	

	// Support up to 6 btree levels.
	int numLevels;
	int levelCounts[6];
	std::vector<int> levelData[6];
};

void CreateBTreeCPU(std::vector<int>& data, int count,
	std::auto_ptr<BTreeCPU>* ppTree) {

	std::auto_ptr<BTreeCPU> tree(new BTreeCPU);
	tree->numLevels = 0;
	tree->count = count;
	tree->data.swap(data);

	const int SEG_SIZE = 32;

	int level = 0;
	while(count > SEG_SIZE) {
		// Divide by 32 to get the size of the next btree level.
		int count2 = (count + SEG_SIZE - 1) / SEG_SIZE;

		// Round up to a multiple of 32 to make indexing simpler.
		int newCount = ~(SEG_SIZE - 1) & (count2 + SEG_SIZE - 1);
		tree->levelData[level].resize(newCount);

		// Prepare the subsampling.
		const int* source = level ? &tree->levelData[level - 1][0] :
			&tree->data[0];

		for(int i(0); i < newCount; ++i) {
			int j = std::min(SEG_SIZE * i + SEG_SIZE - 1, count - 1);
			tree->levelData[level][i] = source[j];
		}

		// Store the level count.
		tree->levelCounts[level++] = newCount;
		count = newCount;
	}
	tree->numLevels = level;

	// Swap the levels to put them in order.
	for(int i(0); i < level / 2; ++i) {
		tree->levelData[i].swap(tree->levelData[level - 1 - i]);
		std::swap(tree->levelCounts[i], tree->levelCounts[level - 1 - i]);
	}

	*ppTree = tree;
}*/









/*
searchStatus_t SEARCHAPI searchKeys(searchEngine_t engine, int count,
	searchType_t type, CUdeviceptr data, searchAlgo_t algo, CUdeviceptr keys, 
	int numQueries, CUdeviceptr tree, CUdeviceptr results) {
*/
/*
#include <cstdio>
#include <vector>
#include <memory>
#include <algorithm>
#include <random>

std::tr1::mt19937 mt19937;

// Build 

const int SEG_SIZE = 32;

struct BTree {
	int count;
	std::vector<int> data;	

	// Support up to 6 btree levels.
	int numLevels;
	int levelCounts[6];
	std::vector<int> levelData[6];
};

void CreateBTree(std::vector<int>& data, int count,
	std::auto_ptr<BTree>* ppTree) {

	std::auto_ptr<BTree> tree(new BTree);
	tree->numLevels = 0;
	tree->count = count;
	tree->data.swap(data);

	int level = 0;
	while(count > SEG_SIZE) {
		// Divide by 32 to get the size of the next btree level.
		int count2 = (count + SEG_SIZE - 1) / SEG_SIZE;

		// Round up to a multiple of 32 to make indexing simpler.
		int newCount = ~(SEG_SIZE - 1) & (count2 + SEG_SIZE - 1);
		tree->levelData[level].resize(newCount);

		// Prepare the subsampling.
		const int* source = level ? &tree->levelData[level - 1][0] :
			&tree->data[0];

		for(int i(0); i < newCount; ++i) {
			int j = std::min(SEG_SIZE * i + SEG_SIZE - 1, count - 1);
			tree->levelData[level][i] = source[j];
		}

		// Store the level count.
		tree->levelCounts[level++] = newCount;
		count = newCount;
	}
	tree->numLevels = level;

	// Swap the levels to put them in order.
	for(int i(0); i < level / 2; ++i) {
		tree->levelData[i].swap(tree->levelData[level - 1 - i]);
		std::swap(tree->levelCounts[i], tree->levelCounts[level - 1 - i]);
	}

	*ppTree = tree;
}

int GetOffset(int key, const int* node) {
	for(int i(0); i < SEG_SIZE; ++i)
		if(node[i] >= key) return i;
	return SEG_SIZE;
}
int GetOffset2(int key, const int* node, int offset, int count) {
	int end = std::min(offset + SEG_SIZE, count);
	for(int i(offset); i < end; ++i)
		if(node[i] >= key) return i;
	return end;
}

int lower_bound(const BTree& tree, int key) {
	int numLevels = tree.numLevels;
	int offset = 0;
	for(int level(0); level < numLevels; ++level) {
		int o2 = GetOffset(key, &tree.levelData[level][offset]);
		offset = SEG_SIZE * (offset + o2);
	}
	offset = GetOffset2(key, &tree.data[0], offset, tree.count);
	return offset;	
}

int main(int argc, char** argv) {
	const int NumElements = 20000;
	std::tr1::uniform_int<int> r(0, 32767);

	std::vector<int> data(NumElements);
	for(int i(0); i < NumElements; ++i)
		data[i] = r(mt19937);
	std::sort(data.begin(), data.end());

	std::auto_ptr<BTree> tree;
	CreateBTree(data, NumElements, &tree);

	int offset = lower_bound(*tree, 32700);

	return 0;
}
*/