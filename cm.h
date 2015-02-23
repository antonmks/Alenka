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
#include <thrust/binary_search.h>
#include <thrust/transform.h>
#include <thrust/partition.h>
#include <thrust/fill.h>
#include <thrust/scan.h>
#include <thrust/unique.h>
#include <thrust/gather.h>
#include <thrust/sort.h>
#include <thrust/merge.h>
#include <thrust/functional.h>
#include <thrust/system/cuda/experimental/pinned_allocator.h>
#include <queue>
#include <string>
#include <map>
#include <unordered_map>
#include <set>
#include <vector>
#include <stack>
#include "strings.h"
#include <ctime>
#include <limits>
#include <fstream>
#include "moderngpu-master/include/moderngpu.cuh"

typedef long long int int_type;
typedef unsigned int int32_type;
typedef unsigned short int int16_type;
typedef unsigned char int8_type;
typedef double float_type;

using namespace std;
using namespace mgpu;
using namespace thrust::system::cuda::experimental;

extern size_t int_size;
extern size_t float_size;
extern unsigned int hash_seed;
extern queue<string> op_type;
extern bool op_case;
extern queue<string> op_sort;
extern queue<string> op_presort;
extern queue<string> op_value;
extern queue<int_type> op_nums;
extern queue<float_type> op_nums_f;
extern queue<string> col_aliases;
extern size_t total_count, oldCount, total_max, totalRecs, alloced_sz;
extern unsigned int total_segments;
extern unsigned int process_count;
extern bool fact_file_loaded;
extern void* alloced_tmp;
extern unsigned int partition_count;
extern map<string,string> setMap; //map to keep track of column names and set names
extern std::clock_t tot;
extern std::clock_t tot_disk;
extern bool verbose;
extern bool save_dict;
extern bool interactive;
extern bool ssd;
extern bool delta;
extern bool star;
extern map<string, char*> index_buffers;
extern map<string, char*> buffers;
extern map<string, size_t> buffer_sizes;
extern queue<string> buffer_names;
extern size_t total_buffer_size;
extern thrust::device_vector<unsigned char> scratch;
extern size_t alloced_sz;
extern ContextPtr context;
extern unordered_map<string, unordered_map<unsigned long long int, size_t> > char_hash; // mapping between column's string hashes and string positions
extern bool scan_state;
extern unsigned int statement_count;
extern map<string, map<string, bool> > used_vars;
extern map<string, unsigned int> cpy_bits;
extern map<string, long long int> cpy_init_val;
extern bool phase_copy;

extern vector<void*> alloced_mem;

template<typename T>
struct uninitialized_host_allocator
        : std::allocator<T>
{
    // note that construct is annotated as
    __host__ 
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

template<typename T>
struct is_positive
{
    __host__ __device__
    bool operator()(const T x)
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
		if(x > 0) {
			if ((long long int)((x+EPSILON)*100.0) > (long long int)(x*100.0))
				return (long long int)((x+EPSILON)*100.0);
			else return (long long int)(x*100.0);
		}
		else {	
			if ((long long int)((x-EPSILON)*100.0) < (long long int)(x*100.0))
				return (long long int)((x-EPSILON)*100.0);	
			else return (long long int)(x*100.0);
		};
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


struct long_to_float
{
    __host__ __device__
    float_type operator()(const long long int x)
    {
        return (((float_type)x)/100.0);
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


struct col_data {
	unsigned int col_type;
	unsigned int col_length;
};
extern map<string, map<string, col_data> > data_dict;


class CudaSet
{
public:
    map<string, thrust::host_vector<int_type, pinned_allocator<int_type> > > h_columns_int;
	//map<string, thrust::host_vector<int_type> > h_columns_int;
    map<string, thrust::host_vector<float_type, pinned_allocator<float_type> > > h_columns_float;	
	//map<string, thrust::host_vector<float_type> > h_columns_float;	
    map<string, char*> h_columns_char;
	/*std::vector<thrust::host_vector<int32_type, pinned_allocator<int32_type> > > h_columns_int32;
	std::vector<thrust::host_vector<int16_type, pinned_allocator<int16_type> > > h_columns_int16;
	std::vector<thrust::host_vector<int8_type, pinned_allocator<int8_type> > > h_columns_int8;	
	*/

    map<string, thrust::device_vector<int_type > > d_columns_int;
    map<string, thrust::device_vector<float_type > > d_columns_float;	
    map<string, char*> d_columns_char;		
	
    map<string, size_t> char_size;
    thrust::device_vector<unsigned int> prm_d;
	map<string, string> string_map; //maps char column names to string files, only select operator changes the original mapping
    char prm_index; // A - all segments values match, N - none match, R - some may match
	map<string, map<int_type, unsigned int> > idx_dictionary_int; //stored in host memory
	map<string, unsigned long long int*> idx_vals; // pointer to compressed values in gpu memory

    // to do filters in-place (during joins, groupby etc ops) we need to save a state of several queues's and a few misc. variables:
    char* fil_s, * fil_f, sort_check;
    queue<string> fil_type,fil_value;
    queue<int_type> fil_nums;
    queue<float_type> fil_nums_f;

    size_t mRecCount, maxRecs, hostRecCount, devRecCount, grp_count, segCount, totalRecs;
    vector<string> columnNames;
	map<string,bool> compTypes; // pfor delta or not
    map<string, FILE*> filePointers;
    thrust::device_vector<bool> grp;
    queue<string> columnGroups;
    bool not_compressed; // 1 = host recs are not compressed, 0 = compressed
    unsigned int mColumnCount;
    string name, load_file_name, separator, source_name;
    bool source, text_source, tmp_table, keep, filtered;
    queue<string> sorted_fields; //segment is sorted by fields
    queue<string> presorted_fields; //globally sorted by fields
    map<string, unsigned int> type; // 0 - integer, 1-float_type, 2-char
    map<string, bool> decimal; // column is decimal - affects only compression
    map<string, unsigned int> grp_type; // type of group : SUM, AVG, COUNT etc
    map<unsigned int, string> cols; // column positions in a file
	map<string, bool> map_like; //for LIKE processing
	map<string, thrust::device_vector<unsigned int> > map_res; //also for LIKE processing
	
	//alternative to Bloom filters. Keep track of non-empty segment join results ( not the actual results
	//but just boolean indicators.
	map<string, string> ref_sets; // referencing datasets
	map<string, string> ref_cols; // referencing dataset's column names
	map<string, map<unsigned int, set<unsigned int> > > ref_joins; // columns referencing dataset segments 
	vector< map<string, set<unsigned int> > > orig_segs;

    CudaSet(queue<string> &nameRef, queue<string> &typeRef, queue<int> &sizeRef, queue<int> &colsRef, size_t Recs, queue<string> &references, queue<string> &references_names);
    CudaSet(queue<string> &nameRef, queue<string> &typeRef, queue<int> &sizeRef, queue<int> &colsRef, size_t Recs, string file_name, unsigned int max);
    CudaSet(const size_t RecordCount, const unsigned int ColumnCount);
	CudaSet(queue<string> op_sel, const queue<string> op_sel_as);
    CudaSet(CudaSet* a, CudaSet* b, queue<string> op_sel, queue<string> op_sel_as);    
    ~CudaSet();
    void allocColumnOnDevice(string colname, size_t RecordCount);
    void resize(size_t addRecs);
    void resize_join(size_t addRecs);
    void deAllocColumnOnDevice(string colIndex);
    void allocOnDevice(size_t RecordCount);
    void deAllocOnDevice();
    void resizeDeviceColumn(size_t RecCount, string colIndex);
    void resizeDevice(size_t RecCount);
    bool onDevice(string colname);
    CudaSet* copyDeviceStruct();
    void readSegmentsFromFile(unsigned int segNum, string colname, size_t offset);
	int_type readSsdSegmentsFromFile(unsigned int segNum, string colname, size_t offset, thrust::host_vector<unsigned int>& prm_vh, CudaSet* dest);
	int_type readSsdSegmentsFromFileR(unsigned int segNum, string colname, thrust::host_vector<unsigned int>& prm_vh, thrust::host_vector<unsigned int>& dest);
    void CopyColumnToGpu(string colname,  unsigned int segment, size_t offset = 0);
    void CopyColumnToGpu(string colname);
    void CopyColumnToHost(string colname, size_t offset, size_t RecCount);
    void CopyColumnToHost(string colname);
    void CopyToHost(size_t offset, size_t count);
    float_type* get_float_type_by_name(string name);
    int_type* get_int_by_name(string name);
    float_type* get_host_float_by_name(string name);
    int_type* get_host_int_by_name(string name);
    void GroupBy(std::stack<string> columnRef);
    void addDeviceColumn(int_type* col, string colName, size_t recCount);
    void addDeviceColumn(float_type* col, string colName, size_t recCount, bool is_decimal);
    void compress(string file_name, size_t offset, unsigned int check_type, unsigned int check_val, size_t mCount);
    void writeHeader(string file_name, string colname, unsigned int tot_segs);
	void reWriteHeader(string file_name, string colname, unsigned int tot_segs, size_t newRecs, size_t maxRecs1);
    void writeSortHeader(string file_name);
    void Display(unsigned int limit, bool binary, bool term);
    void Store(const string file_name, const char* sep, const unsigned int limit, const bool binary, const bool term = 0);
    void compress_char(const string file_name, const string colname, const size_t mCount, const size_t offset, const unsigned int segment);
	void compress_int(const string file_name, const string colname, const size_t mCount);
    bool LoadBigFile(FILE* file_p);
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
	char loadIndex(const string index_name, const unsigned int segment);

protected:

    void initialize(queue<string> &nameRef, queue<string> &typeRef, queue<int> &sizeRef, queue<int> &colsRef, size_t Recs, string file_name);
    void initialize(queue<string> &nameRef, queue<string> &typeRef, queue<int> &sizeRef, queue<int> &colsRef, size_t Recs, queue<string> &references, queue<string> &references_names);
    void initialize(const size_t RecordCount, const unsigned int ColumnCount);
    void initialize(CudaSet* a, CudaSet* b, queue<string> op_sel, queue<string> op_sel_as);
    void initialize(queue<string> op_sel, const queue<string> op_sel_as);
};

extern map<string,CudaSet*> varNames; //  STL map to manage CudaSet variables

void allocColumns(CudaSet* a, queue<string> fields);
void gatherColumns(CudaSet* a, CudaSet* t, string field, unsigned int segment, size_t& count);
size_t getSegmentRecCount(CudaSet* a, unsigned int segment);
void copyColumns(CudaSet* a, queue<string> fields, unsigned int segment, size_t& count, bool rsz = 0, bool flt = 1);
void copyFinalize(CudaSet* a, queue<string> fields);
void setPrm(CudaSet* a, CudaSet* b, char val, unsigned int segment);
void mygather(string colname, CudaSet* a, CudaSet* t, size_t offset, size_t g_size);
void mycopy(string colname, CudaSet* a, CudaSet* t, size_t offset, size_t g_size);
size_t load_queue(queue<string> c1, CudaSet* right, string f2, size_t &rcount,
                  unsigned int start_segment, unsigned int end_segment, bool rsz = 1, bool flt = 1);
size_t max_char(CudaSet* a);
void setSegments(CudaSet* a, queue<string> cols);
size_t max_char(CudaSet* a, queue<string> field_names);
void update_permutation_char_host(char* key, unsigned int* permutation, size_t RecCount, string SortType, char* tmp, unsigned int len);
void apply_permutation_char(char* key, unsigned int* permutation, size_t RecCount, char* tmp, unsigned int len);
void apply_permutation_char_host(char* key, unsigned int* permutation, size_t RecCount, char* res, unsigned int len);
size_t load_right(CudaSet* right, string colname, string f2, queue<string> op_g, queue<string> op_sel,
                  queue<string> op_alt, bool decimal_join, size_t& rcount, unsigned int start_seg, unsigned int end_seg, bool rsz);		
uint64_t MurmurHash64A ( const void * key, int len, unsigned int seed );
uint64_t MurmurHash64S ( const void * key, int len, unsigned int seed, unsigned int step, size_t count );
int_type reverse_op(int_type op_type);
size_t getFreeMem();
void delete_records(const char* f);
void insert_records(const char* f, const char* s);
void save_col_data(map<string, map<string, col_data> >& data_dict, string file_name);
void load_col_data(map<string, map<string, col_data> >& data_dict, string file_name);
bool var_exists(CudaSet* a, string name);
int file_exist (const char *filename);
bool check_bitmaps_exist(CudaSet* left, CudaSet* right); 
bool check_bitmap_file_exist(CudaSet* left, CudaSet* right); 
void check_sort(const string str, const char* rtable, const char* rid);
void filter_op(const char *s, const char *f, unsigned int segment);
void update_char_permutation(CudaSet* a, string colname, unsigned int* raw_ptr, string ord, void* temp, bool host);
void alloc_pool(unsigned int maxRecs);

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
