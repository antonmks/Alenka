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

#ifndef GLOBAL_H_
#define GLOBAL_H_

#include <unistd.h>
#include <map>
#include <queue>
#include <string>
#include <vector>

#include "thrust.h"
#include "types.h"
#include "log.h"
#include "callbacks.h"
#include "cuda_safe.h"
#include "idatadict.h"
#include "ifilesystem.h"

#include "moderngpu/src/moderngpu/kernel_reduce.hxx"
#include "moderngpu/src/moderngpu/kernel_segreduce.hxx"

#ifdef DATADICT_REDIS_SIMPLE
#include "datadict_redis_simple.h"
#elif DATADICT_REDIS_HA
#include "datadict_redis_ha.h"
#else
#include "datadict_local.h"
#endif

#ifdef FILESYSTEM_HDFS
#include "filesystem_hdfs.h"
#else
#include "filesystem_local.h"
#endif

using namespace std;
using namespace mgpu;
using namespace thrust::system::cuda::experimental;

namespace alenka {

//config
extern string data_dict_local_name;
extern string data_dict_redis_simple_host;
extern unsigned int data_dict_redis_simple_port;
extern bool data_dict_redis_simple_pool;
extern string data_dict_redis_ha_sentinel_host;
extern string data_dict_redis_ha_master_name;
extern unsigned int ata_dict_redis_ha_sentinel_port;
extern bool data_dict_redis_ha_pool;
extern char* file_system_local_base_path;
extern char* file_system_hfds_host;
extern unsigned int file_system_hfds_port;
extern char* file_system_hfds_base_path;

//common
extern size_t int_size;
extern size_t float_size;
extern unsigned int total_segments, old_segments;
extern unsigned int hash_seed;
extern time_t curr_time;
extern void* d_v;
extern void* s_v;
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
extern size_t process_count;
extern bool fact_file_loaded;
extern unsigned int partition_count;
extern map<string, string> setMap; //map to keep track of column names and set names
extern clock_t tot;
extern clock_t tot_disk;
extern unsigned long long int currtime;
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
extern char* readbuff;
extern thrust::device_vector<unsigned int> rcol_matches;
extern thrust::device_vector<int_type> rcol_dev;
extern thrust::device_vector<int> ranj;
extern size_t allocated_sz;
extern standard_context_t context;
extern map<unsigned int, map<unsigned long long int, size_t> > char_hash; // mapping between column's string hashes and string positions
extern bool scan_state;
extern unsigned int statement_count;
extern map<string, map<string, bool> > used_vars;
extern map<string, unsigned int> cpy_bits;
extern map<string, long long int> cpy_init_val;
extern bool phase_copy;
extern map<string, bool> min_max_eq;
extern map<string, string> filter_var;
extern void* alloced_tmp;
extern bool alloced_switch;
extern vector<void*> alloced_mem;
extern IDataDict *data_dict;
extern map<string, unsigned long long int*> idx_vals; // pointer to compressed values in gpu memory
extern map<string, unsigned int> cnt_counts;
extern string curr_file;
extern IFileSystem *file_system;

//operators
extern queue<string> namevars;
extern queue<string> typevars;
extern queue<int> sizevars;
extern queue<int> cols;
extern queue<unsigned int> j_col_count;
extern unsigned int sel_count;
extern unsigned int join_cnt;
extern unsigned int distinct_cnt;
extern unsigned int join_col_cnt;
extern unsigned int join_tab_cnt;
extern unsigned int tab_cnt;
extern queue<string> op_join;
extern queue<char> join_type;
extern queue<char> join_eq_type;
extern map<string, unsigned int> stat;
extern map<unsigned int, unsigned int> join_and_cnt;

int get_utc_offset();
time_t tm_to_time_t_utc(struct tm * timeptr);
size_t getFreeMem();
size_t getTotalSystemMemory();
void process_error(int severity, string err);
time_t add_interval(time_t t, int year, int month, int day, int hour, int minute, int second);
void alloc_pool(unsigned int maxRecs);

} // namespace alenka

#endif /* GLOBAL_H_ */
