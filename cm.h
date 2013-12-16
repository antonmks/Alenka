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

#define EPSILON    (1.0E-8)

using namespace std;

#ifndef ADD_H_GUARD
#define ADD_H_GUARD


#include <thrust/device_vector.h>
#include <thrust/sequence.h>
#include <thrust/count.h>
#include <thrust/copy.h>
#include <thrust/iterator/counting_iterator.h>
#include <thrust/iterator/constant_iterator.h>
#include <thrust/iterator/discard_iterator.h>
#include <thrust/adjacent_difference.h>
#include <thrust/transform.h>
#include <thrust/partition.h>
#include <thrust/fill.h>
#include <thrust/scan.h>
#include <thrust/device_ptr.h>
#include <thrust/unique.h>
#include <thrust/gather.h>
#include <thrust/sort.h>
#include <thrust/merge.h>
#include <thrust/reduce.h>
#include <thrust/functional.h>
#include <thrust/system/cuda/experimental/pinned_allocator.h>
#include <queue>
#include <string>
#include <map>
#include <set>
#include <vector>
#include <stack>
#include "strings.h"
#include <ctime>
#include <limits>
#include <fstream>

typedef double float_type;
typedef long long int int_type;
typedef thrust::device_vector<int_type>::iterator ElementIterator_int;
typedef thrust::device_vector<float_type>::iterator ElementIterator_float;
typedef thrust::device_vector<unsigned int>::iterator   IndexIterator;
typedef thrust::device_vector<int>::iterator   IndexIterator2;
typedef thrust::device_ptr<int> IndexIterator1;


extern size_t int_size;
extern size_t float_size;
extern unsigned int hash_seed;
extern queue<string> op_type;
extern queue<string> op_sort;
extern queue<string> op_presort;
extern queue<string> op_value;
extern queue<int_type> op_nums;
extern queue<float_type> op_nums_f;
extern queue<string> col_aliases;
extern unsigned int curr_segment;
extern size_t total_count, oldCount, total_max, totalRecs, alloced_sz;
extern unsigned int total_segments;
extern unsigned int process_count;
extern bool fact_file_loaded;
extern char map_check;
extern void* alloced_tmp;
extern unsigned int partition_count;
extern map<string,string> setMap; //map to keep track of column names and set names
extern std::clock_t tot;
extern std::clock_t tot_fil;


template<typename T>
struct uninitialized_host_allocator
        : std::allocator<T>
{
    // note that construct is annotated as
    __host__ __device__
    void construct(T *p)
    {
        // no-op
    }
};


template<typename T>
struct uninitialized_allocator
        : thrust::device_malloc_allocator<T>
{
    // note that construct is annotated as
    // a __host__ __device__ function
    __host__ __device__
    void construct(T *p)
    {
        // no-op
    }
};

struct is_positive
{
    __host__ __device__
    bool operator()(const int x)
    {
        return (x >= 0);
    }
};

struct set_minus : public binary_function<int,bool,int>
{
    /*! Function call operator. The return value is <tt>lhs + rhs</tt>.
     */
    __host__ __device__ int operator()(const int &lhs, const bool &rhs) const {
        if (rhs) return lhs;
        else return -1;
    }
};



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

struct float_equal_to
{
    /*! Function call operator. The return value is <tt>lhs == rhs</tt>.
     */
    __host__ __device__ bool operator()(const float_type &lhs, const float_type &rhs) const {
        int_type l,r;
        if ((long long int)((lhs+EPSILON)*100.0) > (long long int)(lhs*100.0))
            l = (long long int)((lhs+EPSILON)*100.0);
        else l = (long long int)(lhs*100.0);
        if ((long long int)((rhs+EPSILON)*100.0) > (long long int)(rhs*100.0))
            r = (long long int)((rhs+EPSILON)*100.0);
        else r = (long long int)(rhs*100.0);


        return (l == r);
    }
};


struct int_upper_equal_to
{
    /*! Function call operator. The return value is <tt>lhs == rhs</tt>.
     */
    __host__ __device__ bool operator()(const int_type &lhs, const int_type &rhs) const {
        return (lhs >> 32)  == (rhs >> 32);
    }
};

struct float_upper_equal_to
{
    /*! Function call operator. The return value is <tt>lhs == rhs</tt>.
     */
    __host__ __device__ bool operator()(const float_type &lhs, const float_type &rhs) const {
        return ((int_type)lhs >> 32)  == ((int_type)rhs >> 32);
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

struct uint2_split_left
{

    const uint2* d_res;
    unsigned int * output;

    uint2_split_left(const uint2* _d_res, unsigned int * _output):
        d_res(_d_res), output(_output) {}

    template <typename IndexType>
    __host__ __device__
    void operator()(const IndexType & i) {

        output[i] = d_res[i].x;

    }
};


struct join_functor1
{

    const uint2* d_res;
    const unsigned int* d_addr;
    unsigned int * output;
    unsigned int * output1;

    join_functor1(const uint2* _d_res, const unsigned int * _d_addr, unsigned int * _output, unsigned int * _output1):
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

template<typename T>
  struct not_identity : public unary_function<T,T>
{
  /*! Function call operator. The return value is <tt>x</tt>.
   */
  __host__ __device__ const T &operator()(const T &x) const {return !x;}
}; 




#ifdef _WIN64
typedef unsigned __int64 uint64_t;
#endif

using namespace thrust::system::cuda::experimental;

class CudaSet
{
public:
    std::vector<thrust::host_vector<int_type, pinned_allocator<int_type> > > h_columns_int;
    std::vector<thrust::host_vector<float_type, pinned_allocator<float_type> > > h_columns_float;
    std::vector<char*> h_columns_char;

    std::vector<thrust::device_vector<int_type > > d_columns_int;
    std::vector<thrust::device_vector<float_type > > d_columns_float;
    std::vector<char*> d_columns_char;
    std::vector<size_t> char_size;

    thrust::device_vector<unsigned int> prm_d;
    char prm_index; // A - all segments values match, N - none match, R - some may match

    // to do filters in-place (during joins, groupby etc ops) we need to save a state of several queues's and a few misc. variables:
    char* fil_s;
    char* fil_f;
    queue<string> fil_type,fil_value;
    queue<int_type> fil_nums;
    queue<float_type> fil_nums_f;

    std::map<unsigned int, size_t> type_index;
    size_t mRecCount, maxRecs, hostRecCount, devRecCount, grp_count, segCount, prealloc_char_size;
    std::map<string,unsigned int> columnNames;
    std::map<string, FILE*> filePointers;
    bool *grp;
    queue<string> columnGroups;
    bool not_compressed; // 1 = host recs are not compressed, 0 = compressed
    FILE *file_p;
    unsigned int *seq;
    unsigned int mColumnCount;
    string name, load_file_name;
    bool source, text_source, tmp_table, keep, filtered;
    queue<unsigned int> sorted_fields; //segment is sorted by fields
    queue<unsigned int> presorted_fields; //globally sorted by fields
    unsigned int* type; // 0 - integer, 1-float_type, 2-char
    bool* decimal; // column is decimal - affects only compression
    unsigned int* grp_type; // type of group : SUM, AVG, COUNT etc
    unsigned int* cols; // column positions in a file


    CudaSet(queue<string> &nameRef, queue<string> &typeRef, queue<int> &sizeRef, queue<int> &colsRef, size_t Recs);
    CudaSet(queue<string> &nameRef, queue<string> &typeRef, queue<int> &sizeRef, queue<int> &colsRef, size_t Recs, string file_name);
    CudaSet(size_t RecordCount, unsigned int ColumnCount);
    CudaSet(CudaSet* a, CudaSet* b, queue<string> op_sel, queue<string> op_sel_as);
    CudaSet(queue<string> op_sel, queue<string> op_sel_as);
    ~CudaSet();
    void allocColumnOnDevice(unsigned int colIndex, size_t RecordCount);
    void decompress_char_hash(unsigned int colIndex, unsigned int segment, size_t i_cnt);
    void add_hashed_strings(string field, unsigned int segment, size_t i_cnt);
    void resize(size_t addRecs);
    void resize_join(size_t addRecs);
    void reserve(size_t Recs);
    void deAllocColumnOnDevice(unsigned int colIndex);
    void allocOnDevice(size_t RecordCount);
    void deAllocOnDevice();
    void resizeDeviceColumn(size_t RecCount, unsigned int colIndex);
    void resizeDevice(size_t RecCount);
    bool onDevice(unsigned int i);
    CudaSet* copyDeviceStruct();
    void readSegmentsFromFile(unsigned int segNum, unsigned int colIndex);
    void decompress_char(FILE* f, unsigned int colIndex, unsigned int segNum);
    void CopyColumnToGpu(unsigned int colIndex,  unsigned int segment, size_t offset = 0);
    void CopyColumnToGpu(unsigned int colIndex);
    void CopyColumnToHost(int colIndex, size_t offset, size_t RecCount);
    void CopyColumnToHost(int colIndex);
    void CopyToHost(size_t offset, size_t count);
    float_type* get_float_type_by_name(string name);
    int_type* get_int_by_name(string name);
    float_type* get_host_float_by_name(string name);
    int_type* get_host_int_by_name(string name);
    void GroupBy(std::stack<string> columnRef, unsigned int int_col_count);
    void addDeviceColumn(int_type* col, int colIndex, string colName, size_t recCount);
    void addDeviceColumn(float_type* col, int colIndex, string colName, size_t recCount);
    void compress(string file_name, size_t offset, unsigned int check_type, unsigned int check_val, void* d, size_t mCount);
    void writeHeader(string file_name, unsigned int col, unsigned int tot_segs);
	void reWriteHeader(string file_name, unsigned int col, unsigned int tot_segs, size_t newRecs, size_t maxRecs1);
    void writeSortHeader(string file_name);
    void Store(string file_name, char* sep, unsigned int limit, bool binary);
    void compress_char(string file_name, unsigned int index, size_t mCount, size_t offset);
    bool LoadBigFile(const string file_name, const char* sep);
    void free();
    bool* logical_and(bool* column1, bool* column2);
    bool* logical_or(bool* column1, bool* column2);
    bool* compare(int_type s, int_type d, int_type op_type);
    bool* compare(float_type s, float_type d, int_type op_type);
    bool* compare(int_type* column1, int_type d, int_type op_type);
    bool* compare(float_type* column1, float_type d, int_type op_type);
    bool* compare(int_type* column1, int_type* column2, int_type op_type);
    bool* compare(float_type* column1, float_type* column2, int_type op_type);
    bool* compare(float_type* column1, int_type* column2, int_type op_type);
    float_type* op(int_type* column1, float_type* column2, string op_type, int reverse);
    int_type* op(int_type* column1, int_type* column2, string op_type, int reverse);
    float_type* op(float_type* column1, float_type* column2, string op_type, int reverse);
    int_type* op(int_type* column1, int_type d, string op_type, int reverse);
    float_type* op(int_type* column1, float_type d, string op_type, int reverse);
    float_type* op(float_type* column1, float_type d, string op_type,int reverse);

protected:

    void initialize(queue<string> &nameRef, queue<string> &typeRef, queue<int> &sizeRef, queue<int> &colsRef, size_t Recs, string file_name);
    void initialize(queue<string> &nameRef, queue<string> &typeRef, queue<int> &sizeRef, queue<int> &colsRef, size_t Recs);
    void initialize(size_t RecordCount, unsigned int ColumnCount);
    void initialize(CudaSet* a, CudaSet* b, queue<string> op_sel, queue<string> op_sel_as);
    void initialize(queue<string> op_sel, queue<string> op_sel_as);
};

extern map<string,CudaSet*> varNames; //  STL map to manage CudaSet variables

void allocColumns(CudaSet* a, queue<string> fields);
void gatherColumns(CudaSet* a, CudaSet* t, string field, unsigned int segment, size_t& count);
size_t getSegmentRecCount(CudaSet* a, unsigned int segment);
void copyColumns(CudaSet* a, queue<string> fields, unsigned int segment, size_t& count, bool rsz = 0, bool flt = 1);
void setPrm(CudaSet* a, CudaSet* b, char val, unsigned int segment);
void mygather(unsigned int tindex, unsigned int idx, CudaSet* a, CudaSet* t, size_t offset, size_t g_size);
void mycopy(unsigned int tindex, unsigned int idx, CudaSet* a, CudaSet* t, size_t offset, size_t g_size);
size_t load_queue(queue<string> c1, CudaSet* right, bool str_join, string f2, size_t &rcount,
                  unsigned int start_segment, unsigned int end_segment, bool rsz = 1, bool flt = 1);
size_t max_char(CudaSet* a);
size_t max_tmp(CudaSet* a);
void reset_offsets();
void setSegments(CudaSet* a, queue<string> cols);
size_t max_char(CudaSet* a, set<string> field_names);
size_t max_char(CudaSet* a, queue<string> field_names);
void update_permutation_char(char* key, unsigned int* permutation, size_t RecCount, string SortType, char* tmp, unsigned int len);
void update_permutation_char_host(char* key, unsigned int* permutation, size_t RecCount, string SortType, char* tmp, unsigned int len);
void apply_permutation_char(char* key, unsigned int* permutation, size_t RecCount, char* tmp, unsigned int len);
void apply_permutation_char_host(char* key, unsigned int* permutation, size_t RecCount, char* res, unsigned int len);
size_t load_right(CudaSet* right, unsigned int colInd2, string f2, queue<string> op_g, queue<string> op_sel,
                        queue<string> op_alt, bool decimal_join, bool& str_join, 
                        size_t& rcount, unsigned int start_seg, unsigned int end_seg, bool rsz);
unsigned int calc_right_partition(CudaSet* left, CudaSet* right, queue<string> op_sel);
void sort_right(CudaSet* right, unsigned int colInd2, string f2, queue<string> op_g, queue<string> op_sel,
                bool decimal_join, bool& str_join, size_t& rcount);
				
uint64_t MurmurHash64A ( const void * key, int len, unsigned int seed );
uint64_t MurmurHash64B ( const void * key, int len, unsigned int seed );
int_type reverse_op(int_type op_type);
size_t getFreeMem();
string int_to_string(int number);
void delete_records(char* f);


#endif


#  define CUDA_SAFE_CALL_NO_SYNC( call) do {                                \
    cudaError err = call;                                                    \
    if( cudaSuccess != err) {                                                \
        fprintf(stderr, "Cuda error in file '%s' in line %i : %s.\n",        \
                __FILE__, __LINE__, cudaGetErrorString( err) );              \
        exit(EXIT_FAILURE);                                                  \
    } } while (0)
#  define CUDA_SAFE_CALL( call) do {                                        \
    CUDA_SAFE_CALL_NO_SYNC(call);                                            \
    cudaError err = cudaThreadSynchronize();                                 \
    if( cudaSuccess != err) {                                                \
        fprintf(stderr, "Cuda error in file '%s' in line %i : %s.\n",        \
                __FILE__, __LINE__, cudaGetErrorString( err) );              \
        exit(EXIT_FAILURE);                                                  \
    } } while (0)
