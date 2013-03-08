#include "../../../util/cucpp.h"
#include "../../../inc/mgpusearch.h"

const int SegSize = 128;
const int SegLanes32Bit = 16;
const int SegLanes64Bit = 16;

const char* SearchStatusStrings[] = {
	"SEARCH_STATUS_SUCCESS",
	"SEARCH_STATUS_NOT_INITIALIZED",
	"SEARCH_STATUS_DEVICE_ALLOC_FAILED", 
	"SEARCH_STATUS_HOST_ALLOC_FAILED",
	"SEARCH_STATUS_CONFIG_NOT_SUPORTED",
	"SEARCH_STATUS_INVALID_CONTEXT",
	"SEARCH_STATUS_KERNEL_NOT_FOUND",
	"SEARCH_STATUS_KERNEL_ERROR",
	"SEARCH_STATUS_LAUNCH_ERROR",
	"SEARCH_STATUS_INVALID_VALUE",
	"SEARCH_STATUS_DEVICE_ERROR",
	"SEARCH_STATUS_INTERNAL_ERROR",
	"SCAN_STATUS_UNSUPPORTED_DEVICE"
};

const char* SEARCHAPI searchStatusString(searchStatus_t status) {
	if(status > sizeof(SearchStatusStrings) / sizeof(char*)) return 0;
	return SearchStatusStrings[status];
}


////////////////////////////////////////////////////////////////////////////////
// Support functions for building and navigating GPU b-trees.

// Returns the size of each type.
const int TypeSizes[6] = { 4, 4, 4, 8, 8, 8 };

// Returns the number of active levels and their sizes.
int DeriveLevelSizes(int count, searchType_t type, int* sizes) {
	int size = TypeSizes[type];
	int SegLanes = (8 == size) ? SegLanes64Bit : SegLanes32Bit;
	
	int level = 1;
	sizes[0] = RoundUp(count, SegLanes);
	do {
		count = DivUp(count, SegLanes);
		count = RoundUp(count, SegLanes);
		sizes[level++] = count;
	} while(count > SegLanes);

	for(int i(0); i < level / 2; ++i)
		std::swap(sizes[i], sizes[level - 1 - i]);

	return level;
}

struct searchEngine_d {
	ContextPtr context;
	ModulePtr module;
	FunctionPtr search[6][4];
	FunctionPtr build[2];		// 32- and 64-bit versions.
};


////////////////////////////////////////////////////////////////////////////////
// Create and destroy the sparseEngine_d object.

searchStatus_t SEARCHAPI searchCreate(const char* kernelPath,
	searchEngine_t* engine) {

	std::auto_ptr<searchEngine_d> e(new searchEngine_d);

	// Get the current context and test the device version.
	CUresult result = AttachCuContext(&e->context);
	if(CUDA_SUCCESS != result) return SEARCH_STATUS_INVALID_CONTEXT;
	if(2 != e->context->Device()->ComputeCapability().first)
		return SCAN_STATUS_UNSUPPORTED_DEVICE;

	// Load the module.
	result = e->context->LoadModuleFilename(kernelPath, &e->module);
	if(CUDA_SUCCESS != result) return SEARCH_STATUS_KERNEL_NOT_FOUND;

	// Load the functions.

	const char* Types[6] = {
		"Int", "Uint", "Float", "Int64", "Uint64", "Double" 
	};
	const char* Algos[4] = {
		"Lower", "Upper", "Match", "Range"
	};

	result = e->module->GetFunction("BuildTree4", make_int3(256, 1, 1), 
		&e->build[0]);
	if(CUDA_SUCCESS != result) return SEARCH_STATUS_KERNEL_NOT_FOUND;
	
	result = e->module->GetFunction("BuildTree8", make_int3(256, 1, 1), 
		&e->build[1]);
	if(CUDA_SUCCESS != result) return SEARCH_STATUS_KERNEL_NOT_FOUND;

	for(int i(0); i < 6; ++i)
		for(int j(0); j < 4; ++j) {
			char kernelName[64];
			sprintf(kernelName, "SearchTree%s%s", Types[i], Algos[j]);
			result = e->module->GetFunction(kernelName, make_int3(1024, 1, 1),
				&e->search[i][j]);
		}

	*engine = e.release();
	return SEARCH_STATUS_SUCCESS;
}

searchStatus_t SEARCHAPI searchDestroy(searchEngine_t engine) {
	delete engine;
	return SEARCH_STATUS_SUCCESS;
}


////////////////////////////////////////////////////////////////////////////////
// Build the search b-tree.

const int MaxLevels = 8;

int SEARCHAPI searchTreeSize(int count, searchType_t type) {
	int sizes[MaxLevels];
	int levels = DeriveLevelSizes(count, type, sizes);
	int total = 0;
	for(int i(0); i < levels - 1; ++i)
		total += sizes[i];
	
	return TypeSizes[type] * total;
}


searchStatus_t SEARCHAPI searchBuildTree(searchEngine_t engine, int count, 
	searchType_t type, CUdeviceptr data, CUdeviceptr tree) {

	// Build the tree from the bottom up.
	int sizes[MaxLevels];
	int levels = DeriveLevelSizes(count, type, sizes);
	int size = TypeSizes[type];

	CUdeviceptr levelStarts[MaxLevels];
	for(int i(0); i < levels - 1; ++i) {
		levelStarts[i] = tree;
		tree += size * sizes[i];
	}
	levelStarts[levels - 1] = data;
	sizes[levels - 1] = count;

	for(int i(levels - 2); i >= 0; --i) {
		CuCallStack callStack;
		callStack.Push(levelStarts[i + 1], sizes[i + 1], levelStarts[i]);

		int numBlocks = DivUp(sizes[i], 256);
		CUresult result = engine->build[size / 4 - 1]->Launch(numBlocks, 1,
			callStack);
	}

	return SEARCH_STATUS_SUCCESS;
}


////////////////////////////////////////////////////////////////////////////////
// Search the b-tree.

template<typename T>
struct BTree {
	CUdeviceptr nodes[MaxLevels];
	uint roundDown[MaxLevels];
	uint numLevels;
	uint baseCount;
};

searchStatus_t SEARCHAPI searchKeys(searchEngine_t engine, int count,
	searchType_t type, CUdeviceptr data, searchAlgo_t algo, CUdeviceptr keys, 
	int numQueries, CUdeviceptr tree, CUdeviceptr results) {

	BTree<int> btree;
	int levelCounts[MaxLevels];
	btree.numLevels = DeriveLevelSizes(count, type, levelCounts);
	int offset = 0;
	int size = TypeSizes[type];
	int SegLanes = (8 == size) ? SegLanes64Bit : SegLanes32Bit;
	int SegsPerBlock = 1024 / SegLanes;

	for(uint i(0); i < btree.numLevels - 1; ++i) {
		btree.nodes[i] = tree;
		btree.roundDown[i] = levelCounts[i + 1] - SegLanes;
		tree += levelCounts[i] * size;
	}
	btree.baseCount = count;
	btree.nodes[btree.numLevels - 1] = data;

	int numBlocks = DivUp(numQueries, SegsPerBlock);
	numBlocks = std::min(numBlocks, engine->context->Device()->NumSMs());

	div_t d = div(numQueries, numBlocks);

	CuCallStack callStack;
	callStack.Push(keys, d.quot, d.rem);
	callStack.PushStruct(btree, sizeof(CUdeviceptr));
	callStack.Push(results);

	CuFunction* func = engine->search[(int)type][(int)algo].get();
	CUresult result = func->Launch(numBlocks, 1, callStack);
	
	return SEARCH_STATUS_SUCCESS;
}

