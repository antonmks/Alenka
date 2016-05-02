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

#include <queue>
#include <string>
#include <map>
#include <stack>
#include <set>
#include <vector>
#include <algorithm>

#include "cudaset.h"

namespace alenka {

extern void copyFinalize(CudaSet* a, queue<string> fields, bool ts);
extern void update_permutation_char_host(char* key, unsigned int* permutation, size_t RecCount, string SortType, char* tmp, unsigned int len);
extern void apply_permutation_char_host(char* key, unsigned int* permutation, size_t RecCount, char* res, unsigned int len);
extern void allocColumns(CudaSet* a, queue<string> fields);
extern void copyColumns(CudaSet* a, queue<string> fields, unsigned int segment, size_t& count, bool rsz = 0, bool flt = 1);
extern map<string, CudaSet*> varNames; //  STL map to manage CudaSet variables

CudaSet::CudaSet(queue<string> &nameRef, queue<string> &typeRef, queue<int> &sizeRef, queue<int> &colsRef, size_t Recs)
    : mColumnCount(0), mRecCount(0) {
    initialize(nameRef, typeRef, sizeRef, colsRef, Recs);
    source = 1;
    text_source = 1;
    fil_f = nullptr;
    fil_s = nullptr;
}

CudaSet::CudaSet(queue<string> &nameRef, queue<string> &typeRef, queue<int> &sizeRef, queue<int> &colsRef, size_t Recs, string file_name, unsigned int max)
    : mColumnCount(0),  mRecCount(0) {
    maxRecs = max;
    initialize(nameRef, typeRef, sizeRef, colsRef, Recs, file_name);
    source = 1;
    text_source = 0;
    fil_f = nullptr;
    fil_s = nullptr;
}

CudaSet::CudaSet(const size_t RecordCount, const unsigned int ColumnCount) {
    initialize(RecordCount, ColumnCount);
    keep = false;
    source = 0;
    text_source = 0;
    fil_f = nullptr;
    fil_s = nullptr;
}

CudaSet::CudaSet(queue<string> op_sel, const queue<string> op_sel_as) {
    initialize(op_sel, op_sel_as);
    keep = false;
    source = 0;
    text_source = 0;
    fil_f = nullptr;
    fil_s = nullptr;
}

CudaSet::CudaSet(CudaSet* a, CudaSet* b, queue<string> op_sel, queue<string> op_sel_as) {
    initialize(a, b, op_sel, op_sel_as);
    keep = false;
    source = 0;
    text_source = 0;
    fil_f = nullptr;
    fil_s = nullptr;
}

CudaSet::~CudaSet() {
    free();
}

void CudaSet::allocColumnOnDevice(string colname, size_t RecordCount) {
    if (type[colname] != 1) {
        d_columns_int[colname].resize(RecordCount);
    } else {
        d_columns_float[colname].resize(RecordCount);
    }
}

void CudaSet::resize_join(size_t addRecs) {
    mRecCount = mRecCount + addRecs;
    for (unsigned int i=0; i < columnNames.size(); i++) {
        if (type[columnNames[i]] != 1) {
            h_columns_int[columnNames[i]].resize(mRecCount);
        } else {
            h_columns_float[columnNames[i]].resize(mRecCount);
        }
    }
}

void CudaSet::resize(size_t addRecs) {
    mRecCount = mRecCount + addRecs;
    for (unsigned int i=0; i < columnNames.size(); i++) {
        if (type[columnNames[i]] != 1) {
            h_columns_int[columnNames[i]].resize(mRecCount);
        } else {
            h_columns_float[columnNames[i]].resize(mRecCount);
        }
    }
}

void CudaSet::deAllocColumnOnDevice(string colname) {
    if (type[colname] != 1 && !d_columns_int.empty() && d_columns_int.find(colname) != d_columns_int.end()) {
        if (d_columns_int[colname].size() > 0) {
            d_columns_int[colname].resize(0);
            d_columns_int[colname].shrink_to_fit();
        }
    } else if (type[colname] == 1 && !d_columns_float.empty()) {
        if (d_columns_float[colname].size() > 0) {
            d_columns_float[colname].resize(0);
            d_columns_float[colname].shrink_to_fit();
        }
    }
}

void CudaSet::allocOnDevice(size_t RecordCount) {
    for (unsigned int i=0; i < columnNames.size(); i++)
        allocColumnOnDevice(columnNames[i], RecordCount);
}

void CudaSet::deAllocOnDevice() {
    for (unsigned int i=0; i < columnNames.size(); i++) {
        deAllocColumnOnDevice(columnNames[i]);
	}

	if (prm_d.size()) {
		prm_d.resize(0);
		prm_d.shrink_to_fit();
	}

    for (auto it=d_columns_int.begin(); it != d_columns_int.end(); ++it) {
        if (it->second.size() > 0) {
            it->second.resize(0);
            it->second.shrink_to_fit();
        }
    }

    for (auto it=d_columns_float.begin(); it != d_columns_float.end(); ++it) {
        if (it->second.size() > 0) {
            it->second.resize(0);
            it->second.shrink_to_fit();
        }
    }

    if (filtered) { // dealloc the source
        if (varNames.find(source_name) != varNames.end()) {
            varNames[source_name]->deAllocOnDevice();
        }
    }
}

void CudaSet::resizeDeviceColumn(size_t RecCount, string colname) {
    if (type[colname] != 1) {
        d_columns_int[colname].resize(RecCount);
    } else {
        d_columns_float[colname].resize(RecCount);
    }
}

void CudaSet::resizeDevice(size_t RecCount) {
    for (unsigned int i=0; i < columnNames.size(); i++) {
        resizeDeviceColumn(RecCount, columnNames[i]);
    }
}

bool CudaSet::onDevice(string colname) {
    if (type[colname] != 1) {
        if (!d_columns_int.empty() && d_columns_int[colname].size())
            return 1;
    } else {
        if (!d_columns_float.empty() && d_columns_float[colname].size())
            return 1;
    }
    return 0;
}

CudaSet* CudaSet::copyDeviceStruct() {
    CudaSet* a = new CudaSet(mRecCount, mColumnCount);
    a->not_compressed = not_compressed;
    a->segCount = segCount;
    a->maxRecs = maxRecs;
    a->columnNames = columnNames;
	a->ts_cols = ts_cols;
    a->cols = cols;
    a->type = type;
    a->char_size = char_size;
    a->decimal = decimal;
	a->decimal_zeroes = decimal_zeroes;

    for (unsigned int i=0; i < columnNames.size(); i++) {
        if (a->type[columnNames[i]] == 0) {
            a->d_columns_int[columnNames[i]] = thrust::device_vector<int_type>();
            a->h_columns_int[columnNames[i]] = thrust::host_vector<int_type, uninitialized_host_allocator<int_type> >();
        } else if (a->type[columnNames[i]] == 1) {
            a->d_columns_float[columnNames[i]] = thrust::device_vector<float_type>();
            a->h_columns_float[columnNames[i]] = thrust::host_vector<float_type, uninitialized_host_allocator<float_type> >();
        } else {
            a->h_columns_char[columnNames[i]] = nullptr;
            a->d_columns_char[columnNames[i]] = nullptr;
        }
    }
    a->load_file_name = load_file_name;
    a->mRecCount = 0;
    return a;
}

int_type CudaSet::readSsdSegmentsFromFile(unsigned int segNum, string colname, size_t offset, thrust::host_vector<unsigned int>& prm_vh, CudaSet* dest) {
    string f1 = load_file_name + "." + colname + "." + to_string(segNum);
    iFileSystemHandle* f = file_system->open(f1.c_str(), "rb");
    if (!f) {
    	LOG(logERROR) << "Error opening " << f1 << " file ";
        exit(0);
    }

    unsigned int cnt, bits;
    int_type lower_val;

    unsigned short int val_s_r[4096/2];
    char val_c_r[4096];
    unsigned int val_i_r[4096/4];
    unsigned long long int val_l_r[4096/8];
    unsigned int idx;
    bool idx_set = 0;

    file_system->read(&cnt, 4, f);
    file_system->read(&lower_val, 8, f);
    file_system->seek(f, cnt - (8+4) + 32, SEEK_CUR);
    file_system->read(&bits, 4, f);
    LOG(logDEBUG) << "lower_val bits " << lower_val << " " << bits << endl;

    if (type[colname] == 0) {
    	LOG(logDEBUG) << "lower_val bits " << lower_val << " " << bits;
        for (unsigned int i = 0; i < prm_vh.size(); i++) {
            if (!idx_set ||  prm_vh[i] >= idx + 4096/(bits/8))  {
            	file_system->seek(f, 24 + prm_vh[i]*(bits/8), SEEK_SET);
                idx = prm_vh[i];
                idx_set = 1;

                if (bits == 8) {
                	file_system->read(&val_c_r[0], 4096, f);
                    dest->h_columns_int[colname][i + offset] = val_c_r[0];
                } else if (bits == 16) {
                	file_system->read(&val_s_r, 4096, f);
                    dest->h_columns_int[colname][i + offset] = val_s_r[0];
                }
                if (bits == 32) {
                	file_system->read(&val_i_r, 4096, f);
                    dest->h_columns_int[colname][i + offset] = val_i_r[0];
                }
                if (bits == 84) {
                	file_system->read(&val_l_r, 4096, f);
                    dest->h_columns_int[colname][i + offset] = val_l_r[0];
                }
            } else {
                if (bits == 8) {
                    dest->h_columns_int[colname][i + offset] = val_c_r[prm_vh[i]-idx];
                } else if (bits == 16) {
                    dest->h_columns_int[colname][i + offset] = val_s_r[prm_vh[i]-idx];
                }
                if (bits == 32) {
                    dest->h_columns_int[colname][i + offset] = val_i_r[prm_vh[i]-idx];
                }
                if (bits == 84) {
                    dest->h_columns_int[colname][i + offset] = val_l_r[prm_vh[i]-idx];
                }
            }
        }
    } else if (type[colname] == 1) {
        for (unsigned int i = 0; i < prm_vh.size(); i++) {
            if (!idx_set ||  prm_vh[i] >= idx + 4096/(bits/8))  {
            	file_system->seek(f, 24 + prm_vh[i]*(bits/8), SEEK_SET);
                idx = prm_vh[i];
                idx_set = 1;
                file_system->read(val_c_r, 4096, f);
                memcpy(&dest->h_columns_float[colname][i + offset], &val_c_r[0], bits/8);
            } else {
                memcpy(&dest->h_columns_float[colname][i + offset], &val_c_r[(prm_vh[i]-idx)*(bits/8)], bits/8);
            }
        }
    } else {
        //no strings in fact tables
    }
    file_system->close(f);
    return lower_val;
}

int_type CudaSet::readSsdSegmentsFromFileR(unsigned int segNum, string colname, thrust::host_vector<unsigned int>& prm_vh, thrust::host_vector<unsigned int>& dest) {
    string f1 = load_file_name + "." + colname + "." + to_string(segNum);
    iFileSystemHandle* f = file_system->open(f1.c_str(), "rb");
    if (!f) {
    	LOG(logERROR) << "Error opening " << f1 << " file " << endl;
        exit(0);
    }

    unsigned int cnt, bits;
    int_type lower_val;
    file_system->read(&cnt, 4, f);
    file_system->read(&lower_val, 8, f);
    file_system->seek(f, cnt - (8+4) + 32, SEEK_CUR);
    file_system->read(&bits, 4, f);

    unsigned short int val_s_r[4096/2];
    char val_c_r[4096];
    unsigned int val_i_r[4096/4];
    unsigned long long int val_l_r[4096/8];
    unsigned int idx;
    bool idx_set = 0;

    for (unsigned int i = 0; i < prm_vh.size(); i++) {
        if (!idx_set ||  prm_vh[i] >= idx + 4096/(bits/8))  {
        	file_system->seek(f, 24 + prm_vh[i]*(bits/8), SEEK_SET);
            idx = prm_vh[i];
            idx_set = 1;

            if (bits == 8) {
            	file_system->read(val_c_r, 4096, f);
                dest[i] = val_c_r[0];
            } else if (bits == 16) {
            	file_system->read(val_s_r, 4096, f);
                dest[i] = val_s_r[0];
            }
            if (bits == 32) {
            	file_system->read(val_i_r, 4096, f);
                dest[i] = val_i_r[0];
            }
            if (bits == 84) {
            	file_system->read(val_l_r, 4096, f);
                dest[i] = val_l_r[0];
            }
        } else {
            if (bits == 8) {
                dest[i] = val_c_r[prm_vh[i]-idx];
            } else if (bits == 16) {
                dest[i] = val_s_r[prm_vh[i]-idx];
            }
            if (bits == 32) {
                dest[i] = val_i_r[prm_vh[i]-idx];
            }
            if (bits == 84) {
                dest[i] = val_l_r[prm_vh[i]-idx];
            }
        }
    }
    file_system->close(f);
    return lower_val;
}

extern std::clock_t tot_disk;

void CudaSet::readSegmentsFromFile(unsigned int segNum, string colname) {
    string f1 = load_file_name + "." + colname + "." + to_string(segNum);
    if (type[colname] == 2)
        f1 = f1 + ".idx";

    std::clock_t start1 = std::clock();

    if (interactive) { //check if data are in buffers
        if (buffers.find(f1) == buffers.end()) { // add data to buffers
            iFileSystemHandle* f = file_system->open(f1.c_str(), "rb");
            if (!f) {
            	process_error(3, "Error opening " + string(f1) +" file ");
            }
            file_system->seek(f, 0, SEEK_END);
            long fileSize = file_system->tell(f);
            while (total_buffer_size + fileSize > getTotalSystemMemory() && !buffer_names.empty()) { //free some buffers
                //delete [] buffers[buffer_names.front()];
				cudaFreeHost(buffers[buffer_names.front()]);
                total_buffer_size = total_buffer_size - buffer_sizes[buffer_names.front()];
                buffer_sizes.erase(buffer_names.front());
                buffers.erase(buffer_names.front());
                buffer_names.pop();
            }
            file_system->seek(f, 0, SEEK_SET);

			char* buff;
			cudaHostAlloc((void**) &buff, fileSize, cudaHostAllocDefault);
			file_system->read(buff, fileSize, f);
			file_system->close(f);
            buffers[f1] = buff;
            buffer_sizes[f1] = fileSize;
            buffer_names.push(f1);
            total_buffer_size = total_buffer_size + fileSize;
            buffer_names.push(f1);
            LOG(logDEBUG) << "added buffer " << f1 << " " << fileSize << endl;
        }
        // get data from buffers
        if (type[colname] != 1) {
            unsigned int cnt = ((unsigned int*)buffers[f1])[0];
            if (cnt > h_columns_int[colname].size()/8 + 10)
                h_columns_int[colname].resize(cnt/8 + 10);
        } else {
            unsigned int cnt = ((unsigned int*)buffers[f1])[0];
            if (cnt > h_columns_float[colname].size()/8 + 10)
                h_columns_float[colname].resize(cnt/8 + 10);
        }
    } else {
    	iFileSystemHandle* f = file_system->open(f1.c_str(), "rb");
        if (!f) {
        	LOG(logERROR) << "Error opening " << f1 << " file " << endl;
            exit(0);
        }

        if (type[colname] != 1) {
            if (1 > h_columns_int[colname].size())
                h_columns_int[colname].resize(1);
            file_system->read(h_columns_int[colname].data(), 4, f);
            unsigned int cnt = ((unsigned int*)(h_columns_int[colname].data()))[0];
            if (cnt/8+10 > h_columns_int[colname].size()) {
                h_columns_int[colname].resize(cnt + 10);
			}
            size_t rr = file_system->read((unsigned int*)(h_columns_int[colname].data()) + 1, cnt+52, f);
            if (rr != cnt+52) {
                char buf[1024];
                sprintf(buf, "Couldn't read %d bytes from %s ,read only", cnt+52, f1.c_str());
                process_error(3, string(buf));
            }
        } else  {
            if (1 > h_columns_float[colname].size())
                h_columns_float[colname].resize(1);
            file_system->read(h_columns_float[colname].data(), 4, f);
            unsigned int cnt = ((unsigned int*)(h_columns_float[colname].data()))[0];
            if (cnt/8+10 > h_columns_float[colname].size())
                h_columns_float[colname].resize(cnt + 10);
            size_t rr = file_system->read((unsigned int*)(h_columns_float[colname].data()) + 1, cnt+52, f);
            if (rr != cnt+52) {
                char buf[1024];
                sprintf(buf, "Couldn't read %d bytes from %s ,read only", cnt+52, f1.c_str());
                process_error(3, string(buf));
            }
        }
        file_system->close(f);
    }
    tot_disk =  tot_disk + (std::clock() - start1);
}

void CudaSet::CopyColumnToGpu(string colname,  unsigned int segment, size_t offset) {
    if (not_compressed) {
        // calculate how many records we need to copy
        if (segment < segCount-1) {
            mRecCount = maxRecs;
        } else {
            mRecCount = hostRecCount - maxRecs*(segCount-1);
        }

        if (type[colname] != 1) {
            if (!alloced_switch) {
                thrust::copy(h_columns_int[colname].begin() + maxRecs*segment, h_columns_int[colname].begin() + maxRecs*segment + mRecCount, d_columns_int[colname].begin() + offset);
			} else {
                thrust::device_ptr<int_type> d_col((int_type*)alloced_tmp);
                thrust::copy(h_columns_int[colname].begin() + maxRecs*segment, h_columns_int[colname].begin() + maxRecs*segment + mRecCount, d_col);
            }
        } else {
            if (!alloced_switch) {
                thrust::copy(h_columns_float[colname].begin() + maxRecs*segment, h_columns_float[colname].begin() + maxRecs*segment + mRecCount, d_columns_float[colname].begin() + offset);
            } else {
                thrust::device_ptr<float_type> d_col((float_type*)alloced_tmp);
                thrust::copy(h_columns_float[colname].begin() + maxRecs*segment, h_columns_float[colname].begin() + maxRecs*segment + mRecCount, d_col);
            }
        }
    } else {
        readSegmentsFromFile(segment, colname);
        if (!d_v)
            CUDA_SAFE_CALL(cudaMalloc((void **) &d_v, 12));
        if (!s_v)
            CUDA_SAFE_CALL(cudaMalloc((void **) &s_v, 8));

        string f1;
        if (type[colname] == 2) {
            f1 = load_file_name + "." + colname + "." + to_string(segment) + ".idx";
        } else {
            f1 = load_file_name + "." + colname + "." + to_string(segment);
        }

        if (type[colname] != 1) {
            if (!alloced_switch) {
                if (buffers.find(f1) == buffers.end()) {
                    mRecCount = pfor_decompress(thrust::raw_pointer_cast(d_columns_int[colname].data() + offset), h_columns_int[colname].data(), d_v, s_v, colname);
                } else {
                    mRecCount = pfor_decompress(thrust::raw_pointer_cast(d_columns_int[colname].data() + offset), buffers[f1], d_v, s_v, colname);
                }
            } else {
                if (buffers.find(f1) == buffers.end()) {
                    mRecCount = pfor_decompress(alloced_tmp, h_columns_int[colname].data(), d_v, s_v, colname);
                } else {
                    mRecCount = pfor_decompress(alloced_tmp, buffers[f1], d_v, s_v, colname);
                }
            }
        } else {
            if (decimal[colname]) {
                if (!alloced_switch) {
                    if (buffers.find(f1) == buffers.end()) {
                        mRecCount = pfor_decompress(thrust::raw_pointer_cast(d_columns_float[colname].data() + offset) , h_columns_float[colname].data(), d_v, s_v, colname);
                    } else {
                        mRecCount = pfor_decompress(thrust::raw_pointer_cast(d_columns_float[colname].data() + offset) , buffers[f1], d_v, s_v, colname);
                    }
					if (!phase_copy) {
						thrust::device_ptr<long long int> d_col_int((long long int*)thrust::raw_pointer_cast(d_columns_float[colname].data() + offset));
						thrust::transform(d_col_int, d_col_int+mRecCount, d_columns_float[colname].begin(), long_to_float());
					}
                } else {
                    if (buffers.find(f1) == buffers.end()) {
                        mRecCount = pfor_decompress(alloced_tmp, h_columns_float[colname].data(), d_v, s_v, colname);
                    } else {
                        mRecCount = pfor_decompress(alloced_tmp, buffers[f1], d_v, s_v, colname);
                    }
					if (!phase_copy) {
						thrust::device_ptr<long long int> d_col_int((long long int*)alloced_tmp);
						thrust::device_ptr<float_type> d_col_float((float_type*)alloced_tmp);
						thrust::transform(d_col_int, d_col_int+mRecCount, d_col_float, long_to_float());
					}
					//for(int i = 0; i < mRecCount;i++)
					//cout << "DECOMP " << (float_type)(d_col_int[i]) << " " << d_col_float[i] << endl;
                }
            }
            //else // uncompressed float
            // will have to fix it later so uncompressed data will be written by segments too
        }
    }
}

void CudaSet::CopyColumnToGpu(string colname) { // copy all segments
    if (not_compressed) {
        if (type[colname] != 1)
            thrust::copy(h_columns_int[colname].begin(), h_columns_int[colname].begin() + mRecCount, d_columns_int[colname].begin());
        else
            thrust::copy(h_columns_float[colname].begin(), h_columns_float[colname].begin() + mRecCount, d_columns_float[colname].begin());
    } else {
        if (!d_v)
            CUDA_SAFE_CALL(cudaMalloc((void **) &d_v, 12));
        if (!s_v)
            CUDA_SAFE_CALL(cudaMalloc((void **) &s_v, 8));

        size_t cnt = 0;
        string f1;

        for (unsigned int i = 0; i < segCount; i++) {
            readSegmentsFromFile(i, colname);

            if (type[colname] == 2) {
                f1 = load_file_name + "." + colname + "." + to_string(i) + ".idx";
            } else {
                f1 = load_file_name + "." + colname + "." + to_string(i);
            }

            if (type[colname] == 0) {
                if (buffers.find(f1) == buffers.end()) {
                    mRecCount = pfor_decompress(thrust::raw_pointer_cast(d_columns_int[colname].data() + cnt), h_columns_int[colname].data(), d_v, s_v, colname);
                } else {
                    mRecCount = pfor_decompress(thrust::raw_pointer_cast(d_columns_int[colname].data() + cnt), buffers[f1], d_v, s_v, colname);
                }

            } else if (type[colname] == 1) {
                if (decimal[colname]) {
                    if (buffers.find(f1) == buffers.end()) {
                        mRecCount = pfor_decompress(thrust::raw_pointer_cast(d_columns_float[colname].data() + cnt) , h_columns_float[colname].data(), d_v, s_v, colname);
                    } else {
                        mRecCount = pfor_decompress(thrust::raw_pointer_cast(d_columns_float[colname].data() + cnt) , buffers[f1], d_v, s_v, colname);
                    }
					if (!phase_copy) {
						thrust::device_ptr<long long int> d_col_int((long long int*)thrust::raw_pointer_cast(d_columns_float[colname].data() + cnt));
						thrust::transform(d_col_int, d_col_int+mRecCount, d_columns_float[colname].begin() + cnt, long_to_float());
					}
                }
                // else  uncompressed float
                // will have to fix it later so uncompressed data will be written by segments too
            }
            cnt = cnt + mRecCount;

            //totalRecs = totals + mRecCount;
        }

        mRecCount = cnt;
    }
}

void CudaSet::CopyColumnToHost(string colname, size_t offset, size_t RecCount) {
    if (type[colname] != 1) {
        thrust::copy(d_columns_int[colname].begin(), d_columns_int[colname].begin() + RecCount, h_columns_int[colname].begin() + offset);
	} else {
        thrust::copy(d_columns_float[colname].begin(), d_columns_float[colname].begin() + RecCount, h_columns_float[colname].begin() + offset);
	}
}

void CudaSet::CopyColumnToHost(string colname) {
    CopyColumnToHost(colname, 0, mRecCount);
}

void CudaSet::CopyToHost(size_t offset, size_t count) {
    for (unsigned int i = 0; i < columnNames.size(); i++) {
        CopyColumnToHost(columnNames[i], offset, count);
    }
}

float_type* CudaSet::get_float_type_by_name(string name) {
    return thrust::raw_pointer_cast(d_columns_float[name].data());
}

int_type* CudaSet::get_int_by_name(string name) {
    return thrust::raw_pointer_cast(d_columns_int[name].data());
}

float_type* CudaSet::get_host_float_by_name(string name) {
    return thrust::raw_pointer_cast(h_columns_float[name].data());
}

int_type* CudaSet::get_host_int_by_name(string name) {
    return thrust::raw_pointer_cast(h_columns_int[name].data());
}

void CudaSet::GroupBy(stack<string> columnRef) {
    if (grp.size() < mRecCount)
        grp.resize(mRecCount);
	thrust::fill(grp.begin(), grp.begin()+mRecCount, 0);
	if (scratch.size() < mRecCount)
		scratch.resize(mRecCount*sizeof(bool));
	thrust::device_ptr<bool> d_group((bool*)thrust::raw_pointer_cast(scratch.data()));

    d_group[mRecCount-1] = 1;

    for (int i = 0; i < columnRef.size(); columnRef.pop()) {
		if (ts_cols[columnRef.top()]) {
			queue<string> fields;
			fields.push(columnRef.top());
			copyFinalize(this, fields, 1);
			time_t start_t;
			std::vector<time_t> rcol;

			thrust::device_vector<int_type> unq(mRecCount);
			thrust::copy(d_columns_int[columnRef.top()].begin(), d_columns_int[columnRef.top()].begin() + mRecCount, unq.begin());
			auto result_end = thrust::unique(unq.begin(), unq.end());

			if(unq[0] != 0 || mRecCount == 1) {
				start_t = unq[0]/1000;
			} else {
				start_t = unq[1]/1000;
			}
			time_t end_t = unq[(result_end-unq.begin())-1]/1000;

			LOG(logDEBUG) << "start end " << start_t << " " << end_t;
			//int year_start, year_end, month_start, month_end, day_start, day_end, hour_start, hour_end, minute_start, minute_end, second_start, second_end;
			//struct tm my_tm, my_tm1;
			auto my_tm = *gmtime(&start_t);
			auto my_tm1 = *gmtime(&end_t);

			LOG(logDEBUG) << my_tm.tm_year << " " << my_tm1.tm_year << " " << my_tm.tm_min << " " << my_tm1.tm_min << " " << my_tm.tm_hour << " " << my_tm1.tm_hour;
			rcol.push_back(0);//1970/01/01

			auto pos = grp_val.find("YEAR");
			int grp_num;
			if (pos != string::npos) {
				grp_num = stoi(grp_val.substr(0, pos));
				my_tm.tm_mon = 0;
				my_tm.tm_mday = 1;
				my_tm.tm_hour = 0;
				my_tm.tm_min = 0;
				my_tm.tm_sec = 0;
				start_t = tm_to_time_t_utc(&my_tm);
				rcol.push_back(start_t*1000);
				while (start_t <= end_t) {
					start_t = add_interval(start_t, grp_num, 0, 0, 0, 0, 0);
					rcol.push_back(start_t*1000);
				}
			} else {
				pos = grp_val.find("MONTH");
				int grp_num;
				if (pos != string::npos) {
					grp_num = stoi(grp_val.substr(0, pos));
					my_tm.tm_mday = 1;
					my_tm.tm_hour = 0;
					my_tm.tm_min = 0;
					my_tm.tm_sec = 0;
					start_t = tm_to_time_t_utc(&my_tm);
					LOG(logDEBUG) << "interval " << start_t;
					rcol.push_back(start_t*1000);
					while (start_t <= end_t) {
						start_t = add_interval(start_t, 0, grp_num, 0, 0, 0, 0);
						LOG(logDEBUG) << "interval " << start_t;
						rcol.push_back(start_t*1000);
					}
				} else {
					pos = grp_val.find("DAY");
					int grp_num;
					if (pos != string::npos) {
						grp_num = stoi(grp_val.substr(0, pos));
						my_tm.tm_hour = 0;
						my_tm.tm_min = 0;
						my_tm.tm_sec = 0;
						start_t = tm_to_time_t_utc(&my_tm);
						rcol.push_back(start_t*1000);
						while (start_t <= end_t) {
							start_t = add_interval(start_t, 0, 0, grp_num, 0, 0, 0);
							rcol.push_back(start_t*1000);
						}
					} else {
						pos = grp_val.find("HOUR");
						int grp_num;
						if (pos != string::npos) {
							grp_num = stoi(grp_val.substr(0, pos));
							my_tm.tm_min = 0;
							my_tm.tm_sec = 0;
							start_t = tm_to_time_t_utc(&my_tm);
							rcol.push_back(start_t*1000);
							while (start_t <= end_t) {
								start_t = add_interval(start_t, 0, 0, 0, grp_num, 0, 0);
								rcol.push_back(start_t*1000);
							}
						} else {
							pos = grp_val.find("MINUTE");
							int grp_num;
							if (pos != string::npos) {
								grp_num = stoi(grp_val.substr(0, pos));
								my_tm.tm_sec = 0;
								start_t = tm_to_time_t_utc(&my_tm);
								rcol.push_back(start_t*1000);
								while (start_t <= end_t) {
									start_t = add_interval(start_t, 0, 0, 0, 0, grp_num, 0);
									rcol.push_back(start_t*1000);
								}
							} else {
								pos = grp_val.find("SECOND");
								int grp_num;
								if (pos != string::npos) {
									grp_num = stoi(grp_val.substr(0, pos));
									start_t = tm_to_time_t_utc(&my_tm);
									rcol.push_back(start_t*1000);
									while (start_t <= end_t) {
										start_t = add_interval(start_t, 0, 0, 0, 0, 0, grp_num);
										rcol.push_back(start_t*1000);
									}
								}
							}
						}
					}
				}
			}

			//thrust::device_vector<unsigned int> output(mRecCount);
			rcol_matches.resize(mRecCount);
			rcol_dev.resize(rcol.size());
			thrust::copy(rcol.data(), rcol.data() + rcol.size(), rcol_dev.begin());
			thrust::lower_bound(rcol_dev.begin(), rcol_dev.end(), d_columns_int[columnRef.top()].begin(), d_columns_int[columnRef.top()].begin() + mRecCount, rcol_matches.begin());

			thrust::transform(rcol_matches.begin(), rcol_matches.begin() + mRecCount - 1, rcol_matches.begin()+1, d_group, thrust::not_equal_to<unsigned int>());
			thrust::transform(rcol_matches.begin(), rcol_matches.begin() + mRecCount, rcol_matches.begin(), decrease());
			d_group[mRecCount-1] = 1;
		} else {
			unsigned int bits;
			if (cpy_bits.empty())
				bits = 0;
			else
				bits = cpy_bits[columnRef.top()];

			if (bits == 8) {
				if (type[columnRef.top()] != 1) {  // int_type
					thrust::device_ptr<unsigned char> src((unsigned char*)thrust::raw_pointer_cast(d_columns_int[columnRef.top()].data()));
					thrust::transform(src, src + mRecCount - 1,	src+1, d_group, thrust::not_equal_to<unsigned char>());
				} else {
					thrust::device_ptr<unsigned char> src((unsigned char*)thrust::raw_pointer_cast(d_columns_float[columnRef.top()].data()));
					thrust::transform(src, src + mRecCount - 1,	src+1, d_group, thrust::not_equal_to<unsigned char>());
				}
			} else if (bits == 16) {
				if (type[columnRef.top()] != 1) {  // int_type
					thrust::device_ptr<unsigned short int> src((unsigned short int*)thrust::raw_pointer_cast(d_columns_int[columnRef.top()].data()));
					thrust::transform(src, src + mRecCount - 1,	src+1, d_group, thrust::not_equal_to<unsigned short int>());
				} else {
					thrust::device_ptr<unsigned short int> src((unsigned short int*)thrust::raw_pointer_cast(d_columns_float[columnRef.top()].data()));
					thrust::transform(src, src + mRecCount - 1,	src+1, d_group, thrust::not_equal_to<unsigned short int>());
				}
			} else if (bits == 32) {
				if (type[columnRef.top()] != 1) {  // int_type
					thrust::device_ptr<unsigned int> src((unsigned int*)thrust::raw_pointer_cast(d_columns_int[columnRef.top()].data()));
					thrust::transform(src, src + mRecCount - 1,	src+1, d_group, thrust::not_equal_to<unsigned int>());
				} else {
					thrust::device_ptr<unsigned int> src((unsigned int*)thrust::raw_pointer_cast(d_columns_float[columnRef.top()].data()));
					thrust::transform(src, src + mRecCount - 1,	src+1, d_group, thrust::not_equal_to<unsigned int>());
				}
			} else {
				if (type[columnRef.top()] != 1) {  // int_type
					thrust::transform(d_columns_int[columnRef.top()].begin(), d_columns_int[columnRef.top()].begin() + mRecCount - 1,
						d_columns_int[columnRef.top()].begin()+1, d_group, thrust::not_equal_to<int_type>());
				} else {
					thrust::transform(d_columns_float[columnRef.top()].begin(), d_columns_float[columnRef.top()].begin() + mRecCount - 1,
								  d_columns_float[columnRef.top()].begin()+1, d_group, f_not_equal_to());
				}
			}
		}
        thrust::transform(d_group, d_group+mRecCount, grp.begin(), grp.begin(), thrust::logical_or<bool>());
    }
    grp_count = thrust::count(grp.begin(), grp.begin()+mRecCount, 1);
}

void CudaSet::addDeviceColumn(int_type* col, string colname, size_t recCount) {
    if (std::find(columnNames.begin(), columnNames.end(), colname) == columnNames.end()) {
        columnNames.push_back(colname);
        type[colname] = 0;
        d_columns_int[colname] = thrust::device_vector<int_type>(recCount);
        h_columns_int[colname] = thrust::host_vector<int_type, uninitialized_host_allocator<int_type> >(recCount);
    } else {  // already exists, my need to resize it
        if (d_columns_int[colname].size() < recCount) {
            d_columns_int[colname].resize(recCount);
        }
		if (h_columns_int[colname].size() < recCount) {
            h_columns_int[colname].resize(recCount);
        }
    }
    // copy data to d columns
    thrust::device_ptr<int_type> d_col((int_type*)col);
    thrust::copy(d_col, d_col+recCount, d_columns_int[colname].begin());
	thrust::copy(d_columns_int[colname].begin(), d_columns_int[colname].begin()+recCount, h_columns_int[colname].begin());
}

void CudaSet::addDeviceColumn(float_type* col, string colname, size_t recCount, bool is_decimal) {
    if (std::find(columnNames.begin(), columnNames.end(), colname) == columnNames.end()) {
        columnNames.push_back(colname);
        type[colname] = 1;
        d_columns_float[colname] = thrust::device_vector<float_type>(recCount);
        h_columns_float[colname] = thrust::host_vector<float_type, uninitialized_host_allocator<float_type> >(recCount);
    } else {  // already exists, my need to resize it
        if (d_columns_float[colname].size() < recCount)
            d_columns_float[colname].resize(recCount);
        if (h_columns_float[colname].size() < recCount)
            h_columns_float[colname].resize(recCount);
    }

    decimal[colname] = is_decimal;
    thrust::device_ptr<float_type> d_col((float_type*)col);
    thrust::copy(d_col, d_col+recCount, d_columns_float[colname].begin());
}

void CudaSet::gpu_perm(queue<string> sf, thrust::device_vector<unsigned int>& permutation) {
	permutation.resize(mRecCount);
	thrust::sequence(permutation.begin(), permutation.begin() + mRecCount, 0, 1);
	unsigned int* raw_ptr = thrust::raw_pointer_cast(permutation.data());
	void* temp;

	CUDA_SAFE_CALL(cudaMalloc((void **) &temp, mRecCount*8));
	string sort_type = "ASC";

	while (!sf.empty()) {
		if (type[sf.front()] == 0) {
			update_permutation(d_columns_int[sf.front()], raw_ptr, mRecCount, sort_type, (int_type*)temp, 64);
		} else if (type[sf.front()] == 1) {
			update_permutation(d_columns_float[sf.front()], raw_ptr, mRecCount, sort_type, (float_type*)temp, 64);
		} else {
			thrust::host_vector<unsigned int> permutation_h = permutation;
			char* temp1 = new char[char_size[sf.front()]*mRecCount];
			update_permutation_char_host(h_columns_char[sf.front()], permutation_h.data(), mRecCount, sort_type, temp1, char_size[sf.front()]);
			delete [] temp1;
			permutation = permutation_h;
		}
		sf.pop();
	}
	cudaFree(temp);
}

void CudaSet::compress(string file_name, size_t offset, unsigned int check_type, unsigned int check_val, size_t mCount, const bool append) {
    string str(file_name);
    thrust::device_vector<unsigned int> permutation;
	long long int oldCount;
	bool int_check = 0;

    void* d;
    CUDA_SAFE_CALL(cudaMalloc((void **) &d, mCount*float_size));

    total_count = total_count + mCount;
    if (mCount > total_max && op_sort.empty()) {
        total_max = mCount;
    }

	if (!total_segments && append) {
		string s = file_name + "." + columnNames[0] + ".header";
		iFileSystemHandle* f = file_system->open(s.c_str(), "rb");
		if(f) {
			file_system->read((char *)&oldCount, 8, f);
			file_system->read((char *)&total_segments, 4, f);
			file_system->read((char *)&maxRecs, 4, f);
			if (total_max < maxRecs)
				total_max = maxRecs;
			file_system->close(f);
			total_count = oldCount + mCount;
		}
	}
	string s = file_name + ".interval";
	iFileSystemHandle* f = file_system->open(s.c_str(), "rb");
	if (f) {
    	file_system->seek(f, 0, SEEK_END);
        long length = file_system->tell(f);
        file_system->seek(f, 0, SEEK_SET);
		char* buff = new char[length];
		file_system->read(buff, length, f);
		file_system->close(f);
		char* p = strtok(buff, "|");
		string s1(p);
		p = strtok(NULL, "|");
		string s2(p);
		delete [] buff;

		s = file_name + ".key";
		iFileSystemHandle* f1 = file_system->open(s.c_str(), "rb");
		if (f1) {
			file_system->seek(f1, 0, SEEK_END);
			long length = file_system->tell(f1);
			file_system->seek(f1, 0, SEEK_SET);
			buff = new char[length+1];
			buff[length] = 0;
			file_system->read(buff, length, f1);
			file_system->close(f1);
			string s3(buff);
			delete [] buff;
			load_file_name = file_name;
			calc_intervals(s1, s2, s3, total_segments, append);
			int_check = 1;
		}
	}

    if (!op_sort.empty()) { //sort the segment
		gpu_perm(op_sort, permutation);
    }

    // here we need to check for partitions and if partition_count > 0 -> create partitions
    if (mCount < partition_count || partition_count == 0)
        partition_count = 1;
    unsigned int partition_recs = mCount/partition_count;

    if (!op_sort.empty()) {
        if (total_max < partition_recs)
            total_max = partition_recs;
    }

    total_segments++;
    old_segments = total_segments;
    size_t new_offset;
    for (unsigned int i = 0; i < columnNames.size(); i++) {
		std::clock_t start1 = std::clock();
        string colname = columnNames[i];
        str = file_name + "." + colname;
        curr_file = str;
        str += "." + to_string(total_segments-1);
        new_offset = 0;

        if (type[colname] == 0) {
            thrust::device_ptr<int_type> d_col((int_type*)d);
            if (!op_sort.empty()) {
                thrust::gather(permutation.begin(), permutation.end(), d_columns_int[colname].begin(), d_col);

                for (unsigned int p = 0; p < partition_count; p++) {
                    str = file_name + "." + colname;
                    curr_file = str;
                    str += "." + to_string(total_segments-1);
                    if (p < partition_count - 1) {
                        pfor_compress((int_type*)d + new_offset, partition_recs*int_size, str, h_columns_int[colname], 0);
                    } else {
                        pfor_compress((int_type*)d + new_offset, (mCount - partition_recs*p)*int_size, str, h_columns_int[colname], 0);
                    }
                    new_offset = new_offset + partition_recs;
                    total_segments++;
                }
            } else {
				if(!int_check) {
					thrust::copy(h_columns_int[colname].begin() + offset, h_columns_int[colname].begin() + offset + mCount, d_col);
					pfor_compress(d, mCount*int_size, str, h_columns_int[colname], 0);
				} else {
					pfor_compress(thrust::raw_pointer_cast(d_columns_int[colname].data()), mCount*int_size, str, h_columns_int[colname], 0);
				}
            }
        } else if (type[colname] == 1) {
            if (decimal[colname]) {
                thrust::device_ptr<float_type> d_col((float_type*)d);
                if (!op_sort.empty()) {
                    thrust::gather(permutation.begin(), permutation.end(), d_columns_float[colname].begin(), d_col);
                    thrust::device_ptr<long long int> d_col_dec((long long int*)d);
                    thrust::transform(d_col, d_col+mCount, d_col_dec, float_to_long());

                    for (unsigned int p = 0; p < partition_count; p++) {
                        str = file_name + "." + colname;
                        curr_file = str;
                        str += "." + to_string(total_segments-1);
                        if (p < partition_count - 1)
                            pfor_compress((int_type*)d + new_offset, partition_recs*float_size, str, h_columns_float[colname], 1);
                        else
                            pfor_compress((int_type*)d + new_offset, (mCount - partition_recs*p)*float_size, str, h_columns_float[colname], 1);
                        new_offset = new_offset + partition_recs;
                        total_segments++;
                    }
                } else {
                    thrust::copy(h_columns_float[colname].begin() + offset, h_columns_float[colname].begin() + offset + mCount, d_col);
                    thrust::device_ptr<long long int> d_col_dec((long long int*)d);
                    thrust::transform(d_col, d_col+mCount, d_col_dec, float_to_long());
                    pfor_compress(d, mCount*float_size, str, h_columns_float[colname], 1);
                }
            } else { // do not compress -- float
                thrust::device_ptr<float_type> d_col((float_type*)d);
                if (!op_sort.empty()) {
                    thrust::gather(permutation.begin(), permutation.end(), d_columns_float[colname].begin(), d_col);
                    thrust::copy(d_col, d_col+mRecCount, h_columns_float[colname].begin());
                    for (unsigned int p = 0; p < partition_count; p++) {
                        str = file_name + "." + colname;
                        curr_file = str;
                        str += "." + to_string(total_segments-1);
                        unsigned int curr_cnt;
                        if (p < partition_count - 1)
                            curr_cnt = partition_recs;
                        else
                            curr_cnt = mCount - partition_recs*p;

                        iFileSystemHandle* f = file_system->open(str.c_str(), "ab");
                        file_system->write((char *)&curr_cnt, 4, f);
                        file_system->write((char *)(h_columns_float[colname].data() + new_offset), curr_cnt*float_size, f);
                        new_offset = new_offset + partition_recs;
                        unsigned int comp_type = 3;
                        file_system->write((char *)&comp_type, 4, f);
                        file_system->close(f);
                    }
                } else {
                	iFileSystemHandle* f = file_system->open(str.c_str(), "ab");
                	file_system->write((char *)&mCount, 4, f);
                	file_system->write((char *)(h_columns_float[colname].data() + offset), mCount*float_size, f);
                    unsigned int comp_type = 3;
                    file_system->write((char *)&comp_type, 4, f);
                    file_system->close(f);
                }
            }
        } else { //char
			//populate char_hash
			if (append && total_segments == 1) {
				string s = file_name + "." + colname;
				iFileSystemHandle* f = file_system->open(s.c_str(), "rb");
				if (f) {
					char* strings = new char[oldCount*char_size[colname]];
					file_system->read(strings, oldCount*char_size[colname], f);
					file_system->close(f);
					unsigned int ind = std::find(columnNames.begin(), columnNames.end(), colname) - columnNames.begin();
					for (unsigned int z = 0 ; z < oldCount; z++) {
						char_hash[ind][MurmurHash64A(&strings[z*char_size[colname]], char_size[colname], hash_seed)/2] = z;
					}
					delete [] strings;
				}
			}

            if (!op_sort.empty()) {
                unsigned int*  h_permutation = new unsigned int[mRecCount];
                thrust::copy(permutation.begin(), permutation.end(), h_permutation);
                char* t = new char[char_size[colname]*mRecCount];
                apply_permutation_char_host(h_columns_char[colname], h_permutation, mRecCount, t, char_size[colname]);

                delete [] h_permutation;
                thrust::copy(t, t+ char_size[colname]*mRecCount, h_columns_char[colname]);
                delete [] t;
                for (unsigned int p = 0; p < partition_count; p++) {
                    str = file_name + "." + colname;
                    curr_file = str;
                    str += "." + to_string(total_segments-1);

                    if (p < partition_count - 1)
                        compress_char(str, colname, partition_recs, new_offset, total_segments-1);
                    else
                        compress_char(str, colname, mCount - partition_recs*p, new_offset, total_segments-1);
                    new_offset = new_offset + partition_recs;
                    total_segments++;
                }
            } else {
                compress_char(str, colname, mCount, offset, total_segments-1);
            }
        }

        if ((check_type == 1 && fact_file_loaded) || (check_type == 1 && check_val == 0)) {
            if (!op_sort.empty()) {
                writeHeader(file_name, colname, total_segments-1);
            } else {
                writeHeader(file_name, colname, total_segments);
            }
        }
        total_segments = old_segments;
    }

    cudaFree(d);
    if (!op_sort.empty()) {
        total_segments = (old_segments-1)+partition_count;
    }
    permutation.resize(0);
    permutation.shrink_to_fit();
}

void CudaSet::calc_intervals(string dt1, string dt2, string index, unsigned int total_segs, bool append) {
	alloced_switch = 1;
	not_compressed = 1;
	thrust::device_vector<unsigned int> permutation;
	thrust::device_vector<int_type> stencil(maxRecs);
	thrust::device_vector<int_type> d_dt2(maxRecs);
	thrust::device_vector<int_type> d_index(maxRecs);
	phase_copy = 0;

	queue<string> sf;
	sf.push(dt1);
	sf.push(index);
	gpu_perm(sf, permutation);

	for (unsigned int i = 0; i < columnNames.size(); i++) {
		if (type[columnNames[i]] == 0) {
			apply_permutation(d_columns_int[columnNames[i]], thrust::raw_pointer_cast(permutation.data()), mRecCount, (int_type*)thrust::raw_pointer_cast(stencil.data()), 0);
		} else {
			unsigned int*  h_permutation = new unsigned int[mRecCount];
			thrust::copy(permutation.begin(), permutation.end(), h_permutation);
			char* t = new char[char_size[columnNames[i]]*mRecCount];
			apply_permutation_char_host(h_columns_char[columnNames[i]], h_permutation, mRecCount, t, char_size[columnNames[i]]);
			delete [] h_permutation;
			thrust::copy(t, t+ char_size[columnNames[i]]*mRecCount, h_columns_char[columnNames[i]]);
			delete [] t;
		}
    }

	if (type[index] == 2) {
		d_columns_int[index] = thrust::device_vector<int_type>(mRecCount);
		h_columns_int[index] = thrust::host_vector<int_type>(mRecCount);
		for (int i = 0; i < mRecCount; i++)
			h_columns_int[index][i] = MurmurHash64A(&h_columns_char[index][i*char_size[index]], char_size[index], hash_seed)/2;
		d_columns_int[index] = h_columns_int[index];
    }

	thrust::counting_iterator<unsigned int> begin(0);
	gpu_interval ff(thrust::raw_pointer_cast(d_columns_int[dt1].data()), thrust::raw_pointer_cast(d_columns_int[dt2].data()), thrust::raw_pointer_cast(d_columns_int[index].data()));
	thrust::for_each(begin, begin + mRecCount - 1, ff);

	auto stack_count = mRecCount;

	if (append) {
		not_compressed = 0;
		size_t mysz = 8;
		if (char_size[index] > int_size)
			mysz = char_size[index];

		if (mysz*maxRecs > alloced_sz) {
			if(alloced_sz) {
				cudaFree(alloced_tmp);
			}
			cudaMalloc((void **) &alloced_tmp, mysz*maxRecs);
			alloced_sz = mysz*maxRecs;
		}
		thrust::device_ptr<int_type> d_col((int_type*)alloced_tmp);
		d_columns_int[dt2].resize(0);

		thrust::device_vector<unsigned int> output(stack_count);
		for (int i = 0; i < total_segments; i++) {
			CopyColumnToGpu(dt2, i, 0);
			if (thrust::count(d_col, d_col+mRecCount, 0)) {
				thrust::copy(d_col, d_col+mRecCount, d_dt2.begin());

				if (type[index] == 2) {
					string f1 = load_file_name + "." + index + "." + to_string(i) + ".hash";
					iFileSystemHandle* f = file_system->open(f1.c_str(), "rb");
					unsigned int cnt;
					file_system->read(&cnt, 4, f);
					unsigned long long int* buff = new unsigned long long int[cnt];
					file_system->read(buff, cnt*8, f);
					file_system->close(f);
					thrust::copy(buff, buff + cnt, d_index.begin());
					delete [] buff;
				} else {
					CopyColumnToGpu(index, i, 0);
					thrust::copy(d_col, d_col+mRecCount, d_index.begin());
				}

				thrust::lower_bound(d_columns_int[index].begin(), d_columns_int[index].begin()+stack_count, d_index.begin(), d_index.begin() + mRecCount, output.begin());

				gpu_interval_set f(thrust::raw_pointer_cast(d_columns_int[dt1].data()), thrust::raw_pointer_cast(d_dt2.data()),
														 thrust::raw_pointer_cast(d_index.data()), thrust::raw_pointer_cast(d_columns_int[index].data()),
														 thrust::raw_pointer_cast(output.data()));
				thrust::for_each(begin, begin + mRecCount, f);

				string str = load_file_name + "." + dt2 + "." + to_string(i);;
				pfor_compress(thrust::raw_pointer_cast(d_dt2.data()), mRecCount*int_size, str, h_columns_int[dt2], 0);
			}
		}
	}
}

void CudaSet::writeHeader(string file_name, string colname, unsigned int tot_segs) {
    string str = file_name + "." + colname;
    string ff = str;
    str += ".header";
    iFileSystemHandle* f = file_system->open(str.c_str(), "wb");
    file_system->write((char *)&total_count, 8, f);
    file_system->write((char *)&tot_segs, 4, f);
    file_system->write((char *)&total_max, 4, f);
    file_system->write((char *)&cnt_counts[ff], 4, f);
	LOG(logDEBUG) << "HEADER1 " << total_count << " " << tot_segs << " " << total_max;
	file_system->close(f);
}

void CudaSet::reWriteHeader(string file_name, string colname, unsigned int tot_segs, size_t newRecs, size_t maxRecs1) {
    string str = file_name + "." + colname;
    string ff = str;
    str += ".header";
    iFileSystemHandle* f = file_system->open(str.c_str(), "wb");
    file_system->write((char *)&newRecs, 8, f);
    file_system->write((char *)&tot_segs, 4, f);
    file_system->write((char *)&maxRecs1, 4, f);
    LOG(logDEBUG) << "HEADER2 " << newRecs;
    file_system->close(f);
}

void CudaSet::writeSortHeader(string file_name) {
    string str(file_name);
    unsigned int idx;

    if (!op_sort.empty()) {
        str += ".sort";
        iFileSystemHandle* f = file_system->open(str.c_str(), "wb");
        idx = (unsigned int)op_sort.size();
        file_system->write((char *)&idx, 4, f);
        queue<string> os(op_sort);
        while (!os.empty()) {
            if (verbose)
            	LOG(logDEBUG) << "sorted on " << idx;
            idx = os.front().size();
            file_system->write((char *)&idx, 4, f);
            file_system->write(os.front().data(), idx, f);
            os.pop();
        }
        file_system->close(f);
    } else {
        str += ".sort";
        file_system->remove(str.c_str());
    }

	str = file_name;
    if (!op_presort.empty()) {
        str += ".presort";
        iFileSystemHandle* f = file_system->open(str.c_str(), "wb");
        idx = (unsigned int)op_presort.size();
        file_system->write((char *)&idx, 4, f);
        queue<string> os(op_presort);
        while (!os.empty()) {
            idx = os.front().size();
            file_system->write((char *)&idx, 4, f);
            file_system->write(os.front().data(), idx, f);
            os.pop();
        }
        file_system->close(f);
    } else {
        str += ".presort";
        file_system->remove(str.c_str());
    }
}

void CudaSet::Display(unsigned int limit, bool binary, bool term) {
#define MAXCOLS 128
#define MAXFIELDSIZE 1400

    //-- This should/will be converted to an array holding pointers of malloced sized structures--
    char bigbuf[MAXCOLS * MAXFIELDSIZE];
    memset(bigbuf, 0, MAXCOLS * MAXFIELDSIZE);
    char *fields[MAXCOLS];
    const char *dcolumns[MAXCOLS];
    size_t  mCount;         // num records in play
    bool print_all = 0;
    string ss, str;
    int rows = 0;

    if (limit != 0 && limit < mRecCount) {
        mCount = limit;
    } else {
        mCount = mRecCount;
        print_all = 1;
    }

    LOG(logDEBUG) << "mRecCount=" << mRecCount << " mcount = " << mCount << " term " << term <<  " limit=" << limit << " print_all=" << print_all;

    unsigned int cc = 0;
    unordered_map<string, iFileSystemHandle*> file_map;
    unordered_map<string, unsigned int> len_map;

    for (unsigned int i = 0; i < columnNames.size(); i++) {
        fields[cc] = &(bigbuf[cc*MAXFIELDSIZE]);                        // a hack to avoid malloc overheads     - refine later
        dcolumns[cc++] = columnNames[i].c_str();

		if (string_map.find(columnNames[i]) != string_map.end()) {
			auto s = string_map[columnNames[i]];
			auto pos = s.find_first_of(".");
			auto len = data_dict->get_column_length(s.substr(0, pos), s.substr(pos+1));
			iFileSystemHandle* f = file_system->open(string_map[columnNames[i]].c_str(), "rb");
			file_map[string_map[columnNames[i]]] = f;
			len_map[string_map[columnNames[i]]] = len;
		}
    }

    // The goal here is to loop fast and avoid any double handling of outgoing data - pointers are good.
    if (not_compressed && prm_d.size() == 0) {
        for (unsigned int i=0; i < mCount; i++) {                            // for each record
            for (unsigned int j=0; j < columnNames.size(); j++) {                // for each col
                if (type[columnNames[j]] != 1) {
                    if (string_map.find(columnNames[j]) == string_map.end()) {
						if (decimal_zeroes[columnNames[j]]) {
							str = std::to_string(h_columns_int[columnNames[j]][i]);
							LOG(logDEBUG) << "decimals " << columnNames[j] << " " << decimal_zeroes[columnNames[j]] << " " << h_columns_int[columnNames[j]][i];
							while(str.length() <= decimal_zeroes[columnNames[j]])
								str = '0' + str;
							str.insert(str.length()- decimal_zeroes[columnNames[j]], ".");
							sprintf(fields[j], "%s", str.c_str());
						} else {
							if (!ts_cols[columnNames[j]]) {
								sprintf(fields[j], "%lld", (h_columns_int[columnNames[j]])[i] );
							} else {
								time_t ts = (h_columns_int[columnNames[j]][i])/1000;
								auto ti = gmtime(&ts);
								char buffer[30];
								auto rem = (h_columns_int[columnNames[j]][i])%1000;
								strftime(buffer, 30, "%Y-%m-%d %H.%M.%S", ti);
								//fprintf(file_pr, "%s", buffer);
								//fprintf(file_pr, ".%d", rem);
								sprintf(fields[j], "%s.%d", buffer, rem);

								/*time_t tt = h_columns_int[columnNames[j]][i];
								auto ti = localtime(&tt);
								char buffer[10];
								strftime(buffer,80,"%Y-%m-%d", ti);
								sprintf(fields[j], "%s", buffer);
								*/
							}
						}
					} else {
                        file_system->seek(file_map[string_map[columnNames[j]]], h_columns_int[columnNames[j]][i] * len_map[string_map[columnNames[j]]], SEEK_SET);
                        file_system->read(fields[j], len_map[string_map[columnNames[j]]], file_map[string_map[columnNames[j]]]);
                        fields[j][len_map[string_map[columnNames[j]]]] ='\0'; // zero terminate string
                    }
                } else {
                    sprintf(fields[j], "%.2f", (h_columns_float[columnNames[j]])[i]);
                }
            }
            row_cb(mColumnCount, (char **)fields, (char **)dcolumns);
            rows++;
        }
    } else {
        queue<string> op_vx;
        for (unsigned int i = 0; i < columnNames.size(); i++)
            op_vx.push(columnNames[i]);

        if (prm_d.size() || source) {
            allocColumns(this, op_vx);
        }
        unsigned int curr_seg = 0;
        size_t cnt = 0;
        size_t curr_count, sum_printed = 0;
        resize(maxRecs);
        while (sum_printed < mCount || print_all) {
            if (prm_d.size() || source)  {                            // if host arrays are empty
                copyColumns(this, op_vx, curr_seg, cnt);
                size_t olRecs = mRecCount;
                mRecCount = olRecs;
                CopyToHost(0, mRecCount);
                if (sum_printed + mRecCount <= mCount || print_all)
                    curr_count = mRecCount;
                else
                    curr_count = mCount - sum_printed;
            } else {
                curr_count = mCount;
            }

            sum_printed = sum_printed + mRecCount;
            for (unsigned int i=0; i < curr_count; i++) {
                for (unsigned int j=0; j < columnNames.size(); j++) {
                    if (type[columnNames[j]] != 1) {
                        if (string_map.find(columnNames[j]) == string_map.end()) {
                            sprintf(fields[j], "%lld", (h_columns_int[columnNames[j]])[i] );
                        } else {
							file_system->seek(file_map[string_map[columnNames[j]]], h_columns_int[columnNames[j]][i] * len_map[string_map[columnNames[j]]], SEEK_SET);
							file_system->read(fields[j], len_map[string_map[columnNames[j]]], file_map[string_map[columnNames[j]]]);
							fields[j][len_map[string_map[columnNames[j]]]] ='\0'; // zero terminate string
                        }
                    } else {
                        sprintf(fields[j], "%.2f", (h_columns_float[columnNames[j]])[i] );
                    }
                }
                row_cb(mColumnCount, (char **)fields, (char**)dcolumns);
                rows++;
            }
            curr_seg++;
            if (curr_seg == segCount)
                print_all = 0;
        }
    }      // end else
    for (auto it = file_map.begin(); it != file_map.end(); it++)
    	file_system->close(it->second);
}

void CudaSet::Store(const string file_name, const char* sep, const unsigned int limit, const bool binary, const bool append, const bool term) {
    if (mRecCount == 0 && binary == 1 && !term) { // write tails
        for (unsigned int j=0; j < columnNames.size(); j++) {
            writeHeader(file_name, columnNames[j], total_segments);
        }
        return;
    }

    size_t mCount;
    bool print_all = 0;
	string str;

    if (limit != 0 && limit < mRecCount) {
        mCount = limit;
    } else {
        mCount = mRecCount;
        print_all = 1;
    }

    if (binary == 0) {
        unordered_map<string, iFileSystemHandle*> file_map;
        unordered_map<string, unsigned int> len_map;
        string bf;
        unsigned int max_len = 0;
        for (unsigned int j=0; j < columnNames.size(); j++) {
            if (string_map.find(columnNames[j]) != string_map.end()) {
                auto s = string_map[columnNames[j]];
                auto pos = s.find_first_of(".");
                auto len = data_dict->get_column_length(s.substr(0, pos), s.substr(pos+1));
                if (len > max_len)
                    max_len = len;

                iFileSystemHandle* f = file_system->open(string_map[columnNames[j]].c_str(), "rb");
                file_map[string_map[columnNames[j]]] = f;
                len_map[string_map[columnNames[j]]] = len;
            }
        }
        bf.reserve(max_len);
        iFileSystemHandle* file_pr;
        if (!term) {
        	file_pr = file_system->open(file_name.c_str(), "w");
            if (!file_pr)
            	LOG(logERROR) << "Could not open file " << file_name;
        } else {
            //file_pr = stdout; TODO Fix
        }

        if (not_compressed && prm_d.size() == 0) {
            for (unsigned int i=0; i < mCount; i++) {
                for (unsigned int j=0; j < columnNames.size(); j++) {
                    if (type[columnNames[j]] != 1) {
                        if (string_map.find(columnNames[j]) == string_map.end()) {
							if (decimal_zeroes[columnNames[j]]) {
								str = std::to_string(h_columns_int[columnNames[j]][i]);
								LOG(logDEBUG) << "decimals " << columnNames[j] << " " << decimal_zeroes[columnNames[j]] << " " << h_columns_int[columnNames[j]][i];
								while (str.length() <= decimal_zeroes[columnNames[j]])
									str = '0' + str;
								str.insert(str.length()- decimal_zeroes[columnNames[j]], ".");
								file_system->printf(file_pr, "%s", str.c_str());
							} else {
								if (!ts_cols[columnNames[j]]) {
									file_system->printf(file_pr, "%lld", (h_columns_int[columnNames[j]])[i]);
								} else {
									time_t ts = (h_columns_int[columnNames[j]][i])/1000;
									auto ti = gmtime(&ts);
									char buffer[30];
									auto rem = (h_columns_int[columnNames[j]][i])%1000;
									strftime(buffer, 30, "%Y-%m-%d %H.%M.%S", ti);
									file_system->printf(file_pr, "%s", buffer);
									file_system->printf(file_pr, ".%d", rem);
								}
							}
						} else {
                            //fprintf(file_pr, "%.*s", string_hash[columnNames[j]][h_columns_int[columnNames[j]][i]].size(), string_hash[columnNames[j]][h_columns_int[columnNames[j]][i]].c_str());
							file_system->seek(file_map[string_map[columnNames[j]]], h_columns_int[columnNames[j]][i] * len_map[string_map[columnNames[j]]], SEEK_SET);
							file_system->read(&bf[0], len_map[string_map[columnNames[j]]], file_map[string_map[columnNames[j]]]);
							file_system->printf(file_pr, "%.*s", len_map[string_map[columnNames[j]]], bf.c_str());
                        }
                        file_system->puts(sep, file_pr);
                    } else {
                    	file_system->printf(file_pr, "%.2f", (h_columns_float[columnNames[j]])[i]);
                        file_system->puts(sep, file_pr);
                    }
                }
                if (i != mCount -1 )
                	file_system->puts("\n", file_pr);
            }
            if (!term)
                file_system->close(file_pr);
        } else {
		    queue<string> op_vx;
            string ss;
            for (unsigned int j=0; j < columnNames.size(); j++)
                op_vx.push(columnNames[j]);

            if (prm_d.size() || source) {
                allocColumns(this, op_vx);
            }

            unsigned int curr_seg = 0;
            size_t cnt = 0;
            size_t curr_count, sum_printed = 0;
            mRecCount = 0;
            resize(maxRecs);

            while (sum_printed < mCount || print_all) {
                if (prm_d.size() || source)  {
                    copyColumns(this, op_vx, curr_seg, cnt);
                    if (curr_seg == 0) {
                        if (limit != 0 && limit < mRecCount) {
                            mCount = limit;
                            print_all = 0;
                        } else {
                            mCount = mRecCount;
                            print_all = 1;
                        }
                    }

                    // if host arrays are empty
                    size_t olRecs = mRecCount;
                    mRecCount = olRecs;
                    CopyToHost(0, mRecCount);
                    LOG(logDEBUG) << "start " << sum_printed << " " <<  mRecCount << " " <<  mCount;
                    if (sum_printed + mRecCount <= mCount || print_all) {
                        curr_count = mRecCount;
                    } else {
                        curr_count = mCount - sum_printed;
                    }
                } else {
                    curr_count = mCount;
                }

                sum_printed = sum_printed + mRecCount;
                LOG(logDEBUG) << "sum printed " << sum_printed << " " << curr_count << " " << curr_seg;

                for (unsigned int i=0; i < curr_count; i++) {
                    for (unsigned int j=0; j < columnNames.size(); j++) {
                        if (type[columnNames[j]] != 1) {
                            if (string_map.find(columnNames[j]) == string_map.end()) {
								if (decimal_zeroes[columnNames[j]]) {
									str = std::to_string(h_columns_int[columnNames[j]][i]);
									LOG(logDEBUG) << "decimals " << columnNames[j] << " " << decimal_zeroes[columnNames[j]] << " " << h_columns_int[columnNames[j]][i];
									while (str.length() <= decimal_zeroes[columnNames[j]])
										str = '0' + str;
									str.insert(str.length()- decimal_zeroes[columnNames[j]], ".");
									file_system->printf(file_pr, "%s", str.c_str());
								} else {
									if (!ts_cols[columnNames[j]]) {
										file_system->printf(file_pr, "%lld", (h_columns_int[columnNames[j]])[i]);
									} else {
										time_t ts = (h_columns_int[columnNames[j]][i])/1000;
										auto ti = gmtime(&ts);
										char buffer[30];
										auto rem = (h_columns_int[columnNames[j]][i])%1000;
										strftime(buffer, 30, "%Y-%m-%d %H.%M.%S", ti);
										file_system->printf(file_pr, "%s", buffer);
										file_system->printf(file_pr, ".%d", rem);
									}
								}

							} else {
								file_system->seek(file_map[string_map[columnNames[j]]], h_columns_int[columnNames[j]][i] * len_map[string_map[columnNames[j]]], SEEK_SET);
                                file_system->read(&bf[0], len_map[string_map[columnNames[j]]], file_map[string_map[columnNames[j]]]);
                                file_system->printf(file_pr, "%.*s", len_map[string_map[columnNames[j]]], bf.c_str());
                            }
                            file_system->puts(sep, file_pr);
                        } else  {
                        	file_system->printf(file_pr, "%.2f", (h_columns_float[columnNames[j]])[i]);
                            file_system->puts(sep, file_pr);
                        }
                    }
                    if (i != mCount -1 && (curr_seg != segCount || i < curr_count))
                    	file_system->puts("\n", file_pr);
                }
                curr_seg++;
                if (curr_seg == segCount)
                    print_all = 0;
            }
            if (!term) {
            	file_system->close(file_pr);
            }
        }
		for (auto it = file_map.begin(); it != file_map.end(); it++)
			file_system->close(it->second);
    } else {
        //lets update the data dictionary
        for (unsigned int j=0; j < columnNames.size(); j++) {

        	data_dict->set_column_type(file_name, columnNames[j], type[columnNames[j]]);
            if (type[columnNames[j]] != 2) {
				if(decimal[columnNames[j]])
					data_dict->set_column_length(file_name, columnNames[j], decimal_zeroes[columnNames[j]]);
				else if (ts_cols[columnNames[j]])
					data_dict->set_column_length(file_name, columnNames[j], UINT_MAX);
				else
					data_dict->set_column_length(file_name, columnNames[j], 0);
			} else {
				data_dict->set_column_length(file_name, columnNames[j], char_size[columnNames[j]]);
			}
        }
        save_dict = 1;

        if (text_source) {  //writing a binary file using a text file as a source
            compress(file_name, 0, 1, 0, mCount, append);
            for (unsigned int i = 0; i< columnNames.size(); i++)
                if (type[columnNames[i]] == 2)
                    deAllocColumnOnDevice(columnNames[i]);
        } else { //writing a binary file using a binary file as a source
            fact_file_loaded = 1;
            size_t offset = 0;

            if (!not_compressed) { // records are compressed, for example after filter op.
                //decompress to host
                queue<string> op_vx;
                for (unsigned int i = 0; i< columnNames.size(); i++) {
                    op_vx.push(columnNames[i]);
                }

                allocColumns(this, op_vx);
                size_t oldCnt = mRecCount;
                mRecCount = 0;
                resize(oldCnt);
                mRecCount = oldCnt;
                for (unsigned int i = 0; i < segCount; i++) {
                    size_t cnt = 0;
                    copyColumns(this, op_vx, i, cnt);
                    CopyToHost(0, mRecCount);
                    offset = offset + mRecCount;
                    compress(file_name, 0, 0, i - (segCount-1), mRecCount, append);
                }
            } else {
                // now we have decompressed records on the host
                //call setSegments and compress columns in every segment

                segCount = (mRecCount/process_count + 1);
                offset = 0;

                for (unsigned int z = 0; z < segCount; z++) {
                    if (z < segCount-1) {
                        if (mRecCount < process_count) {
                            mCount = mRecCount;
                        } else {
                            mCount = process_count;
                        }
                    } else {
                        mCount = mRecCount - (segCount-1)*process_count;
                    }
                    compress(file_name, offset, 0, z - (segCount-1), mCount, append);
                    offset = offset + mCount;
                }
            }
        }
    }
}


void CudaSet::compress_char(const string file_name, const string colname, const size_t mCount, const size_t offset, const unsigned int segment) {
    unsigned int len = char_size[colname];

    string h_name, i_name, file_no_seg = file_name.substr(0, file_name.find_last_of("."));
    i_name = file_no_seg + "." + to_string(segment) + ".idx";
    h_name = file_no_seg + "." + to_string(segment) + ".hash";
    iFileSystemHandle* b_file;

    iFileSystemHandle* file_h = file_system->open(h_name.c_str(), "wb");
    file_system->write((char *)&mCount, 4, file_h);

	if (segment == 0) {
		b_file = file_system->open(file_no_seg.c_str(), "wb"); //truncate binary
    } else {
    	b_file = file_system->open(file_no_seg.c_str(), "ab"); //append binary
    }

	if (h_columns_int.find(colname) == h_columns_int.end()) {
        h_columns_int[colname] = thrust::host_vector<int_type >(mCount);
	} else {
		if(h_columns_int[colname].size() < mCount)
			h_columns_int[colname].resize(mCount);
	}
    if (d_columns_int.find(colname) == d_columns_int.end()) {
        d_columns_int[colname] = thrust::device_vector<int_type >(mCount);
	} else {
		if (d_columns_int[colname].size() < mCount)
			d_columns_int[colname].resize(mCount);
	}

	size_t  cnt;
	long long int* hash_array = new long long int[mCount];
	map<unsigned long long int, size_t>::iterator iter;
	unsigned int ind = std::find(columnNames.begin(), columnNames.end(), colname) - columnNames.begin();

	for (unsigned int i = 0 ; i < mCount; i++) {
		hash_array[i] = MurmurHash64A(h_columns_char[colname] + (i+offset)*len, len, hash_seed)/2;
		iter = char_hash[ind].find(hash_array[i]);
		if (iter == char_hash[ind].end()) {
			cnt = char_hash[ind].size();
			char_hash[ind][hash_array[i]] = cnt;
			file_system->write((char *)h_columns_char[colname] + (i+offset)*len, len, b_file);
			h_columns_int[colname][i] = cnt;
		} else {
			h_columns_int[colname][i] = iter->second;
		}
	}

	file_system->write((char *)hash_array, 8*mCount, file_h);
	delete [] hash_array;

    thrust::device_vector<int_type> d_col(mCount);
    thrust::copy(h_columns_int[colname].begin(), h_columns_int[colname].begin() + mCount, d_col.begin());
    pfor_compress(thrust::raw_pointer_cast(d_col.data()), mCount*int_size, i_name, h_columns_int[colname], 0);
    file_system->close(file_h);
    file_system->close(b_file);
}

bool first_time = 1;
size_t rec_sz = 0;
size_t process_piece;

bool CudaSet::LoadBigFile(iFileSystemHandle* file_p, thrust::device_vector<char>& d_readbuff, thrust::device_vector<char*>& dest,
							thrust::device_vector<unsigned int>& ind, thrust::device_vector<unsigned int>& dest_len) {
    const char* sep = separator.c_str();
    unsigned int maxx = cols.rbegin()->first;
	map<unsigned int, string>::iterator it;
	bool done = 0;
	std::clock_t start1 = std::clock();

	vector<int> types;
	vector<int> cl;
	types.push_back(0);
	for(int i = 0; i < maxx; i++) {
		auto iter = cols.find(i+1);
		if(iter != cols.end()) {
			types.push_back(type[iter->second]);
			cl.push_back(iter->first-1);
		} else {
			types.push_back(0);
		}
	}

	if (first_time) {
		if(process_count*4 > getFreeMem()) {
			process_piece = getFreeMem()/4;
		} else {
			process_piece = process_count;
		}
		readbuff = new char[process_piece+1];
		d_readbuff.resize(process_piece+1);
		LOG(logDEBUG) << "set a piece to " << process_piece << " " << getFreeMem();
	}

	thrust::device_vector<unsigned int> ind_cnt(1);
	thrust::device_vector<char> sepp(1);
	sepp[0] = *sep;

	long long int total_processed = 0;
	size_t recs_processed = 0;
	bool finished = 0;
	thrust::device_vector<long long int> dev_pos;
	long long int offset;
	unsigned int cnt = 1;
	const unsigned int max_len = 23;

	while (!done) {
		auto rb = file_system->read(readbuff, process_piece, file_p);

		if (readbuff[rb-1] != '\n') {
			rb++;
			readbuff[rb-1] = '\n';
		}

		if (rb < process_piece) {
			done = 1;
			finished = 1;
			file_system->close(file_p);
		}
		if (total_processed >= process_count)
			done = 1;

		thrust::fill(d_readbuff.begin(), d_readbuff.end(), 0);
		thrust::copy(readbuff, readbuff+rb, d_readbuff.begin());

		auto curr_cnt = thrust::count(d_readbuff.begin(), d_readbuff.begin() + rb, '\n') - 1;

		if (recs_processed == 0 && first_time) {
			rec_sz = curr_cnt;
			if(finished)
				rec_sz++;
			total_max = curr_cnt;
		}

		LOG(logDEBUG) << "curr_cnt " << curr_cnt << " Memory: " << getFreeMem();

		if (first_time) {
			for (unsigned int i=0; i < columnNames.size(); i++) {
				auto colname = columnNames[i];
				if (type[colname] == 0) {
					d_columns_int[colname].resize(d_columns_int[colname].size() + rec_sz);
					h_columns_int[colname].resize(h_columns_int[colname].size() + rec_sz);
				} else if (type[colname] == 1) {
					d_columns_float[colname].resize(d_columns_float[colname].size() + rec_sz);
					h_columns_float[colname].resize(h_columns_float[colname].size() + rec_sz);
				} else {
					char* c = new char[cnt*rec_sz*char_size[columnNames[i]]];
					if(recs_processed > 0) {
						memcpy(c, h_columns_char[columnNames[i]], recs_processed*char_size[columnNames[i]]);
						delete [] h_columns_char[columnNames[i]];
					}
					h_columns_char[columnNames[i]] = c;
					if (recs_processed == 0) {
						void* temp;
						CUDA_SAFE_CALL(cudaMalloc((void **) &temp, char_size[columnNames[i]]*rec_sz));
						cudaMemset(temp, 0, char_size[columnNames[i]]*rec_sz);
						d_columns_char[columnNames[i]] = (char*)temp;
					}
				}

				if (recs_processed == 0) {
					ind[i] = cl[i];
					void* temp;
					if (type[columnNames[i]] != 2) {
						if(!ts_cols[columnNames[i]]) {
							CUDA_SAFE_CALL(cudaMalloc((void **) &temp, max_len*rec_sz));
							dest_len[i] = max_len;
						} else {
							CUDA_SAFE_CALL(cudaMalloc((void **) &temp, 23*rec_sz));
							dest_len[i] = 23;
						}
					} else {
						CUDA_SAFE_CALL(cudaMalloc((void **) &temp, char_size[columnNames[i]]*rec_sz));
						dest_len[i] = char_size[columnNames[i]];
					}
					dest[i] = (char*)temp;
				}
			}
		}

		for (unsigned int i=0; i < columnNames.size(); i++) {
			if(type[columnNames[i]] != 2) {
				cudaMemset(dest[i], 0, max_len*rec_sz);
			} else {
				cudaMemset(dest[i], 0, char_size[columnNames[i]]*rec_sz);
			}
		}

		if (dev_pos.size() < curr_cnt+1)
			dev_pos.resize(curr_cnt+1);	//avoiding the unnecessary allocs
		dev_pos[0] = -1;
		thrust::copy_if(thrust::make_counting_iterator((unsigned long long int)0), thrust::make_counting_iterator((unsigned long long int)rb-1),
						d_readbuff.begin(), dev_pos.begin()+1, _1 == '\n');

		if (!finished) {
			if (curr_cnt < rec_sz) {
				offset = (dev_pos[curr_cnt] - rb)+1;
				LOG(logDEBUG) << "PATH 1 " << dev_pos[curr_cnt] << " " << offset;
				file_system->seek(file_p, offset, SEEK_CUR);
				total_processed = total_processed + rb + offset;
				mRecCount = curr_cnt;
			} else {
				offset = (dev_pos[rec_sz] - rb)+1;
				LOG(logDEBUG) << "PATH 2 " << dev_pos[rec_sz] << " " << offset;
				file_system->seek(file_p, offset, SEEK_CUR);
				total_processed = total_processed + rb + offset;
				mRecCount = rec_sz;
			}
		} else {
			mRecCount = curr_cnt + 1;
		}

		thrust::counting_iterator<unsigned int> begin(0);
		ind_cnt[0] = mColumnCount;
		parse_functor ff((const char*)thrust::raw_pointer_cast(d_readbuff.data()), (char**)thrust::raw_pointer_cast(dest.data()), thrust::raw_pointer_cast(ind.data()),
						thrust::raw_pointer_cast(ind_cnt.data()), thrust::raw_pointer_cast(sepp.data()), thrust::raw_pointer_cast(dev_pos.data()), thrust::raw_pointer_cast(dest_len.data()));
		thrust::for_each(begin, begin + mRecCount, ff);

		ind_cnt[0] = max_len;
		for (int i =0; i < mColumnCount; i++) {
			if (type[columnNames[i]] == 0) {  //int
				thrust::device_ptr<char> p1((char*)dest[i]);
				if (p1[4] == '-') { //date
					if(!ts_cols[columnNames[i]]) {
						gpu_date date_ff((const char*)dest[i], (long long int*)thrust::raw_pointer_cast(d_columns_int[columnNames[i]].data()) + recs_processed);
						thrust::for_each(begin, begin + mRecCount, date_ff);
					} else {
						gpu_tdate date_ff((const char*)dest[i], (long long int*)thrust::raw_pointer_cast(d_columns_int[columnNames[i]].data()) + recs_processed);
						thrust::for_each(begin, begin + mRecCount, date_ff);
					}
				} else { //int
					if (decimal[columnNames[i]]) {
						thrust::device_vector<unsigned int> scale(1);
						scale[0] =  decimal_zeroes[columnNames[i]];
						gpu_atold atold((const char*)dest[i], (long long int*)thrust::raw_pointer_cast(d_columns_int[columnNames[i]].data()) + recs_processed,
											thrust::raw_pointer_cast(ind_cnt.data()), thrust::raw_pointer_cast(scale.data()));
						thrust::for_each(begin, begin + mRecCount, atold);
					} else {
						gpu_atoll atoll_ff((const char*)dest[i], (long long int*)thrust::raw_pointer_cast(d_columns_int[columnNames[i]].data()) + recs_processed, thrust::raw_pointer_cast(ind_cnt.data()));
						thrust::for_each(begin, begin + mRecCount, atoll_ff);
					}
				}
				thrust::copy(d_columns_int[columnNames[i]].begin() + recs_processed, d_columns_int[columnNames[i]].begin()+recs_processed+mRecCount, h_columns_int[columnNames[i]].begin() + recs_processed);
			} else if (type[columnNames[i]] == 1) {
				gpu_atof atof_ff((const char*)dest[i], (double*)thrust::raw_pointer_cast(d_columns_float[columnNames[i]].data()) + recs_processed, thrust::raw_pointer_cast(ind_cnt.data()));
				thrust::for_each(begin, begin + mRecCount, atof_ff);
				thrust::copy(d_columns_float[columnNames[i]].begin() + recs_processed, d_columns_float[columnNames[i]].begin()+recs_processed+mRecCount, h_columns_float[columnNames[i]].begin() + recs_processed);
			} else {//char is already done
				thrust::device_ptr<char> p1((char*)dest[i]);
				cudaMemcpy(h_columns_char[columnNames[i]] + char_size[columnNames[i]]*recs_processed, (void *)dest[i] , char_size[columnNames[i]]*mRecCount, cudaMemcpyDeviceToHost);
			}
		}
		recs_processed = recs_processed + mRecCount;
		cnt++;
	}

	if (finished) {
		for (int i =0; i < mColumnCount; i++) {
			if (dest[i]) {
				cudaFree(dest[i]);
				dest[i] = nullptr;
			}
		}
		delete [] readbuff;
	}
	LOG(logDEBUG) << "processed recs " << recs_processed << " " << getFreeMem();
	first_time = 0;
	mRecCount = recs_processed;
	return finished;
}

void CudaSet::free() {
    for (unsigned int i = 0; i < columnNames.size(); i++) {
		if (type[columnNames[i]] == 0 && h_columns_int[columnNames[i]].size()) {
			h_columns_int[columnNames[i]].resize(0);
			h_columns_int[columnNames[i]].shrink_to_fit();
		} else {
			h_columns_float[columnNames[i]].resize(0);
			h_columns_float[columnNames[i]].shrink_to_fit();
		}
    }
	if (prm_d.size()) {
		prm_d.resize(0);
		prm_d.shrink_to_fit();
	}
    deAllocOnDevice();
}

bool* CudaSet::logical_and(bool* column1, bool* column2) {
    thrust::device_ptr<bool> dev_ptr1(column1);
    thrust::device_ptr<bool> dev_ptr2(column2);

    thrust::transform(dev_ptr1, dev_ptr1+mRecCount, dev_ptr2, dev_ptr1, thrust::logical_and<bool>());
    thrust::device_free(dev_ptr2);
    return column1;
}

bool* CudaSet::logical_or(bool* column1, bool* column2) {
    thrust::device_ptr<bool> dev_ptr1(column1);
    thrust::device_ptr<bool> dev_ptr2(column2);

    thrust::transform(dev_ptr1, dev_ptr1+mRecCount, dev_ptr2, dev_ptr1, thrust::logical_or<bool>());
    thrust::device_free(dev_ptr2);
    return column1;
}

bool* CudaSet::compare(int_type s, int_type d, int_type op_type) {
    bool res;

    if (op_type == 2) { // >
        if (d > s)
        	res = 1;
        else
        	res = 0;
    } else if (op_type == 1) { // <
        if (d < s)
        	res = 1;
        else
        	res = 0;
    } else if (op_type == 6) { // >=
        if (d >= s)
        	res = 1;
        else
        	res = 0;
    } else if (op_type == 5) { // <=
        if (d <= s)
        	res = 1;
        else
        	res = 0;
    } else if (op_type == 4) {// =
        if (d == s)
        	res = 1;
        else
        	res = 0;
    } else { // !=
        if (d != s)
        	res = 1;
        else
        	res = 0;
    }

    thrust::device_ptr<bool> p = thrust::device_malloc<bool>(mRecCount);
    thrust::sequence(p, p+mRecCount, res, (bool)0);

    return thrust::raw_pointer_cast(p);
}

bool* CudaSet::compare(float_type s, float_type d, int_type op_type) {
    bool res;

    if (op_type == 2) { // >
        if ((d-s) > EPSILON) res = 1;
        else res = 0;
    } else if (op_type == 1) { // <
        if ((s-d) > EPSILON) res = 1;
        else res = 0;
    } else if (op_type == 6) { // >=
        if (((d-s) > EPSILON) || (((d-s) < EPSILON) && ((d-s) > -EPSILON))) res = 1;
        else res = 0;
	} else if (op_type == 5) { // <=
        if (((s-d) > EPSILON) || (((d-s) < EPSILON) && ((d-s) > -EPSILON))) res = 1;
        else res = 0;
    } else if (op_type == 4) {// =
        if (((d-s) < EPSILON) && ((d-s) > -EPSILON)) res = 1;
        else res = 0;
    } else { // !=
        if (!(((d-s) < EPSILON) && ((d-s) > -EPSILON))) res = 1;
        else res = 0;
    }
    thrust::device_ptr<bool> p = thrust::device_malloc<bool>(mRecCount);
    thrust::sequence(p, p+mRecCount, res, (bool)0);

    return thrust::raw_pointer_cast(p);
}

bool* CudaSet::compare(float_type* column1, float_type d, int_type op_type) {
    thrust::device_ptr<bool> res = thrust::device_malloc<bool>(mRecCount);
    thrust::device_ptr<float_type> dev_ptr(column1);

    if (op_type == 2) // >
        thrust::transform(dev_ptr, dev_ptr+mRecCount, thrust::make_constant_iterator(d), res, f_greater());
    else if (op_type == 1)  // <
        thrust::transform(dev_ptr, dev_ptr+mRecCount, thrust::make_constant_iterator(d), res, f_less());
    else if (op_type == 6) // >=
        thrust::transform(dev_ptr, dev_ptr+mRecCount, thrust::make_constant_iterator(d), res, f_greater_equal_to());
    else if (op_type == 5)  // <=
        thrust::transform(dev_ptr, dev_ptr+mRecCount, thrust::make_constant_iterator(d), res, f_less_equal());
    else if (op_type == 4)// =
        thrust::transform(dev_ptr, dev_ptr+mRecCount, thrust::make_constant_iterator(d), res, f_equal_to());
    else  // !=
        thrust::transform(dev_ptr, dev_ptr+mRecCount, thrust::make_constant_iterator(d), res, f_not_equal_to());

    return thrust::raw_pointer_cast(res);
}

bool* CudaSet::compare(int_type* column1, int_type d, int_type op_type, unsigned int p1, unsigned int p2) {
    thrust::device_ptr<bool> temp = thrust::device_malloc<bool>(mRecCount);
    thrust::device_ptr<int_type> dev_ptr(column1);

	if(p2)
		d = d*(unsigned int)pow(10, p2);

    if (op_type == 2) { // >
		if(!p1)
			thrust::transform(dev_ptr, dev_ptr+mRecCount, thrust::make_constant_iterator(d), temp, thrust::greater<int_type>());
		else
			thrust::transform(thrust::make_transform_iterator(dev_ptr, power_functor<int_type>(p1)), thrust::make_transform_iterator(dev_ptr+mRecCount, power_functor<int_type>(p1)), thrust::make_constant_iterator(d), temp, thrust::greater<int_type>());
    } else if (op_type == 1) { // <
		if(!p1)
			thrust::transform(dev_ptr, dev_ptr+mRecCount, thrust::make_constant_iterator(d), temp, thrust::less<int_type>());
		else
			thrust::transform(thrust::make_transform_iterator(dev_ptr, power_functor<int_type>(p1)), thrust::make_transform_iterator(dev_ptr+mRecCount, power_functor<int_type>(p1)), thrust::make_constant_iterator(d), temp, thrust::less<int_type>());
    } else if (op_type == 6) { // >=
		if(!p1)
			thrust::transform(dev_ptr, dev_ptr+mRecCount, thrust::make_constant_iterator(d), temp, thrust::greater_equal<int_type>());
		else
			thrust::transform(thrust::make_transform_iterator(dev_ptr, power_functor<int_type>(p1)), thrust::make_transform_iterator(dev_ptr+mRecCount, power_functor<int_type>(p1)), thrust::make_constant_iterator(d), temp, thrust::greater_equal<int_type>());
	} else if (op_type == 5) { // <=
		if(!p1)
			thrust::transform(dev_ptr, dev_ptr+mRecCount, thrust::make_constant_iterator(d), temp, thrust::less_equal<int_type>());
		else
			thrust::transform(thrust::make_transform_iterator(dev_ptr, power_functor<int_type>(p1)), thrust::make_transform_iterator(dev_ptr+mRecCount, power_functor<int_type>(p1)), thrust::make_constant_iterator(d), temp, thrust::less_equal<int_type>());
	} else if (op_type == 4) { // =
		if(!p1)
			thrust::transform(dev_ptr, dev_ptr+mRecCount, thrust::make_constant_iterator(d), temp, thrust::equal_to<int_type>());
		else
			thrust::transform(thrust::make_transform_iterator(dev_ptr, power_functor<int_type>(p1)), thrust::make_transform_iterator(dev_ptr+mRecCount, power_functor<int_type>(p1)), thrust::make_constant_iterator(d), temp, thrust::equal_to<int_type>());
	} else { // !=
		if(!p1)
			thrust::transform(dev_ptr, dev_ptr+mRecCount, thrust::make_constant_iterator(d), temp, thrust::not_equal_to<int_type>());
		else
			thrust::transform(thrust::make_transform_iterator(dev_ptr, power_functor<int_type>(p1)), thrust::make_transform_iterator(dev_ptr+mRecCount, power_functor<int_type>(p1)), thrust::make_constant_iterator(d), temp, thrust::not_equal_to<int_type>());
	}
    return thrust::raw_pointer_cast(temp);
}

bool* CudaSet::compare(int_type* column1, int_type* column2, int_type op_type, unsigned int p1, unsigned int p2) {
    thrust::device_ptr<int_type> dev_ptr1(column1);
    thrust::device_ptr<int_type> dev_ptr2(column2);
    thrust::device_ptr<bool> temp = thrust::device_malloc<bool>(mRecCount);

    if (op_type == 2) { // >
    	if(!p1 && !p2)
			thrust::transform(dev_ptr1, dev_ptr1+mRecCount, dev_ptr2, temp, thrust::greater<int_type>());
		else if (p1 && p2)
			thrust::transform(thrust::make_transform_iterator(dev_ptr1, power_functor<int_type>(p1)), thrust::make_transform_iterator(dev_ptr1+mRecCount, power_functor<int_type>(p1)), thrust::make_transform_iterator(dev_ptr2+mRecCount, power_functor<int_type>(p2)), temp, thrust::greater<int_type>());
		else if (p1)
			thrust::transform(thrust::make_transform_iterator(dev_ptr1, power_functor<int_type>(p1)), thrust::make_transform_iterator(dev_ptr1+mRecCount, power_functor<int_type>(p1)), dev_ptr2, temp, thrust::greater<int_type>());
		else
			thrust::transform(dev_ptr1, dev_ptr1+mRecCount, thrust::make_transform_iterator(dev_ptr2+mRecCount, power_functor<int_type>(p2)), temp, thrust::greater<int_type>());
    } else if (op_type == 1) { // <
    	if(!p1 && !p2)
			thrust::transform(dev_ptr1, dev_ptr1+mRecCount, dev_ptr2, temp, thrust::less<int_type>());
		else if (p1 && p2)
			thrust::transform(thrust::make_transform_iterator(dev_ptr1, power_functor<int_type>(p1)), thrust::make_transform_iterator(dev_ptr1+mRecCount, power_functor<int_type>(p1)), thrust::make_transform_iterator(dev_ptr2+mRecCount, power_functor<int_type>(p2)), temp, thrust::less<int_type>());
		else if (p1)
			thrust::transform(thrust::make_transform_iterator(dev_ptr1, power_functor<int_type>(p1)), thrust::make_transform_iterator(dev_ptr1+mRecCount, power_functor<int_type>(p1)), dev_ptr2, temp, thrust::less<int_type>());
		else
			thrust::transform(dev_ptr1, dev_ptr1+mRecCount, thrust::make_transform_iterator(dev_ptr2+mRecCount, power_functor<int_type>(p2)), temp, thrust::less<int_type>());
    } else if (op_type == 6) { // >=
    	if(!p1 && !p2)
			thrust::transform(dev_ptr1, dev_ptr1+mRecCount, dev_ptr2, temp, thrust::greater_equal<int_type>());
		else if (p1 && p2)
			thrust::transform(thrust::make_transform_iterator(dev_ptr1, power_functor<int_type>(p1)), thrust::make_transform_iterator(dev_ptr1+mRecCount, power_functor<int_type>(p1)), thrust::make_transform_iterator(dev_ptr2+mRecCount, power_functor<int_type>(p2)), temp, thrust::greater_equal<int_type>());
		else if (p1)
			thrust::transform(thrust::make_transform_iterator(dev_ptr1, power_functor<int_type>(p1)), thrust::make_transform_iterator(dev_ptr1+mRecCount, power_functor<int_type>(p1)), dev_ptr2, temp, thrust::greater_equal<int_type>());
		else
			thrust::transform(dev_ptr1, dev_ptr1+mRecCount, thrust::make_transform_iterator(dev_ptr2+mRecCount, power_functor<int_type>(p2)), temp, thrust::greater_equal<int_type>());
    } else if (op_type == 5) {  // <=
    	if(!p1 && !p2)
			thrust::transform(dev_ptr1, dev_ptr1+mRecCount, dev_ptr2, temp, thrust::less_equal<int_type>());
		else if (p1 && p2)
			thrust::transform(thrust::make_transform_iterator(dev_ptr1, power_functor<int_type>(p1)), thrust::make_transform_iterator(dev_ptr1+mRecCount, power_functor<int_type>(p1)), thrust::make_transform_iterator(dev_ptr2+mRecCount, power_functor<int_type>(p2)), temp, thrust::less_equal<int_type>());
		else if (p1)
			thrust::transform(thrust::make_transform_iterator(dev_ptr1, power_functor<int_type>(p1)), thrust::make_transform_iterator(dev_ptr1+mRecCount, power_functor<int_type>(p1)), dev_ptr2, temp, thrust::less_equal<int_type>());
		else
			thrust::transform(dev_ptr1, dev_ptr1+mRecCount, thrust::make_transform_iterator(dev_ptr2+mRecCount, power_functor<int_type>(p2)), temp, thrust::less_equal<int_type>());
    } else if (op_type == 4) { // =
    	if (!p1 && !p2)
			thrust::transform(dev_ptr1, dev_ptr1+mRecCount, dev_ptr2, temp, thrust::equal_to<int_type>());
		else if (p1 && p2)
			thrust::transform(thrust::make_transform_iterator(dev_ptr1, power_functor<int_type>(p1)), thrust::make_transform_iterator(dev_ptr1+mRecCount, power_functor<int_type>(p1)), thrust::make_transform_iterator(dev_ptr2+mRecCount, power_functor<int_type>(p2)), temp, thrust::equal_to<int_type>());
		else if (p1)
			thrust::transform(thrust::make_transform_iterator(dev_ptr1, power_functor<int_type>(p1)), thrust::make_transform_iterator(dev_ptr1+mRecCount, power_functor<int_type>(p1)), dev_ptr2, temp, thrust::equal_to<int_type>());
		else
			thrust::transform(dev_ptr1, dev_ptr1+mRecCount, thrust::make_transform_iterator(dev_ptr2+mRecCount, power_functor<int_type>(p2)), temp, thrust::equal_to<int_type>());
    } else { // !=
    	if(!p1 && !p2)
			thrust::transform(dev_ptr1, dev_ptr1+mRecCount, dev_ptr2, temp, thrust::not_equal_to<int_type>());
		else if (p1 && p2)
			thrust::transform(thrust::make_transform_iterator(dev_ptr1, power_functor<int_type>(p1)), thrust::make_transform_iterator(dev_ptr1+mRecCount, power_functor<int_type>(p1)), thrust::make_transform_iterator(dev_ptr2+mRecCount, power_functor<int_type>(p2)), temp, thrust::not_equal_to<int_type>());
		else if (p1)
			thrust::transform(thrust::make_transform_iterator(dev_ptr1, power_functor<int_type>(p1)), thrust::make_transform_iterator(dev_ptr1+mRecCount, power_functor<int_type>(p1)), dev_ptr2, temp, thrust::not_equal_to<int_type>());
		else
			thrust::transform(dev_ptr1, dev_ptr1+mRecCount, thrust::make_transform_iterator(dev_ptr2+mRecCount, power_functor<int_type>(p2)), temp, thrust::not_equal_to<int_type>());
    }

    return thrust::raw_pointer_cast(temp);
}

bool* CudaSet::compare(float_type* column1, float_type* column2, int_type op_type) {
    thrust::device_ptr<float_type> dev_ptr1(column1);
    thrust::device_ptr<float_type> dev_ptr2(column2);
    thrust::device_ptr<bool> temp = thrust::device_malloc<bool>(mRecCount);

    if (op_type == 2) // >
        thrust::transform(dev_ptr1, dev_ptr1+mRecCount, dev_ptr2, temp, f_greater());
    else if (op_type == 1)  // <
        thrust::transform(dev_ptr1, dev_ptr1+mRecCount, dev_ptr2, temp, f_less());
    else if (op_type == 6) // >=
        thrust::transform(dev_ptr1, dev_ptr1+mRecCount, dev_ptr2, temp, f_greater_equal_to());
    else if (op_type == 5)  // <=
        thrust::transform(dev_ptr1, dev_ptr1+mRecCount, dev_ptr2, temp, f_less_equal());
    else if (op_type == 4)// =
        thrust::transform(dev_ptr1, dev_ptr1+mRecCount, dev_ptr2, temp, f_equal_to());
    else // !=
        thrust::transform(dev_ptr1, dev_ptr1+mRecCount, dev_ptr2, temp, f_not_equal_to());

    return thrust::raw_pointer_cast(temp);
}

bool* CudaSet::compare(float_type* column1, int_type* column2, int_type op_type) {
    thrust::device_ptr<float_type> dev_ptr1(column1);
    thrust::device_ptr<int_type> dev_ptr(column2);
    thrust::device_ptr<float_type> dev_ptr2 = thrust::device_malloc<float_type>(mRecCount);
    thrust::device_ptr<bool> temp = thrust::device_malloc<bool>(mRecCount);

    thrust::transform(dev_ptr, dev_ptr + mRecCount, dev_ptr2, long_to_float_type());

    if (op_type == 2) // >
        thrust::transform(dev_ptr1, dev_ptr1+mRecCount, dev_ptr2, temp, f_greater());
    else if (op_type == 1)  // <
        thrust::transform(dev_ptr1, dev_ptr1+mRecCount, dev_ptr2, temp, f_less());
    else if (op_type == 6) // >=
        thrust::transform(dev_ptr1, dev_ptr1+mRecCount, dev_ptr2, temp, f_greater_equal_to());
    else if (op_type == 5)  // <=
        thrust::transform(dev_ptr1, dev_ptr1+mRecCount, dev_ptr2, temp, f_less_equal());
    else if (op_type == 4)// =
        thrust::transform(dev_ptr1, dev_ptr1+mRecCount, dev_ptr2, temp, f_equal_to());
    else // !=
        thrust::transform(dev_ptr1, dev_ptr1+mRecCount, dev_ptr2, temp, f_not_equal_to());

    thrust::device_free(dev_ptr2);
    return thrust::raw_pointer_cast(temp);
}

float_type* CudaSet::op(int_type* column1, float_type* column2, string op_type, bool reverse) {
	if (alloced_mem.empty()) {
		alloc_pool(maxRecs);
	}
	thrust::device_ptr<float_type> temp((float_type*)alloced_mem.back());
    thrust::device_ptr<int_type> dev_ptr(column1);

    thrust::transform(dev_ptr, dev_ptr + mRecCount, temp, long_to_float_type()); // in-place transformation
    thrust::device_ptr<float_type> dev_ptr1(column2);

    if (reverse == 0) {
        if (op_type.compare("MUL") == 0)
            thrust::transform(dev_ptr1, dev_ptr1+mRecCount, temp, temp, thrust::multiplies<float_type>());
        else if (op_type.compare("ADD") == 0)
            thrust::transform(dev_ptr1, dev_ptr1+mRecCount, temp, temp, thrust::plus<float_type>());
        else if (op_type.compare("MINUS") == 0)
            thrust::transform(dev_ptr1, dev_ptr1+mRecCount, temp, temp, thrust::minus<float_type>());
        else
            thrust::transform(dev_ptr1, dev_ptr1+mRecCount, temp, temp, thrust::divides<float_type>());
    } else {
        if (op_type.compare("MUL") == 0)
            thrust::transform(temp, temp+mRecCount, dev_ptr1, temp, thrust::multiplies<float_type>());
        else if (op_type.compare("ADD") == 0)
            thrust::transform(temp, temp+mRecCount, dev_ptr1, temp, thrust::plus<float_type>());
        else if (op_type.compare("MINUS") == 0)
            thrust::transform(temp, temp+mRecCount, dev_ptr1, temp, thrust::minus<float_type>());
        else
            thrust::transform(temp, temp+mRecCount, dev_ptr1, temp, thrust::divides<float_type>());
    }
	alloced_mem.pop_back();
    return thrust::raw_pointer_cast(temp);
}

int_type* CudaSet::op(int_type* column1, int_type d, string op_type, bool reverse, unsigned int p1, unsigned int p2) {
	if (alloced_mem.empty()) {
		alloc_pool(maxRecs);
	}
	LOG(logDEBUG) << "OP " << d << " " << op_type << " " << p1 << " " << p2;
	thrust::device_ptr<int_type> temp((int_type*)alloced_mem.back());
    thrust::device_ptr<int_type> dev_ptr1(column1);
	unsigned int d1 = d;
	if (p2)
		d = d*(unsigned int)pow(10, p2);

    if (reverse == 0) {
        if (op_type.compare("MUL") == 0) {
			thrust::transform(dev_ptr1, dev_ptr1+mRecCount,  thrust::make_constant_iterator(d1), temp, thrust::multiplies<int_type>());
		} else if (op_type.compare("ADD") == 0) {
			if (!p1)
				thrust::transform(dev_ptr1, dev_ptr1+mRecCount, thrust::make_constant_iterator(d*(unsigned int)pow(10, p2)), temp, thrust::plus<int_type>());
			else
				thrust::transform(thrust::make_transform_iterator(dev_ptr1, power_functor<int_type>(p1)), thrust::make_transform_iterator(dev_ptr1+mRecCount, power_functor<int_type>(p1)),  thrust::make_constant_iterator(d), temp, thrust::plus<int_type>());
		} else if (op_type.compare("MINUS") == 0) {
			if (!p1)
				thrust::transform(dev_ptr1, dev_ptr1+mRecCount, thrust::make_constant_iterator(d*(unsigned int)pow(10, p2)), temp, thrust::minus<int_type>());
			else
				thrust::transform(thrust::make_transform_iterator(dev_ptr1, power_functor<int_type>(p1)), thrust::make_transform_iterator(dev_ptr1+mRecCount, power_functor<int_type>(p1)),  thrust::make_constant_iterator(d), temp, thrust::minus<int_type>());
		} else {
			if (!p1)
				thrust::transform(dev_ptr1, dev_ptr1+mRecCount, thrust::make_constant_iterator(d*(unsigned int)pow(10, p2)), temp, thrust::divides<int_type>());
			else
				thrust::transform(thrust::make_transform_iterator(dev_ptr1, power_functor<int_type>(p1)), thrust::make_transform_iterator(dev_ptr1+mRecCount, power_functor<int_type>(p1)),  thrust::make_constant_iterator(d), temp, thrust::divides<int_type>());
		}
    }  else {
        if (op_type.compare("MUL") == 0) {
			if(!p1)
				thrust::transform(thrust::make_constant_iterator(d), thrust::make_constant_iterator(d) + mRecCount, dev_ptr1, temp, thrust::multiplies<int_type>());
			else
				thrust::transform(thrust::make_constant_iterator(d), thrust::make_constant_iterator(d) + mRecCount, thrust::make_transform_iterator(dev_ptr1, power_functor<int_type>(p1)), temp, thrust::multiplies<int_type>());
		} else if (op_type.compare("ADD") == 0) {
			if (!p1)
				thrust::transform(thrust::make_constant_iterator(d), thrust::make_constant_iterator(d) + mRecCount, dev_ptr1, temp, thrust::plus<int_type>());
			else
				thrust::transform(thrust::make_constant_iterator(d), thrust::make_constant_iterator(d) + mRecCount, thrust::make_transform_iterator(dev_ptr1, power_functor<int_type>(p1)), temp, thrust::plus<int_type>());
		} else if (op_type.compare("MINUS") == 0) {
			if (!p1)
				thrust::transform(thrust::make_constant_iterator(d), thrust::make_constant_iterator(d) + mRecCount, dev_ptr1, temp, thrust::minus<int_type>());
			else
				thrust::transform(thrust::make_constant_iterator(d), thrust::make_constant_iterator(d) + mRecCount, thrust::make_transform_iterator(dev_ptr1, power_functor<int_type>(p1)), temp, thrust::minus<int_type>());
		} else {
			if (!p1)
				thrust::transform(thrust::make_constant_iterator(d), thrust::make_constant_iterator(d) + mRecCount, dev_ptr1, temp, thrust::divides<int_type>());
			else
				thrust::transform(thrust::make_constant_iterator(d), thrust::make_constant_iterator(d) + mRecCount, thrust::make_transform_iterator(dev_ptr1, power_functor<int_type>(p1)), temp, thrust::divides<int_type>());
		}
    }
	alloced_mem.pop_back();
    return thrust::raw_pointer_cast(temp);
}

int_type* CudaSet::op(int_type* column1, int_type* column2, string op_type, bool reverse, unsigned int p1, unsigned int p2) {
	if (alloced_mem.empty()) {
		alloc_pool(maxRecs);
	}
	thrust::device_ptr<int_type> temp((int_type*)alloced_mem.back());
    thrust::device_ptr<int_type> dev_ptr1(column1);
    thrust::device_ptr<int_type> dev_ptr2(column2);

	LOG(logDEBUG) << "OP " <<  op_type << " " << p1 << " " << p2 << " " << reverse;

    if (reverse == 0) {
        if (op_type.compare("MUL") == 0) {
			thrust::transform(dev_ptr1, dev_ptr1+mRecCount, dev_ptr2, temp, thrust::multiplies<int_type>());
		} else if (op_type.compare("ADD") == 0) {
			if (!p1 && !p2)
				thrust::transform(dev_ptr1, dev_ptr1+mRecCount, dev_ptr2, temp, thrust::plus<int_type>());
			else if (p1 && p2)
				thrust::transform(thrust::make_transform_iterator(dev_ptr1, power_functor<int_type>(p1)), thrust::make_transform_iterator(dev_ptr1+mRecCount, power_functor<int_type>(p1)), thrust::make_transform_iterator(dev_ptr2, power_functor<int_type>(p2)), temp, thrust::plus<int_type>());
			else if (p1)
				thrust::transform(thrust::make_transform_iterator(dev_ptr1, power_functor<int_type>(p1)), thrust::make_transform_iterator(dev_ptr1+mRecCount, power_functor<int_type>(p1)), dev_ptr2, temp, thrust::plus<int_type>());
			else
				thrust::transform(dev_ptr1, dev_ptr1+mRecCount, thrust::make_transform_iterator(dev_ptr2, power_functor<int_type>(p2)), temp, thrust::plus<int_type>());

		} else if (op_type.compare("MINUS") == 0) {
			if(!p1 && !p2)
				thrust::transform(dev_ptr1, dev_ptr1+mRecCount, dev_ptr2, temp, thrust::minus<int_type>());
			else if (p1 && p2)
				thrust::transform(thrust::make_transform_iterator(dev_ptr1, power_functor<int_type>(p1)), thrust::make_transform_iterator(dev_ptr1+mRecCount, power_functor<int_type>(p1)), thrust::make_transform_iterator(dev_ptr2, power_functor<int_type>(p2)), temp, thrust::minus<int_type>());
			else if (p1)
				thrust::transform(thrust::make_transform_iterator(dev_ptr1, power_functor<int_type>(p1)), thrust::make_transform_iterator(dev_ptr1+mRecCount, power_functor<int_type>(p1)), dev_ptr2, temp, thrust::minus<int_type>());
			else
				thrust::transform(dev_ptr1, dev_ptr1+mRecCount, thrust::make_transform_iterator(dev_ptr2, power_functor<int_type>(p2)), temp, thrust::minus<int_type>());

		} else {
			if (!p1 && !p2)
				thrust::transform(dev_ptr1, dev_ptr1+mRecCount, dev_ptr2, temp, thrust::divides<int_type>());
			else if (p1 && p2)
				thrust::transform(thrust::make_transform_iterator(dev_ptr1, power_functor<int_type>(p1)), thrust::make_transform_iterator(dev_ptr1+mRecCount, power_functor<int_type>(p1)), thrust::make_transform_iterator(dev_ptr2, power_functor<int_type>(p2)), temp, thrust::divides<int_type>());
			else if (p1)
				thrust::transform(thrust::make_transform_iterator(dev_ptr1, power_functor<int_type>(p1)), thrust::make_transform_iterator(dev_ptr1+mRecCount, power_functor<int_type>(p1)), dev_ptr2, temp, thrust::divides<int_type>());
			else
				thrust::transform(dev_ptr1, dev_ptr1+mRecCount, thrust::make_transform_iterator(dev_ptr2, power_functor<int_type>(p2)), temp, thrust::divides<int_type>());
		}
    } else {
        if (op_type.compare("MUL") == 0) {
			thrust::transform(dev_ptr2, dev_ptr2+mRecCount, dev_ptr1, temp, thrust::multiplies<int_type>());
		} else if (op_type.compare("ADD") == 0) {
			if (!p1 && !p2)
				thrust::transform(dev_ptr2, dev_ptr2+mRecCount, dev_ptr1, temp, thrust::plus<int_type>());
			else if (p1 && p2)
				thrust::transform(thrust::make_transform_iterator(dev_ptr2, power_functor<int_type>(p2)), thrust::make_transform_iterator(dev_ptr2+mRecCount, power_functor<int_type>(p2)), thrust::make_transform_iterator(dev_ptr1, power_functor<int_type>(p1)), temp, thrust::plus<int_type>());
			else if (p1)
				thrust::transform(dev_ptr2, dev_ptr2+mRecCount, thrust::make_transform_iterator(dev_ptr1, power_functor<int_type>(p1)), temp, thrust::plus<int_type>());
			else
				thrust::transform(thrust::make_transform_iterator(dev_ptr2, power_functor<int_type>(p2)), thrust::make_transform_iterator(dev_ptr2+mRecCount, power_functor<int_type>(p2)), dev_ptr1, temp, thrust::plus<int_type>());

		} else if (op_type.compare("MINUS") == 0) {
			if (!p1 && !p2)
				thrust::transform(dev_ptr2, dev_ptr2+mRecCount, dev_ptr1, temp, thrust::minus<int_type>());
			else if (p1 && p2)
				thrust::transform(thrust::make_transform_iterator(dev_ptr2, power_functor<int_type>(p2)), thrust::make_transform_iterator(dev_ptr2+mRecCount, power_functor<int_type>(p2)), thrust::make_transform_iterator(dev_ptr1, power_functor<int_type>(p1)), temp, thrust::minus<int_type>());
			else if (p1)
				thrust::transform(dev_ptr2, dev_ptr2+mRecCount, thrust::make_transform_iterator(dev_ptr1, power_functor<int_type>(p1)), temp, thrust::minus<int_type>());
			else
				thrust::transform(thrust::make_transform_iterator(dev_ptr2, power_functor<int_type>(p2)), thrust::make_transform_iterator(dev_ptr2+mRecCount, power_functor<int_type>(p2)), dev_ptr1, temp, thrust::minus<int_type>());
		} else {
			if (!p1 && !p2)
				thrust::transform(dev_ptr2, dev_ptr2+mRecCount, dev_ptr1, temp, thrust::divides<int_type>());
			else if (p1 && p2)
				thrust::transform(thrust::make_transform_iterator(dev_ptr2, power_functor<int_type>(p2)), thrust::make_transform_iterator(dev_ptr2+mRecCount, power_functor<int_type>(p2)), thrust::make_transform_iterator(dev_ptr1, power_functor<int_type>(p1)), temp, thrust::divides<int_type>());
			else if (p1)
				thrust::transform(dev_ptr2, dev_ptr2+mRecCount, thrust::make_transform_iterator(dev_ptr1, power_functor<int_type>(p1)), temp, thrust::divides<int_type>());
			else
				thrust::transform(thrust::make_transform_iterator(dev_ptr2, power_functor<int_type>(p2)), thrust::make_transform_iterator(dev_ptr2+mRecCount, power_functor<int_type>(p2)), dev_ptr1, temp, thrust::divides<int_type>());
		}
    }
	alloced_mem.pop_back();
    return thrust::raw_pointer_cast(temp);
}

float_type* CudaSet::op(float_type* column1, float_type* column2, string op_type, bool reverse) {
	if (alloced_mem.empty()) {
		alloc_pool(maxRecs);
	}
	thrust::device_ptr<float_type> temp((float_type*)alloced_mem.back());
    thrust::device_ptr<float_type> dev_ptr1(column1);
    thrust::device_ptr<float_type> dev_ptr2(column2);

    if (reverse == 0) {
        if (op_type.compare("MUL") == 0)
            thrust::transform(dev_ptr1, dev_ptr1+mRecCount, dev_ptr2, temp, thrust::multiplies<float_type>());
        else if (op_type.compare("ADD") == 0)
            thrust::transform(dev_ptr1, dev_ptr1+mRecCount, dev_ptr2, temp, thrust::plus<float_type>());
        else if (op_type.compare("MINUS") == 0)
            thrust::transform(dev_ptr1, dev_ptr1+mRecCount, dev_ptr2, temp, thrust::minus<float_type>());
        else
            thrust::transform(dev_ptr1, dev_ptr1+mRecCount, dev_ptr2, temp, thrust::divides<float_type>());
    } else {
        if (op_type.compare("MUL") == 0)
            thrust::transform(dev_ptr2, dev_ptr2+mRecCount, dev_ptr1, temp, thrust::multiplies<float_type>());
        else if (op_type.compare("ADD") == 0)
            thrust::transform(dev_ptr2, dev_ptr2+mRecCount, dev_ptr1, temp, thrust::plus<float_type>());
        else if (op_type.compare("MINUS") == 0)
            thrust::transform(dev_ptr2, dev_ptr2+mRecCount, dev_ptr1, temp, thrust::minus<float_type>());
        else
            thrust::transform(dev_ptr2, dev_ptr2+mRecCount, dev_ptr1, temp, thrust::divides<float_type>());
    }
	alloced_mem.pop_back();
    return thrust::raw_pointer_cast(temp);
}

float_type* CudaSet::op(int_type* column1, float_type d, string op_type, bool reverse) {
	if (alloced_mem.empty()) {
		alloc_pool(maxRecs);
	}
	thrust::device_ptr<float_type> temp((float_type*)alloced_mem.back());
    thrust::fill(temp, temp+mRecCount, d);

    thrust::device_ptr<int_type> dev_ptr(column1);
    thrust::device_ptr<float_type> dev_ptr1 = thrust::device_malloc<float_type>(mRecCount);
    thrust::transform(dev_ptr, dev_ptr + mRecCount, dev_ptr1, long_to_float_type());

    if (reverse == 0) {
        if (op_type.compare("MUL") == 0)
            thrust::transform(dev_ptr1, dev_ptr1+mRecCount, temp, temp, thrust::multiplies<float_type>());
        else if (op_type.compare("ADD") == 0)
            thrust::transform(dev_ptr1, dev_ptr1+mRecCount, temp, temp, thrust::plus<float_type>());
        else if (op_type.compare("MINUS") == 0)
            thrust::transform(dev_ptr1, dev_ptr1+mRecCount, temp, temp, thrust::minus<float_type>());
        else
            thrust::transform(dev_ptr1, dev_ptr1+mRecCount, temp, temp, thrust::divides<float_type>());
    } else {
        if (op_type.compare("MUL") == 0)
            thrust::transform(temp, temp+mRecCount, dev_ptr1, temp, thrust::multiplies<float_type>());
        else if (op_type.compare("ADD") == 0)
            thrust::transform(temp, temp+mRecCount, dev_ptr1, temp, thrust::plus<float_type>());
        else if (op_type.compare("MINUS") == 0)
            thrust::transform(temp, temp+mRecCount, dev_ptr1, temp, thrust::minus<float_type>());
        else
            thrust::transform(temp, temp+mRecCount, dev_ptr1, temp, thrust::divides<float_type>());
    }
    thrust::device_free(dev_ptr1);
	alloced_mem.pop_back();
    return thrust::raw_pointer_cast(temp);
}

float_type* CudaSet::op(float_type* column1, float_type d, string op_type, bool reverse) {
	if (alloced_mem.empty()) {
		alloc_pool(maxRecs);
	}
	thrust::device_ptr<float_type> temp((float_type*)alloced_mem.back());
    thrust::device_ptr<float_type> dev_ptr1(column1);

    if (reverse == 0) {
        if (op_type.compare("MUL") == 0)
            thrust::transform(dev_ptr1, dev_ptr1+mRecCount, thrust::make_constant_iterator(d), temp, thrust::multiplies<float_type>());
        else if (op_type.compare("ADD") == 0)
            thrust::transform(dev_ptr1, dev_ptr1+mRecCount, thrust::make_constant_iterator(d), temp, thrust::plus<float_type>());
        else if (op_type.compare("MINUS") == 0)
            thrust::transform(dev_ptr1, dev_ptr1+mRecCount, thrust::make_constant_iterator(d), temp, thrust::minus<float_type>());
        else
            thrust::transform(dev_ptr1, dev_ptr1+mRecCount, thrust::make_constant_iterator(d), temp, thrust::divides<float_type>());
    } else {
        if (op_type.compare("MUL") == 0)
            thrust::transform(thrust::make_constant_iterator(d), thrust::make_constant_iterator(d)+mRecCount, dev_ptr1, temp, thrust::multiplies<float_type>());
        else if (op_type.compare("ADD") == 0)
            thrust::transform(thrust::make_constant_iterator(d), thrust::make_constant_iterator(d)+mRecCount, dev_ptr1, temp, thrust::plus<float_type>());
        else if (op_type.compare("MINUS") == 0)
            thrust::transform(thrust::make_constant_iterator(d), thrust::make_constant_iterator(d)+mRecCount, dev_ptr1, temp, thrust::minus<float_type>());
        else
            thrust::transform(thrust::make_constant_iterator(d), thrust::make_constant_iterator(d)+mRecCount, dev_ptr1, temp, thrust::divides<float_type>());
    }
	alloced_mem.pop_back();
    return (float_type*)thrust::raw_pointer_cast(temp);
}

char CudaSet::loadIndex(const string index_name, const unsigned int segment) {
    unsigned int bits_encoded, fit_count, vals_count, sz, real_count;
    void* d_str;
    string f1 = index_name + "." + to_string(segment);
    char res;

	//interactive = 0;
    if (interactive) {
        if (index_buffers.find(f1) == index_buffers.end()) {
        	iFileSystemHandle* f = file_system->open(f1.c_str(), "rb");
        	file_system->seek(f, 0, SEEK_END);
            long fileSize = file_system->tell(f);
            char* buff;
            cudaHostAlloc(&buff, fileSize, cudaHostAllocDefault);

            file_system->seek(f, 0, SEEK_SET);
            file_system->read(buff, fileSize, f);
            file_system->close(f);
            index_buffers[f1] = buff;
        }
        sz = ((unsigned int*)index_buffers[f1])[0];

        idx_dictionary_int[index_name].clear();
        for (unsigned int i = 0; i < sz; i++) {
            idx_dictionary_int[index_name][((int_type*)(index_buffers[f1]+4+8*i))[0]] = i;
        }
        vals_count = ((unsigned int*)(index_buffers[f1]+4 +8*sz))[2];
        real_count = ((unsigned int*)(index_buffers[f1]+4 +8*sz))[3];
        mRecCount = real_count;

        if (idx_vals.count(index_name) == 0) {
	        cudaMalloc((void **) &d_str, (vals_count+2)*int_size);
			cudaMemcpy(d_str, (void *) &((index_buffers[f1]+4 +8*sz)[0]), (vals_count+2)*int_size, cudaMemcpyHostToDevice);
			idx_vals[index_name] = (unsigned long long int*)d_str;
		}

    } else {
    	iFileSystemHandle* f = file_system->open(f1.c_str(), "rb");
    	file_system->read(&sz, 4, f);
        int_type* d_array = new int_type[sz];
        idx_dictionary_int[index_name].clear();
        file_system->read((void*)d_array, sz*int_size, f);
        for (unsigned int i = 0; i < sz; i++) {
            idx_dictionary_int[index_name][d_array[i]] = i;
        }
        delete [] d_array;

        file_system->read(&fit_count, 4, f);
        file_system->read(&bits_encoded, 4, f);
        file_system->read(&vals_count, 4, f);
        file_system->read(&real_count, 4, f);

        mRecCount = real_count;

        unsigned long long int* int_array = new unsigned long long int[vals_count+2];
        file_system->seek(f, -16 , SEEK_CUR);
        file_system->read((void*)int_array, vals_count*8 + 16, f);
        file_system->read(&res, 1, f);
        file_system->close(f);
        void* d_str;
        cudaMalloc((void **) &d_str, (vals_count+2)*int_size);
        cudaMemcpy(d_str, (void *) int_array, (vals_count+2)*int_size, cudaMemcpyHostToDevice);
        if (idx_vals.count(index_name))
            cudaFree(idx_vals[index_name]);
        idx_vals[index_name] = (unsigned long long int*)d_str;
    }
    return res;
}

void CudaSet::initialize(queue<string> &nameRef, queue<string> &typeRef, queue<int> &sizeRef, queue<int> &colsRef, size_t Recs, string file_name) { // compressed data for DIM tables
    mColumnCount = (unsigned int)nameRef.size();
    string f1;
    unsigned int cnt;
    char buffer[4000];
    string str;
    not_compressed = 0;
    mRecCount = Recs;
    hostRecCount = Recs;
    totalRecs = Recs;
    load_file_name = file_name;

    f1 = file_name + ".sort";
    iFileSystemHandle* f = file_system->open(f1.c_str(), "rb");
    if (f) {
        unsigned int sz, idx;
        file_system->read((char *)&sz, 4, f);
        for (unsigned int j = 0; j < sz; j++) {
        	file_system->read((char *)&idx, 4, f);
        	file_system->read(buffer, idx, f);
            str.assign(buffer, idx);
            sorted_fields.push(str);
            if (verbose)
            	LOG(logDEBUG) << "segment sorted on " << str;
        }
        file_system->close(f);
    }

    f1 = file_name + ".presort";
    f = file_system->open(f1.c_str(), "rb");
    if (f) {
        unsigned int sz, idx;
        file_system->read((char *)&sz, 4, f);
        for (unsigned int j = 0; j < sz; j++) {
        	file_system->read((char *)&idx, 4, f);
        	file_system->read(buffer, idx, f);
            str.assign(buffer, idx);
            presorted_fields.push(str);
            if (verbose)
            	LOG(logDEBUG) << "presorted on " << str;
        }
        file_system->close(f);
    }

    tmp_table = 0;
    filtered = 0;

    for (unsigned int i=0; i < mColumnCount; i++) {
        columnNames.push_back(nameRef.front());
        cols[colsRef.front()] = nameRef.front();

        if (((typeRef.front()).compare("decimal") == 0) || ((typeRef.front()).compare("int") == 0)) {
            f1 = file_name + "." + nameRef.front() + ".0";
            iFileSystemHandle* f = file_system->open(f1.c_str(), "rb");
            if (!f) {
            	LOG(logERROR) << "Couldn't find field " << nameRef.front() << endl;
                exit(0);
            }
            for (unsigned int j = 0; j < 6; j++)
            	file_system->read((char *)&cnt, 4, f);
            file_system->close(f);
            compTypes[nameRef.front()] = cnt;
        }
		if ((typeRef.front()).compare("timestamp") == 0)
			ts_cols[nameRef.front()] = 1;
		else
			ts_cols[nameRef.front()] = 0;

		if ((typeRef.front()).compare("int") == 0 || (typeRef.front()).compare("timestamp") == 0) {
            type[nameRef.front()] = 0;
            decimal[nameRef.front()] = 0;
			decimal_zeroes[nameRef.front()] = 0;
            h_columns_int[nameRef.front()] = thrust::host_vector<int_type, thrust::system::cuda::experimental::pinned_allocator<int_type> >();
            d_columns_int[nameRef.front()] = thrust::device_vector<int_type>();
        } else if ((typeRef.front()).compare("float") == 0) {
            type[nameRef.front()] = 1;
            decimal[nameRef.front()] = 0;
            h_columns_float[nameRef.front()] = thrust::host_vector<float_type, thrust::system::cuda::experimental::pinned_allocator<float_type> >();
            d_columns_float[nameRef.front()] = thrust::device_vector<float_type >();
        } else if ((typeRef.front()).compare("decimal") == 0) {
            type[nameRef.front()] = 0;
            decimal[nameRef.front()] = 1;
			decimal_zeroes[nameRef.front()] = sizeRef.front();
            h_columns_int[nameRef.front()] = thrust::host_vector<int_type, thrust::system::cuda::experimental::pinned_allocator<int_type> >();
            d_columns_int[nameRef.front()] = thrust::device_vector<int_type>();
        } else {
            type[nameRef.front()] = 2;
            decimal[nameRef.front()] = 0;
            h_columns_char[nameRef.front()] = nullptr;
            d_columns_char[nameRef.front()] = nullptr;
            char_size[nameRef.front()] = sizeRef.front();
            string_map[nameRef.front()] = file_name + "." + nameRef.front();
        }
        nameRef.pop();
        typeRef.pop();
        sizeRef.pop();
        colsRef.pop();
    }
}



void CudaSet::initialize(queue<string> &nameRef, queue<string> &typeRef, queue<int> &sizeRef, queue<int> &colsRef, size_t Recs) {
    mColumnCount = (unsigned int)nameRef.size();
    tmp_table = 0;
    filtered = 0;
    mRecCount = 0;
    hostRecCount = Recs;
    segCount = 0;

    for (unsigned int i=0; i < mColumnCount; i++) {
        columnNames.push_back(nameRef.front());
        cols[colsRef.front()] = nameRef.front();

		if ((typeRef.front()).compare("timestamp") == 0)
			ts_cols[nameRef.front()] = 1;
		else
			ts_cols[nameRef.front()] = 0;

        if ((typeRef.front()).compare("int") == 0 || (typeRef.front()).compare("timestamp") == 0) {
            type[nameRef.front()] = 0;
            decimal[nameRef.front()] = 0;
			decimal_zeroes[nameRef.front()] = 0;
            h_columns_int[nameRef.front()] = thrust::host_vector<int_type, pinned_allocator<int_type> >();
            d_columns_int[nameRef.front()] = thrust::device_vector<int_type>();
        } else if ((typeRef.front()).compare("float") == 0) {
            type[nameRef.front()] = 1;
            decimal[nameRef.front()] = 0;
            h_columns_float[nameRef.front()] = thrust::host_vector<float_type, pinned_allocator<float_type> >();
            d_columns_float[nameRef.front()] = thrust::device_vector<float_type>();
        } else if ((typeRef.front()).compare("decimal") == 0) {
            type[nameRef.front()] = 0;
            decimal[nameRef.front()] = 1;
			decimal_zeroes[nameRef.front()] = sizeRef.front();
            h_columns_int[nameRef.front()] = thrust::host_vector<int_type, pinned_allocator<int_type> >();
            d_columns_int[nameRef.front()] = thrust::device_vector<int_type>();
        } else {
            type[nameRef.front()] = 2;
            decimal[nameRef.front()] = 0;
            h_columns_char[nameRef.front()] = nullptr;
            d_columns_char[nameRef.front()] = nullptr;
            char_size[nameRef.front()] = sizeRef.front();
        }
        nameRef.pop();
        typeRef.pop();
        sizeRef.pop();
        colsRef.pop();
    }
}

void CudaSet::initialize(const size_t RecordCount, const unsigned int ColumnCount) {
    mRecCount = RecordCount;
    hostRecCount = RecordCount;
    mColumnCount = ColumnCount;
    filtered = 0;
}

void CudaSet::initialize(queue<string> op_sel, const queue<string> op_sel_as) {
    mRecCount = 0;
    mColumnCount = (unsigned int)op_sel.size();
    segCount = 1;
    not_compressed = 1;
    filtered = 0;
    col_aliases = op_sel_as;
    unsigned int i = 0;
    CudaSet *a;
    while (!op_sel.empty()) {
        for (auto it = varNames.begin(); it != varNames.end(); it++) {
            a = it->second;
            if (std::find(a->columnNames.begin(), a->columnNames.end(), op_sel.front()) != a->columnNames.end())
                break;
        }

        type[op_sel.front()] = a->type[op_sel.front()];
        cols[i] = op_sel.front();
        decimal[op_sel.front()] = a->decimal[op_sel.front()];
		decimal_zeroes[op_sel.front()] = a->decimal_zeroes[op_sel.front()];
        columnNames.push_back(op_sel.front());

        if (a->type[op_sel.front()] == 0)  {
            d_columns_int[op_sel.front()] = thrust::device_vector<int_type>();
            //h_columns_int[op_sel.front()] = thrust::host_vector<int_type, pinned_allocator<int_type> >();
            h_columns_int[op_sel.front()] = thrust::host_vector<int_type>();
        } else if (a->type[op_sel.front()] == 1) {
            d_columns_float[op_sel.front()] = thrust::device_vector<float_type>();
            //h_columns_float[op_sel.front()] = thrust::host_vector<float_type, pinned_allocator<float_type> >();
            h_columns_float[op_sel.front()] = thrust::host_vector<float_type>();
        } else {
            h_columns_char[op_sel.front()] = nullptr;
            d_columns_char[op_sel.front()] = nullptr;
            char_size[op_sel.front()] = a->char_size[op_sel.front()];
        }
        i++;
        op_sel.pop();
    }
}

void CudaSet::initialize(CudaSet* a, CudaSet* b, queue<string> op_sel, queue<string> op_sel_as) {
    mRecCount = 0;
    mColumnCount = 0;
    queue<string> q_cnt(op_sel);
    unsigned int i = 0;
    set<string> field_names;
    while (!q_cnt.empty()) {
        if (std::find(a->columnNames.begin(), a->columnNames.end(), q_cnt.front()) !=  a->columnNames.end() ||
                std::find(b->columnNames.begin(), b->columnNames.end(), q_cnt.front()) !=  b->columnNames.end())  {
            field_names.insert(q_cnt.front());
        }
        q_cnt.pop();
    }
    mColumnCount = (unsigned int)field_names.size();
    maxRecs = b->maxRecs;
    segCount = 1;
    filtered = 0;
    not_compressed = 1;

    col_aliases = op_sel_as;
    i = 0;
    while (!op_sel.empty()) {
        if (std::find(columnNames.begin(), columnNames.end(), op_sel.front()) ==  columnNames.end()) {
            if (std::find(a->columnNames.begin(), a->columnNames.end(), op_sel.front()) !=  a->columnNames.end()) {
                cols[i] = op_sel.front();
                decimal[op_sel.front()] = a->decimal[op_sel.front()];
                columnNames.push_back(op_sel.front());
                type[op_sel.front()] = a->type[op_sel.front()];
				ts_cols[op_sel.front()] = a->ts_cols[op_sel.front()];

                if (a->type[op_sel.front()] == 0)  {
                    d_columns_int[op_sel.front()] = thrust::device_vector<int_type>();
                    h_columns_int[op_sel.front()] = thrust::host_vector<int_type, pinned_allocator<int_type> >();
                    if (a->string_map.find(op_sel.front()) != a->string_map.end()) {
                        string_map[op_sel.front()] = a->string_map[op_sel.front()];
                    }
					decimal[op_sel.front()] = a->decimal[op_sel.front()];
					decimal_zeroes[op_sel.front()] = a->decimal_zeroes[op_sel.front()];
                } else if (a->type[op_sel.front()] == 1) {
                    d_columns_float[op_sel.front()] = thrust::device_vector<float_type>();
                    h_columns_float[op_sel.front()] = thrust::host_vector<float_type, pinned_allocator<float_type> >();
                } else {
                    h_columns_char[op_sel.front()] = nullptr;
                    d_columns_char[op_sel.front()] = nullptr;
                    char_size[op_sel.front()] = a->char_size[op_sel.front()];
                    string_map[op_sel.front()] = a->string_map[op_sel.front()];
                }
                i++;
            } else if (std::find(b->columnNames.begin(), b->columnNames.end(), op_sel.front()) !=  b->columnNames.end()) {
                columnNames.push_back(op_sel.front());
                cols[i] = op_sel.front();
                decimal[op_sel.front()] = b->decimal[op_sel.front()];
                type[op_sel.front()] = b->type[op_sel.front()];
				ts_cols[op_sel.front()] = b->ts_cols[op_sel.front()];

                if (b->type[op_sel.front()] == 0) {
                    d_columns_int[op_sel.front()] = thrust::device_vector<int_type>();
                    h_columns_int[op_sel.front()] = thrust::host_vector<int_type, pinned_allocator<int_type> >();
                    if (b->string_map.find(op_sel.front()) != b->string_map.end()) {
                        string_map[op_sel.front()] = b->string_map[op_sel.front()];
                    }
					decimal[op_sel.front()] = b->decimal[op_sel.front()];
					decimal_zeroes[op_sel.front()] = b->decimal_zeroes[op_sel.front()];
                }  else if (b->type[op_sel.front()] == 1) {
                    d_columns_float[op_sel.front()] = thrust::device_vector<float_type>();
                    h_columns_float[op_sel.front()] = thrust::host_vector<float_type, pinned_allocator<float_type> >();
                }  else {
                    h_columns_char[op_sel.front()] = nullptr;
                    d_columns_char[op_sel.front()] = nullptr;
                    char_size[op_sel.front()] = b->char_size[op_sel.front()];
                    string_map[op_sel.front()] = b->string_map[op_sel.front()];
                }
                i++;
            }
        }
        op_sel.pop();
    }
}


} // namespace alenka
