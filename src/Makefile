# Linux Makefile

#uncomment for redis data dictionary (SIMPLE or HA)
#REDIS_FLAGS=-I ../deps/redis3m/include/ -DDATADICT_REDIS_SIMPLE=1
#REDIS_LIBS=../deps/redis3m/libredis3m.a -lhiredis -lboost_regex
#REDIS_OBJ=datadict_redis_ha.o datadict_redis_simple.o

#uncomment for hdfs filesystem
#HDFS_FLAGS=-DFILESYSTEM_HDFS=1 
#HDFS_LIBS=-lhdfs
#HDFS_OBJ=filesystem_hdfs.o

#flags
CFLAGS=--machine 64 -O2 -g -std=c++11 --expt-extended-lambda --compiler-options '-fPIC' -I ../deps/ -I ../include/ $(REDIS_FLAGS) $(HDFS_FLAGS)

#compute compatibility (https://developer.nvidia.com/cuda-gpus])
GENCODE_SM30	:= -gencode arch=compute_30,code=sm_30
#GENCODE_SM35	:= -gencode arch=compute_35,code=sm_35
#GENCODE_SM50	:= -gencode arch=compute_50,code=sm_50
GENCODE_FLAGS	:= $(GENCODE_SM30) $(GENCODE_SM35) $(GENCODE_SM50)

#alenka binary
alenka : libalenka.a main.o
	nvcc $(CFLAGS) -L . $< $(REDIS_LIBS) $(HDFS_LIBS) -o $@ main.o

#static library
libalenka.a : alenka.o callbacks.o common.o compress.o cudaset.o datadict_local.o \
		 $(REDIS_OBJ) $(HDFS_OBJ) filesystem_local.o filter.o global.o merge.o murmurhash2_64.o \
		 operators.o select.o sorts.o strings_join.o strings_sort_host.o strings_sort_device.o zone_map.o	 
	ar rcs $@ $^

#shared library
libalenka.so : alenka.o callbacks.o common.o compress.o cudaset.o datadict_local.o \
		 $(REDIS_OBJ) $(HDFS_OBJ) filesystem_local.o filter.o global.o merge.o murmurhash2_64.o \
		 operators.o select.o sorts.o strings_join.o strings_sort_host.o strings_sort_device.o zone_map.o	 
	nvcc -o libalenka.so --shared $^

#alenka objects
nvcc = nvcc $(CFLAGS) $(GENCODE_FLAGS)
alenka.o : alenka.cu lex.yy.c
	$(nvcc) -c $< -o $@
callbacks.o : callbacks.cpp
	$(nvcc) -c $< -o $@
common.o : common.cu
	$(nvcc) -c $< -o $@
compress.o : compress.cu
	$(nvcc) -c $< -o $@
cudaset.o : cudaset.cu
	$(nvcc) -c $< -o $@
datadict_local.o : datadict_local.cpp
	$(nvcc) -c $< -o $@
datadict_redis_ha.o : datadict_redis_ha.cpp
	$(nvcc) -c $< -o $@
datadict_redis_simple.o : datadict_redis_simple.cpp
	$(nvcc) -c $< -o $@
filesystem_local.o : filesystem_local.cpp
	$(nvcc) -c $< -o $@
filesystem_hdfs.o : filesystem_hdfs.cpp
	$(nvcc) -c $< -o $@
filter.o : filter.cu
	$(nvcc) -c $< -o $@
global.o : global.cu
	$(nvcc) -c $< -o $@
main.o : main.cu
	$(nvcc) -c $< -o $@
merge.o : merge.cu
	$(nvcc) -c $< -o $@
murmurhash2_64.o : murmurhash2_64.cpp
	$(nvcc) -c $< -o $@
operators.o : operators.cu
	$(nvcc) -c $< -o $@
select.o : select.cu
	$(nvcc) -c $< -o $@
sorts.o : sorts.cu
	$(nvcc) -c $< -o $@
strings_join.o : strings_join.cu
	$(nvcc) -c $< -o $@
strings_sort_device.o : strings_sort_device.cu
	$(nvcc) -c $< -o $@
strings_sort_host.o : strings_sort_host.cpp
	$(nvcc) -c $< -o $@
zone_map.o : zone_map.cu
	$(nvcc) -c $< -o $@

#bison / flex generation
alenka.cu alenka.hu: alenka.ypp
	bison -d -o $@ $<
lex.yy.c: alenka.l alenka.hu
	flex $<

#clean up all generated files
.PHONY: clean
clean : 
	rm -f alenka *.o lex.yy.c alenka.cu alenka.hu *.a *.so
	
#install binary + libs + header
PREFIX = /usr/local
.PHONY: install
install: alenka libalenka.a libalenka.so
	mkdir -p $(DESTDIR)$(PREFIX)/bin
	cp $< $(DESTDIR)$(PREFIX)/bin/alenka
	mkdir -p $(DESTDIR)$(PREFIX)/lib
	mkdir -p $(DESTDIR)$(PREFIX)/include
	cp libalenka.a $(DESTDIR)$(PREFIX)/lib64/
	cp libalenka.so $(DESTDIR)$(PREFIX)/lib64/
	cp ../include/alenka.h $(DESTDIR)$(PREFIX)/include/

.PHONY: uninstall
uninstall:
	rm -f $(DESTDIR)$(PREFIX)/bin/alenka
	rm -f $(DESTDIR)$(PREFIX)/lib64/libalenka.a
	rm -f $(DESTDIR)$(PREFIX)/lib64/libalenka.so
	rm -f $(DESTDIR)$(PREFIX)/include/alenka.h
