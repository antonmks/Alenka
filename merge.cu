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


typedef thrust::device_vector<int_type>::iterator    IntIterator;
typedef thrust::tuple<IntIterator,IntIterator> IteratorTuple;
typedef thrust::zip_iterator<IteratorTuple> ZipIterator;
unsigned long long int hash_seed;

using namespace std;


int myPow(long long int x, long long int p)
{
    if (p == 0) return 1;
    if (p == 1) return x;

    int tmp = myPow(x, p/2);
    if (p%2 == 0) return tmp * tmp;
    else return x * tmp * tmp;
}

char *trimwhitespace(char *str)
{
    char *end;

    // Trim leading space
    while(isspace(*str)) str++;

    if(*str == 0)  // All spaces?
        return str;

    // Trim trailing space
    end = str + strlen(str) - 1;
    while(end > str && isspace(*end)) end--;

    // Write new null terminator
    *(end+1) = 0;

    return str;
}

void create_c(CudaSet* c, CudaSet* b)
{
    map<string,int>::iterator it;
    c->not_compressed = 1;
    c->segCount = 1;

    for (  it=b->columnNames.begin() ; it != b->columnNames.end(); ++it ) {
        c->columnNames[(*it).first] = (*it).second;
    };

    c->grp_type = new unsigned int[c->mColumnCount];

    for(unsigned int i=0; i < b->mColumnCount; i++) {
        c->cols[i] = b->cols[i];
        c->type[i] = b->type[i];
        c->grp_type[i] = b->grp_type[i];

        if (b->type[i] == 0) {
            c->h_columns_int.push_back(thrust::host_vector<int_type, uninitialized_host_allocator<int_type> >());
            c->d_columns_int.push_back(thrust::device_vector<int_type>());
        }
        else if (b->type[i] == 1) {
            c->h_columns_float.push_back(thrust::host_vector<float_type, uninitialized_host_allocator<float_type> >());
            c->d_columns_float.push_back(thrust::device_vector<float_type>());
        }
        else {
            c->h_columns_char.push_back(NULL);
            c->d_columns_char.push_back(NULL);
            //c->char_size.push_back(b->char_size[b->type_index[i]]);
        };
        c->type_index[i] = b->type_index[i];
        c->char_size = b->char_size;
    };
}

void add(CudaSet* c, CudaSet* b, queue<string> op_v3, boost::unordered_map<long long int, unsigned int>& mymap, map<string,string> aliases,
         vector<thrust::device_vector<int_type> >& distinct_tmp, vector<thrust::device_vector<int_type> >& distinct_val,
         vector<thrust::device_vector<int_type> >& distinct_hash, CudaSet* a)
{

    if (c->columnNames.empty()) {
        // create d_columns and h_columns
        create_c(c,b);
    }



    boost::unordered_map<long long int, unsigned int>::const_iterator got;

    b->CopyToHost(0, b->mRecCount);

    // store in a variable c only unique records
    // we have do it on a host because the hash table for the expected set sizes(~5 bln records) won't fit into a GPU memory
    // gonna be kinda on the slow side


    unsigned long long int *b_hash = new unsigned long long int[b->mRecCount];
    unsigned int idx;
    queue<string> op_v(op_v3);
    unsigned int cycle_sz = op_v.size();
    vector<unsigned int> opv;
    for(unsigned int z = 0; z < cycle_sz; z++) {
        opv.push_back(b->columnNames[aliases[op_v.front()]]);
        op_v.pop();
    };



    unsigned int tot_sz = 0;
    for(unsigned int z = 0; z < cycle_sz; z++) {
        idx = opv[z];
        if(b->type[idx] == 0) {  //int
            tot_sz = tot_sz + int_size;
        }
        else {
            tot_sz = tot_sz +  b->char_size[b->type_index[idx]];
        };
    };
    char* data = new char[tot_sz];
    data[tot_sz-1] = '\0';
    unsigned int curr;
    char* tmp1 = new char[101];

    char* prn = new char[101];
    unsigned long long int loc, res;
    unsigned long long int* sum = new unsigned long long int[cycle_sz];

    for(unsigned int i = 0; i < b->mRecCount; i++) {
        res = 0;
        curr = 0;
        for(unsigned int z = 0; z < cycle_sz; z++) {
            idx = opv[z];

            if(b->type[idx] == 0) {  //int
                loc = MurmurHash64A(&b->h_columns_int[b->type_index[idx]][i], int_size, hash_seed);
            }
            else if(b->type[idx] == 2) {  //string
                loc = MurmurHash64A(&b->h_columns_char[b->type_index[idx]][i*b->char_size[b->type_index[idx]]], b->char_size[b->type_index[idx]], hash_seed);
            }
            else {  //float
                exit(0);
            };
            sum[curr] = loc;
            curr++;
        };
        res = MurmurHash64A(sum, cycle_sz*8, hash_seed);
        b_hash[i] = res;
    };


    //resize c
    unsigned int cnt = 0;
    for(unsigned int i = 0; i < b->mRecCount; i++) {
        got = mymap.find(b_hash[i]);
        if(got == mymap.end())
            cnt++;
    };
    unsigned int old_cnt = c->mRecCount;
    if(cnt)
        c->resize(cnt);


    // now lets add to c those records that are not already there and update those that are there

    for(unsigned int i = 0; i < b->mRecCount; i++) {

        got = mymap.find(b_hash[i]);
        if(got == mymap.end()) {	//not found, need to insert
            //	cout << "insert " << b_hash[i] << endl;
            mymap[b_hash[i]] = old_cnt;
            for(unsigned int j=0; j < b->mColumnCount; j++) {

                if(b->type[j] == 0) {  //int
                    c->h_columns_int[c->type_index[j]][old_cnt] = b->h_columns_int[b->type_index[j]][i];
                }
                else if(b->type[j] == 1) {  //float
                    c->h_columns_float[c->type_index[j]][old_cnt] = b->h_columns_float[b->type_index[j]][i];
                }
                else if(b->type[j] == 2) {  //string
                    memcpy(c->h_columns_char[c->type_index[j]] + old_cnt*b->char_size[b->type_index[j]], b->h_columns_char[b->type_index[j]] + i*b->char_size[b->type_index[j]],
                           b->char_size[b->type_index[j]]);
                };
            };
            old_cnt++;
        }
        else { //need to update
            //cout << "update " << i << ":" << got->second << " " << b_hash[i] << endl;
            for(unsigned int j=0; j < b->mColumnCount; j++) {

                if (c->grp_type[j] == 2 || c->grp_type[j] == 1 || c->grp_type[j] == 0 ) {  // SUM || AVG || COUNT
                    if (c->type[j] == 0) {
                        c->h_columns_int[c->type_index[j]][got->second] +=  b->h_columns_int[b->type_index[j]][i];
                    }
                    else {
                        c->h_columns_float[c->type_index[j]][got->second] += b->h_columns_float[b->type_index[j]][i];
                    };
                }
                else if(c->grp_type[j] == 4) {  // MIN
                    if (c->type[j] == 0) {
                        if (c->h_columns_int[c->type_index[j]][got->second] >  b->h_columns_int[b->type_index[j]][i])
                            c->h_columns_int[c->type_index[j]][got->second] =  b->h_columns_int[b->type_index[j]][i];
                    }
                    else {
                        if (c->h_columns_float[c->type_index[j]][got->second] > b->h_columns_float[b->type_index[j]][i])
                            c->h_columns_float[c->type_index[j]][got->second] = b->h_columns_float[b->type_index[j]][i];
                    };
                }
                else if(c->grp_type[j] == 5) {  // MAX
                    if (c->type[j] == 0) {
                        if (c->h_columns_int[c->type_index[j]][got->second] <  b->h_columns_int[b->type_index[j]][i])
                            c->h_columns_int[c->type_index[j]][got->second] =  b->h_columns_int[b->type_index[j]][i];
                    }
                    else {
                        if (c->h_columns_float[c->type_index[j]][got->second] < b->h_columns_float[b->type_index[j]][i])
                            c->h_columns_float[c->type_index[j]][got->second] = b->h_columns_float[b->type_index[j]][i];
                    };
                }
                else if(c->grp_type[j] == 6) {  // DISTINCT

                }
            };
        };
    };

    bool dis_exists = 0;
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

        thrust::device_ptr<int_type> d_hash = thrust::device_malloc<int_type>(b->mRecCount);
        thrust::device_ptr<int_type> tmp = thrust::device_malloc<int_type>(a->mRecCount);

        unsigned int dist_count = 0;

        for(unsigned int j=0; j < c->mColumnCount; j++) {

            if (c->grp_type[j] == 6) {

                if(!grp_scanned) {

                    d_dii[a->mRecCount-1] = 0;
                    thrust::inclusive_scan(d_dii, d_dii + a->mRecCount, d_dii);
                    thrust::copy(b_hash, b_hash + b->mRecCount, d_hash);
                    thrust::gather(d_dii, d_dii + a->mRecCount, d_hash, tmp);	// now hashes are in tmp
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
        thrust::device_free(d_hash);
        thrust::device_free(tmp);
        thrust::device_free(d_dii);
    };

    delete [] b_hash;

}


void count_simple(CudaSet* c)
{
    int_type count;

    for(unsigned int i = 0; i < c->mColumnCount; i++) {
        if(c->grp_type[i] == 0) { // COUNT
            count = thrust::reduce(c->h_columns_int[c->type_index[i]].begin(), c->h_columns_int[c->type_index[i]].begin() + c->mRecCount);
            c->h_columns_int[c->type_index[i]][0] = count;
        };
    };


    if (c->mRecCount != 0) {

        for(unsigned int k = 0; k < c->mColumnCount; k++)	{
            if(c->grp_type[k] == 1) {   // AVG
                if(c->type[k] == 0) {
                    int_type sum  = thrust::reduce(c->h_columns_int[c->type_index[k]].begin(), c->h_columns_int[c->type_index[k]].begin() + c->mRecCount);
                    c->h_columns_int[c->type_index[k]][0] = sum/count;
                }
                if(c->type[k] == 1) {
                    float_type sum  = thrust::reduce(c->h_columns_float[c->type_index[k]].begin(), c->h_columns_float[c->type_index[k]].begin() + c->mRecCount);
                    c->h_columns_float[c->type_index[k]][0] = sum/count;
                };
            }
            else if(c->grp_type[k] == 2) {   // SUM
                if(c->type[k] == 0) {
                    int_type sum  = thrust::reduce(c->h_columns_int[c->type_index[k]].begin(), c->h_columns_int[c->type_index[k]].begin() + c->mRecCount);
                    c->h_columns_int[c->type_index[k]][0] = sum;
                }
                if(c->type[k] == 1) {
                    float_type sum  = thrust::reduce(c->h_columns_float[c->type_index[k]].begin(), c->h_columns_float[c->type_index[k]].begin() + c->mRecCount);
                    c->h_columns_float[c->type_index[k]][0] = sum;
                };

            }
        };
    }
    c->mRecCount = 1;
};


void count_avg(CudaSet* c, boost::unordered_map<long long int, unsigned int>& mymap, vector<thrust::device_vector<int_type> >& distinct_hash)
{
    int countIndex;

    for(unsigned int i = 0; i < c->mColumnCount; i++) {
        if(c->grp_type[i] == 0) // COUNT
            countIndex = i;
    };

    if (c->mRecCount != 0) {

        unsigned int dis_count = 0;
        for(unsigned int k = 0; k < c->mColumnCount; k++)	{
            if(c->grp_type[k] == 1) {   // AVG

                if (c->type[k] == 0 ) { // int
                    //create a float column k
                    c->h_columns_float.push_back(thrust::host_vector<float_type, uninitialized_host_allocator<float_type> >(c->mRecCount));
                    unsigned int idx = c->h_columns_float.size()-1;

                    for(unsigned int z = 0; z < c->mRecCount; z++) {
                        c->h_columns_float[idx][z] =  ((float_type)c->h_columns_int[c->type_index[k]][z]) / (float_type)c->h_columns_int[c->type_index[countIndex]][z];
                    };
                    c->type[k] = 1;
                    c->h_columns_int[c->type_index[k]].resize(0);
                    c->h_columns_int[c->type_index[k]].shrink_to_fit();
                    c->type_index[k] = idx;
                }
                else {              // float
                    for(unsigned int z = 0; z < c->mRecCount; z++) {
                        c->h_columns_float[c->type_index[k]][z] =  c->h_columns_float[c->type_index[k]][z] / (float_type)c->h_columns_int[c->type_index[countIndex]][z];
                    };
                };
            }
            else if(c->grp_type[k] == 6) {
                unsigned int res_count = 0;

                thrust::host_vector<int_type> h_hash = distinct_hash[dis_count];
                int_type curr_val = h_hash[0];
                unsigned int cycle_sz = h_hash.size();

                for(unsigned int i = 0; i < cycle_sz; i++) {
                    if (h_hash[i] == curr_val) {
                        res_count++;
                        if(i == cycle_sz-1) {
                            c->h_columns_int[c->type_index[k]][mymap[h_hash[i]]] = res_count;
                        };
                    }
                    else {
                        unsigned int idx = mymap[h_hash[i-1]];
                        c->h_columns_int[c->type_index[k]][idx] = res_count;
                        curr_val = h_hash[i];
                        res_count = 1;
                    };
                };
                dis_count++;
            }
            else if(c->grp_type[k] == 2) {

            };
        };
    };

    c->segCount = 1;
    c->maxRecs = c->mRecCount;
};

