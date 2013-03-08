#pragma once

#ifdef WIN32

#ifndef NOMINMAX
#define NOMINMAX
#endif // NOMINMAX

#include <windows.h>
#define SORTAPI WINAPI
#else
#define SORTAPI
#endif

#include <cuda.h>

#ifdef __cplusplus
extern "C" {
#endif

typedef enum {
	SORT_STATUS_SUCCESS = 0,
	SORT_STATUS_NOT_INITIALIZED,
	SORT_STATUS_DEVICE_ALLOC_FAILED,
	SORT_STATUS_HOST_ALLOC_FAILED,
	SORT_STATUS_CONFIG_NOT_SUPPORTED,
	SORT_STATUS_CONTEXT_MISMATCH,
	SORT_STATUS_INVALID_CONTEXT,
	SORT_STATUS_KERNEL_NOT_FOUND,
	SORT_STATUS_KERNEL_ERROR,
	SORT_STATUS_LAUNCH_ERROR,
	SORT_STATUS_INVALID_VALUE,
	SORT_STATUS_DEVICE_ERROR,
	SORT_STATUS_INTERNAL_ERROR,
	SORT_STATUS_UNSUPPORTED_DEVICE
} sortStatus_t;

// Returns a textual representation of the enums.
const char* SORTAPI sortStatusString(sortStatus_t status);


////////////////////////////////////////////////////////////////////////////////
// MGPU SORT FUNCTIONS

// Create the sort engine on the CUDA device API context
struct sortEngine_d;
typedef struct sortEngine_d* sortEngine_t;

// Create the engine and attach to the current context.
sortStatus_t SORTAPI sortCreateEngine(const char* kernelPath,
	sortEngine_t* engine);

// Pass -1 for numValues to preload both the index and single value kernel.
sortStatus_t SORTAPI sortLoadKernel(sortEngine_t engine, int numSortThreads,
	int valuesPerThread, bool useTransList, int valueCount);

// Incs and decs the engine's reference counter.
sortStatus_t SORTAPI sortIncEngine(sortEngine_t engine);
sortStatus_t SORTAPI sortReleaseEngine(sortEngine_t engine);

// sortData_d can be created by the user, or allocated (and deallocated) by the
// mgpusort library.
typedef struct {
	// Total capacity of the allocated sort buffers.
	int maxElements;

	// Number of values to sort
	int numElements;
	
	// Number of de-interleaved value arrays. To emit indices on to values1 on
	// the first pass, set valueCount to -1. This is useful when externally
	// sorting larger values. Subsequent passes will sort the index as the first
	// value.
	int valueCount;

	// First bit and end bit to sort
	int firstBit;
	int endBit;

	// The sort library sets the keys after numElements in the last sort block
	// (up to 2048 elements in size) to -1 to accelerate the sort kernel. If the
	// caller wants to preserve those keys, it must set this parameter to true.
	bool preserveEndKeys;

	// Look for early exit conditions. The count kernel will check if each sort
	// block has sorted radices, and if the entire array is already	sorted in
	// the current radix or over the full key. If earlyExit is true, and no 
	// blocks around found sorted, the standard sort kernel is the used. 
	// earlyExit on a randomized arrays slows sort performance by 2.5%.
	bool earlyExit;

	// Sort the keys and up to 6 de-interleaved arrays.
	// The [0] arrays are ource, and the [1] arrays are targets. After the sort
	// has been completed, arrays will be swapped if necessary so that [0] hold
	// the sorted values, and [1] are temporaries that me be re-used.

	// If the caller provides a source array but not its alternate companion,
	// it should be prepared to give up ownership if sortDestroyData is called,
	// as that function will cuMemFree both arrays. If the caller wants to 
	// retain ownership over its array, it must zero out the appropriate device
	// pointer before calling sortDestroyData. Note that because arrays are
	// ping-ponged, the array that the caller set to keys[0] may be swapped to
	// keys[1] after a sort, and it should compare pointer values before 
	// clearing the pointer corresponding to its own allocated device memory
	// array.

	// The arrays are exchanged with every sort pass. parity indicates where the
	// device pointers were when the sort stared. An array at [0] ends up at 
	// [parity] after the sort.
	int parity;

	union {
		// The driver API prefers device pointers cast as CUdeviceptr.
		struct {
			CUdeviceptr keys[2];

			union {
				struct {
					CUdeviceptr values1[2];
					CUdeviceptr values2[2];
					CUdeviceptr values3[2];
					CUdeviceptr values4[2];
					CUdeviceptr values5[2];
					CUdeviceptr values6[2];
				};
				CUdeviceptr values[6][2];
			};
		};

		// The runtime API prefers device pointers cast as uint*.
		struct {
			unsigned int* pKeys[2];

			union {
				struct {
					unsigned int* pValues1[2];
					unsigned int* pValues2[2];
					unsigned int* pValues3[2];
					unsigned int* pValues4[2];
					unsigned int* pValues5[2];
					unsigned int* pValues6[2];
				};
				unsigned int* pValues[6][2];
			};
		};
	};
} sortData_d;
typedef sortData_d* sortData_t;

// These functions deal with library-managed sort data.

// Let the sort library allocate sortData_d and all of its arrays.
// sortDestroyData frees all device memory and destroys the underlying 
// sortData_d structure.
sortStatus_t SORTAPI sortCreateData(sortEngine_t engine, int maxElements,
	int valueCount, sortData_t* data);
sortStatus_t SORTAPI sortDestroyData(sortData_t data);

// The sort library allocates an unallocated arrays, according to the
// parameters set in the incoming data structure. 
// sortFreeData frees all device memory but does not destory the underlying
// sortData_d sturcture. Set maxElements for sortAllocData to specify the number
// of elements in the device arrays to be allocated.
sortStatus_t SORTAPI sortAllocData(sortEngine_t engine, sortData_t data);
sortStatus_t SORTAPI sortFreeData(sortData_d* data);

sortStatus_t SORTAPI sortArray(sortEngine_t engine, sortData_t data);

sortStatus_t SORTAPI sortArrayEx(sortEngine_t engine, sortData_t data,
	int numSortThreads, int valuesPerThread, int bitPass, bool useTransList);


// sortHost and sortDevice are convenience functions. They will not achieve the
// same high when sharing sortData_t between multiple sorts. sortHost and 
// sortDevice are wrappers for sortAllocData and sortArray; they do not 
// implement special logic.

// To use sortDevice correctly, the keys and values device memory pointers must
// be segment aligned (128 bytes) and rounded up in size to a 2048 byte 
// boundary from the start. If either of these conditions are false, first copy
// to a temp device array.

sortStatus_t SORTAPI sortHost(sortEngine_t engine, unsigned int* keys,
	unsigned int* values, int numElements, int numBits);

sortStatus_t SORTAPI sortDevice(sortEngine_t engine, CUdeviceptr keys,
	CUdeviceptr values, int numElements, int numBits);


#ifdef __cplusplus
} // extern "C"
#endif

