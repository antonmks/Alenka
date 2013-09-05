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

template <typename KeyType>
void update_permutation(thrust::device_vector<KeyType>& key, unsigned int* permutation, unsigned long long int RecCount, string SortType, KeyType* tmp)
{
    thrust::device_ptr<unsigned int> dev_per(permutation);
    // temporary storage for keys
    thrust::device_ptr<KeyType> temp(tmp);
    // permute the keys with the current reordering
    thrust::gather(dev_per, dev_per+RecCount, key.begin(), temp);

    // stable_sort the permuted keys and update the permutation
    if (SortType.compare("DESC") == 0 )
        thrust::stable_sort_by_key(temp, temp+RecCount, dev_per, thrust::greater<KeyType>());
    else
        thrust::stable_sort_by_key(temp, temp+RecCount, dev_per);
}

template <typename KeyType>
void update_permutation_host(KeyType* key, unsigned int* permutation, unsigned long long int RecCount, string SortType, KeyType* tmp)
{
    thrust::gather(permutation, permutation+RecCount, key, tmp);

    if (SortType.compare("DESC") == 0 )
        thrust::stable_sort_by_key(tmp, tmp+RecCount, permutation, thrust::greater<KeyType>());
    else
        thrust::stable_sort_by_key(tmp, tmp+RecCount, permutation);
}



template <typename KeyType>
void apply_permutation(thrust::device_vector<KeyType>& key, unsigned int* permutation, unsigned long long int RecCount, KeyType* tmp)
{
    thrust::device_ptr<unsigned int> dev_per(permutation);
    thrust::device_ptr<KeyType> temp(tmp);
    // copy keys to temporary vector
    thrust::copy(key.begin(), key.begin() + RecCount, temp);
    // permute the keys
    thrust::gather(dev_per, dev_per+RecCount, temp, key.begin());
}

template <typename KeyType>
void apply_permutation_host(KeyType* key, unsigned int* permutation, unsigned long long int RecCount, KeyType* res)
{
    thrust::gather(permutation, permutation + RecCount, key, res);
}







