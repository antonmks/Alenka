#pragma once

#ifdef WIN32

#ifndef NOMINMAX
#define NOMINMAX
#endif // NOMINMAX

#include <windows.h>
#define SEARCHAPI WINAPI

#else	// !defined(WIN32)

#define SEARCHAPI

#endif // WIN32

#include <cuda.h>

#ifdef __cplusplus
extern "C" {
#endif


typedef enum {
	SEARCH_STATUS_SUCCESS = 0,
	SEARCH_STATUS_NOT_INITIALIZED,
	SEARCH_STATUS_DEVICE_ALLOC_FAILED, 
	SEARCH_STATUS_HOST_ALLOC_FAILED,
	SEARCH_STATUS_CONFIG_NOT_SUPORTED,
	SEARCH_STATUS_INVALID_CONTEXT,
	SEARCH_STATUS_KERNEL_NOT_FOUND,
	SEARCH_STATUS_KERNEL_ERROR,
	SEARCH_STATUS_LAUNCH_ERROR,
	SEARCH_STATUS_INVALID_VALUE,
	SEARCH_STATUS_DEVICE_ERROR,
	SEARCH_STATUS_INTERNAL_ERROR,
	SCAN_STATUS_UNSUPPORTED_DEVICE
} searchStatus_t;

const char* SEARCHAPI searchStatusString(searchStatus_t status);

typedef enum {
	// 32 bit types
	SEARCH_TYPE_INT32 = 0,
	SEARCH_TYPE_UINT32,
	SEARCH_TYPE_FLOAT,

	// 64 bit types
	SEARCH_TYPE_INT64,
	SEARCH_TYPE_UINT64,
	SEARCH_TYPE_DOUBLE
} searchType_t;

typedef enum {
	SEARCH_ALGO_LOWER_BOUND = 0,
	SEARCH_ALGO_UPPER_BOUND,
	SEARCH_ALGO_BINARY_SEARCH
} searchAlgo_t;

int SEARCHAPI searchTreeSize(int count, searchType_t type);

struct searchEngine_d;
typedef searchEngine_d* searchEngine_t;

searchStatus_t SEARCHAPI searchCreate(const char* kernelPath,
	searchEngine_t* engine);

searchStatus_t SEARCHAPI searchDestroy(searchEngine_t engine);

searchStatus_t SEARCHAPI searchBuildTree(searchEngine_t engine, int count, 
	searchType_t type, CUdeviceptr data, CUdeviceptr tree);

// Runs a lower_bound, upper_bound, or binary_search.
searchStatus_t SEARCHAPI searchKeys(searchEngine_t engine, int count,
	searchType_t type, CUdeviceptr data, searchAlgo_t algo, CUdeviceptr keys, 
	int numQueries, CUdeviceptr tree, CUdeviceptr results);

// Runs an equal_range and returns the ranges as int2 pairs to results.
searchStatus_t SEARCHAPI searchRanges(searchEngine_t engine, int count,
	searchType_t type, CUdeviceptr data, CUdeviceptr keys, int numQueries,
	CUdeviceptr tree, CUdeviceptr results);

#ifdef __cplusplus
}
#endif
