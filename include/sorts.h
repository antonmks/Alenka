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

#ifndef SORTS_H_
#define SORTS_H_

#include <string>

#include "thrust.h"

using namespace std;

namespace alenka {

template <typename KeyType>
void update_permutation(thrust::device_vector<KeyType>& key, unsigned int* permutation, unsigned long long int RecCount, string SortType, KeyType* tmp, unsigned int bits);

template <typename KeyType>
void update_permutation_host(KeyType* key, unsigned int* permutation, unsigned long long int RecCount, string SortType, KeyType* tmp);

template <typename KeyType>
void apply_permutation(thrust::device_vector<KeyType>& key, unsigned int* permutation, unsigned long long int RecCount, KeyType* tmp, unsigned int bits);

template <typename KeyType>
void apply_permutation_host(KeyType* key, unsigned int* permutation, unsigned long long int RecCount, KeyType* res);

} // namespace alenka

#define SORT_FUNCTIONS
#include "../src/sorts.cu"

#endif /* SORTS_H_ */
