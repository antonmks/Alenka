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

#include "join.h"

size_t int_size = sizeof(int_type);
size_t float_size = sizeof(float_type);

template <typename HeadFlagType>
struct join_head_flag_predicate
        : public thrust::binary_function<HeadFlagType,HeadFlagType,bool>
{
    __host__ __device__
    bool operator()(HeadFlagType left, HeadFlagType right) const
    {
        return !right;
    }
};

template <typename HeadFlagType>
struct join_head_flag_predicate1
        : public thrust::binary_function<HeadFlagType,HeadFlagType,bool>
{
    __host__ __device__
    bool operator()(HeadFlagType left, HeadFlagType right) const
    {
        return (right == 1);
    }
};

struct minus2 : public thrust::unary_function<unsigned int, unsigned int>
{
    __host__ __device__
    unsigned int operator()(unsigned int x) {
        return x-2;
    }
};

struct is_zero : public thrust::unary_function<unsigned int, unsigned int>
{
    __host__ __device__
    unsigned int operator()(unsigned int x) {
        return x == 0;
    }
};




struct join_functor
{

    const unsigned int * lowerbound;
    const unsigned int * upperbound;
    const unsigned int * address;
    unsigned int * output;
    unsigned int * output1;

    join_functor(const unsigned int * _lowerbound, const unsigned int * _upperbound,
                 const unsigned int * _address, unsigned int * _output, unsigned int * _output1):
        lowerbound(_lowerbound), upperbound(_upperbound),
        address(_address), output(_output), output1(_output1) {}

    template <typename IndexType>
    __host__ __device__
    void operator()(const IndexType & i) {

        if (upperbound[i] != lowerbound[i]) {
            output[address[i] ] = i;
            output1[address[i] ] = lowerbound[i]+2;
        };

    }
};


unsigned int join(int_type* d_input,int_type* d_values,
          thrust::device_vector<unsigned int>& d_res1, thrust::device_vector<unsigned int>& d_res2,
          unsigned int bRecCount, unsigned int aRecCount, bool left_join, searchEngine_t engine, CuDeviceMem* btree)
{
    thrust::device_ptr<unsigned int> d_output1 = thrust::device_malloc<unsigned int>(bRecCount);
    thrust::device_ptr<int_type> d_i(d_input);
    thrust::device_ptr<int_type> d_v(d_values);


    thrust::counting_iterator<unsigned int, thrust::device_space_tag> begin(0);
    thrust::device_ptr<unsigned int> d_output = thrust::device_malloc<unsigned int>(bRecCount);
		
						
	searchStatus_t status = searchKeys(engine, aRecCount, SEARCH_TYPE_INT64, 
                            		  (CUdeviceptr)d_input, SEARCH_ALGO_LOWER_BOUND,
			                          (CUdeviceptr)d_values, bRecCount, btree->Handle(),
			                          (CUdeviceptr)thrust::raw_pointer_cast(d_output));
			
    thrust::device_ptr<unsigned int> d_output2 = thrust::device_malloc<unsigned int>(bRecCount);

    status = searchKeys(engine, aRecCount, SEARCH_TYPE_INT64, 
	                    (CUdeviceptr)d_input, SEARCH_ALGO_UPPER_BOUND,
		                (CUdeviceptr)d_values, bRecCount, btree->Handle(),
		                (CUdeviceptr)thrust::raw_pointer_cast(d_output1));							

    thrust::transform(d_output1, d_output1+bRecCount, d_output, d_output2, thrust::minus<unsigned int>());
    unsigned int sz =  thrust::reduce(d_output2, d_output2+bRecCount, 0, thrust::plus<unsigned int>());
		
	unsigned int left_sz = 0;
	if (left_join) {
		left_sz = thrust::count(d_output2, d_output2+bRecCount,0);			
	};	
    d_res1.resize(sz + left_sz);
    d_res2.resize(sz);

	if (left_join && left_sz) {
		thrust::copy_if(thrust::make_counting_iterator((unsigned int)0), thrust::make_counting_iterator(bRecCount-1), d_output2, d_res1.begin()+ sz, is_zero() );
	};		
		
    thrust::exclusive_scan(d_output2, d_output2+bRecCount, d_output2);  // addresses

    if (sz != 0 ) {

        thrust::fill(d_res1.begin(), d_res1.begin() + sz, (unsigned int)0);
        thrust::fill(d_res2.begin(), d_res2.end(), (unsigned int)1);

        join_functor ff(thrust::raw_pointer_cast(d_output),
                        thrust::raw_pointer_cast(d_output1),
                        thrust::raw_pointer_cast(d_output2),
                        thrust::raw_pointer_cast(&d_res1[0]),
                        thrust::raw_pointer_cast(&d_res2[0]));


        thrust::for_each(begin, begin + bRecCount, ff);
		
        thrust::inclusive_scan_by_key(d_res1.begin(), d_res1.begin() + sz, d_res1.begin(), d_res1.begin(), join_head_flag_predicate<unsigned int>(), thrust::maximum<unsigned int>()); // in-place scan
        thrust::inclusive_scan_by_key(d_res2.begin(), d_res2.end(), d_res2.begin(), d_res2.begin(), join_head_flag_predicate1<unsigned int>(), thrust::plus<unsigned int>()); // in-place scan
		
        thrust::transform(d_res2.begin(), d_res2.end(), d_res2.begin(), minus2());
		
    }
    thrust::device_free(d_output2);
    thrust::device_free(d_output);    
    thrust::device_free(d_output1);
	return left_sz;
}



