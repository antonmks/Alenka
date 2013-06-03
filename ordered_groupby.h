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
#ifndef ORDERED_GROUPBY_H
#define ORDERED_GROUPBY_H
// -----------------------------------------------------------------------
#include <thrust/iterator/discard_iterator.h>
#include <thrust/iterator/zip_iterator.h>
#include <thrust/tuple.h>
#include <thrust/functional.h>
#include <thrust/reduce.h>
#include <thrust/merge.h>
#include <thrust/host_vector.h>


/// The functor for comparison only first value in tuple
template<typename T>
struct T_hash_key_less {
    typedef thrust::tuple<uint64_t, T> T_current_tuple;

    __host__ 		__device__  
    bool operator()(T_current_tuple const& tuple_first, T_current_tuple const& tuple_second) const {
        return thrust::get<0>(tuple_first) < thrust::get<0>(tuple_second);
    }
};
//---------------------------------------------------------------------------

/// Merge hashes and values that already have been grouped/reduced by key 
template<typename T_hash_vec, typename T_val_vec, bool get_hashkeys>
void merge_by_key(T_hash_vec const& host_vec_keyhash_seg1, T_hash_vec const& host_vec_keyhash_seg2, 
				  T_val_vec const& host_vec_field_seg1, T_val_vec const& host_vec_field_seg2, 
				  T_hash_vec &host_vec_keyhash_merged, T_val_vec &host_vec_field_merged) 
{
	typedef typename T_val_vec::value_type T_val_vec;

    const size_t new_size = host_vec_keyhash_seg1.size() + host_vec_keyhash_seg2.size();
    host_vec_keyhash_result.resize(new_size);
    host_vec_field_result.resize(new_size);
    
	// We use thrust::zip_iterator<> consider key-hash and value for aggregating
    thrust::merge(
        thrust::make_zip_iterator(thrust::make_tuple(host_vec_keyhash_seg1.begin(), host_vec_field_seg1.begin())),
        thrust::make_zip_iterator(thrust::make_tuple(host_vec_keyhash_seg1.end(),	host_vec_field_seg1.end())),
        thrust::make_zip_iterator(thrust::make_tuple(host_vec_keyhash_seg2.begin(), host_vec_field_seg2.begin())),
        thrust::make_zip_iterator(thrust::make_tuple(host_vec_keyhash_seg2.end(),	host_vec_field_seg2.end())),
        thrust::make_zip_iterator(thrust::make_tuple(
			(get_hashkeys ? host_vec_keyhash_merged.begin() : thrust::make_discard_iterator()), host_vec_field_merged.begin())),
        T_functor_comparison<T_val_vec>() );
}
//---------------------------------------------------------------------------

/// Reduce values that already has been merged by key
/// in C++11 can do default template parameter in function: T_reduce_functor = thrust::plus<T_val_vec::value_type>>
template<typename T_hash_vec, typename T_val_vec, bool get_hashkeys, typename T_reduce_functor> 
void reduce_merged_by_key(T_hash_vec const& host_vec_keyhash_merged, T_val_vec const& host_vec_field_merged, 
				  T_hash_vec &host_vec_keyhash_reduced, T_val_vec &host_vec_field_reduced) 
{
    const size_t old_size = host_vec_keyhash_merged.size();
    host_vec_keyhash_reduced.resize(old_size);
    host_vec_field_reduced.resize(old_size)

    thrust::pair<T_hash_vec::iterator, T_val_vec::iterator> new_end;
    new_end = thrust::reduce_by_key(host_vec_keyhash_merged.begin(), host_vec_keyhash_merged.end(), 
		host_vec_field_merged.begin(), 
		host_vec_keyhash_reduced.begin(), 
		host_vec_field_reduced.begin(),
		thrust::equal_to<uint64_t>(),
		T_reduce_functor() );

    const size_t new_size = new_end.first - host_vec_keyhash_merged.begin();
    host_vec_keyhash_reduced.resize(new_size);
    host_vec_field_reduced.resize(new_size);
}
//---------------------------------------------------------------------------

//---------------------------------------------------------------------------
#endif	/// ORDERED_GROUPBY_H