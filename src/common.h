#ifndef COMMON_H_
#define COMMON_H_

#include <unistd.h>

#include "CudaSet.h"
#include "zone_map.h"
#include "filter.h"
#include "strings_sort_host.h"

struct col_data {
	unsigned int col_type;
	unsigned int col_length;
};


size_t total_count = 0, total_max;
clock_t tot;
unsigned int total_segments = 0, old_segments;
size_t process_count;
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
string grp_val;
queue<string> op_value;
queue<int_type> op_nums;
queue<float_type> op_nums_f;
queue<unsigned int> op_nums_precision;
queue<string> col_aliases;
map<string, map<string, col_data> > data_dict;
map<unsigned int, map<unsigned long long int, size_t> > char_hash;

map<string, char*> index_buffers;
map<string, unsigned long long int*> idx_vals;
map<string, char*> buffers;
map<string, size_t> buffer_sizes;
size_t total_buffer_size;
queue<string> buffer_names;

void* alloced_tmp;
bool alloced_switch = 0;
map<string,CudaSet*> varNames; //  STL map to manage CudaSet variables
map<string, unsigned int> cpy_bits;
map<string, long long int> cpy_init_val;
char* readbuff = nullptr;
thrust::device_vector<unsigned int> rcol_matches;
thrust::device_vector<int_type> rcol_dev;



void write_compressed_char(string file_name, unsigned int index, size_t mCount);
size_t getFreeMem();
size_t getTotalSystemMemory();
void process_error(int severity, string err);




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
time_t add_interval(time_t t, int year, int month, int day, int hour, int minute, int second);
void compress_int(const string file_name, const thrust::host_vector<int_type>& res);



#endif /* COMMON_H_ */
