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

#include <thrust/device_ptr.h>
#include <thrust/device_malloc.h>
#include <thrust/device_free.h>
#include <thrust/device_vector.h>
#include <thrust/host_vector.h>
#include <thrust/copy.h>
#include <thrust/sequence.h>
#include <thrust/count.h>
#include <thrust/sort.h>
#include <thrust/set_operations.h>
#include <thrust/gather.h>
#include <thrust/scan.h>
#include <thrust/reduce.h>
#include <thrust/functional.h>
#include <thrust/iterator/constant_iterator.h>
#include <thrust/iterator/counting_iterator.h>
#include <thrust/adjacent_difference.h>
#include <thrust/transform.h>
#include <cuda.h>
#include <queue>
#include <functional>
#include <numeric>
#include <set>
#include <stack>
#include <string>
#include <map>
#include "cm.h"
#include "atof.h"
#include "itoa.h"
#include "compress.cu"


#ifdef _WIN64
#define fseeko _fseeki64
#define ftello _ftelli64
#else
#define _FILE_OFFSET_BITS 64
#define fseeko fseek
#define ftello ftell
#endif


using namespace std;
using namespace thrust::placeholders;

unsigned int process_count;
long long int totalRecs = 0;
bool fact_file_loaded = 0;
char map_check;
unsigned long long int total_count = 0;
unsigned int total_segments = 0;
unsigned int total_max;
void* d_v = NULL;
void* s_v = NULL;
unsigned int oldCount;
queue<string> op_type;
queue<string> op_value;
queue<int_type> op_nums;
queue<float_type> op_nums_f;



template <typename HeadFlagType>
struct head_flag_predicate
        : public thrust::binary_function<HeadFlagType,HeadFlagType,bool>
{
    __host__ __device__
    bool operator()(HeadFlagType left, HeadFlagType right) const
    {
        return !left;
    }
};

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

struct float_to_long
{

    __host__ __device__
    long long int operator()(const float_type x)
    {
        if ((long long int)((x+EPSILON)*100.0) > (long long int)(x*100.0))
            return (long long int)((x+EPSILON)*100.0);
        else return (long long int)(x*100.0);


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

struct Uint2Sum
{
    __host__ __device__  uint2 operator()(uint2& a, uint2& b)
    {
        //a.x += b.x;
        a.y += b.y;
        return a;
    }
};


struct uint2_split
{

    const uint2* d_res;
    unsigned int * output;

    uint2_split(const uint2* _d_res, unsigned int * _output):
        d_res(_d_res), output(_output) {}

    template <typename IndexType>
    __host__ __device__
    void operator()(const IndexType & i) {

        output[i] = d_res[i].y;

    }
};




struct join_functor
{

    const uint2* d_res;
    const unsigned int* d_addr;
    unsigned int * output;
    unsigned int * output1;

    join_functor(const uint2* _d_res, const unsigned int * _d_addr, unsigned int * _output, unsigned int * _output1):
        d_res(_d_res), d_addr(_d_addr), output(_output), output1(_output1) {}

    template <typename IndexType>
    __host__ __device__
    void operator()(const IndexType & i) {

        if (d_res[i].x || d_res[i].y) {
            for(unsigned int z = 0; z < d_res[i].y; z++) {
                output[d_addr[i] + z] = i;
                output1[d_addr[i] + z] = d_res[i].x + z;
            };
        };
    }
};



struct cmp_functor
{
    const char * src;
    int_type * output;
    const char * str;
    const unsigned int * len;

    cmp_functor(const char * _src, int_type * _output, const char * _str, const unsigned int * _len):
        src(_src), output(_output), str(_str), len(_len) {}

    template <typename IndexType>
    __host__ __device__
    void operator()(const IndexType & i) {

        if(src[i] != 0 && output[i] >= 0 && output[i] < *len ) {
            if ( src[i] == str[(*len-output[i]) - 1])
                output[i]++;
            else
                output[i] = -1;
        };
    }
};

class CudaSet;
void allocColumns(CudaSet* a, queue<string> fields);
void copyColumns(CudaSet* a, queue<string> fields, unsigned int segment, unsigned int& count);
void mygather(unsigned int tindex, unsigned int idx, CudaSet* a, CudaSet* t, unsigned int count, unsigned int g_size);
void mycopy(unsigned int tindex, unsigned int idx, CudaSet* a, CudaSet* t, unsigned int count, unsigned int g_size);
unsigned int findSegmentCount(char* file_name);

map<string,CudaSet*> varNames; //  STL map to manage CudaSet variables
map<string,string> setMap; //map to keep track of column names and set names
unsigned int curr_segment = 10000000;

size_t getFreeMem();
char zone_map_check(queue<string> op_type, queue<string> op_value, queue<int_type> op_nums,queue<float_type> op_nums_f, CudaSet* a, unsigned int segment);


class CudaChar
{
public:
    std::vector<thrust::host_vector<char> > h_columns;
    std::vector<thrust::device_vector<char> > d_columns;
    thrust::host_vector<char> compressed;
    unsigned int mColumnCount;
    unsigned int mRecCount;


    CudaChar(unsigned int columnCount, unsigned int Recs)
        : mColumnCount(0),
          mRecCount(0)
    {
        initialize(columnCount, Recs);
    }

    CudaChar(unsigned int columnCount, unsigned int Recs, bool gpu)
        : mColumnCount(0),
          mRecCount(0)
    {
        initialize(columnCount, Recs, gpu);
    }

    CudaChar(unsigned int columnCount, unsigned int Recs, bool gpu, long long int compressed_size)
        : mColumnCount(0),
          mRecCount(0)
    {
        initialize(columnCount, Recs, gpu, compressed_size);
    }


    void findMinMax(string& minStr, string& maxStr)
    {
        thrust::device_ptr<unsigned int> permutation = thrust::device_malloc<unsigned int>(mRecCount);
        thrust::sequence(permutation, permutation+mRecCount);

        unsigned int* raw_ptr = thrust::raw_pointer_cast(permutation);
        void* temp;
        CUDA_SAFE_CALL(cudaMalloc((void **) &temp, mRecCount));

        for(int j=mColumnCount-1; j>=0 ; j--)
            update_permutation(d_columns[j], raw_ptr, mRecCount, "ASC", (char*)temp);

        minStr = "";
        maxStr = "";

        for(unsigned int j=0; j<mColumnCount; j++) {
            minStr+=(d_columns[j])[permutation[0]];
            maxStr+=(d_columns[j])[permutation[mRecCount-1]];
        };

        cudaFree(temp);
        cudaFree(raw_ptr);
    }


    void resize(unsigned int addRecs)
    {
        mRecCount = mRecCount + addRecs;
        for(unsigned int i=0; i <mColumnCount; i++)
            h_columns[i].resize(mRecCount);
    }

    void allocOnDevice(unsigned int RecordCount)
    {
        mRecCount = RecordCount;
        for(unsigned int i=0; i <mColumnCount; i++)
            d_columns[i].resize(mRecCount);

    }

    void deAllocOnDevice()
    {
        if (d_columns.size())
            for(unsigned int i=0; i <mColumnCount; i++) {
                d_columns[i].resize(0);
                d_columns[i].shrink_to_fit();
            };
    };


    void CopyToGpu(unsigned int offset, unsigned int count)
    {
        for(unsigned int i = 0; i < mColumnCount; i++)
            thrust::copy(h_columns[i].begin() + offset, h_columns[i].begin() + offset +count, d_columns[i].begin());
    };


    void CopyToHost(unsigned int offset, unsigned int count)
    {
        for(unsigned int i = 0; i < mColumnCount; i++)
            thrust::copy(d_columns[i].begin(), d_columns[i].begin() + count, h_columns[i].begin() + offset);
    };


    bool* cmpStr(string str)
    {

        if (str[str.size()-1] == '%' && str[0] == '%') { // contains
            if(str.size() > mColumnCount) {
                thrust::device_ptr<bool> res_f = thrust::device_malloc<bool>(mRecCount);
                thrust::sequence(res_f, res_f+mRecCount, 0, 0);
                return thrust::raw_pointer_cast(res_f);
            }
            else {

                return 0;

            };
        }
        else if(str[str.size()-1] == '%') {  // startsWith

            if(str.size() > mColumnCount) {
                thrust::device_ptr<bool> res_f = thrust::device_malloc<bool>(mRecCount);
                thrust::sequence(res_f, res_f+mRecCount, 0, 0);
                return thrust::raw_pointer_cast(res_f);
            }
            else {

                thrust::device_ptr<bool> v = thrust::device_malloc<bool>(mRecCount);

                str.erase(str.size()-1,1);
                thrust::device_ptr<bool> res = thrust::device_malloc<bool>(mRecCount);
                thrust::sequence(res, res+mRecCount, 1, 0);

                for(int i = 0; i < str.size()-1; i++) {
                    thrust::transform(d_columns[i].begin(), d_columns[i].begin()+mRecCount, thrust::constant_iterator<char>(str[i]), v, thrust::equal_to<char>());
                    thrust::transform(v, v+mRecCount, res, res, thrust::logical_and<bool>());
                };
                thrust::device_free(v);
                return thrust::raw_pointer_cast(res);
            };

        }
        else if(str[0] == '%' ) {  // endsWith

            str.erase(0,1);
            thrust::device_ptr<char> dev_str = thrust::device_malloc<char>(str.size());
            thrust::device_ptr<unsigned int> len = thrust::device_malloc<unsigned int>(1);
            thrust::device_ptr<int_type> output = thrust::device_malloc<int_type>(mRecCount);
            thrust::device_ptr<bool> res = thrust::device_malloc<bool>(mRecCount);
            thrust::sequence(output, output+mRecCount, 0, 0);

            len[0] = str.size();
            for(int z=0; z < str.size(); z++)
                dev_str[z] = str[z];

            for(int i = mColumnCount-1; i >= 0; i--) {
                thrust::counting_iterator<unsigned int, thrust::device_space_tag> begin(0);
                cmp_functor ff(thrust::raw_pointer_cast(d_columns[i].data()),
                               thrust::raw_pointer_cast(output),
                               thrust::raw_pointer_cast(dev_str),
                               thrust::raw_pointer_cast(len));
                thrust::for_each(begin, begin + mRecCount, ff);
            };
            thrust::transform(output, output+mRecCount, res, to_zero());
            return thrust::raw_pointer_cast(res);
        }
        else {                          // equal
            thrust::device_ptr<bool> v = thrust::device_malloc<bool>(mRecCount);
            thrust::device_ptr<bool> res = thrust::device_malloc<bool>(mRecCount);
            thrust::sequence(res, res+mRecCount, 1, 0);

            if(mColumnCount < str.length())
            {
                thrust::sequence(res, res+mRecCount, 0, 0);
                return thrust::raw_pointer_cast(res);
            };

            for(unsigned int i = 0; i < mColumnCount; i++) {
                if (str.length() >= i+1)
                    thrust::transform(d_columns[i].begin(), d_columns[i].begin()+mRecCount, thrust::constant_iterator<char>(str[i]), v, thrust::equal_to<char>());
                else
                    thrust::transform(d_columns[i].begin(), d_columns[i].begin()+mRecCount, thrust::constant_iterator<char>(0), v, thrust::equal_to<char>());
                thrust::transform(v, v+mRecCount, res, res, thrust::logical_and<int_type>());
            };
            thrust::device_free(v);
            return thrust::raw_pointer_cast(res);
        };
    };


protected: // methods

    void initialize(unsigned int columnCount, unsigned int Recs)
    {
        mColumnCount = columnCount;
        mRecCount = Recs;

        for(unsigned int i=0; i <mColumnCount; i++) {
            h_columns.push_back(thrust::host_vector<char>(Recs));
            d_columns.push_back(thrust::device_vector<char>());
        };
    };

    void initialize(unsigned int columnCount, unsigned int Recs, bool gpu)
    {
        mColumnCount = columnCount;
        mRecCount = Recs;

        for(unsigned int i=0; i <mColumnCount; i++) {
            h_columns.push_back(thrust::host_vector<char>());
            d_columns.push_back(thrust::device_vector<char>());
        };
    };

    void initialize(unsigned int columnCount, unsigned int Recs, bool gpu, long long int compressed_size)
    {
        mColumnCount = columnCount;
        mRecCount = Recs;

        for(unsigned int i=0; i <mColumnCount; i++) {
            h_columns.push_back(thrust::host_vector<char>());
            d_columns.push_back(thrust::device_vector<char>());
        };
        compressed.resize(compressed_size);
    };


};



class CudaSet
{
public:
    std::vector<thrust::host_vector<int_type> > h_columns_int;
    std::vector<thrust::host_vector<float_type> > h_columns_float;
    std::vector<thrust::host_vector<char> > h_columns_char;
    std::vector<CudaChar*> h_columns_cuda_char;

    std::vector<thrust::device_vector<int_type> > d_columns_int;
    std::vector<thrust::device_vector<float_type> > d_columns_float;
    thrust::device_vector<unsigned int> prm_d;
    std::vector<unsigned int*> prm; //represents an op's permutation of original data vectors
    //string is a set name
    //unsigned int* is an adress of the permutation array
    std::vector<unsigned int> prm_count;	// counts of prm permutations
    std::vector<char> prm_index; // A - all segments values match, N - none match, R - some may match
    map<unsigned int, unsigned int> type_index;

    unsigned int mColumnCount;
    unsigned int mRecCount;
    map<string,int> columnNames;
    map<string, FILE*> filePointers;
    bool *grp;
    queue<string> columnGroups;
    bool fact_table; // 1 = host recs are not compressed, 0 = compressed
    FILE *file_p;
    unsigned int *seq;
    bool keep;
    unsigned int segCount, maxRecs;
    string name;
    char* load_file_name;
    unsigned int oldRecCount;

    unsigned int* type; // 0 - integer, 1-float_type, 2-char
    bool* decimal; // column is decimal - affects only compression
    unsigned int* grp_type; // type of group : SUM, AVG, COUNT etc
    unsigned int* cols; // column positions in a file
    unsigned int grp_count;
    bool partial_load;


    CudaSet(queue<string> &nameRef, queue<string> &typeRef, queue<int> &sizeRef, queue<int> &colsRef, int_type Recs)
        : mColumnCount(0),
          mRecCount(0)
    {
        initialize(nameRef, typeRef, sizeRef, colsRef, Recs);
        keep = false;
        partial_load = 0;
    }

    CudaSet(queue<string> &nameRef, queue<string> &typeRef, queue<int> &sizeRef, queue<int> &colsRef, int_type Recs, char* file_name)
        : mColumnCount(0),
          mRecCount(0)
    {
        initialize(nameRef, typeRef, sizeRef, colsRef, Recs, file_name);
        keep = false;
        partial_load = 1;
    }



    CudaSet(unsigned int RecordCount, unsigned int ColumnCount)
    {
        initialize(RecordCount, ColumnCount);
        keep = false;
        partial_load = 0;
    };



    CudaSet(CudaSet* a, CudaSet* b, int_type Recs, queue<string> op_sel, queue<string> op_sel_as)
    {
        initialize(a,b,Recs, op_sel, op_sel_as);
        keep = false;
        partial_load = 0;
    };


    ~CudaSet()
    {
        free();
    }



    void resize(unsigned int addRecs)
    {
        mRecCount = mRecCount + addRecs;

        for(unsigned int i=0; i <mColumnCount; i++) {
            if(type[i] == 0)
                h_columns_int[type_index[i]].resize(mRecCount);
            else if(type[i] == 1)
                h_columns_float[type_index[i]].resize(mRecCount);
            else
                h_columns_cuda_char[type_index[i]]->resize(addRecs);
        };
    }


    void allocColumnOnDevice(unsigned int colIndex, unsigned int RecordCount)
    {
        if (type[colIndex] == 0)
            d_columns_int[type_index[colIndex]].resize(RecordCount);
        else if (type[colIndex] == 1)
            d_columns_float[type_index[colIndex]].resize(RecordCount);
        else
            h_columns_cuda_char[type_index[colIndex]]->allocOnDevice(RecordCount);
    };


    void deAllocColumnOnDevice(unsigned int colIndex)
    {
        if (type[colIndex] == 0 && d_columns_int.size()) {
            d_columns_int[type_index[colIndex]].resize(0);
            d_columns_int[type_index[colIndex]].shrink_to_fit();
        }
        else if (type[colIndex] == 1 && d_columns_float.size()) {
            d_columns_float[type_index[colIndex]].resize(0);
            d_columns_float[type_index[colIndex]].shrink_to_fit();
        }
        else if (type[colIndex] == 2 && h_columns_cuda_char.size())
            h_columns_cuda_char[type_index[colIndex]]->deAllocOnDevice();
    };

    void allocOnDevice(unsigned int RecordCount)
    {
        for(unsigned int i=0; i < mColumnCount; i++)
            allocColumnOnDevice(i, RecordCount);
    };

    void deAllocOnDevice()
    {
        for(unsigned int i=0; i <mColumnCount; i++)
            deAllocColumnOnDevice(i);
        if(!columnGroups.empty() && mRecCount !=0) {
            cudaFree(grp);
            grp = NULL;
        };
    };

    void resizeDeviceColumn(unsigned int RecCount, unsigned int colIndex)
    {
        if (RecCount) {
            if (type[colIndex] == 0)
                d_columns_int[type_index[colIndex]].resize(mRecCount+RecCount);
            else if (type[colIndex] == 1)
                d_columns_float[type_index[colIndex]].resize(mRecCount+RecCount);
            else {
                for(unsigned int i = 0; i < h_columns_cuda_char[type_index[colIndex]]->mColumnCount; i++)
                    (h_columns_cuda_char[type_index[colIndex]]->d_columns[i]).resize(mRecCount+RecCount);
            };
        };
    };



    void resizeDevice(unsigned int RecCount)
    {
        if (RecCount)
            for(unsigned int i=0; i < mColumnCount; i++)
                resizeDeviceColumn(RecCount, i);
    };

    bool onDevice(unsigned int i)
    {
        unsigned j = type_index[i];

        if (type[i] == 0) {
            if (!d_columns_int.size())
                return 0;
            if (d_columns_int[j].size() == 0)
                return 0;
        }
        else if (type[i] == 1) {
            if (!d_columns_float.size())
                return 0;
            if(d_columns_float[j].size() == 0)
                return 0;
        }
        else if  (type[i] == 2) {
            if(!h_columns_cuda_char.size())
                return 0;
            if(h_columns_cuda_char[j]->d_columns[0].size() == 0)
                return 0;
        };
        return 1;
    }




//need to remove it
    CudaSet* copyStruct(unsigned int mCount)
    {

        CudaSet* a = new CudaSet(mCount, mColumnCount);
        a->fact_table = fact_table;

        for ( map<string,int>::iterator it=columnNames.begin() ; it != columnNames.end(); ++it )
            a->columnNames[(*it).first] = (*it).second;

        for(unsigned int i=0; i < mColumnCount; i++) {
            a->cols[i] = cols[i];
            a->type[i] = type[i];

            if (a->type[i] == 0) {
                a->h_columns_int.push_back(thrust::host_vector<int_type>(mCount));
                a->d_columns_int.push_back(thrust::device_vector<int_type>());
                a->type_index[i] = a->h_columns_int.size()-1;
            }
            else if (a->type[i] == 1) {
                a->h_columns_float.push_back(thrust::host_vector<float_type>(mCount));
                a->d_columns_float.push_back(thrust::device_vector<float_type>());
                a->type_index[i] = a->h_columns_float.size()-1;
            }
            else {
                a->h_columns_cuda_char.push_back(new CudaChar((h_columns_cuda_char[type_index[i]])->mColumnCount, mCount));
                a->type_index[i] = a->h_columns_cuda_char.size()-1;
            };
        };
        return a;
    }

    CudaSet* copyDeviceStruct()
    {

        CudaSet* a = new CudaSet(mRecCount, mColumnCount);
        a->fact_table = fact_table;
        a->segCount = segCount;
        a->maxRecs = maxRecs;

        for ( map<string,int>::iterator it=columnNames.begin() ; it != columnNames.end(); ++it )
            a->columnNames[(*it).first] = (*it).second;

        for(unsigned int i=0; i < mColumnCount; i++) {
            a->cols[i] = cols[i];
            a->type[i] = type[i];

            if(a->type[i] == 0) {
                a->d_columns_int.push_back(thrust::device_vector<int_type>());
                a->h_columns_int.push_back(thrust::host_vector<int_type>());
                a->type_index[i] = a->d_columns_int.size()-1;
            }
            else if(a->type[i] == 1) {
                a->d_columns_float.push_back(thrust::device_vector<float_type>());
                a->h_columns_float.push_back(thrust::host_vector<float_type>());
                a->type_index[i] = a->d_columns_float.size()-1;
                a->decimal[i] = decimal[i];
            }
            else {
                a->h_columns_cuda_char.push_back(new CudaChar((h_columns_cuda_char[type_index[i]])->mColumnCount, mRecCount, 0));
                a->type_index[i] = a->h_columns_cuda_char.size()-1;
            };
        };

        a->mRecCount = 0;
        return a;
    }



    unsigned long long int readSegmentsFromFile(unsigned int segNum, unsigned int colIndex)
    {
        char f1[100];
        strcpy(f1, load_file_name);
        strcat(f1,".");
        char col_pos[3];
        itoaa(cols[colIndex],col_pos);
        strcat(f1,col_pos);
        FILE* f;
        int cnt, grp_count;
        unsigned long long int offset = 0;

        f = fopen (f1 , "rb" );
//        cout << "file " << f1 << " " << segNum << endl;

        for(unsigned int i = 0; i < segNum; i++) {

            if(type[colIndex] != 2) {
                fread((char *)&cnt, 4, 1, f);
                offset = offset + cnt + 8;
                fseeko(f, offset*8 , SEEK_SET);
            }
            else {
                fread((char *)&cnt, 4, 1, f);
                offset = offset + cnt*8 + 12;
                fseeko(f, offset , SEEK_SET);
                fread((char *)&grp_count, 4, 1, f);
                CudaChar* c = h_columns_cuda_char[type_index[colIndex]];
                offset = offset + 11*4 + grp_count*c->mColumnCount;
                fseeko(f, offset , SEEK_SET);
            };
        };

        // find out how much we need to read and rewind back to the start of the segment
        if(type[colIndex] != 2) {
            fread((char *)&cnt, 4, 1, f);
            fseeko(f, -4 , SEEK_CUR);
        }
        else {
            fread((char *)&cnt, 4, 1, f);
            offset = cnt*8 + 8;
            fseeko(f, offset , SEEK_CUR);
            fread((char *)&grp_count, 4, 1, f);
            fseeko(f, -(cnt*8+16) , SEEK_CUR);
        };

        // resize the host arrays if necessary
        // and read the segment from a file

        if(type[colIndex] == 0) {

            if(h_columns_int[type_index[colIndex]].size() < cnt+9) {
                //resize(cnt+9-h_columns_int[type_index[colIndex]].size());
                h_columns_int[type_index[colIndex]].resize(cnt+9);
            };
            fread(h_columns_int[type_index[colIndex]].data(),(cnt+8)*8,1,f);

        }
        else if(type[colIndex] == 1) {
            if(h_columns_float[type_index[colIndex]].size() < cnt+9) {
                //resize(cnt+9-h_columns_int[type_index[colIndex]].size());
                h_columns_float[type_index[colIndex]].resize(cnt+9);
            };
            fread(h_columns_float[type_index[colIndex]].data(),(cnt+8)*8,1,f);

        }
        else {
            CudaChar* c = h_columns_cuda_char[type_index[colIndex]];
            if(c->compressed.size() < cnt*8 + 14*4 + grp_count*c->mColumnCount)
                c->compressed.resize(cnt*8 + 14*4 + grp_count*c->mColumnCount);
            fread(c->compressed.data(), cnt*8 + 14*4 + grp_count*c->mColumnCount,1,f);
        };
        fclose(f);
        return 0;
    }


    unsigned long long int readSegments(unsigned int segNum, unsigned int colIndex) // read segNum number of segments and return the offset of the next segment
    {
        unsigned long long int offset = 0; // offset measured in bytes if checking chars and in 8 byte integers if checking ints and decimals
        unsigned int grp_count;
        unsigned int data_len;

        for(unsigned int i = 0; i < segNum; i++) {
            if(type[colIndex] == 0) {
                data_len = ((unsigned int*)((h_columns_int[type_index[colIndex]]).data() + offset))[0];
                offset = offset + data_len + 8;
            }
            else if(type[colIndex] == 1) {
                data_len = ((unsigned int*)((h_columns_float[type_index[colIndex]]).data() + offset))[0];
                offset = offset + data_len + 8;
            }
            else {
                CudaChar* c = h_columns_cuda_char[type_index[colIndex]];
                data_len = ((unsigned int*)(c->compressed.data() + offset))[0];
                grp_count = ((unsigned int*)(c->compressed.data() + offset + 8*data_len + 12))[0];
                offset = offset + data_len*8 + 14*4 + grp_count*c->mColumnCount;
            };
        };
        return offset;
    }


    void CopyToGpu(unsigned int offset, unsigned int count)
    {
        if (fact_table) {
            for(unsigned int i = 0; i < mColumnCount; i++) {
                switch(type[i]) {
                case 0 :
                    thrust::copy(h_columns_int[type_index[i]].begin() + offset, h_columns_int[type_index[i]].begin() + offset + count, d_columns_int[type_index[i]].begin());
                    break;
                case 1 :
                    thrust::copy(h_columns_float[type_index[i]].begin() + offset, h_columns_float[type_index[i]].begin() + offset + count, d_columns_float[type_index[i]].begin());
                    break;
                default :
                    (h_columns_cuda_char[type_index[i]])->CopyToGpu(offset, count);
                };
            };
        }
        else
            for(unsigned int i = 0; i < mColumnCount; i++)
                CopyColumnToGpu(i,  offset, count);
    }



    void CopyColumnToGpu(unsigned int colIndex,  unsigned int segment)
    {
        if(fact_table) {
            switch(type[colIndex]) {
            case 0 :
                thrust::copy(h_columns_int[type_index[colIndex]].begin(), h_columns_int[type_index[colIndex]].begin() + mRecCount, d_columns_int[type_index[colIndex]].begin());
                break;
            case 1 :
                thrust::copy(h_columns_float[type_index[colIndex]].begin(), h_columns_float[type_index[colIndex]].begin() + mRecCount, d_columns_float[type_index[colIndex]].begin());
                break;
            default :
                (h_columns_cuda_char[type_index[colIndex]])->CopyToGpu(0, mRecCount);
            };
        }
        else {
            //cout << "start " << colIndex << " " << type[colIndex] << " " << segment << " " << partial_load << endl;
            unsigned long long int data_offset;
            if (partial_load)
                data_offset = readSegmentsFromFile(segment,colIndex);
            else
                data_offset = readSegments(segment,colIndex);


            if(d_v == NULL)
                CUDA_SAFE_CALL(cudaMalloc((void **) &d_v, 12));
            if(s_v == NULL);
            CUDA_SAFE_CALL(cudaMalloc((void **) &s_v, 8));

            std::clock_t start1 = std::clock();
            switch(type[colIndex]) {
            case 0 :
                pfor_decompress(thrust::raw_pointer_cast(d_columns_int[type_index[colIndex]].data()), h_columns_int[type_index[colIndex]].data() + data_offset, &mRecCount, 0, NULL, d_v, s_v);
                //std::cout<< "int decomp time " <<  ( ( std::clock() - start1 ) / (double)CLOCKS_PER_SEC ) <<'\n';
                break;
            case 1 :
                if(decimal[colIndex]) {
                    pfor_decompress( thrust::raw_pointer_cast(d_columns_float[type_index[colIndex]].data()) , h_columns_float[type_index[colIndex]].data() + data_offset, &mRecCount, 0, NULL, d_v, s_v);
                    //std::cout<< "float decomp time " <<  ( ( std::clock() - start1 ) / (double)CLOCKS_PER_SEC ) <<'\n';
                    thrust::device_ptr<long long int> d_col_int((long long int*)thrust::raw_pointer_cast(d_columns_float[type_index[colIndex]].data()));
                    thrust::transform(d_col_int,d_col_int+mRecCount,d_columns_float[type_index[colIndex]].begin(), long_to_float());
                }
                //else // uncompressed float
                //cudaMemcpy( d_columns[colIndex], (void *) ((float_type*)h_columns[colIndex] + offset), count*float_size, cudaMemcpyHostToDevice);
                // will have to fix it later so uncompressed data will be written by segments too
                break;
            default :
                CudaChar* c = h_columns_cuda_char[type_index[colIndex]];
                unsigned int data_len = ((unsigned int*)(c->compressed.data() + data_offset))[0];
                grp_count = ((unsigned int*)(c->compressed.data() + data_offset + data_len*8 + 12))[0];
                pfor_dict_decompress(c->compressed.data() + data_offset, c->h_columns , c->d_columns, &mRecCount, NULL,0, c->mColumnCount, 0, d_v, s_v);
                //std::cout<< "char decomp time " <<  ( ( std::clock() - start1 ) / (double)CLOCKS_PER_SEC ) <<'\n';
            };
            //cudaFree(d_v);
            //cudaFree(s_v);
        };
    }



    void CopyColumnToGpu(unsigned int colIndex) // copy all segments
    {
        if(fact_table) {
            switch(type[colIndex]) {
            case 0 :
                thrust::copy(h_columns_int[type_index[colIndex]].begin(), h_columns_int[type_index[colIndex]].begin() + mRecCount, d_columns_int[type_index[colIndex]].begin());
                break;
            case 1 :
                thrust::copy(h_columns_float[type_index[colIndex]].begin(), h_columns_float[type_index[colIndex]].begin() + mRecCount, d_columns_float[type_index[colIndex]].begin());
                break;
            default :
                (h_columns_cuda_char[type_index[colIndex]])->CopyToGpu(0, mRecCount);
            };
        }
        else {
            long long int data_offset;
            unsigned int totalRecs = 0;
            if(d_v == NULL)
                CUDA_SAFE_CALL(cudaMalloc((void **) &d_v, 12));
            if(s_v == NULL);
            CUDA_SAFE_CALL(cudaMalloc((void **) &s_v, 8));

            for(unsigned int i = 0; i < segCount; i++) {

                if (partial_load)
                    data_offset = readSegmentsFromFile(i,colIndex);
                else
                    data_offset = readSegments(i,colIndex);
                switch(type[colIndex]) {
                case 0 :
                    pfor_decompress(thrust::raw_pointer_cast(d_columns_int[type_index[colIndex]].data() + totalRecs), h_columns_int[type_index[colIndex]].data() + data_offset, &mRecCount, 0, NULL, d_v, s_v);
                    break;
                case 1 :
                    if(decimal[colIndex]) {
                        pfor_decompress( thrust::raw_pointer_cast(d_columns_float[type_index[colIndex]].data() + totalRecs) , h_columns_float[type_index[colIndex]].data() + data_offset, &mRecCount, 0, NULL, d_v, s_v);
                        thrust::device_ptr<long long int> d_col_int((long long int*)thrust::raw_pointer_cast(d_columns_float[type_index[colIndex]].data() + totalRecs));
                        thrust::transform(d_col_int,d_col_int+mRecCount,d_columns_float[type_index[colIndex]].begin() + totalRecs, long_to_float());
                    }
                    // else  uncompressed float
                    //cudaMemcpy( d_columns[colIndex], (void *) ((float_type*)h_columns[colIndex] + offset), count*float_size, cudaMemcpyHostToDevice);
                    // will have to fix it later so uncompressed data will be written by segments too
                    break;
                default :
                    CudaChar* c = h_columns_cuda_char[type_index[colIndex]];
                    pfor_dict_decompress(c->compressed.data() + data_offset, c->h_columns , c->d_columns, &mRecCount, NULL,0, c->mColumnCount, totalRecs, d_v, s_v);
                };
                totalRecs = totalRecs + mRecCount;
            };
//            cudaFree(d_v);
//            cudaFree(s_v);

            mRecCount = totalRecs;
        };
    }




    void CopyColumnToGpu(unsigned int colIndex,  unsigned int offset, unsigned int count)
    {
        if(fact_table) {
            switch(type[colIndex]) {
            case 0 :
                thrust::copy(h_columns_int[type_index[colIndex]].begin(), h_columns_int[type_index[colIndex]].begin() + offset + count, d_columns_int[type_index[colIndex]].begin());
                break;
            case 1 :
                thrust::copy(h_columns_float[type_index[colIndex]].begin(), h_columns_float[type_index[colIndex]].begin() + offset + count, d_columns_float[type_index[colIndex]].begin());
                break;
            default :
                (h_columns_cuda_char[type_index[colIndex]])->CopyToGpu(offset, count);
            };
        }
        else {
            unsigned int start_seg, seg_num, grp_count, data_len, mCount;
            start_seg = offset/segCount; // starting segment
            seg_num = count/segCount;    // number of segments that we need
            long long int data_offset;
            if(partial_load)
                data_offset = readSegmentsFromFile(start_seg,colIndex);
            else
                data_offset = readSegments(start_seg,colIndex);

            if(d_v == NULL)
                CUDA_SAFE_CALL(cudaMalloc((void **) &d_v, 12));
            if(s_v == NULL);
            CUDA_SAFE_CALL(cudaMalloc((void **) &s_v, 8));

            switch(type[colIndex]) {
            case 0 :
                for(unsigned int j = 0; j < seg_num; j++) {
                    data_len = ((unsigned int*)(h_columns_int[type_index[colIndex]].data()))[data_offset];
                    pfor_decompress(thrust::raw_pointer_cast(d_columns_int[type_index[colIndex]].data() + segCount*j), h_columns_int[type_index[colIndex]].data() + data_offset, &data_len, 0, NULL, d_v, s_v);
                    data_offset = data_offset + data_len + 8;
                };
                break;
            case 1 :
                if(decimal[colIndex]) {
                    for(unsigned int j = 0; j < seg_num; j++) {
                        data_len = (((unsigned int*)(h_columns_int[type_index[colIndex]]).data()))[data_offset];
                        thrust::device_ptr<long long int> d_col_int((long long int*)thrust::raw_pointer_cast(d_columns_float[type_index[colIndex]].data() + segCount*j));
                        pfor_decompress( thrust::raw_pointer_cast(d_columns_float[type_index[colIndex]].data() + segCount*j), h_columns_float[type_index[colIndex]].data() + data_offset, &data_len, 0, NULL, d_v, s_v);
                        thrust::transform(d_col_int,d_col_int+mRecCount,d_columns_float[type_index[colIndex]].begin() + segCount*j, long_to_float());
                        data_offset = data_offset + data_len + 8;
                    };
                }
                else // uncompressed float
                    thrust::copy(h_columns_float[type_index[colIndex]].begin() + offset, h_columns_float[type_index[colIndex]].begin() + offset + count, d_columns_float[type_index[colIndex]].begin());
                break;
            default :
                CudaChar* c = h_columns_cuda_char[type_index[colIndex]];
                for(unsigned int j = 0; j < seg_num; j++) {
                    data_len = ((unsigned int*)(c->compressed.data() + data_offset))[0];
                    grp_count = ((unsigned int*)(c->compressed.data() + data_offset + data_len*8 + 12))[0];
                    pfor_dict_decompress(c->compressed.data() + data_offset, c->h_columns , c->d_columns, &mCount, NULL,0, c->mColumnCount, segCount*j, d_v, s_v);
                    data_offset = data_offset + data_len*8 + 14*4 + grp_count*c->mColumnCount;
                };
            };
//            cudaFree(d_v);
//            cudaFree(s_v);
        };
    }



    void CopyColumnToHost(int colIndex, unsigned int offset, unsigned int RecCount)
    {
        if(fact_table) {
            switch(type[colIndex]) {
            case 0 :
                thrust::copy(d_columns_int[type_index[colIndex]].begin(), d_columns_int[type_index[colIndex]].begin() + RecCount, h_columns_int[type_index[colIndex]].begin() + offset);
                break;
            case 1 :
                thrust::copy(d_columns_float[type_index[colIndex]].begin(), d_columns_float[type_index[colIndex]].begin() + RecCount, h_columns_float[type_index[colIndex]].begin() + offset);
                break;
            default :
                (h_columns_cuda_char[type_index[colIndex]])->CopyToHost(offset,RecCount);
            }
        }
        else {
            unsigned long long int comp_offset = 0;
            switch(type[colIndex]) {
            case 0 :
                comp_offset = pfor_compress(thrust::raw_pointer_cast(d_columns_int[type_index[colIndex]].data()), RecCount*int_size, NULL, h_columns_int[type_index[colIndex]], 0, comp_offset);
                break;
            case 1 :
                if (decimal[colIndex]) {
                    thrust::device_ptr<long long int> d_col_dec((long long int*)thrust::raw_pointer_cast(d_columns_float[type_index[colIndex]].data() ));
                    thrust::transform(d_columns_float[type_index[colIndex]].begin(), d_columns_float[type_index[colIndex]].begin()+RecCount,
                                      d_col_dec, float_to_long());
                    comp_offset = pfor_compress(thrust::raw_pointer_cast(d_columns_float[type_index[colIndex]].data()), RecCount*float_size, NULL, h_columns_float[type_index[colIndex]], 0, comp_offset);
                }
                else { // add code for float
                } ;
                break;
            default :
                CudaChar *s = (h_columns_cuda_char)[type_index[colIndex]];
                comp_offset = pfor_dict_compress(s->d_columns, s->mColumnCount, NULL, RecCount, s->compressed, comp_offset);
            };
        };
    }


    void CopyColumnToHost(int colIndex)
    {
        CopyColumnToHost(colIndex, 0, mRecCount);
    }

    void CopyToHost(unsigned int offset, unsigned int count)
    {
        for(unsigned int i = 0; i < mColumnCount; i++)
            CopyColumnToHost(i, offset, count);
    }

    float_type* get_float_type_by_name(string name)
    {
        unsigned int colIndex = columnNames.find(name)->second;
        return thrust::raw_pointer_cast(d_columns_float[type_index[colIndex]].data());
    }

    int_type* get_int_by_name(string name)
    {
        unsigned int colIndex = columnNames.find(name)->second;
        return thrust::raw_pointer_cast(d_columns_int[type_index[colIndex]].data());
    }

    float_type* get_host_float_by_name(string name)
    {
        unsigned int colIndex = columnNames.find(name)->second;
        return thrust::raw_pointer_cast(h_columns_float[type_index[colIndex]].data());
    }

    int_type* get_host_int_by_name(string name)
    {
        unsigned int colIndex = columnNames.find(name)->second;
        return thrust::raw_pointer_cast(h_columns_int[type_index[colIndex]].data());
    }



    void GroupBy(queue<string> columnRef)
    {
        int grpInd, colIndex;

        if(!columnGroups.empty())
            cudaFree(grp);

        CUDA_SAFE_CALL(cudaMalloc((void **) &grp, mRecCount * sizeof(bool))); // d_di is the vector for segmented scans
        thrust::device_ptr<bool> d_grp(grp);

        thrust::sequence(d_grp, d_grp+mRecCount, 0, 0);

        thrust::device_ptr<bool> d_group = thrust::device_malloc<bool>(mRecCount);
        d_group[mRecCount-1] = 1;

        for(int i = 0; i < columnRef.size(); columnRef.pop()) {
            columnGroups.push(columnRef.front()); // save for future references
            colIndex = columnNames[columnRef.front()];

            if(!onDevice(colIndex)) {
                allocColumnOnDevice(colIndex,mRecCount);
                CopyColumnToGpu(colIndex,  0, mRecCount);
                grpInd = 1;
            }
            else
                grpInd = 0;

            if (type[colIndex] == 0) {  // int_type
                thrust::transform(d_columns_int[type_index[colIndex]].begin(), d_columns_int[type_index[colIndex]].begin() + mRecCount - 1,
                                  d_columns_int[type_index[colIndex]].begin()+1, d_group, thrust::not_equal_to<int_type>());
                thrust::transform(d_group, d_group+mRecCount, d_grp, d_grp, thrust::logical_or<bool>());
            }
            else if (type[colIndex] == 1) {  // float_type
                thrust::transform(d_columns_float[type_index[colIndex]].begin(), d_columns_float[type_index[colIndex]].begin() + mRecCount - 1,
                                  d_columns_float[type_index[colIndex]].begin()+1, d_group, f_not_equal_to());
                thrust::transform(d_group, d_group+mRecCount, d_grp, d_grp, thrust::logical_or<bool>());
            }
            else  {  // CudaChar
                CudaChar* c = h_columns_cuda_char[type_index[colIndex]];
                for(unsigned int j=0; j < c->mColumnCount; j++) {
                    thrust::transform(c->d_columns[j].begin(), c->d_columns[j].begin() + mRecCount - 1, c->d_columns[j].begin()+1, d_group, thrust::not_equal_to<char>());
                    thrust::transform(d_group, d_group+mRecCount, d_grp, d_grp, thrust::logical_or<int>());
                }
            };
            if (grpInd == 1)
                deAllocColumnOnDevice(colIndex);
        };

        thrust::device_free(d_group);
        grp_count = thrust::count(d_grp, d_grp+mRecCount,1);
    }


    void addDeviceColumn(int_type* col, int colIndex, string colName, int_type recCount)
    {
        if (columnNames.find(colName) == columnNames.end()) {
            columnNames[colName] = colIndex;
            type[colIndex] = 0;
            d_columns_int.push_back(thrust::device_vector<int_type>(recCount));
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
        mRecCount = recCount;
    };

    void addDeviceColumn(float_type* col, int colIndex, string colName, int_type recCount)
    {
        if (columnNames.find(colName) == columnNames.end()) {
            columnNames[colName] = colIndex;
            type[colIndex] = 1;
            d_columns_float.push_back(thrust::device_vector<float_type>(recCount));
            type_index[colIndex] = d_columns_float.size()-1;
        }
        else {  // already exists, my need to resize it
            if(d_columns_float[type_index[colIndex]].size() < recCount)
                d_columns_float[type_index[colIndex]].resize(recCount);
        };

        thrust::device_ptr<float_type> d_col((float_type*)col);
        thrust::copy(d_col, d_col+recCount, d_columns_float[type_index[colIndex]].begin());
        mRecCount = recCount;
    };



    void addHostColumn(int_type* col, int colIndex, string colName, int_type recCount, int_type old_reccount, bool one_line)
    {
        if (columnNames.find(colName) == columnNames.end()) {
            columnNames[colName] = colIndex;
            type[colIndex] = 0;
            if (!one_line) {
                h_columns_int.push_back(thrust::host_vector<int_type>(old_reccount));
                type_index[colIndex] = h_columns_int.size()-1;
            }
            else {
                h_columns_int.push_back(thrust::host_vector<int_type>(1));
                type_index[colIndex] = h_columns_int.size()-1;
            };
        };

        if (!one_line) {
            thrust::device_ptr<int_type> d_col((int_type*)col);
            thrust::copy(d_col, d_col+recCount, h_columns_int[type_index[colIndex]].begin() + mRecCount);
        }
        else {
            thrust::device_ptr<int_type> src(col);
            (h_columns_int[type_index[colIndex]])[0] = (h_columns_int[type_index[colIndex]])[0] + src[0];
        };
    };

    void addHostColumn(float_type* col, int colIndex, string colName, int_type recCount, int_type old_reccount, bool one_line)
    {
        if (columnNames.find(colName) == columnNames.end()) {
            columnNames[colName] = colIndex;
            type[colIndex] = 1;
            if (!one_line) {
                h_columns_float.push_back(thrust::host_vector<float_type>(old_reccount));
                type_index[colIndex] = h_columns_float.size()-1;
            }
            else {
                h_columns_float.push_back(thrust::host_vector<float_type>(1));
                type_index[colIndex] = h_columns_float.size()-1;
            };
        };

        if (!one_line) {
            thrust::device_ptr<float_type> d_col((float_type*)col);
            thrust::copy(d_col, d_col+recCount, h_columns_float[type_index[colIndex]].begin() + mRecCount);
        }
        else {
            thrust::device_ptr<float_type> src(col);
            (h_columns_float[type_index[colIndex]])[0] = (h_columns_float[type_index[colIndex]])[0] + src[0];
        };
    };



    void Store(char* file_name, char* sep, unsigned int limit, bool binary )
    {
        if (mRecCount == 0 && binary == 1) { // write tails

            char str[100];
            char col_pos[3];

            for(unsigned int i = 0; i< mColumnCount; i++) {
                strcpy(str, file_name);
                strcat(str,".");
                itoaa(cols[i],col_pos);
                strcat(str,col_pos);

                fstream binary_file(str,ios::out|ios::binary|ios::app);
                binary_file.write((char *)&total_count, 8);
                binary_file.write((char *)&total_segments, 4);
                binary_file.write((char *)&total_max, 4);
                binary_file.close();
            };
            return;
        };



        unsigned int mCount, cnt = 0;

        if(limit != 0 && limit < mRecCount)
            mCount = limit;
        else
            mCount = mRecCount;

        if(binary == 0) {

            if(prm.size() > 0) { // data permuted
                // allocate on device and gather
                queue<string> op_vx;
                for ( map<string,int>::iterator it=columnNames.begin() ; it != columnNames.end(); ++it )
                    op_vx.push((*it).first);
                curr_segment = 1000000;
                allocColumns(this, op_vx);
                copyColumns(this, op_vx, 0, cnt);
            };

            FILE *file_pr = fopen(file_name, "w");
            if (file_pr  == NULL)
                cout << "Could not open file " << file_name << endl;

            char buffer [33];
            if(onDevice(0)) {

                if(h_columns_int.size() == 0 && h_columns_float.size() == 0) {
                    for(unsigned int i = 0; i< mColumnCount; i++)
                        if(type[i] == 0)
                            h_columns_int.push_back(thrust::host_vector<int_type>(mCount));
                        else if(type[i] == 1)
                            h_columns_float.push_back(thrust::host_vector<float_type>(mCount));
                };

                resize(mCount+1);
                bool ch = 0;
                if(!fact_table) {
                    fact_table = 1;
                    ch = 1;
                };
                CopyToHost(0,mCount);
                if(ch)
                    fact_table = 0;
            }
            else {
                if(!fact_table) { // compressed on the host
                    allocOnDevice(mCount);
                    for(unsigned int i=0; i < mColumnCount; i++) {
                        CopyColumnToGpu(i);
                        resize(mCount+1);
                    };
                    fact_table = 1;
                    CopyToHost(0,mCount);
                    fact_table = 0;
                };
            };

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
                        CudaChar* cc = h_columns_cuda_char[type_index[j]];
                        char *buf = new char[(cc->mColumnCount)+1];
                        for(unsigned int z=0; z<(cc->mColumnCount); z++)
                            buf[z] = (cc->h_columns[z])[i];
                        buf[cc->mColumnCount] = 0;
                        fputs(buf, file_pr);
                        fputs(sep, file_pr);
                        delete [] buf;
                    };
                };
                if (i != mCount -1)
                    fputs("\n",file_pr);
            };
            fclose(file_pr);
        }
        else {  //writing a binary file

            char str[100];
            char col_pos[3];
            total_count = total_count + mCount;
            total_segments = total_segments + 1;
            if (mCount > total_max)
                total_max = mCount;

            bool in_gpu = false;
            if(onDevice(0))
                in_gpu = true;

            void* d;
            if(!in_gpu)
                CUDA_SAFE_CALL(cudaMalloc((void **) &d, mCount*float_size));

            void* host;
            cudaMallocHost(&host, float_size*mCount);

            for(unsigned int i = 0; i< mColumnCount; i++)
                if(type[i] == 2 && !in_gpu ) {
                    allocColumnOnDevice(i, mCount);
                    CopyColumnToGpu(i,  0, mCount);
                };

            for(unsigned int i = 0; i< mColumnCount; i++) {
                strcpy(str, file_name);
                strcat(str,".");
                itoaa(cols[i],col_pos);
                strcat(str,col_pos);

                if(type[i] == 0) {
                    if(!in_gpu) {
                        thrust::device_ptr<int_type> d_col((int_type*)d);
                        thrust::copy(h_columns_int[type_index[i]].begin(), h_columns_int[type_index[i]].begin() + mCount, d_col);
                        pfor_compress( d, mCount*int_size, str, h_columns_int[type_index[i]], 0, 0);
                    }
                    else
                        pfor_compress( thrust::raw_pointer_cast(d_columns_int[type_index[i]].data()), mCount*int_size, str, h_columns_int[type_index[i]], 0, 0);
                }
                else if(type[i] == 1) {
                    if(decimal[i]) {
                        if(!in_gpu) {
                            thrust::device_ptr<float_type> d_col((float_type*)d);
                            thrust::copy(h_columns_float[type_index[i]].begin(), h_columns_float[type_index[i]].begin() + mCount, d_col);
                            thrust::device_ptr<long long int> d_col_dec((long long int*)d);
                            thrust::transform(d_col,d_col+mCount,d_col_dec, float_to_long());
                            pfor_compress( d, mCount*float_size, str, h_columns_float[type_index[i]], 1, 0);
                        }
                        else {
                            thrust::device_ptr<long long int> d_col_dec((long long int*)(thrust::raw_pointer_cast(d_columns_float[type_index[i]].data()) ));
                            thrust::transform(d_columns_float[type_index[i]].begin(),d_columns_float[type_index[i]].begin()+mCount, d_col_dec, float_to_long());
                            pfor_compress( thrust::raw_pointer_cast(d_columns_float[type_index[i]].data()), mCount*float_size, str, h_columns_float[type_index[i]], 1, 0);
                        };
                    }
                    else { // do not compress
                        fstream binary_file(str,ios::out|ios::binary|fstream::app);
                        binary_file.write((char *)&mCount, 4);
                        if(in_gpu) {
                            cudaMemcpy(host, thrust::raw_pointer_cast(d_columns_float[type_index[i]].data()), mCount*float_size, cudaMemcpyDeviceToHost);
                            binary_file.write((char *)host,mCount*float_size);
                        }
                        else
                            binary_file.write((char *)(h_columns_float[type_index[i]].data()),mCount*float_size);
                        unsigned int comp_type = 3;
                        binary_file.write((char *)&comp_type, 4);
                        binary_file.close();
                    };
                }
                else {
                    CudaChar *a = h_columns_cuda_char[type_index[i]];
                    thrust::host_vector<char> hh(mCount*8);
                    pfor_dict_compress(a->d_columns, a->mColumnCount, str, mCount, hh, 0);
                };

                if(fact_file_loaded) {
                    fstream binary_file(str,ios::out|ios::binary|ios::app);
                    binary_file.write((char *)&total_count, 8);
                    binary_file.write((char *)&total_segments, 4);
                    binary_file.write((char *)&total_max, 4);
                    binary_file.close();
                };

            };


            for(unsigned int i = 0; i< mColumnCount; i++)
                if(type[i] == 2 && !in_gpu)
                    deAllocColumnOnDevice(i);

            if(!in_gpu)
                cudaFree(d);
            cudaFreeHost(host);

        }
    }




    void LoadFile(char* file_name, char* sep )
    {
        unsigned int count = 0;
        char line[500];
        int l;
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
                        (h_columns_int[type_index[seq[i]]])[count] = atoi(field);
                    }
                    else {   // handling possible dates
                        strncpy(field+4,field+5,2);
                        strncpy(field+6,field+8,2);
                        field[8] = '\0';
                        (h_columns_int[type_index[seq[i]]])[count] = atoi(field);
                    };
                }
                else if (type[seq[i]] == 1)
                    (h_columns_float[type_index[seq[i]]])[count] = atoff(field);
                else {
                    l = strlen(field);
                    for(int j =0; j< l; j++)
                        ((h_columns_cuda_char[type_index[seq[i]]])->h_columns[j])[count] = field[j];
                    for(unsigned int j =l; j< (h_columns_cuda_char[type_index[i]])->mColumnCount; j++)
                        ((h_columns_cuda_char[type_index[seq[i]]])->h_columns[j])[count] = 0;
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
    }


    int LoadBigFile(const char* file_name, const char* sep )
    {
        unsigned int count = 0;
        char line[500];
        char* field;
        unsigned int current_column = 1;
        unsigned int l;

        if (file_p == NULL)
            file_p = fopen(file_name, "r");
        if (file_p  == NULL)
            cout << "Could not open file " << file_name << endl;

        if (seq == 0) {
            seq = new unsigned int[mColumnCount];
            thrust::sequence(seq, seq+mColumnCount,0,1);
            thrust::stable_sort_by_key(cols, cols+mColumnCount, seq);
        };

        while (count < process_count && fgets(line, 500, file_p) != NULL) {

            current_column = 1;
            field = strtok(line,sep);

            for(unsigned int i = 0; i< mColumnCount; i++) {

                while(cols[i] > current_column) {
                    field = strtok(NULL,sep);
                    current_column++;
                };
                if (type[seq[i]] == 0) {
                    if (strchr(field,'-') == NULL) {
                        (h_columns_int[type_index[seq[i]]])[count] = atoi(field);
                    }
                    else {   // handling possible dates
                        strncpy(field+4,field+5,2);
                        strncpy(field+6,field+8,2);
                        field[8] = '\0';
                        (h_columns_int[type_index[seq[i]]])[count] = atoi(field);
                    };
                }
                else if (type[seq[i]] == 1)
                    (h_columns_float[type_index[seq[i]]])[count] = atoff(field);
                else {
                    l = strlen(field);
                    for(unsigned int j =0; j< l; j++)
                        ((h_columns_cuda_char[type_index[seq[i]]])->h_columns[j])[count] = field[j];
                    for(unsigned int j =l; j< (h_columns_cuda_char[type_index[seq[i]]])->mColumnCount; j++)
                        ((h_columns_cuda_char[type_index[seq[i]]])->h_columns[j])[count] = 0;
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
    }


    void free()  {

        if (!seq)
            delete seq;

        for(unsigned int i = 0; i < mColumnCount; i++ ) {
            if(type[i] == 2 && h_columns_cuda_char.size() > 0 && prm.size() == 0)
                delete h_columns_cuda_char[type_index[i]];
        };

        if(prm.size()) { // free the sources
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


    bool* logical_and(bool* column1, bool* column2)
    {
        thrust::device_ptr<bool> dev_ptr1(column1);
        thrust::device_ptr<bool> dev_ptr2(column2);

        thrust::transform(dev_ptr1, dev_ptr1+mRecCount, dev_ptr2, dev_ptr1, thrust::logical_and<bool>());

        thrust::device_free(dev_ptr2);
        return column1;
    }


    bool* logical_or(bool* column1, bool* column2)
    {

        thrust::device_ptr<bool> dev_ptr1(column1);
        thrust::device_ptr<bool> dev_ptr2(column2);

        thrust::transform(dev_ptr1, dev_ptr1+mRecCount, dev_ptr2, dev_ptr1, thrust::logical_or<bool>());
        thrust::device_free(dev_ptr2);
        return column1;
    }



    bool* compare(int_type s, int_type d, int_type op_type)
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
    }


    bool* compare(float_type s, float_type d, int_type op_type)
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


    bool* compare(int_type* column1, int_type d, int_type op_type)
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

    bool* compare(float_type* column1, float_type d, int_type op_type)
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


    bool* compare(int_type* column1, int_type* column2, int_type op_type)
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

    bool* compare(float_type* column1, float_type* column2, int_type op_type)
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


    bool* compare(float_type* column1, int_type* column2, int_type op_type)
    {
        thrust::device_ptr<float_type> dev_ptr1(column1);
        thrust::device_ptr<int_type> dev_ptr(column2);
        thrust::device_ptr<float_type> dev_ptr2 = thrust::device_malloc<float_type>(mRecCount);;
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


    float_type* op(int_type* column1, float_type* column2, string op_type, int reverse)
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




    int_type* op(int_type* column1, int_type* column2, string op_type, int reverse)
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

    float_type* op(float_type* column1, float_type* column2, string op_type, int reverse)
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

    int_type* op(int_type* column1, int_type d, string op_type, int reverse)
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

    float_type* op(int_type* column1, float_type d, string op_type, int reverse)
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


    float_type* op(float_type* column1, float_type d, string op_type,int reverse)
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


protected: // methods


    void initialize(queue<string> &nameRef, queue<string> &typeRef, queue<int> &sizeRef, queue<int> &colsRef, int_type Recs, char* file_name) // compressed data for DIM tables
    {
        std::clock_t start1 = std::clock();
        mColumnCount = nameRef.size();
        type = new unsigned int[mColumnCount];
        cols = new unsigned int[mColumnCount];
        decimal = new bool[mColumnCount];
        unsigned int cnt, grp_count;
        file_p = NULL;
        FILE* f;
        char f1[100];

        fact_table = 0;
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


            f = fopen (f1 , "rb" );
            fread((char *)&cnt, 4, 1, f);
            //          cout << "creating host " << cnt << endl;

            if ((typeRef.front()).compare("int") == 0) {
                type[i] = 0;
                decimal[i] = 0;
                h_columns_int.push_back(thrust::host_vector<int_type>(cnt + 9));
                d_columns_int.push_back(thrust::device_vector<int_type>());
                type_index[i] = h_columns_int.size()-1;
            }
            else if ((typeRef.front()).compare("float") == 0) {
                type[i] = 1;
                decimal[i] = 0;
                h_columns_float.push_back(thrust::host_vector<float_type>(cnt + 9));
                d_columns_float.push_back(thrust::device_vector<float_type>());
                type_index[i] = h_columns_float.size()-1;
            }
            else if ((typeRef.front()).compare("decimal") == 0) {
                type[i] = 1;
                decimal[i] = 1;
                h_columns_float.push_back(thrust::host_vector<float_type>(cnt + 9));
                d_columns_float.push_back(thrust::device_vector<float_type>());
                type_index[i] = h_columns_float.size()-1;
            }
            else {
                type[i] = 2;
                decimal[i] = 0;
                fseeko(f, cnt*8 + 12, SEEK_SET);
                fread((char *)&grp_count, 4, 1, f);
                h_columns_cuda_char.push_back(new CudaChar(sizeRef.front(), Recs, 0, cnt*8 + 14*4 + grp_count*sizeRef.front()));
                type_index[i] = h_columns_cuda_char.size()-1;
            };

            fclose(f);
            nameRef.pop();
            typeRef.pop();
            sizeRef.pop();
            colsRef.pop();
        };
        std::cout<< "create time " <<  ( ( std::clock() - start1 ) / (double)CLOCKS_PER_SEC ) <<'\n';
    };



    void initialize(queue<string> &nameRef, queue<string> &typeRef, queue<int> &sizeRef, queue<int> &colsRef, int_type Recs)
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
                h_columns_int.push_back(thrust::host_vector<int_type>());
                d_columns_int.push_back(thrust::device_vector<int_type>());
                type_index[i] = h_columns_int.size()-1;
            }
            else if ((typeRef.front()).compare("float") == 0) {
                type[i] = 1;
                decimal[i] = 0;
                h_columns_float.push_back(thrust::host_vector<float_type>());
                d_columns_float.push_back(thrust::device_vector<float_type>());
                type_index[i] = h_columns_float.size()-1;
            }
            else if ((typeRef.front()).compare("decimal") == 0) {
                type[i] = 1;
                decimal[i] = 1;
                h_columns_float.push_back(thrust::host_vector<float_type>());
                d_columns_float.push_back(thrust::device_vector<float_type>());
                type_index[i] = h_columns_float.size()-1;
            }

            else {
                type[i] = 2;
                decimal[i] = 0;
                h_columns_cuda_char.push_back(new CudaChar(sizeRef.front(), Recs, 1));
                type_index[i] = h_columns_cuda_char.size()-1;
            };
            nameRef.pop();
            typeRef.pop();
            sizeRef.pop();
            colsRef.pop();
        };
    };

    void initialize(unsigned int RecordCount, unsigned int ColumnCount)
    {
        mRecCount = RecordCount;
        mColumnCount = ColumnCount;

        type = new unsigned int[mColumnCount];
        cols = new unsigned int[mColumnCount];
        decimal = new bool[mColumnCount];
        seq = 0;

        for(unsigned int i =0; i < mColumnCount; i++)
            cols[i] = i;

    };


    void initialize(CudaSet* a, CudaSet* b, int_type Recs, queue<string> op_sel, queue<string> op_sel_as)
    {
        mRecCount = Recs;
        mColumnCount = op_sel.size();

        type = new unsigned int[mColumnCount];
        cols = new unsigned int[mColumnCount];
        decimal = new bool[mColumnCount];
        maxRecs = b->maxRecs;

        map<string,int>::iterator it;
        map<int,string> columnNames1;
        seq = 0;
        unsigned int i = 0;
        segCount = 1;
        fact_table = 1;

        while(!op_sel_as.empty()) {
            columnNames[op_sel_as.front()] = i;
            op_sel_as.pop();
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
                    h_columns_cuda_char.push_back(new CudaChar((a->h_columns_cuda_char[a->type_index[index]])->mColumnCount, Recs, 1));
                    type[i] = 2;
                    type_index[i] = h_columns_cuda_char.size()-1;
                };
            }
            else {
                it = b->columnNames.find(op_sel.front());
                index = it->second;

                cols[i] = i;
                decimal[i] = b->decimal[index];

                if ((b->type)[index] == 0) {
                    d_columns_int.push_back(thrust::device_vector<int_type>());
                    h_columns_int.push_back(thrust::host_vector<int_type>());
                    type[i] = 0;
                    type_index[i] = h_columns_int.size()-1;
                }
                else if ((b->type)[index] == 1) {
                    d_columns_float.push_back(thrust::device_vector<float_type>());
                    h_columns_float.push_back(thrust::host_vector<float_type>());
                    type[i] = 1;
                    type_index[i] = h_columns_float.size()-1;
                }
                else {
                    h_columns_cuda_char.push_back(new CudaChar((b->h_columns_cuda_char[a->type_index[index]])->mColumnCount, Recs, 1));
                    type[i] = 2;
                    type_index[i] = h_columns_cuda_char.size()-1;
                };
            }
            op_sel.pop();
        };
    }
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



unsigned int findSegmentCount(char* file_name)
{
    unsigned int orig_recCount;
    unsigned int comp_type, cnt;

    FILE* f = fopen ( file_name , "rb" );
    if (f==NULL) {
        cout << "Cannot open file " << file_name << endl;
        exit (1);
    }
    fread(&cnt, 4, 1, f);
    fseeko(f, cnt*8 + 16, SEEK_CUR);
    fread(&comp_type, 4, 1, f);
    if(comp_type == 2)
        fread(&orig_recCount, 4, 1, f);
    else if(comp_type == 3)
        orig_recCount = cnt;
    else {
        fread(&orig_recCount, 4, 1, f);
        fread(&orig_recCount, 4, 1, f);
    };

    fclose(f);

    return orig_recCount;
};




void allocColumns(CudaSet* a, queue<string> fields)
{
    while(!fields.empty()) {
        if(setMap.count(fields.front()) > 0) {

            CudaSet *t;
            if(a->prm.size())
                t = varNames[setMap[fields.front()]];
            else
                t = a;

            unsigned int idx = t->columnNames[fields.front()];
            bool onDevice = 0;

            if(t->type[idx] == 0) {
                if(t->d_columns_int[t->type_index[idx]].size() > 0)
                    onDevice = 1;
            }
            else if(t->type[idx] == 1) {
                if(t->d_columns_float[t->type_index[idx]].size() > 0)
                    onDevice = 1;
            }
            else {
                if((t->h_columns_cuda_char[t->type_index[idx]])->d_columns[0].size() > 0)
                    onDevice = 1;
            };

            if (!onDevice) {
                t->allocColumnOnDevice(idx, t->maxRecs);
            };

        };
        fields.pop();
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


void copyColumns(CudaSet* a, queue<string> fields, unsigned int segment, unsigned int& count)
{
    set<string> uniques;
    CudaSet *t;

    while(!fields.empty()) {
        if (uniques.count(fields.front()) == 0 && setMap.count(fields.front()) > 0)	{
            if(a->prm.size()) {
                t = varNames[setMap[fields.front()]];
                if(a->prm_count[segment]) {
                    std::clock_t start2 = std::clock();
                    t->CopyColumnToGpu(t->columnNames[fields.front()], segment); // segment i
//					std::cout<< "t time " <<  ( ( std::clock() - start2 ) / (double)CLOCKS_PER_SEC ) << " " << getFreeMem() << '\n';
                    gatherColumns(a, t, fields.front(), segment, count);
//					std::cout<< "g time " <<  ( ( std::clock() - start2 ) / (double)CLOCKS_PER_SEC ) <<  " " << getFreeMem() << '\n';
                };
            }
            else
                a->CopyColumnToGpu(a->columnNames[fields.front()], segment); // segment i
            uniques.insert(fields.front());
        };
        fields.pop();
    };
}



unsigned int getSegmentRecCount(CudaSet* a, unsigned int segment) {
    if (segment == a->segCount-1) {
        return oldCount - a->maxRecs*segment;
    }
    else
        return 	a->maxRecs;
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

        thrust::gather(a->prm_d.begin(), a->prm_d.begin() + g_size,
                       t->d_columns_int[t->type_index[tindex]].begin(), a->d_columns_int[a->type_index[idx]].begin() + offset);

    }
    else if(t->type[tindex] == 1) {
        thrust::gather(a->prm_d.begin(), a->prm_d.begin() + g_size,
                       t->d_columns_float[t->type_index[tindex]].begin(), a->d_columns_float[a->type_index[idx]].begin() + offset);
    }
    else
        for(unsigned int j=0; j < (t->h_columns_cuda_char[t->type_index[tindex]])->mColumnCount; j++)
            thrust::gather(a->prm_d.begin(), a->prm_d.begin() + g_size,
                           (t->h_columns_cuda_char[t->type_index[tindex]])->d_columns[j].begin(),
                           (a->h_columns_cuda_char[a->type_index[idx]])->d_columns[j].begin() + offset);



};

void mycopy(unsigned int tindex, unsigned int idx, CudaSet* a, CudaSet* t, unsigned int offset, unsigned int g_size)
{
    if(t->type[tindex] == 0) {
        thrust::copy(t->d_columns_int[t->type_index[tindex]].begin(), t->d_columns_int[t->type_index[tindex]].begin() + g_size,
                     a->d_columns_int[a->type_index[idx]].begin() + offset);
    }
    else if(t->type[tindex] == 1) {
        thrust::copy(t->d_columns_float[t->type_index[tindex]].begin(), t->d_columns_float[t->type_index[tindex]].begin() + g_size,
                     a->d_columns_float[a->type_index[idx]].begin() + offset);
    }
    else {
        for(unsigned int j=0; j < (t->h_columns_cuda_char[t->type_index[tindex]])->mColumnCount; j++) {
            thrust::copy((t->h_columns_cuda_char[t->type_index[tindex]])->d_columns[j].begin(),(t->h_columns_cuda_char[t->type_index[tindex]])->d_columns[j].begin() + g_size,
                         (a->h_columns_cuda_char[a->type_index[idx]])->d_columns[j].begin() + offset);
        }
    };
};

