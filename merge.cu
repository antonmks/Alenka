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


struct MurmurHash64D
{

    const void* key;
    unsigned long long* output;
    const int* len;
    const unsigned int* seed;
    const unsigned int* off;
    const unsigned int* off_count;


    MurmurHash64D(const void* _key, unsigned long long* _output, const int* _len, const unsigned int* _seed,
                  const unsigned int* _off, const unsigned int* _off_count):
        key(_key), output(_output), len(_len), seed(_seed), off(_off), off_count(_off_count) {}

    template <typename IndexType>
    __host__ __device__
    void operator()(const IndexType & i) {


        const uint64_t m = 0xc6a4a7935bd1e995;
        const int r = 47;
        uint64_t h = *seed ^ (*len * m);

        const uint64_t* data = (const uint64_t *)((char*)key + i*(*len));
        const uint64_t* end = data + (*len/8);

        while(data != end)
        {
            uint64_t k = *data++;

            k *= m;
            k ^= k >> r;
            k *= m;

            h ^= k;
            h *= m;
        }

        const unsigned char * data2 = (const unsigned char*)data;

        switch(*len & 7)
        {
        case 7:
            h ^= uint64_t(data2[6]) << 48;
        case 6:
            h ^= uint64_t(data2[5]) << 40;
        case 5:
            h ^= uint64_t(data2[4]) << 32;
        case 4:
            h ^= uint64_t(data2[3]) << 24;
        case 3:
            h ^= uint64_t(data2[2]) << 16;
        case 2:
            h ^= uint64_t(data2[1]) << 8;
        case 1:
            h ^= uint64_t(data2[0]);
            h *= m;
        };

        h ^= h >> r;
        h *= m;
        h ^= h >> r;

        //printf("WRITE TO OFFSET %d %d %lld \n", i ,  i*(*off) + (*off_count), h);
        output[i*(*off) + (*off_count)] = h;
    }
};

struct MurmurHash64D_F
{

    const void* key;
    unsigned long long* output;
    const int* len;
    const unsigned int* seed;


    MurmurHash64D_F(const void* _key, unsigned long long* _output, const int* _len, const unsigned int* _seed):
        key(_key), output(_output), len(_len), seed(_seed) {}

    template <typename IndexType>
    __host__ __device__
    void operator()(const IndexType & i) {


        const uint64_t m = 0xc6a4a7935bd1e995;
        const int r = 47;
        uint64_t h = *seed ^ (*len * m);

        const uint64_t* data = (const uint64_t *)((char*)key + i*(*len));
        const uint64_t* end = data + (*len/8);

        while(data != end)
        {
            uint64_t k = *data++;

            k *= m;
            k ^= k >> r;
            k *= m;

            h ^= k;
            h *= m;
        }

        const unsigned char * data2 = (const unsigned char*)data;

        switch(*len & 7)
        {
        case 7:
            h ^= uint64_t(data2[6]) << 48;
        case 6:
            h ^= uint64_t(data2[5]) << 40;
        case 5:
            h ^= uint64_t(data2[4]) << 32;
        case 4:
            h ^= uint64_t(data2[3]) << 24;
        case 3:
            h ^= uint64_t(data2[2]) << 16;
        case 2:
            h ^= uint64_t(data2[1]) << 8;
        case 1:
            h ^= uint64_t(data2[0]);
            h *= m;
        };

        h ^= h >> r;
        h *= m;
        h ^= h >> r;

        output[i] = h;
    }
};

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





typedef thrust::device_vector<int_type>::iterator    IntIterator;
typedef thrust::tuple<IntIterator,IntIterator> IteratorTuple;
typedef thrust::zip_iterator<IteratorTuple> ZipIterator;
unsigned int hash_seed = 100;
thrust::host_vector<unsigned long long int> h_merge;

using namespace std;
using namespace thrust::placeholders;


void create_c(CudaSet* c, CudaSet* b)
{
    map<string,unsigned int>::iterator it;
    c->not_compressed = 1;
    c->segCount = 1;

    for (  it=b->columnNames.begin() ; it != b->columnNames.end(); ++it ) {
        c->columnNames[(*it).first] = (*it).second;
    };
	

    c->grp_type = new unsigned int[c->mColumnCount];
	h_merge.clear();

    for(unsigned int i=0; i < b->mColumnCount; i++) {
	
        c->cols[i] = b->cols[i];
        c->type[i] = b->type[i];
        c->grp_type[i] = b->grp_type[i];

        if (b->type[i] == 0) {
            c->h_columns_int.push_back(thrust::host_vector<int_type, uninitialized_host_allocator<int_type> >());
            c->d_columns_int.push_back(thrust::device_vector<int_type>());
            c->type_index[i] = c->h_columns_int.size()-1;
        }
        else if (b->type[i] == 1) {
            c->h_columns_float.push_back(thrust::host_vector<float_type, uninitialized_host_allocator<float_type> >());
            c->d_columns_float.push_back(thrust::device_vector<float_type>());
            c->type_index[i] = c->h_columns_float.size()-1;
        }
        else {
            c->h_columns_char.push_back(NULL);
            c->d_columns_char.push_back(NULL);
            c->char_size.push_back(b->char_size[b->type_index[i]]);
            c->type_index[i] = c->h_columns_char.size()-1;
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
	
    vector<unsigned int> opv;
    queue<string> ss;
    for(unsigned int z = 0; z < cycle_sz; z++) {
        opv.push_back(b->columnNames[aliases[op_v3.front()]]);
        ss.push(aliases[op_v3.front()]);
        op_v3.pop();
    };

    // create hashes of groupby columns
    thrust::device_vector<unsigned long long int> hashes(b->mRecCount);

    unsigned int idx;
    thrust::device_vector<unsigned long long int> sum(cycle_sz*b->mRecCount);
    thrust::device_vector<unsigned int> seed(1);
    seed[0] = hash_seed;
    thrust::device_vector<int> len(1);
    thrust::device_vector<unsigned int> off(1);
    thrust::device_vector<unsigned int> off_count(1);

    thrust::counting_iterator<unsigned int> begin(0);
    for(unsigned int z = 0; z < cycle_sz; z++) {
        idx = opv[z];

        if(b->type[idx] == 0) {  //int
            len[0] = 8;
            off[0] = cycle_sz;
            off_count[0] = z;
            MurmurHash64D ff((void*)(thrust::raw_pointer_cast(b->d_columns_int[b->type_index[idx]].data())),
                             thrust::raw_pointer_cast(sum.data()),
                             thrust::raw_pointer_cast(len.data()), thrust::raw_pointer_cast(seed.data()),
                             thrust::raw_pointer_cast(off.data()), thrust::raw_pointer_cast(off_count.data()));
            thrust::for_each(begin, begin + b->mRecCount, ff);
        }
        else if(b->type[idx] == 2) {  //string
            len[0] = b->char_size[b->type_index[idx]];
            off[0] = cycle_sz;
            off_count[0] = z;
            MurmurHash64D ff((void*)b->d_columns_char[b->type_index[idx]],
                             thrust::raw_pointer_cast(sum.data()),
                             thrust::raw_pointer_cast(len.data()), thrust::raw_pointer_cast(seed.data()),
                             thrust::raw_pointer_cast(off.data()), thrust::raw_pointer_cast(off_count.data()));
            thrust::for_each(begin, begin + b->mRecCount, ff);
        }
        else {  //float
            cout << "No group by on float/decimal columns " << endl;
            exit(0);
        };
    };

    //for(int i = 0; i < cycle_sz*b->mRecCount;i++)
    //cout << "SUM " << sum[0] << endl;
	

    len[0] = 8*cycle_sz;
    MurmurHash64D_F ff(thrust::raw_pointer_cast(sum.data()),
                       thrust::raw_pointer_cast(hashes.data()),
                       thrust::raw_pointer_cast(len.data()), thrust::raw_pointer_cast(seed.data()));
    thrust::for_each(begin, begin + b->mRecCount, ff);

    //for(int i = 0; i < b->mRecCount;i++)
    //cout << "DEV HASH " << hashes[0] << endl;

    // sort the results by hash
    thrust::device_ptr<unsigned int> v = thrust::device_malloc<unsigned int>(b->mRecCount);
    thrust::sequence(v, v + b->mRecCount, 0, 1);

    size_t max_c	= max_char(b);
    if(max_c < 8) {
        max_c = 8;
    };
    void* d;
    CUDA_SAFE_CALL(cudaMalloc((void **) &d, b->mRecCount*max_c));
    thrust::sort_by_key(hashes.begin(), hashes.end(), v);
	

    for(unsigned int i = 0; i < b->mColumnCount; i++) {

        if(b->type[i] == 0) {
            thrust::device_ptr<int_type> d_tmp((int_type*)d);
            thrust::gather(v, v+b->mRecCount, b->d_columns_int[b->type_index[i]].begin(), d_tmp);
            thrust::copy(d_tmp, d_tmp + b->mRecCount, b->d_columns_int[b->type_index[i]].begin());
        }
        else if(b->type[i] == 1) {
            thrust::device_ptr<float_type> d_tmp((float_type*)d);
            thrust::gather(v, v+b->mRecCount, b->d_columns_float[b->type_index[i]].begin(), d_tmp);
            thrust::copy(d_tmp, d_tmp + b->mRecCount, b->d_columns_float[b->type_index[i]].begin());
        }
        else {
            thrust::device_ptr<char> d_tmp((char*)d);
            str_gather(thrust::raw_pointer_cast(v), b->mRecCount, (void*)b->d_columns_char[b->type_index[i]], (void*) thrust::raw_pointer_cast(d_tmp), b->char_size[b->type_index[i]]);
            cudaMemcpy( (void*)b->d_columns_char[b->type_index[i]], (void*) thrust::raw_pointer_cast(d_tmp), b->mRecCount*b->char_size[b->type_index[i]], cudaMemcpyDeviceToDevice);
        };
    };
    cudaFree(d);
    thrust::device_free(v);


    b->CopyToHost(0, b->mRecCount);
    thrust::host_vector<unsigned long long int> hh = hashes;
    char* tmp = new char[max_c*(c->mRecCount + b->mRecCount)];
    c->resize(b->mRecCount);
    //lets merge every column
	
    for(unsigned int i = 0; i < b->mColumnCount; i++) {
	

        if(b->type[i] == 0) {
            thrust::merge_by_key(h_merge.begin(), h_merge.end(),
                                 hh.begin(), hh.end(),
                                 c->h_columns_int[c->type_index[i]].begin(), b->h_columns_int[b->type_index[i]].begin(),
                                 thrust::make_discard_iterator(), (int_type*)tmp);
            thrust::copy((int_type*)tmp, (int_type*)tmp + h_merge.size() + b->mRecCount, c->h_columns_int[c->type_index[i]].begin());
        }
        else if(b->type[i] == 1) {
            thrust::merge_by_key(h_merge.begin(), h_merge.end(),
                                 hh.begin(), hh.end(),
                                 c->h_columns_float[c->type_index[i]].begin(), b->h_columns_float[b->type_index[i]].begin(),
                                 thrust::make_discard_iterator(), (float_type*)tmp);										 
            thrust::copy((float_type*)tmp, (float_type*)tmp + h_merge.size() + b->mRecCount, c->h_columns_float[c->type_index[i]].begin());			
			
        }
        else {
            str_merge_by_key(h_merge, hh, c->h_columns_char[c->type_index[i]], b->h_columns_char[b->type_index[i]], b->char_size[b->type_index[i]], tmp);
            thrust::copy(tmp, tmp + (h_merge.size() + b->mRecCount)*b->char_size[b->type_index[i]],	c->h_columns_char[c->type_index[i]]);
        };
    };
	

    //merge the keys
    thrust::merge(h_merge.begin(), h_merge.end(),
                  hh.begin(), hh.end(), (unsigned long long int*)tmp);

    size_t cpy_sz = h_merge.size() + b->mRecCount;
    h_merge.resize(h_merge.size() + b->mRecCount);
    thrust::copy((unsigned long long int*)tmp, (unsigned long long int*)tmp + cpy_sz, h_merge.begin());
    delete [] tmp;
	

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


void count_avg(CudaSet* c,  vector<thrust::device_vector<int_type> >& distinct_hash)
{
    int countIndex;

    for(unsigned int i = 0; i < c->mColumnCount; i++) {
        if(c->grp_type[i] == 0) { // COUNT
            countIndex = i;
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
            for(unsigned int k = 0; k < c->mColumnCount; k++)	{

                if(c->grp_type[k] <= 2) { //sum || avg || count
                    if (c->type[k] == 0 ) { // int

                        int_type* tmp =  new int_type[res_count];
                        thrust::reduce_by_key(h_merge.begin(), h_merge.end(), c->h_columns_int[c->type_index[k]].begin(),
                                              thrust::make_discard_iterator(), tmp);
                        c->h_columns_int[c->type_index[k]].resize(res_count);
                        thrust::copy(tmp, tmp + res_count, c->h_columns_int[c->type_index[k]].begin());
                        delete [] tmp;
                    }
                    else if (c->type[k] == 1 ) { // float
                        float_type* tmp =  new float_type[res_count];
                        thrust::reduce_by_key(h_merge.begin(), h_merge.end(), c->h_columns_float[c->type_index[k]].begin(),
                                              thrust::make_discard_iterator(), tmp);
                        c->h_columns_float[c->type_index[k]].resize(res_count);
                        thrust::copy(tmp, tmp + res_count, c->h_columns_float[c->type_index[k]].begin());
                        delete [] tmp;
                    };
                }
                if(c->grp_type[k] == 4) { //min
                    if (c->type[k] == 0 ) { // int
                        int_type* tmp =  new int_type[res_count];
                        thrust::reduce_by_key(h_merge.begin(), h_merge.end(), c->h_columns_int[c->type_index[k]].begin(),
                                              thrust::make_discard_iterator(), tmp);
                        c->h_columns_int[c->type_index[k]].resize(res_count);
                        thrust::copy(tmp, tmp + res_count, c->h_columns_int[c->type_index[k]].begin());
                        delete [] tmp;
                    }
                    else if (c->type[k] == 1 ) { // float
                        float_type* tmp =  new float_type[res_count];
                        thrust::reduce_by_key(h_merge.begin(), h_merge.end(), c->h_columns_float[c->type_index[k]].begin(),
                                              thrust::make_discard_iterator(), tmp);
                        c->h_columns_float[c->type_index[k]].resize(res_count);
                        thrust::copy(tmp, tmp + res_count, c->h_columns_float[c->type_index[k]].begin());
                        delete [] tmp;
                    };
                }
                if(c->grp_type[k] == 5) { //max
                    if (c->type[k] == 0 ) { // int
                        int_type* tmp =  new int_type[res_count];
                        thrust::reduce_by_key(h_merge.begin(), h_merge.end(), c->h_columns_int[c->type_index[k]].begin(),
                                              thrust::make_discard_iterator(), tmp);
                        c->h_columns_int[c->type_index[k]].resize(res_count);
                        thrust::copy(tmp, tmp + res_count, c->h_columns_int[c->type_index[k]].begin());
                        delete [] tmp;
                    }
                    else if (c->type[k] == 1 ) { // float
                        float_type* tmp =  new float_type[res_count];
                        thrust::reduce_by_key(h_merge.begin(), h_merge.end(), c->h_columns_float[c->type_index[k]].begin(),
                                              thrust::make_discard_iterator(), tmp);
                        c->h_columns_float[c->type_index[k]].resize(res_count);
                        thrust::copy(tmp, tmp + res_count, c->h_columns_float[c->type_index[k]].begin());
                        delete [] tmp;
                    };
                }
                else if(c->grp_type[k] == 3) { //no group function
                    if (c->type[k] == 0 ) { // int
                        int_type* tmp =  new int_type[res_count];
                        thrust::reduce_by_key(h_merge.begin(), h_merge.end(), c->h_columns_int[c->type_index[k]].begin(),
                                              thrust::make_discard_iterator(), tmp);
                        c->h_columns_int[c->type_index[k]].resize(res_count);
                        thrust::copy(tmp, tmp + res_count, c->h_columns_int[c->type_index[k]].begin());
                        delete [] tmp;
                    }
                    else if (c->type[k] == 1 ) { // float
                        float_type* tmp =  new float_type[res_count];
                        thrust::reduce_by_key(h_merge.begin(), h_merge.end(), c->h_columns_float[c->type_index[k]].begin(),
                                              thrust::make_discard_iterator(), tmp);
                        c->h_columns_float[c->type_index[k]].resize(res_count);
                        thrust::copy(tmp, tmp + res_count, c->h_columns_float[c->type_index[k]].begin());
                        delete [] tmp;
                    }
                    else { //char
                        char* tmp = new char[res_count*c->char_size[c->type_index[k]]];
                        str_copy_if_host(c->h_columns_char[c->type_index[k]], c->mRecCount, tmp, grp, c->char_size[c->type_index[k]]);
                        thrust::copy(tmp, tmp + c->char_size[c->type_index[k]]*res_count, c->h_columns_char[c->type_index[k]]);
                        delete [] tmp;
                    };
                };
            };
            c->mRecCount = res_count;
        };

        for(unsigned int k = 0; k < c->mColumnCount; k++)	{
            if(c->grp_type[k] == 1) {   // AVG

                if (c->type[k] == 0 ) { // int
                    //create a float column k
                    c->h_columns_float.push_back(thrust::host_vector<float_type, uninitialized_host_allocator<float_type> >(c->mRecCount));
                    size_t idx = c->h_columns_float.size()-1;

                    thrust::transform(c->h_columns_int[c->type_index[k]].begin(), c->h_columns_int[c->type_index[k]].begin() + c->mRecCount,
                                      c->h_columns_int[c->type_index[countIndex]].begin(), c->h_columns_float[idx].begin(), float_avg1());
                    c->type[k] = 1;
                    c->h_columns_int[c->type_index[k]].resize(0);
                    c->h_columns_int[c->type_index[k]].shrink_to_fit();
                    c->type_index[k] = idx;
                    c->grp_type[k] = 3;
                }
                else {              // float
                    thrust::transform(c->h_columns_float[c->type_index[k]].begin(), c->h_columns_float[c->type_index[k]].begin() + c->mRecCount,
                                      c->h_columns_int[c->type_index[countIndex]].begin(), c->h_columns_float[c->type_index[k]].begin(), float_avg());
                };
            }
            else if(c->grp_type[k] == 6) {
                /*   unsigned int res_count = 0;

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
                   dis_count++;*/
            }
            else if(c->grp_type[k] == 2) {

            };
        };

    };

    c->segCount = 1;
    c->maxRecs = c->mRecCount;
};

