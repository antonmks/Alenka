#pragma once

#ifdef WIN32

#ifndef NOMINMAX
#define NOMINMAX
#endif // NOMINMAX

#include <windows.h>
#define SPARSEAPI WINAPI

#else	// !defined(WIN32)

#define SPARSEAPI

#endif // WIN32

#include <cuda.h>

#ifdef __cplusplus
#include <complex>
extern "C" {
#endif

typedef enum {
	SPARSE_STATUS_SUCCESS = 0,
	SPARSE_STATUS_NOT_INITIALIZED,
	SPARSE_STATUS_DEVICE_ALLOC_FAILED,
	SPARSE_STATUS_HOST_ALLOC_FAILED,
	SPARSE_STATUS_PREC_MISMATCH,
	SPARSE_STATUS_CONFIG_NOT_SUPPORTED,
	SPARSE_STATUS_CONTEXT_MISMATCH,
	SPARSE_STATUS_INVALID_CONTEXT,
	SPARSE_STATUS_NOT_SORTED,
	SPARSE_STATUS_KERNEL_NOT_FOUND,
	SPARSE_STATUS_KERNEL_ERROR,
	SPARSE_STATUS_LAUNCH_ERROR,
	SPARSE_STATUS_INVALID_VALUE,
	SPARSE_STATUS_DEVICE_ERROR,
	SPARSE_STATUS_INTERNAL_ERROR
} sparseStatus_t;

const char* SPARSEAPI sparseStatusString(sparseStatus_t status);


typedef enum {
	SPARSE_PREC_REAL4 = 0,
	SPARSE_PREC_REAL8,
	SPARSE_PREC_COMPLEX4,
	SPARSE_PREC_COMPLEX8
} sparsePrec_t;

typedef enum {
	SPARSE_INPUT_COO = 0,
	SPARSE_INPUT_CSR
} sparseInput_t;


// If using a C++ compiler, break out of the extern "C" to define some
// templates.
#ifdef __cplusplus
} 

typedef std::complex<float> sparseComplex4_t;
typedef std::complex<double> sparseComplex8_t;

template<typename T>
struct sparseMatElementCOO_t {
	T value;
	int row, col;

	// Define operator on sparseMatElementCOO_t to allow sorts by ascending
	// row.
	bool operator<(const sparseMatElementCOO_t& rhs) const {
		if(row < rhs.row) return true;
		if(row > rhs.row) return false;
		return col < rhs.col;
	}
	bool operator==(const sparseMatElementCOO_t& rhs) const {
		return value == rhs.value && row == rhs.row && col == rhs.col;
	}
	bool operator!=(const sparseMatElementCOO_t& rhs) const {
		return value != rhs.value || row != rhs.row || col != rhs.col;
	}

	// Comparison function compatible with qsort. std::sort is painfully slow
	// in debug mode, so use qsort then.
	static int Cmp(const void* left, const void* right) {
		const sparseMatElementCOO_t* a = (const sparseMatElementCOO_t*)left;
		const sparseMatElementCOO_t* b = (const sparseMatElementCOO_t*)right;
		if(a->row < b->row) return -1;
		if(a->row > b->row) return 1;
		if(a->col < b->col) return -1;
		if(a->col > b->col) return 1;
		return 0;
	}
};
template<typename T>
struct sparseMatElementCSR_t {
	T value;
	int col;
};


typedef sparseMatElementCOO_t<float> sparseMatElementReal4COO_t;
typedef sparseMatElementCOO_t<double> sparseMatElementReal8COO_t;
typedef sparseMatElementCOO_t<sparseComplex4_t> sparseMatElementComplex4COO_t;
typedef sparseMatElementCOO_t<sparseComplex8_t> sparseMatElementDouble8COO_t;

typedef sparseMatElementCSR_t<float> sparseMatElementReal4CSR_t;
typedef sparseMatElementCSR_t<double> sparseMatElementReal8CSR_t;
typedef sparseMatElementCSR_t<sparseComplex4_t> sparseMatElementComplex4CSR_t;
typedef sparseMatElementCSR_t<sparseComplex8_t> sparseMatElementDouble8CSR_t;

extern "C" {
	// If not C++, define structs for our types.

#else	// !defined(__cplusplus) 

typedef struct {
	float real, imag;
} sparseComplex4_t;

typedef struct {
	double real, imag;
} sparseComplex8_t;

typedef struct {
	float value;
	int row, col;
} sparseMatElementReal4COO_t;
typedef struct {
	float value;
	int col;
} sparseMatElementReal4CSR_t;
typedef struct {
	double value;
	int row, col;
} sparseMatElementReal8COO_t;
typedef struct {
	double value;
	int col;
} sparseMatElementReal8CSR_t;
typedef struct {
	sparseComplex4_t value;
	int row, col;
} sparseMatElementComplex4COO_t;
typedef struct {
	sparseComplex4_t value;
	int col;
} sparseMatElementComplex4CSR_t;
typedef struct {
	sparseComplex8_t value;
	int row, col;
} sparseMatElementComplex8COO_t;
typedef struct {
	sparseComplex8_t value;
	int col;
} sparseMatElementComplex8CSR_t;

#endif		// defined(__cplusplus)

	
struct sparseEngine_d;
typedef sparseEngine_d* sparseEngine_t;

typedef struct {
	int height;
	int width;
	sparsePrec_t prec;
	
	int valuesPerThread;
	int numGroups;
	int packedSizeShift;

	// size of tempOutput array
	int outputSize;

	// number of elements in original file
	int nz;	

	// number of elements in this encoding
	int nz2;

	// footprint of device memory
	int storage;

}  sparseMat_d;
typedef sparseMat_d* sparseMat_t;

// Create the engine and attach to the current context.
sparseStatus_t SPARSEAPI sparseCreate(const char* kernelPath,
	sparseEngine_t* engine);

// Increment the sparseEngine_t ref count
sparseStatus_t SPARSEAPI sparseInc(sparseEngine_t engine);

// Decrement the sparseEngine_t ref count
sparseStatus_t SPARSEAPI sparseRelease(sparseEngine_t engine);

// Check if the requested kernel is loaded
sparseStatus_t SPARSEAPI sparseQuerySupport(sparseEngine_t engine,
	sparsePrec_t prec);


///////////////////////////////////////////////////////////////////////////////
// sparseMatrix creation

// Pass in -1 for valuesPerThread to start building sections at the mean and
// work down until 

// Sparse value, column, and row data are deinterleaved. Passed in COO 
// (preferred) or CSR.
sparseStatus_t SPARSEAPI sparseMatCreate(sparseEngine_t engine, 
	int height, int width, sparsePrec_t prec, int valuesPerThread, 
	sparseInput_t input, int numElements, const void* sparse,
	const int* row, const int* col, sparseMat_t* matrix);

// Data must be passed in as row-sorted COO.
sparseStatus_t SPARSEAPI sparseMatCreateGPU(sparseEngine_t engine,
	int height, int width, sparsePrec_t prec, int valuesPerThread, 
	int numElements, CUdeviceptr row, CUdeviceptr col, CUdeviceptr val,
	sparseMat_t* matrix);

sparseStatus_t SPARSEAPI sparseMatDestroy(sparseMat_t matrix);

// Retrieves the engine that created the matrix and incs its ref count
sparseStatus_t SPARSEAPI sparseMatEngine(sparseMat_t matrix,
	sparseEngine_t* engine);

// y = alpha * matrix * x + beta * y
// If beta is 0 and alpha is 1, an optimized version is used.
// for synchronous usage, pass 0 for stream
sparseStatus_t SPARSEAPI sparseMatVecSMul(sparseEngine_t engine, float alpha,
	sparseMat_t matrix, CUdeviceptr x, float beta, CUdeviceptr y);
sparseStatus_t SPARSEAPI sparseMatVecDMul(sparseEngine_t engine, double alpha,
	sparseMat_t matrix, CUdeviceptr x, double beta, CUdeviceptr y);
sparseStatus_t SPARSEAPI sparseMatVecCMul(sparseEngine_t engine,
	sparseComplex4_t alpha, sparseMat_t matrix, CUdeviceptr x, 
	sparseComplex4_t beta, CUdeviceptr y);
sparseStatus_t SPARSEAPI sparseMatVecZMul(sparseEngine_t engine,
	sparseComplex8_t alpha, sparseMat_t matrix, CUdeviceptr x, 
	sparseComplex8_t beta, CUdeviceptr y);

#ifdef __cplusplus
} // extern "C"
#endif
