#include <thrust/device_vector.h>
#include "strings.cu"

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
void update_permutation_host(KeyType* key, unsigned int* permutation, unsigned int RecCount, string SortType, KeyType* tmp)
{
	thrust::gather(permutation, permutation+RecCount, key, tmp);

    if (SortType.compare("DESC") == 0 )
        thrust::stable_sort_by_key(tmp, tmp+RecCount, permutation, thrust::greater<KeyType>());
    else
        thrust::stable_sort_by_key(tmp, tmp+RecCount, permutation);
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

template <typename KeyType>
void apply_permutation_host(KeyType* key, unsigned int* permutation, unsigned int RecCount, KeyType* res)
{
    //thrust::copy(key, key + RecCount, tmp);
    thrust::gather(permutation, permutation + RecCount, key, res);
}



void update_permutation_char(char* key, unsigned int* permutation, unsigned int RecCount, string SortType, char* tmp, unsigned int len)
{
    //thrust::device_ptr<unsigned int> dev_per(permutation);
    // temporary storage for keys
    //thrust::device_ptr<char> temp(tmp);
    // permute the keys with the current reordering
	
	str_gather((void*)permutation, RecCount, (void*)key, (void*)tmp, len);	

    // stable_sort the permuted keys and update the permutation
    if (SortType.compare("DESC") == 0 )
		str_sort(tmp, RecCount, permutation, 1, len);
    else
		str_sort(tmp, RecCount, permutation, 0, len);
}

void update_permutation_char_host(char* key, unsigned int* permutation, unsigned int RecCount, string SortType, char* tmp, unsigned int len)
{ 	
	str_gather_host(permutation, RecCount, (void*)key, (void*)tmp, len);	
	
    if (SortType.compare("DESC") == 0 )
		str_sort_host(tmp, RecCount, permutation, 1, len);
    else
		str_sort_host(tmp, RecCount, permutation, 0, len);		
		
}



void apply_permutation_char(char* key, unsigned int* permutation, unsigned int RecCount, char* tmp, unsigned int len)
{
     // copy keys to temporary vector    
	cudaMemcpy( (void*)tmp, (void*) key, RecCount*len, cudaMemcpyDeviceToDevice);		            
    // permute the keys
	str_gather((void*)permutation, RecCount, (void*)tmp, (void*)key, len);
}


void apply_permutation_char_host(char* key, unsigned int* permutation, unsigned int RecCount, char* res, unsigned int len)
{    
	//cudaMemcpy( (void*)tmp, (void*) key, RecCount*len, cudaMemcpyDeviceToDevice);		            
 	str_gather_host(permutation, RecCount, (void*)key, (void*)res, len);
}




