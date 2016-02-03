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
#include <iomanip>
#include <thrust/extrema.h>
#include "cm.h"

using namespace std;

//thrust::device_vector<unsigned char> scratch;
bool phase_copy = 0;
map<string, unsigned int> cnt_counts;
string curr_file;
map<string,bool> min_max_eq;


template<typename T>
struct type_to_int64
{
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
struct int64_to_type
{
    __host__ __device__
    unsigned int operator()(const int_type x)
    {
        return (T)x;
    }
};

template<typename T>
struct to_int64
{
    __host__ __device__
    int_type operator()(const T x)
    {
        return (int_type)x;
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

        unsigned long long int tmp = source[i/vals[1]]  >> (vals[2] - vals[0] - (i%vals[1])*vals[0]);
        // set  the rest of bits to 0
        tmp	= tmp << (vals[2] - vals[0]);
        tmp	= tmp >> (vals[2] - vals[0]);
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


size_t pfor_decompress(void* destination, void* host, void* d_v, void* s_v, string colname)
{
    unsigned int bit_count = 64;
    auto cnt = ((unsigned int*)host)[0];
	auto orig_upper_val = ((long long int*)((char*)host +12))[0]; 
    auto orig_recCount = ((unsigned int*)((char*)host + cnt))[7];
    auto bits = ((unsigned int*)((char*)host + cnt))[8];
    auto orig_lower_val = ((long long int*)((unsigned int*)((char*)host + cnt) + 9))[0];
    auto fit_count = ((unsigned int*)((char*)host + cnt))[11];
    auto start_val = ((long long int*)((unsigned int*)((char*)host + cnt) + 12))[0];
    auto comp_type = ((unsigned int*)host)[5];

    //cout << "Decomp Header " <<  orig_recCount << " " << bits << " " << orig_lower_val << " " << cnt << " " << fit_count << " " << comp_type << endl;
	//cout << colname << " " << orig_lower_val << " " << orig_upper_val << endl;
	if(orig_lower_val == orig_upper_val)
		min_max_eq[colname] = 1;
	else	
		min_max_eq[colname] = 0;
	
    if(scratch.size() < cnt) 
		scratch.resize(cnt);
		
    cudaMemcpy(thrust::raw_pointer_cast(scratch.data()), (void*)((unsigned int*)host + 6), cnt, cudaMemcpyHostToDevice);
    thrust::device_ptr<int_type> d_int((int_type*)destination);	

    if(comp_type == 1) {
        thrust::device_ptr<unsigned int> dd_v((unsigned int*)d_v);
        thrust::device_ptr<long long int> dd_sv((long long int*)s_v);

        dd_sv[0] = orig_lower_val;
        dd_v[0] = bits;
        dd_v[1] = fit_count;
        dd_v[2] = bit_count;

        thrust::counting_iterator<unsigned int> begin(0);
        decompress_functor_int ff1((const unsigned long long int *)thrust::raw_pointer_cast(scratch.data()),(int_type*)destination, (long long int*)s_v, (unsigned int*)d_v);
        thrust::for_each(begin, begin + orig_recCount, ff1);

        d_int[0] = start_val;
        thrust::inclusive_scan(d_int, d_int + orig_recCount, d_int);
    }
    else {
		if(!phase_copy) {
			thrust::device_vector<int_type> ad(1);
			ad[0] = orig_lower_val;
			thrust::counting_iterator<unsigned int> begin(0);
			if(bits == 8) {
				type_to_int64<unsigned char> ff1((const unsigned char *)thrust::raw_pointer_cast(scratch.data()),(int_type*)destination, thrust::raw_pointer_cast(ad.data()));
				thrust::for_each(begin, begin + orig_recCount, ff1);				
			}
			else if(bits == 16) {
				type_to_int64<unsigned short int> ff1((const unsigned short int *)thrust::raw_pointer_cast(scratch.data()),(int_type*)destination, thrust::raw_pointer_cast(ad.data()));
				thrust::for_each(begin, begin + orig_recCount, ff1);				
			}
			else if(bits == 32) {
				type_to_int64<unsigned int> ff1((const unsigned int *)thrust::raw_pointer_cast(scratch.data()),(int_type*)destination, thrust::raw_pointer_cast(ad.data()));
				thrust::for_each(begin, begin + orig_recCount, ff1);				
			}
			else {
				type_to_int64<long long int> ff1((const long long int *)thrust::raw_pointer_cast(scratch.data()),(int_type*)destination, thrust::raw_pointer_cast(ad.data()));
				thrust::for_each(begin, begin + orig_recCount, ff1);				
			};
		}
		else {
			cpy_bits[colname] = bits;
			cpy_init_val[colname] = orig_lower_val;
			if(bits == 8) {				
				thrust::device_ptr<unsigned char> dest((unsigned char*)destination);
				thrust::copy(scratch.begin(), scratch.begin()+orig_recCount, dest);
			}
			else if(bits == 16) {
				thrust::device_ptr<unsigned short int> src((unsigned short int*)thrust::raw_pointer_cast(scratch.data()));
				thrust::device_ptr<unsigned short int> dest((unsigned short int*)destination);
				thrust::copy(src, src+orig_recCount, dest);
			}
			else if(bits == 32) {
				thrust::device_ptr<unsigned int> src((unsigned int*)thrust::raw_pointer_cast(scratch.data()));
				thrust::device_ptr<unsigned int> dest((unsigned int*)destination);
				thrust::copy(src, src+orig_recCount, dest);			
			}
			else {
				thrust::device_ptr<int_type> src((int_type*)thrust::raw_pointer_cast(scratch.data()));
				thrust::copy(src, src+orig_recCount, d_int);
			};			
		};	
    };
    return orig_recCount;
}


template< typename T>
void pfor_delta_compress(void* source, size_t source_len, string file_name, thrust::host_vector<T, pinned_allocator<T> >& host, bool tp)
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
        //cout << "We need for delta " << file_name << " " << (unsigned int)ceil(log2((double)((orig_upper_val-orig_lower_val)+1))) << " bits to encode " <<  orig_upper_val-orig_lower_val << " values " << endl;
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
        //cout << "We need for delta " << file_name << " " << (unsigned int)ceil(log2((double)((orig_upper_val-orig_lower_val)+1))) << " bits to encode " << orig_upper_val-orig_lower_val << " values" << endl;
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

    // copy fin_seq to host
    unsigned long long int * raw_src = thrust::raw_pointer_cast(fin_seq);

    //cout << file_name << " CNT  " << cnt << " " << recCount << endl;
    cnt = cnt*8;

    cudaMemcpy( host.data(), (void *)raw_src, cnt, cudaMemcpyDeviceToHost);
    fstream binary_file(file_name.c_str(),ios::out|ios::binary|ios::trunc);
    binary_file.write((char *)&cnt, 4);
    binary_file.write((char *)&real_lower, 8);
    binary_file.write((char *)&real_upper, 8);
    binary_file.write((char *)&comp_type, 4);
    binary_file.write((char *)host.data(),cnt);
    binary_file.write((char *)&cnt, 4);
    binary_file.write((char *)&recCount, 4);
    binary_file.write((char *)&bits, 4);
    binary_file.write((char *)&orig_lower_val, 8);
    binary_file.write((char *)&fit_count, 4);
    binary_file.write((char *)&start_val, 8);
    binary_file.close();
    if(cnt_counts[curr_file] < cnt)
        cnt_counts[curr_file] = cnt;

    thrust::device_free(fin_seq);
    cudaFree(ss);
    cudaFree(d_v1);
    cudaFree(s_v1);
}


// non sorted compressed fields should have 1,2,4 or 8 byte values for direct operations on compressed values
template< typename T>
void pfor_compress(void* source, size_t source_len, string file_name, thrust::host_vector<T, pinned_allocator<T> >& host,  bool tp)
//void pfor_compress(void* source, size_t source_len, string file_name, thrust::host_vector<T>& host,  bool tp)
{
    unsigned int recCount = source_len/int_size;
    long long int orig_lower_val;
    long long int orig_upper_val;
    unsigned int  bits;
    unsigned int fit_count = 0;
    unsigned int comp_type = 0; // FOR
    long long int start_val = 0;
    bool sorted = 0;

    // check if sorted


    if(delta) {
        if (tp == 0) {
            thrust::device_ptr<int_type> s((int_type*)source);
            sorted = thrust::is_sorted(s, s+recCount);
        }
        else {
            recCount = source_len/float_size;
            thrust::device_ptr<long long int> s((long long int*)source);
            sorted = thrust::is_sorted(s, s+recCount);
        };
        //cout << "file " << file_name << " is sorted " << sorted << endl;

        if(sorted) {
            pfor_delta_compress(source, source_len, file_name, host, tp);
            return;
        };
    };


	//cout << "Recs " << recCount << endl;
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

    if (bits != 8 && bits != 16 && bits != 32 && bits != 64) {
        if(bits < 8)
            bits = 8;
        else if(bits < 16)
            bits = 16;
        else if(bits < 32)
            bits = 32;
        else if(bits < 64)
            bits = 64;
    };
    //cout << "We will really need " << bits << " for " << file_name << endl;

    unsigned int cnt;
    thrust::device_ptr<int_type> s((int_type*)source);
    thrust::constant_iterator<int_type> iter(orig_lower_val);
    thrust::transform(s, s+recCount, iter, s, thrust::minus<int_type>());

    thrust::device_vector<int8_type> d_columns_int8;
    thrust::device_vector<int16_type> d_columns_int16;
    thrust::device_vector<int32_type> d_columns_int32;
    if(bits == 8) {
        d_columns_int8.resize(recCount);
        thrust::transform(s, s+recCount, d_columns_int8.begin(), int64_to_type<int8_type>());
        cudaMemcpy( host.data(), thrust::raw_pointer_cast(d_columns_int8.data()), recCount, cudaMemcpyDeviceToHost);
        cnt = recCount;
    }
    else if(bits == 16) {
        d_columns_int16.resize(recCount);
        thrust::transform(s, s+recCount, d_columns_int16.begin(), int64_to_type<int16_type>());
        cudaMemcpy( host.data(), thrust::raw_pointer_cast(d_columns_int16.data()), recCount*2, cudaMemcpyDeviceToHost);
        cnt = recCount*2;
    }
    else if(bits == 32) {
        d_columns_int32.resize(recCount);
        thrust::transform(s, s+recCount, d_columns_int32.begin(), int64_to_type<int32_type>());
        cudaMemcpy( host.data(), thrust::raw_pointer_cast(d_columns_int32.data()), recCount*4, cudaMemcpyDeviceToHost);
        cnt = recCount*4;
    }
    else {
        cudaMemcpy( host.data(), (void*)source, recCount*8, cudaMemcpyDeviceToHost);
        cnt = recCount*8;
    };

    fit_count = 64/bits;

    
 //cout << "comp Header " <<  file_name << " " << recCount << " " << bits << " " << orig_lower_val << " " << cnt << " " << fit_count << " " << comp_type << " " << orig_upper_val << " " << start_val <<  endl;
    fstream binary_file(file_name.c_str(),ios::out|ios::binary|ios::trunc);
    binary_file.write((char *)&cnt, 4);
    binary_file.write((char *)&orig_lower_val, 8);
    binary_file.write((char *)&orig_upper_val, 8);
    binary_file.write((char *)&comp_type, 4);
    binary_file.write((char *)host.data(),cnt);
    binary_file.write((char *)&cnt, 4);
    binary_file.write((char *)&recCount, 4);
    binary_file.write((char *)&bits, 4);
    binary_file.write((char *)&orig_lower_val, 8);
    binary_file.write((char *)&fit_count, 4);
    binary_file.write((char *)&start_val, 8);
    binary_file.close();
    if(cnt_counts[curr_file] < cnt)
        cnt_counts[curr_file] = cnt;

}