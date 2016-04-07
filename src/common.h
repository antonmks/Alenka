#ifndef COMMON_H_
#define COMMON_H_

#include <unistd.h>

#include "global.h"
#include "CudaSet.h"
#include "zone_map.h"
#include "filter.h"
#include "strings_sort_host.h"

extern map<string,CudaSet*> varNames;

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
