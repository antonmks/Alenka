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

#ifndef CUDASET_H_
#define CUDASET_H_

#include <queue>
#include <string>
#include <map>
#include <vector>
#include <set>
#include <stack>
#include <unordered_map>

#include "global.h"
#include "compress.cuh"
#include "sorts.h"
#include "util.cuh"
#include "murmurhash2_64.h"

using namespace thrust::placeholders;

namespace alenka {

class CudaSet {
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
    queue<string> fil_type, fil_value;
    queue<int_type> fil_nums;
    queue<float_type> fil_nums_f;
	queue<unsigned int> fil_nums_precision;

    size_t mRecCount, maxRecs, hostRecCount, devRecCount, grp_count, segCount, totalRecs;
    vector<string> columnNames;
	map<string, bool> compTypes; // pfor delta or not
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
	map<string, bool> ts_cols; //timestamp columns

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
    bool LoadBigFile(iFileSystemHandle* file_p, thrust::device_vector<char>& d_readbuff, thrust::device_vector<char*>& dest,
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
	void calc_intervals(string dt1, string dt2, string index, unsigned int total_segs, bool append);
	void gpu_perm(queue<string> sf, thrust::device_vector<unsigned int>& permutation);

protected:
    void initialize(queue<string> &nameRef, queue<string> &typeRef, queue<int> &sizeRef, queue<int> &colsRef, size_t Recs, string file_name);
    void initialize(queue<string> &nameRef, queue<string> &typeRef, queue<int> &sizeRef, queue<int> &colsRef, size_t Recs);
    void initialize(const size_t RecordCount, const unsigned int ColumnCount);
    void initialize(CudaSet* a, CudaSet* b, queue<string> op_sel, queue<string> op_sel_as);
    void initialize(queue<string> op_sel, const queue<string> op_sel_as);

};

} // namespace alenka

#endif /* CUDASET_H_ */
