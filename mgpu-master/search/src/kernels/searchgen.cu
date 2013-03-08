#include <stdint.h>

#define DEVICE extern "C" __device__ __forceinline__
#define DEVICE2 __device__ __forceinline__

#define WARP_SIZE 32
#define LOG_WARP_SIZE 5

// Size of a memory segment
#define SEG_SIZE 128

#define SearchTypeLower 0
#define SearchTypeUpper 1
#define SearchTypeRange 2

// NOTE: SEG_LANES_32_BIT may be set to 32 bits for better performance if the
// alu:mem ratio can be brought down. SEG_LANES_64_BIT should not however be
// increased.
#define SEG_LANES_32_BIT 16
#define SEG_LANES_64_BIT 16

#define MAX_LEVELS 8


typedef unsigned int uint;
#ifdef _WIN64
typedef __int64 int64_t;
typedef unsigned __int64 uint64_t;
#endif


#include <device_functions.h>
#include <vector_functions.h>

// insert the first numBits of y into x starting at bit
DEVICE uint bfi(uint x, uint y, uint bit, uint numBits) {
	uint ret;
	asm("bfi.b32 %0, %1, %2, %3, %4;" : 
		"=r"(ret) : "r"(y), "r"(x), "r"(bit), "r"(numBits));
	return ret;
}


#include "buildtree.cu"

#include "searchtree.cu"
