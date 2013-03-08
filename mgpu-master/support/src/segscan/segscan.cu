// Demonstration of segmented scan. 
// See http://www.moderngpu.com/sparse/segscan.html

#define WARP_SIZE 32
#define LOG_WARP_SIZE 5

#define NUM_THREADS 256
#define NUM_WARPS 8
#define LOG_NUM_WARPS 3

#define VALUES_PER_THREAD 8
#define VALUES_PER_WARP (WARP_SIZE * VALUES_PER_THREAD)

#define DEVICE extern "C" __device__ __forceinline__

#include <device_functions.h>

typedef unsigned int uint;

DEVICE uint bfi(uint x, uint y, uint bit, uint numBits) {
	uint ret;
	asm("bfi.b32 %0, %1, %2, %3, %4;" : 
		"=r"(ret) : "r"(y), "r"(x), "r"(bit), "r"(numBits));
	return ret;
}


////////////////////////////////////////////////////////////////////////////////
// Use ballot and clz to run a segmented scan over a single warp, with one value
// per thread.

extern "C" __global__ void SegScanWarp(const uint* dataIn_global,
	uint* dataOut_global) {

	uint tid = threadIdx.x;
	uint packed = dataIn_global[tid];

	// The start flag is in the high bit.
	uint flag = 0x80000000 & packed;

	// Get the start flags for each thread in the warp.
	uint flags = __ballot(flag);

	// Mask out the bits above the current thread.
	flags &= bfi(0, 0xffffffff, 0, tid + 1);

	// Find the distance from the current thread to the thread at the start of
	// the segment.
	uint distance =  __clz(flags) + tid - 31;

	__shared__ volatile uint shared[WARP_SIZE];

	uint x = 0x7fffffff & packed;
	uint x2 = x;
	shared[tid] = x;

	// Perform the parallel scan. Note the conditional if(offset < distance)
	// replaces the ordinary scan conditional if(offset <= tid).
	#pragma unroll
	for(int i = 0; i < LOG_WARP_SIZE; ++i) {
		uint offset = 1<< i;
		if(offset <= distance) x += shared[tid - offset];
		shared[tid] = x;
	}

	// Turn inclusive scan into exclusive scan.
	x -= x2;

	dataOut_global[tid] = x;
}


////////////////////////////////////////////////////////////////////////////////
// Use parallel scan to compute the ranges for a segmented scan over a warp with
// eight values per thread.

extern "C" __global__ void SegScanWarp8(const uint* dataIn_global,
	uint* dataOut_global) {

	uint tid = threadIdx.x;
	
	__shared__ volatile uint shared[VALUES_PER_THREAD * (WARP_SIZE + 1)];
	
	// Load packed values from global memory and scatter to shared memory. Use
	// a 33-slot stride between successive values in each thread to set us up
	// for a conflict-free strided order -> thread order transpose.

	#pragma unroll
	for(int i = 0; i < VALUES_PER_THREAD; ++i) {
		uint x = dataIn_global[i * WARP_SIZE + tid];
		shared[i * (WARP_SIZE + 1) + tid] = x;
	}

	uint offset = VALUES_PER_THREAD * tid;
	offset += offset / WARP_SIZE;
	uint packed[VALUES_PER_THREAD];

	#pragma unroll
	for(int i = 0; i < VALUES_PER_THREAD; ++i)
		packed[i] = shared[offset + i];

	////////////////////////////////////////////////////////////////////////////
	// UPSWEEP PASS
	// Run a sequential segmented scan for all values in the packed array. Find
	// the sum of all values in the thread's last segment. Additionally set
	// index to tid if any segments begin in this thread.
	
	uint last = 0;
	uint hasHeadFlag = 0;

	uint scan[VALUES_PER_THREAD];
	uint flags[VALUES_PER_THREAD];

	#pragma unroll
	for(int i = 0; i < VALUES_PER_THREAD; ++i) {
		flags[i] = 0x80000000 & packed[i];
		uint x = 0x7fffffff & packed[i];
		if(flags[i]) last = 0;
		hasHeadFlag |= flags[i];
		scan[i] = last;
		last += x;
	}

	////////////////////////////////////////////////////////////////////////////
	// SEGMENT PASS
	// Run a ballot and clz to find the thread containing the start value for
	// the segment that begins this thread.

	uint warpFlags = __ballot(hasHeadFlag);

	// Mask out the bits at or above the current thread.
	warpFlags &= bfi(0, 0xffffffff, 0, tid);

	// Find the distance from the current thread to the thread at the start of
	// the segment.
	int preceding = 31 - __clz(warpFlags);
	uint distance = tid - preceding;

	////////////////////////////////////////////////////////////////////////////
	// REDUCTION PASS
	// Run a prefix sum scan over last to compute for each thread the sum of all
	// values in the segmented preceding the current thread, up to that point.
	// This is added back into the thread-local exclusive scan for the continued
	// segment in each thread.

	shared[tid] = 0;
	volatile uint* shifted = shared + tid + 1;
	
	shifted[0] = last;
	uint sum = last;
	uint first = shared[1 + preceding];

	#pragma unroll
	for(int i = 0; i < LOG_WARP_SIZE; ++i) {
		uint offset = 1<< i;
		if(distance > offset) sum += shifted[-offset];
		shifted[0] = sum;
	}
	// Subtract last to make exclusive and add first to grab the fragment sum of
	// the preceding thread.
	sum += first - last;

	////////////////////////////////////////////////////////////////////////////
	// DOWNSWEEP PASS
	// Add sum to all the values in the continuing segment (that is, before the
	// first start flag) in this thread.

	#pragma unroll
	for(int i = 0; i < VALUES_PER_THREAD; ++i) {
		if(flags[i]) sum = 0;
		shared[offset + i] = scan[i] + sum;
	}

	// Store the values back to global memory.
	#pragma unroll
	for(int i = 0; i < VALUES_PER_THREAD; ++i) {
		uint x = shared[i * (WARP_SIZE + 1) + tid];
		dataOut_global[i * WARP_SIZE + tid] = x;
	}
}


////////////////////////////////////////////////////////////////////////////////
// Use a multiscan pattern to execute segmented scan over an entire block with
// 8 values per thread.

////////////////////////////////////////////////////////////////////////////////
// INTER-WARP REDUCTION 
// Calculate the length of the last segment in the last lane in each warp.

DEVICE uint BlockScan(uint warp, uint lane, uint last, uint warpFlags, 
	uint mask, volatile uint* shared, volatile uint* threadShared) {

	__shared__ volatile uint blockShared[3 * NUM_WARPS];
	if(WARP_SIZE - 1 == lane) {
		blockShared[NUM_WARPS + warp] = last;
		blockShared[2 * NUM_WARPS + warp] = warpFlags;
	}
	__syncthreads();

	if(lane < NUM_WARPS) {
		// Pull out the sum and flags for each warp.
		volatile uint* s = blockShared + NUM_WARPS + lane;
		uint warpLast = blockShared[NUM_WARPS + lane];
		uint flag = blockShared[2 * NUM_WARPS + lane];
		blockShared[lane] = 0;

		uint blockFlags = __ballot(flag);

		// Mask out the bits at or above the current warp.
		blockFlags &= mask;

		// Find the distance from the current warp to the warp at the start of 
		// this segment.
		int preceding = 31 - __clz(blockFlags);
		uint distance = lane - preceding;

		// INTER-WARP reduction
		uint warpSum = warpLast;
		uint warpFirst = blockShared[NUM_WARPS + preceding];

		#pragma unroll
		for(int i = 0; i < LOG_NUM_WARPS; ++i) {
			uint offset = 1<< i;
			if(distance > offset) warpSum += s[-offset];
			s[0] = warpSum;
		}
		// Subtract warpLast to make exclusive and add first to grab the
		// fragment sum of the preceding warp.
		warpSum += warpFirst - warpLast;

		// Store warpSum back into shared memory. This is added to all the
		// lane sums and those are added into all the threads in the first 
		// segment of each lane.
		blockShared[lane] = warpSum;
	}
	__syncthreads();

	return blockShared[warp];
}


extern "C" __global__ __launch_bounds__(NUM_THREADS, 4) 
void SegScanBlock8(const uint* dataIn_global, uint* dataOut_global) {

	uint tid = threadIdx.x;
	uint lane = (WARP_SIZE - 1) & tid;
	uint warp = tid / WARP_SIZE;
	
	const int Size = NUM_WARPS * VALUES_PER_THREAD * (WARP_SIZE + 1);
	__shared__ volatile uint shared[Size];

	// Use a stride of 33 slots per warp per value to allow conflict-free
	// transposes from strided to thread order.
	volatile uint* warpShared = shared + 
		warp * VALUES_PER_THREAD * (WARP_SIZE + 1);
	volatile uint* threadShared = warpShared + lane;
	

	////////////////////////////////////////////////////////////////////////////
	// Load packed values from global memory and scatter to shared memory. Use
	// a 33-slot stride between successive values in each thread to set us up
	// for a conflict-free strided order -> thread order transpose. Storing to
	// separate memory intervals allows use transpose without explicit
	// synchronization.

	uint index = VALUES_PER_WARP * warp + lane;

	#pragma unroll
	for(int i = 0; i < VALUES_PER_THREAD; ++i) {
		uint x = dataIn_global[index + i * WARP_SIZE];
		threadShared[i * (WARP_SIZE + 1)] = x;
	}

	uint offset = VALUES_PER_THREAD * lane;
	offset += offset / WARP_SIZE;
	uint packed[VALUES_PER_THREAD];

	#pragma unroll
	for(int i = 0; i < VALUES_PER_THREAD; ++i)
		packed[i] = warpShared[offset + i];


	////////////////////////////////////////////////////////////////////////////
	// INTRA-WARP UPSWEEP PASS
	// Run a sequential segmented scan for all values in the packed array. Find
	// the sum of all values in the thread's last segment. Additionally set
	// index to tid if any segments begin in this thread.
	
	uint last = 0;
	uint hasHeadFlag = 0;

	uint x[VALUES_PER_THREAD];
	uint flags[VALUES_PER_THREAD];

	#pragma unroll
	for(int i = 0; i < VALUES_PER_THREAD; ++i) {
		flags[i] = 0x80000000 & packed[i];
		x[i] = 0x7fffffff & packed[i];
		if(flags[i]) last = 0;
		hasHeadFlag |= flags[i];
		last += x[i];
	}


	////////////////////////////////////////////////////////////////////////////
	// INTRA-WARP SEGMENT PASS
	// Run a ballot and clz to find the lane containing the start value for
	// the segment that begins this thread.

	uint warpFlags = __ballot(hasHeadFlag);

	// Mask out the bits at or above the current thread.
	uint mask = bfi(0, 0xffffffff, 0, lane);
	uint warpFlagsMask = warpFlags & mask;

	// Find the distance from the current thread to the thread at the start of
	// the segment.
	int preceding = 31 - __clz(warpFlagsMask);
	uint distance = lane - preceding;


	////////////////////////////////////////////////////////////////////////////
	// REDUCTION PASS
	// Run a prefix sum scan over last to compute for each lane the sum of all
	// values in the segmented preceding the current lane, up to that point.
	// This is added back into the thread-local exclusive scan for the continued
	// segment in each thread.
	
	volatile uint* shifted = threadShared + 1;
	shifted[-1] = 0;
	shifted[0] = last;
	uint sum = last;
	uint first = warpShared[1 + preceding];

	#pragma unroll
	for(int i = 0; i < LOG_WARP_SIZE; ++i) {
		uint offset = 1<< i;
		if(distance > offset) sum += shifted[-offset];
		shifted[0] = sum;
	}
	// Subtract last to make exclusive and add first to grab the fragment sum of
	// the preceding thread.
	sum += first - last;


	// Call BlockScan for inter-warp scan on the reductions of the last segment
	// in each warp.
	uint lastSegLength = last;
	if(!hasHeadFlag) lastSegLength += sum;

	uint blockScan = BlockScan(warp, lane, lastSegLength, warpFlags, mask, 
		shared, threadShared);
	if(!warpFlagsMask) sum += blockScan;


	////////////////////////////////////////////////////////////////////////////
	// INTRA-WARP PASS
	// Add sum to all the values in the continuing segment (that is, before the
	// first start flag) in this thread.

	#pragma unroll
	for(int i = 0; i < VALUES_PER_THREAD; ++i) {
		if(flags[i]) sum = 0;

		warpShared[offset + i] = sum;
		sum += x[i];
	}

	// Store the values back to global memory.
	#pragma unroll
	for(int i = 0; i < VALUES_PER_THREAD; ++i) {
		uint x = threadShared[i * (WARP_SIZE + 1)];
		dataOut_global[index + i * WARP_SIZE] = x;
	}
}