/// ======================================== H File =================================================
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
//---------------------------------------------------------------------------
#pragma once
#ifndef STRINGS_TYPE_H
#define STRINGS_TYPE_H
//---------------------------------------------------------------------------

/// Number of turns of the templated functors
#define UNROLL_COUNT 40

/// Static string type
template<unsigned int N, typename T = char>
struct Str {
	T data[N];
	enum { size = N };

	__host__ __device__
	bool operator<(const Str& other) const
	{
		/// Unrolls loops is especially important for CUDA-pipelines
		#pragma unroll
		for(unsigned int i = 0; i < N ; i++) {
			if(data[i] > other.data[i]) {
				return 0;
			} else if(data[i] < other.data[i]) {
				return 1;
			}
		}
		return 0;
	}

	__host__ __device__
	bool operator>(const Str& other) const
	{
		#pragma unroll
		for(unsigned int i = 0; i < N ; i++) {
			if(data[i] > other.data[i]) {
				return 1;
			} else if(data[i] < other.data[i]) {
				return 0;
			}
		}
		return 0;
	}


	__host__ __device__
	bool operator!=(const Str& other) const
	{
		#pragma unroll
		for(unsigned int i = 0; i < N ; i++) {
			if(data[i] != other.data[i]) {
				return 1;
			}
		}
		return 0;
	}

	/// Additional comparisons
	__host__ __device__ bool operator>=(const Str& str) const { return !(*this < str); }
	__host__ __device__ bool operator<=(const Str& str) const { return !(*this > str); }
	__host__ __device__ bool operator==(const Str& str) const { return !(*this != str); }
};
// ---------------------------------------------------------------------------

/// Unrolling the templated functor (reusable)
template<unsigned int unroll_count, template<unsigned int> class T_functor>
struct T_unroll_functor {
	T_unroll_functor<unroll_count-1, T_functor> next_unroll;		/// Next step of unrolling
	T_functor<unroll_count> functor;							/// Current the unrolled functor

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
	template<typename T1, typename T2, typename T3, typename T4>
	bool operator()(T1 &val1, T2 &val2, T3 &val3, T4 &val4, const unsigned int len) { return false; }
	template<typename T1, typename T2, typename T3>
	bool operator()(T1 &val1, T2 &val2, T3 &val3, const unsigned int len) { return false; }
};
// -----------------------------------------------------------------------

//---------------------------------------------------------------------------
#endif	/// STRINGS_TYPE_H