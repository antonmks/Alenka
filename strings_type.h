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
//---------------------------------------------------------------------------
#pragma once
#ifndef STRINGS_TYPE_H
#define STRINGS_TYPE_H
//---------------------------------------------------------------------------

/// Number of turns of the templated functors
//#define UNROLL_COUNT 40

/// Static string type 4
template<unsigned int N, typename T = unsigned char>
class Str {
	__host__ __device__
	inline unsigned short int swap_le_be_16(unsigned short int const& val) const {
		return (val<<8) |		// move byte 0 to byte 1
				(val>>8);		// move byte 1 to byte 0
	}

	__host__ __device__
	inline unsigned int swap_le_be_32(unsigned int const& val) const {
		return ((val>>24)) |			// move byte 3 to byte 0
				((val<<8)&0xff0000) |	// move byte 1 to byte 2
				((val>>8)&0xff00) |		// move byte 2 to byte 1
				((val<<24));			// byte 0 to byte 3
	}

public:
	T data[N];
	enum { size = N };
	enum { bytes2_count = size / sizeof(unsigned short int), 
		bytes4_count = size / sizeof(unsigned int) };

	/// Uniform comparison
	__host__ __device__
	unsigned char comparison(const Str& other) const {
			if(size % 4 == 0) {
			/// Speedup in 3 - 3.5 times (compare aligned data by 4 bytes)
			//static_assert(sizeof(unsigned int) == 4, "You can't use this optimized class, because it can't compare data by 4 bytes!");
			unsigned int const* data4_first = reinterpret_cast<unsigned int const*>(data);
			unsigned int const* data4_second = reinterpret_cast<unsigned int const *>(other.data);
			/// Unrolls loops is especially important for CUDA-pipelines
			#pragma unroll
			for(unsigned int i = 0; i < bytes4_count; i++) {
				if(swap_le_be_32(data4_first[i]) > swap_le_be_32(data4_second[i])) return 0;
				else if(swap_le_be_32(data4_first[i]) < swap_le_be_32(data4_second[i])) return 1;
			}
		} else if(size % 2 == 0) {			
			/// Speedup in 2 - 2.5 times (compare unaligned data by 2 bytes)
			unsigned short int const* data2_first = reinterpret_cast<unsigned short int const*>(data);
			unsigned short int const* data2_second = reinterpret_cast<unsigned short int const *>(other.data);

			/// Partial manualy unrolling
			if(size > 16) {
				if(swap_le_be_16(data2_first[0]) > swap_le_be_16(data2_second[0])) return 0;
				else if(swap_le_be_16(data2_first[0]) < swap_le_be_16(data2_second[0])) return 1;
				if(swap_le_be_16(data2_first[1]) > swap_le_be_16(data2_second[1])) return 0;
				else if(swap_le_be_16(data2_first[1]) < swap_le_be_16(data2_second[1])) return 1;
				if(swap_le_be_16(data2_first[2]) > swap_le_be_16(data2_second[2])) return 0;
				else if(swap_le_be_16(data2_first[2]) < swap_le_be_16(data2_second[2])) return 1;
				if(swap_le_be_16(data2_first[3]) > swap_le_be_16(data2_second[3])) return 0;
				else if(swap_le_be_16(data2_first[3]) < swap_le_be_16(data2_second[3])) return 1;

				if(swap_le_be_16(data2_first[4]) > swap_le_be_16(data2_second[4])) return 0;
				else if(swap_le_be_16(data2_first[4]) < swap_le_be_16(data2_second[4])) return 1;
				if(swap_le_be_16(data2_first[5]) > swap_le_be_16(data2_second[5])) return 0;
				else if(swap_le_be_16(data2_first[5]) < swap_le_be_16(data2_second[5])) return 1;
				if(swap_le_be_16(data2_first[6]) > swap_le_be_16(data2_second[6])) return 0;
				else if(swap_le_be_16(data2_first[6]) < swap_le_be_16(data2_second[6])) return 1;
				if(swap_le_be_16(data2_first[7]) > swap_le_be_16(data2_second[7])) return 0;
				else if(swap_le_be_16(data2_first[7]) < swap_le_be_16(data2_second[7])) return 1;
			} else 
			if(size > 8) {
				if(swap_le_be_16(data2_first[0]) > swap_le_be_16(data2_second[0])) return 0;
				else if(swap_le_be_16(data2_first[0]) < swap_le_be_16(data2_second[0])) return 1;
				if(swap_le_be_16(data2_first[1]) > swap_le_be_16(data2_second[1])) return 0;
				else if(swap_le_be_16(data2_first[1]) < swap_le_be_16(data2_second[1])) return 1;
				if(swap_le_be_16(data2_first[2]) > swap_le_be_16(data2_second[2])) return 0;
				else if(swap_le_be_16(data2_first[2]) < swap_le_be_16(data2_second[2])) return 1;
				if(swap_le_be_16(data2_first[3]) > swap_le_be_16(data2_second[3])) return 0;
				else if(swap_le_be_16(data2_first[3]) < swap_le_be_16(data2_second[3])) return 1;
			}

			#pragma unroll
			for(unsigned int i = ((size>16)?8:((size>8)?4:0)); i < bytes2_count; i++) {
				if(swap_le_be_16(data2_first[i]) > swap_le_be_16(data2_second[i])) return 0;
				else if(swap_le_be_16(data2_first[i]) < swap_le_be_16(data2_second[i])) return 1;
			}

			#pragma unroll
			for(unsigned int i = bytes2_count*2; i < size; i++) {
				if(data[i] > other.data[i]) return 0;
				else if(data[i] < other.data[i]) return 1;
			}			
		} else {
			#pragma unroll
			for(unsigned int i = 0; i < size; i++) {
				if(data[i] > other.data[i]) return 0;
				else if(data[i] < other.data[i]) return 1;
			}
		}
		return 2;
	}
	

	__host__ __device__
	bool operator<(const Str& other) const
	{		
		unsigned char ret = comparison(other);
		if(ret != 2) return ret;
		else return false;
	}

	__host__ __device__
	bool operator>(const Str& other) const
	{
		unsigned char ret = comparison(other);
		if(ret != 2) return !ret;
		else return false;
	}


	__host__ __device__
	bool operator!=(const Str& other) const
	{
		if(size % 4 == 0) {
			unsigned int const* data4_first = reinterpret_cast<unsigned int const*>(data);
			unsigned int const* data4_second = reinterpret_cast<unsigned int const *>(other.data);
			#pragma unroll
			for(unsigned int i = 0; i < size/4; i++) {
				if(swap_le_be_32(data4_first[i]) != swap_le_be_32(data4_second[i])) return true;
			}
		} else if(size % 2 == 0) {	
			unsigned short int const* data2_first = reinterpret_cast<unsigned short int const*>(data);
			unsigned short int const* data2_second = reinterpret_cast<unsigned short int const*>(other.data);
			#pragma unroll
			for(unsigned int i = 0; i < bytes2_count; i++) {
				if(swap_le_be_16(data2_first[i]) != swap_le_be_16(data2_second[i])) return true;
			}

			#pragma unroll
			for(unsigned int i = bytes2_count*2; i < size; i++) {
				if(data[i] != other.data[i]) return true;
			}
		} else {
			#pragma unroll
			for(unsigned int i = 0; i < size; i++) {
				if(data[i] != other.data[i]) return true;
			}
		}
		return false;
	}

	/// Additional comparisons
	__host__ __device__ bool operator>=(const Str& str) const { return !(*this < str); }
	__host__ __device__ bool operator<=(const Str& str) const { return !(*this > str); }
	__host__ __device__ bool operator==(const Str& str) const { return !(*this != str); }
};
//---------------------------------------------------------------------------

/// Unrolling the templated functor (reusable)
template<unsigned int unroll_count, template<unsigned int> class T_functor>
struct T_unroll_functor {
	T_unroll_functor<unroll_count-1, T_functor> next_unroll;		/// Next step of unrolling
	T_functor<unroll_count> functor;							/// Current the unrolled functor

	template<typename T1, typename T2, typename T3, typename T4, typename T5, typename T6>
	bool operator()(T1 &val1, T2 &val2, T3 &val3, T4 &val4, T5 &val5, T6 &val6, const unsigned int len) {
		if(len == unroll_count) { functor(val1, val2, val3, val4, val5, val6); return true; }
		else return next_unroll(val1, val2, val3, val4, val5, val6, len);
	}		
	template<typename T1, typename T2, typename T3, typename T4, typename T5>
	bool operator()(T1 &val1, T2 &val2, T3 &val3, T4 &val4, T5 &val5, const unsigned int len) {
		if(len == unroll_count) { functor(val1, val2, val3, val4, val5); return true; }
		else return next_unroll(val1, val2, val3, val4, val5, len);
	}	
	template<typename T1, typename T2, typename T3, typename T4>
	bool operator()(T1 &val1, T2 &val2, T3 &val3, T4 &val4, const unsigned int len) {
		if(len == unroll_count) { functor(val1, val2, val3, val4); return true; }
		else return next_unroll(val1, val2, val3, val4, len);
	}
	template<typename T1, typename T2, typename T3>
	bool operator()(T1 &val1, T2 &val2, T3 &val3, const unsigned int len) {
		if(len == unroll_count) { functor(val1, val2, val3); return true; }
		else return next_unroll(val1, val2, val3, len);
	}
};
/// End of unroll (partial specialization)
template<template<unsigned int> class T_functor>
struct T_unroll_functor<0, T_functor> { 
	template<typename T1, typename T2, typename T3, typename T4, typename T5, typename T6>
	bool operator()(T1 &val1, T2 &val2, T3 &val3, T4 &val4, T5 &val5, T6 &val6, const unsigned int len) { return false; }
	template<typename T1, typename T2, typename T3, typename T4, typename T5>
	bool operator()(T1 &val1, T2 &val2, T3 &val3, T4 &val4, T5 &val5, const unsigned int len) { return false; }
	template<typename T1, typename T2, typename T3, typename T4>
	bool operator()(T1 &val1, T2 &val2, T3 &val3, T4 &val4, const unsigned int len) { return false; }
	template<typename T1, typename T2, typename T3>
	bool operator()(T1 &val1, T2 &val2, T3 &val3, const unsigned int len) { return false; }
};
// -----------------------------------------------------------------------

//---------------------------------------------------------------------------
#endif	/// STRINGS_TYPE_H