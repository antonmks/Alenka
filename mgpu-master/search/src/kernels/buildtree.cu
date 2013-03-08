#define NUM_BUILD_THREADS 256
#define BUILD_BLOCKS_PER_SM 6

template<typename T> __forceinline__ __device__  
void BuildTree(const T* data, uint count, T* tree) {

	const int SegLanes = (8 == sizeof(T)) ? SEG_LANES_64_BIT : 
		SEG_LANES_32_BIT;

	// Divide (rounding up) by SegLanes for the number of dest lanes.
	uint validDest = (count + SegLanes - 1) / SegLanes;

	// Round up to a multiple of the node size (SegLanes)
	uint numGid = ~(SegLanes - 1) & (validDest + SegLanes - 1);

	uint tid = threadIdx.x;
	uint block = blockIdx.x;
	uint gid = NUM_BUILD_THREADS * block + tid;

	if(gid < numGid) {
		uint index = SegLanes * gid + SegLanes - 1;
		index = min(index, count - 1);

		T x = data[index];
		tree[gid] = x;
	}
}


extern "C" __global__ __launch_bounds__(NUM_BUILD_THREADS, BUILD_BLOCKS_PER_SM)
void BuildTree4(const uint* data, uint count, uint* tree) {

	BuildTree(data, count, tree);
}

extern "C" __global__ __launch_bounds__(NUM_BUILD_THREADS, BUILD_BLOCKS_PER_SM)
void BuildTree8(const double* data, uint count,  double* tree) {

	BuildTree(data, count, tree);
}
