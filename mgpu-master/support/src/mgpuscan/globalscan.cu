#include <device_functions.h>
#include <vector_functions.h>

#define DEVICE extern "C" __forceinline__ __device__
typedef unsigned int uint;

#define ROUND_UP(x, y) (~(y - 1) & (x + y - 1))

#define WARP_SIZE 32
#define NUM_THREADS 256
#define BLOCKS_PER_SM 4
#define NUM_WARPS (NUM_THREADS / WARP_SIZE)

#define LOG_WARP_SIZE 5
#define LOG_NUM_THREADS 8
#define LOG_NUM_WARPS (LOG_NUM_THREADS - LOG_WARP_SIZE)

// Parameters for efficient sequential scan.
#define VALUES_PER_THREAD 8
#define NUM_VALUES (NUM_THREADS * VALUES_PER_THREAD)
#define SHARED_STRIDE (WARP_SIZE + 1)
#define SHARED_SIZE (NUM_VALUES + NUM_VALUES / WARP_SIZE)

__shared__ volatile uint values_shared[SHARED_SIZE];

////////////////////////////////////////////////////////////////////////////////
// Multiscan utility function. Used in the first and third passes of the
// global scan function. Returns the inclusive scan of the arguments in .x and
// the sum of all arguments in .y.

DEVICE uint2 Multiscan(uint tid, uint x) {
	uint warp = tid / WARP_SIZE;
	uint lane = (WARP_SIZE - 1) & tid;

	const int ScanStride = WARP_SIZE + WARP_SIZE / 2 + 1;
	const int ScanSize = NUM_WARPS * ScanStride;
	__shared__ volatile uint reduction_shared[ScanSize];
	__shared__ volatile uint totals_shared[NUM_WARPS + NUM_WARPS / 2];

	volatile uint* s = reduction_shared + ScanStride * warp + lane + 
		WARP_SIZE / 2;
	s[-16] = 0;
	s[0] = x;

	// Run inclusive scan on each warp's data.
	uint sum = x;	
	#pragma unroll
	for(int i = 0; i < LOG_WARP_SIZE; ++i) {
		uint offset = 1<< i;
		sum += s[-offset];
		s[0] = sum;
	}

	// Synchronize to make all the totals available to the reduction code.
	__syncthreads();
	if(tid < NUM_WARPS) {
		// Grab the block total for the tid'th block. This is the last element
		// in the block's scanned sequence. This operation avoids bank 
		// conflicts.
		uint total = reduction_shared[ScanStride * tid + WARP_SIZE / 2 +
			WARP_SIZE - 1];

		totals_shared[tid] = 0;
		volatile uint* s2 = totals_shared + NUM_WARPS / 2 + tid;
		uint totalsSum = total;
		s2[0] = total;

		#pragma unroll
		for(int i = 0; i < LOG_NUM_WARPS; ++i) {
			int offset = 1<< i;
			totalsSum += s2[-offset];
			s2[0] = totalsSum;	
		}

		// Subtract total from totalsSum for an exclusive scan.
		totals_shared[tid] = totalsSum - total;
	}

	// Synchronize to make the block scan available to all warps.
	__syncthreads();

	// Add the block scan to the inclusive sum for the block.
	sum += totals_shared[warp];
	uint total = totals_shared[NUM_WARPS + NUM_WARPS / 2 - 1];
	return make_uint2(sum, total);
}


////////////////////////////////////////////////////////////////////////////////
// GlobalScanPass1 adds up all the values in elements_global within the 
// range given by blockCount and writes to blockTotals_global[blockIdx.x].

extern "C" __launch_bounds__(NUM_THREADS, BLOCKS_PER_SM) __global__ 
void GlobalScanPass1(const uint* elements_global, const uint2* range_global,
	uint* blockTotals_global) {

	uint block = blockIdx.x;
	uint tid = threadIdx.x;
	uint2 range = range_global[block];

	// Loop through all elements in the interval, adding up values.
	// There is no need to synchronize until we perform the multiscan.
	uint sum = 0;
	for(uint index = range.x + tid; index < range.y; index += NUM_THREADS)
		sum += elements_global[index];
	
	// A full multiscan is unnecessary here - we really only need the total.
	// But this is easy and won't slow us down since this kernel is already
	// bandwidth limited.
	uint total = Multiscan(tid, sum).y;

	// The last scan element in the block is the total for all values summed
	// in this block.
	if(tid == NUM_THREADS - 1)
		blockTotals_global[block] = total;
}


////////////////////////////////////////////////////////////////////////////////
// GlobalScanPass2 performs an exclusive scan on the elements in 
// blockTotals_global and writes back in-place.

extern "C" __global__ void GlobalScanPass2(uint* blockTotals_global, 
	uint numBlocks) {

	uint tid = threadIdx.x;
	uint x = 0; 
	if(tid < numBlocks) x = blockTotals_global[tid];

	// Subtract the value from the inclusive scan for the exclusive scan.
	uint2 scan = Multiscan(tid, x);
	if(tid < numBlocks) blockTotals_global[tid] = scan.x - x;
	
	// Have the first thread in the block set the scan total.
	if(!tid) blockTotals_global[numBlocks] = scan.y;
}


////////////////////////////////////////////////////////////////////////////////
// GlobalScanPass3 runs an exclusive scan on the same interval of data as in
// pass 1, and adds blockScan_global[blockIdx.x] to each of them, writing back
// out in-place.

extern "C" __launch_bounds__(NUM_THREADS, BLOCKS_PER_SM) __global__ 
void GlobalScanPass3(uint* elements_global, const uint2* range_global,
	uint* blockScan_global, int inclusive) {

	uint block = blockIdx.x;
	uint tid = threadIdx.x;
	uint warp = tid / WARP_SIZE;
	uint lane = (WARP_SIZE - 1) & tid;

	uint blockScan = blockScan_global[block];
	uint2 range = range_global[block];

	// Have each warp read a consecutive block of memory. Because threads in a
	// warp are implicitly synchronized, we can "transpose" the terms into
	// thread-order without a __syncthreads().
	uint first = range.x + warp * (VALUES_PER_THREAD * WARP_SIZE) + lane;
	uint end = ROUND_UP(range.y, NUM_VALUES);

	// Get a pointer to the start of this warp's shared memory storage for 
	// value transpose.
	volatile uint* warpValues = values_shared +
		warp * SHARED_STRIDE * VALUES_PER_THREAD;

	// The threads write to threadValues[i * SHARED_STRIDE]
	volatile uint* threadValues = warpValues + lane;

	// The threads read from transposeValues[i]
	uint valueOffset = lane * VALUES_PER_THREAD;
	volatile uint* transposeValues = warpValues + valueOffset + 
		valueOffset / WARP_SIZE;
	
	for(uint index = first; index < end; index += NUM_VALUES) {

		#pragma unroll
		for(int i = 0; i < VALUES_PER_THREAD; ++i) {
			uint index2 = index + i * WARP_SIZE;
			uint value = 0;
			if(index2 < range.y) value = elements_global[index2];
		
			threadValues[i * SHARED_STRIDE] = value;
		}

		// Transpose into thread order by reading from transposeValues.
		// Compute the exclusive or inclusive scan of the thread values and 
		// their sum.
		uint scan[VALUES_PER_THREAD];
		uint sum = 0;
		#pragma unroll
		for(int i = 0; i < VALUES_PER_THREAD; ++i) {
			uint x = transposeValues[i];
			scan[i] = sum;
			if(inclusive) scan[i] += x;
			sum += x;
		}

		// Multiscan for each thread's scan offset within the block. Subtract
		// sum to make it an exclusive scan.
		uint2 localScan = Multiscan(tid, sum);
		uint scanOffset = localScan.x + blockScan - sum;

		// Add the scan offset to each exclusive scan and put the values back
		// into the shared memory they came out of.
		#pragma unroll
		for(int i = 0; i < VALUES_PER_THREAD; ++i) {
			uint x = scan[i] + scanOffset;
			transposeValues[i] = x;
		}

		// Store the scan back to global memory.
		#pragma unroll
		for(int i = 0; i < VALUES_PER_THREAD; ++i) {
			uint x = threadValues[i * SHARED_STRIDE];
			uint index2 = index + i * WARP_SIZE;			
			if(index2 < range.y) elements_global[index2] = x;
		}

		// Grab the last element of totals_shared, which was set in Multiscan.
		// This is the total for all the values encountered in this pass.
		blockScan += localScan.y;
	}
}

