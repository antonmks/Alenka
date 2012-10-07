#include <thrust/device_vector.h>

using namespace std;

template <typename KeyType>
void update_permutation(thrust::device_vector<KeyType>& key, unsigned int* permutation, unsigned int RecCount, string SortType, KeyType* tmp)
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
void apply_permutation(thrust::device_vector<KeyType>& key, unsigned int* permutation, unsigned int RecCount, KeyType* tmp)
{
    thrust::device_ptr<unsigned int> dev_per(permutation);
    thrust::device_ptr<KeyType> temp(tmp);
    // copy keys to temporary vector
    thrust::copy(key.begin(), key.begin() + RecCount, temp);
    // permute the keys
    thrust::gather(dev_per, dev_per+RecCount, temp, key.begin());
}