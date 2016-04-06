#ifndef STRINGS_SORT_HOST_H_
#define STRINGS_SORT_HOST_H_

#include <thrust/sort.h>
#include "strings_join.h"

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

#endif /* STRINGS_SORT_HOST_H_ */
