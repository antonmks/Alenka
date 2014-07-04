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

/// SORT on host static strings (functor) 
template<unsigned int len>
struct T_str_sort_host {
	inline void operator()(char* tmp, const size_t RecCount, unsigned int* permutation, const bool desc_order) {
		if(desc_order)
			thrust::stable_sort_by_key((Str<len> *)tmp, (Str<len> *)tmp+RecCount, permutation, thrust::greater<Str<len> >());
		else
			thrust::stable_sort_by_key((Str<len> *)tmp, (Str<len> *)tmp+RecCount, permutation);
	}
};

/// SORT on host static strings
void str_sort_host(char* tmp, const size_t RecCount, unsigned int* permutation, const bool desc_order, const unsigned int len)
{
	T_unroll_functor<UNROLL_COUNT, T_str_sort_host> str_sort_host_functor;
	if (str_sort_host_functor(tmp, RecCount, permutation, desc_order, len)) {}
	else if(len  == 50) T_str_sort_host<50>().operator()(tmp, RecCount, permutation, desc_order);
	else if(len  == 60) T_str_sort_host<60>().operator()(tmp, RecCount, permutation, desc_order);
	else if(len  == 100) T_str_sort_host<100>().operator()(tmp, RecCount, permutation, desc_order);
	else if(len  == 101) T_str_sort_host<101>().operator()(tmp, RecCount, permutation, desc_order);
	else if(len  == 255) T_str_sort_host<255>().operator()(tmp, RecCount, permutation, desc_order);
}
// ---------------------------------------------------------------------------
