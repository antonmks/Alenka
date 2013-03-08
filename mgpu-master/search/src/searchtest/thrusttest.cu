#include "searchtest.h"
#include <thrust/device_ptr.h>
#include <thrust/binary_search.h>


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

template double ThrustBenchmark(int count, CuDeviceMem* values,
	int numIterations, int numQueries, CuDeviceMem* keys, CuDeviceMem* indices, 
	const int* valuesHost, const int* keysHost);

template double ThrustBenchmark(int count, CuDeviceMem* values,
	int numIterations, int numQueries, CuDeviceMem* keys, CuDeviceMem* indices, 
	const int64* valuesHost, const int64* keysHost);
