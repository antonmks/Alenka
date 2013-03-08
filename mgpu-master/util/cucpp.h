#pragma once

#include "util.h"
#include <cuda.h>
#include <memory>
#include <string>
#include <vector>
#include <vector_functions.h>

const int WarpSize = 32;

template<typename T>
inline T* ToPointer(CUdeviceptr p) {
	return reinterpret_cast<T*>(p);
}
template<typename T>
inline CUdeviceptr FromPointer(T* p) {
	return reinterpret_cast<CUdeviceptr>(p);
}

template<typename T>
inline CUdeviceptr AdjustPointer(CUdeviceptr p, int adjust) {
	return FromPointer(ToPointer<T>(p) + adjust);
}

inline void cuFreeZero(CUdeviceptr& p) {
	if(p) cuMemFree(p);
	p = 0;
}

struct CuDeviceAttr;
class CuDevice;

class CuContext;
class CuStream;
class CuDeviceMem;
class CuPageLockedMem;
class CuTexture;
class CuGlobalMem;
class CuBuffer;
class CuModule;

class CuCallStack;
class CuFunction;

typedef intrusive_ptr2<CuDevice> DevicePtr;
typedef intrusive_ptr2<CuContext> ContextPtr;
typedef intrusive_ptr2<CuDeviceMem> DeviceMemPtr;
typedef intrusive_ptr2<CuPageLockedMem> PageLockedMemPtr;
typedef intrusive_ptr2<CuTexture> TexturePtr;
typedef intrusive_ptr2<CuGlobalMem> GlobalMemPtr;
typedef intrusive_ptr2<CuBuffer> BufferPtr;
typedef intrusive_ptr2<CuStream> StreamPtr;
typedef intrusive_ptr2<CuModule> ModulePtr;
typedef intrusive_ptr2<CuFunction> FunctionPtr;

struct CuException {
	CuException(CUresult r = CUDA_SUCCESS) : result(r) { }
	CUresult result;
};


////////////////////////////////////////////////////////////////////////////////
// CuDevice
// CU_DEVICE_ATTRIBUTE_MAX_THREADS_PER_BLOCK
// CU_DEVICE_ATTRIBUTE_MAX_BLOCK_DIM_X, Y, Z
// CU_DEVICE_ATTRIBUTE_MAX_GRID_DIM_X, Y, Z
// CU_DEVICE_ATTRIBUTE_MAX_SHARED_MEMORY_PER_BLOCK
// CU_DEVICE_ATTRIBUTE_TOTAL_CONSTANT_MEMORY
// CU_DEVICE_ATTRIBUTE_WARP_SIZE
// CU_DEVICE_ATTRIBUTE_MAX_PITCH
// CU_DEVICE_ATTRIBUTE_MAX_REGISTERS_PER_BLOCK
// CU_DEVICE_ATTRIBUTE_CLOCK_RATE
// CU_DEVICE_ATTRIBUTE_TEXTURE_ALIGNMENT
// CU_DEVICE_ATTRIBUTE_GPU_OVERLAP
// CU_DEVICE_ATTRIBUTE_MULTIPROCESSOR_COUNT
// CU_DEVICE_ATTRIBUTE_KERNEL_EXEC_TIMEOUT
// CU_DEVICE_ATTRIBUTE_INTEGRATED
// CU_DEVICE_ATTRIBUTE_CAN_MAP_HOST_MEMORY
// CU_DEVICE_ATTRIBUTE_COMPUTE_MODE
// CU_DEVICE_ATTRIBUTE_MAXIMUM_TEXTURE1D_WIDTH
// CU_DEVICE_ATTRIBUTE_MAXIMUM_TEXTURE2D_WIDTH
// CU_DEVICE_ATTRIBUTE_MAXIMUM_TEXTURE3D_WIDTH
// CU_DEVICE_ATTRIBUTE_MAXIMUM_TEXTURE2D_ARRAY_WIDTH
// CU_DEVICE_ATTRIBUTE_SURFACE_ALIGNMENT
// CU_DEVICE_ATTRIBUTE_CONCURRENT_KERNELS
// CU_DEVICE_ATTRIBUTE_ECC_ENABLED
// CU_DEVICE_ATTRIBUTE_PCI_BUS_ID
// CU_DEVICE_ATTRIBUTE_PCI_DEVICE_ID
// CU_DEVICE_ATTRIBUTE_TCC_DRIVER
// CU_DEVICE_ATTRIBUTE_MEMORY_CLOCK_RATE
// CU_DEVICE_ATTRIBUTE_GLOBAL_MEMORY_BUS_WIDTH
// CU_DEVICE_ATTRIBUTE_L2_CACHE_SIZE
// CU_DEVICE_ATTRIBUTE_MAX_THREADS_PER_MULTIPROCESSOR

struct CuDeviceAttr {
	int threadsPerBlock;			
	int3 blockDim;					
	int3 gridDim;					
	int sharedMemPerBlock;			
	int totalConstantMem;			
	int warpSize;					
	int maxPitch;					
	int regPerBlock;				
	int clockRate;					
	int textureAlignment;			
	int gpuOverlap;					
	int multiprocessorCount;		
	int kernelExecTimeout;			
	int integrated;					
	int canMapHostMem;				
	CUcomputemode computeMode;		
	int tex1DSize;					
	int2 tex2DSize;					
	int3 tex3DSize;					
	int3 tex2DArraySize;			
	int surfaceAlignment;			
	int concurrentKernels;			
	int eccEnabled;					
	int pciBusID;					
	int pciDeviceID;				
	int tccDriver;					
	int memoryClockRate;			
	int globalMemoryBusWidth;		
	int l2CacheSize;				
	int maxThreadsPerSM;			
};


class CuDevice : public CuBase {
public:
	typedef CUdevice HandleType;

	int Ordinal() const { return _ordinal; }
	IntPair ComputeCapability() const { return _capability; }
	const char* Name() const { return _deviceName.c_str(); }
	size_t DeviceMem() const { return _totalMem; }
	const CuDeviceAttr& Attributes() const { return _attributes; }
	int NumSMs() const { return _attributes.multiprocessorCount; }
	CUdevice Handle() { return _h; }

private:
	friend CUresult CreateCuDevice(int ordinal, DevicePtr* ppDevice);

	void GetAttributes();

	CuDevice() : _h(0) { }

	CUdevice _h;
	int _ordinal;
	IntPair _capability;
	std::string _deviceName;
	size_t _totalMem;
	CuDeviceAttr _attributes;
};

CUresult CreateCuDevice(int ordinal, DevicePtr* ppDevice);


////////////////////////////////////////////////////////////////////////////////
// CuContext

class CuContext : public CuBase {
public:
	typedef CUcontext HandleType;
	CUcontext Handle() { return _h; }
	CUresult PushContext() { return cuCtxPushCurrent(_h); }

	CuDevice* Device() { return _device; }

	CUresult ByteAlloc(size_t size, DeviceMemPtr* ppMem);
	CUresult ByteAlloc(size_t size, const void* data, DeviceMemPtr* ppMem);
	
	template<typename T>
	CUresult MemAlloc(const std::vector<T>& data, DeviceMemPtr* ppMem) {
		return ByteAlloc(sizeof(T) * data.size(), &data[0], ppMem);
	}

	template<typename T>
	CUresult MemAlloc(const T* data, size_t count, DeviceMemPtr* ppMem) {
		return ByteAlloc(sizeof(T) * count, &data[0], ppMem);
	}

	template<typename T>
	CUresult MemAlloc(size_t count, DeviceMemPtr* ppMem) {
		return ByteAlloc(sizeof(T) * count, ppMem);
	}

	CUresult LoadModuleFilename(const std::string& filename,
		ModulePtr* ppModule);
	CUresult LoadModuleFilenameEx(const std::string& filename, 
		ModulePtr* ppModule, uint maxRegisters);

	CUresult CreateTex2D(int width, int height, CUarray_format format, 
		int numChannels, TexturePtr* ppTexture);
	CUresult CreateTex3D(int width, int height, int depth, 
		CUarray_format format, int numChannels, TexturePtr* ppTexture);

private:
	friend CUresult CreateCuContext(CuDevice* device, uint flags, 
		ContextPtr* ppContext);
	friend CUresult AttachCuContext(ContextPtr* ppContext);

	CuContext(bool destroy) : _h(0), _destroyOnDtor(destroy) { }
	~CuContext() { if(_h && _destroyOnDtor) cuCtxDestroy(_h); }

	CUcontext _h;
	DevicePtr _device;
	bool _destroyOnDtor;
};

// Create a context object from the device. When using this function, the
// context will destroy itself when it falls out of scope.
CUresult CreateCuContext(CuDevice* device, uint flags, ContextPtr* ppContext);

// Attach a CuContext around the current context. When the object falls out of
// scope, it won't call cuCtxDestroy.
CUresult AttachCuContext(ContextPtr* ppContext);


////////////////////////////////////////////////////////////////////////////////
// CuDeviceMem

class CuDeviceMem : public CuBase {
	friend class CuModule;
	friend class CuContext;
public:
	size_t Size() const { return _size; }
	CUdeviceptr Handle() { return _deviceptr; }
	CuContext* Context() { return _context.get(); }

	template<typename T>
	CUresult ToHost(T* host, size_t size = (size_t)0xffffffff) {
		size = (0xffffffff == size) ? _size : (size * sizeof(T));
		return ToHostByte(host, 0, size);
	}
	
	template<typename T>
	CUresult ToHost(std::vector<T>& host) {
		host.resize(_size / sizeof(T));
		return ToHost(&host[0]);
	}

	CUresult ToHostByte(void* host, size_t offset, size_t size);

	CUresult FromHostByte(const void* host, size_t size = (size_t)-1);
	CUresult FromHostByte(const void* host, size_t offset, size_t size);

	template<typename T>
	CUresult FromHost(const T* host, size_t size) {
		return FromHostByte(host, sizeof(T) * size);
	}
	template<typename T>
	CUresult FromHost(const std::vector<T>& host) {
		return FromHost(&host[0], host.size());
	}

	// TODO: add in support for arbitrary fills using custom kernel
	CUresult Fill(int i) { return Fill4(&i); }
	CUresult Fill(uint u) { return Fill4(&u); }
	CUresult Fill(float f) { return Fill4(&f); }

	// Copy from this DeviceMem to target DeviceMem.
	CUresult ToDevice(CuDeviceMem* target);
	CUresult ToDevice(CUdeviceptr target);

	CUresult ToDevice(size_t sourceOffset, CuDeviceMem* target,
		size_t targetOffset, size_t size);
	CUresult ToDevice(size_t sourceOffset, CUdeviceptr target,
		size_t size);

	CUresult FromDevice(size_t targetOffset, CUdeviceptr source,
		size_t size);
	CUresult FromDevice(CUdeviceptr source);

protected:
	CuDeviceMem() : _deviceptr(0), _size(0) { }
	~CuDeviceMem() { Clean(); }
	virtual void Clean();

	CUresult Fill4(const void* fill);

	CUdeviceptr _deviceptr;
	size_t _size;
	ContextPtr _context;
};


////////////////////////////////////////////////////////////////////////////////
// CuTexture

class CuTexture : public CuBase {
	friend class CuContext;
public:
	typedef CUarray HandleType;
	int Dim() const { return _dim; }
	int Width() const { return _width; }
	int Height() const { return _height; }
	int Depth() const { return _depth; }
	CUarray_format Format() const { return _format; }
	int NumChannels() const { return _numChannels; }
	CUarray Handle() { return _texture; }

	CuContext* Context() { return _context; }

private:
	CuTexture() : _context(0) { }
	~CuTexture();

	ContextPtr _context;
	int _width, _height, _depth, _dim, _numChannels;
	CUarray_format _format;
	CUarray _texture;
};


////////////////////////////////////////////////////////////////////////////////
// CuGlobalMem

class CuGlobalMem : public CuDeviceMem {
	friend class CuModule;
public:
	CuModule* Module() { return _module.get(); }
	const std::string& Name() const { return _globalName; }

protected:
	virtual void Clean() { }

	ModulePtr _module;
	std::string _globalName;
};


////////////////////////////////////////////////////////////////////////////////
// CuModule

struct CuTexSamplerAttr {
	CUaddress_mode addressX, addressY, addressZ;
	CUfilter_mode filter;
	bool readAsInteger;
	bool normCoord;
	CUarray_format fmt;
	int numPackedComponents;
};

class CuModule : public CuBase {
	friend class CuContext;
public:
	typedef CUmodule HandleType;
	CUmodule Handle() { return _module; }

	CuContext* Context() { return _context.get(); }

	CUresult GetFunction(const std::string& name, int3 blockShape, 
		FunctionPtr* ppFunction);
	CUresult GetGlobal(const std::string& name, GlobalMemPtr* ppGlobal);

	// Texture binding
	CUresult BindLinearTexture(const std::string& name, CuDeviceMem* mem,
		CUarray_format format, int numChannels);

	CUresult BindArrayTexture(const std::string& name, CuTexture* texture,
		const CuTexSamplerAttr& sampler);

private:
	struct TexBind {
		CUtexref texRef;
		std::string name;
		CuTexSamplerAttr sampler;
	
		TexturePtr texture;
		DeviceMemPtr mem;
	};
	void SetFormat(TexBind* texBind, CUarray_format format, int numChannels);
	void SetSampler(TexBind* texBind, const CuTexSamplerAttr& sampler);

	CUresult FindTexRef(const std::string& name, TexBind** pTexBind);

	CuModule() : _module(0) { }
	~CuModule() { 
		if(_module) cuModuleUnload(_module);
	}

	std::vector<FunctionPtr> _functions;
	std::vector<GlobalMemPtr> _globals;
	std::vector<TexBind> _textures;

	CUmodule _module;
	ContextPtr _context;
};


////////////////////////////////////////////////////////////////////////////////
// CuFunction

struct CuFuncAttr {
	int maxThreadsPerBlock;			// CU_FUNC_ATTRIBUTE_MAX_THREADS_PER_BLOCK 
	int sharedSizeBytes;			// CU_FUNC_ATTRIBUTE_SHARED_SIZE_BYTES 
	int constSizeBytes;				// CU_FUNC_ATTRIBUTE_CONST_SIZE_BYTES 
	int localSizeBytes;				// CU_FUNC_ATTRIBUTE_LOCAL_SIZE_BYTES 
	int numRegs;					// CU_FUNC_ATTRIBUTE_NUM_REGS 
	int ptxVersion;					// CU_FUNC_ATTRIBUTE_PTX_VERSION 
	int binaryVersion;				// CU_FUNC_ATTRIBUTE_BINARY_VERSION 
};

// function has dependency on module
class CuFunction : public CuBase {
	friend CUresult CreateCuFunction(const char* name, CuModule* module,
		int3 blockShape, FunctionPtr* ppFunction);
public:
	typedef CUfunction HandleType;
	CUfunction Handle() { return _function; }
	const std::string& Name() const { return _functionName; }
	const CuFuncAttr& Attributes() const { return _attributes; }
	int3 BlockShape() const { return _blockShape; }

	CuModule* Module() { return _module.get(); }
	CuContext* Context() { return _module->Context(); }

	CUresult Launch(int width, int height, CuCallStack& callStack);

private:
	CUfunction _function;
	ModulePtr _module;
	std::string _functionName;
	CuFuncAttr _attributes;
	int3 _blockShape;
};


////////////////////////////////////////////////////////////////////////////////
// CuCallStack

#define CALL_SET(x)										\
	_status = _status && x;								\
	if(!_status) _size = 0;								\
	return _status;											

class CuCallStack {
public:
	CuCallStack(size_t capacity = 64) : _size(0), _status(true) {
		_data.resize(capacity); 
	}

	const void* Data() const { return _size ? &_data[0] : 0; }
	size_t Size() const { return _size; }
	void Reset() { _size = 0; }

	void** Extra() {
		extra[0] = CU_LAUNCH_PARAM_BUFFER_POINTER;
		extra[1] = (void*)Data();
		extra[2] = CU_LAUNCH_PARAM_BUFFER_SIZE;
		extra[3] = &_size;
		extra[4] = CU_LAUNCH_PARAM_END;
		return extra;
	}

	bool PushV(int i) { return PushV(&i, 4, 4); }
	bool PushV(int2 i2) { return PushV(&i2, 8, 8); }
	bool PushV(int3 i3) { return PushV(&i3, 12, 4); }
	bool PushV(int4 i4) { return PushV(&i4, 16, 16); }
	bool PushV(uint u) { return PushV(&u, 4, 4); }
	bool PushV(uint2 u2) { return PushV(&u2, 8, 8); }
	bool PushV(uint3 u3) { return PushV(&u3, 12, 4); }
	bool PushV(uint4 u4) { return PushV(&u4, 16, 16); }

	bool PushV(float f) { return PushV(&f, 4, 4); }
	bool PushV(float2 f2) { return PushV(&f2, 8, 8); }
	bool PushV(float3 f3) { return PushV(&f3, 12, 4); }
	bool PushV(float4 f4) { return PushV(&f4, 16, 16); }

	bool PushV(double d) { return PushV(&d, 8, 8); }
	bool PushV(double2 d2) { return PushV(&d2, 16, 16); }	
	
	bool PushV(CuDeviceMem* mem);

	template<typename T>
	void PushStruct(const T& t, size_t align) { PushV(&t, sizeof(T), align); }
	
	// On 64bit builds, CUdeviceptr is defined as long long unsigned int.
#if defined(__x86_64) || defined(AMD64) || defined(_M_AMD64)
	bool PushV(CUdeviceptr p) {
		return PushV(&p, 8, 8);
	}
#endif

	bool PushV(const void* data, size_t size, size_t align);

	template<typename T1>
	bool Push(T1 x1) {
		CALL_SET(PushI(x1))		
	}
	template<typename T1, typename T2>
	bool Push(T1 x1, T2 x2) {
		CALL_SET(PushI(x1, x2))
	}
	template<typename T1, typename T2, typename T3>
	bool Push(T1 x1, T2 x2, T3 x3) {
		CALL_SET(PushI(x1, x2, x3))
	}
	template<typename T1, typename T2, typename T3, typename T4>
	bool Push(T1 x1, T2 x2, T3 x3, T4 x4) {
		CALL_SET(PushI(x1, x2, x3, x4))
	}
	template<typename T1, typename T2, typename T3, typename T4, typename T5>
	bool Push(T1 x1, T2 x2, T3 x3, T4 x4, T5 x5) {
		CALL_SET(PushI(x1, x2, x3, x4, x5))
	}
	template<typename T1, typename T2, typename T3, typename T4,
		typename T5, typename T6>
	bool Push(T1 x1, T2 x2, T3 x3, T4 x4, T5 x5, T6 x6) {
		CALL_SET(PushI(x1, x2, x3, x4, x5, x6))
	}
	template<typename T1, typename T2, typename T3, typename T4,
		typename T5, typename T6, typename T7>
	bool Push(T1 x1, T2 x2, T3 x3, T4 x4, T5 x5, T6 x6, T7 x7) {
		CALL_SET(PushI(x1, x2, x3, x4, x5, x6, x7))
	}
	template<typename T1, typename T2, typename T3, typename T4,
		typename T5, typename T6, typename T7, typename T8>
	bool Push(T1 x1, T2 x2, T3 x3, T4 x4, T5 x5, T6 x6, T7 x7, T8 x8) {
		CALL_SET(PushI(x1, x2, x3, x4, x5, x6, x7, x8))
	}
	template<typename T1, typename T2, typename T3, typename T4,
		typename T5, typename T6, typename T7, typename T8, typename T9>
	bool Push(T1 x1, T2 x2, T3 x3, T4 x4, T5 x5, T6 x6, T7 x7, T8 x8, T9 x9) {
		CALL_SET(PushI(x1, x2, x3, x4, x5, x6, x7, x8, x9))
	}
	template<typename T1, typename T2, typename T3, typename T4, typename T5, 
		typename T6, typename T7, typename T8, typename T9, typename T10>
	bool Push(T1 x1, T2 x2, T3 x3, T4 x4, T5 x5, T6 x6, T7 x7, T8 x8, T9 x9,
		T10 x10) {
		CALL_SET(PushI(x1, x2, x3, x4, x5, x6, x7, x8, x9, x10))
	}
	template<typename T1, typename T2, typename T3, typename T4, typename T5, 
		typename T6, typename T7, typename T8, typename T9, typename T10, 
		typename T11>
	bool Push(T1 x1, T2 x2, T3 x3, T4 x4, T5 x5, T6 x6, T7 x7, T8 x8, T9 x9, 
		T10 x10, T11 x11) {
		CALL_SET(PushI(x1, x2, x3, x4, x5, x6, x7, x8, x9, x10, x11))
	}
	template<typename T1, typename T2, typename T3, typename T4, typename T5, 
		typename T6, typename T7, typename T8, typename T9, typename T10,
		typename T11, typename T12>
	bool Push(T1 x1, T2 x2, T3 x3, T4 x4, T5 x5, T6 x6, T7 x7, T8 x8, T9 x9,
		T10 x10, T11 x11, T12 x12) {
		CALL_SET(PushI(x1, x2, x3, x4, x5, x6, x7, x8, x9, x10, x11, x12))
	}
	template<typename T1, typename T2, typename T3, typename T4, typename T5, 
		typename T6, typename T7, typename T8, typename T9, typename T10,
		typename T11, typename T12, typename T13>
	bool Push(T1 x1, T2 x2, T3 x3, T4 x4, T5 x5, T6 x6, T7 x7, T8 x8, T9 x9,
		T10 x10, T11 x11, T12 x12, T13 x13) {
		CALL_SET(PushI(x1, x2, x3, x4, x5, x6, x7, x8, x9, x10, x11, x12, x13))
	}

private:
	template<typename T1>
	bool PushI(T1 x1) {
		return PushV(x1);	
	}
	template<typename T1, typename T2>
	bool PushI(T1 x1, T2 x2) {
		return PushI(x1) && PushV(x2);
	}
	template<typename T1, typename T2, typename T3>
	bool PushI(T1 x1, T2 x2, T3 x3) {
		return PushI(x1, x2) && PushV(x3);
	}
	template<typename T1, typename T2, typename T3, typename T4>
	bool PushI(T1 x1, T2 x2, T3 x3, T4 x4) {
		return PushI(x1, x2, x3) && PushV(x4);
	}
	template<typename T1, typename T2, typename T3, typename T4, typename T5>
	bool PushI(T1 x1, T2 x2, T3 x3, T4 x4, T5 x5) {
		return PushI(x1, x2, x3, x4) && PushV(x5);
	}
	template<typename T1, typename T2, typename T3, typename T4, typename T5,
		typename T6>
	bool PushI(T1 x1, T2 x2, T3 x3, T4 x4, T5 x5, T6 x6) {
		return PushI(x1, x2, x3, x4, x5) && PushV(x6);
	}
	template<typename T1, typename T2, typename T3, typename T4, typename T5,
		typename T6, typename T7>
	bool PushI(T1 x1, T2 x2, T3 x3, T4 x4, T5 x5, T6 x6, T7 x7) {
		return PushI(x1, x2, x3, x4, x5, x6) && PushV(x7);
	}
	template<typename T1, typename T2, typename T3, typename T4, typename T5,
		typename T6, typename T7, typename T8>
	bool PushI(T1 x1, T2 x2, T3 x3, T4 x4, T5 x5, T6 x6, T7 x7, T8 x8) {
		return PushI(x1, x2, x3, x4, x5, x6, x7) && PushV(x8);
	}
	template<typename T1, typename T2, typename T3, typename T4, typename T5,
		typename T6, typename T7, typename T8, typename T9>
	bool PushI(T1 x1, T2 x2, T3 x3, T4 x4, T5 x5, T6 x6, T7 x7, T8 x8, T9 x9) {
		return PushI(x1, x2, x3, x4, x5, x6, x7, x8) && PushV(x9);
	}
	template<typename T1, typename T2, typename T3, typename T4, typename T5,
		typename T6, typename T7, typename T8, typename T9, typename T10>
	bool PushI(T1 x1, T2 x2, T3 x3, T4 x4, T5 x5, T6 x6, T7 x7, T8 x8, T9 x9, 
		T10 x10) {
		return PushI(x1, x2, x3, x4, x5, x6, x7, x8, x9) && PushV(x10);
	}
	template<typename T1, typename T2, typename T3, typename T4, typename T5,
		typename T6, typename T7, typename T8, typename T9, typename T10,
		typename T11>
	bool PushI(T1 x1, T2 x2, T3 x3, T4 x4, T5 x5, T6 x6, T7 x7, T8 x8, T9 x9,
		T10 x10, T11 x11) {
		return PushI(x1, x2, x3, x4, x5, x6, x7, x8, x9, x10) && PushV(x11);
	}
	template<typename T1, typename T2, typename T3, typename T4, typename T5,
		typename T6, typename T7, typename T8, typename T9, typename T10,
		typename T11, typename T12>
	bool PushI(T1 x1, T2 x2, T3 x3, T4 x4, T5 x5, T6 x6, T7 x7, T8 x8, T9 x9,
		T10 x10, T11 x11, T12 x12) {
		return PushI(x1, x2, x3, x4, x5, x6, x7, x8, x9, x10, x11) && 
			PushV(x12);
	}
	template<typename T1, typename T2, typename T3, typename T4, typename T5,
		typename T6, typename T7, typename T8, typename T9, typename T10,
		typename T11, typename T12, typename T13>
	bool PushI(T1 x1, T2 x2, T3 x3, T4 x4, T5 x5, T6 x6, T7 x7, T8 x8, T9 x9, 
		T10 x10, T11 x11, T12 x12, T13 x13) {
		return PushI(x1, x2, x3, x4, x5, x6, x7, x8, x9, x10, x11, x12) && 
			PushV(x13);
	}

	std::vector<byte> _data;
	size_t _size;
	bool _status;

	// extra slots for CUDA4 cuLaunchKernel
	void* extra[5];
};

inline bool CuCallStack::PushV(CuDeviceMem* mem) { 
	CUdeviceptr ptr = mem->Handle();
	return PushV(&ptr, sizeof(CUdeviceptr), sizeof(void*)); 
}

inline bool CuCallStack::PushV(const void* data, size_t size, size_t align) {
	size_t offset = (_size + align - 1) & ~(align - 1);
	size_t offset2 = offset + size;
	if(_data.size() < offset2) _data.resize(3 * offset2 / 2);
	memcpy(&_data[offset], data, size);
	_size = offset2;
	return true;
}


////////////////////////////////////////////////////////////////////////////////
// CuEventTimer

class CuEventTimer {
public:
	CuEventTimer() {
		_running = false;
		_elapsed = 0;

		CUresult result = cuEventCreate(&_startEvent, CU_EVENT_BLOCKING_SYNC);
		assert(CUDA_SUCCESS == result);

		result = cuEventCreate(&_timerEvent, CU_EVENT_BLOCKING_SYNC);
		assert(CUDA_SUCCESS == result);	
		
	}
	~CuEventTimer() {
		cuEventDestroy(_startEvent);
		cuEventDestroy(_timerEvent);
	}

	bool Running() const { return _running; }

	// Starts the timer (if not already running) and optionally clears the time.
	bool Start(bool reset = true) {
		bool success = !_running;
		if(success) {
			if(reset) _elapsed = 0;
			CUresult result = cuEventRecord(_startEvent, 0);
			assert(CUDA_SUCCESS == result);
			_running = true;
		}
		return success;
	}

	// Split returns the time to this point, but the timer keeps running.
	double Split() {
		if(!_running) return 0;
		CUresult result = cuEventRecord(_timerEvent, 0);
		result = cuEventSynchronize(_timerEvent);
		
		float ms;
		result = cuEventElapsedTime(&ms, _startEvent, _timerEvent);
		assert(CUDA_SUCCESS == result);
		
		// Convert from ms to s.
		return ms / 1000;
	}

	// Returns the time to this point and stops the timer.
	double Stop() {
		_elapsed += Split();
		_running = false;
		return _elapsed;
	}

private:
	bool _running;
	double _elapsed;
	CUevent _startEvent, _timerEvent;
};

