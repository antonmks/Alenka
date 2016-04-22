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

/// The conversion between big endian and little endian, it need for sort strings as like fundamental types
struct T_swap_le_be_64 {
	__host__ __device__ 
	inline unsigned long long operator()(unsigned long long const& val) const {
		return ((((unsigned long long)255<<(8*7)) & val) >> (8*7)) |
			((((unsigned long long)255<<(8*6)) & val) >> (8*5)) |
			((((unsigned long long)255<<(8*5)) & val) >> (8*3)) |
			((((unsigned long long)255<<(8*4)) & val) >> (8*1)) |
			((((unsigned long long)255<<(8*3)) & val) << (8*1)) |
			((((unsigned long long)255<<(8*2)) & val) << (8*3)) |
			((((unsigned long long)255<<(8*1)) & val) << (8*5)) |
			((((unsigned long long)255<<(8*0)) & val) << (8*7));
	}
};

struct T_swap_le_be_32 {
	__host__ __device__ 
	inline unsigned int operator()(unsigned int const& val) const {
		return ((val>>24)) |			// move byte 3 to byte 0
				((val<<8)&0xff0000) |	// move byte 1 to byte 2
				((val>>8)&0xff00) |		// move byte 2 to byte 1
				((val<<24));			// byte 0 to byte 3
	}
};

struct T_swap_le_be_16 {
	__host__ __device__ 
	inline unsigned short int operator()(unsigned short int const& val) const {
		return (val<<8) |		// move byte 0 to byte 1
				(val>>8);		// move byte 1 to byte 0
	}
};

struct T_swap_le_be_8 {
	__host__ __device__ 
	inline unsigned char operator()(unsigned char const& val) const { return val; }
};
//---------------------------------------------------------------------------

/// GPU-optimized radix sort 1 - 8 bytes for fundamental integer types, based on the fact that CUDA little-endian.
/// Speedup in 8 times.
template<typename T, typename T_swap_le_be>
static inline void optimized_str_sort(char* tmp, const size_t RecCount, thrust::device_ptr<unsigned int> &dev_per, const bool desc_order, T_swap_le_be const& swap_le_be) { 
		thrust::device_ptr<T> temp((T *)tmp);
		thrust::transform(temp, temp+RecCount, temp, swap_le_be);	// Transform BE to LE data of string
		if(desc_order)
			thrust::stable_sort_by_key(temp, temp+RecCount, dev_per, thrust::greater<T>());
		else
			thrust::stable_sort_by_key(temp, temp+RecCount, dev_per);
		thrust::transform(temp, temp+RecCount, temp, swap_le_be);	// Transform LE to BE data of string
}

/// Using specialization for GPU-optimized radix sort (1 - 8 bytes)
/// SORT on device static strings (functor) - (optimized for 8 bytes)
template<>
struct T_str_sort<8> {
	inline void operator()(char* tmp, const size_t RecCount, thrust::device_ptr<unsigned int> &dev_per, const bool desc_order) {
		//static_assert(sizeof(unsigned long long) == 8, "The size of unsigned long long is not equal to 8 bytes. Comment out this functor!");
		optimized_str_sort<unsigned long long>(tmp, RecCount, dev_per, desc_order, T_swap_le_be_64());
	}
};

/// SORT on device static strings (functor) - (optimized for 4 bytes)
template<>
struct T_str_sort<4> {
	inline void operator()(char* tmp, const size_t RecCount, thrust::device_ptr<unsigned int> &dev_per, const bool desc_order) {
		//static_assert(sizeof(unsigned int) == 4, "The size of unsigned int is not equal to 4 bytes. Comment out this functor!");
		optimized_str_sort<unsigned int>(tmp, RecCount, dev_per, desc_order, T_swap_le_be_32());
	}
};

/// SORT on device static strings (functor) - (optimized for 2 bytes)
template<>
struct T_str_sort<2> {
	inline void operator()(char* tmp, const size_t RecCount, thrust::device_ptr<unsigned int> &dev_per, const bool desc_order) {
		//static_assert(sizeof(unsigned short int) == 2, "The size of unsigned short int is not equal to 2 bytes. Comment out this functor!");
		optimized_str_sort<unsigned short int>(tmp, RecCount, dev_per, desc_order, T_swap_le_be_16());
	}
};

/// SORT on device static strings (functor) - (optimized for 1 bytes)
template<>
struct T_str_sort<1> {
	inline void operator()(char* tmp, const size_t RecCount, thrust::device_ptr<unsigned int> &dev_per, const bool desc_order) {
		//static_assert(sizeof(unsigned char) == 1, "The size of unsigned char is not equal to 1 bytes. Comment out this functor!");
		optimized_str_sort<unsigned char>(tmp, RecCount, dev_per, desc_order, T_swap_le_be_8());
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
