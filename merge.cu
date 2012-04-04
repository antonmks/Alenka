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


#include "cm.h"

unsigned int findPartitionColumn(CudaSet* c, stack<string> op_v2);
head_flag_predicate<bool> binary_pred_l;


void add(CudaSet* c, CudaSet* b, queue<string> op_v3, stack<string> op_v2)
{
    if (c->columnNames.empty()) {
        // create d_columns and h_columns

        map<string,int>::iterator it;
        map<int,string> columnNames1;
        for ( it=b->columnNames.begin() ; it != b->columnNames.end(); ++it ) {
            c->columnNames[(*it).first] = (*it).second;
            columnNames1[(*it).second] = (*it).first;
        };

        string f_name;
        c->grp_type = new unsigned int[c->mColumnCount];

        for(unsigned int i=0; i < b->mColumnCount; i++) {
            c->cols[i] = b->cols[i];
            c->type[i] = b->type[i];
            c->grp_type[i] = b->grp_type[i];

            if (b->type[i] == 0)
                cudaMallocHost(&(c->h_columns[i]), c->mRecCount*int_size);
            else if (b->type[i] == 1)
                cudaMallocHost(&(c->h_columns[i]), c->mRecCount*float_size);
            else
                c->h_columns[i] = new CudaChar(((CudaChar*) (b->h_columns)[i])->mColumnCount, c->mRecCount);
        };

    }
    // append b to c
    for(unsigned int i=0; i < b->mColumnCount; i++) {
        if (b->type[i] == 0 )
            cudaMemcpy((int_type*)c->h_columns[i]+(c->mRecCount-b->mRecCount), b->d_columns[i], b->mRecCount*int_size, cudaMemcpyDeviceToHost);
        else if (b->type[i] == 1 )
            cudaMemcpy((float_type*)c->h_columns[i]+(c->mRecCount-b->mRecCount), b->d_columns[i], b->mRecCount*float_size, cudaMemcpyDeviceToHost);
        else { //CudaChar
            CudaChar *s = (CudaChar*)(b->h_columns)[i];
            CudaChar *d = (CudaChar*)c->h_columns[i];
            for(unsigned int j=0; j < s->mColumnCount; j++)
                cudaMemcpy((char*)d->h_columns[j]+(c->mRecCount-b->mRecCount), s->d_columns[j], b->mRecCount, cudaMemcpyDeviceToHost);
        };
    };
}


void order_inplace(CudaSet* a, stack<string> exe_type)
{

     // initialize permutation to [0, 1, 2, ... ,N-1]
    thrust::device_ptr<unsigned int> permutation = thrust::device_malloc<unsigned int>(a->mRecCount);
    thrust::sequence(permutation, permutation+(a->mRecCount));
	
    void* temp;
    CUDA_SAFE_CALL(cudaMalloc((void **) &temp, a->mRecCount*float_size));
    unsigned int* raw_ptr = thrust::raw_pointer_cast(permutation);	

	
    for(int i=0; !exe_type.empty(); ++i, exe_type.pop()) {
	
	         
		if ((a->columnNames).find(exe_type.top()) ==  a->columnNames.end()) {
		    cout << "Sort couldn't find field " << exe_type.top() << endl;
			exit(1);		
		};
		   
        int colInd = (a->columnNames).find(exe_type.top())->second;


        if(a->d_columns[colInd] == 0 && a->type[colInd] < 2) {
            a->allocColumnOnDevice(colInd,a->mRecCount);
            a->CopyColumnToGpu(colInd, 0, a->mRecCount);
        };
		
	
        if ((a->type)[colInd] == 0) 
            update_permutation((int_type*)(a->d_columns)[colInd], raw_ptr, a->mRecCount, "ASC", (int_type*)temp);
        else if ((a->type)[colInd] == 1) 
            update_permutation((float_type*)(a->d_columns)[colInd], raw_ptr, a->mRecCount,"ASC", (float_type*)temp);
        else {
            CudaChar* c = (CudaChar*)(a->h_columns)[colInd];
            thrust::device_ptr<char> tmp = thrust::device_malloc<char>(a->mRecCount);

            unsigned int curr_pos;
            for(int j=(c->mColumnCount)-1; j>=0 ; j--) {
                cudaMalloc((void **) &c->d_columns[j], a->mRecCount);
                curr_pos = 0;
                for(int k = 0; k < a->m_position.size(); k++) {
				    
                    cudaMemcpy((void *) (c->d_columns[j] + curr_pos), (void *) (c->h_columns[j] + (a->m_position[a->m_current])[k]), (a->m_size[a->m_current])[k], cudaMemcpyHostToDevice);
                    curr_pos = curr_pos + (a->m_size[a->m_current])[k];
                };
                update_permutation_char((c->d_columns)[j], raw_ptr, a->mRecCount, thrust::raw_pointer_cast(tmp), "ASC");
                cudaFree(c->d_columns[j]);
                c->d_columns[j] =0;
            };
            thrust::device_free(tmp);
        };
        a->deAllocColumnOnDevice(colInd);
    };
	
	
    for(int i=0; i<(a->mColumnCount); ++i) {
        if(a->d_columns[i] == 0 && a->type[i] < 2) {
            a->allocColumnOnDevice(i,a->mRecCount);
            a->CopyColumnToGpu(i, 0, a->mRecCount);
        };
	
        if (a->type[i] == 0) 
            apply_permutation((int_type*)(a->d_columns)[i], raw_ptr, a->mRecCount, (int_type*)temp);
        else if (a->type[i] == 1)
            apply_permutation((float_type*)(a->d_columns)[i], raw_ptr, a->mRecCount, (float_type*)temp);
        else {
            CudaChar* c = (CudaChar*)(a->h_columns)[i];
            //thrust::device_ptr<char> tmp = thrust::device_malloc<char>(a->mRecCount);

            unsigned int curr_pos;
            for(int j=(c->mColumnCount)-1; j>=0 ; j--) {
                cudaMalloc((void **) &c->d_columns[j], a->mRecCount);
                curr_pos = 0;
                for(int k = 0; k < a->m_position.size(); k++) {
                    cudaMemcpy((void *) (c->d_columns[j] + curr_pos), (void *) (c->h_columns[j] + (a->m_position[a->m_current])[k]), (a->m_size[a->m_current])[k], cudaMemcpyHostToDevice);
                    curr_pos = curr_pos + (a->m_size[a->m_current])[k];
                };

                apply_permutation_char((c->d_columns)[j], raw_ptr, a->mRecCount, (char*)temp);
                curr_pos = 0;
                for(int k = 0; k < a->m_position.size(); k++) {
                    cudaMemcpy((void *) (c->h_columns[j] + (a->m_position[a->m_current])[k]), (void *) (c->d_columns[j] + curr_pos), (a->m_size[a->m_current])[k], cudaMemcpyDeviceToHost);
                    curr_pos = curr_pos + (a->m_size[a->m_current])[k];
                };

                cudaFree(c->d_columns[j]);
                c->d_columns[j] =0;
            };
            //thrust::device_free(tmp);
        };
        if (a->type[i] != 2)
            a->CopyColumnToHost(i);
        a->deAllocColumnOnDevice(i);
    };
    thrust::device_free(permutation);
	cudaFree(temp);


}



CudaSet* merge(CudaSet* c, queue<string> op_v3, stack<string> op_v2)
{
    int countIndex;
    int avg_index = -1;
    int pieces = 1;

    for(int i = 0; i < c->mColumnCount; i++) {
        if(c->grp_type[i] == 0) // COUNT
            countIndex = i;
        else if(c->grp_type[i] == 1) // AVG
            avg_index = i;
    };

    unsigned int oldRecCount = c->mRecCount;




    // check if c set needs partitioning

    // c->mRecCount*int_size*4 > getFreeMem()

    if(c->mRecCount*int_size*4 > getFreeMem()) {
        unsigned int col = findPartitionColumn(c, op_v2);
        pieces = c->partitionCudaSet(col);
    }
    else {
        c->m_position.push_back(vector <unsigned int>());
        c->m_size.push_back(vector <unsigned int>());
        c->m_position[0].push_back(0);
        c->m_size[0].push_back(c->mRecCount);
    };


//pieces = c->partitionCudaSet(0);

    CudaSet *r = c->copyStruct(c->mRecCount);
    r->mRecCount = 0;


    for(int i = 0; i < c->m_position.size(); i++) {
        c->mRecCount = 0;
        c->m_current = i;

        for(int j = 0; j < pieces; j++)
            c->mRecCount = c->mRecCount + (c->m_size[i])[j];


        if (c->mRecCount != 0) {
            order_inplace(c,op_v2);
            c->GroupBy(op_v3);

            thrust::device_ptr<bool> d_grp(c->grp);
            //thrust::device_ptr<bool> d_di(c->di);


            for(unsigned int j=0; j < c->mColumnCount; j++) {
                c->allocColumnOnDevice(j, c->mRecCount);
                c->CopyColumnToGpu(j, 0, c->mRecCount);

                if (c->grp_type[j] == 3) {	      	  	  // non-grouped columns
                    if (c->type[j] == 0) {
                        thrust::device_ptr<int_type> ss((int_type*)(c->d_columns)[j]);
                        thrust::device_ptr<int_type> diff = thrust::device_malloc<int_type>(c->grp_count);
                        thrust::copy_if(ss,ss+(c->mRecCount), d_grp, diff, nz<bool>());
                        cudaMemcpy((void*)((int_type*)r->h_columns[j] + r->mRecCount), (void*)thrust::raw_pointer_cast(diff) , c->grp_count*int_size, cudaMemcpyDeviceToHost);
						//CopyColumnToHost(j, 0, c->grp_count);
                        thrust::device_free(diff);
                    }
                    else if (c->type[j] == 1) {
                        thrust::device_ptr<float_type> ss((float_type*)(c->d_columns)[j]);
                        thrust::device_ptr<float_type> diff = thrust::device_malloc<float_type>(c->grp_count);
                        thrust::copy_if(ss,ss+(c->mRecCount), d_grp, diff, nz<bool>());
                        cudaMemcpy((void*)((float_type*)r->h_columns[j] + r->mRecCount), (void*)thrust::raw_pointer_cast(diff) , c->grp_count*float_size, cudaMemcpyDeviceToHost);
						//CopyColumnToHost(j, 0, c->grp_count);
                        thrust::device_free(diff);
                    }
                    else if (c->type[j] == 2) {
                        CudaChar *cc = (CudaChar*)(c->h_columns)[j];
                        CudaChar *rr = (CudaChar*)(r->h_columns)[j];
                        thrust::device_ptr<char> diff = thrust::device_malloc<char>(c->grp_count);

                        for(unsigned int k=0; k < (cc->mColumnCount); k++) {
                            thrust::device_ptr<char> sr((cc->d_columns)[k]);
                            thrust::copy_if(sr,sr+(c->mRecCount), d_grp, diff, nz<bool>());
                            cudaMemcpy((void*)(rr->h_columns[k] + r->mRecCount), (void*)thrust::raw_pointer_cast(diff) , c->grp_count, cudaMemcpyDeviceToHost);
                        };
                        thrust::device_free(diff);
                    }
                }
                else if (c->grp_type[j] == 2 || c->grp_type[j] == 1) {  // sum and avg

                    if (c->type[j] == 0) {
                        thrust::device_ptr<int_type> ss((int_type*)(c->d_columns)[j]);
                        thrust::reduce_by_key(d_grp, d_grp+(c->mRecCount), ss,
                                              thrust::make_discard_iterator(), ss,
                                              binary_pred_l,thrust::plus<int_type>());
                        cudaMemcpy((void*)((int_type*)r->h_columns[j] + r->mRecCount), (void*)thrust::raw_pointer_cast(ss) , c->grp_count*int_size, cudaMemcpyDeviceToHost);
                    }
                    else if (c->type[j] == 1) {
                        thrust::device_ptr<float_type> ss((float_type*)(c->d_columns)[j]);
                        thrust::reduce_by_key(d_grp, d_grp+(c->mRecCount), ss,
                                              thrust::make_discard_iterator(), ss,
                                              binary_pred_l,thrust::plus<float_type>());
                        cudaMemcpy((void*)((float_type*)r->h_columns[j] + r->mRecCount), (void*)thrust::raw_pointer_cast(ss) , c->grp_count*float_size, cudaMemcpyDeviceToHost);
                    }
                }
                else if (c->grp_type[j] == 0) {  // count
                    thrust::device_ptr<int_type> ss((int_type*)(c->d_columns)[j]);
                    thrust::reduce_by_key(d_grp, d_grp+(c->mRecCount), ss,
                                          thrust::make_discard_iterator(), ss,
                                          binary_pred_l,thrust::plus<int_type>());
                    cudaMemcpy((void*)((int_type*)r->h_columns[j] + r->mRecCount), (void*)thrust::raw_pointer_cast(ss) , c->grp_count*int_size, cudaMemcpyDeviceToHost);
                }
                else if(c->grp_type[j] == 4) {  // min
                    if (c->type[j] == 0) {
                        thrust::device_ptr<int_type> ss((int_type*)(c->d_columns)[j]);
                        thrust::reduce_by_key(d_grp, d_grp+(c->mRecCount), ss,
                                              thrust::make_discard_iterator(), ss,
                                              binary_pred_l,thrust::minimum<int_type>());
                        cudaMemcpy((void*)((int_type*)r->h_columns[j] + r->mRecCount), (void*)thrust::raw_pointer_cast(ss) , c->grp_count*int_size, cudaMemcpyDeviceToHost);
                    }
                    else if (c->type[j] == 1) {
                        thrust::device_ptr<float_type> ss((float_type*)(c->d_columns)[j]);
                        thrust::reduce_by_key(d_grp, d_grp+(c->mRecCount), ss,
                                              thrust::make_discard_iterator(), ss,
                                              binary_pred_l,thrust::minimum<float_type>());
                        cudaMemcpy((void*)((float_type*)r->h_columns[j] + r->mRecCount), (void*)thrust::raw_pointer_cast(ss) , c->grp_count*float_size, cudaMemcpyDeviceToHost);
                    };
                }
                else if(c->grp_type[j] == 5) {  // max
                    if (c->type[j] == 0) {
                        thrust::device_ptr<int_type> ss((int_type*)(c->d_columns)[j]);
                        thrust::reduce_by_key(d_grp, d_grp+(c->mRecCount), ss,
                                              thrust::make_discard_iterator(), ss,
                                              binary_pred_l,thrust::maximum<int_type>());
                        cudaMemcpy((void*)((int_type*)r->h_columns[j] + r->mRecCount), (void*)thrust::raw_pointer_cast(ss) , c->grp_count*int_size, cudaMemcpyDeviceToHost);
                    }
                    else if (c->type[j] == 1) {
                        thrust::device_ptr<float_type> ss((float_type*)(c->d_columns)[j]);
                        thrust::reduce_by_key(d_grp, d_grp+(c->mRecCount), ss,
                                              thrust::make_discard_iterator(), ss,
                                              binary_pred_l,thrust::maximum<float_type>());
                        cudaMemcpy((void*)((float_type*)r->h_columns[j] + r->mRecCount), (void*)thrust::raw_pointer_cast(ss) , c->grp_count*float_size, cudaMemcpyDeviceToHost);
                    };
                };
                c->deAllocColumnOnDevice(j);
            };


            if (avg_index != -1) {
                thrust::device_ptr<float_type> count_d = thrust::device_malloc<float_type>(c->grp_count);

                r->allocColumnOnDevice(countIndex,c->grp_count);
                r->CopyColumnToGpu(countIndex, r->mRecCount, c->grp_count);
                thrust::device_ptr<int_type> src((int_type*)(r->d_columns)[countIndex]);

                thrust::transform(src, src + c->grp_count, count_d, long_to_float_type());
                r->deAllocColumnOnDevice(countIndex);

                for(int k = 0; k < c->mColumnCount; k++)	{
                    if(c->grp_type[k] == 1) {   // AVG

                        r->allocColumnOnDevice(k, c->grp_count);
                        r->CopyColumnToGpu(k, r->mRecCount, c->grp_count);

                        if (c->type[k] == 0 ) { // int
                            // convert int field and count to float
                            thrust::device_ptr<int_type> s((int_type*)(r->d_columns)[k]);
                            thrust::device_ptr<float_type> d = thrust::device_malloc<float_type>(c->grp_count);
                            thrust::transform(s, s + c->grp_count, count_d, d, div_long_to_float_type());
                            cudaFreeHost(r->h_columns[k]);
                            r->type[k] = 1;
                            cudaMallocHost(&(r->h_columns[k]), c->grp_count*float_size);
                            r->d_columns[k] = thrust::raw_pointer_cast(d);
                        }
                        else  {             // float
                            thrust::device_ptr<float_type> s((float_type*)(r->d_columns)[k]);
                            thrust::transform(s, s + c->grp_count, count_d, s, thrust::divides<float_type>());
                        }
                        r->CopyColumnToHost(k, r->mRecCount, c->grp_count);
                        r->deAllocColumnOnDevice(k);
                    };
                };
                thrust::device_free(count_d);
            };
            r->mRecCount = r->mRecCount + c->grp_count;
        };
    };

    c->m_position.clear();
    c->m_size.clear();
    c->mRecCount = oldRecCount;
	r->segCount = 1;
	r->maxRecs = r->mRecCount;
    return r;

};



unsigned int findPartitionColumn(CudaSet* c, stack<string> op_v2)
{
    int colInd;
    unsigned int selectedColumn = 1000000;
    unsigned int maxDiff = 0, diffCurrent;

    if(c->mRecCount < 11) {
        cout << "FindPartitionColumn error : set is too small - there is no need for partitioning " << endl;
        exit(0);
    };


    while(!op_v2.empty()) {
        colInd = c->columnNames.find(op_v2.top())->second;
        diffCurrent = 0;
        for(int i =0; i < 10; i++)
            if(((int_type*)c->h_columns[colInd])[i] != ((int_type*)c->h_columns[colInd])[i+1])
                diffCurrent++;
        if(diffCurrent > maxDiff) {
            maxDiff = diffCurrent;
            selectedColumn = colInd;
        };
        op_v2.pop();
    };
    return selectedColumn;

}
