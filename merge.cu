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

head_flag_predicate<bool> binary_pred_l;

void add(CudaSet* c, CudaSet* b, queue<string> op_v3)
{
    if (c->columnNames.empty()) {
        // create d_columns and h_columns
        
        map<int,string> columnNames1;
		map<string,int>::iterator it;

        for (  it=b->columnNames.begin() ; it != b->columnNames.end(); ++it ) {
            c->columnNames[(*it).first] = (*it).second;			
            columnNames1[(*it).second] = (*it).first;
        };

        string f_name;
        c->grp_type = new unsigned int[c->mColumnCount];

        for(unsigned int i=0; i < b->mColumnCount; i++) {
            c->cols[i] = b->cols[i];
            c->type[i] = b->type[i];
            c->grp_type[i] = b->grp_type[i];

            if (b->type[i] == 0) {
                c->h_columns_int.push_back(thrust::host_vector<int_type>(c->mRecCount+1));
                c->d_columns_int.push_back(thrust::device_vector<int_type>());
                c->type_index[i] = c->h_columns_int.size()-1;
            }
            else if (b->type[i] == 1) {
                c->h_columns_float.push_back(thrust::host_vector<float_type>(c->mRecCount+1));
                c->d_columns_float.push_back(thrust::device_vector<float_type>());
                c->type_index[i] = c->h_columns_float.size()-1;
            }
            else {
                c->h_columns_cuda_char.push_back(new CudaChar((b->h_columns_cuda_char[b->type_index[i]])->mColumnCount, c->mRecCount));
                c->type_index[i] = c->h_columns_cuda_char.size()-1;
            };
        };
    }
    // append b to c
    for(unsigned int i=0; i < b->mColumnCount; i++) {
        if (b->type[i] == 0 )
            thrust::copy(b->d_columns_int[b->type_index[i]].begin(), b->d_columns_int[b->type_index[i]].begin() + b->mRecCount,
                         c->h_columns_int[c->type_index[i]].begin() + (c->mRecCount-b->mRecCount));
        else if (b->type[i] == 1 )
            thrust::copy(b->d_columns_float[b->type_index[i]].begin(), b->d_columns_float[b->type_index[i]].begin() + b->mRecCount,
                         c->h_columns_float[c->type_index[i]].begin() + (c->mRecCount-b->mRecCount));
        else { //CudaChar
            CudaChar *s = b->h_columns_cuda_char[b->type_index[i]];
            CudaChar *d = c->h_columns_cuda_char[c->type_index[i]];
            for(unsigned int j=0; j < s->mColumnCount; j++)
                thrust::copy(s->d_columns[j].begin(), s->d_columns[j].begin() + b->mRecCount, d->h_columns[j].begin()+(c->mRecCount-b->mRecCount));
        };
    };
}


void order_inplace(CudaSet* a, stack<string> exe_type, map<string,string> aliases)
{
    thrust::device_ptr<unsigned int> permutation = thrust::device_malloc<unsigned int>(a->mRecCount);
    thrust::sequence(permutation, permutation+(a->mRecCount));

    void* temp;
    CUDA_SAFE_CALL(cudaMalloc((void **) &temp, a->mRecCount*float_size));
    unsigned int* raw_ptr = thrust::raw_pointer_cast(permutation);

    for(int i=0; !exe_type.empty(); ++i, exe_type.pop()) {

        if ((a->columnNames).find(aliases[exe_type.top()]) ==  a->columnNames.end()) {
            cout << "Sort couldn't find field " << exe_type.top() << endl;
            exit(1);
        };

        int colInd = (a->columnNames).find(aliases[exe_type.top()])->second;

        if(!a->onDevice(colInd) && a->type[colInd] < 2) {
            a->allocColumnOnDevice(colInd,a->mRecCount);
            a->CopyColumnToGpu(colInd, 0, a->mRecCount);
        };

        if ((a->type)[colInd] == 0)
            update_permutation(a->d_columns_int[a->type_index[colInd]], raw_ptr, a->mRecCount, "ASC", (int_type*)temp);
        else if ((a->type)[colInd] == 1)
            update_permutation(a->d_columns_float[a->type_index[colInd]], raw_ptr, a->mRecCount,"ASC", (float_type*)temp);
        else {
            CudaChar* c = a->h_columns_cuda_char[a->type_index[colInd]];
            thrust::device_ptr<char> tmp = thrust::device_malloc<char>(a->mRecCount);

            for(int j=(c->mColumnCount)-1; j>=0 ; j--) {
                c->d_columns[j].resize(a->mRecCount);
                thrust::copy(c->h_columns[j].begin(), c->h_columns[j].begin() + a->mRecCount, c->d_columns[j].begin());
                update_permutation(c->d_columns[j], raw_ptr, a->mRecCount, "ASC", thrust::raw_pointer_cast(tmp));
                c->d_columns[j].resize(0);
                c->d_columns[j].shrink_to_fit();
            };
            thrust::device_free(tmp);
        };
        a->deAllocColumnOnDevice(colInd);
    };


    for(unsigned int i=0; i < a->mColumnCount; i++) {
        if(!a->onDevice(i) && a->type[i] < 2) {
            a->allocColumnOnDevice(i,a->mRecCount);
            a->CopyColumnToGpu(i, 0, a->mRecCount);
        };

        if (a->type[i] == 0)
            apply_permutation(a->d_columns_int[a->type_index[i]], raw_ptr, a->mRecCount, (int_type*)temp);
        else if (a->type[i] == 1)
            apply_permutation(a->d_columns_float[a->type_index[i]], raw_ptr, a->mRecCount, (float_type*)temp);
        else {
            CudaChar* c = a->h_columns_cuda_char[a->type_index[i]];
            for(int j=(c->mColumnCount)-1; j>=0 ; j--) {
                c->d_columns[j].resize(c->mRecCount);
                thrust::copy(c->h_columns[j].begin(), c->h_columns[j].begin() + c->mRecCount, c->d_columns[j].begin());
                apply_permutation(c->d_columns[j], raw_ptr, a->mRecCount, (char*)temp);
                thrust::copy(c->d_columns[j].begin(), c->d_columns[j].begin() + c->mRecCount, c->h_columns[j].begin());
                c->d_columns[j].resize(0);
                c->d_columns[j].shrink_to_fit();
            };
        };
        if (a->type[i] != 2)
            a->CopyColumnToHost(i);
        a->deAllocColumnOnDevice(i);
    };
    thrust::device_free(permutation);
    cudaFree(temp);
}



CudaSet* merge(CudaSet* c, queue<string> op_v3, stack<string> op_v2, map<string,string> aliases)
{
    int countIndex;
    int avg_index = -1;

    for(unsigned int i = 0; i < c->mColumnCount; i++) {
        if(c->grp_type[i] == 0) // COUNT
            countIndex = i;
        else if(c->grp_type[i] == 1) // AVG
            avg_index = i;
    };

    CudaSet *r = c->copyStruct(c->mRecCount);

    r->mRecCount = 0;

    if (c->mRecCount != 0) {
        order_inplace(c,op_v2, aliases);		
	
		//change op_v3 to aliases
		queue<string> op;
		for(int i = 0; i < op_v3.size(); op_v3.pop())
		    op.push(aliases[op_v3.front()]);		
		
        c->GroupBy(op);		

        thrust::device_ptr<bool> d_grp(c->grp);

        for(unsigned int j=0; j < c->mColumnCount; j++) {
            c->allocColumnOnDevice(j, c->mRecCount);
            c->CopyColumnToGpu(j, 0, c->mRecCount);

            if (c->grp_type[j] == 3) {	      	  	  // non-grouped columns
                if (c->type[j] == 0) {
                    thrust::device_ptr<int_type> diff = thrust::device_malloc<int_type>(c->grp_count);
                    thrust::copy_if(c->d_columns_int[c->type_index[j]].begin(), c->d_columns_int[c->type_index[j]].begin() + (c->mRecCount), d_grp, diff, nz<bool>());
                    thrust::copy(diff, diff+c->grp_count, r->h_columns_int[r->type_index[j]].begin() + r->mRecCount);
                    thrust::device_free(diff);
                }
                else if (c->type[j] == 1) {
                    thrust::device_ptr<float_type> diff = thrust::device_malloc<float_type>(c->grp_count);
                    thrust::copy_if(c->d_columns_float[c->type_index[j]].begin(), c->d_columns_float[c->type_index[j]].begin() + (c->mRecCount), d_grp, diff, nz<bool>());
                    thrust::copy(diff, diff+c->grp_count, r->h_columns_float[r->type_index[j]].begin() + r->mRecCount);
                    thrust::device_free(diff);
                }
                else if (c->type[j] == 2) {
                    CudaChar *cc = c->h_columns_cuda_char[c->type_index[j]];
                    CudaChar *rr = r->h_columns_cuda_char[r->type_index[j]];
                    thrust::device_ptr<char> diff = thrust::device_malloc<char>(c->grp_count);

                    for(unsigned int k=0; k < (cc->mColumnCount); k++) {
                        thrust::copy_if(cc->d_columns[k].begin(),cc->d_columns[k].begin() + c->mRecCount, d_grp, diff, nz<bool>());
                        thrust::copy(diff,diff+c->grp_count,rr->h_columns[k].begin() + r->mRecCount);
                    };
                    thrust::device_free(diff);
                }
            }
            else if (c->grp_type[j] == 2 || c->grp_type[j] == 1) {  // sum and avg

                if (c->type[j] == 0) {
                    thrust::reduce_by_key(d_grp, d_grp+(c->mRecCount), c->d_columns_int[c->type_index[j]].begin(),
                                          thrust::make_discard_iterator(), c->d_columns_int[c->type_index[j]].begin(),
                                          binary_pred_l,thrust::plus<int_type>());
                    thrust::copy(c->d_columns_int[c->type_index[j]].begin(), c->d_columns_int[c->type_index[j]].begin() + c->grp_count, r->h_columns_int[r->type_index[j]].begin() + r->mRecCount);
                }
                else if (c->type[j] == 1) {
                    thrust::reduce_by_key(d_grp, d_grp+(c->mRecCount), c->d_columns_float[c->type_index[j]].begin(),
                                          thrust::make_discard_iterator(), c->d_columns_float[c->type_index[j]].begin(),
                                          binary_pred_l,thrust::plus<float_type>());
                    thrust::copy(c->d_columns_float[c->type_index[j]].begin(), c->d_columns_float[c->type_index[j]].begin() + c->grp_count, r->h_columns_float[r->type_index[j]].begin() + r->mRecCount);
                }
            }
            else if (c->grp_type[j] == 0) {  // count
                thrust::reduce_by_key(d_grp, d_grp+(c->mRecCount), c->d_columns_int[c->type_index[j]].begin(),
                                      thrust::make_discard_iterator(), c->d_columns_int[c->type_index[j]].begin(),
                                      binary_pred_l,thrust::plus<int_type>());
                thrust::copy(c->d_columns_int[c->type_index[j]].begin(), c->d_columns_int[c->type_index[j]].begin() + c->grp_count, r->h_columns_int[r->type_index[j]].begin() + r->mRecCount);
            }
            else if(c->grp_type[j] == 4) {  // min
                if (c->type[j] == 0) {
                    thrust::reduce_by_key(d_grp, d_grp+(c->mRecCount), c->d_columns_int[c->type_index[j]].begin(),
                                          thrust::make_discard_iterator(), c->d_columns_int[c->type_index[j]].begin(),
                                          binary_pred_l,thrust::minimum<int_type>());
                    thrust::copy(c->d_columns_int[c->type_index[j]].begin(), c->d_columns_int[c->type_index[j]].begin() + c->grp_count, r->h_columns_int[r->type_index[j]].begin() + r->mRecCount);
                }
                else if (c->type[j] == 1) {
                    thrust::reduce_by_key(d_grp, d_grp+(c->mRecCount), c->d_columns_float[c->type_index[j]].begin(),
                                          thrust::make_discard_iterator(), c->d_columns_float[c->type_index[j]].begin(),
                                          binary_pred_l,thrust::minimum<float_type>());
                    thrust::copy(c->d_columns_float[c->type_index[j]].begin(), c->d_columns_float[c->type_index[j]].begin() + c->grp_count, r->h_columns_float[r->type_index[j]].begin() + r->mRecCount);
                };
            }
            else if(c->grp_type[j] == 5) {  // max
                if (c->type[j] == 0) {
                    thrust::reduce_by_key(d_grp, d_grp+(c->mRecCount), c->d_columns_int[c->type_index[j]].begin(),
                                          thrust::make_discard_iterator(), c->d_columns_int[c->type_index[j]].begin(),
                                          binary_pred_l,thrust::maximum<int_type>());
                    thrust::copy(c->d_columns_int[c->type_index[j]].begin(), c->d_columns_int[c->type_index[j]].begin() + c->grp_count, r->h_columns_int[r->type_index[j]].begin() + r->mRecCount);
                }
                else if (c->type[j] == 1) {
                    thrust::reduce_by_key(d_grp, d_grp+(c->mRecCount), c->d_columns_float[c->type_index[j]].begin(),
                                          thrust::make_discard_iterator(), c->d_columns_float[c->type_index[j]].begin(),
                                          binary_pred_l,thrust::maximum<float_type>());
                    thrust::copy(c->d_columns_float[c->type_index[j]].begin(), c->d_columns_float[c->type_index[j]].begin() + c->grp_count, r->h_columns_float[r->type_index[j]].begin() + r->mRecCount);
                };
            };
            c->deAllocColumnOnDevice(j);
        };

        if (avg_index != -1) {
            thrust::device_ptr<float_type> count_d = thrust::device_malloc<float_type>(c->grp_count);

            r->allocColumnOnDevice(countIndex,c->grp_count);
            r->CopyColumnToGpu(countIndex, r->mRecCount, c->grp_count);
            thrust::transform(r->d_columns_int[r->type_index[countIndex]].begin(), r->d_columns_int[r->type_index[countIndex]].begin() + c->grp_count, count_d, long_to_float_type());
            r->deAllocColumnOnDevice(countIndex);

            for(unsigned int k = 0; k < c->mColumnCount; k++)	{
                if(c->grp_type[k] == 1) {   // AVG

                    r->allocColumnOnDevice(k, c->grp_count);
                    r->CopyColumnToGpu(k, r->mRecCount, c->grp_count);
                    unsigned int idx;

                    if (c->type[k] == 0 ) { // int

                        //create a float column k

                        r->h_columns_float.push_back(thrust::host_vector<float_type>(c->grp_count));
                        r->d_columns_float.push_back(thrust::device_vector<float_type>(c->grp_count));
                        idx = r->h_columns_float.size()-1;

                        thrust::transform(r->d_columns_int[r->type_index[k]].begin(), r->d_columns_int[r->type_index[k]].begin() + c->grp_count, count_d,
                                          r->d_columns_float[idx].begin(), div_long_to_float_type());
                        r->type[k] = 1;
                        //dealloc k on device and host
                        r->d_columns_int[r->type_index[k]].resize(0);
                        r->d_columns_int[r->type_index[k]].shrink_to_fit();
                        r->h_columns_int[r->type_index[k]].resize(0);
                        r->h_columns_int[r->type_index[k]].shrink_to_fit();
                        r->type_index[k] = idx;
                    }
                    else               // float
                        thrust::transform(r->d_columns_float[r->type_index[k]].begin(), r->d_columns_float[r->type_index[k]].begin() + c->grp_count, count_d, r->d_columns_float[r->type_index[k]].begin(), thrust::divides<float_type>());
                    r->CopyColumnToHost(k, r->mRecCount, c->grp_count);
                    r->deAllocColumnOnDevice(k);
                };
            };
            thrust::device_free(count_d);
        };
        r->mRecCount = r->mRecCount + c->grp_count;
    };

    r->segCount = 1;
    r->maxRecs = r->mRecCount;
    return r;

};



