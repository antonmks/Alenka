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

#ifndef COMMON_H_
#define COMMON_H_

#include <map>
#include <queue>
#include <string>

#include "global.h"
#include "cudaset.h"
#include "zone_map.h"
#include "filter.h"
#include "operators.h"
#include "strings_sort_host.h"

namespace alenka {

extern map<string, CudaSet*> varNames; //  STL map to manage CudaSet variables

void allocColumns(CudaSet* a, queue<string> fields);
void gatherColumns(CudaSet* a, CudaSet* t, string field, unsigned int segment, size_t& count);
void copyFinalize(CudaSet* a, queue<string> fields, bool ts);
void copyColumns(CudaSet* a, queue<string> fields, unsigned int segment, size_t& count, bool rsz = 0, bool flt = 1);
void mygather(string colname, CudaSet* a, CudaSet* t, size_t offset, size_t g_size);
void mycopy(string colname, CudaSet* a, CudaSet* t, size_t offset, size_t g_size);
size_t load_queue(queue<string> c1, CudaSet* right, string f2, size_t &rcount, unsigned int start_segment, unsigned int end_segment, bool rsz = 1, bool flt = 1);
size_t max_char(CudaSet* a);
size_t max_char(CudaSet* a, queue<string> field_names);
void setSegments(CudaSet* a, queue<string> cols);
void update_permutation_char_host(char* key, unsigned int* permutation, size_t RecCount, string SortType, char* tmp, unsigned int len) ;
void apply_permutation_char(char* key, unsigned int* permutation, size_t RecCount, char* tmp, unsigned int len);
void apply_permutation_char_host(char* key, unsigned int* permutation, size_t RecCount, char* res, unsigned int len);
void filter_op(const char *s, const char *f, unsigned int segment);
int_type reverse_op(int_type op_type);
size_t load_right(CudaSet* right, string f2, queue<string> op_g, queue<string> op_alt, size_t& rcount, unsigned int start_seg, unsigned int end_seg);
void insert_records(const char* f, const char* s);
void delete_records(const char* f);
bool var_exists(CudaSet* a, string name);
bool check_bitmap_file_exist(CudaSet* left, CudaSet* right);
bool check_bitmaps_exist(CudaSet* left, CudaSet* right);
void check_sort(const string str, const char* rtable, const char* rid);
void update_char_permutation(CudaSet* a, string colname, unsigned int* raw_ptr, string ord, void* temp, bool host);
void compress_int(const string file_name, const thrust::host_vector<int_type>& res);
unsigned int get_decimals(CudaSet* a, string s1_val, stack<unsigned int>& exe_precision);
int_type* get_host_vec(CudaSet* a, string s1_val, stack<int_type*>& exe_vectors);
int_type* get_vec(CudaSet* a, string s1_val, stack<int_type*>& exe_vectors);
void yyerror(char *s, ...);
void clean_queues();
void load_vars();
void init(char ** av);
void close();

} // namespace alenka

#endif /* COMMON_H_ */
