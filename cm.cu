/*
 *
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

#include <cctype>
#include <functional>
#include <numeric>
#include "cm.h"
#include "atof.h"
#include "compress.cu"


#ifdef _WIN64
#define atoll(S) _atoi64(S)
#endif


using namespace std;
using namespace thrust::placeholders;

unsigned long long int total_count = 0;
unsigned int total_segments = 0;
unsigned int total_max;
unsigned int process_count;
map <unsigned int, unsigned int> str_offset;
long long int totalRecs = 0;
bool fact_file_loaded = 0;
char map_check;
void* d_v = NULL;
void* s_v = NULL;
unsigned int oldCount;
queue<string> op_type;
queue<string> op_value;
queue<int_type> op_nums;
queue<float_type> op_nums_f;
queue<string> col_aliases;

void* alloced_tmp;
unsigned int alloced_sz = 0;
bool alloced_switch = 0;

map<string,CudaSet*> varNames; //  STL map to manage CudaSet variables
map<string,string> setMap; //map to keep track of column names and set names


struct is_match
{
    __host__ __device__
    bool operator()(unsigned int x)
    {
        return x != 4294967295;
    }
};



struct f_equal_to
{
    __host__ __device__
    bool operator()(const float_type x, const float_type y)
    {
        return (((x-y) < EPSILON) && ((x-y) > -EPSILON));
    }
};


struct f_less
{
    __host__ __device__
    bool operator()(const float_type x, const float_type y)
    {
        return ((y-x) > EPSILON);
    }
};

struct f_greater
{
    __host__ __device__
    bool operator()(const float_type x, const float_type y)
    {
        return ((x-y) > EPSILON);
    }
};

struct f_greater_equal_to
{
    __host__ __device__
    bool operator()(const float_type x, const float_type y)
    {
        return (((x-y) > EPSILON) || (((x-y) < EPSILON) && ((x-y) > -EPSILON)));
    }
};

struct f_less_equal
{
    __host__ __device__
    bool operator()(const float_type x, const float_type y)
    {
        return (((y-x) > EPSILON) || (((x-y) < EPSILON) && ((x-y) > -EPSILON)));
    }
};

struct f_not_equal_to
{
    __host__ __device__
    bool operator()(const float_type x, const float_type y)
    {
        return !(((x-y) < EPSILON) && ((x-y) > -EPSILON));
    }
};


struct long_to_float_type
{
    __host__ __device__
    float_type operator()(const int_type x)
    {
        return (float_type)x;
    }
};


struct l_to_ui
{
    __host__ __device__
    float_type operator()(const int_type x)
    {
        return (unsigned int)x;
    }
};

struct float_to_decimal
{
    __host__ __device__
    float_type operator()(const float_type x)
    {
        return (int_type)(x*100);
    }
};


struct to_zero
{
    __host__ __device__
    bool operator()(const int_type x)
    {
        if(x == -1)
            return 0;
        else
            return 1;
    }
};



struct div_long_to_float_type
{
    __host__ __device__
    float_type operator()(const int_type x, const float_type y)
    {
        return (float_type)x/y;
    }
};


struct long_to_float
{
    __host__ __device__
    float_type operator()(const long long int x)
    {
        return (((float_type)x)/100.0);
    }
};


// trim from start
static inline std::string &ltrim(std::string &s) {
    s.erase(s.begin(), std::find_if(s.begin(), s.end(), std::not1(std::ptr_fun<int, int>(std::isspace))));
    return s;
}

// trim from end
static inline std::string &rtrim(std::string &s) {
    s.erase(std::find_if(s.rbegin(), s.rend(), std::not1(std::ptr_fun<int, int>(std::isspace))).base(), s.end());
    return s;
}

// trim from both ends
static inline std::string &trim(std::string &s) {
    return ltrim(rtrim(s));
}


void allocColumns(CudaSet* a, queue<string> fields);
void copyColumns(CudaSet* a, queue<string> fields, unsigned int segment, unsigned int& count);
void mygather(unsigned int tindex, unsigned int idx, CudaSet* a, CudaSet* t, unsigned int count, unsigned int g_size);
void mycopy(unsigned int tindex, unsigned int idx, CudaSet* a, CudaSet* t, unsigned int count, unsigned int g_size);
void write_compressed_char(string file_name, unsigned int index, unsigned int mCount);
unsigned int largest_prm(CudaSet* a);
unsigned int max_tmp(CudaSet* a);


unsigned int curr_segment = 10000000;

size_t getFreeMem();
char zone_map_check(queue<string> op_type, queue<string> op_value, queue<int_type> op_nums,queue<float_type> op_nums_f, CudaSet* a, unsigned int segment);




CudaSet::CudaSet(queue<string> &nameRef, queue<string> &typeRef, queue<int> &sizeRef, queue<int> &colsRef, int_type Recs)
    : mColumnCount(0), mRecCount(0)
{
    initialize(nameRef, typeRef, sizeRef, colsRef, Recs);
    keep = false;
    partial_load = 0;
    source = 1;
    text_source = 1;
    grp = NULL;
};

CudaSet::CudaSet(queue<string> &nameRef, queue<string> &typeRef, queue<int> &sizeRef, queue<int> &colsRef, int_type Recs, char* file_name)
    : mColumnCount(0),  mRecCount(0)
{
    initialize(nameRef, typeRef, sizeRef, colsRef, Recs, file_name);
    keep = false;
    partial_load = 1;
    source = 1;
    text_source = 0;
    grp = NULL;
};

CudaSet::CudaSet(unsigned int RecordCount, unsigned int ColumnCount)
{
    initialize(RecordCount, ColumnCount);
    keep = false;
    partial_load = 0;
    source = 0;
    text_source = 0;
    grp = NULL;
};

CudaSet::CudaSet(CudaSet* a, CudaSet* b, int_type Recs, queue<string> op_sel, queue<string> op_sel_as)
{
    initialize(a,b,Recs, op_sel, op_sel_as);
    keep = false;
    partial_load = 0;
    source = 0;
    text_source = 0;
    grp = NULL;
};


CudaSet::~CudaSet()
{
    free();
};


void CudaSet::allocColumnOnDevice(unsigned int colIndex, unsigned int RecordCount)
{
    if (type[colIndex] == 0) {
        d_columns_int[type_index[colIndex]].resize(RecordCount);
    }
    else if (type[colIndex] == 1)
        d_columns_float[type_index[colIndex]].resize(RecordCount);
    else {
        void* d;
        cudaMalloc(&d, char_size[type_index[colIndex]]*RecordCount);
        d_columns_char[type_index[colIndex]] = (char*)d;
    };
};


void CudaSet::decompress_char_hash(unsigned int colIndex, unsigned int segment, unsigned int i_cnt)
{

    unsigned int bits_encoded, fit_count, sz, vals_count, real_count, old_count;
    const unsigned int len = char_size[type_index[colIndex]];

    char f1[100];
    strcpy(f1, load_file_name);
    strcat(f1,".");
    char col_pos[3];
    itoaa(cols[colIndex],col_pos);
    strcat(f1,col_pos);

    strcat(f1,".");
    itoaa(segment,col_pos);
    strcat(f1,col_pos);
    FILE* f;
    f = fopen (f1 , "rb" );
    fread(&sz, 4, 1, f);
    char* d_array = new char[sz*len];
    fread((void*)d_array, sz*len, 1, f);

    unsigned long long int* hashes  = new unsigned long long int[sz];

    for(unsigned int i = 0; i < sz ; i++) {
        hashes[i] = MurmurHash64A(&d_array[i*len], len, hash_seed); // divide by 2 so it will fit into a signed long long
    };

    void* d;
    cudaMalloc((void **) &d, sz*int_size);
    cudaMemcpy( d, (void *) hashes, sz*8, cudaMemcpyHostToDevice);

    thrust::device_ptr<unsigned long long int> dd_int((unsigned long long int*)d);

    delete[] d_array;
    delete[] hashes;

    fread(&fit_count, 4, 1, f);
    fread(&bits_encoded, 4, 1, f);
    fread(&vals_count, 4, 1, f);
    fread(&real_count, 4, 1, f);

    unsigned long long int* int_array = new unsigned long long int[vals_count];
    fread((void*)int_array, 1, vals_count*8, f);
    fclose(f);

    void* d_val;
    cudaMalloc((void **) &d_val, vals_count*8);
    cudaMemcpy(d_val, (void *) int_array, vals_count*8, cudaMemcpyHostToDevice);

    thrust::device_ptr<unsigned long long int> mval((unsigned long long int*)d_val);


    delete[] int_array;

    void* d_int;
    cudaMalloc((void **) &d_int, real_count*4);

    // convert bits to ints and then do gather

    void* d_v;
    cudaMalloc((void **) &d_v, 8);
    thrust::device_ptr<unsigned int> dd_v((unsigned int*)d_v);
    dd_v[1] = fit_count;
    dd_v[0] = bits_encoded;

    thrust::counting_iterator<unsigned int> begin(0);
    decompress_functor_str ff((unsigned long long int*)d_val,(unsigned int*)d_int, (unsigned int*)d_v);
    thrust::for_each(begin, begin + real_count, ff);

    //thrust::device_ptr<long long int> dd_int((long long int*)d);
    thrust::device_ptr<unsigned int> dd_val((unsigned int*)d_int);

    if(!prm.empty()) {
        if(prm_index[segment] == 'R') {
            thrust::device_ptr<int_type> d_tmp = thrust::device_malloc<int_type>(real_count);
            thrust::gather(dd_val, dd_val + real_count, dd_int, d_tmp);

            if(prm_d.size() == 0) // find the largest prm segment
                prm_d.resize(largest_prm(this));
            cudaMemcpy((void**)(thrust::raw_pointer_cast(prm_d.data())), (void**)prm[segment],
                       4*prm_count[segment], cudaMemcpyHostToDevice);

            old_count = d_columns_int[i_cnt].size();
            d_columns_int[i_cnt].resize(old_count + prm_count[segment]);
            thrust::gather(prm_d.begin(), prm_d.begin() + prm_count[segment], d_tmp, d_columns_int[i_cnt].begin() + old_count);
            thrust::device_free(d_tmp);

        }
        else if(prm_index[segment] == 'A') {
            old_count = d_columns_int[i_cnt].size();
            d_columns_int[i_cnt].resize(old_count + real_count);
            thrust::gather(dd_val, dd_val + real_count, dd_int, d_columns_int[i_cnt].begin() + old_count);
        }
    }
    else {

        old_count = d_columns_int[i_cnt].size();
        d_columns_int[i_cnt].resize(old_count + real_count);
        thrust::gather(dd_val, dd_val + real_count, dd_int, d_columns_int[i_cnt].begin() + old_count);

    };

    cudaFree(d);
    cudaFree(d_val);
    cudaFree(d_v);
    cudaFree(d_int);
};




// takes a char column , hashes strings, copies them to a gpu
void CudaSet::add_hashed_strings(string field, unsigned int segment, unsigned int i_cnt)
{
    unsigned int colInd2 = columnNames.find(field)->second;
    CudaSet *t = varNames[setMap[field]];

    if(not_compressed) { // decompressed strings on a host

        unsigned int old_count;
        unsigned long long int* hashes  = new unsigned long long int[t->mRecCount];

        for(unsigned int i = 0; i < t->mRecCount ; i++)
            hashes[i] = MurmurHash64A(t->h_columns_char[t->type_index[colInd2]] + i*t->char_size[t->type_index[colInd2]], t->char_size[t->type_index[colInd2]], hash_seed);

        if(!prm.empty()) {
            if(prm_index[segment] == 'R') {

                thrust::device_ptr<unsigned long long int> d_tmp = thrust::device_malloc<unsigned long long int>(t->mRecCount);
                thrust::copy(hashes, hashes+mRecCount, d_tmp);

                if(prm_d.size() == 0) // find the largest prm segment
                    prm_d.resize(largest_prm(this));

                cudaMemcpy((void**)(thrust::raw_pointer_cast(prm_d.data())), (void**)prm[segment],
                           4*prm_count[segment], cudaMemcpyHostToDevice);

                old_count = d_columns_int[i_cnt].size();
                d_columns_int[i_cnt].resize(old_count + prm_count[segment]);
                thrust::gather(prm_d.begin(), prm_d.begin() + prm_count[segment], d_tmp, d_columns_int[i_cnt].begin() + old_count);
                thrust::device_free(d_tmp);

            }
            else if(prm_index[segment] == 'A') {
                old_count = d_columns_int[i_cnt].size();
                d_columns_int[i_cnt].resize(old_count + mRecCount);
                thrust::copy(hashes, hashes + mRecCount, d_columns_int[i_cnt].begin() + old_count);
            }
        }
        else {
            old_count = d_columns_int[i_cnt].size();
            d_columns_int[i_cnt].resize(old_count + mRecCount);
            thrust::copy(hashes, hashes + mRecCount, d_columns_int[i_cnt].begin() + old_count);
        }
    }
    else { // hash the dictionary
        decompress_char_hash(colInd2, segment, i_cnt);
    };
};


void CudaSet::resize(unsigned int addRecs)
{    
    mRecCount = mRecCount + addRecs;
    for(unsigned int i=0; i <mColumnCount; i++) {
        if(type[i] == 0) {
            h_columns_int[type_index[i]].resize(mRecCount);
        }
        else if(type[i] == 1) {
            h_columns_float[type_index[i]].resize(mRecCount);
        }
        else {
            if (h_columns_char[type_index[i]]) {
                if (mRecCount > prealloc_char_size) {
                    prealloc_char_size = mRecCount;
                    h_columns_char[type_index[i]] = (char*)realloc(h_columns_char[type_index[i]], (unsigned long long int)mRecCount*(unsigned long long int)char_size[type_index[i]]);
                };
            }
            else {
                h_columns_char[type_index[i]] = new char[(unsigned long long int)mRecCount*(unsigned long long int)char_size[type_index[i]]];
            };
        };

    };
};

void CudaSet::reserve(unsigned int Recs)
{

    for(unsigned int i=0; i <mColumnCount; i++) {
        if(type[i] == 0)
            h_columns_int[type_index[i]].reserve(Recs);
        else if(type[i] == 1)
            h_columns_float[type_index[i]].reserve(Recs);
        else {
		    unsigned long long int sz = (unsigned long long int)Recs*(unsigned long long int)char_size[type_index[i]];
            h_columns_char[type_index[i]] = new char[(unsigned long long int)Recs*(unsigned long long int)char_size[type_index[i]]];
			if(h_columns_char[type_index[i]] == NULL) {
			    cout << "Could not allocate on a host " << Recs << " records of size " << char_size[type_index[i]] << endl;
			    exit(0);
			};
            prealloc_char_size = Recs;
        };

    };
};


void CudaSet::deAllocColumnOnDevice(unsigned int colIndex)
{
    if (type[colIndex] == 0 && !d_columns_int.empty()) {
        d_columns_int[type_index[colIndex]].resize(0);
        d_columns_int[type_index[colIndex]].shrink_to_fit();
    }
    else if (type[colIndex] == 1 && !d_columns_float.empty()) {
        d_columns_float[type_index[colIndex]].resize(0);
        d_columns_float[type_index[colIndex]].shrink_to_fit();
    }
    else if (type[colIndex] == 2 && d_columns_char[type_index[colIndex]] != NULL) {
        cudaFree(d_columns_char[type_index[colIndex]]);
        d_columns_char[type_index[colIndex]] = NULL;
    };
};

void CudaSet::allocOnDevice(unsigned int RecordCount)
{
    for(unsigned int i=0; i < mColumnCount; i++)
        allocColumnOnDevice(i, RecordCount);
};

void CudaSet::deAllocOnDevice()
{
    for(unsigned int i=0; i <mColumnCount; i++)
        deAllocColumnOnDevice(i);

    if(!columnGroups.empty() && mRecCount !=0) {
        cudaFree(grp);
        grp = NULL;
    };

    if(!prm.empty()) { // free the sources
        string some_field;
        map<string,int>::iterator it=columnNames.begin();
        some_field = (*it).first;

        if(setMap[some_field].compare(name)) {
            CudaSet* t = varNames[setMap[some_field]];
            t->deAllocOnDevice();
        };
    };
};

void CudaSet::resizeDeviceColumn(unsigned int RecCount, unsigned int colIndex)
{
    if (RecCount) {
        if (type[colIndex] == 0)
            d_columns_int[type_index[colIndex]].resize(mRecCount+RecCount);
        else if (type[colIndex] == 1)
            d_columns_float[type_index[colIndex]].resize(mRecCount+RecCount);
        else {
            if (d_columns_char[type_index[colIndex]] != NULL)
                cudaFree(d_columns_char[type_index[colIndex]]);
            void *d;
            cudaMalloc((void **) &d, (mRecCount+RecCount)*char_size[type_index[colIndex]]);
            d_columns_char[type_index[colIndex]] = (char*)d;
        };
    };
};



void CudaSet::resizeDevice(unsigned int RecCount)
{
    if (RecCount)
        for(unsigned int i=0; i < mColumnCount; i++)
            resizeDeviceColumn(RecCount, i);
};

bool CudaSet::onDevice(unsigned int i)
{
    unsigned j = type_index[i];

    if (type[i] == 0) {
        if (d_columns_int.empty())
            return 0;
        if (d_columns_int[j].size() == 0)
            return 0;
    }
    else if (type[i] == 1) {
        if (d_columns_float.empty())
            return 0;
        if(d_columns_float[j].size() == 0)
            return 0;
    }
    else if  (type[i] == 2) {
        if(d_columns_char.empty())
            return 0;
        if(d_columns_char[j] == NULL)
            return 0;
    };
    return 1;
}



CudaSet* CudaSet::copyDeviceStruct()
{

    CudaSet* a = new CudaSet(mRecCount, mColumnCount);
    a->not_compressed = not_compressed;
    a->segCount = segCount;
    a->maxRecs = maxRecs;

    for ( map<string,int>::iterator it=columnNames.begin() ; it != columnNames.end(); ++it )
        a->columnNames[(*it).first] = (*it).second;

    for(unsigned int i=0; i < mColumnCount; i++) {
        a->cols[i] = cols[i];
        a->type[i] = type[i];

        if(a->type[i] == 0) {
            a->d_columns_int.push_back(thrust::device_vector<int_type>());
            a->h_columns_int.push_back(thrust::host_vector<int_type, uninitialized_host_allocator<int_type> >());
            a->type_index[i] = a->d_columns_int.size()-1;
        }
        else if(a->type[i] == 1) {
            a->d_columns_float.push_back(thrust::device_vector<float_type>());
            a->h_columns_float.push_back(thrust::host_vector<float_type, uninitialized_host_allocator<float_type> >());
            a->type_index[i] = a->d_columns_float.size()-1;
            a->decimal[i] = decimal[i];
        }
        else {
            a->h_columns_char.push_back(NULL);
            a->d_columns_char.push_back(NULL);
            a->type_index[i] = a->d_columns_char.size()-1;
        };
    };
    a->char_size = char_size;
    a->load_file_name = load_file_name;

    a->mRecCount = 0;
    return a;
}



unsigned long long int CudaSet::readSegmentsFromFile(unsigned int segNum, unsigned int colIndex)
{
    char f1[100];
    strcpy(f1, load_file_name);
    strcat(f1,".");
    char col_pos[3];
    itoaa(cols[colIndex],col_pos);
    strcat(f1,col_pos);
    unsigned int cnt;

    strcat(f1,".");
    itoaa(segNum,col_pos);
    strcat(f1,col_pos);

    FILE* f;

    f = fopen (f1 , "rb" );

    if(type[colIndex] == 0) {
        fread(h_columns_int[type_index[colIndex]].data(), 4, 1, f);
        cnt = ((unsigned int*)(h_columns_int[type_index[colIndex]].data()))[0];
        fread((unsigned int*)(h_columns_int[type_index[colIndex]].data()) + 1, (cnt+8)*8 - 4, 1, f);
    }
    else if(type[colIndex] == 1) {
        fread(h_columns_float[type_index[colIndex]].data(), 4, 1, f);
        cnt = ((unsigned int*)(h_columns_float[type_index[colIndex]].data()))[0];
        fread((unsigned int*)(h_columns_float[type_index[colIndex]].data()) + 1, (cnt+8)*8 - 4, 1, f);
    }
    else {
        decompress_char(f, colIndex, segNum);
    };

    fclose(f);
    return 0;
};


void CudaSet::decompress_char(FILE* f, unsigned int colIndex, unsigned int segNum)
{
    unsigned int bits_encoded, fit_count, sz, vals_count, real_count;
    const unsigned int len = char_size[type_index[colIndex]];

    fread(&sz, 4, 1, f);
    char* d_array = new char[sz*len];
    fread((void*)d_array, sz*len, 1, f);

    void* d;
    cudaMalloc((void **) &d, sz*len);
    cudaMemcpy( d, (void *) d_array, sz*len, cudaMemcpyHostToDevice);
    delete[] d_array;

    fread(&fit_count, 4, 1, f);
    fread(&bits_encoded, 4, 1, f);
    fread(&vals_count, 4, 1, f);
    fread(&real_count, 4, 1, f);

    unsigned long long int* int_array = new unsigned long long int[vals_count];
    fread((void*)int_array, 1, vals_count*8, f);
    fclose(f);

    void* d_val;
    cudaMalloc((void **) &d_val, vals_count*8);
    cudaMemcpy(d_val, (void *) int_array, vals_count*8, cudaMemcpyHostToDevice);
    delete[] int_array;

    void* d_int;
    cudaMalloc((void **) &d_int, real_count*4);

    // convert bits to ints and then do gather

    void* d_v;
    cudaMalloc((void **) &d_v, 8);
    thrust::device_ptr<unsigned int> dd_v((unsigned int*)d_v);
    dd_v[1] = fit_count;
    dd_v[0] = bits_encoded;

    thrust::counting_iterator<unsigned int> begin(0);
    decompress_functor_str ff((unsigned long long int*)d_val,(unsigned int*)d_int, (unsigned int*)d_v);
    thrust::for_each(begin, begin + real_count, ff);

    //thrust::device_ptr<unsigned int> dd_r((unsigned int*)d_int);
    //for(int z = 0 ; z < 3; z++)
    //cout << "DD " << dd_r[z] << endl;

    //void* d_char;
    //cudaMalloc((void **) &d_char, real_count*len);
    //cudaMemset(d_char, 0, real_count*len);
    //str_gather(d_int, real_count, d, d_char, len);
    if(str_offset.count(colIndex) == 0)
        str_offset[colIndex] = 0;
    //cout << "str off " << str_offset[colIndex] << endl;
    if(!alloced_switch)
        str_gather(d_int, real_count, d, d_columns_char[type_index[colIndex]] + str_offset[colIndex]*len, len);
    else
        str_gather(d_int, real_count, d, alloced_tmp, len);

    if(!prm.empty()) {
        str_offset[colIndex] = str_offset[colIndex] + prm_count[segNum];
    }
    else {
        str_offset[colIndex] = str_offset[colIndex] + real_count;
    };

    //if(d_columns_char[type_index[colIndex]])
    //    cudaFree(d_columns_char[type_index[colIndex]]);
    //d_columns_char[type_index[colIndex]] = (char*)d_char;

    mRecCount = real_count;

    cudaFree(d);
    cudaFree(d_val);
    cudaFree(d_v);
    cudaFree(d_int);
}




void CudaSet::CopyToGpu(unsigned int offset, unsigned int count)
{
    if (not_compressed) {
        for(unsigned int i = 0; i < mColumnCount; i++) {
            switch(type[i]) {
            case 0 :
                thrust::copy(h_columns_int[type_index[i]].begin() + offset, h_columns_int[type_index[i]].begin() + offset + count, d_columns_int[type_index[i]].begin());
                break;
            case 1 :
                thrust::copy(h_columns_float[type_index[i]].begin() + offset, h_columns_float[type_index[i]].begin() + offset + count, d_columns_float[type_index[i]].begin());
                break;
            default :
                cudaMemcpy(d_columns_char[type_index[i]], h_columns_char[type_index[i]], char_size[type_index[i]]*(offset + count), cudaMemcpyHostToDevice);
            };
        };
    }
    else
        for(unsigned int i = 0; i < mColumnCount; i++)
            CopyColumnToGpu(i,  offset, count);
};


void CudaSet::CopyColumnToGpu(unsigned int colIndex,  unsigned int segment)
{
    if(not_compressed) {
        switch(type[colIndex]) {
        case 0 :
            if(!alloced_switch)
                thrust::copy(h_columns_int[type_index[colIndex]].begin(), h_columns_int[type_index[colIndex]].begin() + mRecCount, d_columns_int[type_index[colIndex]].begin());
            else {
                thrust::device_ptr<int_type> d_col((int_type*)alloced_tmp);
                thrust::copy(h_columns_int[type_index[colIndex]].begin(), h_columns_int[type_index[colIndex]].begin() + mRecCount, d_col);
            };
            break;
        case 1 :
            if(!alloced_switch)
                thrust::copy(h_columns_float[type_index[colIndex]].begin(), h_columns_float[type_index[colIndex]].begin() + mRecCount, d_columns_float[type_index[colIndex]].begin());
            else {
                thrust::device_ptr<float_type> d_col((float_type*)alloced_tmp);
                thrust::copy(h_columns_float[type_index[colIndex]].begin(), h_columns_float[type_index[colIndex]].begin() + mRecCount, d_col);
            };
            break;
        default :
            if(!alloced_switch)
                cudaMemcpy(d_columns_char[type_index[colIndex]], h_columns_char[type_index[colIndex]], char_size[type_index[colIndex]]*mRecCount, cudaMemcpyHostToDevice);
            else
                cudaMemcpy(alloced_tmp, h_columns_char[type_index[colIndex]], char_size[type_index[colIndex]]*mRecCount, cudaMemcpyHostToDevice);
        };
    }
    else {


        unsigned long long int data_offset;
        if (partial_load)
            data_offset = readSegmentsFromFile(segment,colIndex);

        if(type[colIndex] != 2) {
            if(d_v == NULL)
                CUDA_SAFE_CALL(cudaMalloc((void **) &d_v, 12));
            if(s_v == NULL);
            CUDA_SAFE_CALL(cudaMalloc((void **) &s_v, 8));
        };

        if(type[colIndex] == 0) {
            if(!alloced_switch) {
                mRecCount = pfor_decompress(thrust::raw_pointer_cast(d_columns_int[type_index[colIndex]].data()), h_columns_int[type_index[colIndex]].data() + data_offset, d_v, s_v);
            }
            else {
                mRecCount = pfor_decompress(alloced_tmp, h_columns_int[type_index[colIndex]].data() + data_offset, d_v, s_v);
            };
        }
        else if(type[colIndex] == 1) {
            if(decimal[colIndex]) {
                if(!alloced_switch) {
                    mRecCount = pfor_decompress( thrust::raw_pointer_cast(d_columns_float[type_index[colIndex]].data()) , h_columns_float[type_index[colIndex]].data() + data_offset, d_v, s_v);
                    thrust::device_ptr<long long int> d_col_int((long long int*)thrust::raw_pointer_cast(d_columns_float[type_index[colIndex]].data()));
                    thrust::transform(d_col_int,d_col_int+mRecCount,d_columns_float[type_index[colIndex]].begin(), long_to_float());
                }
                else {
                    mRecCount = pfor_decompress(alloced_tmp, h_columns_float[type_index[colIndex]].data() + data_offset, d_v, s_v);
                    thrust::device_ptr<long long int> d_col_int((long long int*)alloced_tmp);
                    thrust::device_ptr<float_type> d_col_float((float_type*)alloced_tmp);
                    thrust::transform(d_col_int,d_col_int+mRecCount, d_col_float, long_to_float());
                };
            }
            //else // uncompressed float
            //cudaMemcpy( d_columns[colIndex], (void *) ((float_type*)h_columns[colIndex] + offset), count*float_size, cudaMemcpyHostToDevice);
            // will have to fix it later so uncompressed data will be written by segments too
        }
    };
}



void CudaSet::CopyColumnToGpu(unsigned int colIndex) // copy all segments
{
    if(not_compressed) {
        switch(type[colIndex]) {
        case 0 :
            thrust::copy(h_columns_int[type_index[colIndex]].begin(), h_columns_int[type_index[colIndex]].begin() + mRecCount, d_columns_int[type_index[colIndex]].begin());
            break;
        case 1 :
            thrust::copy(h_columns_float[type_index[colIndex]].begin(), h_columns_float[type_index[colIndex]].begin() + mRecCount, d_columns_float[type_index[colIndex]].begin());
            break;
        default :
            cudaMemcpy(d_columns_char[type_index[colIndex]], h_columns_char[type_index[colIndex]], char_size[type_index[colIndex]]*mRecCount, cudaMemcpyHostToDevice);
        };
    }
    else {
        long long int data_offset;
        unsigned long long int totalRecs = 0;
        if(d_v == NULL)
            CUDA_SAFE_CALL(cudaMalloc((void **) &d_v, 12));
        if(s_v == NULL);
        CUDA_SAFE_CALL(cudaMalloc((void **) &s_v, 8));

        str_offset[colIndex] = 0;
        for(unsigned int i = 0; i < segCount; i++) {

            if (partial_load)
                data_offset = readSegmentsFromFile(i,colIndex);


            if(type[colIndex] == 0) {
                mRecCount = pfor_decompress(thrust::raw_pointer_cast(d_columns_int[type_index[colIndex]].data() + totalRecs), h_columns_int[type_index[colIndex]].data() + data_offset, d_v, s_v);
            }
            else if(type[colIndex] == 1) {
                if(decimal[colIndex]) {
                    mRecCount = pfor_decompress( thrust::raw_pointer_cast(d_columns_float[type_index[colIndex]].data() + totalRecs) , h_columns_float[type_index[colIndex]].data() + data_offset, d_v, s_v);
                    thrust::device_ptr<long long int> d_col_int((long long int*)thrust::raw_pointer_cast(d_columns_float[type_index[colIndex]].data() + totalRecs));
                    thrust::transform(d_col_int,d_col_int+mRecCount,d_columns_float[type_index[colIndex]].begin() + totalRecs, long_to_float());
                }
                // else  uncompressed float
                //cudaMemcpy( d_columns[colIndex], (void *) ((float_type*)h_columns[colIndex] + offset), count*float_size, cudaMemcpyHostToDevice);
                // will have to fix it later so uncompressed data will be written by segments too
            };

            totalRecs = totalRecs + mRecCount;
        };

        mRecCount = totalRecs;
    };
}




void CudaSet::CopyColumnToGpu(unsigned int colIndex,  unsigned int offset, unsigned int count)
{
    if(not_compressed) {
        switch(type[colIndex]) {
        case 0 :
            thrust::copy(h_columns_int[type_index[colIndex]].begin(), h_columns_int[type_index[colIndex]].begin() + offset + count, d_columns_int[type_index[colIndex]].begin());
            break;
        case 1 :
            thrust::copy(h_columns_float[type_index[colIndex]].begin(), h_columns_float[type_index[colIndex]].begin() + offset + count, d_columns_float[type_index[colIndex]].begin());
            break;
        default :
            cudaMemcpy(d_columns_char[type_index[colIndex]], h_columns_char[type_index[colIndex]], char_size[type_index[colIndex]]*(offset + count), cudaMemcpyHostToDevice);
        };
    }
    else {
    };
}




void CudaSet::CopyColumnToHost(int colIndex, unsigned int offset, unsigned int RecCount)
{

    switch(type[colIndex]) {
    case 0 :
        thrust::copy(d_columns_int[type_index[colIndex]].begin(), d_columns_int[type_index[colIndex]].begin() + RecCount, h_columns_int[type_index[colIndex]].begin() + offset);
        break;
    case 1 :
        thrust::copy(d_columns_float[type_index[colIndex]].begin(), d_columns_float[type_index[colIndex]].begin() + RecCount, h_columns_float[type_index[colIndex]].begin() + offset);
        break;
    default :
        cudaMemcpy(h_columns_char[type_index[colIndex]] + offset*char_size[type_index[colIndex]], d_columns_char[type_index[colIndex]], char_size[type_index[colIndex]]*RecCount, cudaMemcpyDeviceToHost);
    }
}



void CudaSet::CopyColumnToHost(int colIndex)
{
    CopyColumnToHost(colIndex, 0, mRecCount);
}

void CudaSet::CopyToHost(unsigned int offset, unsigned int count)
{
    for(unsigned int i = 0; i < mColumnCount; i++) {
        CopyColumnToHost(i, offset, count);
    };
}

float_type* CudaSet::get_float_type_by_name(string name)
{
    unsigned int colIndex = columnNames.find(name)->second;
    return thrust::raw_pointer_cast(d_columns_float[type_index[colIndex]].data());
}

int_type* CudaSet::get_int_by_name(string name)
{
    unsigned int colIndex = columnNames.find(name)->second;
    return thrust::raw_pointer_cast(d_columns_int[type_index[colIndex]].data());
}

float_type* CudaSet::get_host_float_by_name(string name)
{
    unsigned int colIndex = columnNames.find(name)->second;
    return thrust::raw_pointer_cast(h_columns_float[type_index[colIndex]].data());
}

int_type* CudaSet::get_host_int_by_name(string name)
{
    unsigned int colIndex = columnNames.find(name)->second;
    return thrust::raw_pointer_cast(h_columns_int[type_index[colIndex]].data());
}



void CudaSet::GroupBy(stack<string> columnRef, unsigned int int_col_count)
{
    int grpInd, colIndex;

    if(grp)
        cudaFree(grp);

    CUDA_SAFE_CALL(cudaMalloc((void **) &grp, mRecCount * sizeof(bool)));
    thrust::device_ptr<bool> d_grp(grp);

    thrust::sequence(d_grp, d_grp+mRecCount, 0, 0);

    thrust::device_ptr<bool> d_group = thrust::device_malloc<bool>(mRecCount);

    d_group[mRecCount-1] = 1;
    unsigned int i_count = 0;

    for(int i = 0; i < columnRef.size(); columnRef.pop()) {

        columnGroups.push(columnRef.top()); // save for future references
        colIndex = columnNames[columnRef.top()];

        if(!onDevice(colIndex)) {
            allocColumnOnDevice(colIndex,mRecCount);
            CopyColumnToGpu(colIndex,  mRecCount);
            grpInd = 1;
        }
        else
            grpInd = 0;

        if (type[colIndex] == 0) {  // int_type
            thrust::transform(d_columns_int[type_index[colIndex]].begin(), d_columns_int[type_index[colIndex]].begin() + mRecCount - 1,
                              d_columns_int[type_index[colIndex]].begin()+1, d_group, thrust::not_equal_to<int_type>());
        }
        else if (type[colIndex] == 1) {  // float_type
            thrust::transform(d_columns_float[type_index[colIndex]].begin(), d_columns_float[type_index[colIndex]].begin() + mRecCount - 1,
                              d_columns_float[type_index[colIndex]].begin()+1, d_group, f_not_equal_to());
        }
        else  {  // Char
            //str_grp(d_columns_char[type_index[colIndex]], mRecCount, d_group, char_size[type_index[colIndex]]);
            //use int_type

            thrust::transform(d_columns_int[int_col_count+i_count].begin(), d_columns_int[int_col_count+i_count].begin() + mRecCount - 1,
                              d_columns_int[int_col_count+i_count].begin()+1, d_group, thrust::not_equal_to<int_type>());
            i_count++;

        };
        thrust::transform(d_group, d_group+mRecCount, d_grp, d_grp, thrust::logical_or<bool>());

        if (grpInd == 1)
            deAllocColumnOnDevice(colIndex);
    };

    thrust::device_free(d_group);
    grp_count = thrust::count(d_grp, d_grp+mRecCount,1);
};


void CudaSet::addDeviceColumn(int_type* col, int colIndex, string colName, unsigned int recCount)
{
    if (columnNames.find(colName) == columnNames.end()) {
        columnNames[colName] = colIndex;
        type[colIndex] = 0;
        d_columns_int.push_back(thrust::device_vector<int_type>(recCount));
        h_columns_int.push_back(thrust::host_vector<int_type, uninitialized_host_allocator<int_type> >());
        type_index[colIndex] = d_columns_int.size()-1;
    }
    else {  // already exists, my need to resize it
        if(d_columns_int[type_index[colIndex]].size() < recCount) {
            d_columns_int[type_index[colIndex]].resize(recCount);
        };
    };
    // copy data to d columns
    thrust::device_ptr<int_type> d_col((int_type*)col);
    thrust::copy(d_col, d_col+recCount, d_columns_int[type_index[colIndex]].begin());
};

void CudaSet::addDeviceColumn(float_type* col, int colIndex, string colName, unsigned int recCount)
{
    if (columnNames.find(colName) == columnNames.end()) {
        columnNames[colName] = colIndex;
        type[colIndex] = 1;
        d_columns_float.push_back(thrust::device_vector<float_type>(recCount));
        h_columns_float.push_back(thrust::host_vector<float_type, uninitialized_host_allocator<float_type> >());
        type_index[colIndex] = d_columns_float.size()-1;
    }
    else {  // already exists, my need to resize it
        if(d_columns_float[type_index[colIndex]].size() < recCount)
            d_columns_float[type_index[colIndex]].resize(recCount);
    };

    thrust::device_ptr<float_type> d_col((float_type*)col);
    thrust::copy(d_col, d_col+recCount, d_columns_float[type_index[colIndex]].begin());
};


void CudaSet::writeHeader(char* file_name, unsigned int col) {

    char str[100];
    char col_pos[3];

    strcpy(str, file_name);
    strcat(str,".");
    itoaa(col,col_pos);
    strcat(str,col_pos);
    string ff = str;
    strcat(str,".header");

    fstream binary_file(str,ios::out|ios::binary|ios::app);
    binary_file.write((char *)&total_count, 8);
    binary_file.write((char *)&total_segments, 4);
    binary_file.write((char *)&total_max, 4);
    binary_file.write((char *)&cnt_counts[ff], 4);
    binary_file.close();
};

void CudaSet::Store(char* file_name, char* sep, unsigned int limit, bool binary )
{
    if (mRecCount == 0 && binary == 1) { // write tails
        for(unsigned int i = 0; i< mColumnCount; i++) {
            writeHeader(file_name, cols[i]);
        };
        return;
    };

    unsigned int mCount;

    if(limit != 0 && limit < mRecCount)
        mCount = limit;
    else
        mCount = mRecCount;

    if(binary == 0) {

        char buffer [33];
        queue<string> op_vx;
        for ( map<string,int>::iterator it=columnNames.begin() ; it != columnNames.end(); ++it )
            op_vx.push((*it).first);
        curr_segment = 1000000;
        FILE *file_pr = fopen(file_name, "w");
        if (file_pr  == NULL)
            cout << "Could not open file " << file_name << endl;

        if(prm.size() || source)
            allocColumns(this, op_vx);
        unsigned int curr_seg = 0, cnt = 0;
        unsigned curr_count, sum_printed = 0;
        while(sum_printed < mCount) {

//			    cout << "mcount " << mCount << " " << prm.size() << " " << keep << endl;
            if(prm.size() || source)  {
                copyColumns(this, op_vx, curr_seg, cnt);
                // if host arrays are empty
                unsigned int olRecs = mRecCount;
                resize(mRecCount);
                mRecCount = olRecs;
                CopyToHost(0,mRecCount);
                if(sum_printed + mRecCount <= mCount)
                    curr_count = mRecCount;
                else {
                    curr_count = mCount - sum_printed;
                };
            }
            else
                curr_count = mCount;


            sum_printed = sum_printed + mRecCount;
            string ss;

            for(unsigned int i=0; i < curr_count; i++) {
                for(unsigned int j=0; j < mColumnCount; j++) {
                    if (type[j] == 0) {
                        sprintf(buffer, "%lld", (h_columns_int[type_index[j]])[i] );
                        fputs(buffer,file_pr);
                        fputs(sep, file_pr);
                    }
                    else if (type[j] == 1) {
                        sprintf(buffer, "%.2f", (h_columns_float[type_index[j]])[i] );
                        fputs(buffer,file_pr);
                        fputs(sep, file_pr);
                    }
                    else {
                        ss.assign(h_columns_char[type_index[j]] + (i*char_size[type_index[j]]), char_size[type_index[j]]);
                        trim(ss);
                        fputs(ss.c_str(), file_pr);
                        fputs(sep, file_pr);
                    };
                };
                if (i != mCount -1)
                    fputs("\n",file_pr);
            };
            curr_seg++;
        };
        fclose(file_pr);
    }
    else if(text_source) {  //writing a binary file using a text file as a source

        char str[100];
        char col_pos[3];
        total_count = total_count + mCount;
        total_segments = total_segments + 1;
        if (mCount > total_max)
            total_max = mCount;

        void* d;
        CUDA_SAFE_CALL(cudaMalloc((void **) &d, mCount*float_size));

        for(unsigned int i = 0; i< mColumnCount; i++) {
            strcpy(str, file_name);
            strcat(str,".");
            itoaa(cols[i],col_pos);
            strcat(str,col_pos);
            curr_file = str;

            strcat(str,".");
            itoaa(total_segments-1,col_pos);
            strcat(str,col_pos);
			cout << "Writing to " << str << endl;


            if(type[i] == 0) {
                thrust::device_ptr<int_type> d_col((int_type*)d);
                thrust::copy(h_columns_int[type_index[i]].begin(), h_columns_int[type_index[i]].begin() + mCount, d_col);
				cout << "Compressing " << endl;
                pfor_compress( d, mCount*int_size, str, h_columns_int[type_index[i]], 0, 0);
				cout << "Compressed " << endl;
            }
            else if(type[i] == 1) {
                if(decimal[i]) {
                    thrust::device_ptr<float_type> d_col((float_type*)d);
                    thrust::copy(h_columns_float[type_index[i]].begin(), h_columns_float[type_index[i]].begin() + mCount, d_col);
                    thrust::device_ptr<long long int> d_col_dec((long long int*)d);
                    thrust::transform(d_col,d_col+mCount,d_col_dec, float_to_long());
					cout << "Compressing " << endl;
                    pfor_compress( d, mCount*float_size, str, h_columns_float[type_index[i]], 1, 0);
					cout << "Compressed " << endl;
                }
                else { // do not compress -- float
                    fstream binary_file(str,ios::out|ios::binary|fstream::app);
                    binary_file.write((char *)&mCount, 4);
                    binary_file.write((char *)(h_columns_float[type_index[i]].data()),mCount*float_size);
                    unsigned int comp_type = 3;
                    binary_file.write((char *)&comp_type, 4);
                    binary_file.close();
                };
            }
            else { //char
			    cout << "Compressing char" << endl;
                compress_char(str, i, mCount);
				cout << "Compressed char " << endl;
            };

            if(fact_file_loaded) {
                writeHeader(file_name, cols[i]);
            };

        };


        for(unsigned int i = 0; i< mColumnCount; i++)
            if(type[i] == 2)
                deAllocColumnOnDevice(i);

        cudaFree(d);

    }
    else { //writing a binary file using a binary file as a source
        fact_file_loaded = 1;
        // do it for every segment

        // will add this later
    };
}


void CudaSet::compress_char(string file_name, unsigned int index, unsigned int mCount)
{
    std::vector<string> v1;
    std::map<string,unsigned int> dict;
    std::vector<string> dict_ordered;
    std::vector<unsigned int> dict_val;
    map<string,unsigned int>::iterator iter;
    unsigned int bits_encoded;
    char* field;
    unsigned int len = char_size[type_index[index]];

    field = new char[len];

    for (unsigned int i = 0 ; i < mCount; i++) {

        strncpy(field, h_columns_char[type_index[index]] + i*len, char_size[type_index[index]]);
        v1.push_back(field);

        if((iter = dict.find(field)) != dict.end()) {
            dict_val.push_back(iter->second);
        }
        else {
            string f = field;
            dict[f] = dict.size();
            dict_val.push_back(dict.size()-1);
            dict_ordered.push_back(f);
        };
    };

    bits_encoded = (unsigned int)ceil(log2(double(dict.size()+1)));

    char *cc = new char[len+1];
    unsigned int sz = dict_ordered.size();
    // write to a file
    fstream binary_file(file_name.c_str(),ios::out|ios::binary);
    binary_file.write((char *)&sz, 4);
    for(unsigned int i = 0; i < dict_ordered.size(); i++) {
        memset(&cc[0], 0, len);
        strcpy(cc,dict_ordered[i].c_str());
        binary_file.write(cc, len);
    };

    delete [] cc;
    unsigned int fit_count = 64/bits_encoded;
    unsigned long long int val = 0;
    binary_file.write((char *)&fit_count, 4);
    binary_file.write((char *)&bits_encoded, 4);
    unsigned int curr_cnt = 1;
    unsigned int vals_count = dict_val.size()/fit_count;
    if(!vals_count || dict_val.size()%fit_count)
        vals_count++;
    binary_file.write((char *)&vals_count, 4);
    unsigned int real_count = dict_val.size();
    binary_file.write((char *)&real_count, 4);

    for(unsigned int i = 0; i < dict_val.size(); i++) {

        val = val | dict_val[i];

        if(curr_cnt < fit_count)
            val = val << bits_encoded;

        if( (curr_cnt == fit_count) || (i == (dict_val.size() - 1)) ) {
            if (curr_cnt < fit_count) {
                val = val << ((fit_count-curr_cnt)-1)*bits_encoded;
            };
            curr_cnt = 1;
            binary_file.write((char *)&val, 8);
            val = 0;
        }
        else
            curr_cnt = curr_cnt + 1;
    };
    binary_file.close();
};


void CudaSet::LoadFile(char* file_name, char* sep )
{
    unsigned int count = 0;
    char line[500];
    char* field;
    unsigned int current_column = 1;

    FILE *file_ptr = fopen(file_name, "r");
    if (file_ptr  == NULL)
        cout << "Could not open file " << file_name << endl;

    unsigned int *seq = new unsigned int[mColumnCount];
    thrust::sequence(seq, seq+mColumnCount,0,1);
    thrust::stable_sort_by_key(cols, cols+mColumnCount, seq);


    while (fgets(line, 500, file_ptr) != NULL ) {

        current_column = 1;
        field = strtok(line,sep);

        for(unsigned int i = 0; i< mColumnCount; i++) {

            while(cols[i] > current_column) {
                field = strtok(NULL,sep);
                current_column++;
            };

            if (type[seq[i]] == 0) {
                if (strchr(field,'-') == NULL) {
                    (h_columns_int[type_index[seq[i]]])[count] = atoll(field);
                }
                else {   // handling possible dates
                    strncpy(field+4,field+5,2);
                    strncpy(field+6,field+8,2);
                    field[8] = '\0';
                    (h_columns_int[type_index[seq[i]]])[count] = atoll(field);
                };
            }
            else if (type[seq[i]] == 1)
                (h_columns_float[type_index[seq[i]]])[count] = atoff(field);
            else {
                strcpy(h_columns_char[type_index[seq[i]]] + count*char_size[type_index[seq[i]]], field);
            };
        };
        count++;
        if (count == mRecCount) {
            mRecCount = mRecCount + process_count;
            resize(mRecCount);
        };
    };
    fclose(file_ptr);
    mRecCount = count;
};


int CudaSet::LoadBigFile(const char* file_name, const char* sep )
{
    unsigned int count = 0;
    char line[1000];
    char* field;
    unsigned int current_column = 1;

    if (file_p == NULL)
        file_p = fopen(file_name, "r");
    if (file_p  == NULL)
        cout << "Could not open file " << file_name << endl;

    if (seq == 0) {
        seq = new unsigned int[mColumnCount];
        thrust::sequence(seq, seq+mColumnCount,0,1);
        thrust::stable_sort_by_key(cols, cols+mColumnCount, seq);
    };

    while (count < process_count && fgets(line, 1000, file_p) != NULL) {

        current_column = 1;
        field = strtok(line,sep);

        for(unsigned int i = 0; i< mColumnCount; i++) {

            while(cols[i] > current_column) {
                field = strtok(NULL,sep);
                current_column++;
            };
            if (type[seq[i]] == 0) {
                if (strchr(field,'-') == NULL) {
                    (h_columns_int[type_index[seq[i]]])[count] = atoll(field);
                }
                else {   // handling possible dates
                    strncpy(field+4,field+5,2);
                    strncpy(field+6,field+8,2);
                    field[8] = '\0';
                    (h_columns_int[type_index[seq[i]]])[count] = atoll(field);
                };
            }
            else if (type[seq[i]] == 1)
                (h_columns_float[type_index[seq[i]]])[count] = atoff(field);
            else  {//char
                strcpy(h_columns_char[type_index[seq[i]]] + count*char_size[type_index[seq[i]]], field);
            }
        };
        count++;
    };

    mRecCount = count;

    if(count < process_count)  {
        fclose(file_p);
        return 1;
    }
    else
        return 0;
};


void CudaSet::free()  {

    if (!seq)
        delete seq;

    for(unsigned int i = 0; i < mColumnCount; i++ ) {
        if(type[i] == 2 && h_columns_char[type_index[i]] && prm.empty()) {
            delete [] h_columns_char[type_index[i]];
            h_columns_char[type_index[i]] = NULL;
        };
    };

    if(!prm.empty()) { // free the sources
        string some_field;
        map<string,int>::iterator it=columnNames.begin();
        some_field = (*it).first;
        CudaSet* t = varNames[setMap[some_field]];
        t->deAllocOnDevice();

    };

    delete type;
    delete cols;

    if(!columnGroups.empty() && mRecCount !=0 && grp != NULL)
        cudaFree(grp);

    for(unsigned int i = 0; i < prm.size(); i++)
        delete [] prm[i];
};


bool* CudaSet::logical_and(bool* column1, bool* column2)
{
    thrust::device_ptr<bool> dev_ptr1(column1);
    thrust::device_ptr<bool> dev_ptr2(column2);

    thrust::transform(dev_ptr1, dev_ptr1+mRecCount, dev_ptr2, dev_ptr1, thrust::logical_and<bool>());

    thrust::device_free(dev_ptr2);
    return column1;
}


bool* CudaSet::logical_or(bool* column1, bool* column2)
{

    thrust::device_ptr<bool> dev_ptr1(column1);
    thrust::device_ptr<bool> dev_ptr2(column2);

    thrust::transform(dev_ptr1, dev_ptr1+mRecCount, dev_ptr2, dev_ptr1, thrust::logical_or<bool>());
    thrust::device_free(dev_ptr2);
    return column1;
}



bool* CudaSet::compare(int_type s, int_type d, int_type op_type)
{
    bool res;

    if (op_type == 2) // >
        if(d>s) res = 1;
        else res = 0;
    else if (op_type == 1)  // <
        if(d<s) res = 1;
        else res = 0;
    else if (op_type == 6) // >=
        if(d>=s) res = 1;
        else res = 0;
    else if (op_type == 5)  // <=
        if(d<=s) res = 1;
        else res = 0;
    else if (op_type == 4)// =
        if(d==s) res = 1;
        else res = 0;
    else // !=
        if(d!=s) res = 1;
        else res = 0;

    thrust::device_ptr<bool> p = thrust::device_malloc<bool>(mRecCount);
    thrust::sequence(p, p+mRecCount,res,(bool)0);

    return thrust::raw_pointer_cast(p);
};


bool* CudaSet::compare(float_type s, float_type d, int_type op_type)
{
    bool res;

    if (op_type == 2) // >
        if ((d-s) > EPSILON) res = 1;
        else res = 0;
    else if (op_type == 1)  // <
        if ((s-d) > EPSILON) res = 1;
        else res = 0;
    else if (op_type == 6) // >=
        if (((d-s) > EPSILON) || (((d-s) < EPSILON) && ((d-s) > -EPSILON))) res = 1;
        else res = 0;
    else if (op_type == 5)  // <=
        if (((s-d) > EPSILON) || (((d-s) < EPSILON) && ((d-s) > -EPSILON))) res = 1;
        else res = 0;
    else if (op_type == 4)// =
        if (((d-s) < EPSILON) && ((d-s) > -EPSILON)) res = 1;
        else res = 0;
    else // !=
        if (!(((d-s) < EPSILON) && ((d-s) > -EPSILON))) res = 1;
        else res = 0;

    thrust::device_ptr<bool> p = thrust::device_malloc<bool>(mRecCount);
    thrust::sequence(p, p+mRecCount,res,(bool)0);

    return thrust::raw_pointer_cast(p);
}


bool* CudaSet::compare(int_type* column1, int_type d, int_type op_type)
{
    thrust::device_ptr<bool> temp = thrust::device_malloc<bool>(mRecCount);
    thrust::device_ptr<int_type> dev_ptr(column1);


    if (op_type == 2) // >
        thrust::transform(dev_ptr, dev_ptr+mRecCount, thrust::make_constant_iterator(d), temp, thrust::greater<int_type>());
    else if (op_type == 1)  // <
        thrust::transform(dev_ptr, dev_ptr+mRecCount, thrust::make_constant_iterator(d), temp, thrust::less<int_type>());
    else if (op_type == 6) // >=
        thrust::transform(dev_ptr, dev_ptr+mRecCount, thrust::make_constant_iterator(d), temp, thrust::greater_equal<int_type>());
    else if (op_type == 5)  // <=
        thrust::transform(dev_ptr, dev_ptr+mRecCount, thrust::make_constant_iterator(d), temp, thrust::less_equal<int_type>());
    else if (op_type == 4)// =
        thrust::transform(dev_ptr, dev_ptr+mRecCount, thrust::make_constant_iterator(d), temp, thrust::equal_to<int_type>());
    else // !=
        thrust::transform(dev_ptr, dev_ptr+mRecCount, thrust::make_constant_iterator(d), temp, thrust::not_equal_to<int_type>());

    return thrust::raw_pointer_cast(temp);

}

bool* CudaSet::compare(float_type* column1, float_type d, int_type op_type)
{
    thrust::device_ptr<bool> res = thrust::device_malloc<bool>(mRecCount);
    thrust::device_ptr<float_type> dev_ptr(column1);

    if (op_type == 2) // >
        thrust::transform(dev_ptr, dev_ptr+mRecCount, thrust::make_constant_iterator(d), res, f_greater());
    else if (op_type == 1)  // <
        thrust::transform(dev_ptr, dev_ptr+mRecCount, thrust::make_constant_iterator(d), res, f_less());
    else if (op_type == 6) // >=
        thrust::transform(dev_ptr, dev_ptr+mRecCount, thrust::make_constant_iterator(d), res, f_greater_equal_to());
    else if (op_type == 5)  // <=
        thrust::transform(dev_ptr, dev_ptr+mRecCount, thrust::make_constant_iterator(d), res, f_less_equal());
    else if (op_type == 4)// =
        thrust::transform(dev_ptr, dev_ptr+mRecCount, thrust::make_constant_iterator(d), res, f_equal_to());
    else // !=
        thrust::transform(dev_ptr, dev_ptr+mRecCount, thrust::make_constant_iterator(d), res, f_not_equal_to());

    return thrust::raw_pointer_cast(res);
}


bool* CudaSet::compare(int_type* column1, int_type* column2, int_type op_type)
{
    thrust::device_ptr<int_type> dev_ptr1(column1);
    thrust::device_ptr<int_type> dev_ptr2(column2);
    thrust::device_ptr<bool> temp = thrust::device_malloc<bool>(mRecCount);

    if (op_type == 2) // >
        thrust::transform(dev_ptr1, dev_ptr1+mRecCount, dev_ptr2, temp, thrust::greater<int_type>());
    else if (op_type == 1)  // <
        thrust::transform(dev_ptr1, dev_ptr1+mRecCount, dev_ptr2, temp, thrust::less<int_type>());
    else if (op_type == 6) // >=
        thrust::transform(dev_ptr1, dev_ptr1+mRecCount, dev_ptr2, temp, thrust::greater_equal<int_type>());
    else if (op_type == 5)  // <=
        thrust::transform(dev_ptr1, dev_ptr1+mRecCount, dev_ptr2, temp, thrust::less_equal<int_type>());
    else if (op_type == 4)// =
        thrust::transform(dev_ptr1, dev_ptr1+mRecCount, dev_ptr2, temp, thrust::equal_to<int_type>());
    else // !=
        thrust::transform(dev_ptr1, dev_ptr1+mRecCount, dev_ptr2, temp, thrust::not_equal_to<int_type>());

    return thrust::raw_pointer_cast(temp);
}

bool* CudaSet::compare(float_type* column1, float_type* column2, int_type op_type)
{
    thrust::device_ptr<float_type> dev_ptr1(column1);
    thrust::device_ptr<float_type> dev_ptr2(column2);
    thrust::device_ptr<bool> temp = thrust::device_malloc<bool>(mRecCount);

    if (op_type == 2) // >
        thrust::transform(dev_ptr1, dev_ptr1+mRecCount, dev_ptr2, temp, f_greater());
    else if (op_type == 1)  // <
        thrust::transform(dev_ptr1, dev_ptr1+mRecCount, dev_ptr2, temp, f_less());
    else if (op_type == 6) // >=
        thrust::transform(dev_ptr1, dev_ptr1+mRecCount, dev_ptr2, temp, f_greater_equal_to());
    else if (op_type == 5)  // <=
        thrust::transform(dev_ptr1, dev_ptr1+mRecCount, dev_ptr2, temp, f_less_equal());
    else if (op_type == 4)// =
        thrust::transform(dev_ptr1, dev_ptr1+mRecCount, dev_ptr2, temp, f_equal_to());
    else // !=
        thrust::transform(dev_ptr1, dev_ptr1+mRecCount, dev_ptr2, temp, f_not_equal_to());

    return thrust::raw_pointer_cast(temp);

}


bool* CudaSet::compare(float_type* column1, int_type* column2, int_type op_type)
{
    thrust::device_ptr<float_type> dev_ptr1(column1);
    thrust::device_ptr<int_type> dev_ptr(column2);
    thrust::device_ptr<float_type> dev_ptr2 = thrust::device_malloc<float_type>(mRecCount);
    thrust::device_ptr<bool> temp = thrust::device_malloc<bool>(mRecCount);

    thrust::transform(dev_ptr, dev_ptr + mRecCount, dev_ptr2, long_to_float_type());

    if (op_type == 2) // >
        thrust::transform(dev_ptr1, dev_ptr1+mRecCount, dev_ptr2, temp, f_greater());
    else if (op_type == 1)  // <
        thrust::transform(dev_ptr1, dev_ptr1+mRecCount, dev_ptr2, temp, f_less());
    else if (op_type == 6) // >=
        thrust::transform(dev_ptr1, dev_ptr1+mRecCount, dev_ptr2, temp, f_greater_equal_to());
    else if (op_type == 5)  // <=
        thrust::transform(dev_ptr1, dev_ptr1+mRecCount, dev_ptr2, temp, f_less_equal());
    else if (op_type == 4)// =
        thrust::transform(dev_ptr1, dev_ptr1+mRecCount, dev_ptr2, temp, f_equal_to());
    else // !=
        thrust::transform(dev_ptr1, dev_ptr1+mRecCount, dev_ptr2, temp, f_not_equal_to());

    thrust::device_free(dev_ptr2);
    return thrust::raw_pointer_cast(temp);
}


float_type* CudaSet::op(int_type* column1, float_type* column2, string op_type, int reverse)
{

    thrust::device_ptr<float_type> temp = thrust::device_malloc<float_type>(mRecCount);
    thrust::device_ptr<int_type> dev_ptr(column1);

    thrust::transform(dev_ptr, dev_ptr + mRecCount, temp, long_to_float_type()); // in-place transformation

    thrust::device_ptr<float_type> dev_ptr1(column2);

    if(reverse == 0) {
        if (op_type.compare("MUL") == 0)
            thrust::transform(dev_ptr1, dev_ptr1+mRecCount, temp, temp, thrust::multiplies<float_type>());
        else if (op_type.compare("ADD") == 0)
            thrust::transform(dev_ptr1, dev_ptr1+mRecCount, temp, temp, thrust::plus<float_type>());
        else if (op_type.compare("MINUS") == 0)
            thrust::transform(dev_ptr1, dev_ptr1+mRecCount, temp, temp, thrust::minus<float_type>());
        else
            thrust::transform(dev_ptr1, dev_ptr1+mRecCount, temp, temp, thrust::divides<float_type>());
    }
    else {
        if (op_type.compare("MUL") == 0)
            thrust::transform(temp, temp+mRecCount, dev_ptr1, temp, thrust::multiplies<float_type>());
        else if (op_type.compare("ADD") == 0)
            thrust::transform(temp, temp+mRecCount, dev_ptr1, temp, thrust::plus<float_type>());
        else if (op_type.compare("MINUS") == 0)
            thrust::transform(temp, temp+mRecCount, dev_ptr1, temp, thrust::minus<float_type>());
        else
            thrust::transform(temp, temp+mRecCount, dev_ptr1, temp, thrust::divides<float_type>());

    };

    return thrust::raw_pointer_cast(temp);

}




int_type* CudaSet::op(int_type* column1, int_type* column2, string op_type, int reverse)
{

    thrust::device_ptr<int_type> temp = thrust::device_malloc<int_type>(mRecCount);
    thrust::device_ptr<int_type> dev_ptr1(column1);
    thrust::device_ptr<int_type> dev_ptr2(column2);

    if(reverse == 0) {
        if (op_type.compare("MUL") == 0)
            thrust::transform(dev_ptr1, dev_ptr1+mRecCount, dev_ptr2, temp, thrust::multiplies<int_type>());
        else if (op_type.compare("ADD") == 0)
            thrust::transform(dev_ptr1, dev_ptr1+mRecCount, dev_ptr2, temp, thrust::plus<int_type>());
        else if (op_type.compare("MINUS") == 0)
            thrust::transform(dev_ptr1, dev_ptr1+mRecCount, dev_ptr2, temp, thrust::minus<int_type>());
        else
            thrust::transform(dev_ptr1, dev_ptr1+mRecCount, dev_ptr2, temp, thrust::divides<int_type>());
    }
    else  {
        if (op_type.compare("MUL") == 0)
            thrust::transform(dev_ptr2, dev_ptr2+mRecCount, dev_ptr1, temp, thrust::multiplies<int_type>());
        else if (op_type.compare("ADD") == 0)
            thrust::transform(dev_ptr2, dev_ptr2+mRecCount, dev_ptr1, temp, thrust::plus<int_type>());
        else if (op_type.compare("MINUS") == 0)
            thrust::transform(dev_ptr2, dev_ptr2+mRecCount, dev_ptr1, temp, thrust::minus<int_type>());
        else
            thrust::transform(dev_ptr2, dev_ptr2+mRecCount, dev_ptr1, temp, thrust::divides<int_type>());
    }

    return thrust::raw_pointer_cast(temp);

}

float_type* CudaSet::op(float_type* column1, float_type* column2, string op_type, int reverse)
{

    thrust::device_ptr<float_type> temp = thrust::device_malloc<float_type>(mRecCount);
    thrust::device_ptr<float_type> dev_ptr1(column1);
    thrust::device_ptr<float_type> dev_ptr2(column2);

    if(reverse == 0) {
        if (op_type.compare("MUL") == 0)
            thrust::transform(dev_ptr1, dev_ptr1+mRecCount, dev_ptr2, temp, thrust::multiplies<float_type>());
        else if (op_type.compare("ADD") == 0)
            thrust::transform(dev_ptr1, dev_ptr1+mRecCount, dev_ptr2, temp, thrust::plus<float_type>());
        else if (op_type.compare("MINUS") == 0)
            thrust::transform(dev_ptr1, dev_ptr1+mRecCount, dev_ptr2, temp, thrust::minus<float_type>());
        else
            thrust::transform(dev_ptr1, dev_ptr1+mRecCount, dev_ptr2, temp, thrust::divides<float_type>());
    }
    else {
        if (op_type.compare("MUL") == 0)
            thrust::transform(dev_ptr2, dev_ptr2+mRecCount, dev_ptr1, temp, thrust::multiplies<float_type>());
        else if (op_type.compare("ADD") == 0)
            thrust::transform(dev_ptr2, dev_ptr2+mRecCount, dev_ptr1, temp, thrust::plus<float_type>());
        else if (op_type.compare("MINUS") == 0)
            thrust::transform(dev_ptr2, dev_ptr2+mRecCount, dev_ptr1, temp, thrust::minus<float_type>());
        else
            thrust::transform(dev_ptr2, dev_ptr2+mRecCount, dev_ptr1, temp, thrust::divides<float_type>());
    };
    return thrust::raw_pointer_cast(temp);
}

int_type* CudaSet::op(int_type* column1, int_type d, string op_type, int reverse)
{
    thrust::device_ptr<int_type> temp = thrust::device_malloc<int_type>(mRecCount);
    thrust::fill(temp, temp+mRecCount, d);

    thrust::device_ptr<int_type> dev_ptr1(column1);

    if(reverse == 0) {
        if (op_type.compare("MUL") == 0)
            thrust::transform(dev_ptr1, dev_ptr1+mRecCount, temp, temp, thrust::multiplies<int_type>());
        else if (op_type.compare("ADD") == 0)
            thrust::transform(dev_ptr1, dev_ptr1+mRecCount, temp, temp, thrust::plus<int_type>());
        else if (op_type.compare("MINUS") == 0)
            thrust::transform(dev_ptr1, dev_ptr1+mRecCount, temp, temp, thrust::minus<int_type>());
        else
            thrust::transform(dev_ptr1, dev_ptr1+mRecCount, temp, temp, thrust::divides<int_type>());
    }
    else {
        if (op_type.compare("MUL") == 0)
            thrust::transform(temp, temp+mRecCount, dev_ptr1, temp, thrust::multiplies<int_type>());
        else if (op_type.compare("ADD") == 0)
            thrust::transform(temp, temp+mRecCount, dev_ptr1, temp, thrust::plus<int_type>());
        else if (op_type.compare("MINUS") == 0)
            thrust::transform(temp, temp+mRecCount, dev_ptr1, temp, thrust::minus<int_type>());
        else
            thrust::transform(temp, temp+mRecCount, dev_ptr1, temp, thrust::divides<int_type>());
    };
    return thrust::raw_pointer_cast(temp);
}

float_type* CudaSet::op(int_type* column1, float_type d, string op_type, int reverse)
{
    thrust::device_ptr<float_type> temp = thrust::device_malloc<float_type>(mRecCount);
    thrust::fill(temp, temp+mRecCount, d);

    thrust::device_ptr<int_type> dev_ptr(column1);
    thrust::device_ptr<float_type> dev_ptr1 = thrust::device_malloc<float_type>(mRecCount);
    thrust::transform(dev_ptr, dev_ptr + mRecCount, dev_ptr1, long_to_float_type());

    if(reverse == 0) {
        if (op_type.compare("MUL") == 0)
            thrust::transform(dev_ptr1, dev_ptr1+mRecCount, temp, temp, thrust::multiplies<float_type>());
        else if (op_type.compare("ADD") == 0)
            thrust::transform(dev_ptr1, dev_ptr1+mRecCount, temp, temp, thrust::plus<float_type>());
        else if (op_type.compare("MINUS") == 0)
            thrust::transform(dev_ptr1, dev_ptr1+mRecCount, temp, temp, thrust::minus<float_type>());
        else
            thrust::transform(dev_ptr1, dev_ptr1+mRecCount, temp, temp, thrust::divides<float_type>());
    }
    else  {
        if (op_type.compare("MUL") == 0)
            thrust::transform(temp, temp+mRecCount, dev_ptr1, temp, thrust::multiplies<float_type>());
        else if (op_type.compare("ADD") == 0)
            thrust::transform(temp, temp+mRecCount, dev_ptr1, temp, thrust::plus<float_type>());
        else if (op_type.compare("MINUS") == 0)
            thrust::transform(temp, temp+mRecCount, dev_ptr1, temp, thrust::minus<float_type>());
        else
            thrust::transform(temp, temp+mRecCount, dev_ptr1, temp, thrust::divides<float_type>());

    };
    thrust::device_free(dev_ptr1);
    return thrust::raw_pointer_cast(temp);
}


float_type* CudaSet::op(float_type* column1, float_type d, string op_type,int reverse)
{
    thrust::device_ptr<float_type> temp = thrust::device_malloc<float_type>(mRecCount);
    thrust::device_ptr<float_type> dev_ptr1(column1);

    if(reverse == 0) {
        if (op_type.compare("MUL") == 0)
            thrust::transform(dev_ptr1, dev_ptr1+mRecCount, thrust::make_constant_iterator(d), temp, thrust::multiplies<float_type>());
        else if (op_type.compare("ADD") == 0)
            thrust::transform(dev_ptr1, dev_ptr1+mRecCount, thrust::make_constant_iterator(d), temp, thrust::plus<float_type>());
        else if (op_type.compare("MINUS") == 0)
            thrust::transform(dev_ptr1, dev_ptr1+mRecCount, thrust::make_constant_iterator(d), temp, thrust::minus<float_type>());
        else
            thrust::transform(dev_ptr1, dev_ptr1+mRecCount, thrust::make_constant_iterator(d), temp, thrust::divides<float_type>());
    }
    else	{
        if (op_type.compare("MUL") == 0)
            thrust::transform(thrust::make_constant_iterator(d), thrust::make_constant_iterator(d)+mRecCount, dev_ptr1, temp, thrust::multiplies<float_type>());
        else if (op_type.compare("ADD") == 0)
            thrust::transform(thrust::make_constant_iterator(d), thrust::make_constant_iterator(d)+mRecCount, dev_ptr1, temp, thrust::plus<float_type>());
        else if (op_type.compare("MINUS") == 0)
            thrust::transform(thrust::make_constant_iterator(d), thrust::make_constant_iterator(d)+mRecCount, dev_ptr1, temp, thrust::minus<float_type>());
        else
            thrust::transform(thrust::make_constant_iterator(d), thrust::make_constant_iterator(d)+mRecCount, dev_ptr1, temp, thrust::divides<float_type>());

    };

    return thrust::raw_pointer_cast(temp);

}


void CudaSet::initialize(queue<string> &nameRef, queue<string> &typeRef, queue<int> &sizeRef, queue<int> &colsRef, int_type Recs, char* file_name) // compressed data for DIM tables
{
    mColumnCount = nameRef.size();
    type = new unsigned int[mColumnCount];
    cols = new unsigned int[mColumnCount];
    decimal = new bool[mColumnCount];
    unsigned int cnt;
    file_p = NULL;
    FILE* f;
    char f1[100];

    not_compressed = 0;
    mRecCount = Recs;
    load_file_name = file_name;



    for(unsigned int i=0; i < mColumnCount; i++) {

        columnNames[nameRef.front()] = i;
        cols[i] = colsRef.front();
        seq = 0;

        strcpy(f1, file_name);
        strcat(f1,".");
        char col_pos[3];
        itoaa(colsRef.front(),col_pos);
        strcat(f1,col_pos); // read the size of a segment

        strcat(f1, ".header");
        f = fopen (f1 , "rb" );
        for(unsigned int j = 0; j < 5; j++)
            fread((char *)&cnt, 4, 1, f);
        fclose(f);
        //cout << "creating " << f1 << " " << cnt << endl;

        if ((typeRef.front()).compare("int") == 0) {
            type[i] = 0;
            decimal[i] = 0;
            h_columns_int.push_back(thrust::host_vector<int_type, uninitialized_host_allocator<int_type> >(cnt + 9));
            d_columns_int.push_back(thrust::device_vector<int_type>());
            type_index[i] = h_columns_int.size()-1;
        }
        else if ((typeRef.front()).compare("float") == 0) {
            type[i] = 1;
            decimal[i] = 0;
            h_columns_float.push_back(thrust::host_vector<float_type, uninitialized_host_allocator<float_type> >(cnt + 9));
            d_columns_float.push_back(thrust::device_vector<float_type >());
            type_index[i] = h_columns_float.size()-1;
        }
        else if ((typeRef.front()).compare("decimal") == 0) {
            type[i] = 1;
            decimal[i] = 1;
            h_columns_float.push_back(thrust::host_vector<float_type, uninitialized_host_allocator<float_type> >(cnt + 9));
            d_columns_float.push_back(thrust::device_vector<float_type>());
            type_index[i] = h_columns_float.size()-1;
        }
        else {
            type[i] = 2;
            decimal[i] = 0;
            h_columns_char.push_back(NULL);
            d_columns_char.push_back(NULL);
            char_size.push_back(sizeRef.front());
            type_index[i] = h_columns_char.size()-1;
        };

        nameRef.pop();
        typeRef.pop();
        sizeRef.pop();
        colsRef.pop();
    };
};



void CudaSet::initialize(queue<string> &nameRef, queue<string> &typeRef, queue<int> &sizeRef, queue<int> &colsRef, int_type Recs)
{
    mColumnCount = nameRef.size();
    type = new unsigned int[mColumnCount];
    cols = new unsigned int[mColumnCount];
    decimal = new bool[mColumnCount];

    file_p = NULL;

    mRecCount = Recs;
    segCount = 1;

    for(unsigned int i=0; i < mColumnCount; i++) {

        columnNames[nameRef.front()] = i;
        cols[i] = colsRef.front();
        seq = 0;

        if ((typeRef.front()).compare("int") == 0) {
            type[i] = 0;
            decimal[i] = 0;
            h_columns_int.push_back(thrust::host_vector<int_type, uninitialized_host_allocator<int_type> >());
            d_columns_int.push_back(thrust::device_vector<int_type>());
            type_index[i] = h_columns_int.size()-1;
        }
        else if ((typeRef.front()).compare("float") == 0) {
            type[i] = 1;
            decimal[i] = 0;
            h_columns_float.push_back(thrust::host_vector<float_type, uninitialized_host_allocator<float_type> >());
            d_columns_float.push_back(thrust::device_vector<float_type>());
            type_index[i] = h_columns_float.size()-1;
        }
        else if ((typeRef.front()).compare("decimal") == 0) {
            type[i] = 1;
            decimal[i] = 1;
            h_columns_float.push_back(thrust::host_vector<float_type, uninitialized_host_allocator<float_type> >());
            d_columns_float.push_back(thrust::device_vector<float_type>());
            type_index[i] = h_columns_float.size()-1;
        }

        else {
            type[i] = 2;
            decimal[i] = 0;
            h_columns_char.push_back(NULL);
            d_columns_char.push_back(NULL);
            char_size.push_back(sizeRef.front());
            type_index[i] = h_columns_char.size()-1;
        };
        nameRef.pop();
        typeRef.pop();
        sizeRef.pop();
        colsRef.pop();
    };
};

void CudaSet::initialize(unsigned int RecordCount, unsigned int ColumnCount)
{
    mRecCount = RecordCount;
    mColumnCount = ColumnCount;

    type = new unsigned int[mColumnCount];
    cols = new unsigned int[mColumnCount];
    decimal = new bool[mColumnCount];
    seq = 0;

    for(unsigned int i =0; i < mColumnCount; i++) {
        cols[i] = i;
    };


};


void CudaSet::initialize(CudaSet* a, CudaSet* b, int_type Recs, queue<string> op_sel, queue<string> op_sel_as)
{
    mRecCount = Recs;
    mColumnCount = op_sel.size();

    type = new unsigned int[mColumnCount];
    cols = new unsigned int[mColumnCount];
    decimal = new bool[mColumnCount];
    maxRecs = b->maxRecs;

    map<string,int>::iterator it;
    seq = 0;
    unsigned int i = 0;
    segCount = 1;
    not_compressed = 1;

    col_aliases = op_sel_as;
    queue<string> names(op_sel);

    while(!names.empty()) {
        columnNames[names.front()] = i;
        names.pop();
        i++;
    };


    unsigned int index;
    for(unsigned int i=0; i < mColumnCount; i++) {

        if((it = a->columnNames.find(op_sel.front())) !=  a->columnNames.end()) {
            index = it->second;
            cols[i] = i;
            decimal[i] = a->decimal[i];

            if ((a->type)[index] == 0)  {
                d_columns_int.push_back(thrust::device_vector<int_type>());
                h_columns_int.push_back(thrust::host_vector<int_type>());
                type[i] = 0;
                type_index[i] = h_columns_int.size()-1;
            }
            else if ((a->type)[index] == 1) {
                d_columns_float.push_back(thrust::device_vector<float_type>());
                h_columns_float.push_back(thrust::host_vector<float_type>());
                type[i] = 1;
                type_index[i] = h_columns_float.size()-1;
            }
            else {
                h_columns_char.push_back(NULL);
                d_columns_char.push_back(NULL);
                type[i] = 2;
                type_index[i] = h_columns_char.size()-1;
                char_size.push_back(a->char_size[a->type_index[index]]);
                prealloc_char_size = 0;
            };
        }
        else {
            it = b->columnNames.find(op_sel.front());
            index = it->second;

            cols[i] = i;
            decimal[i] = b->decimal[index];

            if ((b->type)[index] == 0) {
                d_columns_int.push_back(thrust::device_vector<int_type>());
                h_columns_int.push_back(thrust::host_vector<int_type, uninitialized_host_allocator<int_type> >());
                type[i] = 0;
                type_index[i] = h_columns_int.size()-1;
            }
            else if ((b->type)[index] == 1) {
                d_columns_float.push_back(thrust::device_vector<float_type>());
                h_columns_float.push_back(thrust::host_vector<float_type, uninitialized_host_allocator<float_type> >());
                type[i] = 1;
                type_index[i] = h_columns_float.size()-1;
            }
            else {
                h_columns_char.push_back(NULL);
                d_columns_char.push_back(NULL);
                type[i] = 2;
                type_index[i] = h_columns_char.size()-1;
                char_size.push_back(b->char_size[b->type_index[index]]);
                prealloc_char_size = 0;
            };
        }
        op_sel.pop();
    };
};



int_type reverse_op(int_type op_type)
{
    if (op_type == 2) // >
        return 5;
    else if (op_type == 1)  // <
        return 6;
    else if (op_type == 6) // >=
        return 1;
    else if (op_type == 5)  // <=
        return 2;
    else return op_type;
}


size_t getFreeMem()
{
    size_t available, total;
    cudaMemGetInfo(&available, &total);
    return available;
} ;



void allocColumns(CudaSet* a, queue<string> fields)
{
    if(!a->prm.empty()) {
        unsigned int max_sz = max_tmp(a) ;
        CudaSet* t = varNames[setMap[fields.front()]];
        if(max_sz*t->maxRecs > alloced_sz) {
            if(alloced_sz) {
                cudaFree(alloced_tmp);
            };
            cudaMalloc((void **) &alloced_tmp, max_sz*t->maxRecs);
            alloced_sz = max_sz*t->maxRecs;
        }
    }
    else {

        while(!fields.empty()) {
            if(setMap.count(fields.front()) > 0) {

                unsigned int idx = a->columnNames[fields.front()];
                bool onDevice = 0;

                if(a->type[idx] == 0) {
                    if(a->d_columns_int[a->type_index[idx]].size() > 0) {
                        onDevice = 1;
                    }
                }
                else if(a->type[idx] == 1) {
                    if(a->d_columns_float[a->type_index[idx]].size() > 0) {
                        onDevice = 1;
                    };
                }
                else {
                    if((a->d_columns_char[a->type_index[idx]]) != NULL) {
                        onDevice = 1;
                    };
                };

                if (!onDevice) {
                    if(a->prm.empty()) {
                        a->allocColumnOnDevice(idx, a->maxRecs);
                    }
                    else {
                        a->allocColumnOnDevice(idx, largest_prm(a));
                    };
                };
            };
            fields.pop();
        };
    };
}

unsigned int largest_prm(CudaSet* a)
{
    unsigned int maxx = 0;

    for(unsigned int i = 0; i < a->prm_count.size(); i++)
        if(maxx < a->prm_count[i])
            maxx = a->prm_count[i];
    if(maxx == 0)
        maxx = a->maxRecs;
    return maxx;
};


void gatherColumns(CudaSet* a, CudaSet* t, string field, unsigned int segment, unsigned int& count)
{

    unsigned int tindex = t->columnNames[field];
    unsigned int idx = a->columnNames[field];

    //find the largest possible size of a gathered segment
    if(!a->onDevice(idx)) {
        unsigned int max_count = 0;

        for(unsigned int i = 0; i < a->prm.size(); i++)
            if (a->prm_count[i] > max_count)
                max_count = a->prm_count[i];
        a->allocColumnOnDevice(idx, max_count);
    };



    unsigned int g_size = a->prm_count[segment];

    if(a->prm_index[segment] == 'R') {

        if(a->prm_d.size() == 0) // find the largest prm segment
            a->prm_d.resize(largest_prm(a));

        if(curr_segment != segment) {
            cudaMemcpy((void**)(thrust::raw_pointer_cast(a->prm_d.data())), (void**)a->prm[segment],
                       4*g_size, cudaMemcpyHostToDevice);
            curr_segment = segment;
        };

        mygather(tindex, idx, a, t, count, g_size);
    }
    else {
        mycopy(tindex, idx, a, t, count, g_size);
    };

    a->mRecCount = g_size;
}

unsigned int getSegmentRecCount(CudaSet* a, unsigned int segment) {
    if (segment == a->segCount-1) {
        return oldCount - a->maxRecs*segment;
    }
    else
        return 	a->maxRecs;
}



void copyColumns(CudaSet* a, queue<string> fields, unsigned int segment, unsigned int& count)
{
    set<string> uniques;
    CudaSet *t;

    while(!fields.empty()) {
        if (uniques.count(fields.front()) == 0 && setMap.count(fields.front()) > 0)	{
            if(!a->prm.empty()) {
                t = varNames[setMap[fields.front()]];
                if(a->prm_count[segment]) {

                    alloced_switch = 1;
                    //cout << "copy " << fields.front() << " " << alloced_switch << endl;
                    t->CopyColumnToGpu(t->columnNames[fields.front()], segment); // segment i
                    //cout << "gather " << fields.front() << endl;
                    gatherColumns(a, t, fields.front(), segment, count);
                    //cout << "end " << endl;
                    alloced_switch = 0;
                }
                else
                    a->mRecCount = 0;
            }
            else {
                a->CopyColumnToGpu(a->columnNames[fields.front()], segment); // segment i
            };
            uniques.insert(fields.front());
        };
        fields.pop();
    };
}



void setPrm(CudaSet* a, CudaSet* b, char val, unsigned int segment) {

    b->prm.push_back(NULL);
    b->prm_index.push_back(val);

    if (val == 'A') {
        b->mRecCount = b->mRecCount + getSegmentRecCount(a,segment);
        b->prm_count.push_back(getSegmentRecCount(a, segment));
    }
    else {
        b->prm_count.push_back(0);
    };
}



void mygather(unsigned int tindex, unsigned int idx, CudaSet* a, CudaSet* t, unsigned int offset, unsigned int g_size)
{
    if(t->type[tindex] == 0) {
        if(!alloced_switch) {
            thrust::gather(a->prm_d.begin(), a->prm_d.begin() + g_size,
                           t->d_columns_int[t->type_index[tindex]].begin(), a->d_columns_int[a->type_index[idx]].begin() + offset);
        }
        else {
            thrust::device_ptr<int_type> d_col((int_type*)alloced_tmp);
            thrust::gather(a->prm_d.begin(), a->prm_d.begin() + g_size,
                           d_col, a->d_columns_int[a->type_index[idx]].begin() + offset);
        };
    }
    else if(t->type[tindex] == 1) {
        if(!alloced_switch) {
            thrust::gather(a->prm_d.begin(), a->prm_d.begin() + g_size,
                           t->d_columns_float[t->type_index[tindex]].begin(), a->d_columns_float[a->type_index[idx]].begin() + offset);
        }
        else {
            thrust::device_ptr<float_type> d_col((float_type*)alloced_tmp);
            thrust::gather(a->prm_d.begin(), a->prm_d.begin() + g_size,
                           d_col, a->d_columns_float[a->type_index[idx]].begin() + offset);
        };
    }
    else {
        if(!alloced_switch) {
            str_gather((void*)thrust::raw_pointer_cast(a->prm_d.data()), g_size,
                       (void*)t->d_columns_char[t->type_index[tindex]], (void*)a->d_columns_char[a->type_index[idx]], a->char_size[a->type_index[idx]] );
        }
        else {
            str_gather((void*)thrust::raw_pointer_cast(a->prm_d.data()), g_size,
                       alloced_tmp, (void*)a->d_columns_char[a->type_index[idx]], a->char_size[a->type_index[idx]] );
        };
    }
};

void mycopy(unsigned int tindex, unsigned int idx, CudaSet* a, CudaSet* t, unsigned int offset, unsigned int g_size)
{
    if(t->type[tindex] == 0) {
        if(!alloced_switch) {
            thrust::copy(t->d_columns_int[t->type_index[tindex]].begin(), t->d_columns_int[t->type_index[tindex]].begin() + g_size,
                         a->d_columns_int[a->type_index[idx]].begin() + offset);
        }
        else {
            thrust::device_ptr<int_type> d_col((int_type*)alloced_tmp);
            thrust::copy(d_col, d_col + g_size, a->d_columns_int[a->type_index[idx]].begin() + offset);

        };
    }
    else if(t->type[tindex] == 1) {
        if(!alloced_switch) {
            thrust::copy(t->d_columns_float[t->type_index[tindex]].begin(), t->d_columns_float[t->type_index[tindex]].begin() + g_size,
                         a->d_columns_float[a->type_index[idx]].begin() + offset);
        }
        else {
            thrust::device_ptr<float_type> d_col((float_type*)alloced_tmp);
            thrust::copy(d_col, d_col + g_size,	a->d_columns_float[a->type_index[idx]].begin() + offset);
        };
    }
    else {
        if(!alloced_switch) {
            cudaMemcpy((void**)(a->d_columns_char[a->type_index[idx]] + offset*a->char_size[a->type_index[idx]]), (void**)t->d_columns_char[t->type_index[tindex]],
                       g_size*t->char_size[t->type_index[tindex]], cudaMemcpyDeviceToDevice);
        }
        else {
            cudaMemcpy((void**)(a->d_columns_char[a->type_index[idx]] + offset*a->char_size[a->type_index[idx]]), alloced_tmp,
                       g_size*t->char_size[t->type_index[tindex]], cudaMemcpyDeviceToDevice);
        };
    };
};



unsigned int load_queue(queue<string> c1, CudaSet* right, bool str_join, string f2, unsigned int &rcount)
{
    queue<string> cc;
    while(!c1.empty()) {
        if(right->columnNames.find(c1.front()) !=  right->columnNames.end()) {
            if(f2 != c1.front() || str_join) {
                cc.push(c1.front());
            };
        };
        c1.pop();
    };
    if(!str_join) {
        cc.push(f2);
    };

    unsigned int cnt_r = 0;
    if(!right->prm.empty()) {
        allocColumns(right, cc);
        rcount = std::accumulate(right->prm_count.begin(), right->prm_count.end(), 0 );
    }
    else
        rcount = right->mRecCount;

    queue<string> ct(cc);
    reset_offsets();

    while(!ct.empty()) {
        right->allocColumnOnDevice(right->columnNames[ct.front()], rcount);
        ct.pop();
    };


    ct = cc;
    if(right->prm.empty()) {
        //copy all records
        while(!ct.empty()) {
            right->CopyColumnToGpu(right->columnNames[ct.front()]);
            ct.pop();
        };
        cnt_r = right->mRecCount;
    }
    else {
        //copy and gather all records
        for(unsigned int i = 0; i < right->segCount; i++) {
            copyColumns(right, cc, i, cnt_r);
            cnt_r = cnt_r + right->prm_count[i];
        };
    };
    return cnt_r;

}

unsigned int max_char(CudaSet* a)
{
    unsigned int max_char = 0;
    for(unsigned int i = 0; i < a->char_size.size(); i++)
        if (a->char_size[i] > max_char)
            max_char = a->char_size[i];

    return max_char;
};

unsigned int max_char(CudaSet* a, set<string> field_names)
{
    unsigned int max_char = 0;
    for (set<string>::iterator it=field_names.begin(); it!=field_names.end(); ++it) {
        int i = a->columnNames[*it];	
		if (a->type[i] == 2) {
			if (a->char_size[a->type_index[i]] > max_char)
				max_char = a->char_size[a->type_index[i]];
		};
	};	
    return max_char;
};


unsigned int max_tmp(CudaSet* a)
{
    unsigned int max_sz = 0;
    for(unsigned int i = 0; i < a->mColumnCount; i++) {
        if(a->type[i] == 0) {
            if(int_size > max_sz)
                max_sz = int_size;
        }
        else if(a->type[i] == 1) {
            if(float_size > max_sz)
                max_sz = float_size;
        };
    };
    unsigned int m_char = max_char(a);
    if(m_char > max_sz)
        return m_char;
    else
        return max_sz;

};


void reset_offsets() {
    map<unsigned int, unsigned int>::iterator iter;

    for (iter = str_offset.begin(); iter != str_offset.end(); ++iter) {
        iter->second = 0;
    };

};

void setSegments(CudaSet* a, queue<string> cols)
{
	size_t mem_available = getFreeMem();
	unsigned int tot_sz = 0, idx;
	while(!cols.empty()) {
	    idx = a->columnNames[cols.front()];
	    if(a->type[idx] != 2)
			tot_sz = tot_sz + int_size;
		else
            tot_sz = tot_sz + a->char_size[a->type_index[idx]];
        cols.pop();		
	};
	cout << "tot " << tot_sz << endl;
	if(a->mRecCount*tot_sz > mem_available/2) {
	    a->segCount = (a->mRecCount*tot_sz)/(mem_available/2) + 1;	
	};

};
