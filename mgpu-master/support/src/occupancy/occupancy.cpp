// 

#include <cstdio>
#include <utility>
#include <algorithm>

typedef std::pair<int, int> IntPair;

int RoundUp(int x, int y) {
	return ~(y - 1) & (x + y - 1);
}
int RoundDown(int x, int y) {
	return ~(y - 1) & x;
}

const int WarpSize = 32;
const int RegsPerSM = 32768;
const int MaxRegsPerThread = 63;
const int BytesPerSM = 48 * 1024;
const int MaxBlocksPerSM = 8;
const int MaxOccupancy = 1536;
const int ByteGranularity = 128;	// 128 bytes per block.
const int RegGranularity = 64;		// 64 regs per warp.

// .first is registers per thread, .second is bytes per block.
IntPair RegBytes(int blockSize, int blockCount) {
	int blockSize2 = RoundUp(blockSize, WarpSize);

	// Evenly divide all the registers into the number of blocks.
	int regsPerBlock = (int)((double)RegsPerSM / blockCount);

	// Round regsPerBlock down so that it is a multiple of 64 per warp
	// in the block.
	int numWarps = blockSize2 / WarpSize;
	regsPerBlock = RoundDown(regsPerBlock, RegGranularity * numWarps);

	// Divide by the number of threads in all the warps in the block and 
	int regsPerThread = std::min(MaxRegsPerThread, regsPerBlock / blockSize2);
	
	// Divide the amount of shared memory on the SM evenly by the block count
	// and round down to a multiple of 128.
	int numBytes = (int)((double)BytesPerSM / blockCount);
	numBytes = RoundDown(numBytes, ByteGranularity);

	return IntPair(regsPerThread, numBytes);		
}


int main(int argc, char** argv) {
	for(int blockSize(32); blockSize <= 1024; blockSize *= 2) {
		// Find the maximum block count given the MaxOccupancy.
		int maxBlocks = std::min(MaxBlocksPerSM, MaxOccupancy / blockSize);
		
		for(int numBlocks(1); numBlocks <= maxBlocks; ++numBlocks) {
			IntPair regBytes = RegBytes(blockSize, numBlocks);
			double occupancy = 100.0 * (numBlocks * blockSize) / MaxOccupancy;
			int intsPerThread = regBytes.second / (4 * blockSize);
			printf("%4d x %d (%6.2f%%): %d regs, %5d bytes (%3d ints/thread)\n",
				blockSize, numBlocks, occupancy, regBytes.first, 
				regBytes.second, intsPerThread);
		}
		printf("\n");
	}
}
