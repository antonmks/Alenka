
template<typename T>
struct BTree {
	const T* nodes[MAX_LEVELS];
	uint roundDown[MAX_LEVELS];
	uint numLevels;
	uint baseCount;
};


template<typename T> DEVICE2
uint GetOffset(T key, T node, int type, uint mask) {
	uint p;
	if(SearchTypeLower == type) p = key > node;
	if(SearchTypeUpper == type) p = key >= node;

	uint bits = mask & __ballot(p);
	uint offset = __popc(bits);

	return offset;
}

template<int SegLanes, typename T> DEVICE2
uint DescendTree(uint offset, uint& o2, T& laneNode, T key, uint segLane,
	uint level, int type, uint mask, BTree<T> tree, int numLevels) {

	laneNode = tree.nodes[level][offset + segLane];

	if(level < numLevels - 1) {
		// We're in a b-tree level.
		o2 = GetOffset(key, laneNode, type, mask);
		offset = SegLanes * (offset + o2);
		offset = min(offset, tree.roundDown[level]);
	} else {
		// We're on the base level of data.
		if(offset + SegLanes > tree.baseCount) {
			// Change the mask if we're at the end of the data.
			uint setBits = tree.baseCount - offset;
			mask = mask & (0xffffffff>> (SegLanes - setBits));
		}
		o2 = GetOffset(key, laneNode, type, mask);
		offset += o2;
	}
	return offset;
}

template<int SegLanes, int Loop, typename T> DEVICE2
uint RecurseTree(T key, T rootNode, int type, uint mask, const T* level1_shared,
	BTree<T> tree, uint segLane) {

	// Find the offset within the 16-way or 32-way tree node.
	uint offset = GetOffset(key, rootNode, type, mask);

	// Multiply by 16 or 32 to get the offset for the next node in the tree.
	// To prevent indexing past the end of the array, we round down to the
	// start of the last complete node in each level.
	offset = min(SegLanes * offset, tree.roundDown[0]);

	// Use the scaled offset + segLane to get this lane's comparison key.
	T laneNode = level1_shared[offset + segLane];
	uint o2 = 0;

	offset = DescendTree<SegLanes>(offset, o2, laneNode, key, segLane, 1, type,
		mask, tree, Loop);

	// Advisory: Loop was not unrolled, unexpected call OPs.
	// Manually unroll the loop because nvcc is a POS.

	/*
	#pragma unroll
	for(int level = 2; level < Loop; ++level) {
		offset = DescendTree(offset, o2, laneNode, key, segLane, level, type,
			mask, tree);
	}
	*/

	if(2 < Loop) 
		offset = DescendTree<SegLanes>(offset, o2, laneNode, key, segLane, 2, 
			type, mask, tree, Loop);
	if(3 < Loop) 
		offset = DescendTree<SegLanes>(offset, o2, laneNode, key, segLane, 3, 
			type, mask, tree, Loop);
	if(4 < Loop) 
		offset = DescendTree<SegLanes>(offset, o2, laneNode, key, segLane, 4, 
			type, mask, tree, Loop);
	if(5 < Loop) 
		offset = DescendTree<SegLanes>(offset, o2, laneNode, key, segLane, 5, 
			type, mask, tree, Loop);
	if(6 < Loop) 
		offset = DescendTree<SegLanes>(offset, o2, laneNode, key, segLane, 6, 
			type, mask, tree, Loop);
	if(7 < Loop) 
		offset = DescendTree<SegLanes>(offset, o2, laneNode, key, segLane, 7, 
			type, mask, tree, Loop);

	return offset;
}


template<int SegLanes, int Loop, typename T> DEVICE2
void SearchTree(const T* keys_global, int2 task, int type, BTree<T> tree, 
	T* rootNode_shared, T* level1_shared, T* request_shared,
	uint* indices_shared, uint* indices_global) {
	

	////////////////////////////////////////////////////////////////////////////
	// Initialize

	const int SegsPerBlock = 1024 / SegLanes;

	uint tid = threadIdx.x;
	uint segLane = (SegLanes - 1) & tid;
	uint warpLane = (WARP_SIZE - 1) & tid;
	uint node = tid / SegLanes;

	uint mask;
	if(WARP_SIZE == SegLanes) mask = 0xffffffff;
	else {
		uint warpSegStart = ~(SegLanes - 1) & warpLane;
		mask = ((1<< SegLanes) - 1)<< warpSegStart;
	}

	// Load the root node and the first level of nodes.
	if(tid < SegLanes) rootNode_shared[tid] = tree.nodes[0][tid];
	if(tid < SegLanes * SegLanes) level1_shared[tid] = tree.nodes[1][tid];
	__syncthreads();

	T rootNode = rootNode_shared[segLane];

	////////////////////////////////////////////////////////////////////////////
	// Loop over all the requests and process the searches.

	// Load all the requests into shared memory and store the indices to 
	// shared memory.

	while(task.x < task.y) {
		int remaining = task.y - task.x;
		remaining = min(1024, remaining);
		if(tid < remaining) 
			request_shared[tid] = keys_global[task.x + tid];
		__syncthreads();


		// Process all the requests from shared memory over each warp or 
		// half-warp.
		for(int query = node; query < remaining; query += SegsPerBlock) {

			T key = request_shared[query];

			uint offset = RecurseTree<SegLanes, Loop>(key, rootNode, type, mask,
				level1_shared, tree, segLane);

			if(!segLane) indices_shared[query] = offset;
		}
		
		__syncthreads();
		if(tid < remaining) 
			indices_global[task.x + tid] = indices_shared[tid];

		task.x += 1024;
	}
}

template<typename T> DEVICE2
void SearchTreeSwitch(const T* keys, int2 task, int type, BTree<T> tree, 
	uint* indices_global) {

	const int SegLanes = (8 == sizeof(T)) ? SEG_LANES_64_BIT : SEG_LANES_32_BIT;

	__shared__ T rootNode_shared[SegLanes];
	__shared__ T level1_shared[SegLanes * SegLanes];
	__shared__ T request_shared[1024];
	__shared__ uint indices_shared[1024];

	if(2 == tree.numLevels)
		SearchTree<SegLanes, 2>(keys, task, type, tree, rootNode_shared, 
			level1_shared, request_shared, indices_shared, indices_global);
	if(3 == tree.numLevels)
		SearchTree<SegLanes, 3>(keys, task, type, tree, rootNode_shared, 
			level1_shared, request_shared, indices_shared, indices_global);
	if(4 == tree.numLevels)
		SearchTree<SegLanes, 4>(keys, task, type, tree, rootNode_shared, 
			level1_shared, request_shared, indices_shared, indices_global);
	if(5 == tree.numLevels)
		SearchTree<SegLanes, 5>(keys, task, type, tree, rootNode_shared, 
			level1_shared, request_shared, indices_shared, indices_global);
	if(6 == tree.numLevels)
		SearchTree<SegLanes, 6>(keys, task, type, tree, rootNode_shared, 
			level1_shared, request_shared, indices_shared, indices_global);
	if((16 == SegLanes) && (7 == tree.numLevels))
		SearchTree<SegLanes, 7>(keys, task, type, tree, rootNode_shared, 
			level1_shared, request_shared, indices_shared, indices_global);
}


// The input taskPair is a div() quot/remainder pair. We want to combine with
// blockIdx.x to get the first query and end query for the block.
DEVICE int2 ComputeTaskPair(int taskQuot, int taskRem) {
	int block = blockIdx.x;
	int2 pair;
	pair.x = taskQuot * block;
	pair.x += min(block, taskRem);
	pair.y = pair.x + taskQuot + (block < taskRem);
	return pair;
}

#define GEN_SEARCH(name, T, type)											\
extern "C" __global__ __launch_bounds__(1024, 1)							\
void name(const T* keys, int taskQuot, int taskRem, BTree<T> tree,			\
	uint* indices_global) {													\
																			\
	int2 task = ComputeTaskPair(taskQuot, taskRem);							\
	SearchTreeSwitch(keys, task, type, tree, indices_global);				\
}

GEN_SEARCH(SearchTreeIntLower, int, SearchTypeLower)
GEN_SEARCH(SearchTreeIntUpper, int, SearchTypeUpper)

GEN_SEARCH(SearchTreeUintLower, uint, SearchTypeLower)
GEN_SEARCH(SearchTreeUintUpper, uint, SearchTypeUpper)

GEN_SEARCH(SearchTreeFloatLower, float, SearchTypeLower)
GEN_SEARCH(SearchTreeFloatUpper, float, SearchTypeUpper)


GEN_SEARCH(SearchTreeInt64Lower, int64_t, SearchTypeLower)
GEN_SEARCH(SearchTreeInt64Upper, int64_t, SearchTypeUpper)

GEN_SEARCH(SearchTreeUint64Lower, uint64_t, SearchTypeLower)
GEN_SEARCH(SearchTreeUint64Upper, uint64_t, SearchTypeUpper)

GEN_SEARCH(SearchTreeDoubleLower, double, SearchTypeLower)
GEN_SEARCH(SearchTreeDoubleUpper, double, SearchTypeUpper)
