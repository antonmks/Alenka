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

typedef unsigned int uint;

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
#include "moderngpu/src/moderngpu/kernel_reduce.hxx"
#include "moderngpu/src/moderngpu/kernel_segreduce.hxx"

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
extern string grp_val;
extern queue<int_type> op_nums;
extern queue<float_type> op_nums_f;
extern queue<unsigned int> op_nums_precision; //decimals' precision
extern queue<string> col_aliases;
extern size_t total_count, oldCount, total_max, totalRecs, alloced_sz;
extern unsigned int total_segments;
extern size_t process_count;
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
extern unsigned int prs;
extern bool delta;
extern bool star;
extern map<string, char*> index_buffers;
extern map<string, char*> buffers;
extern map<string, size_t> buffer_sizes;
extern queue<string> buffer_names;
extern size_t total_buffer_size;
extern thrust::device_vector<unsigned char> scratch;
extern thrust::device_vector<unsigned int> rcol_matches;
extern thrust::device_vector<int_type> rcol_dev;
extern thrust::device_vector<int> ranj;
extern size_t alloced_sz;
//extern ContextPtr context;
extern standard_context_t context;
extern map<unsigned int, map<unsigned long long int, size_t> > char_hash; // mapping between column's string hashes and string positions
extern bool scan_state;
extern unsigned int statement_count;
extern map<string, map<string, bool> > used_vars;
extern map<string, unsigned int> cpy_bits;
extern map<string, long long int> cpy_init_val;
extern bool phase_copy;
extern map<string,bool> min_max_eq;
extern vector<void*> alloced_mem;
extern map<string, string> filter_var;

struct gpu_tdate
{
    const char *source;
    long long int *dest;

    gpu_tdate(const char *_source, long long int *_dest):
        source(_source), dest(_dest) {}
    template <typename IndexType>
    __host__ __device__
    void operator()(const IndexType & i) {
        const char *s;
        long long int acc;
        int z = 0, c;
        int y, m, d, h, min, sec, ms;
        bool year_set = 0;

        s = source + 23*i;
        c = (unsigned char) *s++;

        for (acc = 0; z < 10; c = (unsigned char) *s++) {
            if(c != '-') {
                c -= '0';
                acc *= 10;
                acc += c;
            }
            else {
                if(!year_set) {
                    y = acc;
                    year_set = 1;
                }
                else
                    m = acc;
                acc = 0;
            };
            z++;
        }

        d = acc;

        c = (unsigned char) s[0];
        c -= '0';
        h = c*10;
        c = (unsigned char) s[1];
        c -= '0';
        h = h+c;

        c = (unsigned char) s[3];
        c -= '0';
        min = c*10;
        c = (unsigned char) s[4];
        c -= '0';
        min = min+c;

        c = (unsigned char) s[6];
        c -= '0';
        sec = c*10;
        c = (unsigned char) s[7];
        c -= '0';
        sec = sec+c;

        c = (unsigned char) s[9];
        c -= '0';
        ms = c*100;
        c = (unsigned char) s[10];
        c -= '0';
        ms = ms+c*10;
        c = (unsigned char) s[11];
        c -= '0';
        ms = ms+c;


        y -= m <= 2;
        const int era = (y >= 0 ? y : y-399) / 400;
        const unsigned yoe = static_cast<unsigned>(y - era * 400);      // [0, 399]
        const unsigned doy = (153*(m + (m > 2 ? -3 : 9)) + 2)/5 + d-1;  // [0, 365]
        const unsigned doe = yoe * 365 + yoe/4 - yoe/100 + doy;         // [0, 146096]
        dest[i] =  (long long int)(era * 146097 + static_cast<int>(doe) - 719468)*24*60*60*1000 + (long long int)h*60*60*1000 + (long long int)min*60*1000 + (long long int)sec*1000 + (long long int)ms;
    }
};

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


struct set_minus : public binary_function<int,bool,int>
{
    /*! Function call operator. The return value is <tt>lhs + rhs</tt>.
     */
    __host__ __device__ int operator()(const int &lhs, const bool &rhs) const {
        if (rhs)
            return lhs;
        else
            return -1;
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
    __device__
    long long int operator()(const float_type x)
    {
        return __double2ll_rn(x*100);
    }
};

struct decrease
{
    __device__
    unsigned int operator()(const unsigned int x)
    {
        if(x > 0)
            return x-1;
        else
            return x;
    }
};

struct float_equal_to
{
    __device__
    bool operator()(const float_type &lhs, const float_type &rhs) const {
        return (__double2ll_rn(lhs*100) == __double2ll_rn(rhs*100));
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


struct is_break
{
    __host__ __device__
    bool operator()(const char x)
    {
        return x == '\n';
    }
};




struct split_int2
{
    int *v1;
    int *v2;
    const int2 *source;

    split_int2(int *_v1, int *_v2, const int2* _source):
        v1(_v1), v2(_v2), source(_source) {}
    template <typename IndexType>
    __host__ __device__
    void operator()(const IndexType & i) {

        v1[i] = source[i].x;
        v2[i] = source[i].y;
    }
};



struct gpu_date
{
    const char *source;
    long long int *dest;

    gpu_date(const char *_source, long long int *_dest):
        source(_source), dest(_dest) {}
    template <typename IndexType>
    __host__ __device__
    void operator()(const IndexType & i) {
        const char *s;
        long long int acc;
        int z = 0, c;

        s = source + 23*i;
        c = (unsigned char) *s++;

        for (acc = 0; z < 10; c = (unsigned char) *s++) {
            if(c != '-') {
                c -= '0';
                acc *= 10;
                acc += c;
            };
            z++;
        }
        dest[i] = acc;
    }
};





struct gpu_atof
{
    const char *source;
    double *dest;
    const unsigned int *len;

    gpu_atof(const char *_source, double *_dest, const unsigned int *_len):
        source(_source), dest(_dest), len(_len) {}
    template <typename IndexType>
    __host__ __device__
    void operator()(const IndexType & i) {
        const char *p;
        int frac;
        double sign, value, scale;

        p = source + len[0]*i;

        while (*p == ' ') {
            p += 1;
        }

        sign = 1.0;
        if (*p == '-') {
            sign = -1.0;
            p += 1;
        } else
            if (*p == '+') {
                p += 1;
            }

        for (value = 0.0; *p >= '0' && *p <= '9'; p += 1) {
            value = value * 10.0 + (*p - '0');
        }

        if (*p == '.') {
            double pow10 = 10.0;
            p += 1;
            while (*p >= '0' && *p <= '9') {
                value += (*p - '0') / pow10;
                pow10 *= 10.0;
                p += 1;
            }
        }

        frac = 0;
        scale = 1.0;

        dest[i] = sign * (frac ? (value / scale) : (value * scale));
    }
};



struct gpu_atod
{
    const char *source;
    int_type *dest;
    const unsigned int *len;
    const unsigned int *sc;

    gpu_atod(const char *_source, int_type *_dest, const unsigned int *_len, const unsigned int *_sc):
        source(_source), dest(_dest), len(_len), sc(_sc) {}
    template <typename IndexType>
    __host__ __device__
    void operator()(const IndexType & i) {
        const char *p;
        int frac;
        double sign, value, scale;

        p = source + len[0]*i;

        while (*p == ' ') {
            p += 1;
        }

        sign = 1.0;
        if (*p == '-') {
            sign = -1.0;
            p += 1;
        } else
            if (*p == '+') {
                p += 1;
            }

        for (value = 0.0; *p >= '0' && *p <= '9'; p += 1) {
            value = value * 10.0 + (*p - '0');
        }

        if (*p == '.') {
            double pow10 = 10.0;
            p += 1;
            while (*p >= '0' && *p <= '9') {
                value += (*p - '0') / pow10;
                pow10 *= 10.0;
                p += 1;
            }
        }

        frac = 0;
        scale = 1.0;

        dest[i] = (sign * (frac ? (value / scale) : (value * scale)))*sc[0];
    }
};


struct gpu_atold
{
    const char *source;
    long long int *dest;
    const unsigned int *len;
    const unsigned int *sc;

    gpu_atold(const char *_source, long long int *_dest, const unsigned int *_len, const unsigned int *_sc):
        source(_source), dest(_dest), len(_len), sc(_sc) {}
    template <typename IndexType>
    __host__ __device__
    void operator()(const IndexType & i) {
        const char *s;
        long long int acc;
        int c;
        int neg;
        int point = 0;
        bool cnt = 0;

        s = source + len[0]*i;

        do {
            c = (unsigned char) *s++;
        } while (c == ' ');

        if (c == '-') {
            neg = 1;
            c = *s++;
        } else {
            neg = 0;
            if (c == '+')
                c = *s++;
        }

        for (acc = 0;; c = (unsigned char) *s++) {
            if (c >= '0' && c <= '9')
                c -= '0';
            else {
                if(c != '.')
                    break;
                cnt = 1;
                continue;
            };
            if (c >= 10)
                break;
            if (neg) {
                acc *= 10;
                acc -= c;
            }
            else {
                acc *= 10;
                acc += c;
            }
            if(cnt)
                point++;
            if(point == sc[0])
                break;
        }
        dest[i] = acc * (unsigned int)exp10((double)sc[0]- point);
    }
};


struct gpu_atoll
{
    const char *source;
    long long int *dest;
    const unsigned int *len;

    gpu_atoll(const char *_source, long long int *_dest, const unsigned int *_len):
        source(_source), dest(_dest), len(_len) {}
    template <typename IndexType>
    __host__ __device__
    void operator()(const IndexType & i) {
        const char *s;
        long long int acc;
        int c;
        int neg;

        s = source + len[0]*i;

        do {
            c = (unsigned char) *s++;
        } while (c == ' ');

        if (c == '-') {
            neg = 1;
            c = *s++;
        } else {
            neg = 0;
            if (c == '+')
                c = *s++;
        }

        for (acc = 0;; c = (unsigned char) *s++) {
            if (c >= '0' && c <= '9')
                c -= '0';
            else
                break;
            if (c >= 10)
                break;
            if (neg) {
                acc *= 10;
                acc -= c;
            }
            else {
                acc *= 10;
                acc += c;
            }
        }
        dest[i] = acc;
    }
};

#define MAX_LONG            180.0
#define MIN_LONG            -180.0



struct parse_functor
{
    const char *source;
    char **dest;
    const unsigned int *ind;
    const unsigned int *cnt;
    const char *separator;
    const long long int *src_ind;
    const unsigned int *dest_len;

    parse_functor(const char* _source, char** _dest, const unsigned int* _ind, const unsigned int* _cnt, const char* _separator,
                  const long long int* _src_ind, const unsigned int* _dest_len):
        source(_source), dest(_dest), ind(_ind), cnt(_cnt),  separator(_separator), src_ind(_src_ind), dest_len(_dest_len) {}

    template <typename IndexType>
    __host__ __device__
    void operator()(const IndexType & i) {
        unsigned int curr_cnt = 0, dest_curr = 0, j = 0, t, pos;
        bool open_quotes = 0;
        pos = src_ind[i]+1;

        while(dest_curr < *cnt) {
            if(ind[dest_curr] == curr_cnt) { //process
                t = 0;
                while(source[pos+j] != *separator || open_quotes) {
                    //printf("REG %d ", j);
                    if(source[pos+j] == '"') {
                        open_quotes = !open_quotes;
                    };
                    if(source[pos+j] != 0) {
                        dest[dest_curr][dest_len[dest_curr]*i+t] = source[pos+j];
                        t++;
                    };
                    j++;
                };
                j++;
                dest_curr++;
            }
            else {
                //printf("Skip %d \n", j);
                while(source[pos+j] != *separator || open_quotes) {
                    if(source[pos+j] == '"') {
                        open_quotes = !open_quotes;
                    };
                    j++;
                    //printf("CONT Skip %d \n", j);
                };
                j++;
            };
            curr_cnt++;
            //printf("DEST CURR %d %d %d %d \n" , j, dest_curr, ind[dest_curr], curr_cnt);
        }

    }
};


#ifdef _WIN64
typedef unsigned __int64 uint64_t;
#endif


struct col_data {
    unsigned int col_type;
    unsigned int col_length;
};
extern map<string, map<string, col_data> > data_dict;

struct bitmap_data {
    string ltable;
    string rtable;
    string lid;
    string rid;
    string rcolumn;
};
extern map<string, bitmap_data> ind_dict;


extern time_t curr_time;
extern map<string, unsigned long long int*> idx_vals; // pointer to compressed values in gpu memory


class CudaSet
{
public:
    map<string, thrust::host_vector<int_type, pinned_allocator<int_type> > > h_columns_int;
    map<string, thrust::host_vector<float_type, pinned_allocator<float_type> > > h_columns_float;
    map<string, char*> h_columns_char;
    map<string, thrust::device_vector<int_type > > d_columns_int;
    map<string, thrust::device_vector<float_type > > d_columns_float;
    map<string, char*> d_columns_char;
    map<string, size_t> char_size;
    thrust::device_vector<unsigned int> prm_d;
    map<string, string> string_map; //maps char column names to string files, only a select operator changes the original mapping
    char prm_index; // A - all segments values match, N - none match, R - some may match
    map<string, map<int_type, unsigned int> > idx_dictionary_int; //stored in host memory

    // to do filters in-place (during joins, groupby etc ops) we need to save a state of several queues's and a few misc. variables:
    char* fil_s, * fil_f, sort_check;
    queue<string> fil_type,fil_value;
    queue<int_type> fil_nums;
    queue<float_type> fil_nums_f;
    queue<unsigned int> fil_nums_precision;

    size_t mRecCount, maxRecs, hostRecCount, devRecCount, grp_count, segCount, totalRecs;
    vector<string> columnNames;
    map<string,bool> compTypes; // pfor delta or not
    map<string, FILE*> filePointers;
    thrust::device_vector<unsigned int> grp;
    bool not_compressed; // 1 = host recs are not compressed, 0 = compressed
    unsigned int mColumnCount;
    string name, load_file_name, separator, source_name;
    bool source, text_source, tmp_table, keep, filtered;
    queue<string> sorted_fields; //segment is sorted by fields
    queue<string> presorted_fields; //globally sorted by fields
    map<string, unsigned int> type; // 0 - integer, 1-float_type, 2-char
    map<string, bool> decimal; // column is decimal - affects only compression
    map<string, unsigned int> decimal_zeroes; // number of zeroes in decimals
    map<string, unsigned int> grp_type; // type of group : SUM, AVG, COUNT etc
    map<unsigned int, string> cols; // column positions in a file
    map<string, bool> map_like; //for LIKE processing
    map<string, thrust::device_vector<unsigned int> > map_res; //also for LIKE processing
    map<string,bool> ts_cols; //timestamp columns

    CudaSet(queue<string> &nameRef, queue<string> &typeRef, queue<int> &sizeRef, queue<int> &colsRef, size_t Recs);
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
    void readSegmentsFromFile(unsigned int segNum, string colname);
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
    void compress(string file_name, size_t offset, unsigned int check_type, unsigned int check_val, size_t mCount, const bool compress);
    void writeHeader(string file_name, string colname, unsigned int tot_segs);
    void reWriteHeader(string file_name, string colname, unsigned int tot_segs, size_t newRecs, size_t maxRecs1);
    void writeSortHeader(string file_name);
    void Display(unsigned int limit, bool binary, bool term);
    void Store(const string file_name, const char* sep, const unsigned int limit, const bool binary, const bool append, const bool term = 0);
    void compress_char(const string file_name, const string colname, const size_t mCount, const size_t offset, const unsigned int segment);
    bool LoadBigFile(FILE* file_p, thrust::device_vector<char>& d_readbuff, thrust::device_vector<char*>& dest,
                     thrust::device_vector<unsigned int>& ind, thrust::device_vector<unsigned int>& dest_len);
    void free();
    bool* logical_and(bool* column1, bool* column2);
    bool* logical_or(bool* column1, bool* column2);
    bool* compare(int_type s, int_type d, int_type op_type);
    bool* compare(float_type s, float_type d, int_type op_type);
    bool* compare(int_type* column1, int_type d, int_type op_type, unsigned int p1, unsigned int p2);
    bool* compare(float_type* column1, float_type d, int_type op_type);
    bool* compare(int_type* column1, int_type* column2, int_type op_type, unsigned int p1, unsigned int p2);
    bool* compare(float_type* column1, float_type* column2, int_type op_type);
    bool* compare(float_type* column1, int_type* column2, int_type op_type);
    float_type* op(int_type* column1, float_type* column2, string op_type, bool reverse);
    int_type* op(int_type* column1, int_type* column2, string op_type, bool reverse, unsigned int p1, unsigned int p2);
    float_type* op(float_type* column1, float_type* column2, string op_type, bool reverse);
    int_type* op(int_type* column1, int_type d, string op_type, bool reverse, unsigned int p1, unsigned int p2);
    float_type* op(int_type* column1, float_type d, string op_type, bool reverse);
    float_type* op(float_type* column1, float_type d, string op_type, bool reverse);
    char loadIndex(const string index_name, const unsigned int segment);
    void gpu_perm(queue<string> sf, thrust::device_vector<unsigned int>& permutation);

protected:

    void initialize(queue<string> &nameRef, queue<string> &typeRef, queue<int> &sizeRef, queue<int> &colsRef, size_t Recs, string file_name);
    void initialize(queue<string> &nameRef, queue<string> &typeRef, queue<int> &sizeRef, queue<int> &colsRef, size_t Recs);
    void initialize(const size_t RecordCount, const unsigned int ColumnCount);
    void initialize(CudaSet* a, CudaSet* b, queue<string> op_sel, queue<string> op_sel_as);
    void initialize(queue<string> op_sel, const queue<string> op_sel_as);
};

extern map<string,CudaSet*> varNames; //  STL map to manage CudaSet variables

void allocColumns(CudaSet* a, queue<string> fields);
void gatherColumns(CudaSet* a, CudaSet* t, string field, unsigned int segment, size_t& count);
size_t getSegmentRecCount(CudaSet* a, unsigned int segment);
void copyColumns(CudaSet* a, queue<string> fields, unsigned int segment, size_t& count, bool rsz = 0, bool flt = 1);
void copyFinalize(CudaSet* a, queue<string> fields, bool ts);
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
size_t load_right(CudaSet* right, string f2, queue<string> op_g, queue<string> op_alt, size_t& rcount, unsigned int start_seg, unsigned int end_seg);
uint64_t MurmurHash64A ( const void * key, int len, unsigned int seed );
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
void compress_int(const string file_name, const thrust::host_vector<int_type>& res);
int_type* get_vec(CudaSet* a, string s1_val, stack<int_type*>& exe_vectors);
int_type* get_host_vec(CudaSet* a, string s1_val, stack<int_type*>& exe_vectors);
unsigned int get_decimals(CudaSet* a, string s1_val, stack<unsigned int>& exe_precision);

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
