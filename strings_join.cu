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

#include <thrust/gather.h>

/// JOIN on host static strings (functor)
template<unsigned int len>
struct T_str_gather_host {
	inline void operator()(unsigned int* d_int, const size_t real_count, void* d, void* d_char) {
		thrust::gather(d_int, d_int + real_count, (Str<len> *)d, (Str<len> *)d_char);
	}
};

/// JOIN on host static strings
void str_gather_host(unsigned int* d_int, const size_t real_count, void* d, void* d_char, const unsigned int len)
{
	T_unroll_functor<UNROLL_COUNT, T_str_gather_host> str_gather_host_functor;
	if (str_gather_host_functor(d_int, real_count, d, d_char, len)) {}
	else if(len  == 50) T_str_gather_host<50>().operator()(d_int, real_count, d, d_char);
	else if(len  == 60) T_str_gather_host<60>().operator()(d_int, real_count, d, d_char);
	else if(len  == 100) T_str_gather_host<100>().operator()(d_int, real_count, d, d_char);
	else if(len  == 101) T_str_gather_host<101>().operator()(d_int, real_count, d, d_char);
	else if(len  == 255) T_str_gather_host<255>().operator()(d_int, real_count, d, d_char);
}
// ---------------------------------------------------------------------------

/// JOIN on device static strings (functor)
template<unsigned int len>
struct T_str_gather {
	inline void operator()(thrust::device_ptr<unsigned int> &res, const size_t real_count, void* d, void* d_char) {
		thrust::device_ptr<Str<len> > dev_ptr_char((Str<len>*)d_char);
		thrust::device_ptr<Str<len> > dev_ptr((Str<len>*)d);
		thrust::gather_if(res, res + real_count, res, dev_ptr, dev_ptr_char, is_positive<unsigned int>());
	}
};

/// JOIN on device static strings
void str_gather(void* d_int, const size_t real_count, void* d, void* d_char, const unsigned int len)
{
	thrust::device_ptr<unsigned int> res((unsigned int*)d_int);

	T_unroll_functor<UNROLL_COUNT, T_str_gather> str_gather_functor;
	if (str_gather_functor(res, real_count, d, d_char, len)) {}
	else if(len  == 50) T_str_gather<50>().operator()(res, real_count, d, d_char);
	else if(len  == 60) T_str_gather<60>().operator()(res, real_count, d, d_char);
	else if(len  == 100) T_str_gather<100>().operator()(res, real_count, d, d_char);
	else if(len  == 101) T_str_gather<101>().operator()(res, real_count, d, d_char);
	else if(len  == 255) T_str_gather<255>().operator()(res, real_count, d, d_char);
}



// ---------------------------------------------------------------------------
