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

#include "merge.h"
#include "zone_map.h"

using namespace std;

void process_error(int severity, string err);	// this should probably live in a utils header file


#if defined(_MSC_VER)
#define BIG_CONSTANT(x) (x)
// Other compilers
#else   // defined(_MSC_VER)
#define BIG_CONSTANT(x) (x##LLU)
#endif // !defined(_MSC_VER)



struct float_avg
{
    __host__  float_type operator()(const float_type &lhs, const int_type &rhs) const {
        return lhs/rhs;
    }
};

struct float_avg1
{
    __host__  float_type operator()(const int_type &lhs, const int_type &rhs) const {
        return ((float_type)lhs)/rhs;
    }
};


/*struct float_avg  : public binary_function<float_type,int_type,float_type>
{
  __host__ __device__ float_type operator()(const float_type &lhs, const int_type &rhs) const {return lhs/(float_type)rhs;}
}; // end not_equal_to
*/





//typedef thrust::device_vector<int_type>::iterator    IntIterator;
//typedef thrust::tuple<IntIterator,IntIterator> IteratorTuple;
//typedef thrust::zip_iterator<IteratorTuple> ZipIterator;
unsigned int hash_seed = 100;
thrust::host_vector<unsigned long long int> h_merge;

using namespace std;
using namespace thrust::placeholders;


void create_c(CudaSet* c, CudaSet* b)
{
    map<string,unsigned int>::iterator it;
    c->not_compressed = 1;
    c->segCount = 1;

    c->columnNames = b->columnNames;
    h_merge.clear();
    c->cols = b->cols;
    c->type = b->type;
    c->decimal = b->decimal;
    c->grp_type = b->grp_type;

    for(unsigned int i=0; i < b->columnNames.size(); i++) {

        if (b->type[b->columnNames[i]] == 0) {
            c->h_columns_int[b->columnNames[i]] = thrust::host_vector<int_type, uninitialized_host_allocator<int_type> >();
            c->d_columns_int[b->columnNames[i]] = thrust::device_vector<int_type>();
        }
        else if (b->type[b->columnNames[i]] == 1) {
            c->h_columns_float[b->columnNames[i]] = thrust::host_vector<float_type, uninitialized_host_allocator<float_type> >();
            c->d_columns_float[b->columnNames[i]] = thrust::device_vector<float_type>();
        }
        else {
            c->h_columns_char[b->columnNames[i]] = NULL;
            c->d_columns_char[b->columnNames[i]] = NULL;
            c->char_size[b->columnNames[i]] = b->char_size[b->columnNames[i]];
        };
    };
}

void add(CudaSet* c, CudaSet* b, queue<string> op_v3, map<string,string> aliases,
         vector<thrust::device_vector<int_type> >& distinct_tmp, vector<thrust::device_vector<int_type> >& distinct_val,
         vector<thrust::device_vector<int_type> >& distinct_hash, CudaSet* a)
{
    if (c->columnNames.empty()) {
        // create d_columns and h_columns
        create_c(c,b);
    }

    size_t cycle_sz = op_v3.size();

    vector<string> opv;
    queue<string> ss;
    for(unsigned int z = 0; z < cycle_sz; z++) {
        if(std::find(b->columnNames.begin(), b->columnNames.end(), aliases[op_v3.front()]) == b->columnNames.end()) { //sanity check
            cout << "Syntax error: alias " << op_v3.front() << endl;
            exit(0);
        };
        opv.push_back(aliases[op_v3.front()]);
        ss.push(aliases[op_v3.front()]);
        op_v3.pop();
    };


    // create hashes of groupby columns
    unsigned long long int* hashes = new unsigned long long int[b->mRecCount];
    unsigned long long int* sum = new unsigned long long int[cycle_sz*b->mRecCount];
    b->CopyToHost(0, b->mRecCount);

    for(unsigned int z = 0; z < cycle_sz; z++) {
        if(b->type[opv[z]] == 0) {  //int
            //for(int i = 0; i < b->mRecCount; i++) {
            //sum[i*cycle_sz + z] = MurmurHash64A(&b->h_columns_int[opv[z]][i], 8, hash_seed);
            memcpy(&sum[z*b->mRecCount], thrust::raw_pointer_cast(b->h_columns_int[opv[z]].data()), b->mRecCount*8);
            //};
        }
        else if(b->type[opv[z]] == 2) {  //string
            for(int i = 0; i < b->mRecCount; i++) {
                sum[z*b->mRecCount + i] = MurmurHash64A(&b->h_columns_char[opv[z]][i*b->char_size[opv[z]]], b->char_size[opv[z]], hash_seed);
            };
        }
        else {  //float
            process_error(2, "No group by on float/decimal columns ");
            //cout << "No group by on float/decimal columns " << endl;
            //exit(0);
        };
    };

    for(int i = 0; i < b->mRecCount; i++) {
        hashes[i] = MurmurHash64S(&sum[i], 8, hash_seed, cycle_sz, b->mRecCount);
    };

    delete [] sum;
    thrust::device_vector<unsigned long long int> d_hashes(b->mRecCount);
    thrust::device_vector<unsigned int> v(b->mRecCount);
    thrust::sequence(v.begin(), v.end(), 0, 1);
    thrust::copy(hashes, hashes+b->mRecCount, d_hashes.begin());

    // sort the results by hash
    thrust::sort_by_key(d_hashes.begin(), d_hashes.end(), v.begin());

    void* d_tmp;
    CUDA_SAFE_CALL(cudaMalloc((void **) &d_tmp, b->mRecCount*max_char(b)));

    for(unsigned int i = 0; i < b->columnNames.size(); i++) {

        if(b->type[b->columnNames[i]] == 0) {
            //int_type* d_tmp = new int_type[b->mRecCount];
            thrust::device_ptr<int_type> d_tmp_int((int_type*)d_tmp);
            thrust::gather(v.begin(), v.end(), b->d_columns_int[b->columnNames[i]].begin(), d_tmp_int);
            thrust::copy(d_tmp_int, d_tmp_int + b->mRecCount, b->h_columns_int[b->columnNames[i]].begin());
            //delete [] d_tmp;
        }
        else if(b->type[b->columnNames[i]] == 1) {
            //float_type* d_tmp = new float_type[b->mRecCount];
            thrust::device_ptr<float_type> d_tmp_float((float_type*)d_tmp);
            thrust::gather(v.begin(), v.end(), b->d_columns_float[b->columnNames[i]].begin(), d_tmp_float);
            thrust::copy(d_tmp_float, d_tmp_float + b->mRecCount, b->h_columns_float[b->columnNames[i]].begin());
            //delete [] d_tmp;
        }
        else {
            //char* d_tmp = new char[b->mRecCount*b->char_size[b->columnNames[i]]];
            //thrust::device_ptr<char> d_tmp_char((char*)d_tmp);
            str_gather((void*)thrust::raw_pointer_cast(v.data()), b->mRecCount, b->d_columns_char[b->columnNames[i]], d_tmp, b->char_size[b->columnNames[i]]);
            //memcpy(b->h_columns_char[b->columnNames[i]], d_tmp, b->mRecCount*b->char_size[b->columnNames[i]]);
            cudaMemcpy(b->h_columns_char[b->columnNames[i]], d_tmp, b->mRecCount*b->char_size[b->columnNames[i]], cudaMemcpyDeviceToHost);
            //delete [] d_tmp;
        };
    };
    cudaFree(d_tmp);

    thrust::host_vector<unsigned long long int> hh(b->mRecCount);
    thrust::copy(d_hashes.begin(), d_hashes.end(), hh.begin());
    char* tmp = new char[max_char(b)*(c->mRecCount + b->mRecCount)];
    c->resize(b->mRecCount);

    //lets merge every column

    //MGPU_MEM(unsigned long long int) cKeys = context3->Malloc<unsigned long long int>(c->mRecCount + b->mRecCount);

    for(unsigned int i = 0; i < b->columnNames.size(); i++) {

        if(b->type[b->columnNames[i]] == 0) {

            thrust::merge_by_key(h_merge.begin(), h_merge.end(),
                                 hh.begin(), hh.end(),
                                 c->h_columns_int[c->columnNames[i]].begin(), b->h_columns_int[b->columnNames[i]].begin(),
                                 thrust::make_discard_iterator(), (int_type*)tmp);
            memcpy(thrust::raw_pointer_cast(c->h_columns_int[c->columnNames[i]].data()), (int_type*)tmp, (h_merge.size() + b->mRecCount)*int_size);
        }
        else if(b->type[b->columnNames[i]] == 1) {
            thrust::merge_by_key(h_merge.begin(), h_merge.end(),
                                 hh.begin(), hh.end(),
                                 c->h_columns_float[c->columnNames[i]].begin(), b->h_columns_float[b->columnNames[i]].begin(),
                                 thrust::make_discard_iterator(), (float_type*)tmp);
            memcpy(thrust::raw_pointer_cast(c->h_columns_float[c->columnNames[i]].data()), (float_type*)tmp, (h_merge.size() + b->mRecCount)*float_size);

        }
        else {
            str_merge_by_key(h_merge, hh, c->h_columns_char[c->columnNames[i]], b->h_columns_char[b->columnNames[i]], b->char_size[b->columnNames[i]], tmp);
            memcpy(c->h_columns_char[c->columnNames[i]], tmp, (h_merge.size() + b->mRecCount)*b->char_size[b->columnNames[i]]);
        };
    };


    //merge the keys
    thrust::merge(h_merge.begin(), h_merge.end(),
                  hh.begin(), hh.end(), (unsigned long long int*)tmp);

    size_t cpy_sz = h_merge.size() + b->mRecCount;
    h_merge.resize(h_merge.size() + b->mRecCount);
    thrust::copy((unsigned long long int*)tmp, (unsigned long long int*)tmp + cpy_sz, h_merge.begin());
    delete [] tmp;
    delete [] hashes;

    //cout << endl << "end b and c " << b->mRecCount << " " << c->mRecCount << endl;
    //for(int i = 0; i < h_merge.size();i++)
    //cout << "H " << h_merge[i] << endl;

    /*   bool dis_exists = 0;
        for(unsigned int j=0; j < c->mColumnCount; j++) {
            if (c->grp_type[j] == 6)
                dis_exists = 1;
        };

        if (dis_exists) {
            bool grp_scanned = 0;
            thrust::device_ptr<bool> d_di(a->grp);
            thrust::device_ptr<unsigned int> d_dii = thrust::device_malloc<unsigned int>(a->mRecCount);
            thrust::identity<bool> op;
            thrust::transform(d_di, d_di+a->mRecCount, d_dii, op);

            thrust::device_ptr<int_type> tmp = thrust::device_malloc<int_type>(a->mRecCount);

            unsigned int dist_count = 0;

            for(unsigned int j=0; j < c->mColumnCount; j++) {

                if (c->grp_type[j] == 6) {

                    if(!grp_scanned) {

                        d_dii[a->mRecCount-1] = 0;
                        thrust::inclusive_scan(d_dii, d_dii + a->mRecCount, d_dii);
                        thrust::gather(d_dii, d_dii + a->mRecCount, hashes.begin(), tmp);	// now hashes are in tmp
                        grp_scanned = 1;
                    };
                    unsigned int offset = distinct_val[dist_count].size();

                    distinct_val[dist_count].resize(distinct_val[dist_count].size() + a->mRecCount);
                    distinct_hash[dist_count].resize(distinct_hash[dist_count].size() + a->mRecCount);

                    thrust::copy(distinct_tmp[dist_count].begin(), distinct_tmp[dist_count].begin() + a->mRecCount, distinct_val[dist_count].begin() + offset);
                    thrust::copy(tmp, tmp + a->mRecCount, distinct_hash[dist_count].begin() + offset);

                    thrust::stable_sort_by_key(distinct_val[dist_count].begin(), distinct_val[dist_count].end(), distinct_hash[dist_count].begin());
                    thrust::stable_sort_by_key(distinct_hash[dist_count].begin(), distinct_hash[dist_count].end(), distinct_val[dist_count].begin());

                    ZipIterator new_last = thrust::unique(thrust::make_zip_iterator(thrust::make_tuple(distinct_hash[dist_count].begin(), distinct_val[dist_count].begin())),
                                                          thrust::make_zip_iterator(thrust::make_tuple(distinct_hash[dist_count].end(), distinct_val[dist_count].end())));

                    IteratorTuple t = new_last.get_iterator_tuple();
                    distinct_val[dist_count].resize(thrust::get<0>(t) - distinct_hash[dist_count].begin());
                    distinct_hash[dist_count].resize(thrust::get<0>(t) - distinct_hash[dist_count].begin());

                    dist_count++;

                };
            };
            thrust::device_free(tmp);
            thrust::device_free(d_dii);
        };
    	*/


}


void count_simple(CudaSet* c)
{
    int_type count;

    for(unsigned int i = 0; i < c->columnNames.size(); i++) {
        if(c->grp_type[c->columnNames[i]] == 0) { // COUNT
            count = thrust::reduce(c->h_columns_int[c->columnNames[i]].begin(), c->h_columns_int[c->columnNames[i]].begin() + c->mRecCount);
            c->h_columns_int[c->columnNames[i]][0] = count;
        };
    };


    if (c->mRecCount != 0) {

        for(unsigned int k = 0; k < c->columnNames.size(); k++) {
            if(c->grp_type[c->columnNames[k]] == 1) {   // AVG
                if(c->type[c->columnNames[k]] == 0) {
                    int_type sum  = thrust::reduce(c->h_columns_int[c->columnNames[k]].begin(), c->h_columns_int[c->columnNames[k]].begin() + c->mRecCount);
                    c->h_columns_int[c->columnNames[k]][0] = sum/count;
                }
                if(c->type[c->columnNames[k]] == 1) {
                    float_type sum  = thrust::reduce(c->h_columns_float[c->columnNames[k]].begin(), c->h_columns_float[c->columnNames[k]].begin() + c->mRecCount);
                    c->h_columns_float[c->columnNames[k]][0] = sum/count;
                };
            }
            else if(c->grp_type[c->columnNames[k]] == 2) {   // SUM
                if(c->type[c->columnNames[k]] == 0) {
                    int_type sum  = thrust::reduce(c->h_columns_int[c->columnNames[k]].begin(), c->h_columns_int[c->columnNames[k]].begin() + c->mRecCount);
                    c->h_columns_int[c->columnNames[k]][0] = sum;
                }
                if(c->type[c->columnNames[k]] == 1) {
                    float_type sum  = thrust::reduce(c->h_columns_float[c->columnNames[k]].begin(), c->h_columns_float[c->columnNames[k]].begin() + c->mRecCount);
                    c->h_columns_float[c->columnNames[k]][0] = sum;
                };

            }
        };
    }
    c->mRecCount = 1;
};


void count_avg(CudaSet* c,  vector<thrust::device_vector<int_type> >& distinct_hash)
{
    string countstr;
    thrust::equal_to<unsigned long long int> binary_pred;
    thrust::maximum<unsigned long long int> binary_op_max;
    thrust::minimum<unsigned long long int> binary_op_min;

    for(unsigned int i = 0; i < c->columnNames.size(); i++) {
        if(c->grp_type[c->columnNames[i]] == 0) { // COUNT
            countstr = c->columnNames[i];
            break;
        };
    };


    thrust::host_vector<bool> grp;
    size_t res_count;

    if(h_merge.size()) {
        grp.resize(h_merge.size());
        thrust::adjacent_difference(h_merge.begin(), h_merge.end(), grp.begin());
        res_count = h_merge.size() - thrust::count(grp.begin(), grp.end(), 0);
    };


    if (c->mRecCount != 0) {

        //unsigned int dis_count = 0;
        if (h_merge.size()) {
            for(unsigned int k = 0; k < c->columnNames.size(); k++)	{

                if(c->grp_type[c->columnNames[k]] <= 2) { //sum || avg || count
                    if (c->type[c->columnNames[k]] == 0 ) { // int


                        int_type* tmp =  new int_type[res_count];
                        thrust::reduce_by_key(h_merge.begin(), h_merge.end(), c->h_columns_int[c->columnNames[k]].begin(),
                                              thrust::make_discard_iterator(), tmp);
                        c->h_columns_int[c->columnNames[k]].resize(res_count);
                        thrust::copy(tmp, tmp + res_count, c->h_columns_int[c->columnNames[k]].begin());
                        delete [] tmp;
                    }
                    else if (c->type[c->columnNames[k]] == 1 ) { // float
                        float_type* tmp =  new float_type[res_count];
                        thrust::reduce_by_key(h_merge.begin(), h_merge.end(), c->h_columns_float[c->columnNames[k]].begin(),
                                              thrust::make_discard_iterator(), tmp);
                        c->h_columns_float[c->columnNames[k]].resize(res_count);
                        thrust::copy(tmp, tmp + res_count, c->h_columns_float[c->columnNames[k]].begin());
                        delete [] tmp;
                    };
                }
                if(c->grp_type[c->columnNames[k]] == 4) { //min
                    if (c->type[c->columnNames[k]] == 0 ) { // int
                        int_type* tmp =  new int_type[res_count];
                        thrust::reduce_by_key(h_merge.begin(), h_merge.end(), c->h_columns_int[c->columnNames[k]].begin(),
                                              thrust::make_discard_iterator(), tmp, binary_pred, binary_op_min);
                        c->h_columns_int[c->columnNames[k]].resize(res_count);
                        thrust::copy(tmp, tmp + res_count, c->h_columns_int[c->columnNames[k]].begin());
                        delete [] tmp;
                    }
                    else if (c->type[c->columnNames[k]] == 1 ) { // float
                        float_type* tmp =  new float_type[res_count];
                        thrust::reduce_by_key(h_merge.begin(), h_merge.end(), c->h_columns_float[c->columnNames[k]].begin(),
                                              thrust::make_discard_iterator(), tmp, binary_pred, binary_op_min);
                        c->h_columns_float[c->columnNames[k]].resize(res_count);
                        thrust::copy(tmp, tmp + res_count, c->h_columns_float[c->columnNames[k]].begin());
                        delete [] tmp;
                    };
                }
                if(c->grp_type[c->columnNames[k]] == 5) { //max
                    if (c->type[c->columnNames[k]] == 0 ) { // int
                        int_type* tmp =  new int_type[res_count];
                        thrust::reduce_by_key(h_merge.begin(), h_merge.end(), c->h_columns_int[c->columnNames[k]].begin(),
                                              thrust::make_discard_iterator(), tmp, binary_pred, binary_op_max);
                        c->h_columns_int[c->columnNames[k]].resize(res_count);
                        thrust::copy(tmp, tmp + res_count, c->h_columns_int[c->columnNames[k]].begin());
                        delete [] tmp;
                    }
                    else if (c->type[c->columnNames[k]] == 1 ) { // float
                        float_type* tmp =  new float_type[res_count];
                        thrust::reduce_by_key(h_merge.begin(), h_merge.end(), c->h_columns_float[c->columnNames[k]].begin(),
                                              thrust::make_discard_iterator(), tmp, binary_pred, binary_op_max);
                        c->h_columns_float[c->columnNames[k]].resize(res_count);
                        thrust::copy(tmp, tmp + res_count, c->h_columns_float[c->columnNames[k]].begin());
                        delete [] tmp;
                    };
                }
                else if(c->grp_type[c->columnNames[k]] == 3) { //no group function
                    if (c->type[c->columnNames[k]] == 0 ) { // int
                        int_type* tmp =  new int_type[res_count];
                        thrust::reduce_by_key(h_merge.begin(), h_merge.end(), c->h_columns_int[c->columnNames[k]].begin(),
                                              thrust::make_discard_iterator(), tmp, binary_pred, binary_op_max);
                        c->h_columns_int[c->columnNames[k]].resize(res_count);
                        thrust::copy(tmp, tmp + res_count, c->h_columns_int[c->columnNames[k]].begin());
                        delete [] tmp;
                    }
                    else if (c->type[c->columnNames[k]] == 1 ) { // float
                        float_type* tmp =  new float_type[res_count];
                        thrust::reduce_by_key(h_merge.begin(), h_merge.end(), c->h_columns_float[c->columnNames[k]].begin(),
                                              thrust::make_discard_iterator(), tmp, binary_pred, binary_op_max);
                        c->h_columns_float[c->columnNames[k]].resize(res_count);
                        thrust::copy(tmp, tmp + res_count, c->h_columns_float[c->columnNames[k]].begin());
                        delete [] tmp;
                    }
                    else { //char
                        char* tmp = new char[res_count*c->char_size[c->columnNames[k]]];
                        str_copy_if_host(c->h_columns_char[c->columnNames[k]], c->mRecCount, tmp, grp, c->char_size[c->columnNames[k]]);
                        thrust::copy(tmp, tmp + c->char_size[c->columnNames[k]]*res_count, c->h_columns_char[c->columnNames[k]]);
                        delete [] tmp;
                    };
                };
            };

            c->mRecCount = res_count;
        };

        for(unsigned int k = 0; k < c->columnNames.size(); k++)	{
            if(c->grp_type[c->columnNames[k]] == 1) {   // AVG

                if (c->type[c->columnNames[k]] == 0 ) { // int
                    //create a float column k
                    c->h_columns_float[c->columnNames[k]] = thrust::host_vector<float_type, uninitialized_host_allocator<float_type> >(c->mRecCount);
                    c->d_columns_float[c->columnNames[k]] = thrust::device_vector<float_type>();

                    thrust::transform(c->h_columns_int[c->columnNames[k]].begin(), c->h_columns_int[c->columnNames[k]].begin() + c->mRecCount,
                                      c->h_columns_int[countstr].begin(), c->h_columns_float[c->columnNames[k]].begin(), float_avg1());
                    c->type[c->columnNames[k]] = 1;
                    c->h_columns_int[c->columnNames[k]].resize(0);
                    c->h_columns_int[c->columnNames[k]].shrink_to_fit();
                    c->grp_type[c->columnNames[k]] = 3;
                }
                else {              // float
                    thrust::transform(c->h_columns_float[c->columnNames[k]].begin(), c->h_columns_float[c->columnNames[k]].begin() + c->mRecCount,
                                      c->h_columns_int[countstr].begin(), c->h_columns_float[c->columnNames[k]].begin(), float_avg());
                };
            }
            else if(c->grp_type[c->columnNames[k]] == 6) {
                /*   unsigned int res_count = 0;

                   thrust::host_vector<int_type> h_hash = distinct_hash[dis_count];
                   int_type curr_val = h_hash[0];
                   unsigned int cycle_sz = h_hash.size();

                   for(unsigned int i = 0; i < cycle_sz; i++) {
                       if (h_hash[i] == curr_val) {
                           res_count++;
                           if(i == cycle_sz-1) {
                               c->h_columns_int[c->columnNames[k]][mymap[h_hash[i]]] = res_count;
                           };
                       }
                       else {
                           unsigned int idx = mymap[h_hash[i-1]];
                           c->h_columns_int[c->columnNames[k]][idx] = res_count;
                           curr_val = h_hash[i];
                           res_count = 1;
                       };
                   };
                   dis_count++;*/
            }
            else if(c->grp_type[c->columnNames[k]] == 2) {

            };
        };

    };

    c->segCount = 1;
    c->maxRecs = c->mRecCount;
};

