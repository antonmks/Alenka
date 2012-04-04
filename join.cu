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


#include <thrust/device_vector.h>
#include <thrust/iterator/counting_iterator.h>
#include <thrust/binary_search.h>
#include <thrust/reduce.h>
#include <thrust/fill.h>
#include <thrust/scan.h>
#include <thrust/device_ptr.h>


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
  unsigned int operator()(unsigned int x) { return x-2; }
};




struct nzj
{
    __host__ __device__
    bool operator()(const unsigned int x)
    {
        return (x != 0);
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

    //    for(unsigned int j = 0; j < upperbound[i]-lowerbound[i]; j++)
      //  {
            //output[address[i] + j] = i;
            //output1[address[i] + j] = lowerbound[i]+j;
			if (upperbound[i] != lowerbound[i]) {
                output[address[i] ] = i;
                output1[address[i] ] = lowerbound[i]+2;
			};	

        //};
    }
};


void join(int_type* d_input,int_type* d_values,
          thrust::device_vector<unsigned int>& d_res1, thrust::device_vector<unsigned int>& d_res2,
          unsigned int bRecCount, unsigned int aRecCount, bool isUnique)
{

	
	//float time;
    //cudaEvent_t start, stop;
	
	
 //cudaEventCreate(&start);
 //cudaEventCreate(&stop) ;
 //cudaEventRecord(start, 0) ;


    
    thrust::device_ptr<unsigned int> d_output1 = thrust::device_malloc<unsigned int>(bRecCount);   	
		
    thrust::device_ptr<int_type> d_i(d_input);
    thrust::device_ptr<int_type> d_v(d_values);

    if (!isUnique) {							
	
	    thrust::device_ptr<unsigned int> d_output = thrust::device_malloc<unsigned int>(bRecCount);
        thrust::lower_bound(d_i, d_i+aRecCount,
                            d_v, d_v+bRecCount,
                            d_output);				
	
	    thrust::device_ptr<unsigned int> d_output2 = thrust::device_malloc<unsigned int>(bRecCount);
		
        thrust::upper_bound(d_i, d_i+aRecCount,
                            d_v, d_v+bRecCount,
                            d_output1);
						
				
	
        thrust::transform(d_output1, d_output1+bRecCount, d_output, d_output2, thrust::minus<unsigned int>());	
	
	    unsigned int sz =  thrust::reduce(d_output2, d_output2+bRecCount, 0, thrust::plus<unsigned int>());	

	//    cout << "join end " << sz << endl;	

        thrust::exclusive_scan(d_output2, d_output2+bRecCount, d_output2);  // addresses		
		
        thrust::counting_iterator<unsigned int, thrust::device_space_tag> begin(0);
	
        d_res1.resize(sz);
        d_res2.resize(sz);
	
	    if (sz != 0 ) {
	
	        thrust::fill(d_res1.begin(), d_res1.end(), (unsigned int)0);
	        thrust::fill(d_res2.begin(), d_res2.end(), (unsigned int)1);
		
            join_functor ff(thrust::raw_pointer_cast(d_output),
                            thrust::raw_pointer_cast(d_output1),
                            thrust::raw_pointer_cast(d_output2),
                            thrust::raw_pointer_cast(&d_res1[0]),
                            thrust::raw_pointer_cast(&d_res2[0]));


            thrust::for_each(begin, begin + bRecCount, ff);	
	
	
	        thrust::inclusive_scan_by_key(d_res1.begin(), d_res1.end(), d_res1.begin(), d_res1.begin(), join_head_flag_predicate<unsigned int>(), thrust::maximum<unsigned int>()); // in-place scan
            thrust::inclusive_scan_by_key(d_res2.begin(), d_res2.end(), d_res2.begin(), d_res2.begin(), join_head_flag_predicate1<unsigned int>(), thrust::plus<unsigned int>()); // in-place scan
	        thrust::transform(d_res2.begin(), d_res2.end(), d_res2.begin(), minus2());		
		
	    };	
		thrust::device_free(d_output2);	
		thrust::device_free(d_output);	
	}
    else {  // DW style join with unique dimension keys
  	    
        thrust::binary_search(d_i, d_i+aRecCount,
                              d_v, d_v+bRecCount,
                              d_output1);		
							
	/*cudaEventRecord(stop, 0) ;
cudaEventSynchronize(stop) ;
 cudaEventElapsedTime(&time, start, stop);
 cudaEventRecord(start, 0);

printf("Time to generate2:  %3.1f ms \n", time);
		*/					
							
        unsigned int sz =  thrust::reduce(d_output1, d_output1+bRecCount);								
        d_res1.resize(sz);
        d_res2.resize(sz);
		


		
		if(sz) { 		
		    thrust::counting_iterator<unsigned int> seq(0);
		    thrust::copy_if(seq,seq+bRecCount,d_output1,d_res1.begin(),nzj());				
		
	        thrust::device_ptr<unsigned int> d_output = thrust::device_malloc<unsigned int>(bRecCount);
            thrust::lower_bound(d_i, d_i+aRecCount, d_v, d_v+bRecCount,  d_output);						
		
		    thrust::copy_if(d_output,d_output+bRecCount,d_output1,d_res2.begin(),nzj());
			thrust::device_free(d_output);	
		};			

        cout << "fast join end " << sz << endl;
    };		
    
    thrust::device_free(d_output1);	
    

}





void join(CudaChar* d_input,CudaChar* d_values,
          thrust::device_vector<unsigned int>& d_res1, thrust::device_vector<unsigned int>& d_res2)
{

// should be similar to joining numeric columns except that we shoud do it repeatedly for all columns in a varchar variable

    thrust::device_ptr<unsigned int> d_output = thrust::device_malloc<unsigned int>(d_values->mRecCount);
    thrust::device_ptr<unsigned int> d_output1 = thrust::device_malloc<unsigned int>(d_values->mRecCount);
    thrust::device_ptr<unsigned int> d_output2 = thrust::device_malloc<unsigned int>(d_values->mRecCount);


    thrust::device_ptr<char> d_i((d_input->d_columns)[0]);
    thrust::device_ptr<char> d_v((d_values->d_columns)[0]);

    thrust::lower_bound(d_i, d_i + d_input->mRecCount,
                        d_v, d_v+ d_values->mRecCount,
                        d_output);

    thrust::upper_bound(d_i, d_i + d_input->mRecCount,
                        d_v, d_v+ d_values->mRecCount,
                        d_output1);


    thrust::transform(d_output1, d_output1+d_values->mRecCount, d_output, d_output2, thrust::minus<unsigned int>());

    int sz =  thrust::reduce(d_output2, d_output2+d_values->mRecCount, 0);

    thrust::exclusive_scan(d_output2, d_output2+d_values->mRecCount, d_output2);  // addresses

    thrust::counting_iterator<unsigned int, thrust::device_space_tag> begin(0);

    d_res1.resize(sz);
    d_res2.resize(sz);

    join_functor ff(thrust::raw_pointer_cast(d_output),
                           thrust::raw_pointer_cast(d_output1),
                           thrust::raw_pointer_cast(d_output2),
                           thrust::raw_pointer_cast(&d_res1[0]),
                           thrust::raw_pointer_cast(&d_res2[0]));

    thrust::for_each(begin, begin + d_values->mRecCount, ff);

    thrust::device_free(d_output);
    thrust::device_free(d_output1);
    thrust::device_free(d_output2);

// gather and compare the rest of varchar columns

    int cc;

    if(d_input->mColumnCount > d_values->mColumnCount)
        cc = d_input->mColumnCount;
    else
        cc = d_values->mColumnCount;


    thrust::device_ptr<char> d_blanks;
    if(d_input->mColumnCount != d_values->mColumnCount) {
        d_blanks = thrust::device_malloc<char>(sz);
        thrust::sequence(d_blanks, d_blanks+sz, 0, 0);
    };

    int new_sz = sz;


    for(int i=1; i< cc; i++) {
        thrust::device_ptr<char> d_ii;
        if (d_input->mColumnCount >= i+1)
            d_ii = thrust::device_pointer_cast((d_input->d_columns)[i]); // check if columns actually exist
        else
            d_ii = thrust::device_pointer_cast(d_blanks);

        thrust::device_ptr<char> d_vv;
        if (d_values->mColumnCount >= i+1)
            d_vv = thrust::device_pointer_cast((d_values->d_columns)[i]);
        else
            d_vv = thrust::device_pointer_cast(d_blanks);

        thrust::device_ptr<char> d_out = thrust::device_malloc<char>(new_sz);
        thrust::device_ptr<char> d_out1 = thrust::device_malloc<char>(new_sz);
        thrust::device_ptr<unsigned int> v = thrust::device_malloc<unsigned int>(new_sz);

        thrust::gather(d_res2.begin(), d_res2.end(), d_ii, d_out);
        thrust::gather(d_res1.begin(), d_res1.end(), d_vv, d_out1);

        thrust::transform(d_out, d_out+new_sz, d_out1, v, thrust::equal_to<char>());
        new_sz =  thrust::reduce(v, v+new_sz, 0);

        thrust::device_ptr<unsigned int> res1_tmp = thrust::device_malloc<unsigned int>(new_sz);
        thrust::device_ptr<unsigned int> res2_tmp = thrust::device_malloc<unsigned int>(new_sz);

        thrust::copy_if(d_res1.begin(),d_res1.end(), v, res1_tmp, nzj());
        thrust::copy_if(d_res2.begin(),d_res2.end(), v, res2_tmp, nzj());

        d_res1.resize(new_sz);
        d_res2.resize(new_sz);

        thrust::copy(res1_tmp, res1_tmp+new_sz, d_res1.begin());
        thrust::copy(res2_tmp, res2_tmp+new_sz, d_res2.begin());

    };


}
