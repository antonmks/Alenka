/*
 *  Licensed under the Apache License, Version 2.0 (the "License");
 *  you may not use this file except in compliance with the License.
 *  You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 *  Unless required by applicable law or agreed to in writing, software
 *  distributed under the License is distributed on an "AS IS" BASIS,
 *  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 *  See the License for the specific language governing permissions and
 *  limitations under the License.
 */

#ifndef COMPRESS
#define COMPRESS

#include <string>
#include <fstream>
#include <stdio.h>
#include <iomanip>
#include <thrust/extrema.h>
#include "global.h"
#include "cuda_safe.h"

namespace alenka {

template<typename T>
struct type_to_int64 {
	const T *source;
    long long int *dest;
	long long int *ad;

	type_to_int64(const T* _source, long long int *_dest, long long int *_ad):
			  source(_source), dest(_dest), ad(_ad) {}
    template <typename IndexType>
    __host__ __device__
    void operator()(const IndexType & i) {
		dest[i] = (int_type)source[i] + ad[0];
	}
};

template<typename T>
struct int64_to_type {
    __host__ __device__
    unsigned int operator()(const int_type x) {
        return (T)x;
    }
};

template<typename T>
struct to_int64 {
    __host__ __device__
    int_type operator()(const T x) {
        return (int_type)x;
    }
};

struct compress_functor_int {
    const int_type * source;
    unsigned long long int * dest;
    const long long int * start_val;
    const unsigned int * vals;

    compress_functor_int(const int_type * _source, unsigned long long int  * _dest,
                         const long long int * _start_val, const unsigned int * _vals):
        source(_source), dest(_dest), start_val(_start_val), vals(_vals) {}

    template <typename IndexType>
    __host__ __device__
    void operator()(const IndexType & i) {
        long long int val = source[i] - start_val[0];
        unsigned int shifted = vals[2] - vals[0] - (i%vals[1])*vals[0];
        dest[i] = val << shifted;
    }
};

struct compress_functor_float {
    const long long int * source;
    unsigned long long int * dest;
    const long long int * start_val;
    const unsigned int * vals;

    compress_functor_float(const long long int * _source, unsigned long long int  * _dest,
                           const long long int * _start_val, const unsigned int * _vals):
        source(_source), dest(_dest), start_val(_start_val), vals(_vals) {}

    template <typename IndexType>
    __host__ __device__
    void operator()(const IndexType & i) {
        long long int val;

        unsigned int bits = vals[0];
        unsigned int fit_count = vals[1];
        unsigned int int_sz = vals[2];

        val = source[i] - start_val[0];
        unsigned int z = i%fit_count;

        unsigned int shifted = int_sz - bits - z*bits;
        dest[i] = val << shifted;
    }
};

struct decompress_functor_int {
    const unsigned long long int * source;
    int_type * dest;
    const long long int * start_val;
    const unsigned int * vals;

    decompress_functor_int(const unsigned long long int * _source, int_type * _dest,
                           const long long int * _start_val, const unsigned int * _vals):
        source(_source), dest(_dest), start_val(_start_val), vals(_vals) {}

    template <typename IndexType>
    __host__ __device__
    void operator()(const IndexType & i) {
        unsigned long long int tmp = source[i/vals[1]]  >> (vals[2] - vals[0] - (i%vals[1])*vals[0]);
        // set  the rest of bits to 0
        tmp	= tmp << (vals[2] - vals[0]);
        tmp	= tmp >> (vals[2] - vals[0]);
        dest[i] = tmp + start_val[0];
    }
};

struct decompress_functor_str {
    const unsigned long long  * source;
    unsigned int * dest;
    const unsigned int * vals;

    decompress_functor_str(const unsigned long long int * _source, unsigned int * _dest,
                           const unsigned int * _vals):
        source(_source), dest(_dest), vals(_vals) {}

    template <typename IndexType>
    __host__ __device__
    void operator()(const IndexType & i) {
        unsigned int bits = vals[0];
        unsigned int fit_count = vals[1];
        unsigned int int_sz = 64;

        //find the source index
        unsigned int src_idx = i/fit_count;
        // find the exact location
        unsigned int src_loc = i%fit_count;
        //right shift the values
        unsigned int shifted = ((fit_count-src_loc)-1)*bits;
        unsigned long long int tmp = source[src_idx]  >> shifted;
        // set  the rest of bits to 0
        tmp	= tmp << (int_sz - bits);
        tmp	= tmp >> (int_sz - bits);
        dest[i] = tmp;
    }
};

size_t pfor_decompress(void* destination, void* host, void* d_v, void* s_v, string colname);

} // namespace alenka

#define COMPRESS_FUNCTIONS
#include "../src/compress.cu"

#endif


