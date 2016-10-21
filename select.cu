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

#include "cm.h"
#include "zone_map.h"
#include "moderngpu/src/moderngpu/kernel_reduce.hxx"
#include "moderngpu/src/moderngpu/kernel_segreduce.hxx"


using namespace mgpu;
using namespace thrust::placeholders;

vector<void*> alloced_mem;

template<typename T>
struct distinct : public binary_function<T,T,T>
{
    __host__ __device__ T operator()(const T &lhs, const T &rhs) const {
        return lhs != rhs;
    }
};

struct gpu_getyear
{
    const int_type *source;
    int_type *dest;

    gpu_getyear(const int_type *_source, int_type *_dest):
        source(_source), dest(_dest) {}
    template <typename IndexType>
    __host__ __device__
    void operator()(const IndexType & i) {

        unsigned long long int sec;
        uint quadricentennials, centennials, quadrennials, annuals/*1-ennial?*/;
        uint year, leap;
        uint yday;
        uint month, mday;
        const uint daysSinceJan1st[2][13]=
        {
            {0,31,59,90,120,151,181,212,243,273,304,334,365}, // 365 days, non-leap
            {0,31,60,91,121,152,182,213,244,274,305,335,366}  // 366 days, leap
        };
        unsigned long long int SecondsSinceEpoch = source[i]/1000;
        sec = SecondsSinceEpoch + 11644473600;

        //wday = (uint)((sec / 86400 + 1) % 7); // day of week
        quadricentennials = (uint)(sec / 12622780800ULL); // 400*365.2425*24*3600
        sec %= 12622780800ULL;

        centennials = (uint)(sec / 3155673600ULL); // 100*(365+24/100)*24*3600
        if (centennials > 3)
        {
            centennials = 3;
        }
        sec -= centennials * 3155673600ULL;

        quadrennials = (uint)(sec / 126230400); // 4*(365+1/4)*24*3600
        if (quadrennials > 24)
        {
            quadrennials = 24;
        }
        sec -= quadrennials * 126230400ULL;

        annuals = (uint)(sec / 31536000); // 365*24*3600
        if (annuals > 3)
        {
            annuals = 3;
        }
        sec -= annuals * 31536000ULL;

        year = 1601 + quadricentennials * 400 + centennials * 100 + quadrennials * 4 + annuals;
        leap = !(year % 4) && (year % 100 || !(year % 400));

        // Calculate the day of the year and the time
        yday = sec / 86400;
        sec %= 86400;
        //hour = sec / 3600;
        sec %= 3600;
        //min = sec / 60;
        sec %= 60;

        // Calculate the month
        for (mday = month = 1; month < 13; month++)
        {
            if (yday < daysSinceJan1st[leap][month])
            {
                mday += yday - daysSinceJan1st[leap][month - 1];
                break;
            }
        }
        dest[i] = year;
    }
};

struct gpu_getmonth
{
    const int_type *source;
    int_type *dest;

    gpu_getmonth(const int_type *_source, int_type *_dest):
        source(_source), dest(_dest) {}
    template <typename IndexType>
    __host__ __device__
    void operator()(const IndexType & i) {

        unsigned long long int sec;
        uint quadricentennials, centennials, quadrennials, annuals/*1-ennial?*/;
        uint year, leap;
        uint yday;
        uint month, mday;
        const uint daysSinceJan1st[2][13]=
        {
            {0,31,59,90,120,151,181,212,243,273,304,334,365}, // 365 days, non-leap
            {0,31,60,91,121,152,182,213,244,274,305,335,366}  // 366 days, leap
        };
        unsigned long long int SecondsSinceEpoch = source[i]/1000;
        sec = SecondsSinceEpoch + 11644473600;

        //wday = (uint)((sec / 86400 + 1) % 7); // day of week
        quadricentennials = (uint)(sec / 12622780800ULL); // 400*365.2425*24*3600
        sec %= 12622780800ULL;

        centennials = (uint)(sec / 3155673600ULL); // 100*(365+24/100)*24*3600
        if (centennials > 3)
        {
            centennials = 3;
        }
        sec -= centennials * 3155673600ULL;

        quadrennials = (uint)(sec / 126230400); // 4*(365+1/4)*24*3600
        if (quadrennials > 24)
        {
            quadrennials = 24;
        }
        sec -= quadrennials * 126230400ULL;

        annuals = (uint)(sec / 31536000); // 365*24*3600
        if (annuals > 3)
        {
            annuals = 3;
        }
        sec -= annuals * 31536000ULL;

        year = 1601 + quadricentennials * 400 + centennials * 100 + quadrennials * 4 + annuals;
        leap = !(year % 4) && (year % 100 || !(year % 400));

        // Calculate the day of the year and the time
        yday = sec / 86400;
        sec %= 86400;
        //hour = sec / 3600;
        sec %= 3600;
        //min = sec / 60;
        sec %= 60;

        // Calculate the month
        for (mday = month = 1; month < 13; month++)
        {
            if (yday < daysSinceJan1st[leap][month])
            {
                mday += yday - daysSinceJan1st[leap][month - 1];
                break;
            }
        }
        dest[i] = year*100+month;
    }
};


struct gpu_getday
{
    const int_type *source;
    int_type *dest;

    gpu_getday(const int_type *_source, int_type *_dest):
        source(_source), dest(_dest) {}
    template <typename IndexType>
    __host__ __device__
    void operator()(const IndexType & i) {

        unsigned long long int sec;
        uint quadricentennials, centennials, quadrennials, annuals/*1-ennial?*/;
        uint year, leap;
        uint yday;
        uint month, mday;
        const uint daysSinceJan1st[2][13]=
        {
            {0,31,59,90,120,151,181,212,243,273,304,334,365}, // 365 days, non-leap
            {0,31,60,91,121,152,182,213,244,274,305,335,366}  // 366 days, leap
        };
        unsigned long long int SecondsSinceEpoch = source[i]/1000;
        sec = SecondsSinceEpoch + 11644473600;

        //wday = (uint)((sec / 86400 + 1) % 7); // day of week
        quadricentennials = (uint)(sec / 12622780800ULL); // 400*365.2425*24*3600
        sec %= 12622780800ULL;

        centennials = (uint)(sec / 3155673600ULL); // 100*(365+24/100)*24*3600
        if (centennials > 3)
        {
            centennials = 3;
        }
        sec -= centennials * 3155673600ULL;

        quadrennials = (uint)(sec / 126230400); // 4*(365+1/4)*24*3600
        if (quadrennials > 24)
        {
            quadrennials = 24;
        }
        sec -= quadrennials * 126230400ULL;

        annuals = (uint)(sec / 31536000); // 365*24*3600
        if (annuals > 3)
        {
            annuals = 3;
        }
        sec -= annuals * 31536000ULL;

        year = 1601 + quadricentennials * 400 + centennials * 100 + quadrennials * 4 + annuals;
        leap = !(year % 4) && (year % 100 || !(year % 400));

        // Calculate the day of the year and the time
        yday = sec / 86400;
        sec %= 86400;
        //hour = sec / 3600;
        sec %= 3600;
        //min = sec / 60;
        sec %= 60;

        // Calculate the month
        for (mday = month = 1; month < 13; month++)
        {
            if (yday < daysSinceJan1st[leap][month])
            {
                mday += yday - daysSinceJan1st[leap][month - 1];
                break;
            }
        }
        dest[i] = year*10000+month*100+mday;
    }
};

bool select(queue<string> op_type, queue<string> op_value, queue<int_type> op_nums, queue<float_type> op_nums_f, queue<unsigned int> op_nums_precision, CudaSet* a,
            CudaSet* b, vector<thrust::device_vector<int_type> >& distinct_tmp)
{

    stack<string> exe_type, exe_value;
    stack<int_type*> exe_vectors, exe_vectors1;
    stack<int_type> exe_nums, exe_nums1;
    string  s1, s2, s1_val, s2_val, grp_type;
    int_type n1, n2, res;
    unsigned int colCount = 0, dist_processed = 0;
    stack<int> col_type;
    stack<string> grp_type1, col_val, exe_value1;
    size_t res_size = 0;
    stack<float_type*> exe_vectors1_d;
    stack<unsigned int> exe_precision, exe_precision1;
    stack<bool> exe_ts;
    bool one_line = 0, ts;

    //thrust::device_ptr<bool> d_di(thrust::raw_pointer_cast(a->grp.data()));

    if (a->grp_count && (a->mRecCount != 0))
        res_size = a->grp_count;

    std::clock_t start1 = std::clock();

    for(int i=0; !op_type.empty(); ++i, op_type.pop()) {

        string ss = op_type.front();
        //cout << ss << endl;

        if(ss.compare("emit sel_name") != 0) {
            grp_type = "NULL";

            if (ss.compare("COUNT") == 0  || ss.compare("SUM") == 0  || ss.compare("AVG") == 0 || ss.compare("MIN") == 0 || ss.compare("MAX") == 0 || ss.compare("DISTINCT") == 0 || ss.compare("YEAR") == 0 || ss.compare("MONTH") == 0 || ss.compare("DAY") == 0 || ss.compare("CAST") == 0) {

                if(!a->grp_count && ss.compare("YEAR") && ss.compare("MONTH") && ss.compare("DAY") && ss.compare("CAST")) {
                    one_line = 1;
                };

				if (ss.compare("CAST") == 0) {
					s1_val = exe_value.top();
					exe_value.pop();
					exe_type.pop();
					thrust::device_ptr<int_type> res = thrust::device_malloc<int_type>(a->mRecCount);
					thrust::transform(a->d_columns_int[s1_val].begin(), a->d_columns_int[s1_val].begin() + a->mRecCount, res, _1/100);
					exe_precision.push(0);
					exe_vectors.push(thrust::raw_pointer_cast(res));
					exe_type.push("NAME");
					exe_value.push("");
				}
				else				
                if (ss.compare("YEAR") == 0) {
                    s1_val = exe_value.top();
                    exe_value.pop();
                    exe_type.pop();
                    thrust::device_ptr<int_type> res = thrust::device_malloc<int_type>(a->mRecCount);
                    if(a->ts_cols[s1_val]) {
                        thrust::counting_iterator<unsigned int> begin(0);
                        gpu_getyear ff((const int_type*)thrust::raw_pointer_cast(a->d_columns_int[s1_val].data()),	thrust::raw_pointer_cast(res));
                        thrust::for_each(begin, begin + a->mRecCount, ff);
                        exe_precision.push(0);
                    }
                    else {
                        thrust::transform(a->d_columns_int[s1_val].begin(), a->d_columns_int[s1_val].begin() + a->mRecCount, thrust::make_constant_iterator(10000), res, thrust::divides<int_type>());
                        exe_precision.push(a->decimal_zeroes[s1_val]);
                    };
                    exe_vectors.push(thrust::raw_pointer_cast(res));
                    exe_type.push("NAME");
                    exe_value.push("");
                }
                else
                    if (ss.compare("MONTH") == 0) {
                        s1_val = exe_value.top();
                        exe_value.pop();
                        exe_type.pop();
                        thrust::device_ptr<int_type> res = thrust::device_malloc<int_type>(a->mRecCount);
                        thrust::counting_iterator<unsigned int> begin(0);
                        gpu_getmonth ff((const int_type*)thrust::raw_pointer_cast(a->d_columns_int[s1_val].data()),	thrust::raw_pointer_cast(res));
                        thrust::for_each(begin, begin + a->mRecCount, ff);
                        exe_precision.push(0);
                        exe_vectors.push(thrust::raw_pointer_cast(res));
                        exe_type.push("NAME");
                        exe_value.push("");
                    }
                    else
                        if (ss.compare("DAY") == 0) {
                            s1_val = exe_value.top();
                            exe_value.pop();
                            exe_type.pop();
                            thrust::device_ptr<int_type> res = thrust::device_malloc<int_type>(a->mRecCount);
                            thrust::counting_iterator<unsigned int> begin(0);
                            gpu_getday ff((const int_type*)thrust::raw_pointer_cast(a->d_columns_int[s1_val].data()),	thrust::raw_pointer_cast(res));
                            thrust::for_each(begin, begin + a->mRecCount, ff);
                            exe_precision.push(0);
                            exe_vectors.push(thrust::raw_pointer_cast(res));
                            exe_type.push("NAME");
                            exe_value.push("");
                        }


                        else
                            if (ss.compare("DISTINCT") == 0) {
                                s1_val = exe_value.top();
                                exe_type.pop();
                                exe_value.pop();

                                if(a->type[s1_val] == 0) {

                                    thrust::copy(a->d_columns_int[s1_val].begin(), a->d_columns_int[s1_val].begin() + a->mRecCount,
                                                 distinct_tmp[dist_processed].begin());
                                    dist_processed++;
                                    thrust::device_ptr<int_type> res = thrust::device_malloc<int_type>(res_size);
                                    exe_vectors.push(thrust::raw_pointer_cast(res));
                                    exe_type.push("NAME");
                                    exe_value.push("");
                                }
                                else
                                    if(a->type[s1_val] == 2) {
                                        //will add a DISTINCT on strings if anyone needs it
                                        cout << "DISTINCT on strings is not supported yet" << endl;
                                        exit(0);
                                    }
                                    else {
                                        cout << "DISTINCT on float is not supported yet" << endl;
                                        exit(0);
                                    };
                            }

                            else
                                if (ss.compare("COUNT") == 0) {

                                    s1 = exe_type.top();
                                    //if(s1.compare("NAME") != 0) {  // non distinct

                                    grp_type = "COUNT";
                                    exe_type.pop();
                                    s1_val = exe_value.top();
                                    exe_value.pop();


                                    if (a->grp_count > 1) {
                                        thrust::device_ptr<int_type> count_diff = thrust::device_malloc<int_type>(res_size);
                                        if(alloced_mem.empty()) {
                                            alloc_pool(a->maxRecs);
                                        };
                                        thrust::device_ptr<int_type> const_seq((int_type*)alloced_mem.back());
                                        thrust::fill(const_seq, const_seq+a->mRecCount, (int_type)1);
                                        segreduce(thrust::raw_pointer_cast(const_seq), a->mRecCount, (int*)thrust::raw_pointer_cast(a->grp.data()), a->grp.size(), thrust::raw_pointer_cast(count_diff), plus_t<int_type>(), (int_type)0, context);
                                        exe_vectors.push(thrust::raw_pointer_cast(count_diff));
                                        exe_type.push("NAME");
                                    }
                                    else {
                                        thrust::device_ptr<int_type> dest  = thrust::device_malloc<int_type>(1);
                                        dest[0] = a->mRecCount;
                                        exe_vectors.push(thrust::raw_pointer_cast(dest));
                                        exe_type.push("NAME");
                                    };
                                    //    }
                                    //     else
                                    //         grp_type = "COUNTD";
                                    exe_precision.push(0);
                                    exe_value.push("");
                                }
                                else
                                    if (ss.compare("SUM") == 0) {

                                        /*if(op_case) {
                                        	cout << "found case " << endl;
                                        	op_case = 0;
                                        	while(!exe_type.empty())
                                        	{
                                        	cout << "CASE type " << exe_type.top() << endl;
                                        	exe_type.pop();
                                        	exit(0);
                                        	}

                                        };
                                        */

                                        grp_type = "SUM";
                                        s1 = exe_type.top();
                                        exe_type.pop();
                                        s1_val = exe_value.top();
                                        exe_value.pop();


                                        if(std::find(a->columnNames.begin(), a->columnNames.end(), s1_val) == a->columnNames.end()) {
                                            int_type* s3 = exe_vectors.top();
                                            exe_vectors.pop();

                                            if (a->grp_count > 1) {
                                                thrust::device_ptr<int_type> count_diff = thrust::device_malloc<int_type>(res_size);
                                                segreduce(s3, a->mRecCount, (int*)thrust::raw_pointer_cast(a->grp.data()), a->grp.size(), thrust::raw_pointer_cast(count_diff), plus_t<int_type>(), (int_type)0, context);
                                                exe_vectors.push(thrust::raw_pointer_cast(count_diff));
                                            }
                                            else {
                                                thrust::device_ptr<int_type> count_diff = thrust::device_malloc<int_type>(1);
                                                reduce(s3, a->mRecCount,  thrust::raw_pointer_cast(count_diff), plus_t<int_type>(), context);
                                                exe_vectors.push(thrust::raw_pointer_cast(count_diff));
                                            };
                                            cudaFree(s3);
                                        }
                                        else  {
                                            if (a->grp_count > 1) {
                                                thrust::device_ptr<int_type> count_diff = thrust::device_malloc<int_type>(res_size);
                                                segreduce(thrust::raw_pointer_cast(a->d_columns_int[s1_val].data()), a->mRecCount, (int*)thrust::raw_pointer_cast(a->grp.data()), a->grp.size(), thrust::raw_pointer_cast(count_diff), plus_t<int_type>(), (int_type)0, context);
                                                exe_vectors.push(thrust::raw_pointer_cast(count_diff));
                                            }
                                            else {
                                                thrust::device_ptr<int_type> dest;
                                                thrust::device_ptr<int_type> count_diff = thrust::device_malloc<int_type>(res_size);
                                                reduce(thrust::raw_pointer_cast(a->d_columns_int[s1_val].data()), a->mRecCount,  thrust::raw_pointer_cast(count_diff), plus_t<int_type>(), context);
                                                if (one_line) {
                                                    dest = thrust::device_malloc<int_type>(1);
                                                    dest[0] = count_diff[0];
                                                }
                                                else {
                                                    dest = thrust::device_malloc<int_type>(a->mRecCount);
                                                    int_type cc = count_diff[0];
                                                    thrust::sequence(dest, dest+(a->mRecCount), cc, (int_type)0);
                                                };
                                                exe_vectors.push(thrust::raw_pointer_cast(dest));

                                            };
                                            exe_precision.push(get_decimals(a, s1_val, exe_precision));
                                        }
                                        exe_type.push("NAME");
                                        exe_value.push("");
                                    }
                                    else
                                        if (ss.compare("MIN") == 0) {
                                            grp_type = "MIN";
                                            s1 = exe_type.top();
                                            exe_type.pop();
                                            s1_val = exe_value.top();
                                            exe_value.pop();
                                            thrust::device_ptr<int_type> count_diff = thrust::device_malloc<int_type>(res_size);

                                            if(std::find(a->columnNames.begin(), a->columnNames.end(), s1_val) != a->columnNames.end()) {
                                                if (a->grp_count > 1) {
                                                    segreduce(thrust::raw_pointer_cast(a->d_columns_int[s1_val].data()), a->mRecCount, (int*)thrust::raw_pointer_cast(a->grp.data()), a->grp.size(), thrust::raw_pointer_cast(count_diff), minimum_t<int_type>(), (int_type)0, context);
                                                }
                                                else {
                                                    reduce(thrust::raw_pointer_cast(a->d_columns_int[s1_val].data()), a->mRecCount,  thrust::raw_pointer_cast(count_diff), minimum_t<int_type>(), context);
                                                };
                                            }
                                            else {
                                                int_type* s3 = exe_vectors.top();
                                                exe_vectors.pop();
                                                if (a->grp_count > 1) {
                                                    segreduce(s3, a->mRecCount, (int*)thrust::raw_pointer_cast(a->grp.data()), a->grp.size(), thrust::raw_pointer_cast(count_diff), minimum_t<int_type>(), (int_type)0, context);
                                                }
                                                else {
                                                    reduce(s3, a->mRecCount,  thrust::raw_pointer_cast(count_diff), minimum_t<int_type>(), context);
                                                };
                                                cudaFree(s3);
                                            };

                                            exe_vectors.push(thrust::raw_pointer_cast(count_diff));
                                            exe_type.push("NAME");
                                            exe_value.push("");
                                            exe_precision.push(get_decimals(a, s1_val, exe_precision));
                                        }
                                        else
                                            if (ss.compare("MAX") == 0) {
                                                grp_type = "MAX";
                                                s1 = exe_type.top();
                                                exe_type.pop();
                                                s1_val = exe_value.top();
                                                exe_value.pop();
                                                thrust::device_ptr<int_type> count_diff = thrust::device_malloc<int_type>(res_size);

                                                if(std::find(a->columnNames.begin(), a->columnNames.end(), s1_val) != a->columnNames.end()) {
                                                    if (a->grp_count > 1) {
                                                        segreduce(thrust::raw_pointer_cast(a->d_columns_int[s1_val].data()), a->mRecCount, (int*)thrust::raw_pointer_cast(a->grp.data()), a->grp.size(), thrust::raw_pointer_cast(count_diff), maximum_t<int_type>(), (int_type)0, context);
                                                    }
                                                    else {
                                                        reduce(thrust::raw_pointer_cast(a->d_columns_int[s1_val].data()), a->mRecCount,  thrust::raw_pointer_cast(count_diff), maximum_t<int_type>(), context);
                                                    };
                                                }
                                                else {
                                                    int_type* s3 = exe_vectors.top();
                                                    exe_vectors.pop();
                                                    if (a->grp_count > 1) {
                                                        segreduce(s3, a->mRecCount, (int*)thrust::raw_pointer_cast(a->grp.data()), a->grp.size(), thrust::raw_pointer_cast(count_diff), maximum_t<int_type>(), (int_type)0, context);
                                                    }
                                                    else {
                                                        reduce(s3, a->mRecCount,  thrust::raw_pointer_cast(count_diff), maximum_t<int_type>(), context);
                                                    };
                                                    cudaFree(s3);
                                                };

                                                exe_vectors.push(thrust::raw_pointer_cast(count_diff));
                                                exe_type.push("NAME");
                                                exe_value.push("");
                                                exe_precision.push(get_decimals(a, s1_val, exe_precision));
                                            }

                                            else
                                                if (ss.compare("AVG") == 0) {

                                                    grp_type = "AVG";
                                                    s1 = exe_type.top();
                                                    exe_type.pop();
                                                    s1_val = exe_value.top();
                                                    exe_value.pop();
                                                    thrust::device_ptr<int_type> count_diff = thrust::device_malloc<int_type>(res_size);

                                                    if(std::find(a->columnNames.begin(), a->columnNames.end(), s1_val) != a->columnNames.end()) {
                                                        if (a->grp_count > 1) {
                                                            segreduce(thrust::raw_pointer_cast(a->d_columns_int[s1_val].data()), a->mRecCount, (int*)thrust::raw_pointer_cast(a->grp.data()), a->grp.size(), thrust::raw_pointer_cast(count_diff), plus_t<int_type>(), (int_type)0, context);
                                                        }
                                                        else {
                                                            reduce(thrust::raw_pointer_cast(a->d_columns_int[s1_val].data()), a->mRecCount,  thrust::raw_pointer_cast(count_diff), plus_t<int_type>(), context);
                                                        };
                                                    }
                                                    else {
                                                        int_type* s3 = exe_vectors.top();
                                                        exe_vectors.pop();
                                                        if (a->grp_count > 1) {
                                                            segreduce(s3, a->mRecCount, (int*)thrust::raw_pointer_cast(a->grp.data()), a->grp.size(), thrust::raw_pointer_cast(count_diff), plus_t<int_type>(), (int_type)0, context);
                                                        }
                                                        else {
                                                            reduce(s3, a->mRecCount,  thrust::raw_pointer_cast(count_diff), plus_t<int_type>(), context);
                                                        }
                                                        cudaFree(s3);
                                                    };

                                                    exe_vectors.push(thrust::raw_pointer_cast(count_diff));
                                                    exe_type.push("NAME");
                                                    exe_value.push("");
                                                    exe_precision.push(get_decimals(a, s1_val, exe_precision));
                                                };
            };

            if (ss.compare("NAME") == 0 || ss.compare("NUMBER") == 0 ) {

                exe_type.push(ss);
                if (ss.compare("NUMBER") == 0) {
                    exe_nums.push(op_nums.front());
                    op_nums.pop();
                    exe_precision.push(op_nums_precision.front());
                    op_nums_precision.pop();
                }
                else
                    if (ss.compare("NAME") == 0) {
                        exe_value.push(op_value.front());
                        ts = a->ts_cols[op_value.front()];
                        op_value.pop();
                    }
            }
            else {
                if (ss.compare("MUL") == 0  || ss.compare("ADD") == 0 || ss.compare("DIV") == 0 || ss.compare("MINUS") == 0) {
                    // get 2 values from the stack
                    s1 = exe_type.top();
                    exe_type.pop();
                    s2 = exe_type.top();
                    exe_type.pop();

                    if (s1.compare("NUMBER") == 0 && s2.compare("NUMBER") == 0) {
                        n1 = exe_nums.top();
                        exe_nums.pop();
                        n2 = exe_nums.top();
                        exe_nums.pop();

                        auto p1 = exe_precision.top();
                        exe_precision.pop();
                        auto p2 = exe_precision.top();
                        exe_precision.pop();
                        auto pres = precision_func(p1, p2, ss);
                        exe_precision.push(pres);
                        if(p1)
                            n1 = n1*(unsigned int)pow(10,p1);
                        if(p2)
                            n2 = n2*(unsigned int)pow(10,p2);

                        if (ss.compare("ADD") == 0 )
                            res = n1+n2;
                        else
                            if (ss.compare("MUL") == 0 )
                                res = n1*n2;
                            else
                                if (ss.compare("DIV") == 0 )
                                    res = n1/n2;
                                else
                                    res = n1-n2;

                        thrust::device_ptr<int_type> p = thrust::device_malloc<int_type>(a->mRecCount);
                        thrust::sequence(p, p+(a->mRecCount),res,(int_type)0);
                        exe_type.push("NAME");
                        exe_value.push("");
                        exe_vectors.push(thrust::raw_pointer_cast(p));
                    }

                    else
                        if (s1.compare("NAME") == 0 && s2.compare("NUMBER") == 0) {
                            s1_val = exe_value.top();
                            exe_value.pop();
                            n1 = exe_nums.top();
                            exe_nums.pop();
                            auto p1 = exe_precision.top();
                            exe_precision.pop();
                            auto p2 = get_decimals(a, s1_val, exe_precision);
                            int_type* t = get_vec(a, s1_val, exe_vectors);
                            auto pres = precision_func(p2, p1, ss);
                            exe_precision.push(pres);
                            exe_type.push("NAME");
                            exe_value.push("");
                            exe_vectors.push(a->op(t,n1,ss,1, p2, p1));
                        }
                        else
                            if (s1.compare("NUMBER") == 0 && s2.compare("NAME") == 0) {
                                n1 = exe_nums.top();
                                exe_nums.pop();
                                s1_val = exe_value.top();
                                exe_value.pop();
                                auto p1 = exe_precision.top();
                                exe_precision.pop();
                                auto p2 = get_decimals(a, s1_val, exe_precision);
                                int_type* t = get_vec(a, s1_val, exe_vectors);
                                auto pres = precision_func(p2, p1, ss);
                                exe_precision.push(pres);
                                exe_type.push("NAME");
                                exe_value.push("");
                                exe_vectors.push(a->op(t,n1,ss,0, p2, p1));
                            }
                            else
                                if (s1.compare("NAME") == 0 && s2.compare("NAME") == 0) {
                                    s1_val = exe_value.top();
                                    exe_value.pop();
                                    s2_val = exe_value.top();
                                    exe_value.pop();
                                    int_type* t1 = get_vec(a, s1_val, exe_vectors);
                                    int_type* t = get_vec(a, s2_val, exe_vectors);
                                    auto p1 = get_decimals(a, s1_val, exe_precision);
                                    auto p2 = get_decimals(a, s2_val, exe_precision);
                                    auto pres = precision_func(p1, p2, ss);
                                    exe_precision.push(pres);
                                    exe_type.push("NAME");
                                    exe_value.push("");
                                    exe_vectors.push(a->op(t,t1,ss,0,p2,p1));

                                }
                }
            }

        }
        else {
            // here we need to save what is where

            col_val.push(op_value.front());
            op_value.pop();
            grp_type1.push(grp_type);

            if(!exe_nums.empty()) {  //number
                col_type.push(0);
                exe_nums1.push(exe_nums.top());
                exe_nums.pop();
                exe_precision1.push(exe_precision.top());
                exe_precision.pop();
            };
            if(!exe_value.empty() && exe_value.top() != "") {  //field name
                col_type.push(1);
                exe_precision1.push(a->decimal_zeroes[exe_value.top()]);
                exe_value1.push(exe_value.top());
                exe_ts.push(ts);
                exe_value.pop();
            };
            if(!exe_vectors.empty()) {  //vector int
                exe_vectors1.push(exe_vectors.top());
                exe_vectors.pop();
                col_type.push(2);
                exe_precision1.push(exe_precision.top());
                exe_precision.pop();
                exe_value.pop();
            };
            colCount++;
        };
    };



    for(unsigned int j=0; j < colCount; j++) {

        if ((grp_type1.top()).compare("COUNT") == 0 )
            b->grp_type[col_val.top()] = 0;
        else
            if ((grp_type1.top()).compare("AVG") == 0 )
                b->grp_type[col_val.top()] = 1;
            else
                if ((grp_type1.top()).compare("SUM") == 0 )
                    b->grp_type[col_val.top()] = 2;
                else
                    if ((grp_type1.top()).compare("NULL") == 0 )
                        b->grp_type[col_val.top()] = 3;
                    else
                        if ((grp_type1.top()).compare("MIN") == 0 )
                            b->grp_type[col_val.top()] = 4;
                        else
                            if ((grp_type1.top()).compare("MAX") == 0 )
                                b->grp_type[col_val.top()] = 5;
                            else
                                if ((grp_type1.top()).compare("COUNTD") == 0 ) {
                                    b->grp_type[col_val.top()] = 6;
                                };

        if(col_type.top() == 0) {
            // create a vector
            if (a->grp_count) {
                thrust::device_ptr<int_type> count_diff = thrust::device_malloc<int_type>(res_size);
                thrust::gather(a->grp.begin(), a->grp.end(), thrust::make_constant_iterator((int)exe_nums1.top()), count_diff);
                b->addDeviceColumn(thrust::raw_pointer_cast(count_diff) , col_val.top(), res_size);
                thrust::device_free(count_diff);
            }
            else {
                thrust::device_ptr<int_type> s = thrust::device_malloc<int_type>(a->mRecCount);
                thrust::sequence(s, s+(a->mRecCount), (int)exe_nums1.top(), 0);
                b->addDeviceColumn(thrust::raw_pointer_cast(s), col_val.top(), a->mRecCount);
            }
            exe_nums1.pop();
            b->decimal_zeroes[col_val.top()] = exe_precision1.top();
            exe_precision1.pop();

        }
        else
            if(col_type.top() == 1) {

                //modify what we push there in case of a grouping
                if (a->grp_count) {
                    thrust::device_ptr<int_type> count_diff = thrust::device_malloc<int_type>(res_size);
                    if(!exe_ts.top()) {
                        thrust::gather(a->grp.begin(), a->grp.end(), a->d_columns_int[exe_value1.top()].begin(), count_diff);
                    }
                    else {

                        thrust::device_vector<unsigned int> dd_tmp(res_size);
                        thrust::gather(a->grp.begin(), a->grp.end(), rcol_matches.begin(), count_diff);
                        thrust::gather(dd_tmp.begin(), dd_tmp.end(), rcol_dev.begin(), count_diff);

                    };
                    b->addDeviceColumn(thrust::raw_pointer_cast(count_diff) ,  col_val.top(), res_size);
                    thrust::device_free(count_diff);
                }
                else
                    b->addDeviceColumn(thrust::raw_pointer_cast(a->d_columns_int[exe_value1.top()].data()) , col_val.top(), a->mRecCount);

                if(a->type[exe_value1.top()] == 0) {
                    b->decimal_zeroes[col_val.top()] = exe_precision1.top();
                    b->ts_cols[col_val.top()] = exe_ts.top();
                };

                if(a->type[exe_value1.top()] == 2 || (a->type[exe_value1.top()] == 0 && a->string_map.find(exe_value1.top()) != a->string_map.end())) {
                    b->string_map[col_val.top()] = a->string_map[exe_value1.top()];
                };
                exe_precision1.pop();
                exe_ts.pop();
                exe_value1.pop();
            }
            else
                if(col_type.top() == 2) {	    // int

                    if (a->grp_count)
                        b->addDeviceColumn(exe_vectors1.top() , col_val.top(), res_size);
                    else {
                        if(!one_line)
                            b->addDeviceColumn(exe_vectors1.top() , col_val.top(), a->mRecCount);
                        else
                            b->addDeviceColumn(exe_vectors1.top() , col_val.top(), 1);
                    };
                    cudaFree(exe_vectors1.top());
                    exe_vectors1.pop();
                    b->decimal_zeroes[col_val.top()] = exe_precision1.top();
                    exe_precision1.pop();

                }
        col_type.pop();
        col_val.pop();
        grp_type1.pop();
    };

    if (!a->grp_count) {
        if(!one_line)
            b->mRecCount = a->mRecCount;
        else
            b->mRecCount = 1;
        return one_line;
    }
    else {
        b->mRecCount = res_size;
        return 0;
    };
}


