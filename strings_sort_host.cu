/*
*
*    This file is part of Alenka.
*
*    Alenka is free software: you can redistribute it and/or modify
*    it under the terms of the GNU General Public License as published by
*    the Free Software Foundation, either version 3 of the License, or
*    (at your option) any later version.
*
*    Alenka is distributed in the hope that it will be useful,
*    but WITHOUT ANY WARRANTY; without even the implied warranty of
*    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
*    GNU General Public License for more details.
*
*    You should have received a copy of the GNU General Public License
*    along with Alenka.  If not, see <http://www.gnu.org/licenses/>.
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
