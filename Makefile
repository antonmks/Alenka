alenka : bison.o join.o merge.o \
         MurmurHash2_64.o filter.o strings.o \
		 select.o zone_map.o itoa.o \
		 atof.o cucpp.o cm.o 
	/usr/local/cuda/bin/nvcc -O3 -arch=sm_20 -lcuda -o alenka bison.o join.o merge.o \
         MurmurHash2_64.o filter.o strings.o \
		 select.o zone_map.o itoa.o \
		 atof.o cm.o
		 
bison.o : bison.cu cm.h
	/usr/local/cuda/bin/nvcc -O3 -arch=sm_20 -c bison.cu
join.o : join.cu cm.h join.h
	/usr/local/cuda/bin/nvcc -O3 -arch=sm_20 -c join.cu
merge.o : merge.cu cm.h merge.h
	/usr/local/cuda/bin/nvcc -O3 -arch=sm_20 -c merge.cu
MurmurHash2_64.o : MurmurHash2_64.cu cm.h 
	/usr/local/cuda/bin/nvcc -O3 -arch=sm_20 -c MurmurHash2_64.cu
filter.o : filter.cu cm.h filter.h
	/usr/local/cuda/bin/nvcc -O3 -arch=sm_20 -c filter.cu
strings.o : strings.cu cm.h strings.h
	/usr/local/cuda/bin/nvcc -O3 -arch=sm_20 -c strings.cu
select.o : select.cu cm.h select.h
	/usr/local/cuda/bin/nvcc -O3 -arch=sm_20 -c select.cu
zone_map.o : zone_map.cu cm.h zone_map.h
	/usr/local/cuda/bin/nvcc -O3 -arch=sm_20 -c zone_map.cu
itoa.o : itoa.cu itoa.h
	/usr/local/cuda/bin/nvcc -O3 -arch=sm_20 -c itoa.cu
atof.o : atof.cu cm.h atof.h
	/usr/local/cuda/bin/nvcc -O3 -arch=sm_20 -c atof.cu 
cm.o : cm.cu cm.h	
	/usr/local/cuda/bin/nvcc -O3 -arch=sm_20 -c cm.cu
	
clean : del bison.o join.o merge.o \
         MurmurHash2_64.o filter.o strings.o \
		 select.o zone_map.o itoa.o \
		 atof.o cm.o