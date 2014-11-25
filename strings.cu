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
 
/// Number of turns of the templated functors


#include "strings.h"
#include "cm.h"

using namespace std;

/// Static string type
template<unsigned int N, typename T = char>
struct Str {
    T A[N];

    __host__ __device__
    bool operator<(const Str& other) const
    {
        for(unsigned int i = 0; i < N ; i++) {
            if(A[i] > other.A[i]) {
                return 0;
            } else if(A[i] < other.A[i]) {
                return 1;
            }
        }
        return 0;
    }

    __host__ __device__
    bool operator>(const Str& other) const
    {
        for(unsigned int i = 0; i < N ; i++) {
            if(A[i] > other.A[i]) {
                return 1;
            } else if(A[i] < other.A[i]) {
                return 0;
            }
        }
        return 0;
    }


    __host__ __device__
    bool operator!=(const Str& other) const
    {
        for(unsigned int i = 0; i < N ; i++) {
            if(A[i] != other.A[i]) {
                return 1;
            }
        }
        return 0;
    }

/// Additional comparisons
    __host__ __device__ bool operator>=(const Str& str) const {
        return !(*this < str);
    }
    __host__ __device__ bool operator<=(const Str& str) const {
        return !(*this > str);
    }
    __host__ __device__ bool operator==(const Str& str) const {
        return !(*this != str);
    }
};
// ---------------------------------------------------------------------------

/// Unrolling the templated functor (reusable)
template<unsigned int unroll_count, template<unsigned int> class T_functor>
struct T_unroll_functor {
    T_unroll_functor<unroll_count-1, T_functor> next_unroll;	/// Next step of unrolling
    T_functor<unroll_count> functor;	/// Current the unrolled functor

    template<typename T1, typename T2, typename T3, typename T4>
    bool operator()(T1 &val1, T2 &val2, T3 &val3, T4 &val4, const unsigned int len) {
        if(len == unroll_count) {
            functor(val1, val2, val3, val4);
            return true;
        }
        else return next_unroll(val1, val2, val3, val4, len);
    }
    template<typename T1, typename T2, typename T3>
    bool operator()(T1 &val1, T2 &val2, T3 &val3, const unsigned int len) {
        if(len == unroll_count) {
            functor(val1, val2, val3);
            return true;
        }
        else return next_unroll(val1, val2, val3, len);
    }
};
/// End of unroll (partial specialization)
template<template<unsigned int> class T_functor>
struct T_unroll_functor<0, T_functor> {
    template<typename T1, typename T2, typename T3, typename T4>
    bool operator()(T1 &val1, T2 &val2, T3 &val3, T4 &val4, const unsigned int len) {
        return false;
    }
    template<typename T1, typename T2, typename T3>
    bool operator()(T1 &val1, T2 &val2, T3 &val3, const unsigned int len) {
        return false;
    }
};
// -----------------------------------------------------------------------


/// JOIN on host static strings (functor)
template<unsigned int len>
struct T_str_gather_host {
    inline void operator()(unsigned int* d_int, const unsigned int real_count, void* d, void* d_char) {
        thrust::gather_if(d_int, d_int + real_count, d_int, (Str<len> *)d, (Str<len> *)d_char, is_positive());
    }
};

/// JOIN on host static strings
void str_gather_host(unsigned int* d_int, const unsigned int real_count, void* d, void* d_char, const unsigned int len)
{
    T_unroll_functor<UNROLL_COUNT, T_str_gather_host> str_gather_host_functor;
    if (str_gather_host_functor(d_int, real_count, d, d_char, len)) {}
    else if(len == 101) {
        thrust::gather(d_int, d_int + real_count, d_int, (Str<101> *)d, (Str<101> *)d_char, is_positive());
    }
}
// ---------------------------------------------------------------------------

/// JOIN on device static strings (functor)
template<unsigned int len>
struct T_str_gather {
    inline void operator()(thrust::device_ptr<unsigned int> &res, const unsigned int real_count, void* d, void* d_char) {
        thrust::device_ptr<Str<len> > dev_ptr_char((Str<len>*)d_char);
        thrust::device_ptr<Str<len> > dev_ptr((Str<len>*)d);
        thrust::gather_if(res, res + real_count, res, dev_ptr, dev_ptr_char, is_positive());
    }
};

/// JOIN on device static strings
void str_gather(void* d_int, const unsigned int real_count, void* d, void* d_char, const unsigned int len)
{
    thrust::device_ptr<unsigned int> res((unsigned int*)d_int);

    T_unroll_functor<UNROLL_COUNT, T_str_gather> str_gather_functor;
    if (str_gather_functor(res, real_count, d, d_char, len)) {}
    else if(len == 101) {
        thrust::device_ptr<Str<101> > dev_ptr_char((Str<101> *)d_char);
        thrust::device_ptr<Str<101> > dev_ptr((Str<101> *)d);
        thrust::gather_if(res, res + real_count, res, dev_ptr, dev_ptr_char, is_positive());
    }
}
// ---------------------------------------------------------------------------

/// SORT on host static strings (functor)
template<unsigned int len>
struct T_str_sort_host {
    inline void operator()(char* tmp, const unsigned int RecCount, unsigned int* permutation, const bool srt) {
        if(srt)
            thrust::stable_sort_by_key((Str<len> *)tmp, (Str<len> *)tmp+RecCount, permutation, thrust::greater<Str<len> >());
        else
            thrust::stable_sort_by_key((Str<len> *)tmp, (Str<len> *)tmp+RecCount, permutation);
    }
};

/// SORT on host static strings
void str_sort_host(char* tmp, const unsigned int RecCount, unsigned int* permutation, const bool srt, const unsigned int len)
{
    T_unroll_functor<UNROLL_COUNT, T_str_sort_host> str_sort_host_functor;
    if (str_sort_host_functor(tmp, RecCount, permutation, srt, len)) {}
    else if(len == 101) {
        if(srt)
            thrust::stable_sort_by_key((Str<101> *)tmp, (Str<101> *)tmp+RecCount, permutation, thrust::greater<Str<101> >());
        else
            thrust::stable_sort_by_key((Str<101> *)tmp, (Str<101> *)tmp+RecCount, permutation);
    }
}
// ---------------------------------------------------------------------------

/// SORT on device static strings (functor)
template<unsigned int len>
struct T_str_sort {
    inline void operator()(char* tmp, const unsigned int RecCount, thrust::device_ptr<unsigned int> &dev_per, const bool srt) {
        thrust::device_ptr<Str<len> > temp((Str<len> *)tmp);
        if(srt)
            thrust::stable_sort_by_key(temp, temp+RecCount, dev_per, thrust::greater<Str<len> >());
        else
            thrust::stable_sort_by_key(temp, temp+RecCount, dev_per);
    }
};

/// SORT on device static strings
void str_sort(char* tmp, const unsigned int RecCount, unsigned int* permutation, const bool srt, const unsigned int len)
{
    thrust::device_ptr<unsigned int> dev_per((unsigned int*)permutation);

    T_unroll_functor<UNROLL_COUNT, T_str_sort> str_sort_functor;
    if (str_sort_functor(tmp, RecCount, dev_per, srt, len)) {}
    else if(len == 101) {
        thrust::device_ptr<Str<101> > temp((Str<101> *)tmp);
        if(srt) {
            thrust::stable_sort_by_key(temp, temp+RecCount, dev_per, thrust::greater<Str<101> >());
        }
        else {
            thrust::stable_sort_by_key(temp, temp+RecCount, dev_per);
        }
    }

}
// ---------------------------------------------------------------------------



