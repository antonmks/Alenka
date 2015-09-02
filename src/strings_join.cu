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


#include "strings.h"
#include "strings_type.h"


template<unsigned int len>
struct T_str_scatter_host {
    inline void operator()(const unsigned int* d_int, const size_t real_count, void* d, void* d_char) {
        thrust::scatter((Str<len> *)d, (Str<len> *)d + real_count, d_int, (Str<len> *)d_char);
    }
};

/// JOIN on host static strings
void str_scatter_host(const unsigned int* d_int, const size_t real_count, void* d, void* d_char, const unsigned int len)
{
    T_unroll_functor<UNROLL_COUNT, T_str_scatter_host> str_scatter_host_functor;
    if (str_scatter_host_functor(d_int, real_count, d, d_char, len)) {}
}

/// JOIN on host static strings (functor)
template<unsigned int len>
struct T_str_gather_host {
	inline void operator()(const unsigned int* d_int, const size_t real_count, void* d, void* d_char) {
		thrust::gather(d_int, d_int + real_count, (Str<len> *)d, (Str<len> *)d_char);
	}
};

/// JOIN on host static strings
void str_gather_host(const unsigned int* d_int, const size_t real_count, void* d, void* d_char, const unsigned int len)
{
	T_unroll_functor<UNROLL_COUNT, T_str_gather_host> str_gather_host_functor;
	if (str_gather_host_functor(d_int, real_count, d, d_char, len)) {}
	else if(len  == 50) T_str_gather_host<50>().operator()(d_int, real_count, d, d_char);
	else if(len  == 60) T_str_gather_host<60>().operator()(d_int, real_count, d, d_char);
	else if(len  == 100) T_str_gather_host<100>().operator()(d_int, real_count, d, d_char);
	else if(len  == 101) T_str_gather_host<101>().operator()(d_int, real_count, d, d_char);
	else if(len  == 255) T_str_gather_host<255>().operator()(d_int, real_count, d, d_char);
	else if(len  == 1023) T_str_gather_host<1023>().operator()(d_int, real_count, d, d_char);
}
// ---------------------------------------------------------------------------

/// JOIN on device static strings (functor)
template<unsigned int len>
struct T_str_gather {
	inline void operator()(thrust::device_ptr<unsigned int> &res, const size_t real_count, void* d, void* d_char) {
		thrust::device_ptr<Str<len> > dev_ptr_char((Str<len>*)d_char);
		thrust::device_ptr<Str<len> > dev_ptr((Str<len>*)d);
		thrust::gather(res, res + real_count, dev_ptr, dev_ptr_char);
	}
};

/// JOIN on device static strings
void str_gather(void* d_int, const size_t real_count, void* d, void* d_char, const unsigned int len)
{
	thrust::device_ptr<unsigned int> res((unsigned int*)d_int);

	T_unroll_functor<UNROLL_COUNT, T_str_gather> str_gather_functor;
	if (str_gather_functor(res, real_count, d, d_char, len)) {}
	else if(len  == 50) T_str_gather<50>().operator()(res, real_count, d, d_char);
	else if(len  == 60) T_str_gather<60>().operator()(res, real_count, d, d_char);
	else if(len  == 100) T_str_gather<100>().operator()(res, real_count, d, d_char);
	else if(len  == 101) T_str_gather<101>().operator()(res, real_count, d, d_char);
	else if(len  == 255) T_str_gather<255>().operator()(res, real_count, d, d_char);
	else if(len  == 1023) T_str_gather<1023>().operator()(res, real_count, d, d_char);
}



// ---------------------------------------------------------------------------
