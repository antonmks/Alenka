#ifndef SORTS_H_
#define SORTS_H_

#include "thrust.h"

using namespace std;


template <typename KeyType>
void update_permutation(thrust::device_vector<KeyType>& key, unsigned int* permutation, unsigned long long int RecCount, string SortType, KeyType* tmp, unsigned int bits);

template <typename KeyType>
void update_permutation_host(KeyType* key, unsigned int* permutation, unsigned long long int RecCount, string SortType, KeyType* tmp);

template <typename KeyType>
void apply_permutation(thrust::device_vector<KeyType>& key, unsigned int* permutation, unsigned long long int RecCount, KeyType* tmp, unsigned int bits);

template <typename KeyType>
void apply_permutation_host(KeyType* key, unsigned int* permutation, unsigned long long int RecCount, KeyType* res);


#endif /* SORTS_H_ */
