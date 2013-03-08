#pragma once
#pragma once

#ifdef WIN32

#ifndef NOMINMAX
#define NOMINMAX
#endif // NOMINMAX

#include <windows.h>
#define BWTAPI WINAPI
#else
#define BWTAPI
#endif

#include <cuda.h>

#ifdef __cplusplus
extern "C" {
#endif

typedef enum {
	BWT_STATUS_SUCCESS,
	BWT_STATUS_NOT_INITIALIZED,
	BWT_STATUS_DEVICE_ALLOC_FAILED,
	BWT_STATUS_INVALID_CONTEXT,
	BWT_STATUS_KERNEL_NOT_FOUND,
	BWT_STATUS_KERNEL_ERROR,
	BWT_STATUS_LAUNCH_ERROR,
	BWT_STATUS_INVALID_VALUE,
	BWT_STATUS_DEVICE_ERROR,
	BWT_STATUS_NOT_IMPLEMENTED,
	BWT_STATUS_UNSUPPORTED_DEVICE,
	BWT_STATUS_SORT_ERROR
} bwtStatus_t;

// Returns a textual representation of the enums.
const char* BWTAPI bwtStatusString(bwtStatus_t status);


////////////////////////////////////////////////////////////////////////////////
// MGPU BWT FUNCTIONS

// Create the bwt engine on the CUDA device API context
struct bwtEngine_d;
typedef struct bwtEngine_d* bwtEngine_t;

// Create the engine and attach to the current context. The kernelPath must be
// a directory containing both the MGPU Sort .cubins and bwt.cubin.
bwtStatus_t BWTAPI bwtCreateEngine(const char* kernelPath,
	bwtEngine_t* engine);

bwtStatus_t BWTAPI bwtDestroyEngine(bwtEngine_t engine);


// bwtSortBlock runs a BWT sort on count bytes from the array block. gpuKeySize
// must be between 1 and 24, and indicates the number of symbols (bytes) to push
// through the GPU radix sort. A smaller key sorts quicker, but leaves more 
// cleanup for the CPU. Multiples of 4 are somewhat more efficient.

// transform (optional) is a byte array with count elements. It is the BWT
// permutation of the block data. transform may point to the same data as block.

// indices (optional) specifies the indices from the original block bytes from
// which to gather symbols. This is provided for text-processing or diagnostic
// purposes.

// segCount and avSegSize (optional) are counters for parameters for diagnostic
// and tuning. segCount is the total number of segments after the GPU sort with
// multiple elements - these are handled by the much slower CPU quicksort.
// avSegSize gives the average size of each segment (>= 2). Running time for the
// CPU quicksort is estimated on the order of segCount * log(avSegSize).

bwtStatus_t BWTAPI bwtSortBlock(bwtEngine_t engine, const void* block, 
	int count, int gpuKeySize, void* transform, int* indices, int* segCount,
	float* avSegSize);



#ifdef __cplusplus
} // extern "C"
#endif

