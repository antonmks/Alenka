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

size_t total_count = 0, total_max;
clock_t tot;
unsigned int total_segments = 0;
unsigned int process_count;
size_t alloced_sz = 0;
bool fact_file_loaded = 1;
bool verbose;
bool interactive, ssd, delta, star;
void* d_v = nullptr;
void* s_v = nullptr;
queue<string> op_sort;
queue<string> op_presort;
queue<string> op_type;
bool op_case = 0;
queue<string> op_value;
queue<int_type> op_nums;
queue<float_type> op_nums_f;
queue<string> col_aliases;
map<string, map<string, col_data> > data_dict;
unordered_map<string, unordered_map<unsigned long long int, size_t> > char_hash;

map<string, char*> index_buffers;
map<string, char*> buffers;
map<string, size_t> buffer_sizes;
size_t total_buffer_size;
queue<string> buffer_names;

void* alloced_tmp;
bool alloced_switch = 0;
map<string,CudaSet*> varNames; //  STL map to manage CudaSet variables
map<string, unsigned int> cpy_bits;
map<string, long long int> cpy_init_val;

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
size_t getFreeMem();
char zone_map_check(queue<string> op_type, queue<string> op_value, queue<int_type> op_nums,queue<float_type> op_nums_f, CudaSet* a, unsigned int segment);
size_t getTotalSystemMemory();
void process_error(int severity, string err);

CudaSet::CudaSet(queue<string> &nameRef, queue<string> &typeRef, queue<int> &sizeRef, queue<int> &colsRef, size_t Recs, queue<string> &references, queue<string> &references_names)
    : mColumnCount(0), mRecCount(0)
{
    initialize(nameRef, typeRef, sizeRef, colsRef, Recs, references, references_names);
    keep = false;
    source = 1;
    text_source = 1;
    fil_f = nullptr;
    fil_s = nullptr;
};

CudaSet::CudaSet(queue<string> &nameRef, queue<string> &typeRef, queue<int> &sizeRef, queue<int> &colsRef, size_t Recs, string file_name, unsigned int max)
    : mColumnCount(0),  mRecCount(0)
{
    maxRecs = max;
    initialize(nameRef, typeRef, sizeRef, colsRef, Recs, file_name);
    keep = false;
    source = 1;
    text_source = 0;
    fil_f = nullptr;
    fil_s = nullptr;
};

CudaSet::CudaSet(const size_t RecordCount, const unsigned int ColumnCount)
{
    initialize(RecordCount, ColumnCount);
    keep = false;
    source = 0;
    text_source = 0;
    fil_f = nullptr;
    fil_s = nullptr;
};


CudaSet::CudaSet(queue<string> op_sel, const queue<string> op_sel_as)
{
    initialize(op_sel, op_sel_as);
    keep = false;
    source = 0;
    text_source = 0;
    fil_f = nullptr;
    fil_s = nullptr;
};

CudaSet::CudaSet(CudaSet* a, CudaSet* b, queue<string> op_sel, queue<string> op_sel_as)
{
    initialize(a,b, op_sel, op_sel_as);
    keep = false;
    source = 0;
    text_source = 0;
    fil_f = nullptr;
    fil_s = nullptr;
};


CudaSet::~CudaSet()
{
    free();
};


void CudaSet::allocColumnOnDevice(string colname, size_t RecordCount)
{
    if (type[colname] != 1 ) {
        d_columns_int[colname].resize(RecordCount);
    }
    else 
        d_columns_float[colname].resize(RecordCount);
};


void CudaSet::resize_join(size_t addRecs)
{
    mRecCount = mRecCount + addRecs;
    for(unsigned int i=0; i < columnNames.size(); i++) {
        if(type[columnNames[i]] != 1) {
            h_columns_int[columnNames[i]].resize(mRecCount);
        }
        else
            h_columns_float[columnNames[i]].resize(mRecCount);
    };
};


void CudaSet::resize(size_t addRecs)
{
    mRecCount = mRecCount + addRecs;
    for(unsigned int i=0; i < columnNames.size(); i++) {
        if(type[columnNames[i]] != 1) {
            h_columns_int[columnNames[i]].resize(mRecCount);
        }
        else {
            h_columns_float[columnNames[i]].resize(mRecCount);
        }
    };
};

void CudaSet::deAllocColumnOnDevice(string colname)
{
    if (type[colname] != 1 && !d_columns_int.empty()) {
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

    for (auto it=d_columns_int.begin(); it != d_columns_int.end(); ++it ) {
        if(it->second.size() > 0) {
            it->second.resize(0);
            it->second.shrink_to_fit();
        };
    };

    for (auto it=d_columns_float.begin(); it != d_columns_float.end(); ++it ) {
        if(it->second.size() > 0) {
            it->second.resize(0);
            it->second.shrink_to_fit();
        };
    };

    if(filtered) { // free the sources
        if(varNames.find(source_name) != varNames.end()) {
            varNames[source_name]->deAllocOnDevice();
        };
    };
};

void CudaSet::resizeDeviceColumn(size_t RecCount, string colname)
{
    if (type[colname] != 1) {
        d_columns_int[colname].resize(RecCount);
    }
    else 
        d_columns_float[colname].resize(RecCount);
};

void CudaSet::resizeDevice(size_t RecCount)
{
    for(unsigned int i=0; i < columnNames.size(); i++) {
        resizeDeviceColumn(RecCount, columnNames[i]);
    };
};

bool CudaSet::onDevice(string colname)
{
    if (type[colname] != 1) {
        if (!d_columns_int.empty() && d_columns_int[colname].size())
            return 1;
    }
    else 
        if (!d_columns_float.empty() && d_columns_float[colname].size())
            return 1;
    return 0;
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
            a->h_columns_char[columnNames[i]] = nullptr;
            a->d_columns_char[columnNames[i]] = nullptr;
        };
    };
    a->load_file_name = load_file_name;
    a->mRecCount = 0;
    return a;
}

int_type CudaSet::readSsdSegmentsFromFile(unsigned int segNum, string colname, size_t offset, thrust::host_vector<unsigned int>& prm_vh, CudaSet* dest)
{
    string f1 = load_file_name + "." + colname + "." + to_string(segNum);
    FILE* f = fopen(f1.c_str(), "rb" );
    if(!f) {
        cout << "Error opening " << f1 << " file " << endl;
        exit(0);
    };

    unsigned int cnt, bits;
    int_type lower_val;

    unsigned short int val_s_r[4096/2];
    char val_c_r[4096];
    unsigned int val_i_r[4096/4];
    unsigned long long int val_l_r[4096/8];
    unsigned int idx;
    bool idx_set = 0;

    fread(&cnt, 4, 1, f);
    fread(&lower_val, 8, 1, f);
    fseek(f, cnt - (8+4) + 32, SEEK_CUR);
    fread(&bits, 4, 1, f);
    //cout << "lower_val bits " << lower_val << " " << bits << endl;

    if(type[colname] == 0) {
        //cout << "lower_val bits " << lower_val << " " << bits << endl;

        for(unsigned int i = 0; i < prm_vh.size(); i++) {

            if(!idx_set ||  prm_vh[i] >= idx + 4096/(bits/8))  {
                fseek(f, 24 + prm_vh[i]*(bits/8), SEEK_SET);
                idx = prm_vh[i];
                idx_set = 1;

                if(bits == 8) {
                    fread(&val_c_r[0], 4096, 1, f);
                    dest->h_columns_int[colname][i + offset] = val_c_r[0];
                }
                else if(bits == 16) {
                    fread(&val_s_r, 4096, 1, f);
                    dest->h_columns_int[colname][i + offset] = val_s_r[0];
                }
                if(bits == 32) {
                    fread(&val_i_r, 4096, 1, f);
                    dest->h_columns_int[colname][i + offset] = val_i_r[0];
                }
                if(bits == 84) {
                    fread(&val_l_r, 4096, 1, f);
                    dest->h_columns_int[colname][i + offset] = val_l_r[0];
                }
            }
            else {
                if(bits == 8) {
                    dest->h_columns_int[colname][i + offset] = val_c_r[prm_vh[i]-idx];
                }
                else if(bits == 16) {
                    dest->h_columns_int[colname][i + offset] = val_s_r[prm_vh[i]-idx];
                }
                if(bits == 32) {
                    dest->h_columns_int[colname][i + offset] = val_i_r[prm_vh[i]-idx];
                }
                if(bits == 84) {
                    dest->h_columns_int[colname][i + offset] = val_l_r[prm_vh[i]-idx];
                }
            };
        };
    }
    else if(type[colname] == 1) {

        for(unsigned int i = 0; i < prm_vh.size(); i++) {
            if(!idx_set ||  prm_vh[i] >= idx + 4096/(bits/8))  {
                fseek(f, 24 + prm_vh[i]*(bits/8), SEEK_SET);
                idx = prm_vh[i];
                idx_set = 1;
                fread(val_c_r, 4096, 1, f);
                memcpy(&dest->h_columns_float[colname][i + offset], &val_c_r[0], bits/8);
            }
            else {
                memcpy(&dest->h_columns_float[colname][i + offset], &val_c_r[(prm_vh[i]-idx)*(bits/8)], bits/8);
            };
        };

    }
    else {
        //no strings in fact tables
    };
    fclose(f);
    return lower_val;
}

int_type CudaSet::readSsdSegmentsFromFileR(unsigned int segNum, string colname, thrust::host_vector<unsigned int>& prm_vh, thrust::host_vector<unsigned int>& dest)
{
    string f1 = load_file_name + "." + colname + "." + to_string(segNum);
    FILE* f = fopen(f1.c_str(), "rb" );
    if(!f) {
        cout << "Error opening " << f1 << " file " << endl;
        exit(0);
    };

    unsigned int cnt, bits;
    int_type lower_val;
    fread(&cnt, 4, 1, f);
    fread(&lower_val, 8, 1, f);
    fseek(f, cnt - (8+4) + 32, SEEK_CUR);
    fread(&bits, 4, 1, f);

    unsigned short int val_s_r[4096/2];
    char val_c_r[4096];
    unsigned int val_i_r[4096/4];
    unsigned long long int val_l_r[4096/8];
    unsigned int idx;
    bool idx_set = 0;

    for(unsigned int i = 0; i < prm_vh.size(); i++) {

        if(!idx_set ||  prm_vh[i] >= idx + 4096/(bits/8))  {
            fseek(f, 24 + prm_vh[i]*(bits/8), SEEK_SET);
            idx = prm_vh[i];
            idx_set = 1;

            if(bits == 8) {
                fread(val_c_r, 4096, 1, f);
                dest[i] = val_c_r[0];
            }
            else if(bits == 16) {
                fread(val_s_r, 4096, 1, f);
                dest[i] = val_s_r[0];
            }
            if(bits == 32) {
                fread(val_i_r, 4096, 1, f);
                dest[i] = val_i_r[0];
            }
            if(bits == 84) {
                fread(val_l_r, 4096, 1, f);
                dest[i] = val_l_r[0];
            }
        }
        else {
            if(bits == 8) {
                dest[i] = val_c_r[prm_vh[i]-idx];
            }
            else if(bits == 16) {
                dest[i] = val_s_r[prm_vh[i]-idx];
            }
            if(bits == 32) {
                dest[i] = val_i_r[prm_vh[i]-idx];
            }
            if(bits == 84) {
                dest[i] = val_l_r[prm_vh[i]-idx];
            }
        };
    };
    fclose(f);
    return lower_val;
}

std::clock_t tot_disk;

void CudaSet::readSegmentsFromFile(unsigned int segNum, string colname, size_t offset)
{
    string f1 = load_file_name + "." + colname + "." + to_string(segNum);
    if(type[colname] == 2)
        f1 = f1 + ".idx";

    std::clock_t start1 = std::clock();

    if(interactive) { //check if data are in buffers
        if(buffers.find(f1) == buffers.end()) { // add data to buffers
            FILE* f = fopen(f1.c_str(), "rb" );
            if(!f) {
                process_error(3, "Error opening " + string(f1) +" file " );
            };
            fseek(f, 0, SEEK_END);
            long fileSize = ftell(f);
            while(total_buffer_size + fileSize > getTotalSystemMemory() && !buffer_names.empty()) { //free some buffers
                //delete [] buffers[buffer_names.front()];
				cudaFreeHost(buffers[buffer_names.front()]);
                total_buffer_size = total_buffer_size - buffer_sizes[buffer_names.front()];
                buffer_sizes.erase(buffer_names.front());
                buffers.erase(buffer_names.front());
                buffer_names.pop();
            };
            fseek(f, 0, SEEK_SET);
			
			char* buff;
			cudaHostAlloc((void**) &buff, fileSize,cudaHostAllocDefault);
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
        if(type[colname] != 1) {
            unsigned int cnt = ((unsigned int*)buffers[f1])[0];
            if(cnt > h_columns_int[colname].size()/8 + 10)
                h_columns_int[colname].resize(cnt/8 + 10);
        }
        else {
            unsigned int cnt = ((unsigned int*)buffers[f1])[0];
            if(cnt > h_columns_float[colname].size()/8 + 10)
                h_columns_float[colname].resize(cnt/8 + 10);
        }
    }
    else {

        FILE* f = fopen(f1.c_str(), "rb" );
        if(!f) {
            cout << "Error opening " << f1 << " file " << endl;
            exit(0);
        };


        if(type[colname] != 1) {
            if(1 > h_columns_int[colname].size())
                h_columns_int[colname].resize(1);
            fread(h_columns_int[colname].data(), 4, 1, f);
            unsigned int cnt = ((unsigned int*)(h_columns_int[colname].data()))[0];
            if(cnt/8+10 > h_columns_int[colname].size())
                h_columns_int[colname].resize(cnt + 10);
            size_t rr = fread((unsigned int*)(h_columns_int[colname].data()) + 1, 1, cnt+52, f);
            if(rr != cnt+52) {
                char buf[1024];
                sprintf(buf, "Couldn't read %d bytes from %s ,read only", cnt+52, f1.c_str());
                process_error(3, string(buf));
            };
        }
        else  {
            if(1 > h_columns_float[colname].size())
                h_columns_float[colname].resize(1);
            fread(h_columns_float[colname].data(), 4, 1, f);
            unsigned int cnt = ((unsigned int*)(h_columns_float[colname].data()))[0];
            if(cnt/8+10 > h_columns_float[colname].size())
                h_columns_float[colname].resize(cnt + 10);
            size_t rr = fread((unsigned int*)(h_columns_float[colname].data()) + 1, 1, cnt+52, f);
            if(rr != cnt+52) {
                char buf[1024];
                sprintf(buf, "Couldn't read %d bytes from %s ,read only", cnt+52, f1.c_str());
                process_error(3, string(buf));
            };
        }
        fclose(f);
    };
    tot_disk =  tot_disk + (std::clock() - start1);
};

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

        if(type[colname] != 1) {
            if(!alloced_switch)
                thrust::copy(h_columns_int[colname].begin() + maxRecs*segment, h_columns_int[colname].begin() + maxRecs*segment + mRecCount, d_columns_int[colname].begin() + offset);
            else {
                thrust::device_ptr<int_type> d_col((int_type*)alloced_tmp);
                thrust::copy(h_columns_int[colname].begin() + maxRecs*segment, h_columns_int[colname].begin() + maxRecs*segment + mRecCount, d_col);
            };
        }
        else {
            if(!alloced_switch) {
                thrust::copy(h_columns_float[colname].begin() + maxRecs*segment, h_columns_float[colname].begin() + maxRecs*segment + mRecCount, d_columns_float[colname].begin() + offset);
            }
            else {
                thrust::device_ptr<float_type> d_col((float_type*)alloced_tmp);
                thrust::copy(h_columns_float[colname].begin() + maxRecs*segment, h_columns_float[colname].begin() + maxRecs*segment + mRecCount, d_col);
            };
        }
    }
    else {

        readSegmentsFromFile(segment,colname, offset);
        if(!d_v)
            CUDA_SAFE_CALL(cudaMalloc((void **) &d_v, 12));
        if(!s_v)
            CUDA_SAFE_CALL(cudaMalloc((void **) &s_v, 8));

        string f1;
        if(type[colname] == 2) {
            f1 = load_file_name + "." + colname + "." + to_string(segment) + ".idx";
        }
        else {
            f1 = load_file_name + "." + colname + "." + to_string(segment);
        };

        if(type[colname] != 1) {
            if(!alloced_switch) {
                if(buffers.find(f1) == buffers.end()) {
                    mRecCount = pfor_decompress(thrust::raw_pointer_cast(d_columns_int[colname].data() + offset), h_columns_int[colname].data(), d_v, s_v, colname);
                }
                else {
                    mRecCount = pfor_decompress(thrust::raw_pointer_cast(d_columns_int[colname].data() + offset), buffers[f1], d_v, s_v, colname);
                };
            }
            else {
                if(buffers.find(f1) == buffers.end()) {
                    mRecCount = pfor_decompress(alloced_tmp, h_columns_int[colname].data(), d_v, s_v, colname);
                }
                else {
                    mRecCount = pfor_decompress(alloced_tmp, buffers[f1], d_v, s_v, colname);
                };
            };
        }
        else  {
            if(decimal[colname]) {
                if(!alloced_switch) {
                    if(buffers.find(f1) == buffers.end()) {
                        mRecCount = pfor_decompress( thrust::raw_pointer_cast(d_columns_float[colname].data() + offset) , h_columns_float[colname].data(), d_v, s_v, colname);
                    }
                    else {
                        mRecCount = pfor_decompress( thrust::raw_pointer_cast(d_columns_float[colname].data() + offset) , buffers[f1], d_v, s_v, colname);
                    };
					if(!phase_copy) {
						thrust::device_ptr<long long int> d_col_int((long long int*)thrust::raw_pointer_cast(d_columns_float[colname].data() + offset));
						thrust::transform(d_col_int,d_col_int+mRecCount,d_columns_float[colname].begin(), long_to_float());					
					};	
                }
                else {
                    if(buffers.find(f1) == buffers.end()) {
                        mRecCount = pfor_decompress(alloced_tmp, h_columns_float[colname].data(), d_v, s_v, colname);
                    }
                    else {
                        mRecCount = pfor_decompress(alloced_tmp, buffers[f1], d_v, s_v, colname);
                    };
					if(!phase_copy) {
						thrust::device_ptr<long long int> d_col_int((long long int*)alloced_tmp);
						thrust::device_ptr<float_type> d_col_float((float_type*)alloced_tmp);
						thrust::transform(d_col_int,d_col_int+mRecCount, d_col_float, long_to_float());
					};	
					//for(int i = 0; i < mRecCount;i++)
					//cout << "DECOMP " << (float_type)(d_col_int[i]) << " " << d_col_float[i] << endl;

                };
            }
            //else // uncompressed float
            // will have to fix it later so uncompressed data will be written by segments too
        }
    };
}



void CudaSet::CopyColumnToGpu(string colname) // copy all segments
{
    if(not_compressed) {
        if(type[colname] != 1)
            thrust::copy(h_columns_int[colname].begin(), h_columns_int[colname].begin() + mRecCount, d_columns_int[colname].begin());
        else
            thrust::copy(h_columns_float[colname].begin(), h_columns_float[colname].begin() + mRecCount, d_columns_float[colname].begin());
    }
    else {
        if(!d_v)
            CUDA_SAFE_CALL(cudaMalloc((void **) &d_v, 12));
        if(!s_v)
            CUDA_SAFE_CALL(cudaMalloc((void **) &s_v, 8));

        size_t cnt = 0;
        string f1;

        for(unsigned int i = 0; i < segCount; i++) {

            readSegmentsFromFile(i,colname, cnt);

            if(type[colname] == 2) {
                f1 = load_file_name + "." + colname + "." + to_string(i) + ".idx";
            }
            else {
                f1 = load_file_name + "." + colname + "." + to_string(i);
            };


            if(type[colname] == 0) {
                if(buffers.find(f1) == buffers.end()) {
                    mRecCount = pfor_decompress(thrust::raw_pointer_cast(d_columns_int[colname].data() + cnt), h_columns_int[colname].data(), d_v, s_v, colname);
                }
                else {
                    mRecCount = pfor_decompress(thrust::raw_pointer_cast(d_columns_int[colname].data() + cnt), buffers[f1], d_v, s_v, colname);
                };

            }
            else if(type[colname] == 1) {
                if(decimal[colname]) {
                    if(buffers.find(f1) == buffers.end()) {
                        mRecCount = pfor_decompress( thrust::raw_pointer_cast(d_columns_float[colname].data() + cnt) , h_columns_float[colname].data(), d_v, s_v, colname);
                    }
                    else {
                        mRecCount = pfor_decompress( thrust::raw_pointer_cast(d_columns_float[colname].data() + cnt) , buffers[f1], d_v, s_v, colname);
                    };
					if(!phase_copy) {
						thrust::device_ptr<long long int> d_col_int((long long int*)thrust::raw_pointer_cast(d_columns_float[colname].data() + cnt));
						thrust::transform(d_col_int,d_col_int+mRecCount,d_columns_float[colname].begin() + cnt, long_to_float());
					};	
                }
                // else  uncompressed float
                // will have to fix it later so uncompressed data will be written by segments too
            };
            cnt = cnt + mRecCount;

            //totalRecs = totals + mRecCount;
        };

        mRecCount = cnt;
    };
}

void CudaSet::CopyColumnToHost(string colname, size_t offset, size_t RecCount)
{

    if(type[colname] != 1) {
		//cout << "copied " << colname << " " <<  RecCount << endl;
        thrust::copy(d_columns_int[colname].begin(), d_columns_int[colname].begin() + RecCount, h_columns_int[colname].begin() + offset);
		//cout << "to " << colname << " " << h_columns_int[colname][0] << " " << h_columns_int[colname][1] << endl;
		//cout << "to " << colname << " " << d_columns_int[colname][0] << " " << d_columns_int[colname][1] << endl;
	}
    else 
        thrust::copy(d_columns_float[colname].begin(), d_columns_float[colname].begin() + RecCount, h_columns_float[colname].begin() + offset);
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
    if(grp.size() < mRecCount)
        grp.resize(mRecCount);	
	thrust::fill(grp.begin(), grp.begin()+mRecCount,0);
	if(scratch.size() < mRecCount)
		scratch.resize(mRecCount*sizeof(bool));
	thrust::device_ptr<bool> d_group((bool*)thrust::raw_pointer_cast(scratch.data()));	

    d_group[mRecCount-1] = 1;	
	unsigned int bits;	

    for(int i = 0; i < columnRef.size(); columnRef.pop()) {
        columnGroups.push(columnRef.top()); // save for future references

		
		if(cpy_bits.empty())
			bits = 0;
		else
			bits = cpy_bits[columnRef.top()];			
		
		if(bits == 8) {			
			if (type[columnRef.top()] != 1) {  // int_type
				thrust::device_ptr<unsigned char> src((unsigned char*)thrust::raw_pointer_cast(d_columns_int[columnRef.top()].data()));
				thrust::transform(src, src + mRecCount - 1,	src+1, d_group, thrust::not_equal_to<unsigned char>());			
			}
			else {
				thrust::device_ptr<unsigned char> src((unsigned char*)thrust::raw_pointer_cast(d_columns_float[columnRef.top()].data()));
				thrust::transform(src, src + mRecCount - 1,	src+1, d_group, thrust::not_equal_to<unsigned char>());			
			};			
		}
		else if(bits == 16) {			
			if (type[columnRef.top()] != 1) {  // int_type
				thrust::device_ptr<unsigned short int> src((unsigned short int*)thrust::raw_pointer_cast(d_columns_int[columnRef.top()].data()));
				thrust::transform(src, src + mRecCount - 1,	src+1, d_group, thrust::not_equal_to<unsigned short int>());			
			}
			else {
				thrust::device_ptr<unsigned short int> src((unsigned short int*)thrust::raw_pointer_cast(d_columns_float[columnRef.top()].data()));
				thrust::transform(src, src + mRecCount - 1,	src+1, d_group, thrust::not_equal_to<unsigned short int>());			
			};					
		}
		else if(bits == 32) {			
			if (type[columnRef.top()] != 1) {  // int_type
				thrust::device_ptr<unsigned int> src((unsigned int*)thrust::raw_pointer_cast(d_columns_int[columnRef.top()].data()));
				thrust::transform(src, src + mRecCount - 1,	src+1, d_group, thrust::not_equal_to<unsigned int>());			
			}
			else {
				thrust::device_ptr<unsigned int> src((unsigned int*)thrust::raw_pointer_cast(d_columns_float[columnRef.top()].data()));
				thrust::transform(src, src + mRecCount - 1,	src+1, d_group, thrust::not_equal_to<unsigned int>());			
			};					
		}
		else {
			if (type[columnRef.top()] != 1) {  // int_type
				thrust::transform(d_columns_int[columnRef.top()].begin(), d_columns_int[columnRef.top()].begin() + mRecCount - 1,
					d_columns_int[columnRef.top()].begin()+1, d_group, thrust::not_equal_to<int_type>());
			}
			else {
				thrust::transform(d_columns_float[columnRef.top()].begin(), d_columns_float[columnRef.top()].begin() + mRecCount - 1,
                              d_columns_float[columnRef.top()].begin()+1, d_group, f_not_equal_to());
			};					
		}					

        thrust::transform(d_group, d_group+mRecCount, grp.begin(), grp.begin(), thrust::logical_or<bool>());
    };
    grp_count = thrust::count(grp.begin(), grp.begin()+mRecCount, 1);
};


void CudaSet::addDeviceColumn(int_type* col, string colname, size_t recCount)
{
    if (std::find(columnNames.begin(), columnNames.end(), colname) == columnNames.end()) {
        columnNames.push_back(colname);
        type[colname] = 0;
        d_columns_int[colname] = thrust::device_vector<int_type>(recCount);
        h_columns_int[colname] = thrust::host_vector<int_type, uninitialized_host_allocator<int_type> >(recCount);
    }
    else {  // already exists, my need to resize it
        if(d_columns_int[colname].size() < recCount) {
            d_columns_int[colname].resize(recCount);
        };
		if(h_columns_int[colname].size() < recCount) {
            h_columns_int[colname].resize(recCount);
        };
    };
    // copy data to d columns
    thrust::device_ptr<int_type> d_col((int_type*)col);
    thrust::copy(d_col, d_col+recCount, d_columns_int[colname].begin());
	thrust::copy(d_columns_int[colname].begin(), d_columns_int[colname].begin()+recCount, h_columns_int[colname].begin());
};

void CudaSet::addDeviceColumn(float_type* col, string colname, size_t recCount, bool is_decimal)
{
    if (std::find(columnNames.begin(), columnNames.end(), colname) == columnNames.end()) {
        columnNames.push_back(colname);
        type[colname] = 1;
        d_columns_float[colname] = thrust::device_vector<float_type>(recCount);
        h_columns_float[colname] = thrust::host_vector<float_type, uninitialized_host_allocator<float_type> >(recCount);		
    }
    else {  // already exists, my need to resize it
        if(d_columns_float[colname].size() < recCount)
            d_columns_float[colname].resize(recCount);
        if(h_columns_float[colname].size() < recCount)
            h_columns_float[colname].resize(recCount);			
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

            if(type[sf.front()] != 2) {
                allocColumnOnDevice(sf.front(), maxRecs);
                CopyColumnToGpu(sf.front());
            };

            if (type[sf.front()] == 0)
                update_permutation(d_columns_int[sf.front()], raw_ptr, mRecCount, sort_type, (int_type*)temp, 64);
            else if (type[sf.front()] == 1)
                update_permutation(d_columns_float[sf.front()], raw_ptr, mRecCount, sort_type, (float_type*)temp, 64);
            else {
                thrust::host_vector<unsigned int> permutation_h = permutation;
                update_permutation_char_host(h_columns_char[sf.front()], permutation_h.data(), mRecCount, sort_type, (char*)temp, char_size[sf.front()]);
            };
            if(type[sf.front()] != 2)
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
        str += "." + to_string(total_segments-1);
        new_offset = 0;

        if(!op_sort.empty() && type[colname] != 2) {
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
                    str += "." + to_string(total_segments-1);
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
                        str += "." + to_string(total_segments-1);
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
                        str += "." + to_string(total_segments-1);
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
                    str += "." + to_string(total_segments-1);

                    if (p < partition_count - 1)
                        compress_char(str, colname, partition_recs, new_offset, total_segments-1);
                    else
                        compress_char(str, colname, mCount - partition_recs*p, new_offset, total_segments-1);
                    new_offset = new_offset + partition_recs;
                    total_segments++;
                };
            }
            else {
                compress_char(str, colname, mCount, offset, total_segments-1);
            };
        };

        if(type[colname] != 2)
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
    else {
        str += ".sort";
        remove(str.c_str());
    };

    if(!op_presort.empty()) {
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
    }
    else {
        str += ".presort";
        remove(str.c_str());
    };
}

using namespace mgpu;

void CudaSet::Display(unsigned int limit, bool binary, bool term)
{
#define MAXCOLS 128
#define MAXFIELDSIZE 1400

    //-- This should/will be converted to an array holding pointers of malloced sized structures--
    char    bigbuf[MAXCOLS * MAXFIELDSIZE];
    memset(bigbuf, 0, MAXCOLS * MAXFIELDSIZE);
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

    unsigned int cc =0;
    unordered_map<string, FILE*> file_map;
    unordered_map<string, unsigned int> len_map;

    for(unsigned int i = 0; i < columnNames.size(); i++)
    {
        fields[cc] = &(bigbuf[cc*MAXFIELDSIZE]);                        // a hack to avoid malloc overheads     - refine later
        dcolumns[cc++] = columnNames[i].c_str();
    
		if(string_map.find(columnNames[i]) != string_map.end()) {
			auto s = string_map[columnNames[i]];
			auto pos = s.find_first_of(".");
			auto len = data_dict[s.substr(0, pos)][s.substr(pos+1)].col_length;
			FILE *f;
			f = fopen(string_map[columnNames[i]].c_str(), "rb");
			file_map[string_map[columnNames[i]]] = f;
			len_map[string_map[columnNames[i]]] = len;
		};
    };

    // The goal here is to loop fast and avoid any double handling of outgoing data - pointers are good.
    if(not_compressed && prm_d.size() == 0) {
        for(unsigned int i=0; i < mCount; i++) {                            // for each record
            for(unsigned int j=0; j < columnNames.size(); j++) {                // for each col
                if (type[columnNames[j]] != 1) {
                    if(string_map.find(columnNames[j]) == string_map.end())
                        sprintf(fields[j], "%lld", (h_columns_int[columnNames[j]])[i] );
                    else {
                        fseek(file_map[string_map[columnNames[j]]], h_columns_int[columnNames[j]][i] * len_map[string_map[columnNames[j]]], SEEK_SET);
                        fread(fields[j], 1, len_map[string_map[columnNames[j]]], file_map[string_map[columnNames[j]]]);
                        fields[j][len_map[string_map[columnNames[j]]]] ='\0'; // zero terminate string
                    };
                }
                else
                    sprintf(fields[j], "%.2f", (h_columns_float[columnNames[j]])[i] );
            };
            row_cb(mColumnCount, (char **)fields, (char **)dcolumns);
            rows++;
        };
    }
    else {
        queue<string> op_vx;
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
                    if (type[columnNames[j]] != 1) {
                        if(string_map.find(columnNames[j]) == string_map.end())
                            sprintf(fields[j], "%lld", (h_columns_int[columnNames[j]])[i] );
                        else {
                            fseek(file_map[string_map[columnNames[j]]], h_columns_int[columnNames[j]][i] * len_map[string_map[columnNames[j]]], SEEK_SET);
                            fread(fields[j], 1, len_map[string_map[columnNames[j]]], file_map[string_map[columnNames[j]]]);
                            fields[j][len_map[string_map[columnNames[j]]]] ='\0'; // zero terminate string
                        };
                    }
                    else
                        sprintf(fields[j], "%.2f", (h_columns_float[columnNames[j]])[i] );
                };
                row_cb(mColumnCount, (char **)fields, (char**)dcolumns);
                rows++;
            };
            curr_seg++;
            if(curr_seg == segCount)
                print_all = 0;
        };
    };      // end else
    for(auto it = file_map.begin(); it != file_map.end(); it++)
		fclose(it->second);
}

void CudaSet::Store(const string file_name, const char* sep, const unsigned int limit, const bool binary, const bool term)
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

        unordered_map<string, FILE*> file_map;
        unordered_map<string, unsigned int> len_map;
        string bf;
        unsigned int max_len = 0;
        for(unsigned int j=0; j < columnNames.size(); j++) {
            if(string_map.find(columnNames[j]) != string_map.end()) {
                auto s = string_map[columnNames[j]];
                auto pos = s.find_first_of(".");
                auto len = data_dict[s.substr(0, pos)][s.substr(pos+1)].col_length;
                if(len > max_len)
                    max_len = len;
                FILE *f;
                f = fopen(string_map[columnNames[j]].c_str(), "rb");
                file_map[string_map[columnNames[j]]] = f;
                len_map[string_map[columnNames[j]]] = len;
            };
        };
        bf.reserve(max_len);

        FILE *file_pr;
        if(!term) {
            file_pr = fopen(file_name.c_str(), "w");
            if (!file_pr)
                cout << "Could not open file " << file_name << endl;
        }
        else
            file_pr = stdout;

        if(not_compressed && prm_d.size() == 0) {
            for(unsigned int i=0; i < mCount; i++) {
                for(unsigned int j=0; j < columnNames.size(); j++) {
                    if (type[columnNames[j]] != 1 ) {
                        if(string_map.find(columnNames[j]) == string_map.end()) {
                            fprintf(file_pr, "%lld", (h_columns_int[columnNames[j]])[i]);
						}									
                        else {
                            //fprintf(file_pr, "%.*s", string_hash[columnNames[j]][h_columns_int[columnNames[j]][i]].size(), string_hash[columnNames[j]][h_columns_int[columnNames[j]][i]].c_str());
                            fseek(file_map[string_map[columnNames[j]]], h_columns_int[columnNames[j]][i] * len_map[string_map[columnNames[j]]], SEEK_SET);
                            fread(&bf[0], 1, len_map[string_map[columnNames[j]]], file_map[string_map[columnNames[j]]]);
                            fprintf(file_pr, "%.*s", len_map[string_map[columnNames[j]]], bf.c_str());
                        };
                        fputs(sep, file_pr);
                    }
                    else {
                        fprintf(file_pr, "%.2f", (h_columns_float[columnNames[j]])[i]);
                        fputs(sep, file_pr);
                    }
                };
                if (i != mCount -1 )
                    fputs("\n",file_pr);
            };
            if(!term)
                fclose(file_pr);
        }
        else {

            queue<string> op_vx;
            string ss;
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
                        if (type[columnNames[j]] != 1) {
                            if(string_map.find(columnNames[j]) == string_map.end()) {
                                fprintf(file_pr, "%lld", (h_columns_int[columnNames[j]])[i]);
							}	
                            else {
                                fseek(file_map[string_map[columnNames[j]]], h_columns_int[columnNames[j]][i] * len_map[string_map[columnNames[j]]], SEEK_SET);
                                fread(&bf[0], 1, len_map[string_map[columnNames[j]]], file_map[string_map[columnNames[j]]]);
                                fprintf(file_pr, "%.*s", len_map[string_map[columnNames[j]]], bf.c_str());
                            };
                            fputs(sep, file_pr);
                        }
                        else  {							
                            fprintf(file_pr, "%.2f", (h_columns_float[columnNames[j]])[i]);
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
		for(auto it = file_map.begin(); it != file_map.end(); it++)
			fclose(it->second);		
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
                    if(!ff) {
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
                    //a->h_columns_int[ref_cols[columnNames[i]]] = thrust::host_vector<int_type, pinned_allocator<int_type> >();
                    a->h_columns_int[ref_cols[columnNames[i]]] = thrust::host_vector<int_type>();
                    a->d_columns_int[ref_cols[columnNames[i]]] = thrust::device_vector<int_type>(ref_maxRecs);
                    a->type[ref_cols[columnNames[i]]] = 0;
                    a->not_compressed = 0;
                    a->load_file_name = ref_sets[columnNames[i]];
                    a->cols[1] = ref_cols[columnNames[i]];
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
                        cout << "RES " << i << " " << total_segments << ":" << z << " " << res_count << endl;
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


void CudaSet::compress_char(const string file_name, const string colname, const size_t mCount, const size_t offset, const unsigned int segment)
{
    unsigned int len = char_size[colname];
    unsigned long long int string_hash;

    string h_name, i_name, file_no_seg = file_name.substr(0, file_name.find_last_of("."));
    i_name = file_no_seg + "." + to_string(segment) + ".idx";
    h_name = file_no_seg + "." + to_string(segment) + ".hash";
    fstream b_file_str, loc_hashes;

    fstream binary_file_h(h_name.c_str(),ios::out|ios::binary|ios::trunc);
    binary_file_h.write((char *)&mCount, 4);

    if(segment == 0) {
        b_file_str.open(file_no_seg.c_str(),ios::out|ios::binary|ios::trunc);
    }
    else {
        b_file_str.open(file_no_seg.c_str(),ios::out|ios::binary|ios::app);
    };

    if(h_columns_int.find(colname) == h_columns_int.end())
        h_columns_int[colname] = thrust::host_vector<int_type >(mCount);
    if(d_columns_int.find(colname) == d_columns_int.end())
        d_columns_int[colname] = thrust::device_vector<int_type >(mCount);
		
    for (unsigned int i = 0 ; i < mCount; i++) {
        string_hash = MurmurHash64A(h_columns_char[colname] + (i+offset)*len, len, hash_seed)/2;
        binary_file_h.write((char *)&string_hash, 8);
        if(char_hash[colname].find(string_hash) == char_hash[colname].end()) {
			auto cnt = char_hash[colname].size();
            char_hash[colname][string_hash] = cnt;
            b_file_str.write((char *)h_columns_char[colname] + (i+offset)*len, len);
            h_columns_int[colname][i] = cnt;
        }
        else {
            h_columns_int[colname][i] = char_hash[colname][string_hash];
        };

    };

    thrust::device_vector<int_type> d_col(mCount);
    thrust::copy(h_columns_int[colname].begin(), h_columns_int[colname].begin() + mCount, d_col.begin());
    pfor_compress(thrust::raw_pointer_cast(d_col.data()), mCount*int_size, i_name, h_columns_int[colname], 0);

    binary_file_h.close();
    b_file_str.close();
};

void CudaSet::compress_int(const string file_name, const string colname, const size_t mCount)
{
    std::vector<unsigned int> dict_val;
    unsigned int bits_encoded;
    set<int_type> dict_s;
    map<int_type, unsigned int> d_ordered;

    for (unsigned int i = 0 ; i < mCount; i++) {
        int_type f = h_columns_int[colname][i];
        dict_s.insert(f);
    };

    unsigned int i = 0;
    for (auto it = dict_s.begin(); it != dict_s.end(); it++) {
        d_ordered[*it] = i++;
    };

    for (unsigned int i = 0 ; i < mCount; i++) {
        int_type f = h_columns_int[colname][i];
        dict_val.push_back(d_ordered[f]);
    };

    bits_encoded = (unsigned int)ceil(log2(double(d_ordered.size()+1)));
    //cout << "bits " << bits_encoded << endl;

    unsigned int sz = (unsigned int)d_ordered.size();
    // write to a file
    fstream binary_file(file_name.c_str(),ios::out|ios::binary|ios::trunc);
    binary_file.write((char *)&sz, 4);

    for (auto it = d_ordered.begin(); it != d_ordered.end(); it++) {
        binary_file.write((char*)(&(it->first)), int_size);
    };

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
            binary_file.write((char *)&val, int_size);
            val = 0;
        }
        else
            curr_cnt = curr_cnt + 1;
    };
    binary_file.close();
};




bool CudaSet::LoadBigFile(FILE* file_p)
{
    char line[2000];
    unsigned int current_column, count = 0;
    string colname;
    char *p,*t;
    const char* sep = separator.c_str();
    unsigned int maxx = cols.rbegin()->first;
	map<unsigned int, string>::iterator it;

    //clear the varchars
    //for(auto it=columnNames.begin(); it!=columnNames.end();it++) {
    for(unsigned int i = 0; i < mColumnCount; i++) {
        if(type[columnNames[i]] == 2) {
			if(!h_columns_char[columnNames[i]])
				h_columns_char[columnNames[i]] = new char[maxRecs*char_size[columnNames[i]]];
            memset(h_columns_char[columnNames[i]], 0, maxRecs*char_size[columnNames[i]]);
        };
    };
	
	vector<int> types;
	types.push_back(0);
	for(int i = 0; i < maxx; i++) {
		auto iter = cols.find(i+1);
		if(iter != cols.end())
			types.push_back(type[iter->second]);
		else	
			types.push_back(0);
	};
		
	
    while (count < process_count && fgets(line, 2000, file_p)) {
        strtok(line, "\n");
        current_column = 0;

        for(t=mystrtok(&p,line,*sep); t && current_column < maxx; t=mystrtok(&p,0,*sep)) {
            current_column++;
			it = cols.find(current_column);
            if(it == cols.end()) {
                continue;
            };

			switch(types[current_column]) {
			case 0 :            		
                if (strchr(t,'-') && t[0] != '-') { // handling possible dates
                    strncpy(t+4,t+5,2);
                    strncpy(t+6,t+8,2);
                    t[8] = '\0';
                    (h_columns_int[it->second])[count] = atoll(t);
                }
                else if (strchr(t,'/')) { // 4/30/2014
                    string s(t);
                    size_t pos1 = s.find_first_of("/",0);
                    size_t pos2 = s.find_first_of("/",pos1+1);
                    string month = s.substr(0,pos1);
                    if(month.length() == 1)
                        month = "0" + month;
                    string day = s.substr(pos1+1,pos2-pos1-1);
                    if(day.length() == 1)
                        day = "0" + day;
                    string s2 = s.substr(pos2+1, string::npos) + month + day;
                    (h_columns_int[it->second])[count] = atoll(s2.c_str());
                }
                else {
				
                    (h_columns_int[it->second])[count] = atoll(t);
                };				
				break;
            case 1 :
                (h_columns_float[it->second])[count] = atoff(t);
				break;            
            default :  //char
                strcpy(h_columns_char[it->second] + count*char_size[it->second], t);
				break;
            };			
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
    for(unsigned int i = 0; i < columnNames.size(); i++ ) {
		if(type[columnNames[i]] == 0 ) {
			h_columns_int[columnNames[i]].resize(0);
			h_columns_int[columnNames[i]].shrink_to_fit();
		}
		else {
			h_columns_float[columnNames[i]].resize(0);
			h_columns_float[columnNames[i]].shrink_to_fit();
		};
    };
    prm_d.resize(0);
    prm_d.shrink_to_fit();
    deAllocOnDevice();
};

void alloc_pool(unsigned int maxRecs) {
	void* temp;
	CUDA_SAFE_CALL(cudaMalloc((void **) &temp, 8*maxRecs));
	alloced_mem.push_back(temp);		
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
	if(alloced_mem.empty()) {								
		alloc_pool(maxRecs);
	};
	thrust::device_ptr<float_type> temp((float_type*)alloced_mem.back());								
    //thrust::device_ptr<float_type> temp = thrust::device_malloc<float_type>(mRecCount);
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
	alloced_mem.pop_back();
    return thrust::raw_pointer_cast(temp);

}




int_type* CudaSet::op(int_type* column1, int_type* column2, string op_type, int reverse)
{
	if(alloced_mem.empty()) {								
		alloc_pool(maxRecs);
	};
	thrust::device_ptr<int_type> temp((int_type*)alloced_mem.back());								
    //thrust::device_ptr<int_type> temp = thrust::device_malloc<int_type>(mRecCount);
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
	alloced_mem.pop_back();
    return thrust::raw_pointer_cast(temp);

}

float_type* CudaSet::op(float_type* column1, float_type* column2, string op_type, int reverse)
{
	if(alloced_mem.empty()) {								
		alloc_pool(maxRecs);
	};
	thrust::device_ptr<float_type> temp((float_type*)alloced_mem.back());								
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
	alloced_mem.pop_back();
    return thrust::raw_pointer_cast(temp);
}

int_type* CudaSet::op(int_type* column1, int_type d, string op_type, int reverse)
{
	if(alloced_mem.empty()) {								
		alloc_pool(maxRecs);
	};
	thrust::device_ptr<int_type> temp((int_type*)alloced_mem.back());								
    //thrust::device_ptr<int_type> temp = thrust::device_malloc<int_type>(mRecCount);
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
	alloced_mem.pop_back();
    return thrust::raw_pointer_cast(temp);
}

float_type* CudaSet::op(int_type* column1, float_type d, string op_type, int reverse)
{
	if(alloced_mem.empty()) {								
		alloc_pool(maxRecs);
	};
	thrust::device_ptr<float_type> temp((float_type*)alloced_mem.back());								
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
	alloced_mem.pop_back();
    return thrust::raw_pointer_cast(temp);
}

float_type* CudaSet::op(float_type* column1, float_type d, string op_type,int reverse)
{
	if(alloced_mem.empty()) {								
		alloc_pool(maxRecs);
	};
	thrust::device_ptr<float_type> temp((float_type*)alloced_mem.back());								
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
	alloced_mem.pop_back();
    return (float_type*)thrust::raw_pointer_cast(temp);
}

char CudaSet::loadIndex(const string index_name, const unsigned int segment)
{
    FILE* f;
    unsigned int bits_encoded, fit_count, vals_count, sz, real_count;
    void* d_str;
    string f1 = index_name + "." + to_string(segment);
    char res;

    if(interactive) {
        if(index_buffers.find(f1) == index_buffers.end()) {
            f = fopen (f1.c_str(), "rb" );
            fseek(f, 0, SEEK_END);
            long fileSize = ftell(f);
            char* buff;
            cudaHostAlloc(&buff, fileSize, cudaHostAllocDefault);

            fseek(f, 0, SEEK_SET);
            fread(buff, fileSize, 1, f);
            fclose(f);
            index_buffers[f1] = buff;
        };
        sz = ((unsigned int*)index_buffers[f1])[0];

        idx_dictionary_int[index_name].clear();
        for(unsigned int i = 0; i < sz; i++) {
            idx_dictionary_int[index_name][((int_type*)(index_buffers[f1]+4+8*i))[0]] = i;
        };
        vals_count = ((unsigned int*)(index_buffers[f1]+4 +8*sz))[2];
        real_count = ((unsigned int*)(index_buffers[f1]+4 +8*sz))[3];
        mRecCount = real_count;
        res = (index_buffers[f1]+4 +8*sz + (vals_count+2)*int_size)[0];
        cudaMalloc((void **) &d_str, (vals_count+2)*int_size);
        cudaMemcpy( d_str, (void *) &((index_buffers[f1]+4 +8*sz)[0]), (vals_count+2)*int_size, cudaMemcpyHostToDevice);

        if(idx_vals.count(index_name))
            cudaFree(idx_vals[index_name]);
        idx_vals[index_name] = (unsigned long long int*)d_str;

    }
    else {
        f = fopen (f1.c_str(), "rb" );
        fread(&sz, 4, 1, f);
        int_type* d_array = new int_type[sz];
        idx_dictionary_int[index_name].clear();
        fread((void*)d_array, sz*int_size, 1, f);
        for(unsigned int i = 0; i < sz; i++) {
            idx_dictionary_int[index_name][d_array[i]] = i;
            //cout << index_name  << " " << d_array[i] << " " << i << endl;
        };
        delete [] d_array;

        fread(&fit_count, 4, 1, f);
        fread(&bits_encoded, 4, 1, f);
        fread(&vals_count, 4, 1, f);
        fread(&real_count, 4, 1, f);
        mRecCount = real_count;

        unsigned long long int* int_array = new unsigned long long int[vals_count+2];
        fseek ( f , -16 , SEEK_CUR );
        fread((void*)int_array, 1, vals_count*8 + 16, f);
        fread(&res, 1, 1, f);
        fclose(f);
        void* d_str;
        cudaMalloc((void **) &d_str, (vals_count+2)*int_size);
        cudaMemcpy( d_str, (void *) int_array, (vals_count+2)*int_size, cudaMemcpyHostToDevice);
        if(idx_vals.count(index_name))
            cudaFree(idx_vals[index_name]);
        idx_vals[index_name] = (unsigned long long int*)d_str;
    }
    return res;
}



void CudaSet::initialize(queue<string> &nameRef, queue<string> &typeRef, queue<int> &sizeRef, queue<int> &colsRef, size_t Recs, string file_name) // compressed data for DIM tables
{
    mColumnCount = (unsigned int)nameRef.size();
    FILE* f;
    string f1;
    unsigned int cnt;
    char buffer[4000];
    string str;
    not_compressed = 0;
    mRecCount = Recs;
    hostRecCount = Recs;
    totalRecs = Recs;
    load_file_name = file_name;

    f1 = file_name + ".sort";
    f = fopen (f1.c_str() , "rb" );
    if(f) {
        unsigned int sz, idx;
        fread((char *)&sz, 4, 1, f);
        for(unsigned int j = 0; j < sz; j++) {
            fread((char *)&idx, 4, 1, f);
            fread(buffer, idx, 1, f);
            str.assign(buffer, idx);
            sorted_fields.push(str);
            if(verbose)
                cout << "segment sorted on " << str << endl;
        };
        fclose(f);
    };

    f1 = file_name + ".presort";
    f = fopen (f1.c_str() , "rb" );
    if(f) {
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
        cols[colsRef.front()] = nameRef.front();

        if (((typeRef.front()).compare("decimal") == 0) || ((typeRef.front()).compare("int") == 0)) {
            f1 = file_name + "." + nameRef.front() + ".0";
            f = fopen (f1.c_str() , "rb" );
            if(!f) {
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
        if(f) {
            unsigned int len;
            fread(&len, 4, 1, f);
            char* array = new char[len+1];			
			memset(array, 0, len+1);
            fread((void*)array, len, 1, f);
			string s(array);
            ref_sets[nameRef.front()] = s;
            delete [] array;
            unsigned int segs, seg_num, curr_seg;
            size_t res_count;
            fread(&len, 4, 1, f);
            char* array1 = new char[len+1];
			memset(array1, 0, len+1);
            fread((void*)array1, len, 1, f);
			string s1(array1);
            ref_cols[nameRef.front()] = s1;
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
            //h_columns_int[nameRef.front()] = thrust::host_vector<int_type >();
            d_columns_int[nameRef.front()] = thrust::device_vector<int_type>();
        }
        else if ((typeRef.front()).compare("float") == 0) {
            type[nameRef.front()] = 1;
            decimal[nameRef.front()] = 0;
            h_columns_float[nameRef.front()] = thrust::host_vector<float_type, pinned_allocator<float_type> >();
            //h_columns_float[nameRef.front()] = thrust::host_vector<float_type>();
            d_columns_float[nameRef.front()] = thrust::device_vector<float_type >();
        }
        else if ((typeRef.front()).compare("decimal") == 0) {
            type[nameRef.front()] = 1;
            decimal[nameRef.front()] = 1;
            h_columns_float[nameRef.front()] = thrust::host_vector<float_type, pinned_allocator<float_type> >();
            //h_columns_float[nameRef.front()] = thrust::host_vector<float_type>();
            d_columns_float[nameRef.front()] = thrust::device_vector<float_type>();
        }
        else {
            type[nameRef.front()] = 2;
            decimal[nameRef.front()] = 0;
            h_columns_char[nameRef.front()] = nullptr;
            d_columns_char[nameRef.front()] = nullptr;
            char_size[nameRef.front()] = sizeRef.front();
            string_map[nameRef.front()] = file_name + "." + nameRef.front();
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
    tmp_table = 0;
    filtered = 0;
    mRecCount = Recs;
    hostRecCount = Recs;
    segCount = 1;

    for(unsigned int i=0; i < mColumnCount; i++) {

        columnNames.push_back(nameRef.front());
        cols[colsRef.front()] = nameRef.front();

        if ((typeRef.front()).compare("int") == 0) {
            type[nameRef.front()] = 0;
            decimal[nameRef.front()] = 0;
            h_columns_int[nameRef.front()] = thrust::host_vector<int_type, pinned_allocator<int_type> >();
            //h_columns_int[nameRef.front()] = thrust::host_vector<int_type>();
            d_columns_int[nameRef.front()] = thrust::device_vector<int_type>();
        }
        else if ((typeRef.front()).compare("float") == 0) {
            type[nameRef.front()] = 1;
            decimal[nameRef.front()] = 0;
            h_columns_float[nameRef.front()] = thrust::host_vector<float_type, pinned_allocator<float_type> >();
            //h_columns_float[nameRef.front()] = thrust::host_vector<float_type>();
            d_columns_float[nameRef.front()] = thrust::device_vector<float_type>();
        }
        else if ((typeRef.front()).compare("decimal") == 0) {
            type[nameRef.front()] = 1;
            decimal[nameRef.front()] = 1;
            h_columns_float[nameRef.front()] = thrust::host_vector<float_type, pinned_allocator<float_type> >();
            //h_columns_float[nameRef.front()] = thrust::host_vector<float_type>();
            d_columns_float[nameRef.front()] = thrust::device_vector<float_type>();
        }

        else {
            type[nameRef.front()] = 2;
            decimal[nameRef.front()] = 0;
            h_columns_char[nameRef.front()] = nullptr;
            d_columns_char[nameRef.front()] = nullptr;
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

void CudaSet::initialize(const size_t RecordCount, const unsigned int ColumnCount)
{
    mRecCount = RecordCount;
    hostRecCount = RecordCount;
    mColumnCount = ColumnCount;
    filtered = 0;
};


void CudaSet::initialize(queue<string> op_sel, const queue<string> op_sel_as)
{
    mRecCount = 0;
    mColumnCount = (unsigned int)op_sel.size();
    segCount = 1;
    not_compressed = 1;
    filtered = 0;
    col_aliases = op_sel_as;
    unsigned int i = 0;
    CudaSet *a;
    while(!op_sel.empty()) {
        for(auto it = varNames.begin(); it != varNames.end(); it++) {
            a = it->second;
            if(std::find(a->columnNames.begin(), a->columnNames.end(), op_sel.front()) != a->columnNames.end())
                break;
        };

        type[op_sel.front()] = a->type[op_sel.front()];
        cols[i] = op_sel.front();
        decimal[op_sel.front()] = a->decimal[op_sel.front()];
        columnNames.push_back(op_sel.front());

        if (a->type[op_sel.front()] == 0)  {
            d_columns_int[op_sel.front()] = thrust::device_vector<int_type>();
            //h_columns_int[op_sel.front()] = thrust::host_vector<int_type, pinned_allocator<int_type> >();
            h_columns_int[op_sel.front()] = thrust::host_vector<int_type>();
        }
        else if (a->type[op_sel.front()] == 1) {
            d_columns_float[op_sel.front()] = thrust::device_vector<float_type>();
            //h_columns_float[op_sel.front()] = thrust::host_vector<float_type, pinned_allocator<float_type> >();
            h_columns_float[op_sel.front()] = thrust::host_vector<float_type>();
        }
        else {
            h_columns_char[op_sel.front()] = nullptr;
            d_columns_char[op_sel.front()] = nullptr;
            char_size[op_sel.front()] = a->char_size[op_sel.front()];
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
        if( std::find(a->columnNames.begin(), a->columnNames.end(), q_cnt.front()) !=  a->columnNames.end() ||
                std::find(b->columnNames.begin(), b->columnNames.end(), q_cnt.front()) !=  b->columnNames.end())  {
            field_names.insert(q_cnt.front());
        };
        q_cnt.pop();
    }
    mColumnCount = (unsigned int)field_names.size();
    maxRecs = b->maxRecs;
    segCount = 1;
    filtered = 0;
    not_compressed = 1;

    col_aliases = op_sel_as;
    i = 0;
    while(!op_sel.empty()) {
        if(std::find(columnNames.begin(), columnNames.end(), op_sel.front()) ==  columnNames.end()) {
            if(std::find(a->columnNames.begin(), a->columnNames.end(), op_sel.front()) !=  a->columnNames.end()) {
                cols[i] = op_sel.front();
                decimal[op_sel.front()] = a->decimal[op_sel.front()];
                columnNames.push_back(op_sel.front());
                type[op_sel.front()] = a->type[op_sel.front()];

                if (a->type[op_sel.front()] == 0)  {
                    d_columns_int[op_sel.front()] = thrust::device_vector<int_type>();
                    h_columns_int[op_sel.front()] = thrust::host_vector<int_type, pinned_allocator<int_type> >();
                    //h_columns_int[op_sel.front()] = thrust::host_vector<int_type>();
                    if(a->string_map.find(op_sel.front()) != a->string_map.end()) {
                        string_map[op_sel.front()] = a->string_map[op_sel.front()];
                        //cout << "SETTING J " << op_sel.front() << " " << a->string_map[op_sel.front()] << endl;
                    };
                }
                else if (a->type[op_sel.front()] == 1) {
                    d_columns_float[op_sel.front()] = thrust::device_vector<float_type>();
                    h_columns_float[op_sel.front()] = thrust::host_vector<float_type, pinned_allocator<float_type> >();
                    //h_columns_float[op_sel.front()] = thrust::host_vector<float_type>();
                }
                else {
                    h_columns_char[op_sel.front()] = nullptr;
                    d_columns_char[op_sel.front()] = nullptr;
                    char_size[op_sel.front()] = a->char_size[op_sel.front()];
                    string_map[op_sel.front()] = a->string_map[op_sel.front()];
                    //cout << "SETTING J " << op_sel.front() << " " << a->string_map[op_sel.front()] << endl;
                };
                i++;
            }
            else if(std::find(b->columnNames.begin(), b->columnNames.end(), op_sel.front()) !=  b->columnNames.end()) {
                columnNames.push_back(op_sel.front());
                cols[i] = op_sel.front();
                decimal[op_sel.front()] = b->decimal[op_sel.front()];
                type[op_sel.front()] = b->type[op_sel.front()];

                if (b->type[op_sel.front()] == 0) {
                    d_columns_int[op_sel.front()] = thrust::device_vector<int_type>();
                    h_columns_int[op_sel.front()] = thrust::host_vector<int_type, pinned_allocator<int_type> >();
                    //h_columns_int[op_sel.front()] = thrust::host_vector<int_type>();
                    if(b->string_map.find(op_sel.front()) != b->string_map.end()) {
                        string_map[op_sel.front()] = b->string_map[op_sel.front()];
                        //cout << "SETTING J " << op_sel.front() << " " << b->string_map[op_sel.front()] << endl;
                    };

                }
                else if (b->type[op_sel.front()] == 1) {
                    d_columns_float[op_sel.front()] = thrust::device_vector<float_type>();
                    h_columns_float[op_sel.front()] = thrust::host_vector<float_type, pinned_allocator<float_type> >();
                    //h_columns_float[op_sel.front()] = thrust::host_vector<float_type>();
                }
                else {
                    h_columns_char[op_sel.front()] = nullptr;
                    d_columns_char[op_sel.front()] = nullptr;
                    char_size[op_sel.front()] = b->char_size[op_sel.front()];
                    string_map[op_sel.front()] = b->string_map[op_sel.front()];
                    //cout << "SETTING J " << op_sel.front() << " " << b->string_map[op_sel.front()] << endl;
                };
                i++;
            }
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
        CudaSet* t;
        if(a->filtered)
            t = varNames[a->source_name];
        else
            t = a;

        if(int_size*t->maxRecs > alloced_sz) {
            if(alloced_sz) {
                cudaFree(alloced_tmp);
            };
            cudaMalloc((void **) &alloced_tmp, int_size*t->maxRecs);
            alloced_sz = int_size*t->maxRecs;
        }
    }
    else {
        while(!fields.empty()) {
            if(var_exists(a, fields.front()) && !a->onDevice(fields.front())) {
                a->allocColumnOnDevice(fields.front(), a->maxRecs);
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

void copyFinalize(CudaSet* a, queue<string> fields)
{
	set<string> uniques;   
	if(scratch.size() < a->mRecCount*8)
		scratch.resize(a->mRecCount*8);
	thrust::device_ptr<int_type> tmp((int_type*)thrust::raw_pointer_cast(scratch.data()));		
   
	while(!fields.empty()) {
        if (uniques.count(fields.front()) == 0 && var_exists(a, fields.front()) && cpy_bits.find(fields.front()) != cpy_bits.end())	{
						
			if(cpy_bits[fields.front()] == 8) {				
				if(a->type[fields.front()] != 1) {
					thrust::device_ptr<char> src((char*)thrust::raw_pointer_cast(a->d_columns_int[fields.front()].data()));					
					thrust::transform(src, src+a->mRecCount, tmp, char_to_int64());					
				}
				else {
					thrust::device_ptr<unsigned char> src((unsigned char*)thrust::raw_pointer_cast(a->d_columns_float[fields.front()].data()));
					thrust::transform(src, src+a->mRecCount, tmp, char_to_int64());
				};	
			}
			else if(cpy_bits[fields.front()] == 16) {
				if(a->type[fields.front()] != 1) {
					thrust::device_ptr<unsigned short int> src((unsigned short int*)thrust::raw_pointer_cast(a->d_columns_int[fields.front()].data()));
					thrust::transform(src, src+a->mRecCount, tmp, int16_to_int64());
				}
				else {
					thrust::device_ptr<unsigned short int> src((unsigned short int*)thrust::raw_pointer_cast(a->d_columns_float[fields.front()].data()));
					thrust::transform(src, src+a->mRecCount, tmp, int16_to_int64());
				};	
			}
			else if(cpy_bits[fields.front()] == 32) {
				if(a->type[fields.front()] != 1) {
					thrust::device_ptr<unsigned int> src((unsigned int*)thrust::raw_pointer_cast(a->d_columns_int[fields.front()].data()));
					thrust::transform(src, src+a->mRecCount, tmp, int32_to_int64());
				}	
				else {
					thrust::device_ptr<unsigned int> src((unsigned int*)thrust::raw_pointer_cast(a->d_columns_float[fields.front()].data()));
					thrust::transform(src, src+a->mRecCount, tmp, int32_to_int64());
				};
			}
			else {
				if(a->type[fields.front()] != 1) {
					thrust::device_ptr<int_type> src((int_type*)thrust::raw_pointer_cast(a->d_columns_int[fields.front()].data()));
					thrust::copy(src, src+a->mRecCount, tmp);
				}	
				else {					
					thrust::device_ptr<int_type> src((int_type*)thrust::raw_pointer_cast(a->d_columns_float[fields.front()].data()));
					thrust::copy(src, src+a->mRecCount, tmp);
				};
			};			
			thrust::constant_iterator<int_type> iter(cpy_init_val[fields.front()]);
			if(a->type[fields.front()] != 1) {
				thrust::transform(tmp, tmp + a->mRecCount, iter, a->d_columns_int[fields.front()].begin(), thrust::plus<int_type>());				
			}
			else {
				thrust::device_ptr<int_type> dest((int_type*)thrust::raw_pointer_cast(a->d_columns_float[fields.front()].data()));
				thrust::transform(tmp, tmp + a->mRecCount, iter, dest, thrust::plus<int_type>());	
                thrust::transform(dest, dest+a->mRecCount, a->d_columns_float[fields.front()].begin(), long_to_float());				
			};				
		};		
		uniques.insert(fields.front());
        fields.pop();
    };   
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
	cpy_bits.clear();
	cpy_init_val.clear();
	auto f(fields);
	
    while(!fields.empty()) {
        if (uniques.count(fields.front()) == 0 && var_exists(a, fields.front()))	{
            if(a->filtered) {
                if(a->mRecCount) {
                    CudaSet *t = varNames[a->source_name];
                    alloced_switch = 1;
                    t->CopyColumnToGpu(fields.front(), segment);
                    gatherColumns(a, t, fields.front(), segment, count);
                    alloced_switch = 0;
                    if(t->orig_segs.size() >= segment+1) {
                        a->orig_segs.resize(segment+1);
                        a->orig_segs.resize(segment+1);
                        a->orig_segs[segment] = t->orig_segs[segment];
                    };
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


void setPrm(CudaSet* a, CudaSet* b, char val, unsigned int segment)
{
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
    if(t->type[colname] != 1 ) {
		if(cpy_bits.find(colname) != cpy_bits.end()) { // non-delta compression
			if(cpy_bits[colname] == 8) {
					thrust::device_ptr<unsigned char> d_col_source((unsigned char*)alloced_tmp);
					thrust::device_ptr<unsigned char> d_col_dest((unsigned char*)thrust::raw_pointer_cast(a->d_columns_int[colname].data()));
					thrust::gather(a->prm_d.begin(), a->prm_d.begin() + g_size, d_col_source, d_col_dest + offset);
			}
			else if(cpy_bits[colname] == 16) {
					thrust::device_ptr<unsigned short int> d_col_source((unsigned short int*)alloced_tmp);
					thrust::device_ptr<unsigned short int> d_col_dest((unsigned short int*)thrust::raw_pointer_cast(a->d_columns_int[colname].data()));
					thrust::gather(a->prm_d.begin(), a->prm_d.begin() + g_size, d_col_source, d_col_dest + offset);
			}
			else if(cpy_bits[colname] == 32) {
					thrust::device_ptr<unsigned int> d_col_source((unsigned int*)alloced_tmp);
					thrust::device_ptr<unsigned int> d_col_dest((unsigned int*)thrust::raw_pointer_cast(a->d_columns_int[colname].data()));
					thrust::gather(a->prm_d.begin(), a->prm_d.begin() + g_size, d_col_source, d_col_dest + offset);
			}	
			else if(cpy_bits[colname] == 64) {
					thrust::device_ptr<int_type> d_col((int_type*)alloced_tmp);
					thrust::gather(a->prm_d.begin(), a->prm_d.begin() + g_size, d_col, a->d_columns_int[colname].begin() + offset);
			};					
		}
		else {
			thrust::device_ptr<int_type> d_col((int_type*)alloced_tmp);
			thrust::gather(a->prm_d.begin(), a->prm_d.begin() + g_size, d_col, a->d_columns_int[colname].begin() + offset);			
		};

    }
    else  {
		if(cpy_bits.find(colname) != cpy_bits.end()) { // non-delta compression			
			if(cpy_bits[colname] == 8) {
					thrust::device_ptr<unsigned char> d_col_source((unsigned char*)alloced_tmp);
					thrust::device_ptr<unsigned char> d_col_dest((unsigned char*)thrust::raw_pointer_cast(a->d_columns_float[colname].data()));
					thrust::gather(a->prm_d.begin(), a->prm_d.begin() + g_size, d_col_source, d_col_dest + offset);
			}
			else if(cpy_bits[colname] == 16) {
					thrust::device_ptr<unsigned short int> d_col_source((unsigned short int*)alloced_tmp);
					thrust::device_ptr<unsigned short int> d_col_dest((unsigned short int*)thrust::raw_pointer_cast(a->d_columns_float[colname].data()));
					thrust::gather(a->prm_d.begin(), a->prm_d.begin() + g_size, d_col_source, d_col_dest + offset);
			}
			else if(cpy_bits[colname] == 32) {
					thrust::device_ptr<unsigned int> d_col_source((unsigned int*)alloced_tmp);
					thrust::device_ptr<unsigned int> d_col_dest((unsigned int*)thrust::raw_pointer_cast(a->d_columns_float[colname].data()));
					thrust::gather(a->prm_d.begin(), a->prm_d.begin() + g_size, d_col_source, d_col_dest + offset);
			}	
			else if(cpy_bits[colname] == 64) {
					thrust::device_ptr<int_type> d_col((int_type*)alloced_tmp);
					thrust::gather(a->prm_d.begin(), a->prm_d.begin() + g_size, d_col, a->d_columns_float[colname].begin() + offset);
			};					
		}
		else {		
			thrust::device_ptr<float_type> d_col((float_type*)alloced_tmp);
			thrust::gather(a->prm_d.begin(), a->prm_d.begin() + g_size, d_col, a->d_columns_float[colname].begin() + offset);
		};	
    }
};

void mycopy(string colname, CudaSet* a, CudaSet* t, size_t offset, size_t g_size)
{
    if(t->type[colname] != 1) {
		if(cpy_bits.find(colname) != cpy_bits.end()) { // non-delta compression
			if(cpy_bits[colname] == 8) {
					thrust::device_ptr<unsigned char> d_col_source((unsigned char*)alloced_tmp);
					thrust::device_ptr<unsigned char> d_col_dest((unsigned char*)thrust::raw_pointer_cast(a->d_columns_int[colname].data()));
					thrust::copy(d_col_source, d_col_source + g_size, d_col_dest + offset);
			}
			else if(cpy_bits[colname] == 16) {
					thrust::device_ptr<short int> d_col_source((short int*)alloced_tmp);
					thrust::device_ptr<short int> d_col_dest((short int*)thrust::raw_pointer_cast(a->d_columns_int[colname].data()+offset));
					thrust::copy(d_col_source, d_col_source + g_size, d_col_dest + offset);
			}
			else if(cpy_bits[colname] == 32) {
					thrust::device_ptr<unsigned int> d_col_source((unsigned int*)alloced_tmp);
					thrust::device_ptr<unsigned int> d_col_dest((unsigned int*)thrust::raw_pointer_cast(a->d_columns_int[colname].data()));
					thrust::copy(d_col_source, d_col_source + g_size, d_col_dest + offset);
			}	
			else if(cpy_bits[colname] == 64) {
					thrust::device_ptr<int_type> d_col_source((int_type*)alloced_tmp);
					thrust::copy(d_col_source, d_col_source + g_size, a->d_columns_int[colname].begin() + offset);
			};					
		}
		else {		
			thrust::device_ptr<int_type> d_col((int_type*)alloced_tmp);
			thrust::copy(d_col, d_col + g_size, a->d_columns_int[colname].begin() + offset);
		};
    }
    else {
		if(cpy_bits.find(colname) != cpy_bits.end()) { // non-delta compression
			if(cpy_bits[colname] == 8) {
					thrust::device_ptr<unsigned char> d_col_source((unsigned char*)alloced_tmp);
					thrust::device_ptr<unsigned char> d_col_dest((unsigned char*)thrust::raw_pointer_cast(a->d_columns_float[colname].data()));
					thrust::copy(d_col_source, d_col_source + g_size, d_col_dest + offset);
			}
			else if(cpy_bits[colname] == 16) {
					thrust::device_ptr<short int> d_col_source((short int*)alloced_tmp);
					thrust::device_ptr<short int> d_col_dest((short int*)thrust::raw_pointer_cast(a->d_columns_float[colname].data()+offset));
					thrust::copy(d_col_source, d_col_source + g_size, d_col_dest + offset);
			}
			else if(cpy_bits[colname] == 32) {
					thrust::device_ptr<unsigned int> d_col_source((unsigned int*)alloced_tmp);
					thrust::device_ptr<unsigned int> d_col_dest((unsigned int*)thrust::raw_pointer_cast(a->d_columns_float[colname].data()));
					thrust::copy(d_col_source, d_col_source + g_size, d_col_dest + offset);						
			}	
			else if(cpy_bits[colname] == 64) {
					thrust::device_ptr<int_type> d_col_source((int_type*)alloced_tmp);
					thrust::copy(d_col_source, d_col_source + g_size, a->d_columns_float[colname].begin() + offset);
			};					
		}
		else {		
			thrust::device_ptr<float_type> d_col((float_type*)alloced_tmp);
			thrust::copy(d_col, d_col + g_size,	a->d_columns_float[colname].begin() + offset);
		};	
	};
};



size_t load_queue(queue<string> c1, CudaSet* right, string f2, size_t &rcount,
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
        }
        else if(a->type[a->columnNames[i]] == 0 && a->string_map.find(a->columnNames[i]) != a->string_map.end()) {
            auto s = a->string_map[a->columnNames[i]];
            auto pos = s.find_first_of(".");
            auto len = data_dict[s.substr(0, pos)][s.substr(pos+1)].col_length;
            if (len > max_char1)
                max_char1 = len;
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


void filter_op(const char *s, const char *f, unsigned int segment)
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
        b->string_map = a->string_map;
        size_t cnt = 0;
        allocColumns(a, b->fil_value);

        if (b->prm_d.size() == 0)
            b->prm_d.resize(a->maxRecs);

        //cout << endl << "MAP CHECK start " << segment <<  endl;
        char map_check = zone_map_check(b->fil_type,b->fil_value,b->fil_nums, b->fil_nums_f, a, segment);
        //cout << endl << "MAP CHECK segment " << segment << " " << map_check <<  endl;

        if(map_check == 'R') {
			auto old_ph = phase_copy;
			phase_copy = 0;
            copyColumns(a, b->fil_value, segment, cnt);
			phase_copy = old_ph;			
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
        cout << endl << "filter res " << b->mRecCount << " " << phase_copy << endl;
    //std::cout<< "filter time " <<  ( ( std::clock() - start1 ) / (double)CLOCKS_PER_SEC ) << " " << getFreeMem() << '\n';
}




size_t load_right(CudaSet* right, string colname, string f2, queue<string> op_g, queue<string> op_sel,
                  queue<string> op_alt, bool decimal_join, size_t& rcount, unsigned int start_seg, unsigned int end_seg, bool rsz) {

    size_t cnt_r = 0;
    //if join is on strings then add integer columns to left and right tables and modify colInd1 and colInd2

    // need to allocate all right columns
    if(right->not_compressed) {
        queue<string> op_alt1;
        op_alt1.push(f2);
        cnt_r = load_queue(op_alt1, right, "", rcount, start_seg, end_seg, rsz, 1);
    }
    else {
        cnt_r = load_queue(op_alt, right, f2, rcount, start_seg, end_seg, rsz, 1);
    };


    /*    if (right->type[colname]  == 2) {
            str_join = 1;
            right->d_columns_int[f2] = thrust::device_vector<int_type>();
            for(unsigned int i = start_seg; i < end_seg; i++) {
                right->add_hashed_strings(f2, i);
            };
            cnt_r = right->d_columns_int[f2].size();
        };
    */
	
	
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
            cnt_r = load_queue(op_alt1, right, "", rcount, start_seg, end_seg, 0, 0);
    };
    return cnt_r;
};



void insert_records(const char* f, const char* s) {
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
		
				if(a->type[a->columnNames[z]] != 2) {
					str_s = a->load_file_name + "." + a->columnNames[z] + "." + to_string(i);
					str_d = b->load_file_name + "." + a->columnNames[z] + "." + to_string(b->segCount + i);
					cout << str_s << " " << str_d << endl;
					FILE* source = fopen(str_s.c_str(), "rb");
					FILE* dest = fopen(str_d.c_str(), "wb");
					while (size = fread(buf, 1, BUFSIZ, source)) {
						fwrite(buf, 1, size, dest);
					}
					fclose(source);
					fclose(dest);
				}
				else { //merge strings
					//read b's strings
					str_s = b->load_file_name + "." + b->columnNames[z];
					FILE* dest = fopen(str_s.c_str(), "rb");
					auto len = b->char_size[b->columnNames[z]];
					map<string, unsigned long long int> map_d;
					buf[len] = 0;
					unsigned long long cnt = 0;
					while (fread(buf, len, 1, dest)) {
						map_d[buf] = cnt;
						cnt++;
					};
					fclose(dest);
					unsigned long long int cct = cnt;
					
					str_s = a->load_file_name + "." + a->columnNames[z] + "." + to_string(i) + ".hash";
					str_d = b->load_file_name + "." + b->columnNames[z] + "." + to_string(b->segCount + i) + ".hash";
					FILE* source = fopen(str_s.c_str(), "rb");
					dest = fopen(str_d.c_str(), "wb");
					while (size = fread(buf, 1, BUFSIZ, source)) {
						fwrite(buf, 1, size, dest);
					}
					fclose(source);
					fclose(dest);
					
					str_s = a->load_file_name + "." + a->columnNames[z];
					source = fopen(str_s.c_str(), "rb");
					map<unsigned long long int, string> map_s;
					buf[len] = 0;
					cnt = 0;
					while (fread(buf, len, 1, source)) {
						map_s[cnt] = buf;
						cnt++;
					};
					fclose(source);
					
					queue<string> op_vx;
					op_vx.push(a->columnNames[z]);
					allocColumns(a, op_vx);
					a->resize(a->maxRecs);
					a->CopyColumnToGpu(a->columnNames[z], z, 0);
					a->CopyColumnToHost(a->columnNames[z]);
					
					str_d = b->load_file_name + "." + b->columnNames[z];					
                    fstream f_file;
                    f_file.open(str_d.c_str(), ios::out|ios::app|ios::binary);
					
					for(auto j = 0; j < a->mRecCount; j++) {
						auto ss = map_s[a->h_columns_int[a->columnNames[z]][j]];
						if(map_d.find(ss) == map_d.end()) { //add
							f_file.write((char *)ss.c_str(), len);
							a->h_columns_int[a->columnNames[z]][j] = cct;
							cct++;							
						}
						else {
							a->h_columns_int[a->columnNames[z]][j] = map_d[ss];
						};
					};											
					f_file.close();	
					
					thrust::device_vector<int_type> d_col(a->mRecCount);
					thrust::copy(a->h_columns_int[a->columnNames[z]].begin(), a->h_columns_int[a->columnNames[z]].begin() + a->mRecCount, d_col.begin());
					auto i_name = b->load_file_name + "." + b->columnNames[z] + "." + to_string(b->segCount + i) + ".idx";
					pfor_compress(thrust::raw_pointer_cast(d_col.data()), a->mRecCount*int_size, i_name, a->h_columns_int[a->columnNames[z]], 0);					
				};	
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
        for(unsigned int i = 0; i < b->columnNames.size(); i++) {
            b->writeHeader(b->load_file_name, b->columnNames[i], total_segments);
        };
    };
};



void delete_records(const char* f) {

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
        for ( auto it=data_dict[a->load_file_name].begin() ; it != data_dict[a->load_file_name].end(); ++it ) {
            op_vx.push((*it).first);
            if (std::find(a->columnNames.begin(), a->columnNames.end(), (*it).first) == a->columnNames.end()) {

                if ((*it).second.col_type == 0) {
                    a->type[(*it).first] = 0;
                    a->decimal[(*it).first] = 0;
                    //a->h_columns_int[(*it).first] = thrust::host_vector<int_type, pinned_allocator<int_type> >();
                    a->h_columns_int[(*it).first] = thrust::host_vector<int_type>();
                    a->d_columns_int[(*it).first] = thrust::device_vector<int_type>();
                }
                else if((*it).second.col_type == 1) {
                    a->type[(*it).first] = 1;
                    a->decimal[(*it).first] = 0;
                    //a->h_columns_float[(*it).first] = thrust::host_vector<float_type, pinned_allocator<float_type> >();
                    a->h_columns_float[(*it).first] = thrust::host_vector<float_type>();
                    a->d_columns_float[(*it).first] = thrust::device_vector<float_type>();
                }
                else if ((*it).second.col_type == 3) {
                    a->type[(*it).first] = 1;
                    a->decimal[(*it).first] = 1;
                    //a->h_columns_float[(*it).first] = thrust::host_vector<float_type, pinned_allocator<float_type> >();
                    a->h_columns_float[(*it).first] = thrust::host_vector<float_type>();
                    a->d_columns_float[(*it).first] = thrust::device_vector<float_type>();
                }
                else {
                    a->type[(*it).first] = 2;
                    a->decimal[(*it).first] = 0;
                    a->h_columns_char[(*it).first] = nullptr;
                    a->d_columns_char[(*it).first] = nullptr;
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
                                for (auto it=data_dict[a->load_file_name].begin() ; it != data_dict[a->load_file_name].end(); ++it ) {
                                    auto colname = (*it).first;
                                    str_old = a->load_file_name + "." + colname + "." + to_string(i);
                                    str = a->load_file_name + "." + colname + "." + to_string(new_seg_count);
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
                                str = a->load_file_name + "." + colname + "." + to_string(new_seg_count);

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
                                    thrust::device_ptr<int_type> d_col((int_type*)d);
                                    thrust::gather(a->prm_d.begin(), a->prm_d.begin() + a->mRecCount, a->d_columns_int[colname].begin(), d_col);
                                    pfor_compress( d, a->mRecCount*int_size, str + ".hash", a->h_columns_int[colname], 0);
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
                    for(unsigned int z = 0; z < a->columnNames.size(); z++) {
                        str_old = a->load_file_name + "." + a->columnNames[z] + "." + to_string(i);
                        str = a->load_file_name + "." + a->columnNames[z] + "." + to_string(new_seg_count);
                        remove(str.c_str());
                        rename(str_old.c_str(), str.c_str());
                    };
                };
                new_seg_count++;
                maxRecs	= a->maxRecs;
            };
        };

        if (new_seg_count < a->segCount) {
            for(unsigned int i = new_seg_count; i < a->segCount; i++) {
                //cout << "delete segment " << i << endl;
                for(unsigned int z = 0; z < a->columnNames.size(); z++) {
                    str = a->load_file_name + "." + a->columnNames[z];
                    str += "." + to_string(i);
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
    for (auto it=data_dict.begin() ; it != data_dict.end(); ++it ) {
        str_len = (*it).first.size();
        binary_file.write((char *)&str_len, 8);
        binary_file.write((char *)(*it).first.data(), str_len);
        map<string, col_data> s = (*it).second;
        size_t len1 = s.size();
        binary_file.write((char *)&len1, 8);

        for (auto sit=s.begin() ; sit != s.end(); ++sit ) {
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
        cout << "Couldn't open data dictionary" << endl;
    };
}

bool var_exists(CudaSet* a, string name) {

    if(std::find(a->columnNames.begin(), a->columnNames.end(), name) !=  a->columnNames.end())
        return 1;
    else

        return 0;
}

int file_exist (const char *filename)
{
    std::ifstream infile(filename);
    return infile.good();
}

bool check_bitmap_file_exist(CudaSet* left, CudaSet* right)
{
    queue<string> cols(right->fil_value);
    bool bitmaps_exist = 1;

    if(cols.size() == 0) {
        bitmaps_exist = 0;
    };
    while(cols.size() ) {
        if (std::find(right->columnNames.begin(), right->columnNames.end(), cols.front()) != right->columnNames.end()) {
            string fname = left->load_file_name + "."  + right->load_file_name + "." + cols.front() + ".0";
            if( !file_exist(fname.c_str())) {
                bitmaps_exist = 0;
            };
        };
        cols.pop();
    };
    return bitmaps_exist;
}

bool check_bitmaps_exist(CudaSet* left, CudaSet* right)
{
    //check if there are join bitmap indexes
    queue<string> cols(right->fil_value);
    bool bitmaps_exist = 1;

    if(cols.size() == 0) {
        bitmaps_exist = 1;
        return 1;
    };
    while(cols.size() ) {
        if (std::find(right->columnNames.begin(), right->columnNames.end(), cols.front()) != right->columnNames.end()) {
            string fname = left->load_file_name + "."  + right->load_file_name + "." + cols.front() + ".0";
            if( !file_exist(fname.c_str())) {
                bitmaps_exist = 0;
            };
        };
        cols.pop();
    };
    if(bitmaps_exist) {
        while(!right->fil_nums.empty() ) {
            left->fil_nums.push(right->fil_nums.front());
            right->fil_nums.pop();
        };
        while(!right->fil_nums_f.empty() ) {
            left->fil_nums_f.push(right->fil_nums_f.front());
            right->fil_nums_f.pop();
        };
        while(!right->fil_value.empty() ) {
            if (std::find(right->columnNames.begin(), right->columnNames.end(), right->fil_value.front()) != right->columnNames.end()) {
                string fname = left->load_file_name + "."  + right->load_file_name + "." + right->fil_value.front();
                left->fil_value.push(fname);
            }
            else
                left->fil_value.push(right->fil_value.front());
            right->fil_value.pop();
        };
        bool add_and = 1;
        if(left->fil_type.empty())
            add_and = 0;
        while(!right->fil_type.empty() ) {
            left->fil_type.push(right->fil_type.front());
            right->fil_type.pop();
        };
        if(add_and) {
            left->fil_type.push("AND");
        };
        return 1;
    }
    else {
        return 0;
    };
}


void check_sort(const string str, const char* rtable, const char* rid)
{
    CudaSet* right = varNames.find(rtable)->second;
    fstream binary_file(str.c_str(),ios::out|ios::binary|ios::app);
    binary_file.write((char *)&right->sort_check, 1);
    binary_file.close();
}

void update_char_permutation(CudaSet* a, string colname, unsigned int* raw_ptr, string ord, void* temp, bool host)
{    
    auto s = a->string_map[colname];
    auto pos = s.find_first_of(".");
    auto len = data_dict[s.substr(0, pos)][s.substr(pos+1)].col_length;
	
    a->h_columns_char[colname] = new char[a->mRecCount*len];
    memset(a->h_columns_char[colname], 0, a->mRecCount*len);
	
	thrust::device_ptr<unsigned int> perm(raw_ptr);
	thrust::device_ptr<int_type> temp_int((int_type*)temp);	
	thrust::gather(perm, perm+a->mRecCount, a->d_columns_int[colname].begin(), temp_int);
	
	//for(int z = 0 ; z < a->mRecCount; z++) {
	//cout << "Init vals " << a->d_columns_int[colname][z] << " " << perm[z] << " " << temp_int[z] << endl;
	//};
	
	//cout << "sz " << a->h_columns_int[colname].size() << " " << a->d_columns_int[colname].size() <<  " " << len << endl;
	cudaMemcpy(thrust::raw_pointer_cast(a->h_columns_int[colname].data()), temp, 8*a->mRecCount, cudaMemcpyDeviceToHost);

    FILE *f;
    f = fopen(a->string_map[colname].c_str(), "rb");

    for(int z = 0 ; z < a->mRecCount; z++) {
        fseek(f, a->h_columns_int[colname][z] * len, SEEK_SET);
        fread(a->h_columns_char[colname] + z*len, 1, len, f);
    };
    fclose(f);

    if(!host) {
        void *d;
        cudaMalloc((void **) &d, a->mRecCount*len);
        a->d_columns_char[colname] = (char*)d;

        cudaMemcpy(a->d_columns_char[colname], a->h_columns_char[colname], len*a->mRecCount, cudaMemcpyHostToDevice);
		
	    if (ord.compare("DESC") == 0 )
			str_sort(a->d_columns_char[colname], a->mRecCount, raw_ptr, 1, len);
		else
			str_sort(a->d_columns_char[colname], a->mRecCount, raw_ptr, 0, len);
			
        cudaFree(d);
    }
    else {
	    if (ord.compare("DESC") == 0 )
			str_sort_host(a->h_columns_char[colname], a->mRecCount, raw_ptr, 1, len);
		else
			str_sort_host(a->h_columns_char[colname], a->mRecCount, raw_ptr, 0, len);
    };
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

