#pragma once

#ifdef _WIN32
#ifndef NOMINMAX
	#define NOMINMAX
#endif
#include <windows.h>
#define SCANAPI WINAPI
#else
#define SCANAPI
#endif

#include <cuda.h>

struct scanEngine_d;
typedef struct scanEngine_d* scanEngine_t;

typedef enum {
	SCAN_STATUS_SUCCESS = 0,
	SCAN_STATUS_NOT_INITIALIZED,
	SCAN_STATUS_DEVICE_ALLOC_FAILED,
	SCAN_STATUS_INVALID_CONTEXT,
	SCAN_STATUS_KERNEL_NOT_FOUND,
	SCAN_STATUS_KERNEL_ERROR,
	SCAN_STATUS_LAUNCH_ERROR,
	SCAN_STATUS_INVALID_VALUE,
	SCAN_STATUS_DEVICE_ERROR,
	SCAN_STATUS_UNSUPPORTED_DEVICE
} scanStatus_t;

#ifdef __cplusplus
extern "C" {
#endif

const char* SCANAPI scanStatusString(scanStatus_t status);

scanStatus_t SCANAPI scanCreateEngine(const char* cubin, scanEngine_t* engine);
scanStatus_t SCANAPI scanDestroyEngine(scanEngine_t engine);

scanStatus_t SCANAPI scanArray(scanEngine_t engine, CUdeviceptr values,
	CUdeviceptr scan, int count, unsigned int* scanTotal, bool inclusive);

scanStatus_t SCANAPI scanSegmentedPacked(scanEngine_t engine,
	CUdeviceptr packed, CUdeviceptr scan, int count, bool inclusive);

scanStatus_t SCANAPI scanSegmentedFlags(scanEngine_t engine, CUdeviceptr values,
	CUdeviceptr flags, CUdeviceptr scan, int count, bool inclusive);

scanStatus_t SCANAPI scanSegmentedKeys(scanEngine_t engine, CUdeviceptr values,
	CUdeviceptr keys, CUdeviceptr scan, int count, bool inclusive);


#ifdef __cplusplus
} // extern "C"
#endif
