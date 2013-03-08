
#include "cucpp.h"
#include <vector>
#include <fstream>

#define HANDLE_RESULT() if(CUDA_SUCCESS != result) return result


////////////////////////////////////////////////////////////////////////////////
// CuDevice

void CuDevice::GetAttributes() {

	cuDeviceComputeCapability(&_capability.first, &_capability.second, _h);

	char name[256];
	cuDeviceGetName(name, 255, _h);
	_deviceName = name;

	cuDeviceTotalMem(&_totalMem, _h);

	CuDeviceAttr& a = _attributes;
	cuDeviceGetAttribute(&a.threadsPerBlock, 
		CU_DEVICE_ATTRIBUTE_MAX_THREADS_PER_BLOCK, _h);
	cuDeviceGetAttribute(&a.blockDim.x, 
		CU_DEVICE_ATTRIBUTE_MAX_BLOCK_DIM_X, _h);
	cuDeviceGetAttribute(&a.blockDim.y, 
		CU_DEVICE_ATTRIBUTE_MAX_BLOCK_DIM_Y, _h);
	cuDeviceGetAttribute(&a.blockDim.z, 
		CU_DEVICE_ATTRIBUTE_MAX_BLOCK_DIM_Z, _h);
	cuDeviceGetAttribute(&a.gridDim.x, 
		CU_DEVICE_ATTRIBUTE_MAX_GRID_DIM_X, _h);
	cuDeviceGetAttribute(&a.gridDim.y, 
		CU_DEVICE_ATTRIBUTE_MAX_GRID_DIM_Y, _h);
	cuDeviceGetAttribute(&a.gridDim.z, 
		CU_DEVICE_ATTRIBUTE_MAX_GRID_DIM_Z, _h);
	cuDeviceGetAttribute(&a.sharedMemPerBlock, 
		CU_DEVICE_ATTRIBUTE_MAX_SHARED_MEMORY_PER_BLOCK, _h);
	cuDeviceGetAttribute(&a.totalConstantMem, 
		CU_DEVICE_ATTRIBUTE_TOTAL_CONSTANT_MEMORY, _h);
	cuDeviceGetAttribute(&a.warpSize, 
		CU_DEVICE_ATTRIBUTE_WARP_SIZE, _h);
	cuDeviceGetAttribute(&a.maxPitch, 
		CU_DEVICE_ATTRIBUTE_MAX_PITCH, _h);
	cuDeviceGetAttribute(&a.regPerBlock, 
		CU_DEVICE_ATTRIBUTE_MAX_REGISTERS_PER_BLOCK, _h);
	cuDeviceGetAttribute(&a.clockRate, 
		CU_DEVICE_ATTRIBUTE_CLOCK_RATE, _h);
	cuDeviceGetAttribute(&a.textureAlignment, 
		CU_DEVICE_ATTRIBUTE_TEXTURE_ALIGNMENT, _h);
	cuDeviceGetAttribute(&a.gpuOverlap, 
		CU_DEVICE_ATTRIBUTE_GPU_OVERLAP, _h);
	cuDeviceGetAttribute(&a.multiprocessorCount, 
		CU_DEVICE_ATTRIBUTE_MULTIPROCESSOR_COUNT, _h);
	cuDeviceGetAttribute(&a.kernelExecTimeout, 
		CU_DEVICE_ATTRIBUTE_KERNEL_EXEC_TIMEOUT, _h);
	cuDeviceGetAttribute(&a.integrated, 
		CU_DEVICE_ATTRIBUTE_INTEGRATED, _h);
	cuDeviceGetAttribute(&a.canMapHostMem, 
		CU_DEVICE_ATTRIBUTE_CAN_MAP_HOST_MEMORY, _h);
	cuDeviceGetAttribute((int*)&a.computeMode, 
		CU_DEVICE_ATTRIBUTE_COMPUTE_MODE, _h);
	cuDeviceGetAttribute(&a.tex1DSize, 
		CU_DEVICE_ATTRIBUTE_MAXIMUM_TEXTURE1D_WIDTH, _h);
	cuDeviceGetAttribute(&a.tex2DSize.x,
		CU_DEVICE_ATTRIBUTE_MAXIMUM_TEXTURE2D_WIDTH, _h);
	cuDeviceGetAttribute(&a.tex2DSize.y, 
		CU_DEVICE_ATTRIBUTE_MAXIMUM_TEXTURE2D_HEIGHT, _h);
	cuDeviceGetAttribute(&a.tex3DSize.x, 
		CU_DEVICE_ATTRIBUTE_MAXIMUM_TEXTURE3D_WIDTH, _h);
	cuDeviceGetAttribute(&a.tex3DSize.y, 
		CU_DEVICE_ATTRIBUTE_MAXIMUM_TEXTURE3D_HEIGHT, _h);
	cuDeviceGetAttribute(&a.tex3DSize.z, 
		CU_DEVICE_ATTRIBUTE_MAXIMUM_TEXTURE3D_DEPTH, _h);
	cuDeviceGetAttribute(&a.tex2DArraySize.x, 
		CU_DEVICE_ATTRIBUTE_MAXIMUM_TEXTURE2D_ARRAY_WIDTH, _h);
	cuDeviceGetAttribute(&a.tex2DArraySize.y, 
		CU_DEVICE_ATTRIBUTE_MAXIMUM_TEXTURE2D_ARRAY_HEIGHT, _h);
	cuDeviceGetAttribute(&a.tex2DArraySize.z, 
		CU_DEVICE_ATTRIBUTE_MAXIMUM_TEXTURE2D_ARRAY_NUMSLICES, _h);
	cuDeviceGetAttribute(&a.surfaceAlignment, 
		CU_DEVICE_ATTRIBUTE_SURFACE_ALIGNMENT, _h);
	cuDeviceGetAttribute(&a.concurrentKernels, 
		CU_DEVICE_ATTRIBUTE_CONCURRENT_KERNELS, _h);
	cuDeviceGetAttribute(&a.eccEnabled, 
		CU_DEVICE_ATTRIBUTE_ECC_ENABLED, _h);
	cuDeviceGetAttribute(&a.pciBusID, 
		CU_DEVICE_ATTRIBUTE_PCI_BUS_ID, _h);
	cuDeviceGetAttribute(&a.pciDeviceID, 
		CU_DEVICE_ATTRIBUTE_PCI_DEVICE_ID, _h);
	cuDeviceGetAttribute(&a.tccDriver, 
		CU_DEVICE_ATTRIBUTE_TCC_DRIVER, _h);
	cuDeviceGetAttribute(&a.memoryClockRate, 
		CU_DEVICE_ATTRIBUTE_MEMORY_CLOCK_RATE, _h);
	cuDeviceGetAttribute(&a.globalMemoryBusWidth, 
		CU_DEVICE_ATTRIBUTE_GLOBAL_MEMORY_BUS_WIDTH, _h);
	cuDeviceGetAttribute(&a.l2CacheSize, 
		CU_DEVICE_ATTRIBUTE_L2_CACHE_SIZE, _h);
	cuDeviceGetAttribute(&a.maxThreadsPerSM, 
		CU_DEVICE_ATTRIBUTE_MAX_THREADS_PER_MULTIPROCESSOR, _h);
}

CUresult CreateCuDevice(int ordinal, DevicePtr* ppDevice) {
	DevicePtr device(new CuDevice);
	device->_ordinal = ordinal;
	device->GetAttributes();
	ppDevice->swap(device);
	return CUDA_SUCCESS;
}


////////////////////////////////////////////////////////////////////////////////
// CuContext

CUresult CreateCuContext(CuDevice* device, uint flags, ContextPtr* ppContext) {
	ContextPtr context(new CuContext(true));
	CUresult result = cuCtxCreate(&context->_h, flags, device->Handle());
	HANDLE_RESULT();

	context->_destroyOnDtor = true;
	context->_device = device;
	
	ppContext->swap(context);
	return CUDA_SUCCESS;
}

CUresult AttachCuContext(ContextPtr* ppContext) {
	ContextPtr context(new CuContext(false));
	CUresult result = cuCtxGetCurrent(&context->_h);
	if(CUDA_SUCCESS != result || !context->_h)
		return CUDA_ERROR_INVALID_CONTEXT;

	int ordinal;
	cuCtxGetDevice(&ordinal);
	CreateCuDevice(ordinal, &context->_device);
	
	ppContext->swap(context);
	return CUDA_SUCCESS;
}


CUresult CuContext::ByteAlloc(size_t size, DeviceMemPtr* ppMem) {
	DeviceMemPtr mem(new CuDeviceMem);
	CUresult result = cuMemAlloc(&mem->_deviceptr, size);
	HANDLE_RESULT();

	mem->_size = size;
	mem->_context = this;
	ppMem->swap(mem);
	return CUDA_SUCCESS;
}

CUresult CuContext::ByteAlloc(size_t size, const void* data,
	DeviceMemPtr* ppMem) {

	DeviceMemPtr mem;
	CUresult result = ByteAlloc(size, &mem);
	HANDLE_RESULT();

	result = mem->FromHostByte(data);
	HANDLE_RESULT();
	ppMem->swap(mem);

	return CUDA_SUCCESS;
}


CUresult CuContext::LoadModuleFilename(const std::string& filename, 
	ModulePtr* ppModule) {

	ModulePtr module(new CuModule);
	CUresult result = cuModuleLoad(&module->_module, filename.c_str());
	HANDLE_RESULT();

	module->_context = this;
	ppModule->swap(module);
	return CUDA_SUCCESS;
}

CUresult CuContext::LoadModuleFilenameEx(const std::string& filename, 
	ModulePtr* ppModule, uint maxRegisters) {

	std::ifstream file(filename.c_str());
	if(!file.good()) return CUDA_ERROR_FILE_NOT_FOUND;

	std::string contents(std::istreambuf_iterator<char>(file),
		std::istreambuf_iterator<char>(0));

	ModulePtr module(new CuModule);

	CUjit_option options[1] = { CU_JIT_MAX_REGISTERS };
	uint values[1] = { maxRegisters };
	CUresult result = cuModuleLoadDataEx(&module->_module, contents.c_str(),
		1, options, (void**)values);
	HANDLE_RESULT();

	module->_context = this;
	ppModule->swap(module);
	return CUDA_SUCCESS;
}


CUresult CuContext::CreateTex2D(int width, int height, CUarray_format format, 
	int numChannels, TexturePtr *ppTexture) {

	TexturePtr texture(new CuTexture);
	texture->_context = this;
	texture->_width = width;
	texture->_height = height;
	texture->_depth = 0;
	texture->_dim = 2;
	texture->_format = format;
	texture->_numChannels = numChannels;

	CUDA_ARRAY_DESCRIPTOR ad;
	ad.Width = width;
	ad.Height = height;
	ad.Format = format;
	ad.NumChannels = numChannels;

	CUresult result = cuArrayCreate(&texture->_texture, &ad);
	HANDLE_RESULT();

	ppTexture->swap(texture);
	return CUDA_SUCCESS;
}

CUresult CuContext::CreateTex3D(int width, int height, int depth, 
	CUarray_format format, int numChannels, TexturePtr* ppTexture) {

	TexturePtr texture(new CuTexture);
	texture->_context = this;
	texture->_width = width;
	texture->_height = height;
	texture->_depth = depth;
	texture->_dim = 3;
	texture->_format = format;
	texture->_numChannels = numChannels;

	CUDA_ARRAY3D_DESCRIPTOR ad;
	ad.Width = width;
	ad.Height = height;
	ad.Depth = depth;
	ad.Flags = 0;
	ad.Format = format;
	ad.NumChannels = numChannels;

	CUresult result = cuArray3DCreate(&texture->_texture, &ad);
	HANDLE_RESULT();

	ppTexture->swap(texture);
	return CUDA_SUCCESS;
}


////////////////////////////////////////////////////////////////////////////////
// CuDeviceMem

void CuDeviceMem::Clean() {
	cuFreeZero(_deviceptr);
}

CUresult CuDeviceMem::FromHostByte(const void* host, size_t size) {
	if((size_t)-1 == size) size = _size;
	if(size > _size) return CUDA_ERROR_INVALID_VALUE;
	return cuMemcpyHtoD(_deviceptr, host, size);
}
CUresult CuDeviceMem::FromHostByte(const void* host, size_t offset,
	size_t size) {
	if(offset + size > _size) return CUDA_ERROR_INVALID_VALUE;
	return cuMemcpyHtoD(_deviceptr + offset, host, size);
}

CUresult CuDeviceMem::Fill4(const void* fill) {
	CUresult result = cuMemsetD32(_deviceptr, *(uint*)fill, _size / 4);
	return result;
}

CUresult CuDeviceMem::ToHostByte(void* host, size_t offset, size_t size) {
	if(offset + size > _size) return CUDA_ERROR_INVALID_VALUE;
	return cuMemcpyDtoH(host, _deviceptr + offset, size);
}

CUresult CuDeviceMem::ToDevice(CuDeviceMem* target) {
	if(Context() != target->Context()) return CUDA_ERROR_INVALID_CONTEXT;
	if(Size() != target->Size()) return CUDA_ERROR_INVALID_VALUE;
	return ToDevice(target->Handle());
}
CUresult CuDeviceMem::ToDevice(CUdeviceptr target) {
	CUresult result = cuMemcpyDtoD(target, _deviceptr, _size);
	return result;
}

CUresult CuDeviceMem::ToDevice(size_t sourceOffset, CuDeviceMem* target,
	size_t targetOffset, size_t size) {

	if(Context() != target->Context()) return CUDA_ERROR_INVALID_CONTEXT;
	if(targetOffset + size > target->Size()) return CUDA_ERROR_INVALID_VALUE;
	
	return ToDevice(sourceOffset, target->Handle() + targetOffset, size);
}

CUresult CuDeviceMem::ToDevice(size_t sourceOffset, CUdeviceptr target,
	size_t size) {
	CUresult result = cuMemcpyDtoD(target, _deviceptr + sourceOffset, size);
	return result;
}

CUresult CuDeviceMem::FromDevice(size_t targetOffset, CUdeviceptr source, 
	size_t size) {

	if(targetOffset + size > _size) return CUDA_ERROR_INVALID_VALUE;
	CUresult result = cuMemcpyDtoD(_deviceptr + targetOffset, source, size);
	return result;
}

CUresult CuDeviceMem::FromDevice(CUdeviceptr source) {
	CUresult result = cuMemcpyDtoD(_deviceptr, source, _size);
	return result;
}




////////////////////////////////////////////////////////////////////////////////
// CuTexture

CuTexture::~CuTexture() {
	if(_texture) cuArrayDestroy(_texture);
}



////////////////////////////////////////////////////////////////////////////////
// CuModule

CUresult CuModule::GetFunction(const std::string& name, int3 blockShape,
	FunctionPtr *ppFunction) {

	// look for the cached function
	for(size_t i(0); i < _functions.size(); ++i)
		if(name == _functions[i]->Name()) {
			*ppFunction = _functions[i];
			return CUDA_SUCCESS;
		}

	// create the function
	FunctionPtr func;
	CUresult result = CreateCuFunction(name.c_str(), this, blockShape, &func);
	HANDLE_RESULT();

	_functions.push_back(func);
	ppFunction->swap(func);
	return CUDA_SUCCESS;
}

CUresult CuModule::GetGlobal(const std::string& name, GlobalMemPtr* ppGlobal) {
	for(size_t i(0); i < _globals.size(); ++i) 
		if(name == _globals[i]->Name()) {
			*ppGlobal = _globals[i];
			return CUDA_SUCCESS;
		}

	GlobalMemPtr mem(new CuGlobalMem);
	CUresult result = cuModuleGetGlobal(&mem->_deviceptr, &mem->_size, 
		_module, name.c_str());
	HANDLE_RESULT();

	mem->_context = _context;
	mem->_globalName = name;
	mem->_module = this;

	_globals.push_back(mem);
	*ppGlobal = mem;
	return CUDA_SUCCESS;
}

CUresult CuModule::FindTexRef(const std::string& name, 
	CuModule::TexBind** ppTexBind) {

	for(size_t i(0); i < _textures.size(); ++i)
		if(name == _textures[i].name) {
			*ppTexBind = &_textures[i];
			return CUDA_SUCCESS;
		}
	CUtexref texRef;
	CUresult result = cuModuleGetTexRef(&texRef, _module, name.c_str());
	HANDLE_RESULT();

	TexBind texBind;
	texBind.texRef = texRef;
	texBind.name = name;
	memset(&texBind.sampler, -1, sizeof(CuTexSamplerAttr));
	_textures.push_back(texBind);
	
	CuTexSamplerAttr sampler;
	sampler.addressX = CU_TR_ADDRESS_MODE_WRAP;
	sampler.addressY = CU_TR_ADDRESS_MODE_WRAP;
	sampler.addressZ = CU_TR_ADDRESS_MODE_WRAP;
	sampler.filter = CU_TR_FILTER_MODE_LINEAR;
	sampler.fmt = CU_AD_FORMAT_UNSIGNED_INT8;
	sampler.numPackedComponents = 4;
	sampler.normCoord = true;
	sampler.readAsInteger = false;
	SetSampler(&_textures.back(), sampler);

	*ppTexBind = &_textures.back();

	return CUDA_SUCCESS;
}

void CuModule::SetFormat(CuModule::TexBind* texBind, CUarray_format format,  
	int numChannels) {

	if((texBind->sampler.fmt != format) || 
		(texBind->sampler.numPackedComponents != numChannels)) {

		cuTexRefSetFormat(texBind->texRef, format, numChannels);
		texBind->sampler.fmt = format;
		texBind->sampler.numPackedComponents = numChannels;
	}
}

void CuModule::SetSampler(CuModule::TexBind* texBind,
	const CuTexSamplerAttr& sampler) {

	SetFormat(texBind, sampler.fmt, sampler.numPackedComponents);
	
	if(texBind->sampler.addressX != sampler.addressX) {
		cuTexRefSetAddressMode(texBind->texRef, 0, texBind->sampler.addressX);
		texBind->sampler.addressX = sampler.addressX;
	}
	if(texBind->sampler.addressY != sampler.addressY) {
		cuTexRefSetAddressMode(texBind->texRef, 1, texBind->sampler.addressY);
		texBind->sampler.addressY = sampler.addressY;
	}
	if(texBind->sampler.addressZ != sampler.addressZ) {
		cuTexRefSetAddressMode(texBind->texRef, 2, texBind->sampler.addressZ);
		texBind->sampler.addressZ = sampler.addressZ;
	}
	if(texBind->sampler.filter != sampler.filter) {
		cuTexRefSetFilterMode(texBind->texRef, sampler.filter);
		texBind->sampler.filter = sampler.filter;
	}
	if((texBind->sampler.readAsInteger != sampler.readAsInteger) ||
		(texBind->sampler.normCoord != sampler.normCoord)) {
	
		uint flags = (sampler.readAsInteger ? CU_TRSF_READ_AS_INTEGER : 0) |
			(sampler.normCoord ? CU_TRSF_NORMALIZED_COORDINATES : 0);
		texBind->sampler.readAsInteger = sampler.readAsInteger;
		texBind->sampler.normCoord = sampler.normCoord;
		cuTexRefSetFlags(texBind->texRef, flags);		
	}
}


CUresult CuModule::BindLinearTexture(const std::string& name, CuDeviceMem* mem,
	CUarray_format format, int numChannels) {

	TexBind* texBind;
	CUresult result = FindTexRef(name, &texBind);
	HANDLE_RESULT();

	SetFormat(texBind, format, numChannels);

	size_t offset;
	result = cuTexRefSetAddress(&offset, texBind->texRef, mem->Handle(),
		mem->Size());
	HANDLE_RESULT();

	texBind->texture.reset();
	texBind->mem = mem;
	return CUDA_SUCCESS;
}

CUresult CuModule::BindArrayTexture(const std::string& name, CuTexture* texture,
	const CuTexSamplerAttr& sampler) {

	TexBind* texBind;
	CUresult result = FindTexRef(name, &texBind);
	HANDLE_RESULT();

	SetSampler(texBind, sampler);

	result = cuTexRefSetArray(texBind->texRef, texture->Handle(), 0);
	HANDLE_RESULT();

	texBind->texture = texture;
	texBind->mem.reset();
	return CUDA_SUCCESS;
}



////////////////////////////////////////////////////////////////////////////////
// CuFunction

CUresult CreateCuFunction(const char* name, CuModule* module, int3 blockShape, 
	FunctionPtr* ppFunction) {
	CUfunction func;
	CUresult result = cuModuleGetFunction(&func, module->Handle(), name);
	if(CUDA_SUCCESS != result) return result;

	FunctionPtr f(new CuFunction);

	CuFuncAttr& attr = f->_attributes;
	cuFuncGetAttribute(&attr.maxThreadsPerBlock,
		CU_FUNC_ATTRIBUTE_MAX_THREADS_PER_BLOCK, func);
	cuFuncGetAttribute(&attr.sharedSizeBytes, 
		CU_FUNC_ATTRIBUTE_SHARED_SIZE_BYTES, func);
	cuFuncGetAttribute(&attr.constSizeBytes, 
		CU_FUNC_ATTRIBUTE_CONST_SIZE_BYTES, func);
	cuFuncGetAttribute(&attr.localSizeBytes, 
		CU_FUNC_ATTRIBUTE_LOCAL_SIZE_BYTES, func);
	cuFuncGetAttribute(&attr.numRegs, 
		CU_FUNC_ATTRIBUTE_NUM_REGS, func);
	cuFuncGetAttribute(&attr.ptxVersion, 
		CU_FUNC_ATTRIBUTE_PTX_VERSION, func);
	cuFuncGetAttribute(&attr.binaryVersion, 
		CU_FUNC_ATTRIBUTE_BINARY_VERSION, func);
	f->_function = func;
	f->_module = module;
	f->_functionName = name;
	f->_blockShape = blockShape;
	ppFunction->swap(f);
	return CUDA_SUCCESS;
}

CUresult CuFunction::Launch(int width, int height, CuCallStack& callStack) {
	if(!_blockShape.x) return CUDA_ERROR_INVALID_VALUE;

	CUresult result = cuLaunchKernel(_function, width, height, 1, _blockShape.x,
		_blockShape.y, _blockShape.z, 0, 0, 0, callStack.Extra());

	return result;
}

