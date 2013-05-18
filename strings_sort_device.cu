/**
 *  Licensed under the Apache License, Version 2.0 (the "License");
 *  you may not use this file except in compliance with the License.
 *  You may obtain a copy of the License at
 *
 *	  http://www.apache.org/licenses/LICENSE-2.0
 *
 *  Unless required by applicable law or agreed to in writing, software
 *  distributed under the License is distributed on an "AS IS" BASIS,
 *  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 *  See the License for the specific language governing permissions and
 *  limitations under the License.
 */


#include "strings.h"
#include "strings_type.h"

#include <thrust/sort.h>

/// SORT on device static strings (functor)
template<unsigned int len>
struct T_str_sort {
	inline void operator()(char* tmp, const size_t RecCount, thrust::device_ptr<unsigned int> &dev_per, const bool desc_order) {
		thrust::device_ptr<Str<len> > temp((Str<len> *)tmp);
		if(desc_order)
			thrust::stable_sort_by_key(temp, temp+RecCount, dev_per, thrust::greater<Str<len> >());
		else
			thrust::stable_sort_by_key(temp, temp+RecCount, dev_per);
	}
};
// ---------------------------------------------------------------------------

/// GPU-optimized radix sort 1 - 8 bytes for fundamental integer types, based on the fact that CUDA little-endian.
template<typename T>
static inline void optimized_str_sort(char* tmp, const size_t RecCount, thrust::device_ptr<unsigned int> &dev_per, const bool desc_order) { 
		thrust::device_ptr<T> temp((T *)tmp);
		if(desc_order)
			thrust::stable_sort_by_key(temp, temp+RecCount, dev_per, thrust::greater<T>());
		else
			thrust::stable_sort_by_key(temp, temp+RecCount, dev_per);
}

/// Using specialization for GPU-optimized radix sort (1 - 8 bytes)
/// SORT on device static strings (functor) - (optimized for 8 bytes)
template<>
struct T_str_sort<8> {
	inline void operator()(char* tmp, const size_t RecCount, thrust::device_ptr<unsigned int> &dev_per, const bool desc_order) {
		static_assert(sizeof(unsigned long long) == 8, "The size of unsigned long long is not equal to 8 bytes. Comment out this functor!");
		optimized_str_sort<unsigned long long>(tmp, RecCount, dev_per, desc_order);
	}
};

/// SORT on device static strings (functor) - (optimized for 4 bytes)
template<>
struct T_str_sort<4> {
	inline void operator()(char* tmp, const size_t RecCount, thrust::device_ptr<unsigned int> &dev_per, const bool desc_order) {
		static_assert(sizeof(unsigned int) == 4, "The size of unsigned int is not equal to 4 bytes. Comment out this functor!");
		optimized_str_sort<unsigned int>(tmp, RecCount, dev_per, desc_order);
	}
};

/// SORT on device static strings (functor) - (optimized for 2 bytes)
template<>
struct T_str_sort<2> {
	inline void operator()(char* tmp, const size_t RecCount, thrust::device_ptr<unsigned int> &dev_per, const bool desc_order) {
		static_assert(sizeof(unsigned short int) == 2, "The size of unsigned short int is not equal to 2 bytes. Comment out this functor!");
		optimized_str_sort<unsigned short int>(tmp, RecCount, dev_per, desc_order);
	}
};

/// SORT on device static strings (functor) - (optimized for 1 bytes)
template<>
struct T_str_sort<1> {
	inline void operator()(char* tmp, const size_t RecCount, thrust::device_ptr<unsigned int> &dev_per, const bool desc_order) {
		static_assert(sizeof(unsigned char) == 1, "The size of unsigned char is not equal to 1 bytes. Comment out this functor!");
		optimized_str_sort<unsigned char>(tmp, RecCount, dev_per, desc_order);
	}
};
// ---------------------------------------------------------------------------

/// SORT on device static strings
void str_sort(char* tmp, const size_t RecCount, unsigned int* permutation, const bool desc_order, const unsigned int len)
{
	thrust::device_ptr<unsigned int> dev_per((unsigned int*)permutation);
	
	T_unroll_functor<UNROLL_COUNT, T_str_sort> str_sort_functor;
	if (str_sort_functor(tmp, RecCount, dev_per, desc_order, len)) {}
	else if(len  == 50) T_str_sort<50>().operator()(tmp, RecCount, dev_per, desc_order);
	else if(len  == 60) T_str_sort<60>().operator()(tmp, RecCount, dev_per, desc_order);
	else if(len  == 100) T_str_sort<100>().operator()(tmp, RecCount, dev_per, desc_order);
	else if(len  == 101) T_str_sort<101>().operator()(tmp, RecCount, dev_per, desc_order);
	else if(len  == 255) T_str_sort<255>().operator()(tmp, RecCount, dev_per, desc_order);
	
}
// ---------------------------------------------------------------------------
