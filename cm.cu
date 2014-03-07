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
#include <algorithm>
#include <functional>
#include <numeric>
#include "cm.h"
#include "atof.h"
#include "compress.cu"
#include "sorts.cu"
#include "filter.h"
#include "row.h"


#ifdef _WIN64
#define atoll(S) _atoi64(S)
#endif


using namespace std;
using namespace thrust::placeholders;


size_t total_count = 0, total_max;
std::clock_t tot;
unsigned int total_segments = 0;
unsigned int process_count;
size_t alloced_sz = 0;
bool fact_file_loaded = 1;
bool verbose;
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

void* alloced_tmp;
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
	grp_type = NULL;
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
	grp_type = NULL;

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
	grp_type = NULL;	
};

CudaSet::CudaSet(queue<string> op_sel, queue<string> op_sel_as)
{
    initialize(op_sel, op_sel_as);
    keep = false;
    source = 0;
    text_source = 0;
    grp = NULL;
	fil_f = NULL;
	fil_s = NULL;
	grp_type = NULL;	
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
	grp_type = NULL;	
};


CudaSet::~CudaSet()
{
    free();
};


void CudaSet::allocColumnOnDevice(unsigned int colIndex, size_t RecordCount)
{
    if (type[colIndex] == 0) {
        d_columns_int[type_index[colIndex]].resize(RecordCount);
    }
    else if (type[colIndex] == 1)
        d_columns_float[type_index[colIndex]].resize(RecordCount);
    else {
        void* d;
        size_t sz = RecordCount*char_size[type_index[colIndex]];
        cudaError_t cudaStatus = cudaMalloc(&d, sz);
        if(cudaStatus != cudaSuccess) {
            cout << "Could not allocate " << sz << " bytes of GPU memory for " << RecordCount << " records " << endl;
            exit(0);
        };
        d_columns_char[type_index[colIndex]] = (char*)d;
    };
};


void CudaSet::decompress_char_hash(string colname, unsigned int segment, size_t i_cnt)
{
    unsigned int bits_encoded, fit_count, sz, vals_count, real_count;
	unsigned int colIndex = columnNames[colname];
    size_t old_count;
    const unsigned int len = char_size[type_index[colIndex]];

    string f1 = load_file_name + "." + colname + "." + int_to_string(segment);

    FILE* f;
    f = fopen (f1.c_str() , "rb" );
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
            old_count = d_columns_int[i_cnt].size();
            d_columns_int[i_cnt].resize(old_count + mRecCount);
            thrust::gather(prm_d.begin(), prm_d.begin() + mRecCount, d_tmp, d_columns_int[i_cnt].begin() + old_count);
            thrust::device_free(d_tmp);

        }
        else if(prm_index == 'A') {
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
    cudaFree(d_v1);
    cudaFree(d_int);	
};




// takes a char column , hashes strings, copies them to a gpu
void CudaSet::add_hashed_strings(string field, unsigned int segment, size_t i_cnt)
{
    unsigned int colInd2 = columnNames.find(field)->second;
    CudaSet *t = varNames[setMap[field]];

    if(not_compressed) { // decompressed strings on a host

        size_t old_count;
        unsigned long long int* hashes  = new unsigned long long int[t->mRecCount];

        for(unsigned int i = 0; i < t->mRecCount ; i++) {
            hashes[i] = MurmurHash64A(t->h_columns_char[t->type_index[colInd2]] + i*t->char_size[t->type_index[colInd2]] + segment*t->maxRecs*t->char_size[t->type_index[colInd2]], t->char_size[t->type_index[colInd2]], hash_seed);
        };

        if(filtered) {

            if(prm_index == 'R') {

                thrust::device_ptr<unsigned long long int> d_tmp = thrust::device_malloc<unsigned long long int>(t->mRecCount);
                thrust::copy(hashes, hashes+mRecCount, d_tmp);
                old_count = d_columns_int[i_cnt].size();
                d_columns_int[i_cnt].resize(old_count + mRecCount);
                thrust::gather(prm_d.begin(), prm_d.begin() + mRecCount, d_tmp, d_columns_int[i_cnt].begin() + old_count);
                thrust::device_free(d_tmp);

            }
            else if(prm_index == 'A') {
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
        delete [] hashes;
    }
    else { // hash the dictionary
        decompress_char_hash(field, segment, i_cnt);
    };
};


void CudaSet::resize_join(size_t addRecs)
{
    mRecCount = mRecCount + addRecs;
    bool prealloc = 0;
    for(unsigned int i=0; i < mColumnCount; i++) {
        if(type[i] == 0) {
            h_columns_int[type_index[i]].resize(mRecCount);
        }
        else if(type[i] == 1) {
            h_columns_float[type_index[i]].resize(mRecCount);
        }
        else {
            if (h_columns_char[type_index[i]]) {
                if (mRecCount > prealloc_char_size) {
                    h_columns_char[type_index[i]] = (char*)realloc(h_columns_char[type_index[i]], mRecCount*char_size[type_index[i]]);
                    prealloc = 1;
                };
            }
            else {
                h_columns_char[type_index[i]] = new char[mRecCount*char_size[type_index[i]]];
            };
        };

    };
    if(prealloc)
        prealloc_char_size = mRecCount;
};


void CudaSet::resize(size_t addRecs)
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
                h_columns_char[type_index[i]] = (char*)realloc(h_columns_char[type_index[i]], mRecCount*char_size[type_index[i]]);
            }
            else {
                h_columns_char[type_index[i]] = new char[mRecCount*char_size[type_index[i]]];
            };
        };

    };
};

void CudaSet::reserve(size_t Recs)
{

    for(unsigned int i=0; i <mColumnCount; i++) {
        if(type[i] == 0)
            h_columns_int[type_index[i]].reserve(Recs);
        else if(type[i] == 1)
            h_columns_float[type_index[i]].reserve(Recs);
        else {
            h_columns_char[type_index[i]] = new char[Recs*char_size[type_index[i]]];
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
		if(d_columns_int[type_index[colIndex]].size() > 0) {
			d_columns_int[type_index[colIndex]].resize(0);
			d_columns_int[type_index[colIndex]].shrink_to_fit();
		};	
    }
    else if (type[colIndex] == 1 && !d_columns_float.empty()) {
		if (d_columns_float[type_index[colIndex]].size() > 0) {
			d_columns_float[type_index[colIndex]].resize(0);
			d_columns_float[type_index[colIndex]].shrink_to_fit();
		};	
    }
    else if (type[colIndex] == 2 && d_columns_char[type_index[colIndex]] != NULL) {
        cudaFree(d_columns_char[type_index[colIndex]]);
        d_columns_char[type_index[colIndex]] = NULL;
    };
};

void CudaSet::allocOnDevice(size_t RecordCount)
{
    for(unsigned int i=0; i < mColumnCount; i++)
        allocColumnOnDevice(i, RecordCount);
};

void CudaSet::deAllocOnDevice()
{
    for(unsigned int i=0; i < mColumnCount; i++)
        deAllocColumnOnDevice(i);
		
	for(unsigned int i=0; i < d_columns_int.size(); i++)	{
		if(d_columns_int[i].size() > 0) {
			d_columns_int[i].resize(0);
			d_columns_int[i].shrink_to_fit();
		};	
	};	

	for(unsigned int i=0; i < d_columns_float.size(); i++)	{
		if(d_columns_float[i].size() > 0) {
			d_columns_float[i].resize(0);
			d_columns_float[i].shrink_to_fit();
		};	
	};	
	

    if(grp) {
        cudaFree(grp);
        grp = NULL;
    };

	
    if(filtered) { // free the sources
        string some_field;
        map<string,unsigned int>::iterator it=columnNames.begin();
        some_field = (*it).first;

        if(setMap[some_field].compare(name)) {
			if(varNames.find(setMap[some_field]) != varNames.end()) {
				CudaSet* t = varNames[setMap[some_field]];
				t->deAllocOnDevice();
			};	
        };
    };
};

void CudaSet::resizeDeviceColumn(size_t RecCount, unsigned int colIndex)
{
//   if (RecCount) {
    if (type[colIndex] == 0) {
        d_columns_int[type_index[colIndex]].resize(mRecCount+RecCount);
    }
    else if (type[colIndex] == 1)
        d_columns_float[type_index[colIndex]].resize(mRecCount+RecCount);
    else {
        if (d_columns_char[type_index[colIndex]] != NULL)
            cudaFree(d_columns_char[type_index[colIndex]]);
        void *d;
        cudaMalloc((void **) &d, (mRecCount+RecCount)*char_size[type_index[colIndex]]);
        d_columns_char[type_index[colIndex]] = (char*)d;
    };
//    };
};



void CudaSet::resizeDevice(size_t RecCount)
{
    //  if (RecCount)
    for(unsigned int i=0; i < mColumnCount; i++)
        resizeDeviceColumn(RecCount, i);
};

bool CudaSet::onDevice(unsigned int i)
{
    size_t j = type_index[i];

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
	a->ref_joins = ref_joins;
	a->ref_sets = ref_sets;
	a->ref_cols = ref_cols;

    for ( map<string,unsigned int>::iterator it=columnNames.begin() ; it != columnNames.end(); ++it )
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
            a->char_size.push_back(char_size[type_index[i]]);
        };
    };
    a->load_file_name = load_file_name;

    a->mRecCount = 0;
    return a;
}


void CudaSet::readSegmentsFromFile(unsigned int segNum, string colname, size_t offset)
{
	std::clock_t start1 = std::clock();	
    string f1(load_file_name);
	unsigned int colIndex = columnNames[colname];
    f1 += "." + colname + "." + int_to_string(segNum);
    unsigned int cnt;

    FILE* f;
    f = fopen(f1.c_str(), "rb" );
    if(f == NULL) {
        cout << "Error opening " << f1 << " file " << endl;
        exit(0);
    };
    size_t rr;	

    if(type[colIndex] == 0) {	    
		if(1 > h_columns_int[type_index[colIndex]].size())
			h_columns_int[type_index[colIndex]].resize(1);		
        fread(h_columns_int[type_index[colIndex]].data(), 4, 1, f);
        cnt = ((unsigned int*)(h_columns_int[type_index[colIndex]].data()))[0];		
		if(cnt > h_columns_int[type_index[colIndex]].size()/8 + 10)
			h_columns_int[type_index[colIndex]].resize(cnt/8 + 10);			
        rr = fread((unsigned int*)(h_columns_int[type_index[colIndex]].data()) + 1, 1, cnt+52, f);
        if(rr != cnt+52) {
            cout << "Couldn't read  " << cnt+52 << " bytes from " << f1  << " ,read only " << rr << endl;
            exit(0);
        };
    }
    else if(type[colIndex] == 1) {		
		if(1 > h_columns_float[type_index[colIndex]].size())
			h_columns_float[type_index[colIndex]].resize(1);		
        fread(h_columns_float[type_index[colIndex]].data(), 4, 1, f);
        cnt = ((unsigned int*)(h_columns_float[type_index[colIndex]].data()))[0];
		if(cnt > h_columns_float[type_index[colIndex]].size()/8 + 10)
			h_columns_float[type_index[colIndex]].resize(cnt/8 + 10);				
        rr = fread((unsigned int*)(h_columns_float[type_index[colIndex]].data()) + 1, 1, cnt+52, f);
        if(rr != cnt+52) {
            cout << "Couldn't read  " << cnt+52 << " bytes from " << f1  << endl;
            exit(0);
        };		
    }
    else {
        decompress_char(f, colIndex, segNum, offset);
    };
    fclose(f);
	tot = tot + (std::clock() - start1);
	//if(verbose)
	//	std::cout<< "read from file time " <<  ( ( std::clock() - start1 ) / (double)CLOCKS_PER_SEC ) << " " << getFreeMem() << '\n';	
};



void CudaSet::decompress_char(FILE* f, unsigned int colIndex, unsigned int segNum, size_t offset)
{
    unsigned int bits_encoded, fit_count, sz, vals_count, real_count;
    const unsigned int len = char_size[type_index[colIndex]];
	std::clock_t start1 = std::clock();	
	
    fread(&sz, 4, 1, f);
    char* d_array = new char[sz*len];
    fread((void*)d_array, sz*len, 1, f);
	tot = tot + (std::clock() - start1);
    void* d;
    cudaMalloc((void **) &d, sz*len);
    cudaMemcpy( d, (void *) d_array, sz*len, cudaMemcpyHostToDevice);
    delete[] d_array;

	start1 = std::clock();	
    fread(&fit_count, 4, 1, f);
    fread(&bits_encoded, 4, 1, f);
    fread(&vals_count, 4, 1, f);
    fread(&real_count, 4, 1, f);
	tot = tot + (std::clock() - start1);

    thrust::device_ptr<unsigned int> param = thrust::device_malloc<unsigned int>(2);
    param[1] = fit_count;
    param[0] = bits_encoded;

    unsigned long long int* int_array = new unsigned long long int[vals_count];
    fread((void*)int_array, 1, vals_count*8, f);
	
    //fclose(f);

    void* d_val;
    cudaMalloc((void **) &d_val, vals_count*8);
    cudaMemcpy(d_val, (void *) int_array, vals_count*8, cudaMemcpyHostToDevice);
    delete[] int_array;

    void* d_int;
    cudaMalloc((void **) &d_int, real_count*4);

    thrust::counting_iterator<unsigned int> begin(0);
    decompress_functor_str ff((unsigned long long int*)d_val,(unsigned int*)d_int, (unsigned int*)thrust::raw_pointer_cast(param));
    thrust::for_each(begin, begin + real_count, ff);

    if(!alloced_switch)
		str_gather(d_int, real_count, d, d_columns_char[type_index[colIndex]] + offset*len, len);
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

	unsigned int colIndex = columnNames[colname];
    if(not_compressed) 	{
        // calculate how many records we need to copy
        if(segment < segCount-1) {
            mRecCount = maxRecs;
        }
        else {
            mRecCount = hostRecCount - maxRecs*(segCount-1);
        };

        switch(type[colIndex]) {
        case 0 :
            if(!alloced_switch)
                thrust::copy(h_columns_int[type_index[colIndex]].begin() + maxRecs*segment, h_columns_int[type_index[colIndex]].begin() + maxRecs*segment + mRecCount, d_columns_int[type_index[colIndex]].begin() + offset);
            else {
                thrust::device_ptr<int_type> d_col((int_type*)alloced_tmp);
                thrust::copy(h_columns_int[type_index[colIndex]].begin() + maxRecs*segment, h_columns_int[type_index[colIndex]].begin() + maxRecs*segment + mRecCount, d_col);
            };
            break;
        case 1 :
            if(!alloced_switch) {
                thrust::copy(h_columns_float[type_index[colIndex]].begin() + maxRecs*segment, h_columns_float[type_index[colIndex]].begin() + maxRecs*segment + mRecCount, d_columns_float[type_index[colIndex]].begin() + offset);
            }
            else {
                thrust::device_ptr<float_type> d_col((float_type*)alloced_tmp);
                thrust::copy(h_columns_float[type_index[colIndex]].begin() + maxRecs*segment, h_columns_float[type_index[colIndex]].begin() + maxRecs*segment + mRecCount, d_col);
            };
            break;
        default :
            if(!alloced_switch) {
                cudaMemcpy(d_columns_char[type_index[colIndex]] + char_size[type_index[colIndex]]*offset, h_columns_char[type_index[colIndex]] + maxRecs*segment*char_size[type_index[colIndex]], char_size[type_index[colIndex]]*mRecCount, cudaMemcpyHostToDevice);
            }
            else
                cudaMemcpy(alloced_tmp , h_columns_char[type_index[colIndex]] + maxRecs*segment*char_size[type_index[colIndex]], char_size[type_index[colIndex]]*mRecCount, cudaMemcpyHostToDevice);
        };
    }
    else {
	
        readSegmentsFromFile(segment,colname, offset);

        if(type[colIndex] != 2) {
            if(d_v == NULL)
                CUDA_SAFE_CALL(cudaMalloc((void **) &d_v, 12));
            if(s_v == NULL)
                CUDA_SAFE_CALL(cudaMalloc((void **) &s_v, 8));
        };
		

        if(type[colIndex] == 0) {
            if(!alloced_switch) {
                mRecCount = pfor_decompress(thrust::raw_pointer_cast(d_columns_int[type_index[colIndex]].data() + offset), h_columns_int[type_index[colIndex]].data(), d_v, s_v);
            }
            else {
                mRecCount = pfor_decompress(alloced_tmp, h_columns_int[type_index[colIndex]].data(), d_v, s_v);
            };
        }
        else if(type[colIndex] == 1) {
            if(decimal[colIndex]) {
                if(!alloced_switch) {
                    mRecCount = pfor_decompress( thrust::raw_pointer_cast(d_columns_float[type_index[colIndex]].data() + offset) , h_columns_float[type_index[colIndex]].data(), d_v, s_v);
                    thrust::device_ptr<long long int> d_col_int((long long int*)thrust::raw_pointer_cast(d_columns_float[type_index[colIndex]].data() + offset));
                    thrust::transform(d_col_int,d_col_int+mRecCount,d_columns_float[type_index[colIndex]].begin(), long_to_float());
                }
                else {
                    mRecCount = pfor_decompress(alloced_tmp, h_columns_float[type_index[colIndex]].data(), d_v, s_v);
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
	unsigned int colIndex = columnNames[colname];
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
        size_t totals = 0;
        if(d_v == NULL)
            CUDA_SAFE_CALL(cudaMalloc((void **) &d_v, 12));
        if(s_v == NULL)
            CUDA_SAFE_CALL(cudaMalloc((void **) &s_v, 8));

		size_t cnt = 0;
        for(unsigned int i = 0; i < segCount; i++) {

            readSegmentsFromFile(i,colname, cnt);

            if(type[colIndex] == 0) {
                mRecCount = pfor_decompress(thrust::raw_pointer_cast(d_columns_int[type_index[colIndex]].data() + totals), h_columns_int[type_index[colIndex]].data(), d_v, s_v);
            }
            else if(type[colIndex] == 1) {
                if(decimal[colIndex]) {
                    mRecCount = pfor_decompress( thrust::raw_pointer_cast(d_columns_float[type_index[colIndex]].data() + totals) , h_columns_float[type_index[colIndex]].data(), d_v, s_v);
                    thrust::device_ptr<long long int> d_col_int((long long int*)thrust::raw_pointer_cast(d_columns_float[type_index[colIndex]].data() + totals));
                    thrust::transform(d_col_int,d_col_int+mRecCount,d_columns_float[type_index[colIndex]].begin() + totals, long_to_float());
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



void CudaSet::CopyColumnToHost(int colIndex, size_t offset, size_t RecCount)
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

void CudaSet::CopyToHost(size_t offset, size_t count)
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
    unsigned int colIndex;

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

    };

    thrust::device_free(d_group);
    grp_count = thrust::count(d_grp, d_grp+mRecCount,1);
};


void CudaSet::addDeviceColumn(int_type* col, int colIndex, string colName, size_t recCount)
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

void CudaSet::addDeviceColumn(float_type* col, int colIndex, string colName, size_t recCount, bool is_decimal)
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

	decimal[colIndex] = is_decimal;
    thrust::device_ptr<float_type> d_col((float_type*)col);
    thrust::copy(d_col, d_col+recCount, d_columns_float[type_index[colIndex]].begin());
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
            int colInd = columnNames[sf.front()];

            allocColumnOnDevice(colInd, maxRecs);
            CopyColumnToGpu(sf.front());

            if (type[colInd] == 0)
                update_permutation(d_columns_int[type_index[colInd]], raw_ptr, mRecCount, sort_type, (int_type*)temp);
            else if (type[colInd] == 1)
                update_permutation(d_columns_float[type_index[colInd]], raw_ptr, mRecCount, sort_type, (float_type*)temp);
            else {
                update_permutation_char(d_columns_char[type_index[colInd]], raw_ptr, mRecCount, sort_type, (char*)temp, char_size[type_index[colInd]]);
            };
            deAllocColumnOnDevice(colInd);
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
	//for(unsigned int i = 0; i< mColumnCount; i++) {
	unsigned int i;
    for (map<string,unsigned int>::iterator it=columnNames.begin() ; it != columnNames.end(); ++it ) {

		i = it->second;
		string colname = it->first;
		
		str = file_name + "." + colname;
		curr_file = str;
		str += "." + int_to_string(total_segments-1);
		new_offset = 0;

		if(!op_sort.empty()) {
			allocColumnOnDevice(i, maxRecs);
			CopyColumnToGpu(it->first);
		};		

		if(type[i] == 0) {
			thrust::device_ptr<int_type> d_col((int_type*)d);
			if(!op_sort.empty()) {
				thrust::gather(permutation.begin(), permutation.end(), d_columns_int[type_index[i]].begin(), d_col);
				
				for(unsigned int p = 0; p < partition_count; p++) {
					str = file_name + "." + colname;
					curr_file = str;
					str += "." + int_to_string(total_segments-1);
					if (p < partition_count - 1) {
						pfor_compress( (int_type*)d + new_offset, partition_recs*int_size, str, h_columns_int[type_index[i]], 0);
					}	
					else {	
						pfor_compress( (int_type*)d + new_offset, (mCount - partition_recs*p)*int_size, str, h_columns_int[type_index[i]], 0);
					};	
					new_offset = new_offset + partition_recs;
					total_segments++;	
				};
			}
			else {
				thrust::copy(h_columns_int[type_index[i]].begin() + offset, h_columns_int[type_index[i]].begin() + offset + mCount, d_col);
				pfor_compress( d, mCount*int_size, str, h_columns_int[type_index[i]], 0);
			};			
		}
		else if(type[i] == 1) {
			if(decimal[i]) {
				thrust::device_ptr<float_type> d_col((float_type*)d);
				if(!op_sort.empty()) {
					thrust::gather(permutation.begin(), permutation.end(), d_columns_float[type_index[i]].begin(), d_col);
					thrust::device_ptr<long long int> d_col_dec((long long int*)d);
					thrust::transform(d_col,d_col+mCount,d_col_dec, float_to_long());
					
					for(unsigned int p = 0; p < partition_count; p++) {
						str = file_name + "." + colname;
						curr_file = str;
						str += "." + int_to_string(total_segments-1);
						if (p < partition_count - 1)
							pfor_compress( (int_type*)d + new_offset, partition_recs*float_size, str, h_columns_float[type_index[i]], 1);
						else	
							pfor_compress( (int_type*)d + new_offset, (mCount - partition_recs*p)*float_size, str, h_columns_float[type_index[i]], 1);
						new_offset = new_offset + partition_recs;
						total_segments++;	
					};					
				}
				else {
					thrust::copy(h_columns_float[type_index[i]].begin() + offset, h_columns_float[type_index[i]].begin() + offset + mCount, d_col);
					thrust::device_ptr<long long int> d_col_dec((long long int*)d);
					thrust::transform(d_col,d_col+mCount,d_col_dec, float_to_long());
					pfor_compress( d, mCount*float_size, str, h_columns_float[type_index[i]], 1);					
				};
			}
			else { // do not compress -- float
				thrust::device_ptr<float_type> d_col((float_type*)d);
				if(!op_sort.empty()) {
					thrust::gather(permutation.begin(), permutation.end(), d_columns_float[type_index[i]].begin(), d_col);
					thrust::copy(d_col, d_col+mRecCount, h_columns_float[type_index[i]].begin());
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
						binary_file.write((char *)(h_columns_float[type_index[i]].data() + new_offset),curr_cnt*float_size);
						new_offset = new_offset + partition_recs;
						unsigned int comp_type = 3;
						binary_file.write((char *)&comp_type, 4);
						binary_file.close();
					};					
				}
				else {				
					fstream binary_file(str.c_str(),ios::out|ios::binary|fstream::app);
					binary_file.write((char *)&mCount, 4);
					binary_file.write((char *)(h_columns_float[type_index[i]].data() + offset),mCount*float_size);
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
				char* t = new char[char_size[type_index[i]]*mRecCount];
				apply_permutation_char_host(h_columns_char[type_index[i]], h_permutation, mRecCount, t, char_size[type_index[i]]);
				delete [] h_permutation;
				thrust::copy(t, t+ char_size[type_index[i]]*mRecCount, h_columns_char[type_index[i]]);
				delete [] t;
				for(unsigned int p = 0; p < partition_count; p++) {		
					str = file_name + "." + colname;
					curr_file = str;
					str += "." + int_to_string(total_segments-1);
				
					if (p < partition_count - 1)
						compress_char(str, i, partition_recs, new_offset);
					else	
						compress_char(str, i, mCount - partition_recs*p, new_offset);
					new_offset = new_offset + partition_recs;
					total_segments++;	
				};	
			}
			else
				compress_char(str, i, mCount, offset);
		};
		
		
		if((check_type == 1 && fact_file_loaded) || (check_type == 1 && check_val == 0)) {
			if(!op_sort.empty())
				writeHeader(file_name, it->first, total_segments-1);
			else {
				writeHeader(file_name, it->first, total_segments);
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

        map<unsigned int, string> ordered_columnNames;
        for (map<string,unsigned int>::iterator it=columnNames.begin() ; it != columnNames.end(); ++it )
                ordered_columnNames[it->second] = it->first;

        unsigned int cc =0;
        for (map<unsigned int, string>::iterator it=ordered_columnNames.begin() ; it != ordered_columnNames.end(); ++it )
        {
                fields[cc] = &(bigbuf[cc*MAXFIELDSIZE]);                        // a hack to avoid malloc overheads     - refine later
                dcolumns[cc++] = it->second.c_str();
        }

     // The goal here is to loop fast and avoid any double handling of outgoing data - pointers are good.
        if(not_compressed && prm_d.size() == 0) {
            for(unsigned int i=0; i < mCount; i++) {                            // for each record
                  for(unsigned int j=0; j < mColumnCount; j++) {                // for each col
                    if (type[j] == 0)
                        sprintf(fields[j], "%lld", (h_columns_int[type_index[j]])[i] );
                    else if (type[j] == 1)
                        sprintf(fields[j], "%.2f", (h_columns_float[type_index[j]])[i] );
                    else {
						strncpy(fields[j], h_columns_char[type_index[j]] + (i*char_size[type_index[j]]), char_size[type_index[j]]);
                        //ss.assign(h_columns_char[type_index[j]] + (i*char_size[type_index[j]]), char_size[type_index[j]]);
                        //fields[j] = (char *) ss.c_str();
                    };
                  };
                  row_cb(NULL, mColumnCount, (char **)fields, (char **)dcolumns);
                  rows++;
            };
        }
        else {
                        queue<string> op_vx;
                        for (map<string,unsigned int>::iterator it=columnNames.begin() ; it != columnNames.end(); ++it )
                                op_vx.push((*it).first);
                        //curr_segment = 1000000;

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
                                        for(unsigned int j=0; j < mColumnCount; j++) {
                                                if (type[j] == 0)
                                                        sprintf(fields[j], "%lld", (h_columns_int[type_index[j]])[i] );
                                                else if (type[j] == 1)
                                                        sprintf(fields[j], "%.2f", (h_columns_float[type_index[j]])[i] );
                                                else {
                                                        ss.assign(h_columns_char[type_index[j]] + (i*char_size[type_index[j]]), char_size[type_index[j]]);
                                                        fields[j] = (char *) ss.c_str();
                                                };
                                        };
                                        row_cb(NULL, mColumnCount, (char **)fields, (char**)dcolumns);
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
        //for(unsigned int i = 0; i< mColumnCount; i++) {
		for (map<string,unsigned int>::iterator it=columnNames.begin() ; it != columnNames.end(); ++it ) {
            writeHeader(file_name, it->first, total_segments);
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
			
		char buffer [33];			
		string ss;
		
		if(not_compressed && prm_d.size() == 0) {
            for(unsigned int i=0; i < mCount; i++) {
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
                if (i != mCount -1 )
                    fputs("\n",file_pr);
            };		
			if(!term)
				fclose(file_pr);
		}
		else {

			queue<string> op_vx;
			for (map<string,unsigned int>::iterator it=columnNames.begin() ; it != columnNames.end(); ++it )
				op_vx.push((*it).first);

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
		for (map<string,unsigned int>::iterator it=columnNames.begin() ; it != columnNames.end(); ++it ) {
	
			if(decimal[(*it).second] == 1)
				data_dict[file_name][(*it).first].col_type = 3;
			else	
				data_dict[file_name][(*it).first].col_type = type[(*it).second]; 
			if(type[(*it).second] != 2)
				data_dict[file_name][(*it).first].col_length = 0;
			else	
				data_dict[file_name][(*it).first].col_length = char_size[type_index[(*it).second]];
		};		

	
		if(text_source) {  //writing a binary file using a text file as a source

			// time to perform join checks on REFERENCES dataset segments	
			//for(unsigned int i = 0; i< mColumnCount; i++) {
			for (map<string,unsigned int>::iterator it=columnNames.begin() ; it != columnNames.end(); ++it ) {
				unsigned int i = columnNames[it->first];
				if(ref_sets.find(i) != ref_sets.end()) {
				
					string f1 = file_name + "." + it->first + ".refs";
					fstream f_file;
					if(total_segments == 0) {
						f_file.open(f1.c_str(), ios::out|ios::trunc|ios::binary);
						unsigned int len = ref_sets[i].size();
						f_file.write((char *)&len, 4);
						f_file.write(ref_sets[i].c_str(), len);
						len = ref_cols[i].size();
						f_file.write((char *)&len, 4);
						f_file.write(ref_cols[i].c_str(), len);
					}	
					else {	
						f_file.open(f1.c_str(), ios::out|ios::app|ios::binary);
					};					
				
					f1 = ref_sets[i] + "." + ref_cols[i] + ".header";
					FILE* ff = fopen(f1.c_str(), "rb");
					if(ff == NULL) {
						cout << "Couldn't open file " << f1 << endl;
						exit(0);
					};
					unsigned int ref_segCount, ref_maxRecs;
					fread((char *)&ref_segCount, 4, 1, ff);
					fread((char *)&ref_segCount, 4, 1, ff);
					fread((char *)&ref_segCount, 4, 1, ff);
					fread((char *)&ref_maxRecs, 4, 1, ff);
					fclose(ff);				
					//cout << "CALC " << i << " " << ref_sets[i] << " " << ref_cols[i] << " " << ref_segCount << endl;
				
					CudaSet* a = new CudaSet(maxRecs, 1);
					a->h_columns_int.push_back(thrust::host_vector<int_type, pinned_allocator<int_type> >());
					a->d_columns_int.push_back(thrust::device_vector<int_type>(ref_maxRecs));
					a->type[0] = 0;
					a->type_index[0] = 0;
					a->not_compressed = 0;
					a->load_file_name = ref_sets[i];
					a->cols[0] = 1;
					a->columnNames[ref_cols[i]] = 0;
					MGPU_MEM(int) aIndicesDevice, bIndicesDevice;
					size_t res_count;
				
					if(!onDevice(i)) {
						allocColumnOnDevice(i, maxRecs);					
					};	
					CopyColumnToGpu(it->first);
					thrust::sort(d_columns_int[type_index[i]].begin(), d_columns_int[type_index[i]].begin() + mRecCount);				

					f_file.write((char *)&total_segments, 4);					
					f_file.write((char *)&ref_segCount, 4);				
					for(unsigned int z = 0; z < ref_segCount; z++) {

						a->CopyColumnToGpu(ref_cols[i], z, 0);
						thrust::sort(a->d_columns_int[0].begin(), a->d_columns_int[0].begin() + a->mRecCount);
						// check if there is a join result
						//cout << "join " << mRecCount << " " << a->mRecCount << endl;					
				
						res_count = RelationalJoin<MgpuJoinKindInner>(thrust::raw_pointer_cast(d_columns_int[type_index[i]].data()), mRecCount,
									thrust::raw_pointer_cast(a->d_columns_int[0].data()), a->mRecCount,
									&aIndicesDevice, &bIndicesDevice,
									mgpu::less<int_type>(), *context);
					//cout << "RES " << i << " " << total_segments << ":" << z << " " << res_count << endl;			
						f_file.write((char *)&z, 4);
						f_file.write((char *)&res_count, 8);
					};
					f_file.close();
					a->deAllocColumnOnDevice(0);
					a->free();				
				};
			};	
			compress(file_name, 0, 1, 0, mCount);		
			for(unsigned int i = 0; i< mColumnCount; i++)
				if(type[i] == 2)
					deAllocColumnOnDevice(i);
		}
		else { //writing a binary file using a binary file as a source
			fact_file_loaded = 1;
			size_t offset = 0;

			if(!not_compressed) { // records are compressed, for example after filter op.
				//decompress to host
				queue<string> op_vx;
				for (map<string,unsigned int>::iterator it=columnNames.begin() ; it != columnNames.end(); ++it ) {
					op_vx.push((*it).first);
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


void CudaSet::compress_char(string file_name, unsigned int index, size_t mCount, size_t offset)
{
    std::map<string,unsigned int> dict;
    std::vector<string> dict_ordered;
    std::vector<unsigned int> dict_val;
    map<string,unsigned int>::iterator iter;
    unsigned int bits_encoded, ss;    
    unsigned int len = char_size[type_index[index]];

    for (unsigned int i = 0 ; i < mCount; i++) {

		string f(h_columns_char[type_index[index]] + (i+offset)*len, len);
		
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

    char *cc = new char[len+1];
    unsigned int sz = (unsigned int)dict_ordered.size();
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
    unsigned int current_column, count = 0, index;
    char *p,*t;
	const char* sep = separator.c_str();

    map<unsigned int,unsigned int> col_map;
    for(unsigned int i = 0; i < mColumnCount; i++) {
        col_map[cols[i]] = i;
    };	

    while (count < process_count && fgets(line, 1000, file_p) != NULL) {
        strtok(line, "\n");
        current_column = 0;

        for(t=mystrtok(&p,line,*sep); t; t=mystrtok(&p,0,*sep)) {
            current_column++;
            if(col_map.find(current_column) == col_map.end()) {
                continue;
            };

            index = col_map[current_column];
            if (type[index] == 0) {
                if (strchr(t,'-') == NULL) {
                    (h_columns_int[type_index[index]])[count] = atoll(t);
                }
                else {   // handling possible dates
                    strncpy(t+4,t+5,2);
                    strncpy(t+6,t+8,2);
                    t[8] = '\0';
                    (h_columns_int[type_index[index]])[count] = atoll(t);
                };
            }
            else if (type[index] == 1) {
                (h_columns_float[type_index[index]])[count] = atoff(t);
            }
            else  {//char
                strcpy(h_columns_char[type_index[index]] + count*char_size[type_index[index]], t);
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
	
    for(unsigned int i = 0; i < mColumnCount; i++ ) {
		if(type[i] == 2 && h_columns_char[type_index[i]]) {
            delete [] h_columns_char[type_index[i]];
            h_columns_char[type_index[i]] = NULL;
        }
        else {
            if(type[i] == 0 ) {
                h_columns_int[type_index[i]].resize(0);
                h_columns_int[type_index[i]].shrink_to_fit();
            }
            else if(type[i] == 1) {
                h_columns_float[type_index[i]].resize(0);
                h_columns_float[type_index[i]].shrink_to_fit();
            };			
        }
    };
	
	prm_d.resize(0);
	prm_d.shrink_to_fit();
	deAllocOnDevice();
	
    delete type;
	delete decimal;
	if(grp_type)
		delete grp_type;
    delete cols;
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
    type = new unsigned int[mColumnCount];
    cols = new unsigned int[mColumnCount];
    decimal = new bool[mColumnCount];
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
				cout << "presorted on " << idx << endl;
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
		
        columnNames[nameRef.front()] = i;
        cols[i] = colsRef.front();

		if (((typeRef.front()).compare("decimal") == 0) || ((typeRef.front()).compare("int") == 0)) {
			f1 = file_name + "." + nameRef.front() + ".0";		
			f = fopen (f1.c_str() , "rb" );
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
			ref_sets[i] = array;
			delete [] array;	
			unsigned int segs, seg_num, curr_seg;
			size_t res_count;
			fread(&len, 4, 1, f);
			char* array1 = new char[len];
		    fread((void*)array1, len, 1, f);
			ref_cols[i] = array1;
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
						ref_joins[i][curr_seg].insert(seg_num);
					else	
						ref_joins[i][curr_seg].insert(std::numeric_limits<unsigned int>::max());
				};
				bytes_read = fread((void*)&curr_seg, 4, 1, f);					
			};				
			fclose(f);
		};		
		
		
        
        if ((typeRef.front()).compare("int") == 0) {
            type[i] = 0;
            decimal[i] = 0;
			h_columns_int.push_back(thrust::host_vector<int_type, pinned_allocator<int_type> >());
            d_columns_int.push_back(thrust::device_vector<int_type>());
            type_index[i] = h_columns_int.size()-1;
        }
        else if ((typeRef.front()).compare("float") == 0) {
            type[i] = 1;
            decimal[i] = 0;
			h_columns_float.push_back(thrust::host_vector<float_type, pinned_allocator<float_type> >());
            d_columns_float.push_back(thrust::device_vector<float_type >());
            type_index[i] = h_columns_float.size()-1;
        }
        else if ((typeRef.front()).compare("decimal") == 0) {
            type[i] = 1;
            decimal[i] = 1;
			h_columns_float.push_back(thrust::host_vector<float_type, pinned_allocator<float_type> >());
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



void CudaSet::initialize(queue<string> &nameRef, queue<string> &typeRef, queue<int> &sizeRef, queue<int> &colsRef, size_t Recs, queue<string> &references, queue<string> &references_names)
{
    mColumnCount = (unsigned int)nameRef.size();
    type = new unsigned int[mColumnCount];
    cols = new unsigned int[mColumnCount];
    decimal = new bool[mColumnCount];
    prealloc_char_size = 0;

    tmp_table = 0;
    filtered = 0;

    mRecCount = Recs;
    hostRecCount = Recs;
    segCount = 1;

    for(unsigned int i=0; i < mColumnCount; i++) {

        columnNames[nameRef.front()] = i;
        cols[i] = colsRef.front();

        if ((typeRef.front()).compare("int") == 0) {
            type[i] = 0;
            decimal[i] = 0;
            h_columns_int.push_back(thrust::host_vector<int_type, pinned_allocator<int_type> >());
            d_columns_int.push_back(thrust::device_vector<int_type>());
            type_index[i] = h_columns_int.size()-1;
        }
        else if ((typeRef.front()).compare("float") == 0) {
            type[i] = 1;
            decimal[i] = 0;
            h_columns_float.push_back(thrust::host_vector<float_type, pinned_allocator<float_type> >());
            d_columns_float.push_back(thrust::device_vector<float_type>());
            type_index[i] = h_columns_float.size()-1;
        }
        else if ((typeRef.front()).compare("decimal") == 0) {
            type[i] = 1;
            decimal[i] = 1;
            h_columns_float.push_back(thrust::host_vector<float_type, pinned_allocator<float_type> >());
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
		
		if(!references.front().empty()) {
			ref_sets[i] = references.front();
			ref_cols[i] = references_names.front();
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

    type = new unsigned int[mColumnCount];
    cols = new unsigned int[mColumnCount];
    decimal = new bool[mColumnCount];
    filtered = 0;

    for(unsigned int i =0; i < mColumnCount; i++) {
        cols[i] = i;
    };


};


void CudaSet::initialize(queue<string> op_sel, queue<string> op_sel_as)
{
    mRecCount = 0;
    mColumnCount = (unsigned int)op_sel.size();

    type = new unsigned int[mColumnCount];
    cols = new unsigned int[mColumnCount];
    decimal = new bool[mColumnCount];

    segCount = 1;
    not_compressed = 1;
    filtered = 0;
    col_aliases = op_sel_as;
    prealloc_char_size = 0;

    unsigned int index;
    unsigned int i = 0;
    while(!op_sel.empty()) {

        if(!setMap.count(op_sel.front())) {
            cout << "coudn't find column " << op_sel.front() << endl;
            exit(0);
        };


        CudaSet* a = varNames[setMap[op_sel.front()]];

        if(i == 0)
            maxRecs = a->maxRecs;

        index = a->columnNames[op_sel.front()];
        cols[i] = i;
        decimal[i] = a->decimal[i];
        columnNames[op_sel.front()] = i;

        if (a->type[index] == 0)  {
            d_columns_int.push_back(thrust::device_vector<int_type>());
            h_columns_int.push_back(thrust::host_vector<int_type, pinned_allocator<int_type> >());
            type[i] = 0;
            type_index[i] = h_columns_int.size()-1;
        }
        else if ((a->type)[index] == 1) {
            d_columns_float.push_back(thrust::device_vector<float_type>());
            h_columns_float.push_back(thrust::host_vector<float_type, pinned_allocator<float_type> >());
            type[i] = 1;
            type_index[i] = h_columns_float.size()-1;
        }
        else {
            h_columns_char.push_back(NULL);
            d_columns_char.push_back(NULL);
            type[i] = 2;
            type_index[i] = h_columns_char.size()-1;
            char_size.push_back(a->char_size[a->type_index[index]]);
        };
        i++;
        op_sel.pop();
    };

}


void CudaSet::initialize(CudaSet* a, CudaSet* b, queue<string> op_sel, queue<string> op_sel_as)
{
    mRecCount = 0;
    mColumnCount = 0;
    queue<string> q_cnt(op_sel);
    unsigned int i = 0;
    set<string> field_names;
    while(!q_cnt.empty()) {
        if(a->columnNames.find(q_cnt.front()) !=  a->columnNames.end() || b->columnNames.find(q_cnt.front()) !=  b->columnNames.end())  {
            field_names.insert(q_cnt.front());
        };
        q_cnt.pop();
    }
    mColumnCount = (unsigned int)field_names.size();

    type = new unsigned int[mColumnCount];
    cols = new unsigned int[mColumnCount];
    decimal = new bool[mColumnCount];
    maxRecs = b->maxRecs;

    map<string,unsigned int>::iterator it;

    segCount = 1;
    filtered = 0;
    not_compressed = 1;

    col_aliases = op_sel_as;
    prealloc_char_size = 0;

    unsigned int index;
    i = 0;
    while(!op_sel.empty() && (columnNames.find(op_sel.front()) ==  columnNames.end())) {

        if((it = a->columnNames.find(op_sel.front())) !=  a->columnNames.end()) {
            index = it->second;
            cols[i] = i;
            decimal[i] = a->decimal[i];
            columnNames[op_sel.front()] = i;

            if (a->type[index] == 0)  {
                d_columns_int.push_back(thrust::device_vector<int_type>());
                h_columns_int.push_back(thrust::host_vector<int_type, pinned_allocator<int_type> >());
                type[i] = 0;
                type_index[i] = h_columns_int.size()-1;
            }
            else if ((a->type)[index] == 1) {
                d_columns_float.push_back(thrust::device_vector<float_type>());
                h_columns_float.push_back(thrust::host_vector<float_type, pinned_allocator<float_type> >());
                type[i] = 1;
                type_index[i] = h_columns_float.size()-1;
            }
            else {
                h_columns_char.push_back(NULL);
                d_columns_char.push_back(NULL);
                type[i] = 2;
                type_index[i] = h_columns_char.size()-1;
                char_size.push_back(a->char_size[a->type_index[index]]);
            };
            i++;
        }
        else if((it = b->columnNames.find(op_sel.front())) !=  b->columnNames.end()) {
            index = it->second;
            columnNames[op_sel.front()] = i;
            cols[i] = i;
            decimal[i] = b->decimal[index];

            if ((b->type)[index] == 0) {
                d_columns_int.push_back(thrust::device_vector<int_type>());
                h_columns_int.push_back(thrust::host_vector<int_type, pinned_allocator<int_type> >());
                type[i] = 0;
                type_index[i] = h_columns_int.size()-1;
            }
            else if ((b->type)[index] == 1) {
                d_columns_float.push_back(thrust::device_vector<float_type>());
                h_columns_float.push_back(thrust::host_vector<float_type, pinned_allocator<float_type> >());
                type[i] = 1;
                type_index[i] = h_columns_float.size()-1;
            }
            else {
                h_columns_char.push_back(NULL);
                d_columns_char.push_back(NULL);
                type[i] = 2;
                type_index[i] = h_columns_char.size()-1;
                char_size.push_back(b->char_size[b->type_index[index]]);
            };
            i++;
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
    if(a->filtered) {
        size_t max_sz = max_tmp(a) ;
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
                    a->allocColumnOnDevice(idx, a->maxRecs);
                }
            }
            fields.pop();
        };
    };
}



void gatherColumns(CudaSet* a, CudaSet* t, string field, unsigned int segment, size_t& count)
{

    unsigned int tindex = t->columnNames[field];
    unsigned int idx = a->columnNames[field];

    if(!a->onDevice(idx)) {
        a->allocColumnOnDevice(idx, a->maxRecs);
    };

    if(a->prm_index == 'R') {
        mygather(tindex, idx, a, t, count, a->mRecCount);
    }
    else {
        mycopy(tindex, idx, a, t, count, t->mRecCount);
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
        if(rsz) {		    
            a->resizeDevice(count);
            a->devRecCount = count+a->mRecCount;
        };
    };


	while(!fields.empty()) {
        if (uniques.count(fields.front()) == 0 && setMap.count(fields.front()) > 0)	{
            if(a->filtered) {
                if(a->mRecCount) {
                    CudaSet *t = varNames[setMap[fields.front()]];
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



void mygather(unsigned int tindex, unsigned int idx, CudaSet* a, CudaSet* t, size_t offset, size_t g_size)
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
                       (void*)t->d_columns_char[t->type_index[tindex]], (void*)(a->d_columns_char[a->type_index[idx]] + offset*a->char_size[a->type_index[idx]]), (unsigned int)a->char_size[a->type_index[idx]] );
        }
        else {
            str_gather((void*)thrust::raw_pointer_cast(a->prm_d.data()), g_size,
                       alloced_tmp, (void*)(a->d_columns_char[a->type_index[idx]] + offset*a->char_size[a->type_index[idx]]), (unsigned int)a->char_size[a->type_index[idx]] );
        };
    }
};

void mycopy(unsigned int tindex, unsigned int idx, CudaSet* a, CudaSet* t, size_t offset, size_t g_size)
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



size_t load_queue(queue<string> c1, CudaSet* right, bool str_join, string f2, size_t &rcount,
                  unsigned int start_segment, unsigned int end_segment, bool rsz, bool flt)
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
    if(!str_join && right->columnNames.find(f2) !=  right->columnNames.end()) {
        cc.push(f2);
    };

    if(right->filtered) {
        allocColumns(right, cc);
        rcount = right->maxRecs;
    }
    else
        rcount = right->mRecCount;

    queue<string> ct(cc);

    while(!ct.empty()) {
        if(right->filtered && rsz) {
            right->mRecCount = 0;
        }
        else {
            right->allocColumnOnDevice(right->columnNames[ct.front()], rcount);
		};	
        ct.pop();
    };


    size_t cnt_r = 0;
    for(unsigned int i = start_segment; i < end_segment; i++) {
        if(!right->filtered)
            copyColumns(right, cc, i, cnt_r, rsz, 0);
        else
            copyColumns(right, cc, i, cnt_r, rsz, flt);
        cnt_r = cnt_r + right->mRecCount;
		//cout << "RIGHT SEG " <<  i << " " << cnt_r << " " << right->d_columns_int[1][0] << "-" << right->d_columns_int[1][cnt_r-1] << endl;			
    };
    right->mRecCount = cnt_r;
    return cnt_r;

}

size_t max_char(CudaSet* a)
{
    size_t max_char1 = 8;
    for(unsigned int i = 0; i < a->char_size.size(); i++)
        if (a->char_size[i] > max_char1)
            max_char1 = a->char_size[i];

    return max_char1;
};

size_t max_char(CudaSet* a, set<string> field_names)
{
    size_t max_char1 = 8, i;
    for (set<string>::iterator it=field_names.begin(); it!=field_names.end(); ++it) {
        i = a->columnNames[*it];
        if (a->type[i] == 2) {
            if (a->char_size[a->type_index[i]] > max_char1)
                max_char1 = a->char_size[a->type_index[i]];
        };
    };
    return max_char1;
};

size_t max_char(CudaSet* a, queue<string> field_names)
{
    size_t max_char = 8, i;
    while (!field_names.empty()) {
        i = a->columnNames[field_names.front()];
        if (a->type[i] == 2) {
            if (a->char_size[a->type_index[i]] > max_char)
                max_char = a->char_size[a->type_index[i]];
        };
        field_names.pop();
    };
    return max_char;
};



size_t max_tmp(CudaSet* a)
{
    size_t max_sz = 0;
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
    size_t m_char = max_char(a);
    if(m_char > max_sz)
        return m_char;
    else
        return max_sz;

};


void setSegments(CudaSet* a, queue<string> cols)
{
    size_t mem_available = getFreeMem();
    size_t tot_sz = 0, idx;
    while(!cols.empty()) {
        idx = a->columnNames[cols.front()];
        if(a->type[idx] != 2)
            tot_sz = tot_sz + int_size;
        else
            tot_sz = tot_sz + a->char_size[a->type_index[idx]];
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
	
    if(a->mRecCount == 0) {
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

		//cout << "MAP CHECK start " << segment <<  endl;	
		char map_check = zone_map_check(b->fil_type,b->fil_value,b->fil_nums, b->fil_nums_f, a, segment);
		//cout << "MAP CHECK segment " << segment << " " << map_check <<  endl;
		
        if(map_check == 'R') {
            copyColumns(a, b->fil_value, segment, cnt);	
            bool* res = filter(b->fil_type,b->fil_value,b->fil_nums, b->fil_nums_f, a, segment);
		    thrust::device_ptr<bool> bp((bool*)res);    
			b->prm_index = 'R';
			b->mRecCount = thrust::count(bp, bp + (unsigned int)a->mRecCount, 1);
			thrust::copy_if(thrust::make_counting_iterator((unsigned int)0), thrust::make_counting_iterator((unsigned int)a->mRecCount),
							bp, b->prm_d.begin(), thrust::identity<bool>());
			if(segment == a->segCount-1)
				b->type_index = a->type_index;
			cudaFree(res);
        }
        else  {
            setPrm(a,b,map_check,segment);
        };
        if(segment == a->segCount-1)
            a->deAllocOnDevice();
    }
	//cout << endl << "filter res " << b->mRecCount << endl;		
    //std::cout<< "filter time " <<  ( ( std::clock() - start1 ) / (double)CLOCKS_PER_SEC ) << " " << getFreeMem() << '\n';	
}


void sort_right(CudaSet* right, unsigned int colInd2, string f2, queue<string> op_g, queue<string> op_sel,
                bool decimal_join, bool& str_join, size_t& rcount) {
		
	size_t cnt_r = 0;		
    right->hostRecCount = right->mRecCount;
   
    if (right->type[colInd2]  == 2) {
        str_join = 1;
        right->d_columns_int.push_back(thrust::device_vector<int_type>());
        for(unsigned int i = 0; i < right->segCount; i++) {
            right->add_hashed_strings(f2, i, right->d_columns_int.size()-1);
        };
        cnt_r = right->d_columns_int[right->d_columns_int.size()-1].size();
    };

	
	//sort the segments and merge them on a host
	
    // need to allocate all right columns
		queue<string> op_alt1;
		op_alt1.push(f2);
		cnt_r = load_queue(op_alt1, right, str_join, "", rcount, 0, right->segCount);

		if(str_join) {
			colInd2 = right->mColumnCount+1;
			right->type_index[colInd2] = right->d_columns_int.size()-1;
		};	

		//here we need to make sure that right column is ordered. If not then we order it and keep the permutation
		bool sorted;

		if(str_join || !decimal_join) {
			sorted = thrust::is_sorted(right->d_columns_int[right->type_index[colInd2]].begin(), right->d_columns_int[right->type_index[colInd2]].begin() + cnt_r);
		}
		else
			sorted = thrust::is_sorted(right->d_columns_float[right->type_index[colInd2]].begin(), right->d_columns_float[right->type_index[colInd2]].begin() + cnt_r);


		if(!sorted) {
		
			thrust::device_ptr<unsigned int> v = thrust::device_malloc<unsigned int>(cnt_r);
			thrust::sequence(v, v + cnt_r, 0, 1);
			thrust::sort_by_key(right->d_columns_int[right->type_index[colInd2]].begin(), right->d_columns_int[right->type_index[colInd2]].begin() + cnt_r, v);
			thrust::copy(right->d_columns_int[right->type_index[colInd2]].begin(), right->d_columns_int[right->type_index[colInd2]].begin() + cnt_r, right->h_columns_int[right->type_index[colInd2]].begin());			

			right->resize(cnt_r);
			
			right->deAllocColumnOnDevice(colInd2);		
			
			void* d;
			CUDA_SAFE_CALL(cudaMalloc((void **) &d, cnt_r*max_char(right)));
			
			unsigned int i;
			while(!op_sel.empty()) {		
				if (right->columnNames.find(op_sel.front()) != right->columnNames.end()) {
					i = right->columnNames[op_sel.front()];

					if(i != colInd2) {

						queue<string> op_alt2;
						op_alt2.push(op_sel.front());
						cnt_r = load_queue(op_alt2, right, str_join, "", rcount, 0, right->segCount, 0, 0);
						cout << "next load " << cnt_r << endl;

						if(right->type[i] == 0) {
							thrust::device_ptr<int_type> d_tmp((int_type*)d);
							thrust::gather(v, v+cnt_r, right->d_columns_int[right->type_index[i]].begin(), d_tmp);
							thrust::copy(d_tmp, d_tmp + cnt_r, right->h_columns_int[right->type_index[i]].begin());
						}
						else if(right->type[i] == 1) {
							thrust::device_ptr<float_type> d_tmp((float_type*)d);
							thrust::gather(v, v+cnt_r, right->d_columns_float[right->type_index[i]].begin(), d_tmp);
							thrust::copy(d_tmp, d_tmp + cnt_r, right->h_columns_float[right->type_index[i]].begin());
						}
						else {
							thrust::device_ptr<char> d_tmp((char*)d);
							str_gather(thrust::raw_pointer_cast(v), cnt_r, (void*)right->d_columns_char[right->type_index[i]], (void*) thrust::raw_pointer_cast(d_tmp), right->char_size[right->type_index[i]]);			
							cudaMemcpy( (void*)right->h_columns_char[right->type_index[i]], (void*) thrust::raw_pointer_cast(d_tmp), cnt_r*right->char_size[right->type_index[i]], cudaMemcpyDeviceToHost);
						};
						right->deAllocColumnOnDevice(i);
					};
				};
				op_sel.pop();
			};
			thrust::device_free(v);
			cudaFree(d);
			right->not_compressed = 1;
		}								
}						


size_t load_right(CudaSet* right, unsigned int colInd2, string f2, queue<string> op_g, queue<string> op_sel,
                        queue<string> op_alt, bool decimal_join, bool& str_join,
                        size_t& rcount, unsigned int start_seg, unsigned int end_seg, bool rsz) {

    size_t cnt_r = 0;
    right->hostRecCount = right->mRecCount;
    //if join is on strings then add integer columns to left and right tables and modify colInd1 and colInd2

    if (right->type[colInd2]  == 2) {
        str_join = 1;
        right->d_columns_int.push_back(thrust::device_vector<int_type>());
        for(unsigned int i = start_seg; i < end_seg; i++) {
            right->add_hashed_strings(f2, i, right->d_columns_int.size()-1);
        };
        cnt_r = right->d_columns_int[right->d_columns_int.size()-1].size();
    };

    // need to allocate all right columns    
    if(right->not_compressed) {
        queue<string> op_alt1;
        op_alt1.push(f2);
        cnt_r = load_queue(op_alt1, right, str_join, "", rcount, start_seg, end_seg, rsz, 1);
    }
    else {
        cnt_r = load_queue(op_alt, right, str_join, f2, rcount, start_seg, end_seg, rsz, 1);
    };

    if(str_join) {
        colInd2 = right->mColumnCount+1;
        right->type_index[colInd2] = right->d_columns_int.size()-1;
    };	

    if(right->not_compressed) {
        queue<string> op_alt1;
        while(!op_alt.empty()) {
            if(f2.compare(op_alt.front())) {
                if (right->columnNames.find(op_alt.front()) != right->columnNames.end()) {
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
	unsigned int tot_size = left->maxRecs*8;
	
	while(!op_sel.empty()) {
		if (right->columnNames.find(op_sel.front()) != right->columnNames.end()) {
					
		    if(right->type[right->columnNames[op_sel.front()]] <= 1) {
				tot_size = tot_size + right->maxRecs*8*right->segCount;
            }
            else {
				tot_size = tot_size + right->maxRecs*
									  right->char_size[right->type_index[right->columnNames[op_sel.front()]]]*
									  right->segCount;
			};
        };		
		op_sel.pop();			
	};		
	
	if(tot_size + 300000000 < getFreeMem())
		return right->segCount;
	else {	
		if(right->segCount == 1) { //need to partition it. Not compressed.
			right->segCount = ((tot_size + 300000000)/getFreeMem())+1;
			right->maxRecs = (right->mRecCount/right->segCount)+1;
			return 1;
		}
		else { //compressed
			return right->segCount / ((tot_size+300000000)/getFreeMem());
		};				
	};	
		
};


string int_to_string(int number){
    string number_string = "";
    char ones_char;
    int ones = 0;
    while(true){
        ones = number % 10;
        switch(ones){
            case 0: ones_char = '0'; break;
            case 1: ones_char = '1'; break;
            case 2: ones_char = '2'; break;
            case 3: ones_char = '3'; break;
            case 4: ones_char = '4'; break;
            case 5: ones_char = '5'; break;
            case 6: ones_char = '6'; break;
            case 7: ones_char = '7'; break;
            case 8: ones_char = '8'; break;
            case 9: ones_char = '9'; break;
            default : cout << ("Trouble converting number to string.");
        }
        number -= ones;
        number_string = ones_char + number_string;
        if(number == 0){
            break;
        }
        number = number/10;
    }
    return number_string;
}


void insert_records(char* f, char* s) {
	char buf[4096];
    size_t size, maxRecs;
	string str_s, str_d;	

	if(varNames.find(s) == varNames.end()) {
		cout << "couldn't find " << s << endl;
		exit(0);
	};	
	CudaSet *a;
    a = varNames.find(s)->second;
    a->name = s;	
	
	if(varNames.find(f) == varNames.end()) {
		cout << "couldn't find " << f << endl;
		exit(0);
	};	
	
	CudaSet *b;
    b = varNames.find(f)->second;
    b->name = f;	
	
	// if both source and destination are on disk
	if(a->source && b->source) {
		for(unsigned int i = 0; i < a->segCount; i++) {          	
			//for(unsigned int z = 0; z< a->mColumnCount; z++) {							
			for (map<string,unsigned int>::iterator it=a->columnNames.begin() ; it != a->columnNames.end(); ++it ) {
				str_s = a->load_file_name + "." + it->first + "." + int_to_string(i);		
				str_d = b->load_file_name + "." + it->first + "." + int_to_string(b->segCount + i);
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
		
		for (map<string,unsigned int>::iterator it=b->columnNames.begin() ; it != b->columnNames.end(); ++it ) {
			b->reWriteHeader(b->load_file_name, it->first, a->segCount + b->segCount, a->totalRecs + b->totalRecs, maxRecs);				
		};		
	}
 	else if(!a->source && !b->source) { //if both source and destination are in memory
		size_t oldCount = b->mRecCount;
		b->resize(a->mRecCount);		
		for(unsigned int z = 0; z< b->mColumnCount; z++) {	
			if(b->type[z] == 0) {
				thrust::copy(a->h_columns_int[a->type_index[z]].begin(), a->h_columns_int[a->type_index[z]].begin() + a->mRecCount, b->h_columns_int[b->type_index[z]].begin() + oldCount);
			}
			else if(b->type[z] == 1) {
				thrust::copy(a->h_columns_float[a->type_index[z]].begin(), a->h_columns_float[a->type_index[z]].begin() + a->mRecCount, b->h_columns_float[b->type_index[z]].begin() + oldCount);			
			}
			else {
				cudaMemcpy(b->h_columns_char[b->type_index[z]] + b->char_size[b->type_index[z]]*oldCount, a->h_columns_char[a->type_index[z]], a->char_size[a->type_index[z]]*a->mRecCount, cudaMemcpyHostToHost);			
			};		
		};	
	}
	else if(!a->source && b->source) {
		
		total_segments = b->segCount;
		total_count = a->mRecCount;
		total_max = process_count;
		unsigned int segCount = (a->mRecCount/process_count + 1);
        size_t offset = 0, mCount;

        for(unsigned int z = 0; z < segCount; z++) {
            if(z < segCount-1) {
                if(a->mRecCount < process_count) {
                    mCount = a->mRecCount;
                }
                else {
                    mCount = process_count;
                }
            }
			else {
				mCount = a->mRecCount - (segCount-1)*process_count;			
			};				
			a->compress(b->load_file_name, offset, 0, z - (segCount-1), mCount);
            offset = offset + mCount;
        };
		//update headers
		total_count = a->mRecCount + b->mRecCount;
		//cout << "and now lets write " << a->mRecCount << " " <<  b->mRecCount << endl;
		for (map<string,unsigned int>::iterator it=b->columnNames.begin() ; it != b->columnNames.end(); ++it ) {
			b->writeHeader(b->load_file_name, it->first, total_segments);
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
		cout << "Delete operator is only applicable to disk based sets" << endl;
		cout << "for deleting records from derived sets please use filter operator " << endl;
		exit(0);
    }
    else {  // read matching segments, delete, compress and write on a disk replacing the original segments

		string str, str_old;
	    queue<string> op_vx;
		size_t cnt;
		for (map<string,unsigned int>::iterator it=a->columnNames.begin() ; it != a->columnNames.end(); ++it ) {
            op_vx.push((*it).first);        		
		};	
		allocColumns(a, op_vx);
		a->prm_d.resize(a->maxRecs);
		a->resize(a->maxRecs);
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
					
					//cout << "Remained recs count " << a->mRecCount << endl;
					if(a->mRecCount > maxRecs)
						maxRecs = a->mRecCount;
										
					if (a->mRecCount) {
					
					    totalRemoved = totalRemoved + (tmp - a->mRecCount);
					    if (a->mRecCount == tmp) { //none deleted
							//cout << "rename " << i << " to " << new_seg_count << endl;
							if(new_seg_count != i) {
								//for(unsigned int z = 0; z< a->mColumnCount; z++) {
								for (map<string,unsigned int>::iterator it=a->columnNames.begin() ; it != a->columnNames.end(); ++it ) {
							
									str_old = a->load_file_name + "." + it->first;
									str_old += "." + int_to_string(i);
									str = a->load_file_name + "." + it->first;
									str += "." + int_to_string(new_seg_count);								
								
									remove(str.c_str());
									rename(str_old.c_str(), str.c_str());
								};	
							};   
							new_seg_count++;
							
						}
						else { //some deleted
					        //cout << "writing segment " << new_seg_count << endl;
							//for(unsigned int z = 0; z< a->mColumnCount; z++) {
							for (map<string,unsigned int>::iterator it=a->columnNames.begin() ; it != a->columnNames.end(); ++it ) {
								unsigned int z = it->second;
								str = a->load_file_name + "." + it->first;
								str += "." + int_to_string(new_seg_count);

								if(a->type[z] == 0) {
									thrust::device_ptr<int_type> d_col((int_type*)d);
									thrust::gather(a->prm_d.begin(), a->prm_d.begin() + a->mRecCount, a->d_columns_int[a->type_index[z]].begin(), d_col);				
									pfor_compress( d, a->mRecCount*int_size, str, a->h_columns_int[a->type_index[z]], 0);
								}
								else if(a->type[z] == 1){
									thrust::device_ptr<float_type> d_col((float_type*)d);
									if(a->decimal[z]) {
										thrust::gather(a->prm_d.begin(), a->prm_d.begin() + a->mRecCount, a->d_columns_float[a->type_index[z]].begin(), d_col);
										thrust::device_ptr<long long int> d_col_dec((long long int*)d);
										thrust::transform(d_col,d_col+a->mRecCount, d_col_dec, float_to_long());
										pfor_compress( d, a->mRecCount*float_size, str, a->h_columns_float[a->type_index[z]], 1);					
									}
									else {
										thrust::gather(a->prm_d.begin(), a->prm_d.begin() + a->mRecCount, a->d_columns_float[a->type_index[z]].begin(), d_col);
										thrust::copy(d_col, d_col + a->mRecCount, a->h_columns_float[a->type_index[z]].begin());	
										fstream binary_file(str.c_str(),ios::out|ios::binary);
										binary_file.write((char *)&a->mRecCount, 4);
										binary_file.write((char *)(a->h_columns_float[a->type_index[z]].data()),a->mRecCount*float_size);
										unsigned int comp_type = 3;
										binary_file.write((char *)&comp_type, 4);
										binary_file.close();													
									
									};
								}
								else {								
							        void* t;
									CUDA_SAFE_CALL(cudaMalloc((void **) &t, tmp*a->char_size[a->type_index[z]]));
									apply_permutation_char(a->d_columns_char[a->type_index[z]], (unsigned int*)thrust::raw_pointer_cast(a->prm_d.data()), tmp, (char*)t, a->char_size[a->type_index[z]]);
									cudaMemcpy(a->h_columns_char[a->type_index[z]], t, a->char_size[a->type_index[z]]*a->mRecCount, cudaMemcpyDeviceToHost);
									cudaFree(t);
									a->compress_char(str, z, a->mRecCount, 0);
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
					for (map<string,unsigned int>::iterator it=a->columnNames.begin() ; it != a->columnNames.end(); ++it ) {
							
						str_old = a->load_file_name + "." + it->first;
						str_old += "." + int_to_string(i);
						str = a->load_file_name + "." + it->first;
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
				//for(unsigned int z = 0; z< a->mColumnCount; z++) {							
				for (map<string,unsigned int>::iterator it=a->columnNames.begin() ; it != a->columnNames.end(); ++it ) {
					str = a->load_file_name + "." + it->first;
					str += "." + int_to_string(i);								
					remove(str.c_str());	
				};	
			};					
		};
		
		for (map<string,unsigned int>::iterator it=a->columnNames.begin() ; it != a->columnNames.end(); ++it ) {
			a->reWriteHeader(a->load_file_name, it->first, new_seg_count, a->totalRecs-totalRemoved, maxRecs);				
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
