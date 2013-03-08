#pragma once

#ifdef WIN32

#ifndef NOMINMAX
#define NOMINMAX
#endif // NOMINMAX

#include <windows.h>
#define SELECTAPI WINAPI
#else
#define SELECTAPI
#endif

#include <cuda.h>

#ifdef __cplusplus
extern "C" {
#endif

typedef enum {
	SELECT_STATUS_SUCCESS,
	SELECT_STATUS_NOT_INITIALIZED,
	SELECT_STATUS_DEVICE_ALLOC_FAILED,
	SELECT_STATUS_INVALID_CONTEXT,
	SELECT_STATUS_KERNEL_NOT_FOUND,
	SELECT_STATUS_KERNEL_ERROR,
	SELECT_STATUS_LAUNCH_ERROR,
	SELECT_STATUS_INVALID_VALUE,
	SELECT_STATUS_DEVICE_ERROR,
	SELECT_STATUS_NOT_IMPLEMENTED,
	SELECT_STATUS_UNSUPPORTED_DEVICE
} selectStatus_t;

typedef enum {
	SELECT_TYPE_UINT,
	SELECT_TYPE_INT,
	SELECT_TYPE_FLOAT
} selectType_t;

typedef enum {
	SELECT_CONTENT_KEYS, 
	SELECT_CONTENT_PAIRS,
	SELECT_CONTENT_INDICES
} selectContent_t;

typedef struct {
	CUdeviceptr keys;			// Keys to select.
	CUdeviceptr values;			// Values to copy.
	int count;					// Size of the source array.
	int bit;					// The least significant key bit.
	int numBits;				// Total number of key bits.
	selectType_t type;			// The type of the key.
	selectContent_t content;	// The content to copy.
} selectData_t;

// Returns a textual representation of the enums.
const char* SELECTAPI selectStatusString(selectStatus_t status);


////////////////////////////////////////////////////////////////////////////////
// MGPU SELECT FUNCTIONS

// Create the select engine on the CUDA device API context
struct selectEngine_d;
typedef struct selectEngine_d* selectEngine_t;

// Create the engine and attach to the current context.
selectStatus_t SELECTAPI selectCreateEngine(const char* kernelPath,
	selectEngine_t* engine);

selectStatus_t SELECTAPI selectDestroyEngine(selectEngine_t engine);

// Retrieve the size of device memory cache and reset it. 
selectStatus_t SELECTAPI selectCacheSize(selectEngine_t engine, size_t* size);
selectStatus_t SELECTAPI selectResetCache(selectEngine_t engine);

// Returns the k'th-smallest value.
selectStatus_t SELECTAPI selectItem(selectEngine_t engine, selectData_t data,
	int k, void* key, void* value);

// Returns a list of k-smallest values. This function performs best if the count
// of items is small or if they are clustered together. Consider using a sort
// for complicated queries.
selectStatus_t SELECTAPI selectList(selectEngine_t engine, selectData_t data,
	const int* k, int count, void* keys, void* values);

// Select an interval. k1 is the first value selected and k2 is one past the 
// last value selected. The caller must provide device memory large enough to
// hold the returned interval.
selectStatus_t SELECTAPI selectInterval(selectEngine_t engine, 
	selectData_t data, int k1, int k2, CUdeviceptr keys, CUdeviceptr values);


#ifdef __cplusplus
} // extern "C"
#endif

