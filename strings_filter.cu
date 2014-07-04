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

#include <thrust/copy.h>

/// Filtering on device static strings (functor)
template<unsigned int len>
struct T_str_copy_if {
	inline void operator()(char* source, const size_t mRecCount, char* dest, thrust::device_ptr<bool>& d_grp) {
		thrust::device_ptr<Str<len> > d_str((Str<len> *)source);
		thrust::device_ptr<Str<len> > d_dest((Str<len> *)dest);

		thrust::copy_if(d_str, d_str + mRecCount, d_grp, d_dest, thrust::identity<bool>());
	}
};

/// Filtering on device static strings
void str_copy_if(char* source, const size_t mRecCount, char* dest, thrust::device_ptr<bool>& d_grp, const unsigned int len)
{
	T_unroll_functor<UNROLL_COUNT, T_str_copy_if> str_copy_if_functor;
	if (str_copy_if_functor(source, mRecCount, dest, d_grp, len)) {}
	else if(len  == 50) T_str_copy_if<50>().operator()(source, mRecCount, dest, d_grp);
	else if(len  == 60) T_str_copy_if<60>().operator()(source, mRecCount, dest, d_grp);
	else if(len  == 100) T_str_copy_if<100>().operator()(source, mRecCount, dest, d_grp);
	else if(len  == 101) T_str_copy_if<101>().operator()(source, mRecCount, dest, d_grp);
	else if(len  == 255) T_str_copy_if<255>().operator()(source, mRecCount, dest, d_grp);
}


/// Filtering on device static strings (functor)
template<unsigned int len>
struct T_str_copy_if_host {
	inline void operator()(char* source, const size_t mRecCount, char* dest, thrust::host_vector<bool>& grp) {

		thrust::copy_if((Str<len> *)source, (Str<len> *)source + mRecCount, grp.begin(), (Str<len> *)dest, thrust::identity<bool>());
	}
};


void str_copy_if_host(char* source, size_t mRecCount, char* dest, thrust::host_vector<bool>& grp, unsigned int len)
{
	T_unroll_functor<UNROLL_COUNT, T_str_copy_if_host> str_copy_if_host_functor;
    if (str_copy_if_host_functor(source, mRecCount, dest, grp, len)) {}
}

template<unsigned int len>
struct T_str_merge_by_key {
	inline void operator()(const thrust::host_vector<unsigned long long int>& keys,
					       const thrust::host_vector<unsigned long long int>& hh,
                           const char* values_first1, const char* values_first2, char* tmp)
   {
	thrust::merge_by_key(keys.begin(), keys.end(),
                         hh.begin(), hh.end(),
						 (Str<len> *)values_first1, (Str<len> *)values_first2,
				         thrust::make_discard_iterator(), (Str<len> *)tmp);
  
	}
};

void str_merge_by_key(thrust::host_vector<unsigned long long int>& keys,
					  thrust::host_vector<unsigned long long int>& hh,
                      char* values_first1, char* values_first2,
				      unsigned int len,
                      char* tmp)
{
	T_unroll_functor<UNROLL_COUNT, T_str_merge_by_key> str_merge_by_key_functor;
	if (str_merge_by_key_functor(keys, hh, values_first1, values_first2, tmp, len)) {}
    
}

template<unsigned int len>
struct T_str_merge_by_key1 {
	inline void operator()(long long int* keys,
                           char* values_first1, const char* values_first2, char* tmp, size_t offset1, size_t offset2)
   {
	thrust::merge_by_key(keys, keys + offset1,
                         keys + offset1, keys + offset2,
						 (Str<len> *)values_first1, (Str<len> *)values_first2,
				         thrust::make_discard_iterator(), (Str<len> *)tmp);
  
	}
};

void str_merge_by_key1(long long int* keys,
                      char* values_first1, char* values_first2,
				      unsigned int len,
                      char* tmp, size_t offset1, size_t offset2)
{
	T_unroll_functor<UNROLL_COUNT, T_str_merge_by_key1> str_merge_by_key_functor;
	if (str_merge_by_key_functor(keys, values_first1, values_first2, tmp, offset1, offset2, len)) {}
    
}
// ---------------------------------------------------------------------------

/*
/// GROUP BY on device static strings (functor) - not used now
template<unsigned int len>
struct T_str_grp {
	inline void operator()(char* d_char, const size_t real_count, thrust::device_ptr<bool>& d_group) {
		thrust::device_ptr<Str<len> > d_str((Str<len> *)d_char);
		thrust::transform(d_str, d_str + real_count -1 , d_str+1, d_group, thrust::not_equal_to<Str<len> >());
	}
};

/// GROUP BY on device static strings - not used now
void str_grp(char* d_char, const size_t real_count, thrust::device_ptr<bool>& d_group, const unsigned int len)
{
	T_unroll_functor<UNROLL_COUNT, T_str_grp> str_grp_functor;
	if (str_grp_functor(d_char, real_count, d_group, len)) {}
	else if(len  == 50) T_str_grp<50>().operator()(d_char, real_count, d_group);
	else if(len  == 60) T_str_grp<60>().operator()(d_char, real_count, d_group);
	else if(len  == 100) T_str_grp<100>().operator()(d_char, real_count, d_group);
	else if(len  == 101) T_str_grp<101>().operator()(d_char, real_count, d_group);
	else if(len  == 255) T_str_grp<255>().operator()(d_char, real_count, d_group);
}

				 

// ---------------------------------------------------------------------------
*/
