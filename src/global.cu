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

#include "global.h"

size_t int_size = sizeof(int_type);
size_t float_size = sizeof(float_type);

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
vector<void*> alloced_mem;

map<string, unsigned int> cpy_bits;
map<string, long long int> cpy_init_val;
char* readbuff = nullptr;
thrust::device_vector<unsigned int> rcol_matches;
thrust::device_vector<int_type> rcol_dev;

clock_t tot_disk;



//map<string,CudaSet*> varNames; //  STL map to manage CudaSet variables
