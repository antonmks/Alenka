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


// PFOR and PFOR-DELTA Compression and decompression routines

#include <stdio.h>
#include <fstream>
#include <iomanip>
#include <exception>
#include <thrust/device_vector.h>
#include <thrust/iterator/discard_iterator.h>
#include <thrust/extrema.h>
#include "cm.h"

using namespace std;

unsigned long long int* raw_decomp = NULL;
unsigned int raw_decomp_length = 0;

std::map<string, unsigned int> cnt_counts;
string curr_file;


struct bool_to_int
{
    __host__ __device__
    unsigned int operator()(const bool x)
    {
        return (unsigned int)x;
    }
};

struct ui_to_ll
{
    __host__ __device__
    long long int operator()(const unsigned int x)
    {
        return (long long int)x;
    }
};


struct compress_functor_int
{

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

struct compress_functor_float
{

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



struct decompress_functor_int
{

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


        unsigned int bits = vals[0];
        unsigned int fit_count = vals[1];
        unsigned int int_sz = vals[2];

        //find the source index
        unsigned int src_idx = i/fit_count;
        // find the exact location
        unsigned int src_loc = i%fit_count;
        //right shift the values
        unsigned int shifted = int_sz - bits - src_loc*bits;
        unsigned long long int tmp = source[src_idx]  >> shifted;
        // set  the rest of bits to 0
        tmp	= tmp << (int_sz - bits);
        tmp	= tmp >> (int_sz - bits);

        dest[i] = tmp + start_val[0];

    }
};


struct decompress_functor_float
{

    const unsigned long long int * source;
    long long int * dest;
    const long long int * start_val;
    const unsigned int * vals;


    decompress_functor_float(const unsigned long long int * _source, long long int * _dest,
                             const long long int * _start_val, const unsigned int * _vals):
        source(_source), dest(_dest), start_val(_start_val), vals(_vals) {}

    template <typename IndexType>
    __host__ __device__
    void operator()(const IndexType & i) {


        unsigned int bits = vals[0];
        unsigned int fit_count = vals[1];
        unsigned int int_sz = vals[2];

        //find the source index
        unsigned int src_idx = i/fit_count;
        // find the exact location
        unsigned int src_loc = i%fit_count;
        //right shift the values
        unsigned int shifted = int_sz - bits - src_loc*bits;
        unsigned long long int tmp = source[src_idx]  >> shifted;
        // set  the rest of bits to 0
        tmp	= tmp << (int_sz - bits);
        tmp	= tmp >> (int_sz - bits);

        dest[i] = tmp + start_val[0];

    }
};


struct decompress_functor_str
{

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




unsigned int pfor_decompress(void* destination, void* host, void* d_v, void* s_v)
{

    unsigned int bits, cnt, fit_count, orig_recCount;
    long long int  orig_lower_val;
    unsigned int bit_count = 64;
    unsigned int comp_type;
    long long int start_val;

    cnt = ((unsigned int*)host)[0];
    orig_recCount = ((unsigned int*)host + cnt*2)[7];
    bits = ((unsigned int*)host + cnt*2)[8];
    orig_lower_val = ((long long int*)((unsigned int*)host + cnt*2 + 9))[0];
    fit_count = ((unsigned int*)host + cnt*2)[11];
    start_val = ((long long int*)((unsigned int*)host + cnt*2 + 12))[0];
    comp_type = ((unsigned int*)host + cnt*2)[14];

    //*mRecCount = orig_recCount;

    //cout << "Decomp Header " <<  orig_recCount << " " << bits << " " << orig_lower_val << " " << cnt << " " << fit_count << " " << comp_type << endl;


    if(raw_decomp_length < cnt*8) {
        if(raw_decomp != NULL) {
            cudaFree(raw_decomp);
        };
        cudaMalloc((void **) &raw_decomp, cnt*8);
        raw_decomp_length = cnt*8;
    };

    cudaMemcpy( (void*)raw_decomp, (void*)((unsigned int*)host + 5), cnt*8, cudaMemcpyHostToDevice);
    thrust::device_ptr<unsigned int> dd_v((unsigned int*)d_v);
    thrust::device_ptr<long long int> dd_sv((long long int*)s_v);

    dd_sv[0] = orig_lower_val;
    dd_v[0] = bits;
    dd_v[1] = fit_count;
    dd_v[2] = bit_count;
	
    thrust::counting_iterator<unsigned int> begin(0);
    decompress_functor_int ff1(raw_decomp,(int_type*)destination, (long long int*)s_v, (unsigned int*)d_v);
    thrust::for_each(begin, begin + orig_recCount, ff1);
    if(comp_type == 1) {
        thrust::device_ptr<int_type> d_int((int_type*)destination);
        d_int[0] = start_val;
        thrust::inclusive_scan(d_int, d_int + orig_recCount, d_int);
    };
    return orig_recCount;
}


template< typename T>
unsigned long long int pfor_delta_compress(void* source, unsigned int source_len, char* file_name, thrust::host_vector<T, pinned_allocator<T> >& host, bool tp, unsigned long long int sz)
{
    long long int orig_lower_val, orig_upper_val, start_val, real_lower, real_upper;
    unsigned int  bits, recCount;
    unsigned int bit_count = 8*8;
    unsigned int fit_count;
    unsigned int comp_type = 1; // FOR-DELTA

    if(tp == 0)
        recCount = source_len/int_size;
    else
        recCount = source_len/float_size;

    void* ss;
    CUDA_SAFE_CALL(cudaMalloc((void **) &ss, recCount*float_size));


    if (tp == 0) {
        thrust::device_ptr<int_type> s((int_type*)source);
        thrust::device_ptr<int_type> d_ss((int_type*)ss);
        thrust::adjacent_difference(s, s+recCount, d_ss);

        start_val = d_ss[0];
        if(recCount > 1)
            d_ss[0] = d_ss[1];

        orig_lower_val = *(thrust::min_element(d_ss, d_ss + recCount));
        orig_upper_val = *(thrust::max_element(d_ss, d_ss + recCount));

        real_lower = s[0];
        real_upper = s[recCount-1];
        //cout << "orig " << orig_upper_val << " " <<  orig_lower_val << endl;
        //cout << "We need for delta " << (unsigned int)ceil(log2((double)((orig_upper_val-orig_lower_val)+1))) << " bits to encode " <<  orig_upper_val-orig_lower_val << " values " << endl;
        bits = (unsigned int)ceil(log2((double)((orig_upper_val-orig_lower_val)+1)));
        if (bits == 0)
            bits = 1;

    }
    else {
        thrust::device_ptr<long long int> s((long long int*)source);
        thrust::device_ptr<long long int> d_ss((long long int*)ss);
        thrust::adjacent_difference(s, s+recCount, d_ss);
        start_val = d_ss[0];
        if(recCount > 1)
            d_ss[0] = d_ss[1];

        orig_lower_val = *(thrust::min_element(d_ss, d_ss + recCount));
        orig_upper_val = *(thrust::max_element(d_ss, d_ss + recCount));
        real_lower = s[0];
        real_upper = s[recCount-1];

        //cout << "orig " << orig_upper_val << " " <<  orig_lower_val << endl;
        //cout << "We need for delta " << (unsigned int)ceil(log2((double)((orig_upper_val-orig_lower_val)+1))) << " bits to encode " << orig_upper_val-orig_lower_val << " values" << endl;
        bits = (unsigned int)ceil(log2((double)((orig_upper_val-orig_lower_val)+1)));
        if (bits == 0)
            bits = 1;
    };

    thrust::counting_iterator<unsigned int> begin(0);

    fit_count = bit_count/bits;
    void* d_v1;
    CUDA_SAFE_CALL(cudaMalloc((void **) &d_v1, 12));
    thrust::device_ptr<unsigned int> dd_v((unsigned int*)d_v1);

    void* s_v1;
    CUDA_SAFE_CALL(cudaMalloc((void **) &s_v1, 8));
    thrust::device_ptr<long long int> dd_sv((long long int*)s_v1);

    dd_sv[0] = orig_lower_val;
    dd_v[0] = bits;
    dd_v[1] = fit_count;
    dd_v[2] = bit_count;


    //void* d;
    //CUDA_SAFE_CALL(cudaMalloc((void **) &d, recCount*float_size));

    thrust::device_ptr<char> dd((char*)source);
    thrust::fill(dd, dd+source_len,0);

    //cout << "FF " << orig_lower_val << " " << bits << " " << fit_count << " " << bit_count << endl;

    if (tp == 0) {
        compress_functor_int ff((int_type*)ss,(unsigned long long int*)source, (long long int*)s_v1, (unsigned int*)d_v1);
        thrust::for_each(begin, begin + recCount, ff);
    }
    else {
        compress_functor_float ff((long long int*)ss,(unsigned long long int*)source, (long long int*)s_v1, (unsigned int*)d_v1);
        thrust::for_each(begin, begin + recCount, ff);
    };


    thrust::device_ptr<unsigned long long int> s_copy1((unsigned long long int*)source);

    // make an addition  sequence

    thrust::device_ptr<unsigned long long int> add_seq((unsigned long long int*)ss);
    thrust::constant_iterator<unsigned long long int> iter(fit_count);
    thrust::sequence(add_seq, add_seq + recCount, 0, 1);
    thrust::transform(add_seq, add_seq + recCount, iter, add_seq, thrust::divides<unsigned long long int>());

    unsigned int cnt = (recCount)/fit_count;
    if (recCount%fit_count > 0)
        cnt++;

    thrust::device_ptr<unsigned long long int> fin_seq = thrust::device_malloc<unsigned long long int>(cnt);

    thrust::reduce_by_key(add_seq, add_seq+recCount,s_copy1,thrust::make_discard_iterator(),
                          fin_seq);

    //for(int i = 0; i < 10;i++)
    //  cout << "FIN " << fin_seq[i] << endl;

    // copy fin_seq to host
    unsigned long long int * raw_src = thrust::raw_pointer_cast(fin_seq);

    if(file_name) {
        cudaMemcpy( host.data(), (void *)raw_src, cnt*8, cudaMemcpyDeviceToHost);
        fstream binary_file(file_name,ios::out|ios::binary|ios::app);
        binary_file.write((char *)&cnt, 4);
        binary_file.write((char *)&real_lower, 8);
        binary_file.write((char *)&real_upper, 8);
        binary_file.write((char *)host.data(),cnt*8);
        binary_file.write((char *)&comp_type, 4);
        binary_file.write((char *)&cnt, 4);
        binary_file.write((char *)&recCount, 4);
        binary_file.write((char *)&bits, 4);
        binary_file.write((char *)&orig_lower_val, 8);
        binary_file.write((char *)&fit_count, 4);
        binary_file.write((char *)&start_val, 8);
        binary_file.write((char *)&comp_type, 4);
        binary_file.write((char *)&comp_type, 4); //filler
        binary_file.close();
        if(cnt_counts[curr_file] < cnt)
            cnt_counts[curr_file] = cnt;
    }
    else {
        char* hh;
        //resize_compressed(host, sz, cnt*8 + 15*4, 0);
        host.resize(sz+cnt+8);
        hh = (char*)(host.data() + sz);
        ((unsigned int*)hh)[0] = cnt;
        ((long long int*)(hh+4))[0] = real_lower;
        ((long long int*)(hh+12))[0] = real_upper;
        cudaMemcpy( hh + 20, (void *)raw_src, cnt*8, cudaMemcpyDeviceToHost);
        ((unsigned int*)hh)[5+cnt*2] = comp_type;
        ((unsigned int*)hh)[6+cnt*2] = cnt;
        ((unsigned int*)hh)[7+cnt*2] = recCount;
        ((unsigned int*)hh)[8+cnt*2] = bits;
        ((long long int*)((char*)hh+36+cnt*8))[0] = orig_lower_val;
        ((unsigned int*)hh)[11+cnt*2] = fit_count;
        ((long long int*)((char*)hh+48+cnt*8))[0] = start_val;
        ((unsigned int*)hh)[14+cnt*2] = comp_type;
    };

    thrust::device_free(fin_seq);
    cudaFree(ss);
    cudaFree(d_v1);
    cudaFree(s_v1);
    return sz + cnt + 8;
}


template< typename T>
unsigned long long int pfor_compress(void* source, unsigned int source_len, char* file_name, thrust::host_vector<T, pinned_allocator<T> >& host,  bool tp, unsigned long long int sz)
{
    unsigned int recCount;
    long long int orig_lower_val;
    long long int orig_upper_val;
    unsigned int  bits;
    unsigned int bit_count = 8*8;
    unsigned int fit_count;
    unsigned int comp_type = 0; // FOR
    long long int start_val = 0;
    bool sorted = 0;

    // check if sorted

    if (tp == 0) {
	    recCount = source_len/int_size;
        thrust::device_ptr<int_type> s((int_type*)source);
        sorted = thrust::is_sorted(s, s+recCount-1);
    }
    else {
	    recCount = source_len/float_size;
        thrust::device_ptr<long long int> s((long long int*)source);
        sorted = thrust::is_sorted(s, s+recCount);
    };
    //cout << "file " << file_name << " is sorted " << sorted << endl;

    if(sorted)
        return pfor_delta_compress(source, source_len, file_name, host, tp, sz);

// sort the sequence

    if (tp == 0) {
        thrust::device_ptr<int_type> s((int_type*)source);

        orig_lower_val = *(thrust::min_element(s, s + recCount));
        orig_upper_val = *(thrust::max_element(s, s + recCount));

        //cout << "We need " << (unsigned int)ceil(log2((double)((orig_upper_val - orig_lower_val) + 1))) << " bits to encode original range of " << orig_lower_val << " to " << orig_upper_val << endl;
        bits = (unsigned int)ceil(log2((double)((orig_upper_val - orig_lower_val) + 1)));
    }
    else {
	     
        thrust::device_ptr<long long int> s((long long int*)source);
	
        orig_lower_val = *(thrust::min_element(s, s + recCount));
        orig_upper_val = *(thrust::max_element(s, s + recCount));		
		
        //cout << "We need " << (unsigned int)ceil(log2((double)((orig_upper_val - orig_lower_val) + 1))) << " bits to encode original range of " << orig_lower_val << " to " << orig_upper_val << endl;
        bits = (unsigned int)ceil(log2((double)((orig_upper_val - orig_lower_val) + 1)));
    };

    thrust::counting_iterator<unsigned int> begin(0);

    fit_count = bit_count/bits;
    void* d_v1;
    CUDA_SAFE_CALL(cudaMalloc((void **) &d_v1, 12));
    thrust::device_ptr<unsigned int> dd_v((unsigned int*)d_v1);

    void* s_v1;
    CUDA_SAFE_CALL(cudaMalloc((void **) &s_v1, 8));
    thrust::device_ptr<long long int> dd_sv((long long int*)s_v1);

    dd_sv[0] = orig_lower_val;
    dd_v[0] = bits;
    dd_v[1] = fit_count;
    dd_v[2] = bit_count;

    void* d;
    CUDA_SAFE_CALL(cudaMalloc((void **) &d, recCount*float_size));
    thrust::device_ptr<char> dd((char*)d);
    thrust::fill(dd, dd+source_len,0);

    if (tp == 0) {
        compress_functor_int ff((int_type*)source,(unsigned long long int*)d, (long long int*)s_v1, (unsigned int*)d_v1);
        thrust::for_each(begin, begin + recCount, ff);
    }
    else {
        compress_functor_float ff((long long int*)source,(unsigned long long int*)d, (long long int*)s_v1, (unsigned int*)d_v1);
        thrust::for_each(begin, begin + recCount, ff);
    };


    thrust::device_ptr<unsigned long long int> s_copy1((unsigned long long int*)d);

    // make an addition  sequence
    thrust::device_ptr<unsigned int> add_seq = thrust::device_malloc<unsigned int>(recCount);
    thrust::constant_iterator<unsigned int> iter(fit_count);
    thrust::sequence(add_seq, add_seq + recCount, 0, 1);
    thrust::transform(add_seq, add_seq + recCount, iter, add_seq, thrust::divides<unsigned int>());

    unsigned int cnt = (recCount)/fit_count;
    if(cnt == 0)
        cnt = 1; // need at least 1

    if (recCount%fit_count > 0)
        cnt++;

    //thrust::device_ptr<unsigned long long int> fin_seq = thrust::device_malloc<unsigned long long int>(cnt);
    thrust::device_ptr<unsigned long long int> fin_seq((unsigned long long int*)source);

    thrust::reduce_by_key(add_seq, add_seq+recCount,s_copy1,thrust::make_discard_iterator(),
                          fin_seq);

    // copy fin_seq to host
    unsigned long long int * raw_src = thrust::raw_pointer_cast(fin_seq);

    //cout << file_name << " CNT  " << cnt << endl;

    if(file_name) {
        cudaMemcpy( host.data(), (void *)raw_src, cnt*8, cudaMemcpyDeviceToHost);
        fstream binary_file(file_name,ios::out|ios::binary|ios::app);
        binary_file.write((char *)&cnt, 4);
        binary_file.write((char *)&orig_lower_val, 8);
        binary_file.write((char *)&orig_upper_val, 8);
        binary_file.write((char *)host.data(),cnt*8);
        binary_file.write((char *)&comp_type, 4);
        binary_file.write((char *)&cnt, 4);
        binary_file.write((char *)&recCount, 4);
        binary_file.write((char *)&bits, 4);
        binary_file.write((char *)&orig_lower_val, 8);
        binary_file.write((char *)&fit_count, 4);
        binary_file.write((char *)&start_val, 8);
        binary_file.write((char *)&comp_type, 4);
        binary_file.write((char *)&comp_type, 4); //filler
        binary_file.close();
        if(cnt_counts[curr_file] < cnt)
            cnt_counts[curr_file] = cnt;
    }
    else {
        char* hh;
        // resize host to sz + cnt*8 + 15
        host.resize(sz+cnt+8);
        hh = (char*)(host.data() + sz);
        ((unsigned int*)hh)[0] = cnt;
        ((long long int*)(hh+4))[0] = orig_lower_val;
        ((long long int*)(hh+12))[0] = orig_upper_val;
        cudaMemcpy( hh + 20, (void *)raw_src, cnt*8, cudaMemcpyDeviceToHost);
        ((unsigned int*)hh)[5+cnt*2] = comp_type;
        ((unsigned int*)hh)[6+cnt*2] = cnt;
        ((unsigned int*)hh)[7+cnt*2] = recCount;
        ((unsigned int*)hh)[8+cnt*2] = bits;
        ((long long int*)(hh+36+cnt*8))[0] = orig_lower_val;
        ((unsigned int*)hh)[11+cnt*2] = fit_count;
        ((long long int*)(hh+48+cnt*8))[0] = start_val;
        ((unsigned int*)hh)[14+cnt*2] = comp_type;
    };

    thrust::device_free(add_seq);
    cudaFree(d);
    cudaFree(d_v1);
    cudaFree(s_v1);
    return sz + cnt + 8;
}