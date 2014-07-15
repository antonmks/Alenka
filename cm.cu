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



#include <cctype>
#include <algorithm>
#include <functional>
#include <numeric>
#include "cm.h"
#include "atof.h"
#include "compress.cu"
#include "sorts.cu"
#include "filter.h"
#include "callbacks.h"


#ifdef _WIN64
#define atoll(S) _atoi64(S)
#include <windows.h>
#else
#include <unistd.h>
#endif


using namespace std;
using namespace thrust::placeholders;

size_t total_count = 0, total_max;
clock_t tot;
unsigned int total_segments = 0;
unsigned int process_count;
size_t alloced_sz = 0;
bool fact_file_loaded = 1;
bool verbose;
bool interactive;
void* d_v = NULL;
void* s_v = NULL;
queue<string> op_sort;
queue<string> op_presort;
queue<string> op_type;
bool op_case = 0;
queue<string> op_value;
queue<int_type> op_nums;
queue<float_type> op_nums_f;
queue<string> col_aliases;
map<string, map<string, col_data> > data_dict;

map<string, char*> buffers;
map<string, size_t> buffer_sizes;
size_t total_buffer_size;
queue<string> buffer_names;

void* alloced_tmp;
bool alloced_switch = 0;

map<string,CudaSet*> varNames; //  STL map to manage CudaSet variables
//map<string,string> setMap; //map to keep track of column names and set names

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
        return ((x-y) > EPSILON) || ((x-y) < -EPSILON);
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

char *mystrtok(char **m,char *s,const char c)
{
    char *p=s?s:*m;
    if( !*p )
        return 0;
    *m=strchr(p,c);
    if( *m )
        *(*m)++=0;
    else
        *m=p+strlen(p);
    return p;
}


void allocColumns(CudaSet* a, queue<string> fields);
void copyColumns(CudaSet* a, queue<string> fields, unsigned int segment, size_t& count, bool rsz, bool flt);
void mygather(unsigned int tindex, unsigned int idx, CudaSet* a, CudaSet* t, size_t count, size_t g_size);
void mycopy(unsigned int tindex, unsigned int idx, CudaSet* a, CudaSet* t, size_t count, size_t g_size);
void write_compressed_char(string file_name, unsigned int index, size_t mCount);
size_t max_tmp(CudaSet* a);
size_t getFreeMem();
char zone_map_check(queue<string> op_type, queue<string> op_value, queue<int_type> op_nums,queue<float_type> op_nums_f, CudaSet* a, unsigned int segment);
void filter_op(char *s, char *f, unsigned int segment);
size_t getTotalSystemMemory();
void process_error(int severity, string err);

CudaSet::CudaSet(queue<string> &nameRef, queue<string> &typeRef, queue<int> &sizeRef, queue<int> &colsRef, size_t Recs, queue<string> &references, queue<string> &references_names)
    : mColumnCount(0), mRecCount(0)
{
    initialize(nameRef, typeRef, sizeRef, colsRef, Recs, references, references_names);
    keep = false;
    source = 1;
    text_source = 1;
    grp = NULL;
    fil_f = NULL;
    fil_s = NULL;
};

CudaSet::CudaSet(queue<string> &nameRef, queue<string> &typeRef, queue<int> &sizeRef, queue<int> &colsRef, size_t Recs, string file_name, unsigned int max)
    : mColumnCount(0),  mRecCount(0)
{
    maxRecs = max;
    initialize(nameRef, typeRef, sizeRef, colsRef, Recs, file_name);
    keep = false;
    source = 1;
    text_source = 0;
    grp = NULL;
    fil_f = NULL;
    fil_s = NULL;
};

CudaSet::CudaSet(size_t RecordCount, unsigned int ColumnCount)
{
    initialize(RecordCount, ColumnCount);
    keep = false;
    source = 0;
    text_source = 0;
    grp = NULL;
    fil_f = NULL;
    fil_s = NULL;
};


CudaSet::CudaSet(CudaSet* a, CudaSet* b, queue<string> op_sel, queue<string> op_sel_as)
{
    initialize(a,b, op_sel, op_sel_as);
    keep = false;
    source = 0;
    text_source = 0;
    grp = NULL;
    fil_f = NULL;
    fil_s = NULL;
};


CudaSet::~CudaSet()
{
    free();
};


void CudaSet::allocColumnOnDevice(string colname, size_t RecordCount)
{
    if (type[colname] == 0) {
        d_columns_int[colname].resize(RecordCount);
    }
    else if (type[colname] == 1)
        d_columns_float[colname].resize(RecordCount);
    else {
        void* d;
        size_t sz = RecordCount*char_size[colname];
        cudaError_t cudaStatus = cudaMalloc(&d, sz);
        if(cudaStatus != cudaSuccess) {
            char buf[1024];
            sprintf( buf, "Could not allocate %llu bytes of GPU memory for %d records ", sz, RecordCount);
            process_error(3, string(buf));
        };
        d_columns_char[colname] = (char*)d;
    };
};


void CudaSet::decompress_char_hash(string colname, unsigned int segment)
{
    unsigned int bits_encoded, fit_count, sz, vals_count, real_count;
    size_t old_count;
    const unsigned int len = char_size[colname];

    string f1 = load_file_name + "." + colname + "." + int_to_string(segment);

    FILE* f;
    f = fopen (f1.c_str() , "rb" );
    fread(&sz, 4, 1, f);
    char* d_array = new char[sz*len];
    fread((void*)d_array, sz*len, 1, f);

    unsigned long long int* hashes  = new unsigned long long int[sz];

    for(unsigned int i = 0; i < sz ; i++) {
        hashes[i] = MurmurHash64A(&d_array[i*len], len, hash_seed)/2;
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

    delete[] int_array;
    void* d_int;
    cudaMalloc((void **) &d_int, real_count*4);

    // convert bits to ints and then do gather

    void* d_v1;
    cudaMalloc((void **) &d_v1, 8);
    thrust::device_ptr<unsigned int> dd_v((unsigned int*)d_v1);

    dd_v[1] = fit_count;
    dd_v[0] = bits_encoded;

    thrust::counting_iterator<unsigned int> begin(0);
    decompress_functor_str ff((unsigned long long int*)d_val,(unsigned int*)d_int, (unsigned int*)d_v1);
    thrust::for_each(begin, begin + real_count, ff);

    thrust::device_ptr<unsigned int> dd_val((unsigned int*)d_int);

    if(filtered) {
        if(prm_index == 'R') {
            thrust::device_ptr<int_type> d_tmp = thrust::device_malloc<int_type>(real_count);
            thrust::gather(dd_val, dd_val + real_count, dd_int, d_tmp);
            old_count = d_columns_int[colname].size();
            d_columns_int[colname].resize(old_count + mRecCount);
            thrust::gather(prm_d.begin(), prm_d.begin() + mRecCount, d_tmp, d_columns_int[colname].begin() + old_count);
            thrust::device_free(d_tmp);

        }
        else if(prm_index == 'A') {
            old_count = d_columns_int[colname].size();
            d_columns_int[colname].resize(old_count + real_count);
            thrust::gather(dd_val, dd_val + real_count, dd_int, d_columns_int[colname].begin() + old_count);
        }
    }
    else {
        old_count = d_columns_int[colname].size();
        d_columns_int[colname].resize(old_count + real_count);
        thrust::gather(dd_val, dd_val + real_count, dd_int, d_columns_int[colname].begin() + old_count);
    };


    cudaFree(d);
    cudaFree(d_val);
    cudaFree(d_v1);
    cudaFree(d_int);
};




// takes a char column , hashes strings, copies them to a gpu
void CudaSet::add_hashed_strings(string field, unsigned int segment)
{
    CudaSet *t;
    if(filtered)
        t = varNames[source_name];
    else
        t = this;

    if(not_compressed) { // decompressed strings on a host

        size_t old_count;
        unsigned long long int* hashes  = new unsigned long long int[t->mRecCount];

        for(unsigned int i = 0; i < t->mRecCount ; i++) {
            hashes[i] = MurmurHash64A(t->h_columns_char[field] + i*t->char_size[field] + segment*t->maxRecs*t->char_size[field], t->char_size[field], hash_seed)/2;
        };

        if(filtered) {

            if(prm_index == 'R') {
                thrust::device_ptr<unsigned long long int> d_tmp = thrust::device_malloc<unsigned long long int>(t->mRecCount);
                thrust::copy(hashes, hashes+mRecCount, d_tmp);
                old_count = d_columns_int[field].size();
                d_columns_int[field].resize(old_count + mRecCount);
                thrust::gather(prm_d.begin(), prm_d.begin() + mRecCount, d_tmp, d_columns_int[field].begin() + old_count);
                thrust::device_free(d_tmp);
            }
            else if(prm_index == 'A') {
                old_count = d_columns_int[field].size();
                d_columns_int[field].resize(old_count + mRecCount);
                thrust::copy(hashes, hashes + mRecCount, d_columns_int[field].begin() + old_count);
            }
        }
        else {
            old_count = d_columns_int[field].size();
            d_columns_int[field].resize(old_count + mRecCount);
            thrust::copy(hashes, hashes + mRecCount, d_columns_int[field].begin() + old_count);
        }
        delete [] hashes;
    }
    else { // hash the dictionary
        decompress_char_hash(field, segment);
    };
};




void CudaSet::resize_join(size_t addRecs)
{
    mRecCount = mRecCount + addRecs;
    bool prealloc = 0;
    for(unsigned int i=0; i < columnNames.size(); i++) {
        if(type[columnNames[i]] == 0) {
            h_columns_int[columnNames[i]].resize(mRecCount);
        }
        else if(type[columnNames[i]] == 1) {
            h_columns_float[columnNames[i]].resize(mRecCount);
        }
        else {
            if (h_columns_char.find(columnNames[i]) != h_columns_char.end()) {
                if (mRecCount > prealloc_char_size) {
                    h_columns_char[columnNames[i]] = (char*)realloc(h_columns_char[columnNames[i]], mRecCount*char_size[columnNames[i]]);
                    prealloc = 1;
                };
            }
            else {
                h_columns_char[columnNames[i]] = new char[mRecCount*char_size[columnNames[i]]];
            };
        };
    };
    if(prealloc)
        prealloc_char_size = mRecCount;
};


void CudaSet::resize(size_t addRecs)
{
    mRecCount = mRecCount + addRecs;
    for(unsigned int i=0; i < columnNames.size(); i++) {
        if(type[columnNames[i]] == 0) {
            h_columns_int[columnNames[i]].resize(mRecCount);
        }
        else if(type[columnNames[i]] == 1) {
            h_columns_float[columnNames[i]].resize(mRecCount);
        }
        else {
            if (h_columns_char[columnNames[i]]) {
                h_columns_char[columnNames[i]] = (char*)realloc(h_columns_char[columnNames[i]], mRecCount*char_size[columnNames[i]]);
            }
            else {
                h_columns_char[columnNames[i]] = new char[mRecCount*char_size[columnNames[i]]];
                memset(h_columns_char[columnNames[i]], 0, mRecCount*char_size[columnNames[i]]);
            };
        };

    };
};

void CudaSet::reserve(size_t Recs)
{

    for(unsigned int i=0; i < columnNames.size(); i++) {
        if(type[columnNames[i]] == 0)
            h_columns_int[columnNames[i]].reserve(Recs);
        else if(type[columnNames[i]] == 1)
            h_columns_float[columnNames[i]].reserve(Recs);
        else {
            h_columns_char[columnNames[i]] = new char[Recs*char_size[columnNames[i]]];
            if(h_columns_char[columnNames[i]] == NULL) {
                char buf[1024];
                sprintf(buf, "(Alenka) Could not allocate on a host %d records of size %llu", Recs, char_size[columnNames[i]]);
                process_error(3, string(buf));
            };
            prealloc_char_size = Recs;
        };

    };
};


void CudaSet::deAllocColumnOnDevice(string colname)
{
    if (type[colname] == 0 && !d_columns_int.empty()) {
        if(d_columns_int[colname].size() > 0) {
            d_columns_int[colname].resize(0);
            d_columns_int[colname].shrink_to_fit();
        };
    }
    else if (type[colname] == 1 && !d_columns_float.empty()) {
        if (d_columns_float[colname].size() > 0) {
            d_columns_float[colname].resize(0);
            d_columns_float[colname].shrink_to_fit();
        };
    }
    else if (type[colname] == 2 && d_columns_char[colname] != NULL) {
        cudaFree(d_columns_char[colname]);
        d_columns_char[colname] = NULL;
    };
};

void CudaSet::allocOnDevice(size_t RecordCount)
{
    for(unsigned int i=0; i < columnNames.size(); i++)
        allocColumnOnDevice(columnNames[i], RecordCount);
};

void CudaSet::deAllocOnDevice()
{
    for(unsigned int i=0; i < columnNames.size(); i++)
        deAllocColumnOnDevice(columnNames[i]);

    for ( map<string, thrust::device_vector<int_type > >::iterator it=d_columns_int.begin(); it != d_columns_int.end(); ++it ) {
        if(it->second.size() > 0) {
            it->second.resize(0);
            it->second.shrink_to_fit();
        };
    };

    for ( map<string, thrust::device_vector<float_type > >::iterator it=d_columns_float.begin(); it != d_columns_float.end(); ++it ) {
        if(it->second.size() > 0) {
            it->second.resize(0);
            it->second.shrink_to_fit();
        };
    };

    if(grp) {
        cudaFree(grp);
        grp = NULL;
    };

    if(filtered) { // free the sources
        if(varNames.find(source_name) != varNames.end()) {
            varNames[source_name]->deAllocOnDevice();
        };
    };
};

void CudaSet::resizeDeviceColumn(size_t RecCount, string colname)
{
    if (type[colname] == 0) {
        d_columns_int[colname].resize(RecCount);
    }
    else if (type[colname] == 1)
        d_columns_float[colname].resize(RecCount);
    else {
        void *d;
        cudaMalloc((void **) &d, RecCount*char_size[colname]);        
        if (d_columns_char[colname] != NULL) {
			cudaMemcpy( d, (void*)d_columns_char[colname], char_size[colname] * mRecCount, cudaMemcpyDeviceToDevice);			
            cudaFree(d_columns_char[colname]);		
		};	
		d_columns_char[colname] = (char*)d;		
    };
};



void CudaSet::resizeDevice(size_t RecCount)
{
    for(unsigned int i=0; i < columnNames.size(); i++) {
        resizeDeviceColumn(RecCount, columnNames[i]);
    };
};

bool CudaSet::onDevice(string colname)
{

    if (type[colname] == 0) {
        if (d_columns_int.empty())
            return 0;
        if (d_columns_int[colname].size() == 0)
            return 0;
    }
    else if (type[colname] == 1) {
        if (d_columns_float.empty())
            return 0;
        if(d_columns_float[colname].size() == 0)
            return 0;
    }
    else if  (type[colname] == 2) {
        if(d_columns_char.empty())
            return 0;
        if(d_columns_char[colname] == NULL)
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
    a->ref_joins = ref_joins;
    a->ref_sets = ref_sets;
    a->ref_cols = ref_cols;
    a->columnNames = columnNames;
    a->cols = cols;
    a->type = type;
    a->char_size = char_size;
    a->decimal = decimal;

    for(unsigned int i=0; i < columnNames.size(); i++) {

        if(a->type[columnNames[i]] == 0) {
            a->d_columns_int[columnNames[i]] = thrust::device_vector<int_type>();
            a->h_columns_int[columnNames[i]] = thrust::host_vector<int_type, uninitialized_host_allocator<int_type> >();
        }
        else if(a->type[columnNames[i]] == 1) {
            a->d_columns_float[columnNames[i]] = thrust::device_vector<float_type>();
            a->h_columns_float[columnNames[i]] = thrust::host_vector<float_type, uninitialized_host_allocator<float_type> >();
        }
        else {
            a->h_columns_char[columnNames[i]] = NULL;
            a->d_columns_char[columnNames[i]] = NULL;
        };
    };
    a->load_file_name = load_file_name;

    a->mRecCount = 0;
    return a;
}


void CudaSet::readSegmentsFromFile(unsigned int segNum, string colname, size_t offset)
{
    string f1 = load_file_name + "." + colname + "." + int_to_string(segNum);;

    if(interactive) { //check if data are in buffers
        if(buffers.find(f1) == buffers.end()) { // add data to buffers
            FILE* f = fopen(f1.c_str(), "rb" );
            if(f == NULL) {
                process_error(3, "Error opening " + string(f1) +" file " );
            };
            fseek(f, 0, SEEK_END);
            long fileSize = ftell(f);
            while(total_buffer_size + fileSize > getTotalSystemMemory() && !buffer_names.empty()) { //free some buffers
                delete [] buffers[buffer_names.front()];
                total_buffer_size = total_buffer_size - buffer_sizes[buffer_names.front()];
                buffer_sizes.erase(buffer_names.front());
                buffers.erase(buffer_names.front());
                buffer_names.pop();
            };
            fseek(f, 0, SEEK_SET);
            char* buff = new char[fileSize];
            fread(buff, fileSize, 1, f);
            fclose(f);
            buffers[f1] = buff;
            buffer_sizes[f1] = fileSize;
            buffer_names.push(f1);
            total_buffer_size = total_buffer_size + fileSize;
            buffer_names.push(f1);
            cout << "added buffer " << f1 << " " << fileSize << endl;
        };
        // get data from buffers
		std::clock_t start2 = std::clock();
        if(type[colname] == 0) {
            unsigned int cnt = ((unsigned int*)buffers[f1])[0];
            if(cnt > h_columns_int[colname].size()/8 + 10)
                h_columns_int[colname].resize(cnt/8 + 10);			
            //memcpy(h_columns_int[colname].data(), buffers[f1], cnt+56);
        }
        else if(type[colname] == 1) {
            unsigned int cnt = ((unsigned int*)buffers[f1])[0];
            if(cnt > h_columns_float[colname].size()/8 + 10)
                h_columns_float[colname].resize(cnt/8 + 10);
            //memcpy(h_columns_float[colname].data(), buffers[f1], cnt+56);
        }
        else {
            decompress_char(NULL, colname, segNum, offset, buffers[f1]);
        };
    }
    else {

        FILE* f = fopen(f1.c_str(), "rb" );
        if(f == NULL) {
            cout << "Error opening " << f1 << " file " << endl;
            exit(0);
        };
	
        if(type[colname] == 0) {
            if(1 > h_columns_int[colname].size())
                h_columns_int[colname].resize(1);
            fread(h_columns_int[colname].data(), 4, 1, f);
            unsigned int cnt = ((unsigned int*)(h_columns_int[colname].data()))[0];
            if(cnt > h_columns_int[colname].size()/8 + 10)
                h_columns_int[colname].resize(cnt/8 + 10);
            size_t rr = fread((unsigned int*)(h_columns_int[colname].data()) + 1, 1, cnt+52, f);
            if(rr != cnt+52) {
                char buf[1024];
                sprintf(buf, "Couldn't read %d bytes from %s ,read only", cnt+52, f1.c_str());
                process_error(3, string(buf));
            };
        }
        else if(type[colname] == 1) {
            if(1 > h_columns_float[colname].size())
                h_columns_float[colname].resize(1);
            fread(h_columns_float[colname].data(), 4, 1, f);
            unsigned int cnt = ((unsigned int*)(h_columns_float[colname].data()))[0];
            if(cnt > h_columns_float[colname].size()/8 + 10)
                h_columns_float[colname].resize(cnt/8 + 10);
            size_t rr = fread((unsigned int*)(h_columns_float[colname].data()) + 1, 1, cnt+52, f);
            if(rr != cnt+52) {
                char buf[1024];
                sprintf(buf, "Couldn't read %d bytes from %s ,read only", cnt+52, f1.c_str());
                process_error(3, string(buf));
            };
        }
        else {
            decompress_char(f, colname, segNum, offset, NULL);
        };
        fclose(f);
    };
};


void CudaSet::decompress_char(FILE* f, string colname, unsigned int segNum, size_t offset, char* mem)
{
    unsigned int bits_encoded, fit_count, sz, vals_count, real_count;
    const unsigned int len = char_size[colname];

    if(mem == NULL)
        fread(&sz, 4, 1, f);
    else
        sz = ((unsigned int*)mem)[0];

    size_t a_sz = (size_t)sz*(size_t)len;
    char* d_array = new char[a_sz];
    if(mem == NULL)
        fread((void*)d_array, a_sz, 1, f);
    else
        memcpy(d_array, ((unsigned int*)mem + 1), a_sz);
	
    void* d;
    cudaMalloc((void **) &d, a_sz);

    cudaMemcpy( d, (void *) d_array, a_sz, cudaMemcpyHostToDevice);
    delete[] d_array;

    if(mem == NULL) {
        fread(&fit_count, 4, 1, f);
        fread(&bits_encoded, 4, 1, f);
        fread(&vals_count, 4, 1, f);
        fread(&real_count, 4, 1, f);
    }
    else {
        fit_count = ((unsigned int*)(&mem[4+a_sz]))[0];
        bits_encoded = ((unsigned int*)(&mem[4+a_sz]))[1];
        vals_count = ((unsigned int*)(&mem[4+a_sz]))[2];
        real_count = ((unsigned int*)(&mem[4+a_sz]))[3];
    };
	
	//cout << "DECOMP " << colname << " " << fit_count << " " << bits_encoded << " " << vals_count << " " << real_count << endl;

    thrust::device_ptr<unsigned int> param = thrust::device_malloc<unsigned int>(2);
    param[1] = fit_count;
    param[0] = bits_encoded;

    unsigned long long int* int_array = new unsigned long long int[vals_count];
    if(mem == NULL) {
        fread((void*)int_array, 1, vals_count*8, f);
    }
    else {
        memcpy(int_array, &mem[4+sz*len+16], vals_count*8);
    };
	

    void* d_val;
    cudaMalloc((void **) &d_val, vals_count*8);
    cudaMemcpy(d_val, (void *) int_array, vals_count*8, cudaMemcpyHostToDevice);
    delete[] int_array;

    void* d_int;
    cudaMalloc((void **) &d_int, real_count*4);

    thrust::counting_iterator<unsigned int> begin(0);
    decompress_functor_str ff((unsigned long long int*)d_val,(unsigned int*)d_int, (unsigned int*)thrust::raw_pointer_cast(param));
    thrust::for_each(begin, begin + real_count, ff);

    thrust::device_ptr<unsigned int> d_int2((unsigned int*)d_int);
    d_columns_int[colname].resize(real_count);
    thrust::copy(d_int2, d_int2+real_count, d_columns_int[colname].begin());

    if(!alloced_switch)
        str_gather(d_int, real_count, d, d_columns_char[colname] + offset*len, len);
    else
        str_gather(d_int, real_count, d, alloced_tmp, len);

    mRecCount = real_count;

    cudaFree(d);
    cudaFree(d_val);
    thrust::device_free(param);
    cudaFree(d_int);
}



void CudaSet::CopyColumnToGpu(string colname,  unsigned int segment, size_t offset)
{

    if(not_compressed) 	{
        // calculate how many records we need to copy
        if(segment < segCount-1) {
            mRecCount = maxRecs;
        }
        else {
            mRecCount = hostRecCount - maxRecs*(segCount-1);
        };

        switch(type[colname]) {
        case 0 :
            if(!alloced_switch)
                thrust::copy(h_columns_int[colname].begin() + maxRecs*segment, h_columns_int[colname].begin() + maxRecs*segment + mRecCount, d_columns_int[colname].begin() + offset);
            else {
                thrust::device_ptr<int_type> d_col((int_type*)alloced_tmp);
                thrust::copy(h_columns_int[colname].begin() + maxRecs*segment, h_columns_int[colname].begin() + maxRecs*segment + mRecCount, d_col);
            };
            break;
        case 1 :
            if(!alloced_switch) {
                thrust::copy(h_columns_float[colname].begin() + maxRecs*segment, h_columns_float[colname].begin() + maxRecs*segment + mRecCount, d_columns_float[colname].begin() + offset);
            }
            else {
                thrust::device_ptr<float_type> d_col((float_type*)alloced_tmp);
                thrust::copy(h_columns_float[colname].begin() + maxRecs*segment, h_columns_float[colname].begin() + maxRecs*segment + mRecCount, d_col);
            };
            break;
        default :
            if(!alloced_switch) {
                cudaMemcpy(d_columns_char[colname] + char_size[colname]*offset, h_columns_char[colname] + maxRecs*segment*char_size[colname], char_size[colname]*mRecCount, cudaMemcpyHostToDevice);
            }
            else
                cudaMemcpy(alloced_tmp , h_columns_char[colname] + maxRecs*segment*char_size[colname], char_size[colname]*mRecCount, cudaMemcpyHostToDevice);
        };
    }
    else {

        readSegmentsFromFile(segment,colname, offset);

        if(type[colname] != 2) {
            if(d_v == NULL)
                CUDA_SAFE_CALL(cudaMalloc((void **) &d_v, 12));
            if(s_v == NULL)
                CUDA_SAFE_CALL(cudaMalloc((void **) &s_v, 8));
        };

		string f1 = load_file_name + "." + colname + "." + int_to_string(segment);
        if(type[colname] == 0) {						
            if(!alloced_switch) {			
				if(buffers.find(f1) == buffers.end()) {
					mRecCount = pfor_decompress(thrust::raw_pointer_cast(d_columns_int[colname].data() + offset), h_columns_int[colname].data(), d_v, s_v);
				}
				else {
					mRecCount = pfor_decompress(thrust::raw_pointer_cast(d_columns_int[colname].data() + offset), buffers[f1], d_v, s_v);
				};
            }
            else {
				if(buffers.find(f1) == buffers.end()) {
					mRecCount = pfor_decompress(alloced_tmp, h_columns_int[colname].data(), d_v, s_v);
				}
				else {
					mRecCount = pfor_decompress(alloced_tmp, buffers[f1], d_v, s_v);
				};	
            };
        }
        else if(type[colname] == 1) {
            if(decimal[colname]) {
                if(!alloced_switch) {
					if(buffers.find(f1) == buffers.end()) {
						mRecCount = pfor_decompress( thrust::raw_pointer_cast(d_columns_float[colname].data() + offset) , h_columns_float[colname].data(), d_v, s_v);
					}
					else {
						mRecCount = pfor_decompress( thrust::raw_pointer_cast(d_columns_float[colname].data() + offset) , buffers[f1], d_v, s_v);
					};	
                    thrust::device_ptr<long long int> d_col_int((long long int*)thrust::raw_pointer_cast(d_columns_float[colname].data() + offset));
                    thrust::transform(d_col_int,d_col_int+mRecCount,d_columns_float[colname].begin(), long_to_float());
                }
                else {
					if(buffers.find(f1) == buffers.end()) {
						mRecCount = pfor_decompress(alloced_tmp, h_columns_float[colname].data(), d_v, s_v);
					}
					else {
						mRecCount = pfor_decompress(alloced_tmp, buffers[f1], d_v, s_v);
					};	
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



void CudaSet::CopyColumnToGpu(string colname) // copy all segments
{
    if(not_compressed) {
        switch(type[colname]) {
        case 0 :
            thrust::copy(h_columns_int[colname].begin(), h_columns_int[colname].begin() + mRecCount, d_columns_int[colname].begin());
            break;
        case 1 :
            thrust::copy(h_columns_float[colname].begin(), h_columns_float[colname].begin() + mRecCount, d_columns_float[colname].begin());
            break;
        default :
            cudaMemcpy(d_columns_char[colname], h_columns_char[colname], char_size[colname]*mRecCount, cudaMemcpyHostToDevice);
        };
    }
    else {
        size_t totals = 0;
        if(d_v == NULL)
            CUDA_SAFE_CALL(cudaMalloc((void **) &d_v, 12));
        if(s_v == NULL)
            CUDA_SAFE_CALL(cudaMalloc((void **) &s_v, 8));

        size_t cnt = 0;
        for(unsigned int i = 0; i < segCount; i++) {

            readSegmentsFromFile(i,colname, cnt);

            if(type[colname] == 0) {
                mRecCount = pfor_decompress(thrust::raw_pointer_cast(d_columns_int[colname].data() + totals), h_columns_int[colname].data(), d_v, s_v);
            }
            else if(type[colname] == 1) {
                if(decimal[colname]) {
                    mRecCount = pfor_decompress( thrust::raw_pointer_cast(d_columns_float[colname].data() + totals) , h_columns_float[colname].data(), d_v, s_v);
                    thrust::device_ptr<long long int> d_col_int((long long int*)thrust::raw_pointer_cast(d_columns_float[colname].data() + totals));
                    thrust::transform(d_col_int,d_col_int+mRecCount,d_columns_float[colname].begin() + totals, long_to_float());
                }
                // else  uncompressed float
                //cudaMemcpy( d_columns[colIndex], (void *) ((float_type*)h_columns[colIndex] + offset), count*float_size, cudaMemcpyHostToDevice);
                // will have to fix it later so uncompressed data will be written by segments too
            };
            cnt = cnt + mRecCount;

            //totalRecs = totals + mRecCount;
        };

        mRecCount = totals;
    };
}

void CudaSet::CopyColumnToHost(string colname, size_t offset, size_t RecCount)
{

    switch(type[colname]) {
    case 0 :
        thrust::copy(d_columns_int[colname].begin(), d_columns_int[colname].begin() + RecCount, h_columns_int[colname].begin() + offset);
        break;
    case 1 :
        thrust::copy(d_columns_float[colname].begin(), d_columns_float[colname].begin() + RecCount, h_columns_float[colname].begin() + offset);
        break;
    default :
        cudaMemcpy(h_columns_char[colname] + offset*char_size[colname], d_columns_char[colname], char_size[colname]*RecCount, cudaMemcpyDeviceToHost);
    }
}


void CudaSet::CopyColumnToHost(string colname)
{
    CopyColumnToHost(colname, 0, mRecCount);
}

void CudaSet::CopyToHost(size_t offset, size_t count)
{
    for(unsigned int i = 0; i < columnNames.size(); i++) {
        CopyColumnToHost(columnNames[i], offset, count);
    };
}

float_type* CudaSet::get_float_type_by_name(string name)
{
    return thrust::raw_pointer_cast(d_columns_float[name].data());
}

int_type* CudaSet::get_int_by_name(string name)
{
    return thrust::raw_pointer_cast(d_columns_int[name].data());
}

float_type* CudaSet::get_host_float_by_name(string name)
{
    return thrust::raw_pointer_cast(h_columns_float[name].data());
}

int_type* CudaSet::get_host_int_by_name(string name)
{
    return thrust::raw_pointer_cast(h_columns_int[name].data());
}



void CudaSet::GroupBy(stack<string> columnRef)
{
    if(grp)
        cudaFree(grp);

    CUDA_SAFE_CALL(cudaMalloc((void **) &grp, mRecCount * sizeof(bool)));
    thrust::device_ptr<bool> d_grp(grp);

    thrust::sequence(d_grp, d_grp+mRecCount, 0, 0);

    thrust::device_ptr<bool> d_group = thrust::device_malloc<bool>(mRecCount);

    d_group[mRecCount-1] = 1;

    for(int i = 0; i < columnRef.size(); columnRef.pop()) {

        columnGroups.push(columnRef.top()); // save for future references

        if (type[columnRef.top()] == 0) {  // int_type
            thrust::transform(d_columns_int[columnRef.top()].begin(), d_columns_int[columnRef.top()].begin() + mRecCount - 1,
                              d_columns_int[columnRef.top()].begin()+1, d_group, thrust::not_equal_to<int_type>());
        }
        else if (type[columnRef.top()] == 1) {  // float_type
            thrust::transform(d_columns_float[columnRef.top()].begin(), d_columns_float[columnRef.top()].begin() + mRecCount - 1,
                              d_columns_float[columnRef.top()].begin()+1, d_group, f_not_equal_to());
        }
        else  {  // Char
            //str_grp(d_columns_char[type_index[colIndex]], mRecCount, d_group, char_size[type_index[colIndex]]);
            //use int_type

            thrust::transform(d_columns_int[columnRef.top()].begin(), d_columns_int[columnRef.top()].begin() + mRecCount - 1,
                              d_columns_int[columnRef.top()].begin()+1, d_group, thrust::not_equal_to<int_type>());

        };
        thrust::transform(d_group, d_group+mRecCount, d_grp, d_grp, thrust::logical_or<bool>());

    };

    thrust::device_free(d_group);
    grp_count = thrust::count(d_grp, d_grp+mRecCount,1);
};



void CudaSet::addDeviceColumn(int_type* col, string colname, size_t recCount)
{
    if (std::find(columnNames.begin(), columnNames.end(), colname) == columnNames.end()) {
        columnNames.push_back(colname);
        type[colname] = 0;
        d_columns_int[colname] = thrust::device_vector<int_type>(recCount);
        h_columns_int[colname] = thrust::host_vector<int_type, uninitialized_host_allocator<int_type> >();
    }
    else {  // already exists, my need to resize it
        if(d_columns_int[colname].size() < recCount) {
            d_columns_int[colname].resize(recCount);
        };
    };
    // copy data to d columns
    thrust::device_ptr<int_type> d_col((int_type*)col);
    thrust::copy(d_col, d_col+recCount, d_columns_int[colname].begin());
};

void CudaSet::addDeviceColumn(float_type* col, string colname, size_t recCount, bool is_decimal)
{
    if (std::find(columnNames.begin(), columnNames.end(), colname) == columnNames.end()) {
        columnNames.push_back(colname);
        type[colname] = 1;
        d_columns_float[colname] = thrust::device_vector<float_type>(recCount);
        h_columns_float[colname] = thrust::host_vector<float_type, uninitialized_host_allocator<float_type> >();
    }
    else {  // already exists, my need to resize it
        if(d_columns_float[colname].size() < recCount)
            d_columns_float[colname].resize(recCount);
    };

    decimal[colname] = is_decimal;
    thrust::device_ptr<float_type> d_col((float_type*)col);
    thrust::copy(d_col, d_col+recCount, d_columns_float[colname].begin());
};

void CudaSet::compress(string file_name, size_t offset, unsigned int check_type, unsigned int check_val, size_t mCount)
{
    string str(file_name);
    thrust::device_vector<unsigned int> permutation;

    void* d;
    CUDA_SAFE_CALL(cudaMalloc((void **) &d, mCount*float_size));

    total_count = total_count + mCount;
    if (mCount > total_max && op_sort.empty()) {
        total_max = mCount;
    };

    if(!op_sort.empty()) { //sort the segment
        //copy the key columns to device
        queue<string> sf(op_sort);

        permutation.resize(mRecCount);
        thrust::sequence(permutation.begin(), permutation.begin() + mRecCount,0,1);
        unsigned int* raw_ptr = thrust::raw_pointer_cast(permutation.data());
        void* temp;

        CUDA_SAFE_CALL(cudaMalloc((void **) &temp, mRecCount*max_char(this, sf)));

        string sort_type = "ASC";

        while(!sf.empty()) {

            allocColumnOnDevice(sf.front(), maxRecs);
            CopyColumnToGpu(sf.front());

            if (type[sf.front()] == 0)
                update_permutation(d_columns_int[sf.front()], raw_ptr, mRecCount, sort_type, (int_type*)temp);
            else if (type[sf.front()] == 1)
                update_permutation(d_columns_float[sf.front()], raw_ptr, mRecCount, sort_type, (float_type*)temp);
            else {
                update_permutation_char(d_columns_char[sf.front()], raw_ptr, mRecCount, sort_type, (char*)temp, char_size[sf.front()]);
            };
            deAllocColumnOnDevice(sf.front());
            sf.pop();
        };
        cudaFree(temp);
    };

    // here we need to check for partitions and if partition_count > 0 -> create partitions
    if(mCount < partition_count || partition_count == 0)
        partition_count = 1;
    unsigned int partition_recs = mCount/partition_count;

    if(!op_sort.empty()) {
        if(total_max < partition_recs)
            total_max = partition_recs;
    };

    total_segments++;
    unsigned int old_segments = total_segments;
    size_t new_offset;
    for(unsigned int i = 0; i < columnNames.size(); i++) {

        string colname = columnNames[i];

        str = file_name + "." + colname;
        curr_file = str;
        str += "." + int_to_string(total_segments-1);
        new_offset = 0;

        if(!op_sort.empty()) {
            allocColumnOnDevice(colname, maxRecs);
            CopyColumnToGpu(colname);
        };

        if(type[colname] == 0) {
            thrust::device_ptr<int_type> d_col((int_type*)d);
            if(!op_sort.empty()) {
                thrust::gather(permutation.begin(), permutation.end(), d_columns_int[colname].begin(), d_col);

                for(unsigned int p = 0; p < partition_count; p++) {
                    str = file_name + "." + colname;
                    curr_file = str;
                    str += "." + int_to_string(total_segments-1);
                    if (p < partition_count - 1) {
                        pfor_compress( (int_type*)d + new_offset, partition_recs*int_size, str, h_columns_int[colname], 0);
                    }
                    else {
                        pfor_compress( (int_type*)d + new_offset, (mCount - partition_recs*p)*int_size, str, h_columns_int[colname], 0);
                    };
                    new_offset = new_offset + partition_recs;
                    total_segments++;
                };
            }
            else {
                thrust::copy(h_columns_int[colname].begin() + offset, h_columns_int[colname].begin() + offset + mCount, d_col);
                pfor_compress( d, mCount*int_size, str, h_columns_int[colname], 0);
            };
        }
        else if(type[colname] == 1) {
            if(decimal[colname]) {
                thrust::device_ptr<float_type> d_col((float_type*)d);
                if(!op_sort.empty()) {
                    thrust::gather(permutation.begin(), permutation.end(), d_columns_float[colname].begin(), d_col);
                    thrust::device_ptr<long long int> d_col_dec((long long int*)d);
                    thrust::transform(d_col,d_col+mCount,d_col_dec, float_to_long());

                    for(unsigned int p = 0; p < partition_count; p++) {
                        str = file_name + "." + colname;
                        curr_file = str;
                        str += "." + int_to_string(total_segments-1);
                        if (p < partition_count - 1)
                            pfor_compress( (int_type*)d + new_offset, partition_recs*float_size, str, h_columns_float[colname], 1);
                        else
                            pfor_compress( (int_type*)d + new_offset, (mCount - partition_recs*p)*float_size, str, h_columns_float[colname], 1);
                        new_offset = new_offset + partition_recs;
                        total_segments++;
                    };
                }
                else {
                    thrust::copy(h_columns_float[colname].begin() + offset, h_columns_float[colname].begin() + offset + mCount, d_col);
                    thrust::device_ptr<long long int> d_col_dec((long long int*)d);
                    thrust::transform(d_col,d_col+mCount,d_col_dec, float_to_long());
                    pfor_compress( d, mCount*float_size, str, h_columns_float[colname], 1);
                };
            }
            else { // do not compress -- float
                thrust::device_ptr<float_type> d_col((float_type*)d);
                if(!op_sort.empty()) {
                    thrust::gather(permutation.begin(), permutation.end(), d_columns_float[colname].begin(), d_col);
                    thrust::copy(d_col, d_col+mRecCount, h_columns_float[colname].begin());
                    for(unsigned int p = 0; p < partition_count; p++) {
                        str = file_name + "." + colname;
                        curr_file = str;
                        str += "." + int_to_string(total_segments-1);
                        unsigned int curr_cnt;
                        if (p < partition_count - 1)
                            curr_cnt = partition_recs;
                        else
                            curr_cnt = mCount - partition_recs*p;

                        fstream binary_file(str.c_str(),ios::out|ios::binary|fstream::app);
                        binary_file.write((char *)&curr_cnt, 4);
                        binary_file.write((char *)(h_columns_float[colname].data() + new_offset),curr_cnt*float_size);
                        new_offset = new_offset + partition_recs;
                        unsigned int comp_type = 3;
                        binary_file.write((char *)&comp_type, 4);
                        binary_file.close();
                    };
                }
                else {
                    fstream binary_file(str.c_str(),ios::out|ios::binary|fstream::app);
                    binary_file.write((char *)&mCount, 4);
                    binary_file.write((char *)(h_columns_float[colname].data() + offset),mCount*float_size);
                    unsigned int comp_type = 3;
                    binary_file.write((char *)&comp_type, 4);
                    binary_file.close();
                };
            };
        }
        else { //char
            if(!op_sort.empty()) {
                unsigned int*  h_permutation = new unsigned int[mRecCount];
                thrust::copy(permutation.begin(), permutation.end(), h_permutation);
                char* t = new char[char_size[colname]*mRecCount];
                apply_permutation_char_host(h_columns_char[colname], h_permutation, mRecCount, t, char_size[colname]);
				
                delete [] h_permutation;
                thrust::copy(t, t+ char_size[colname]*mRecCount, h_columns_char[colname]);
                delete [] t;
                for(unsigned int p = 0; p < partition_count; p++) {
                    str = file_name + "." + colname;
                    curr_file = str;
                    str += "." + int_to_string(total_segments-1);

                    if (p < partition_count - 1)
                        compress_char(str, colname, partition_recs, new_offset);
                    else
                        compress_char(str, colname, mCount - partition_recs*p, new_offset);
                    new_offset = new_offset + partition_recs;
                    total_segments++;
                };
            }
            else {
                compress_char(str, colname, mCount, offset);
            };
        };
		
		deAllocColumnOnDevice(colname);


        if((check_type == 1 && fact_file_loaded) || (check_type == 1 && check_val == 0)) {
            if(!op_sort.empty())
                writeHeader(file_name, colname, total_segments-1);
            else {
                writeHeader(file_name, colname, total_segments);
            };
        };

        total_segments = old_segments;
    };
    cudaFree(d);

    if(!op_sort.empty()) {
        total_segments = (old_segments-1)+partition_count;
    };
    permutation.resize(0);
    permutation.shrink_to_fit();
}


void CudaSet::writeHeader(string file_name, string colname, unsigned int tot_segs) {
    string str = file_name + "." + colname;
    string ff = str;
    str += ".header";

    fstream binary_file(str.c_str(),ios::out|ios::binary|ios::trunc);
    binary_file.write((char *)&total_count, 8);
    binary_file.write((char *)&tot_segs, 4);
    binary_file.write((char *)&total_max, 4);
    binary_file.write((char *)&cnt_counts[ff], 4);
    binary_file.close();
};

void CudaSet::reWriteHeader(string file_name, string colname, unsigned int tot_segs, size_t newRecs, size_t maxRecs1) {
    string str = file_name + "." + colname;
    string ff = str;
    str += ".header";
    fstream binary_file(str.c_str(),ios::out|ios::binary|ios::trunc);
    binary_file.write((char *)&newRecs, 8);
    binary_file.write((char *)&tot_segs, 4);
    binary_file.write((char *)&maxRecs1, 4);
    binary_file.close();
};



void CudaSet::writeSortHeader(string file_name)
{
    string str(file_name);
    unsigned int idx;

    if(!op_sort.empty()) {
        str += ".sort";
        fstream binary_file(str.c_str(),ios::out|ios::binary|ios::trunc);
        idx = (unsigned int)op_sort.size();
        binary_file.write((char *)&idx, 4);
        queue<string> os(op_sort);
        while(!os.empty()) {
            //idx = cols[columnNames[os.front()]];
            if(verbose)
                cout << "sorted on " << idx << endl;
            idx = os.front().size();
            binary_file.write((char *)&idx, 4);
            binary_file.write(os.front().data(), idx);
            os.pop();
        };
        binary_file.close();
    }
    else if(!op_presort.empty()) {
        str += ".presort";
        fstream binary_file(str.c_str(),ios::out|ios::binary|ios::trunc);
        idx = (unsigned int)op_presort.size();
        binary_file.write((char *)&idx, 4);
        queue<string> os(op_presort);
        while(!os.empty()) {
            //idx = cols[columnNames[os.front()]];
            idx = os.front().size();
            binary_file.write((char *)&idx, 4);
            binary_file.write(os.front().data(), idx);
            os.pop();
        };
        binary_file.close();
    };
}

using namespace mgpu;

void CudaSet::Display(unsigned int limit, bool binary, bool term)
{
#define MAXCOLS 128
#define MAXFIELDSIZE 128

    //-- This should/will be converted to an array holding pointers of malloced sized structures--
    char    bigbuf[MAXCOLS * MAXFIELDSIZE];
    char    *fields[MAXCOLS];
    const   char *dcolumns[MAXCOLS];
    size_t  mCount;         // num records in play
    bool    print_all = 0;
    string  ss;
    int rows = 0;

    if(limit != 0 && limit < mRecCount)
        mCount = limit;
    else {
        mCount = mRecCount;
        print_all = 1;
    };

    cout << "mRecCount=" << mRecCount << " mcount = " << mCount << " term " << term <<  " limit=" << limit << " print_all=" << print_all << endl;

    //map<unsigned int, string> ordered_columnNames;
    //for (map<string,unsigned int>::iterator it=columnNames.begin() ; it != columnNames.end(); ++it )
    //        ordered_columnNames[it->second] = it->first;

    unsigned int cc =0;
    //for (map<unsigned int, string>::iterator it=ordered_columnNames.begin() ; it != ordered_columnNames.end(); ++it )
    for(unsigned int i = 0; i < columnNames.size(); i++)
    {
        fields[cc] = &(bigbuf[cc*MAXFIELDSIZE]);                        // a hack to avoid malloc overheads     - refine later
        //dcolumns[cc++] = it->second.c_str();
        dcolumns[cc++] = columnNames[i].c_str();
    }

    // The goal here is to loop fast and avoid any double handling of outgoing data - pointers are good.
    if(not_compressed && prm_d.size() == 0) {
        for(unsigned int i=0; i < mCount; i++) {                            // for each record
            for(unsigned int j=0; j < columnNames.size(); j++) {                // for each col
                if (type[columnNames[j]] == 0)
                    sprintf(fields[j], "%lld", (h_columns_int[columnNames[j]])[i] );
                else if (type[columnNames[j]] == 1)
                    sprintf(fields[j], "%.2f", (h_columns_float[columnNames[j]])[i] );
                else {
                    strncpy(fields[j], h_columns_char[columnNames[j]] + (i*char_size[columnNames[j]]), char_size[columnNames[j]]);
                    //ss.assign(h_columns_char[type_index[j]] + (i*char_size[type_index[j]]), char_size[type_index[j]]);
                    //fields[j] = (char *) ss.c_str();
                };
            };
            row_cb(mColumnCount, (char **)fields, (char **)dcolumns);
            rows++;
        };
    }
    else {
        queue<string> op_vx;
        //for (map<string,unsigned int>::iterator it=columnNames.begin() ; it != columnNames.end(); ++it )
        for(unsigned int i = 0; i < columnNames.size(); i++)
            op_vx.push(columnNames[i]);


        if(prm_d.size() || source) {
            allocColumns(this, op_vx);
        };
        unsigned int curr_seg = 0;
        size_t cnt = 0;
        size_t curr_count, sum_printed = 0;
        resize(maxRecs);
        while(sum_printed < mCount || print_all) {

            if(prm_d.size() || source)  {                            // if host arrays are empty
                copyColumns(this, op_vx, curr_seg, cnt);
                size_t olRecs = mRecCount;
                mRecCount = olRecs;
                CopyToHost(0,mRecCount);
                if(sum_printed + mRecCount <= mCount || print_all)
                    curr_count = mRecCount;
                else
                    curr_count = mCount - sum_printed;
            }
            else
                curr_count = mCount;

            sum_printed = sum_printed + mRecCount;
            for(unsigned int i=0; i < curr_count; i++) {
                for(unsigned int j=0; j < columnNames.size(); j++) {
                    if (type[columnNames[j]] == 0)
                        sprintf(fields[j], "%lld", (h_columns_int[columnNames[j]])[i] );
                    else if (type[columnNames[j]] == 1)
                        sprintf(fields[j], "%.2f", (h_columns_float[columnNames[j]])[i] );
                    else {
                        ss.assign(h_columns_char[columnNames[j]] + (i*char_size[columnNames[j]]), char_size[columnNames[j]]);
                        fields[j] = (char *) ss.c_str();
                    };
                };
                row_cb(mColumnCount, (char **)fields, (char**)dcolumns);
                rows++;
            };
            curr_seg++;
            if(curr_seg == segCount)
                print_all = 0;
        };
    };      // end else
}

void CudaSet::Store(string file_name, char* sep, unsigned int limit, bool binary, bool term)
{
    if (mRecCount == 0 && binary == 1 && !term) { // write tails
        for(unsigned int j=0; j < columnNames.size(); j++) {
            writeHeader(file_name, columnNames[j], total_segments);
        };
        return;
    };

    size_t mCount;
    bool print_all = 0;

    if(limit != 0 && limit < mRecCount)
        mCount = limit;
    else {
        mCount = mRecCount;
        print_all = 1;
    };
    //cout << "mCount " << mCount << " " << mRecCount << endl;

    if(binary == 0) {

        FILE *file_pr;
        if(!term) {
            file_pr = fopen(file_name.c_str(), "w");
            if (file_pr  == NULL)
                cout << "Could not open file " << file_name << endl;
        }
        else
            file_pr = stdout;

        string ss;

        if(not_compressed && prm_d.size() == 0) {
            for(unsigned int i=0; i < mCount; i++) {
                for(unsigned int j=0; j < columnNames.size(); j++) {
                    if (type[columnNames[j]] == 0) {
                        fprintf(file_pr, "%lld", (h_columns_int[columnNames[j]])[i]);
                        fputs(sep, file_pr);
                    }
                    else if (type[columnNames[j]] == 1) {
                        fprintf(file_pr, "%.2f", (h_columns_float[columnNames[j]])[i]);
                        fputs(sep, file_pr);
                    }
                    else {
                        ss.assign(h_columns_char[columnNames[j]] + (i*char_size[columnNames[j]]), char_size[columnNames[j]]);
                        fputs(ss.c_str(), file_pr);
                        fputs(sep, file_pr);
                    };
                };
                if (i != mCount -1 )
                    fputs("\n",file_pr);
            };
            if(!term)
                fclose(file_pr);
        }
        else {

            queue<string> op_vx;
            for(unsigned int j=0; j < columnNames.size(); j++)
                op_vx.push(columnNames[j]);

            if(prm_d.size() || source) {
                allocColumns(this, op_vx);
            };

            unsigned int curr_seg = 0;
            size_t cnt = 0;
            size_t curr_count, sum_printed = 0;
            mRecCount = 0;
            resize(maxRecs);

            while(sum_printed < mCount || print_all) {

                if(prm_d.size() || source)  {
                    copyColumns(this, op_vx, curr_seg, cnt);
                    if(curr_seg == 0) {
                        if(limit != 0 && limit < mRecCount) {
                            mCount = limit;
                            print_all = 0;
                        }
                        else {
                            mCount = mRecCount;
                            print_all = 1;
                        };

                    };

                    // if host arrays are empty
                    size_t olRecs = mRecCount;
                    mRecCount = olRecs;
                    CopyToHost(0,mRecCount);
                    //cout << "start " << sum_printed << " " <<  mRecCount << " " <<  mCount << endl;
                    if(sum_printed + mRecCount <= mCount || print_all) {
                        curr_count = mRecCount;
                    }
                    else {
                        curr_count = mCount - sum_printed;
                    };
                }
                else {
                    curr_count = mCount;
                };

                sum_printed = sum_printed + mRecCount;
                //cout << "sum printed " << sum_printed << " " << curr_count << " " << curr_seg << endl;

                for(unsigned int i=0; i < curr_count; i++) {
                    for(unsigned int j=0; j < columnNames.size(); j++) {
                        if (type[columnNames[j]] == 0) {
                            fprintf(file_pr, "%lld", (h_columns_int[columnNames[j]])[i]);
                            fputs(sep, file_pr);
                        }
                        else if (type[columnNames[j]] == 1) {
                            fprintf(file_pr, "%.2f", (h_columns_float[columnNames[j]])[i]);
                            fputs(sep, file_pr);
                        }
                        else {
                            ss.assign(h_columns_char[columnNames[j]] + (i*char_size[columnNames[j]]), char_size[columnNames[j]]);
                            trim(ss);
                            fputs(ss.c_str(), file_pr);
                            fputs(sep, file_pr);
                        };
                    };
                    if (i != mCount -1 && (curr_seg != segCount || i < curr_count))
                        fputs("\n",file_pr);
                };
                curr_seg++;
                if(curr_seg == segCount)
                    print_all = 0;
            };
            if(!term) {
                fclose(file_pr);
            };
        };
    }
    else {

        //lets update the data dictionary
        for(unsigned int j=0; j < columnNames.size(); j++) {

            if(decimal[columnNames[j]] == 1)
                data_dict[file_name][columnNames[j]].col_type = 3;
            else
                data_dict[file_name][columnNames[j]].col_type = type[columnNames[j]];
            if(type[columnNames[j]] != 2)
                data_dict[file_name][columnNames[j]].col_length = 0;
            else
                data_dict[file_name][columnNames[j]].col_length = char_size[columnNames[j]];
        };
        save_dict = 1;


        if(text_source) {  //writing a binary file using a text file as a source

            // time to perform join checks on REFERENCES dataset segments
            //for(unsigned int i = 0; i< mColumnCount; i++) {

            for(unsigned int i=0; i < columnNames.size(); i++) {

                if(ref_sets.find(columnNames[i]) != ref_sets.end()) {

                    string f1 = file_name + "." + columnNames[i] + ".refs";
                    fstream f_file;
                    if(total_segments == 0) {
                        f_file.open(f1.c_str(), ios::out|ios::trunc|ios::binary);
                        unsigned int len = ref_sets[columnNames[i]].size();
                        f_file.write((char *)&len, 4);
                        f_file.write(ref_sets[columnNames[i]].c_str(), len);
                        len = ref_cols[columnNames[i]].size();
                        f_file.write((char *)&len, 4);
                        f_file.write(ref_cols[columnNames[i]].c_str(), len);
                    }
                    else {
                        f_file.open(f1.c_str(), ios::out|ios::app|ios::binary);
                    };

                    f1 = ref_sets[columnNames[i]] + "." + ref_cols[columnNames[i]] + ".header";
                    FILE* ff = fopen(f1.c_str(), "rb");
                    if(ff == NULL) {
                        process_error(3, "Couldn't open file " + string(f1));
                    };
                    unsigned int ref_segCount, ref_maxRecs;
                    fread((char *)&ref_segCount, 4, 1, ff);
                    fread((char *)&ref_segCount, 4, 1, ff);
                    fread((char *)&ref_segCount, 4, 1, ff);
                    fread((char *)&ref_maxRecs, 4, 1, ff);
                    fclose(ff);
                    //cout << "CALC " << i << " " << columnNames[i] << " " << ref_sets[columnNames[i]] << " " << ref_cols[columnNames[i]] << " " << ref_segCount << " " << ref_maxRecs << endl;

                    CudaSet* a = new CudaSet(maxRecs, 1);
                    a->h_columns_int[ref_cols[columnNames[i]]] = thrust::host_vector<int_type, pinned_allocator<int_type> >();
                    a->d_columns_int[ref_cols[columnNames[i]]] = thrust::device_vector<int_type>(ref_maxRecs);
                    a->type[ref_cols[columnNames[i]]] = 0;
                    a->not_compressed = 0;
                    a->load_file_name = ref_sets[columnNames[i]];
                    a->cols[ref_cols[columnNames[i]]] = 1;
                    a->columnNames.push_back(ref_cols[columnNames[i]]);
                    MGPU_MEM(int) aIndicesDevice, bIndicesDevice;
                    size_t res_count;

                    if(!onDevice(columnNames[i])) {
                        allocColumnOnDevice(columnNames[i], maxRecs);
                    };
                    CopyColumnToGpu(columnNames[i]);
                    thrust::sort(d_columns_int[columnNames[i]].begin(), d_columns_int[columnNames[i]].begin() + mRecCount);

                    f_file.write((char *)&total_segments, 4);
                    f_file.write((char *)&ref_segCount, 4);
                    for(unsigned int z = 0; z < ref_segCount; z++) {

                        a->CopyColumnToGpu(ref_cols[columnNames[i]], z, 0);
                        thrust::sort(a->d_columns_int[ref_cols[columnNames[i]]].begin(), a->d_columns_int[ref_cols[columnNames[i]]].begin() + a->mRecCount);
                        // check if there is a join result
                        //cout << "join " << mRecCount << " " << a->mRecCount << " " << getFreeMem() << endl;
                        //cout << d_columns_int[columnNames[i]][0] << " " <<  d_columns_int[columnNames[i]][mRecCount-1] << " " << a->d_columns_int[ref_cols[columnNames[i]]][a->mRecCount-1]	<< " " <<  a->d_columns_int[ref_cols[columnNames[i]]][0] << endl;
                        if(d_columns_int[columnNames[i]][0] > a->d_columns_int[ref_cols[columnNames[i]]][a->mRecCount-1]	||
                                d_columns_int[columnNames[i]][mRecCount-1] < a->d_columns_int[ref_cols[columnNames[i]]][0]) {
                            res_count = 0;
                        }
                        else {
                            res_count = RelationalJoin<MgpuJoinKindInner>(thrust::raw_pointer_cast(d_columns_int[columnNames[i]].data()), mRecCount,
                                        thrust::raw_pointer_cast(a->d_columns_int[ref_cols[columnNames[i]]].data()), a->mRecCount,
                                        &aIndicesDevice, &bIndicesDevice,
                                        mgpu::less<int_type>(), *context);
                        };
                        //cout << "RES " << i << " " << total_segments << ":" << z << " " << res_count << endl;
                        f_file.write((char *)&z, 4);
                        f_file.write((char *)&res_count, 8);
                    };
                    f_file.close();
                    a->deAllocColumnOnDevice(ref_cols[columnNames[i]]);
                    a->free();
                };
            };
            compress(file_name, 0, 1, 0, mCount);
            for(unsigned int i = 0; i< columnNames.size(); i++)
                if(type[columnNames[i]] == 2)
                    deAllocColumnOnDevice(columnNames[i]);
        }
        else { //writing a binary file using a binary file as a source
            fact_file_loaded = 1;
            size_t offset = 0;

            if(!not_compressed) { // records are compressed, for example after filter op.
                //decompress to host
                queue<string> op_vx;
                for(unsigned int i = 0; i< columnNames.size(); i++) {
                    op_vx.push(columnNames[i]);
                };

                allocColumns(this, op_vx);
                size_t oldCnt = mRecCount;
                mRecCount = 0;
                resize(oldCnt);
                mRecCount = oldCnt;
                for(unsigned int i = 0; i < segCount; i++) {
                    size_t cnt = 0;
                    copyColumns(this, op_vx, i, cnt);
                    CopyToHost(0, mRecCount);
                    offset = offset + mRecCount;
                    compress(file_name, 0, 0, i - (segCount-1), mRecCount);
                };
            }
            else {
                // now we have decompressed records on the host
                //call setSegments and compress columns in every segment

                segCount = (mRecCount/process_count + 1);
                offset = 0;

                for(unsigned int z = 0; z < segCount; z++) {

                    if(z < segCount-1) {
                        if(mRecCount < process_count) {
                            mCount = mRecCount;
                        }
                        else {
                            mCount = process_count;
                        }
                    }
                    else {
                        mCount = mRecCount - (segCount-1)*process_count;
                    };
                    compress(file_name, offset, 0, z - (segCount-1), mCount);
                    offset = offset + mCount;
                };
            };
        };
    };
}


void CudaSet::compress_char(string file_name, string colname, size_t mCount, size_t offset)
{
    std::map<string,unsigned int> dict;
    std::vector<string> dict_ordered;
    std::vector<unsigned int> dict_val;
    map<string,unsigned int>::iterator iter;
    unsigned int bits_encoded, ss;
    unsigned int len = char_size[colname];


    for (unsigned int i = 0 ; i < mCount; i++) {

        string f(h_columns_char[colname] + (i+offset)*len, len);
        if((iter = dict.find(f)) != dict.end()) {
            dict_val.push_back(iter->second);
        }
        else {
            ss = (unsigned int)dict.size();
            dict[f] = ss;
            dict_val.push_back(ss);
            dict_ordered.push_back(f);
        };
    };

    bits_encoded = (unsigned int)ceil(log2(double(dict.size()+1)));
	//cout << "bits " << bits_encoded << endl;

    char *cc = new char[len+1];
    cc[len] = 0;
    unsigned int sz = (unsigned int)dict_ordered.size();
    // write to a file
    fstream binary_file(file_name.c_str(),ios::out|ios::binary|ios::trunc);
    binary_file.write((char *)&sz, 4);	
    for(unsigned int i = 0; i < sz; i++) {
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
    unsigned int vals_count = (unsigned int)dict_val.size()/fit_count;
    if(!vals_count || dict_val.size()%fit_count)
        vals_count++;
    binary_file.write((char *)&vals_count, 4);
    unsigned int real_count = (unsigned int)dict_val.size();
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



bool CudaSet::LoadBigFile(FILE* file_p)
{
    char line[1000];
    unsigned int current_column, count = 0;
    string colname;
    char *p,*t;
    const char* sep = separator.c_str();


    unsigned int maxx = 0;
    for(unsigned int i = 0; i < mColumnCount; i++) {
        if(cols[columnNames[i]] > maxx)
            maxx = cols[columnNames[i]];
    };

    bool *check_col = new bool[maxx+1];
    vector<string> names(maxx+1);

    for(unsigned int i = 0; i <= maxx; i++) {
        check_col[i] = 0;
    };

    for(unsigned int i = 0; i < mColumnCount; i++) {
        names[cols[columnNames[i]]] = columnNames[i];
        check_col[cols[columnNames[i]]] = 1;
    };
	
	//clear the varchars
	
	//for(auto it=columnNames.begin(); it!=columnNames.end();it++) {
	for(unsigned int i = 0; i < mColumnCount; i++) {
		if(type[columnNames[i]] == 2) {			
			memset(h_columns_char[columnNames[i]], 0, maxRecs*char_size[columnNames[i]]);
		};
	};


    //while (count < process_count && fgets(line, 1000, file_p) != NULL) {
    while (count < process_count && fgets(line, 1000, file_p) != NULL) {
        strtok(line, "\n");
        current_column = 0;

        for(t=mystrtok(&p,line,*sep); t && current_column < maxx; t=mystrtok(&p,0,*sep)) {
            current_column++;
            if(!check_col[current_column]) {
                //cout << "Didn't find " << current_column << endl;
                continue;
            };
            //cout << "curr " << current_column << " " << names[current_column] << endl;

            if (type[names[current_column]] == 0) {
                if (strchr(t,'-') == NULL) {
                    (h_columns_int[names[current_column]])[count] = atoll(t);
                }
                else {   // handling possible dates
                    strncpy(t+4,t+5,2);
                    strncpy(t+6,t+8,2);
                    t[8] = '\0';
                    (h_columns_int[names[current_column]])[count] = atoll(t);
                };
            }
            else if (type[names[current_column]] == 1) {
                (h_columns_float[names[current_column]])[count] = atoff(t);
            }
            else  {//char
                strcpy(h_columns_char[names[current_column]] + count*char_size[names[current_column]], t);
            }
        };
        count++;
    };

    delete [] check_col;
    mRecCount = count;

    if(count < process_count)  {
        fclose(file_p);
        return 1;
    }
    else
        return 0;
};


void CudaSet::free()  {

    for(unsigned int i = 0; i < columnNames.size(); i++ ) {
        if(type[columnNames[i]] == 2 && h_columns_char[columnNames[i]]) {
            delete [] h_columns_char[columnNames[i]];
            h_columns_char[columnNames[i]] = NULL;
        }
        else {
            if(type[columnNames[i]] == 0 ) {
                h_columns_int[columnNames[i]].resize(0);
                h_columns_int[columnNames[i]].shrink_to_fit();
            }
            else if(type[columnNames[i]] == 1) {
                h_columns_float[columnNames[i]].resize(0);
                h_columns_float[columnNames[i]].shrink_to_fit();
            };
        }
    };

    prm_d.resize(0);
    prm_d.shrink_to_fit();
    deAllocOnDevice();

    if(fil_s)
        delete fil_s;
    if(fil_f)
        delete fil_f;

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
    else  // !=
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





void CudaSet::initialize(queue<string> &nameRef, queue<string> &typeRef, queue<int> &sizeRef, queue<int> &colsRef, size_t Recs, string file_name) // compressed data for DIM tables
{
    mColumnCount = (unsigned int)nameRef.size();
    FILE* f;
    string f1;
    unsigned int cnt;
    char buffer[4000];
    string str;
    prealloc_char_size = 0;
    not_compressed = 0;
    mRecCount = Recs;
    hostRecCount = Recs;
    totalRecs = Recs;
    load_file_name = file_name;

    f1 = file_name + ".sort";
    f = fopen (f1.c_str() , "rb" );
    if(f != NULL) {
        unsigned int sz, idx;
        fread((char *)&sz, 4, 1, f);
        for(unsigned int j = 0; j < sz; j++) {
            fread((char *)&idx, 4, 1, f);
            fread(buffer, idx, 1, f);
            str.assign(buffer, idx);
            sorted_fields.push(str);
            if(verbose)
                cout << "segment sorted on " << idx << endl;
        };
        fclose(f);
    };

    f1 = file_name + ".presort";
    f = fopen (f1.c_str() , "rb" );
    if(f != NULL) {
        unsigned int sz, idx;
        fread((char *)&sz, 4, 1, f);
        for(unsigned int j = 0; j < sz; j++) {
            fread((char *)&idx, 4, 1, f);
            fread(buffer, idx, 1, f);
            str.assign(buffer, idx);
            presorted_fields.push(str);
            if(verbose)
                cout << "presorted on " << str << endl;
        };
        fclose(f);
    };
	
    tmp_table = 0;
    filtered = 0;

    for(unsigned int i=0; i < mColumnCount; i++) {

        //f1 = file_name + "." + nameRef.front() + ".0";
        //f = fopen (f1.c_str() , "rb" );
        //fread((char *)&bytes, 4, 1, f); //need to read metadata such as type and length
        //fclose(f);

        columnNames.push_back(nameRef.front());
        cols[nameRef.front()] = colsRef.front();

        if (((typeRef.front()).compare("decimal") == 0) || ((typeRef.front()).compare("int") == 0)) {
            f1 = file_name + "." + nameRef.front() + ".0";
            f = fopen (f1.c_str() , "rb" );
			if(f == NULL) {
				cout << "Couldn't find field " << nameRef.front() << endl;
				exit(0);
			};
            for(unsigned int j = 0; j < 6; j++)
                fread((char *)&cnt, 4, 1, f);
            fclose(f);
            compTypes[nameRef.front()] = cnt;
        };
		
        //check the references
        f1 = file_name + "." + nameRef.front() + ".refs";
        f = fopen (f1.c_str() , "rb" );
        if(f != NULL) {
            unsigned int len;
            fread(&len, 4, 1, f);
            char* array = new char[len];
            fread((void*)array, len, 1, f);
            ref_sets[nameRef.front()] = array;
            delete [] array;
            unsigned int segs, seg_num, curr_seg;
            size_t res_count;
            fread(&len, 4, 1, f);
            char* array1 = new char[len];
            fread((void*)array1, len, 1, f);
            ref_cols[nameRef.front()] = array1;
            delete [] array1;

            unsigned int bytes_read = fread((void*)&curr_seg, 4, 1, f);

            while(bytes_read == 1) {
                fread((void*)&segs, 4, 1, f); //ref seg count
                //cout << "for " << i << " read " << array << " and " << z << " " << segs << endl;

                for(unsigned int j = 0; j < segs; j++) {
                    fread((void*)&seg_num, 4, 1, f);
                    fread((void*)&res_count, 8, 1, f);
                    //cout << "curr_seg " << curr_seg << " " << seg_num << " " << res_count << endl;
                    if(res_count)
                        ref_joins[columnNames[i]][curr_seg].insert(seg_num);
                    else
                        ref_joins[columnNames[i]][curr_seg].insert(std::numeric_limits<unsigned int>::max());
                };
                bytes_read = fread((void*)&curr_seg, 4, 1, f);
            };
            fclose(f);
        };
		
        if ((typeRef.front()).compare("int") == 0) {
            type[nameRef.front()] = 0;
            decimal[nameRef.front()] = 0;
            h_columns_int[nameRef.front()] = thrust::host_vector<int_type, pinned_allocator<int_type> >();
            d_columns_int[nameRef.front()] = thrust::device_vector<int_type>();
        }
        else if ((typeRef.front()).compare("float") == 0) {
            type[nameRef.front()] = 1;
            decimal[nameRef.front()] = 0;
            h_columns_float[nameRef.front()] = thrust::host_vector<float_type, pinned_allocator<float_type> >();
            d_columns_float[nameRef.front()] = thrust::device_vector<float_type >();
        }
        else if ((typeRef.front()).compare("decimal") == 0) {
            type[nameRef.front()] = 1;
            decimal[nameRef.front()] = 1;
            h_columns_float[nameRef.front()] = thrust::host_vector<float_type, pinned_allocator<float_type> >();
            d_columns_float[nameRef.front()] = thrust::device_vector<float_type>();
        }
        else {
            type[nameRef.front()] = 2;
            decimal[nameRef.front()] = 0;
            h_columns_char[nameRef.front()] = NULL;
            d_columns_char[nameRef.front()] = NULL;
            char_size[nameRef.front()] = sizeRef.front();
        };
		
        nameRef.pop();
        typeRef.pop();
        sizeRef.pop();
        colsRef.pop();
    };
	
};



void CudaSet::initialize(queue<string> &nameRef, queue<string> &typeRef, queue<int> &sizeRef, queue<int> &colsRef, size_t Recs, queue<string> &references, queue<string> &references_names)
{
    mColumnCount = (unsigned int)nameRef.size();
    prealloc_char_size = 0;
    tmp_table = 0;
    filtered = 0;
    mRecCount = Recs;
    hostRecCount = Recs;
    segCount = 1;

    for(unsigned int i=0; i < mColumnCount; i++) {

        columnNames.push_back(nameRef.front());
        cols[nameRef.front()] = colsRef.front();

        if ((typeRef.front()).compare("int") == 0) {
            type[nameRef.front()] = 0;
            decimal[nameRef.front()] = 0;
            h_columns_int[nameRef.front()] = thrust::host_vector<int_type, pinned_allocator<int_type> >();
            d_columns_int[nameRef.front()] = thrust::device_vector<int_type>();
        }
        else if ((typeRef.front()).compare("float") == 0) {
            type[nameRef.front()] = 1;
            decimal[nameRef.front()] = 0;
            h_columns_float[nameRef.front()] = thrust::host_vector<float_type, pinned_allocator<float_type> >();
            d_columns_float[nameRef.front()] = thrust::device_vector<float_type>();
        }
        else if ((typeRef.front()).compare("decimal") == 0) {
            type[nameRef.front()] = 1;
            decimal[nameRef.front()] = 1;
            h_columns_float[nameRef.front()] = thrust::host_vector<float_type, pinned_allocator<float_type> >();
            d_columns_float[nameRef.front()] = thrust::device_vector<float_type>();
        }

        else {
            type[nameRef.front()] = 2;
            decimal[nameRef.front()] = 0;
            h_columns_char[nameRef.front()] = NULL;
            d_columns_char[nameRef.front()] = NULL;
            char_size[nameRef.front()] = sizeRef.front();
        };

        if(!references.front().empty()) {
            ref_sets[nameRef.front()] = references.front();
            ref_cols[nameRef.front()] = references_names.front();
        };
        nameRef.pop();
        typeRef.pop();
        sizeRef.pop();
        colsRef.pop();
        references.pop();
        references_names.pop();
    };
};

void CudaSet::initialize(size_t RecordCount, unsigned int ColumnCount)
{
    mRecCount = RecordCount;
    hostRecCount = RecordCount;
    mColumnCount = ColumnCount;
    prealloc_char_size = 0;
    filtered = 0;
};




void CudaSet::initialize(CudaSet* a, CudaSet* b, queue<string> op_sel, queue<string> op_sel_as)
{
    mRecCount = 0;
    mColumnCount = 0;
	flt = 0;
    queue<string> q_cnt(op_sel);
    unsigned int i = 0;
    set<string> field_names;
    while(!q_cnt.empty()) {
        if( std::find(a->columnNames.begin(), a->columnNames.end(), q_cnt.front()) !=  a->columnNames.end() ||
                std::find(b->columnNames.begin(), b->columnNames.end(), q_cnt.front()) !=  b->columnNames.end())  {
            field_names.insert(q_cnt.front());
        };
        q_cnt.pop();
    }
    mColumnCount = (unsigned int)field_names.size();
    maxRecs = b->maxRecs;
    map<string,unsigned int>::iterator it;

    segCount = 1;
    filtered = 0;
    not_compressed = 1;

    col_aliases = op_sel_as;
    prealloc_char_size = 0;

    i = 0;
    while(!op_sel.empty()) {
	
		if(std::find(columnNames.begin(), columnNames.end(), op_sel.front()) ==  columnNames.end()) {
			if(std::find(a->columnNames.begin(), a->columnNames.end(), op_sel.front()) !=  a->columnNames.end()) {
				cols[op_sel.front()] = i;
				decimal[op_sel.front()] = a->decimal[op_sel.front()];
				columnNames.push_back(op_sel.front());
				type[op_sel.front()] = a->type[op_sel.front()];

				if (a->type[op_sel.front()] == 0)  {
					d_columns_int[op_sel.front()] = thrust::device_vector<int_type>();
					h_columns_int[op_sel.front()] = thrust::host_vector<int_type, pinned_allocator<int_type> >();
				}
				else if (a->type[op_sel.front()] == 1) {
					d_columns_float[op_sel.front()] = thrust::device_vector<float_type>();
					h_columns_float[op_sel.front()] = thrust::host_vector<float_type, pinned_allocator<float_type> >();
				}
				else {
					h_columns_char[op_sel.front()] = NULL;
					d_columns_char[op_sel.front()] = NULL;
					char_size[op_sel.front()] = a->char_size[op_sel.front()];
				};
				i++;
			}
			else if(std::find(b->columnNames.begin(), b->columnNames.end(), op_sel.front()) !=  b->columnNames.end()) {
				columnNames.push_back(op_sel.front());
				cols[op_sel.front()] = i;
				decimal[op_sel.front()] = b->decimal[op_sel.front()];
				type[op_sel.front()] = b->type[op_sel.front()];

				if (b->type[op_sel.front()] == 0) {
					d_columns_int[op_sel.front()] = thrust::device_vector<int_type>();
					h_columns_int[op_sel.front()] = thrust::host_vector<int_type, pinned_allocator<int_type> >();
				}
				else if (b->type[op_sel.front()] == 1) {
					d_columns_float[op_sel.front()] = thrust::device_vector<float_type>();
					h_columns_float[op_sel.front()] = thrust::host_vector<float_type, pinned_allocator<float_type> >();
				}
				else {
					h_columns_char[op_sel.front()] = NULL;
					d_columns_char[op_sel.front()] = NULL;
					char_size[op_sel.front()] = b->char_size[op_sel.front()];
				};
				i++;
			}
		};	
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
    if(a->filtered) {
        size_t max_sz = max_tmp(a);
        CudaSet* t;
        if(a->filtered)
            t = varNames[a->source_name];
        else
            t = a;

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
            if(var_exists(a, fields.front())) {

                bool onDevice = 0;

                if(a->type[fields.front()] == 0) {
                    if(a->d_columns_int[fields.front()].size() > 0) {
                        onDevice = 1;
                    }
                }
                else if(a->type[fields.front()] == 1) {
                    if(a->d_columns_float[fields.front()].size() > 0) {
                        onDevice = 1;
                    };
                }
                else {
                    if((a->d_columns_char[fields.front()]) != NULL) {
                        onDevice = 1;
                    };
                };

                if (!onDevice) {
                    a->allocColumnOnDevice(fields.front(), a->maxRecs);
                }
            }
            fields.pop();
        };
    };
}



void gatherColumns(CudaSet* a, CudaSet* t, string field, unsigned int segment, size_t& count)
{
    if(!a->onDevice(field)) {
        a->allocColumnOnDevice(field, a->maxRecs);
    };

    if(a->prm_index == 'R') {
        mygather(field, a, t, count, a->mRecCount);
    }
    else {
        mycopy(field, a, t, count, t->mRecCount);
        a->mRecCount = t->mRecCount;
    };
}


size_t getSegmentRecCount(CudaSet* a, unsigned int segment) {
    if (segment == a->segCount-1) {
        return a->hostRecCount - a->maxRecs*segment;
    }
    else
        return 	a->maxRecs;
}



void copyColumns(CudaSet* a, queue<string> fields, unsigned int segment, size_t& count, bool rsz, bool flt)
{
    set<string> uniques;

    if(a->filtered) { //filter the segment
        if(flt) {
            filter_op(a->fil_s, a->fil_f, segment);
		};
        if(rsz && a->mRecCount) {
            queue<string> fields1(fields);			
            while(!fields1.empty()) {
                a->resizeDeviceColumn(a->devRecCount + a->mRecCount, fields1.front());			
                fields1.pop();
            };
            a->devRecCount = a->devRecCount + a->mRecCount;
        };
    };
	
    while(!fields.empty()) {
        if (uniques.count(fields.front()) == 0 && var_exists(a, fields.front()))	{
            if(a->filtered) {
                if(a->mRecCount) {		
                    CudaSet *t = varNames[a->source_name];
                    alloced_switch = 1;
                    t->CopyColumnToGpu(fields.front(), segment);
                    gatherColumns(a, t, fields.front(), segment, count);
                    alloced_switch = 0;
                    a->orig_segs[t->load_file_name].insert(segment);
                };
            }
            else {
                if(a->mRecCount) {				
                    a->CopyColumnToGpu(fields.front(), segment, count);
                };
            };
            uniques.insert(fields.front());
        };
        fields.pop();
    };
}



void setPrm(CudaSet* a, CudaSet* b, char val, unsigned int segment) {

    b->prm_index = val;
    if (val == 'A') {
        b->mRecCount = getSegmentRecCount(a,segment);
    }
    else if (val == 'N') {
        b->mRecCount = 0;
    }
}



void mygather(string colname, CudaSet* a, CudaSet* t, size_t offset, size_t g_size)
{
    if(t->type[colname] == 0) {
        if(!alloced_switch) {
            thrust::gather(a->prm_d.begin(), a->prm_d.begin() + g_size,
                           t->d_columns_int[colname].begin(), a->d_columns_int[colname].begin() + offset);
        }
        else {
            thrust::device_ptr<int_type> d_col((int_type*)alloced_tmp);
            thrust::gather(a->prm_d.begin(), a->prm_d.begin() + g_size,
                           d_col, a->d_columns_int[colname].begin() + offset);
        };
    }
    else if(t->type[colname] == 1) {
        if(!alloced_switch) {
            thrust::gather(a->prm_d.begin(), a->prm_d.begin() + g_size,
                           t->d_columns_float[colname].begin(), a->d_columns_float[colname].begin() + offset);
        }
        else {
            thrust::device_ptr<float_type> d_col((float_type*)alloced_tmp);
            thrust::gather(a->prm_d.begin(), a->prm_d.begin() + g_size,
                           d_col, a->d_columns_float[colname].begin() + offset);
        };
    }
    else {
        if(!alloced_switch) {
            str_gather((void*)thrust::raw_pointer_cast(a->prm_d.data()), g_size,
                       (void*)t->d_columns_char[colname], (void*)(a->d_columns_char[colname] + offset*a->char_size[colname]), (unsigned int)a->char_size[colname] );
            thrust::gather(a->prm_d.begin(), a->prm_d.begin() + g_size,
                           t->d_columns_int[colname].begin(), a->d_columns_int[colname].begin() + offset);

        }
        else {
            str_gather((void*)thrust::raw_pointer_cast(a->prm_d.data()), g_size,
                       alloced_tmp, (void*)(a->d_columns_char[colname] + offset*a->char_size[colname]), (unsigned int)a->char_size[colname] );			   
        };
        if(a->d_columns_int.find(colname) != a->d_columns_int.end())
            thrust::gather(a->prm_d.begin(), a->prm_d.begin() + g_size,
                           t->d_columns_int[colname].begin(), a->d_columns_int[colname].begin() + offset);
    }
};

void mycopy(string colname, CudaSet* a, CudaSet* t, size_t offset, size_t g_size)
{
    if(t->type[colname] == 0) {
        if(!alloced_switch) {
            thrust::copy(t->d_columns_int[colname].begin(), t->d_columns_int[colname].begin() + g_size,
                         a->d_columns_int[colname].begin() + offset);
        }
        else {
            thrust::device_ptr<int_type> d_col((int_type*)alloced_tmp);
            thrust::copy(d_col, d_col + g_size, a->d_columns_int[colname].begin() + offset);

        };
    }
    else if(t->type[colname] == 1) {
        if(!alloced_switch) {
            thrust::copy(t->d_columns_float[colname].begin(), t->d_columns_float[colname].begin() + g_size,
                         a->d_columns_float[colname].begin() + offset);
        }
        else {
            thrust::device_ptr<float_type> d_col((float_type*)alloced_tmp);
            thrust::copy(d_col, d_col + g_size,	a->d_columns_float[colname].begin() + offset);
        };
    }
    else {
        if(!alloced_switch) {
            cudaMemcpy((void**)(a->d_columns_char[colname] + offset*a->char_size[colname]), (void**)t->d_columns_char[colname],
                       g_size*t->char_size[colname], cudaMemcpyDeviceToDevice);
            thrust::copy(t->d_columns_int[colname].begin(), t->d_columns_int[colname].begin() + g_size,
                         a->d_columns_int[colname].begin() + offset);
        }
        else {
            cudaMemcpy((void**)(a->d_columns_char[colname] + offset*a->char_size[colname]), alloced_tmp,
                       g_size*t->char_size[colname], cudaMemcpyDeviceToDevice);
        };
        if(a->d_columns_int.find(colname) != a->d_columns_int.end())
            thrust::copy(t->d_columns_int[colname].begin(), t->d_columns_int[colname].begin() + g_size,
                         a->d_columns_int[colname].begin() + offset);

    };
};



size_t load_queue(queue<string> c1, CudaSet* right, bool str_join, string f2, size_t &rcount,
                  unsigned int start_segment, unsigned int end_segment, bool rsz, bool flt)
{
    queue<string> cc;
    while(!c1.empty()) {
        if(std::find(right->columnNames.begin(), right->columnNames.end(), c1.front()) !=  right->columnNames.end()) {
            if(f2 != c1.front() ) {
                cc.push(c1.front());
            };
        };
        c1.pop();
    };
    if(std::find(right->columnNames.begin(), right->columnNames.end(), f2) !=  right->columnNames.end()) {
        cc.push(f2);
    };

    if(right->filtered) {
        allocColumns(right, cc);
    };

    rcount = right->maxRecs;
    queue<string> ct(cc);

    while(!ct.empty()) {
        if(right->filtered && rsz) {
            right->mRecCount = 0;
        }
        else {
            right->allocColumnOnDevice(ct.front(), rcount);
        };
        ct.pop();
    };


    size_t cnt_r = 0;
    right->devRecCount = 0;
    for(unsigned int i = start_segment; i < end_segment; i++) {
        if(!right->filtered)
            copyColumns(right, cc, i, cnt_r, rsz, 0);
        else
            copyColumns(right, cc, i, cnt_r, rsz, flt);
        cnt_r = cnt_r + right->mRecCount;
    };
    right->mRecCount = cnt_r;
    return cnt_r;

}

size_t max_char(CudaSet* a)
{
    size_t max_char1 = 8;
    for(unsigned int i = 0; i < a->columnNames.size(); i++) {
        if(a->type[a->columnNames[i]] == 2) {
            if (a->char_size[a->columnNames[i]] > max_char1)
                max_char1 = a->char_size[a->columnNames[i]];
        };
    };
    return max_char1;
};

size_t max_char(CudaSet* a, set<string> field_names)
{
    size_t max_char1 = 8;
    for (set<string>::iterator it=field_names.begin(); it!=field_names.end(); ++it) {
        if (a->type[*it] == 2) {
            if (a->char_size[*it] > max_char1)
                max_char1 = a->char_size[*it];
        };
    };
    return max_char1;
};

size_t max_char(CudaSet* a, queue<string> field_names)
{
    size_t max_char = 8;
    while (!field_names.empty()) {
        if (a->type[field_names.front()] == 2) {
            if (a->char_size[field_names.front()] > max_char)
                max_char = a->char_size[field_names.front()];
        };
        field_names.pop();
    };
    return max_char;
};



size_t max_tmp(CudaSet* a)
{
    size_t max_sz = 0;
    for(unsigned int i = 0; i < a->columnNames.size(); i++) {
        if(a->type[a->columnNames[i]] == 0) {
            if(int_size > max_sz)
                max_sz = int_size;
        }
        else if(a->type[a->columnNames[i]] == 1) {
            if(float_size > max_sz)
                max_sz = float_size;
        };
    };
    size_t m_char = max_char(a);
    if(m_char > max_sz)
        return m_char;
    else
        return max_sz;

};

size_t maxsz(CudaSet* a)
{
    size_t tot_sz = 0;
    for(unsigned int i = 0; i < a->columnNames.size(); i++) {
        if(a->type[a->columnNames[i]] == 0) {
			tot_sz = tot_sz + int_size;
		}
        else if(a->type[a->columnNames[i]] == 1) {
			tot_sz = tot_sz + float_size;
		}
		else
			tot_sz = tot_sz + a->char_size[a->columnNames[i]];
    };
	return tot_sz;
};	



void setSegments(CudaSet* a, queue<string> cols)
{
    size_t mem_available = getFreeMem();
    size_t tot_sz = 0;
    while(!cols.empty()) {
        if(a->type[cols.front()] != 2)
            tot_sz = tot_sz + int_size;
        else
            tot_sz = tot_sz + a->char_size[cols.front()];
        cols.pop();
    };
    if(a->mRecCount*tot_sz > mem_available/3) { //default is 3
        a->segCount = (a->mRecCount*tot_sz)/(mem_available/5) + 1;
        a->maxRecs = (a->mRecCount/a->segCount)+1;
    };

};

void update_permutation_char(char* key, unsigned int* permutation, size_t RecCount, string SortType, char* tmp, unsigned int len)
{

    str_gather((void*)permutation, RecCount, (void*)key, (void*)tmp, len);

    // stable_sort the permuted keys and update the permutation
    if (SortType.compare("DESC") == 0 )
        str_sort(tmp, RecCount, permutation, 1, len);
    else
        str_sort(tmp, RecCount, permutation, 0, len);
}

void update_permutation_char_host(char* key, unsigned int* permutation, size_t RecCount, string SortType, char* tmp, unsigned int len)
{
    str_gather_host(permutation, RecCount, (void*)key, (void*)tmp, len);

    if (SortType.compare("DESC") == 0 )
        str_sort_host(tmp, RecCount, permutation, 1, len);
    else
        str_sort_host(tmp, RecCount, permutation, 0, len);

}



void apply_permutation_char(char* key, unsigned int* permutation, size_t RecCount, char* tmp, unsigned int len)
{
    // copy keys to temporary vector
    cudaMemcpy( (void*)tmp, (void*) key, RecCount*len, cudaMemcpyDeviceToDevice);
    // permute the keys
    str_gather((void*)permutation, RecCount, (void*)tmp, (void*)key, len);
}


void apply_permutation_char_host(char* key, unsigned int* permutation, size_t RecCount, char* res, unsigned int len)
{
    str_gather_host(permutation, RecCount, (void*)key, (void*)res, len);
}



void filter_op(char *s, char *f, unsigned int segment)
{
    CudaSet *a, *b;

    a = varNames.find(f)->second;
    a->name = f;
    //std::clock_t start1 = std::clock();

    if(a->mRecCount == 0 && !a->filtered) {
        b = new CudaSet(0,1);
    }
    else {
        if(verbose)
            cout << "FILTER " << s << " " << f << " " << getFreeMem() << '\xd';


        b = varNames[s];
        b->name = s;
        size_t cnt = 0;
        allocColumns(a, b->fil_value);

        if (b->prm_d.size() == 0)
            b->prm_d.resize(a->maxRecs);

        //cout << endl << "MAP CHECK start " << segment <<  endl;
        char map_check = zone_map_check(b->fil_type,b->fil_value,b->fil_nums, b->fil_nums_f, a, segment);
        //cout << endl << "MAP CHECK segment " << segment << " " << map_check <<  endl;

        if(map_check == 'R') {
            copyColumns(a, b->fil_value, segment, cnt);
            bool* res = filter(b->fil_type,b->fil_value,b->fil_nums, b->fil_nums_f, a, segment);
            thrust::device_ptr<bool> bp((bool*)res);
            b->prm_index = 'R';
            b->mRecCount = thrust::count(bp, bp + (unsigned int)a->mRecCount, 1);
            thrust::copy_if(thrust::make_counting_iterator((unsigned int)0), thrust::make_counting_iterator((unsigned int)a->mRecCount),
                            bp, b->prm_d.begin(), thrust::identity<bool>());
            cudaFree(res);
        }
        else  {
            setPrm(a,b,map_check,segment);
        };
        if(segment == a->segCount-1)
            a->deAllocOnDevice();
    }
    if(verbose)
        cout << endl << "filter res " << b->mRecCount << endl;
    //std::cout<< "filter time " <<  ( ( std::clock() - start1 ) / (double)CLOCKS_PER_SEC ) << " " << getFreeMem() << '\n';
}




size_t load_right(CudaSet* right, string colname, string f2, queue<string> op_g, queue<string> op_sel,
                  queue<string> op_alt, bool decimal_join, bool& str_join,
                  size_t& rcount, unsigned int start_seg, unsigned int end_seg, bool rsz) {

    size_t cnt_r = 0;
    //if join is on strings then add integer columns to left and right tables and modify colInd1 and colInd2

    // need to allocate all right columns
    if(right->not_compressed) {
        queue<string> op_alt1;
        op_alt1.push(f2);
        cnt_r = load_queue(op_alt1, right, str_join, "", rcount, start_seg, end_seg, rsz, 1);
    }
    else {
        cnt_r = load_queue(op_alt, right, str_join, f2, rcount, start_seg, end_seg, rsz, 1);
    };


    if (right->type[colname]  == 2) {
        str_join = 1;
        right->d_columns_int[f2] = thrust::device_vector<int_type>();
        for(unsigned int i = start_seg; i < end_seg; i++) {
            right->add_hashed_strings(f2, i);
        };
        cnt_r = right->d_columns_int[f2].size();
    };


    if(right->not_compressed) {
        queue<string> op_alt1;
        while(!op_alt.empty()) {
            if(f2.compare(op_alt.front())) {
                if (std::find(right->columnNames.begin(), right->columnNames.end(), op_alt.front()) != right->columnNames.end()) {
                    op_alt1.push(op_alt.front());
                };
            };
            op_alt.pop();
        };
        if(!op_alt1.empty())
            cnt_r = load_queue(op_alt1, right, str_join, "", rcount, start_seg, end_seg, 0, 0);
    };
    return cnt_r;
};

unsigned int calc_right_partition(CudaSet* left, CudaSet* right, queue<string> op_sel) {
    size_t tot_size = left->maxRecs*8;

    while(!op_sel.empty()) {
        if (std::find(right->columnNames.begin(), right->columnNames.end(), op_sel.front()) != right->columnNames.end()) {

            if(right->type[op_sel.front()] <= 1) {
                tot_size = tot_size + right->maxRecs*8*right->segCount;
            }
            else {
                tot_size = tot_size + right->maxRecs*
                           right->char_size[op_sel.front()]*
                           right->segCount;
            };
        };
        op_sel.pop();
    };

    //cout << "tot size " << tot_size << " " << right->maxRecs << " " << right->mRecCount << endl;

    if(tot_size + 300000000 < getFreeMem()) //00
        return right->segCount;
    else {
        if(right->segCount == 1) { //need to partition it. Not compressed.
            right->segCount = ((tot_size*2 )/getFreeMem())+1;
            //right->segCount = 8;
            cout << "seg count " << right->segCount << endl;
            right->maxRecs = (right->mRecCount/right->segCount)+1;
            cout << "max recs " << right->maxRecs << endl;
            return 1;
        }
        else { //compressed
            return right->segCount / ((tot_size+300000000)/getFreeMem());
        };
    };

};


string int_to_string(int number) {
    string number_string = "";
    char ones_char;
    int ones = 0;
    while(true) {
        ones = number % 10;
        switch(ones) {
        case 0:
            ones_char = '0';
            break;
        case 1:
            ones_char = '1';
            break;
        case 2:
            ones_char = '2';
            break;
        case 3:
            ones_char = '3';
            break;
        case 4:
            ones_char = '4';
            break;
        case 5:
            ones_char = '5';
            break;
        case 6:
            ones_char = '6';
            break;
        case 7:
            ones_char = '7';
            break;
        case 8:
            ones_char = '8';
            break;
        case 9:
            ones_char = '9';
            break;
        default :
            cout << ("Trouble converting number to string.");
        }
        number -= ones;
        number_string = ones_char + number_string;
        if(number == 0) {
            break;
        }
        number = number/10;
    }
    return number_string;
}


void insert_records(char* f, char* s) {
    char buf[4096];
    size_t size, maxRecs, cnt = 0;
    string str_s, str_d;

    if(varNames.find(s) == varNames.end()) {
        process_error(3, "couldn't find " + string(s) );
    };
    CudaSet *a;
    a = varNames.find(s)->second;
    a->name = s;

    if(varNames.find(f) == varNames.end()) {
        process_error(3, "couldn't find " + string(f) );
    };

    CudaSet *b;
    b = varNames.find(f)->second;
    b->name = f;

    // if both source and destination are on disk
    cout << "SOURCES " << a->source << ":" << b->source << endl;
    if(a->source && b->source) {
        for(unsigned int i = 0; i < a->segCount; i++) {
            for(unsigned int z = 0; z < a->columnNames.size(); z++) {
                str_s = a->load_file_name + "." + a->columnNames[z] + "." + int_to_string(i);
                str_d = b->load_file_name + "." + a->columnNames[z] + "." + int_to_string(b->segCount + i);
                cout << str_s << " " << str_d << endl;
                FILE* source = fopen(str_s.c_str(), "rb");
                FILE* dest = fopen(str_d.c_str(), "wb");
                while (size = fread(buf, 1, BUFSIZ, source)) {
                    fwrite(buf, 1, size, dest);
                }
                fclose(source);
                fclose(dest);
            };
        };

        if(a->maxRecs > b->maxRecs)
            maxRecs = a->maxRecs;
        else
            maxRecs = b->maxRecs;

        for(unsigned int i = 0; i < b->columnNames.size(); i++) {
            b->reWriteHeader(b->load_file_name, b->columnNames[i], a->segCount + b->segCount, a->totalRecs + b->totalRecs, maxRecs);
        };
    }
    else if(!a->source && !b->source) { //if both source and destination are in memory
        size_t oldCount = b->mRecCount;
        b->resize(a->mRecCount);
        for(unsigned int z = 0; z< b->mColumnCount; z++) {
            if(b->type[a->columnNames[z]] == 0) {
                thrust::copy(a->h_columns_int[a->columnNames[z]].begin(), a->h_columns_int[a->columnNames[z]].begin() + a->mRecCount, b->h_columns_int[b->columnNames[z]].begin() + oldCount);
            }
            else if(b->type[a->columnNames[z]] == 1) {
                thrust::copy(a->h_columns_float[a->columnNames[z]].begin(), a->h_columns_float[a->columnNames[z]].begin() + a->mRecCount, b->h_columns_float[b->columnNames[z]].begin() + oldCount);
            }
            else {
                cudaMemcpy(b->h_columns_char[b->columnNames[z]] + b->char_size[b->columnNames[z]]*oldCount, a->h_columns_char[a->columnNames[z]], a->char_size[a->columnNames[z]]*a->mRecCount, cudaMemcpyHostToHost);
            };
        };
    }
    else if(!a->source && b->source) {


        total_segments = b->segCount;
        total_count = b->mRecCount;
        total_max = b->maxRecs;;

        queue<string> op_vx;
        for(unsigned int i=0; i < a->columnNames.size(); i++)
            op_vx.push(a->columnNames[i]);

        allocColumns(a, op_vx);
        a->resize(a->maxRecs);
        for(unsigned int i = 0; i < a->segCount; i++) {

            if (a->filtered) {
                copyColumns(a, op_vx, i, cnt);
                a->CopyToHost(0, a->mRecCount);
            };

            a->compress(b->load_file_name, 0, 1, i - (a->segCount-1), a->mRecCount);
        };
        //update headers
        //total_count = a->mRecCount + b->mRecCount;
        //cout << "and now lets write " << total_segments << " " <<  total_count << " " << total_max << endl;
        for(unsigned int i = 0; i < b->columnNames.size(); i++) {
            b->writeHeader(b->load_file_name, b->columnNames[i], total_segments);
        };
    };
};



void delete_records(char* f) {

    CudaSet *a;
    a = varNames.find(f)->second;
    a->name = f;
    size_t totalRemoved = 0;
    size_t maxRecs = 0;

    if(!a->keep) { // temporary variable
        process_error(2, "Delete operator is only applicable to disk based sets\nfor deleting records from derived sets please use filter operator ");
    }
    else {  // read matching segments, delete, compress and write on a disk replacing the original segments

        string str, str_old;
        queue<string> op_vx;
        size_t cnt;
        map<string, col_data> s = data_dict[a->load_file_name];
        for ( map<string, col_data>::iterator it=s.begin() ; it != s.end(); ++it ) {
            op_vx.push((*it).first);
            if (std::find(a->columnNames.begin(), a->columnNames.end(), (*it).first) == a->columnNames.end()) {

                if ((*it).second.col_type == 0) {
                    a->type[(*it).first] = 0;
                    a->decimal[(*it).first] = 0;
                    a->h_columns_int[(*it).first] = thrust::host_vector<int_type, pinned_allocator<int_type> >();
                    a->d_columns_int[(*it).first] = thrust::device_vector<int_type>();
                }
                else if((*it).second.col_type == 1) {
                    a->type[(*it).first] = 1;
                    a->decimal[(*it).first] = 0;
                    a->h_columns_float[(*it).first] = thrust::host_vector<float_type, pinned_allocator<float_type> >();
                    a->d_columns_float[(*it).first] = thrust::device_vector<float_type>();
                }
                else if ((*it).second.col_type == 3) {
                    a->type[(*it).first] = 1;
                    a->decimal[(*it).first] = 1;
                    a->h_columns_float[(*it).first] = thrust::host_vector<float_type, pinned_allocator<float_type> >();
                    a->d_columns_float[(*it).first] = thrust::device_vector<float_type>();
                }
                else {
                    a->type[(*it).first] = 2;
                    a->decimal[(*it).first] = 0;
                    a->h_columns_char[(*it).first] = NULL;
                    a->d_columns_char[(*it).first] = NULL;
                    a->char_size[(*it).first] = (*it).second.col_length;
                };
                a->columnNames.push_back((*it).first);
            }
        };

        allocColumns(a, op_vx);
        a->resize(a->maxRecs);
        a->prm_d.resize(a->maxRecs);
        size_t cc = a->mRecCount;
        size_t tmp;

        void* d;
        CUDA_SAFE_CALL(cudaMalloc((void **) &d, a->maxRecs*float_size));
        unsigned int new_seg_count = 0;
        char map_check;

        for(unsigned int i = 0; i < a->segCount; i++) {

            map_check = zone_map_check(op_type,op_value,op_nums, op_nums_f, a, i);
            if(verbose)
                cout << "MAP CHECK segment " << i << " " << map_check <<  endl;
            if(map_check != 'N') {

                cnt = 0;
                copyColumns(a, op_vx, i, cnt);
                tmp = a->mRecCount;

                if(a->mRecCount) {
                    bool* res = filter(op_type,op_value,op_nums, op_nums_f, a, i);
                    thrust::device_ptr<bool> bp((bool*)res);
                    thrust::copy_if(thrust::make_counting_iterator((unsigned int)0), thrust::make_counting_iterator((unsigned int)a->mRecCount),
                                    bp, a->prm_d.begin(), not_identity<bool>());

                    a->mRecCount = thrust::count(bp, bp + (unsigned int)a->mRecCount, 0);
                    cudaFree(res);

//					cout << "Remained recs count " << a->mRecCount << endl;
                    if(a->mRecCount > maxRecs)
                        maxRecs = a->mRecCount;

                    if (a->mRecCount) {

                        totalRemoved = totalRemoved + (tmp - a->mRecCount);
                        if (a->mRecCount == tmp) { //none deleted
                            if(new_seg_count != i) {
                                map<string, col_data> s = data_dict[a->load_file_name];
                                for ( map<string, col_data>::iterator it=s.begin() ; it != s.end(); ++it ) {
                                    string colname = (*it).first;


                                    str_old = a->load_file_name + "." + colname;
                                    str_old += "." + int_to_string(i);
                                    str = a->load_file_name + "." + colname;
                                    str += "." + int_to_string(new_seg_count);

                                    remove(str.c_str());
                                    rename(str_old.c_str(), str.c_str());
                                };
                            };
                            new_seg_count++;

                        }
                        else { //some deleted
                            //cout << "writing segment " << new_seg_count << endl;

                            map<string, col_data> s = data_dict[a->load_file_name];
                            for ( map<string, col_data>::iterator it=s.begin() ; it != s.end(); ++it ) {
                                string colname = (*it).first;
                                str = a->load_file_name + "." + colname;
                                str += "." + int_to_string(new_seg_count);

                                if(a->type[colname] == 0) {
                                    thrust::device_ptr<int_type> d_col((int_type*)d);
                                    thrust::gather(a->prm_d.begin(), a->prm_d.begin() + a->mRecCount, a->d_columns_int[colname].begin(), d_col);
                                    pfor_compress( d, a->mRecCount*int_size, str, a->h_columns_int[colname], 0);
                                }
                                else if(a->type[colname] == 1) {
                                    thrust::device_ptr<float_type> d_col((float_type*)d);
                                    if(a->decimal[colname]) {
                                        thrust::gather(a->prm_d.begin(), a->prm_d.begin() + a->mRecCount, a->d_columns_float[colname].begin(), d_col);
                                        thrust::device_ptr<long long int> d_col_dec((long long int*)d);
                                        thrust::transform(d_col,d_col+a->mRecCount, d_col_dec, float_to_long());
                                        pfor_compress( d, a->mRecCount*float_size, str, a->h_columns_float[colname], 1);
                                    }
                                    else {
                                        thrust::gather(a->prm_d.begin(), a->prm_d.begin() + a->mRecCount, a->d_columns_float[colname].begin(), d_col);
                                        thrust::copy(d_col, d_col + a->mRecCount, a->h_columns_float[colname].begin());
                                        fstream binary_file(str.c_str(),ios::out|ios::binary);
                                        binary_file.write((char *)&a->mRecCount, 4);
                                        binary_file.write((char *)(a->h_columns_float[colname].data()),a->mRecCount*float_size);
                                        unsigned int comp_type = 3;
                                        binary_file.write((char *)&comp_type, 4);
                                        binary_file.close();

                                    };
                                }
                                else {
                                    void* t;
                                    CUDA_SAFE_CALL(cudaMalloc((void **) &t, tmp*a->char_size[colname]));
                                    apply_permutation_char(a->d_columns_char[colname], (unsigned int*)thrust::raw_pointer_cast(a->prm_d.data()), tmp, (char*)t, a->char_size[colname]);
                                    cudaMemcpy(a->h_columns_char[colname], a->d_columns_char[colname], a->char_size[colname]*a->mRecCount, cudaMemcpyDeviceToHost);
                                    cudaFree(t);
                                    a->compress_char(str, colname, a->mRecCount, 0);
                                };
                            };
                            new_seg_count++;
                        };
                    }
                    else {
                        totalRemoved = totalRemoved + tmp;
                    };
                }
            }
            else {
                if(new_seg_count != i) {
                    //cout << "rename " << i << " to " << new_seg_count << endl;
                    //for(unsigned int z = 0; z< a->mColumnCount; z++) {
                    for(unsigned int z = 0; z < a->columnNames.size(); z++) {

                        str_old = a->load_file_name + "." + a->columnNames[z];
                        str_old += "." + int_to_string(i);
                        str = a->load_file_name + "." + a->columnNames[z];
                        str += "." + int_to_string(new_seg_count);

                        remove(str.c_str());
                        rename(str_old.c_str(), str.c_str());
                    };
                };
                new_seg_count++;
                maxRecs	= a->maxRecs;
            };
            //cout << "TOTAL REM " << totalRemoved << endl;
        };

        if (new_seg_count < a->segCount) {
            for(unsigned int i = new_seg_count; i < a->segCount; i++) {
                //cout << "delete segment " << i << endl;
                for(unsigned int z = 0; z < a->columnNames.size(); z++) {
                    str = a->load_file_name + "." + a->columnNames[z];
                    str += "." + int_to_string(i);
                    remove(str.c_str());
                };
            };
        };

        for(unsigned int i = new_seg_count; i < a->segCount; i++) {
            a->reWriteHeader(a->load_file_name, a->columnNames[i], new_seg_count, a->totalRecs-totalRemoved, maxRecs);
        };


        a->mRecCount = cc;
        a->prm_d.resize(0);
        a->segCount = new_seg_count;
        a->deAllocOnDevice();
        cudaFree(d);
    };


};


void save_col_data(map<string, map<string, col_data> >& data_dict, string file_name)
{
    size_t str_len;
    fstream binary_file(file_name.c_str(),ios::out|ios::binary|ios::trunc);
    size_t len = data_dict.size();
    binary_file.write((char *)&len, 8);
    for ( map<string, map<string, col_data> >::iterator it=data_dict.begin() ; it != data_dict.end(); ++it ) {
        str_len = (*it).first.size();
        binary_file.write((char *)&str_len, 8);
        binary_file.write((char *)(*it).first.data(), str_len);
        map<string, col_data> s = (*it).second;
        size_t len1 = s.size();
        binary_file.write((char *)&len1, 8);

        for ( map<string, col_data>::iterator sit=s.begin() ; sit != s.end(); ++sit ) {
            str_len = (*sit).first.size();
            binary_file.write((char *)&str_len, 8);
            binary_file.write((char *)(*sit).first.data(), str_len);
            binary_file.write((char *)&(*sit).second.col_type, 4);
            binary_file.write((char *)&(*sit).second.col_length, 4);
        };
    };
    binary_file.close();
}

void load_col_data(map<string, map<string, col_data> >& data_dict, string file_name)
{
    size_t str_len, recs, len1;
    string str1, str2;
    char buffer[4000];
    unsigned int col_type, col_length;
    fstream binary_file;
    binary_file.open(file_name.c_str(),ios::in|ios::binary);
    if(binary_file.is_open()) {
        binary_file.read((char*)&recs, 8);
        for(unsigned int i = 0; i < recs; i++) {
            binary_file.read((char*)&str_len, 8);
            binary_file.read(buffer, str_len);
            str1.assign(buffer, str_len);
            binary_file.read((char*)&len1, 8);

            for(unsigned int j = 0; j < len1; j++) {
                binary_file.read((char*)&str_len, 8);
                binary_file.read(buffer, str_len);
                str2.assign(buffer, str_len);
                binary_file.read((char*)&col_type, 4);
                binary_file.read((char*)&col_length, 4);
                data_dict[str1][str2].col_type = col_type;
                data_dict[str1][str2].col_length = col_length;
                //cout << "data DICT " << str1 << " " << str2 << " " << col_type << " " << col_length << endl;
            };
        };
        binary_file.close();
    }
    else {
        cout << "Coudn't open data dictionary" << endl;
    };
}

bool var_exists(CudaSet* a, string name) {

    if(std::find(a->columnNames.begin(), a->columnNames.end(), name) !=  a->columnNames.end())
        return 1;
    else

        return 0;
}


#ifdef _WIN64
size_t getTotalSystemMemory()
{
    MEMORYSTATUSEX status;
    status.dwLength = sizeof(status);
    GlobalMemoryStatusEx(&status);
    return status.ullTotalPhys;
}
#else
size_t getTotalSystemMemory()
{
    long pages = sysconf(_SC_PHYS_PAGES);
    long page_size = sysconf(_SC_PAGE_SIZE);
    return pages * page_size;
}
#endif

