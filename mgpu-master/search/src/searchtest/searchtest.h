#pragma once

#include <vector>
#include <algorithm>
#include "../../../util/cucpp.h"


typedef __int64 int64;


const int MaxQuerySize = 100000;

template<typename T>
double ThrustBenchmark(int count, CuDeviceMem* values, int numIterations,
	int numQueries,	CuDeviceMem* keys, CuDeviceMem* indices, 
	const T* valuesHost, const T* keysHost);
