# Makefile
#
# The -D below may have to change to /D on some dos compilers
CFLAGS=--machine 64 -O3 -std=c++11 -I moderngpu/include/

GENCODE_SM30	:= -gencode arch=compute_30,code=sm_30
GENCODE_SM35	:= -gencode arch=compute_35,code=sm_35
GENCODE_SM50	:= -gencode arch=compute_50,code=sm_50
GENCODE_FLAGS	:= $(GENCODE_SM30) $(GENCODE_SM35) $(GENCODE_SM50)

alenka : bison.o merge.o \
         MurmurHash2_64.o filter.o \
		 strings_join.o strings_sort_host.o strings_sort_device.o \
		 select.o zone_map.o atof.o cm.o mgpucontext.o callbacks.o main.o operators.o

	nvcc $(CFLAGS) -L . mgpucontext.o mgpuutil.o -o alenka bison.o merge.o \
		 MurmurHash2_64.o filter.o \
		 strings_join.o strings_sort_host.o strings_sort_device.o \
		 select.o zone_map.o atof.o cm.o \
		 callbacks.o main.o	operators.o	 

nvcc = nvcc $(CFLAGS) $(GENCODE_FLAGS) -c

operators.o : operators.cu operators.h 
	$(nvcc) operators.cu
callbacks.o : callbacks.c callbacks.h
	$(nvcc) callbacks.c
main.o : main.cu
	$(nvcc) main.cu
cm.o : cm.cu cm.h	
	$(nvcc) cm.cu
bison.o : bison.cu cm.h sorts.cu
	$(nvcc) -I moderngpu/include/ bison.cu
merge.o : merge.cu cm.h merge.h
	$(nvcc) merge.cu
MurmurHash2_64.o : MurmurHash2_64.cu cm.h 
	$(nvcc) MurmurHash2_64.cu
filter.o : filter.cu cm.h filter.h
	$(nvcc) filter.cu
strings_join.o : strings_join.cu strings.h strings_type.h
	$(nvcc) strings_join.cu
strings_sort_host.o : strings_sort_host.cu strings.h strings_type.h
	$(nvcc) strings_sort_host.cu
strings_sort_device.o : strings_sort_device.cu strings.h strings_type.h
	$(nvcc) strings_sort_device.cu
select.o : select.cu cm.h select.h
	$(nvcc) select.cu
zone_map.o : zone_map.cu cm.h zone_map.h
	$(nvcc) zone_map.cu
atof.o : atof.cu cm.h atof.h
	$(nvcc) atof.cu 
mgpucontext.o : moderngpu/src/mgpucontext.cu 	
	$(nvcc) -I moderngpu/include/ moderngpu/src/mgpucontext.cu moderngpu/src/mgpuutil.cpp
	
clean : 
	$(RM) alenka *.o