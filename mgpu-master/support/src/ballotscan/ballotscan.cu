// Demonstration of ballot scan. 
// See http://www.moderngpu.com/intro/scan.html#Ballot

#define WARP_SIZE 32
#define LOG_WARP_SIZE 5

#define NUM_THREADS 256
#define NUM_WARPS 8
#define LOG_NUM_WARPS 3

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
// Use parallel scan for stream compaction. All values that are not -1.0f are
// moved to the front of the stream and stored to dataOut_global. The total
// number of defined values is stored in countOut_global.

extern "C" __global__ void ParallelScanWarp(const float* dataIn_global, 
	float* dataOut_global, uint* countOut_global) {

	__shared__ volatile uint shared[WARP_SIZE + WARP_SIZE / 2];

	uint tid = threadIdx.x;
	float val = dataIn_global[tid];

	shared[tid] = 0;

	volatile uint* s = shared + tid + WARP_SIZE / 2;

	// Scan the number of non -1.0 elements.
	uint flag = -1.0f != val;
	uint x = flag;
	s[0] = x;

	// Run a parallel scan.
	#pragma unroll
	for(int i = 0; i < LOG_WARP_SIZE; ++i) {
		uint offset = 1<< i;
		uint y = s[-offset];
		x += y;
		s[0] = x;
	}

	// Subtract the flag to get an exclusive scan.
	uint scan = x - flag;
	uint total = shared[WARP_SIZE + WARP_SIZE / 2 - 1];

	volatile float* s2 = (volatile float*)shared;
	if(flag) s2[scan] = val;

	val = s2[tid];

	if(tid < total)
		dataOut_global[tid] = val;

	if(!tid) 
		*countOut_global = total;
}


////////////////////////////////////////////////////////////////////////////////
// Use ballot scan (ballot-mask-popc) for a fast parallel scan on one-bit
// sequences.

extern "C" __global__ void BallotScanWarp(const float* dataIn_global, 
	float* dataOut_global, uint* countOut_global) {

	uint tid = threadIdx.x;
	float val = dataIn_global[tid];

	uint flag = -1.0f != val;

	uint bits = __ballot(flag);

	uint mask = bfi(0, 0xffffffff, 0, tid);
	uint exc = __popc(mask & bits);
	uint total = __popc(bits);

	__shared__ volatile float shared[WARP_SIZE];
	if(flag) shared[exc] = val;
	val = shared[tid];

	if(tid < total) 
		dataOut_global[tid] = val;

	if(!tid) *countOut_global = total;
}



////////////////////////////////////////////////////////////////////////////////
// Multiscan utility function. Returns the inclusive scan of the arguments in 
// .x and the sum of all arguments in .y.

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
// Scan across an entire block using Multiscan method.

extern "C" __global__ void ParallelScanBlock(const float* dataIn_global, 
	float* dataOut_global, uint* countOut_global) {

	uint tid = threadIdx.x;
	float val = dataIn_global[tid];

	uint flag = -1.0f != val;

	uint2 scan = Multiscan(tid, flag);
	
	__shared__ volatile float shared[NUM_THREADS];
	uint exc = scan.x - flag;

	if(flag) shared[exc] = val;
	__syncthreads();
	
	if(tid < scan.y) {
		val = shared[tid];
		dataOut_global[tid] = val;
	}

	if(!tid) 
		*countOut_global = scan.y;
}


////////////////////////////////////////////////////////////////////////////////
// Run a ballot scan on each warp. Run a parallel scan on the total for each
// warp, then add the exclusive scan of the totals back into the exclusive
// ballot scans.

extern "C" __global__ void BallotScanBlock(const float* dataIn_global, 
	float* dataOut_global, uint* countOut_global) {

	uint tid = threadIdx.x;
	uint lane = (WARP_SIZE - 1) & tid;
	uint warp = tid / WARP_SIZE;

	float val = dataIn_global[tid];

	uint flag = -1.0f != val;
	
	// Ballot scan the flags as in the warp scan version.
	uint bits = __ballot(flag);
	uint mask = bfi(0, 0xffffffff, 0, lane);
	uint exc = __popc(mask & bits);
	uint warpTotal = __popc(bits);

	__shared__ volatile uint shared[NUM_WARPS];
	if(!lane) shared[warp] = warpTotal;

	// Inclusive scan the warp totals.
	__syncthreads();
	if(tid < NUM_WARPS) {
		uint x = shared[tid];
		for(int i = 0; i < LOG_NUM_WARPS; ++i) {
			uint offset = 1<< i;
			if(tid >= offset) x += shared[tid - offset];
			shared[tid] = x;
		}
	}
	__syncthreads();

	// Add the scanned warp totals into exc.
	uint blockTotal = shared[NUM_WARPS - 1];
	exc += shared[warp] - warpTotal;

	__shared__ volatile float shared2[NUM_THREADS];
	if(flag) shared2[exc] = val;
	
	__syncthreads();

	if(tid < blockTotal) {
		val = shared2[tid];
		dataOut_global[tid] = val;
	}

	if(!tid) 
		*countOut_global = blockTotal;
}
