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

#ifndef STRINGS_SORT_HOST_H_
#define STRINGS_SORT_HOST_H_

#include <thrust/sort.h>
#include "strings_join.h"

namespace alenka {

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

void str_sort_host(char* tmp, const size_t RecCount, unsigned int* permutation, const bool desc_order, const unsigned int len);

}// namespace alenka

#endif /* STRINGS_SORT_HOST_H_ */
