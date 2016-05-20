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

#include <map>
#include <queue>
#include <string>
#include <vector>

#include "global.h"

namespace alenka {

//config
string data_dict_local_name = "data.dictionary";
string data_dict_redis_simple_host = "localhost";
unsigned int data_dict_redis_simple_port = 6379;
bool data_dict_redis_simple_pool = true;
string data_dict_redis_ha_sentinel_host = "redis1,redis2,redis3";
string data_dict_redis_ha_master_name = "redis-cluster";
unsigned int data_dict_redis_ha_sentinel_port = 26379;
bool data_dict_redis_ha_pool = true;
string file_system_local_base_path= ".";
string file_system_hdfs_host = "default";
unsigned int file_system_hdfs_port = 0;
string file_system_hdfs_base_path = "/tmp/";

//common
size_t int_size = sizeof(int_type);
size_t float_size = sizeof(float_type);
unsigned int total_segments = 0, old_segments;
unsigned int hash_seed;
time_t curr_time;
void* d_v = nullptr;
void* s_v = nullptr;
queue<string> op_type;
bool op_case;
queue<string> op_sort;
queue<string> op_presort;
queue<string> op_value;
string grp_val;
queue<int_type> op_nums;
queue<float_type> op_nums_f;
queue<unsigned int> op_nums_precision; //decimals' precision
queue<string> col_aliases;
size_t total_count = 0, oldCount, total_max, totalRecs, alloced_sz = 0;
size_t process_count;
bool fact_file_loaded = 1;
unsigned int partition_count;
map<string, string> setMap; //map to keep track of column names and set names
clock_t tot;
clock_t tot_disk;
unsigned long long int currtime;
bool verbose;
bool save_dict = 0;
bool interactive;
bool ssd;
bool delta;
bool star;
map<string, char*> index_buffers;
map<string, char*> buffers;
map<string, size_t> buffer_sizes;
queue<string> buffer_names;
size_t total_buffer_size;
thrust::device_vector<unsigned char> scratch;
char* readbuff;
thrust::device_vector<unsigned int> rcol_matches;
thrust::device_vector<int_type> rcol_dev;
thrust::device_vector<int> ranj;
size_t allocated_sz;
standard_context_t context;
map<unsigned int, map<unsigned long long int, size_t> > char_hash; // mapping between column's string hashes and string positions
bool scan_state;
unsigned int statement_count;
map<string, map<string, bool> > used_vars;
map<string, unsigned int> cpy_bits;
map<string, long long int> cpy_init_val;
bool phase_copy;
map<string, bool> min_max_eq;
map<string, string> filter_var;
void* alloced_tmp;
bool alloced_switch = 0;
vector<void*> alloced_mem;
IDataDict *data_dict;
map<string, unsigned long long int*> idx_vals; // pointer to compressed values in gpu memory
map<string, unsigned int> cnt_counts;
string curr_file;
IFileSystem *file_system;
stringstream display_results;

struct res{
	int code;
	string results;
};

//operators
queue<string> namevars;
queue<string> typevars;
queue<int> sizevars;
queue<int> cols;
queue<unsigned int> j_col_count;
unsigned int sel_count = 0;
unsigned int join_cnt = 0;;
unsigned int distinct_cnt = 0;
unsigned int join_col_cnt = 0;
unsigned int join_tab_cnt = 0;
unsigned int tab_cnt = 0;
queue<string> op_join;
queue<char> join_type;
queue<char> join_eq_type;
map<string, unsigned int> stat;
map<unsigned int, unsigned int> join_and_cnt;

int get_utc_offset() {
	time_t zero = 24*60*60L;
	struct tm * timeptr;
	int gmtime_hours;

	/* get the local time for Jan 2, 1900 00:00 UTC */
	timeptr = localtime(&zero);
	gmtime_hours = timeptr->tm_hour;

	/* if the local time is the "day before" the UTC, subtract 24 hours
	from the hours to get the UTC offset */
	if (timeptr->tm_mday < 2)
	gmtime_hours -= 24;

	return gmtime_hours;
}

/*
  the utc analogue of mktime,
  (much like timegm on some systems)
*/
time_t tm_to_time_t_utc(struct tm * timeptr) {
  /* gets the epoch time relative to the local time zone,
  and then adds the appropriate number of seconds to make it UTC */
  return mktime(timeptr) + get_utc_offset() * 3600;
}

size_t getFreeMem() {
    size_t available, total;
    cudaMemGetInfo(&available, &total);
    return available;
}

#ifdef _WIN64
size_t getTotalSystemMemory() {
    MEMORYSTATUSEX status;
    status.dwLength = sizeof(status);
    GlobalMemoryStatusEx(&status);
    return status.ullTotalPhys;
}
#else
size_t getTotalSystemMemory() {
    long pages = sysconf(_SC_PHYS_PAGES);
    long page_size = sysconf(_SC_PAGE_SIZE);
    return pages * page_size;
}
#endif

void process_error(int severity, string err) {
    switch (severity) {
    case 1:
        err = "(Warning) " + err;
        break;
    case 2:
        err = "(Fatal) " + err;
        break;
    default:
        err = "(Aborting) " + err;
        break;
    }
    error_cb(severity, err.c_str());            // send the error to the c based callback
}

time_t add_interval(time_t t, int year, int month, int day, int hour, int minute, int second) {
	if (year) {
		struct tm tt = *gmtime(&t);
		tt.tm_year = tt.tm_year + year;
		return tm_to_time_t_utc(&tt);
	} else if (month) {
		struct tm tt = *gmtime(&t);
		if (tt.tm_mon + month > 11) {
			tt.tm_year++;
			tt.tm_mon = ((tt.tm_mon + month) - 11)-1;
		} else {
			tt.tm_mon = tt.tm_mon + month;
		}
		return tm_to_time_t_utc(&tt);
	} else if (day) {
		return t + day*24*60*60;
	} else if (hour) {
		return t + hour*60*60;
	} else if (minute) {
		return t + minute*60;
	} else {
		return t + second;
	}
}

void alloc_pool(unsigned int maxRecs) {
	void* temp;
	CUDA_SAFE_CALL(cudaMalloc((void **) &temp, 8*maxRecs));
	alloced_mem.push_back(temp);
}


} // namespace alenka

