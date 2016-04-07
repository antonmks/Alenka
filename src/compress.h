#ifndef COMPRESS_H_
#define COMPRESS_H_

#include <fstream>
#include <thrust/extrema.h>

#include "global.h"
#include "compress.cuh"
#include "cuda_safe.h"


size_t pfor_decompress(void* destination, void* host, void* d_v, void* s_v, string colname);
template< typename T>
void pfor_delta_compress(void* source, size_t source_len, string file_name, thrust::host_vector<T, pinned_allocator<T> >& host, bool tp);

template< typename T>
void pfor_compress(void* source, size_t source_len, string file_name, thrust::host_vector<T, pinned_allocator<T> >& host,  bool tp);


#endif /* COMPRESS_H_ */
