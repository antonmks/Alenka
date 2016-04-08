# Makefile
#
# The -D below may have to change to /D on some dos compilers
CFLAGS=--machine 64 -O3 -std=c++11 -I moderngpu/include/

GENCODE_SM30	:= -gencode arch=compute_30,code=sm_30
GENCODE_SM35	:= -gencode arch=compute_35,code=sm_35
GENCODE_SM50	:= -gencode arch=compute_50,code=sm_50
GENCODE_FLAGS	:= $(GENCODE_SM30) $(GENCODE_SM35) $(GENCODE_SM50)

nvcc = nvcc $(CFLAGS) $(GENCODE_FLAGS) -c

alenka : alenka.o callbacks.o common.o compress.o CudaSet.o filter.o global.o main.o \
 		 merge.o mgpucontext.o mgpuutil.o MurmurHash2_64.o operators.o select.o sorts.o \
		 strings_join.o strings_sort_host.o strings_sort_device.o \
		 zone_map.o

	nvcc $(CFLAGS) -L . mgpucontext.o mgpuutil.o -o alenka  \
		 alenka.o callbacks.o common.o compress.o CudaSet.o filter.o global.o main.o \
		 merge.o MurmurHash2_64.o operators.o select.o sorts.o \
		 strings_join.o strings_sort_host.o strings_sort_device.o \
		 zone_map.o

alenka.o : alenka.cu lex.yy.c
	$(nvcc) alenka.cu
alenka.cu alenka.hu: alenka.ypp
	bison -d -o alenka.cu alenka.ypp
lex.yy.c: alenka.l alenka.hu
	flex alenka.l
callbacks.o : callbacks.cpp callbacks.h
	$(nvcc) callbacks.cpp	
common.o : common.cu common.h
	$(nvcc) common.cu		
compress.o : compress.cu
	$(nvcc) compress.cu
CudaSet.o : CudaSet.cu CudaSet.h
	$(nvcc) CudaSet.cu	
filter.o : filter.cu filter.h
	$(nvcc) filter.cu	
global.o : global.cu global.h
	$(nvcc) global.cu		
main.o : main.cu
	$(nvcc) main.cu
merge.o : merge.cu merge.h
	$(nvcc) merge.cu	
mgpucontext.o : moderngpu/src/mgpucontext.cu
	$(nvcc) -I moderngpu/include/ moderngpu/src/mgpucontext.cu
mgpuutil.o : moderngpu/src/mgpuutil.cpp
	$(nvcc) -I moderngpu/include/ moderngpu/src/mgpuutil.cpp	
MurmurHash2_64.o : MurmurHash2_64.cpp
	$(nvcc) MurmurHash2_64.cpp	
operators.o : operators.cu operators.h 
	$(nvcc) operators.cu
select.o : select.cu select.h 
	$(nvcc) select.cu
sorts.o : sorts.cu sorts.cuh 
	$(nvcc) sorts.cu
strings_join.o : strings_join.cu strings_type.cuh
	$(nvcc) strings_join.cu
strings_sort_device.o : strings_sort_device.cu strings_type.cuh
	$(nvcc) strings_sort_device.cu
strings_sort_host.o : strings_sort_host.cpp strings_type.cuh
	$(nvcc) strings_sort_host.cpp
zone_map.o : zone_map.cu zone_map.h
	$(nvcc) zone_map.cu
	
clean : 
	$(RM) alenka *.o lex.yy.c alenka.cu alenka.hu
