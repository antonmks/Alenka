#pragma once

#include "mgpusort.h"


////////////////////////////////////////////////////////////////////////////////
// Exception-safe wrapper for using MPGU sort from C++.

#include <exception>
#include <algorithm>

struct MgpuException : std::exception {
	MgpuException(sortStatus_t status) : _status(status) { }
	
	virtual const char* what() const throw() { 
		return sortStatusString(_status); 
	}
	
	sortStatus_t _status;
};

// Wrap sortData_d and take ownership of the data. 
// Adds Attach function to attach externally allocated device memory to the
// sortData_d, and prevents the library from deallocating these on destruction.
struct MgpuSortData : sortData_d {
	MgpuSortData() { 
		memset(this, 0, sizeof(MgpuSortData)); 
	}
	~MgpuSortData() { 
		Reset();
	}

	void Reset() {
		for(int i(0); i < 2; ++i) {
			if(_attachedKeys[i]) keys[i ^ parity] = 0;
			for(int j(0); j < 6; ++j)
				if(_attachedVals[j][i]) values[j][i ^ parity] = 0;
		}
		sortFreeData(this);
		memset(this, 0, sizeof(MgpuSortData)); 
	}

	sortStatus_t Alloc(sortEngine_t engine, int maxElements_, int valueCount_) {
		maxElements = maxElements_;
		numElements = maxElements_;
		valueCount = valueCount_;
		return sortAllocData(engine, this);
	}

	void AttachKey(CUdeviceptr p, int i = 0) { 
		keys[i] = p; 
		_attachedKeys[i ^ parity] = true; 
	}
	void AttachKey(unsigned int* p, int i = 0) { 
		pKeys[i] = p;
		_attachedKeys[i ^ parity] = true; 
	}

	void AttachVal(int j, CUdeviceptr p, int i = 0) { 
		values[j][i] = p;
		_attachedVals[j][i ^ parity] = true;
	}
	void AttachVal(int j, unsigned int* p, int i = 0) {
		pValues[j][i] = p;
		_attachedVals[j][i ^ parity] = true;
	}

private:
	// Disable copy and assignment, because we don't have deep copy semantics.
	MgpuSortData(const MgpuSortData&) { }
	MgpuSortData& operator=(const MgpuSortData&) { return *this; }

	bool _attachedKeys[2];
	bool _attachedVals[6][2];
};


// Wrap sortEngine_t and implement reference counting semantics on copy.
class MgpuSort {
public:
	// Throws an exception on error.
	MgpuSort(const char* kernelPath) {
		sortStatus_t status = sortCreateEngine(kernelPath, &_engine);
		if(SORT_STATUS_SUCCESS != status) throw MgpuException(status);
	}

	// Attach an MgpuSort wrapper around an existing engine handle. Will 
	// increment the engine's reference counter on construction, and dec it on
	// destruction.
	MgpuSort(sortEngine_t engine) {
		_engine = engine; 
		if(engine) sortIncEngine(engine);
	}

	MgpuSort(const MgpuSort& rhs) {
		_engine = rhs._engine;
		if(_engine) sortIncEngine(_engine);
	}

	~MgpuSort() {
		if(_engine) sortReleaseEngine(_engine);
	}

	MgpuSort& operator=(const MgpuSort& rhs) {
		MgpuSort temp(rhs);
		std::swap(_engine, temp._engine);
		return *this;
	}

	operator sortEngine_t() { return _engine; }

private:
	sortEngine_t _engine;
};

