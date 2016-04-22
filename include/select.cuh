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

#include "types.h"

namespace alenka {

template<typename T>
struct distinct : public binary_function<T, T, T> {
    __host__ __device__ T operator()(const T &lhs, const T &rhs) const {
        return lhs != rhs;
    }
};

struct gpu_getyear {
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
		const uint daysSinceJan1st[2][13]= {
			{0, 31, 59, 90, 120, 151, 181, 212, 243, 273, 304, 334, 365}, // 365 days, non-leap
			{0, 31, 60, 91, 121, 152, 182, 213, 244, 274, 305, 335, 366}  // 366 days, leap
		};
		unsigned long long int SecondsSinceEpoch = source[i]/1000;
		sec = SecondsSinceEpoch + 11644473600;

		//wday = (uint)((sec / 86400 + 1) % 7); // day of week
		quadricentennials = (uint)(sec / 12622780800ULL); // 400*365.2425*24*3600
		sec %= 12622780800ULL;

		centennials = (uint)(sec / 3155673600ULL); // 100*(365+24/100)*24*3600
		if (centennials > 3) {
			centennials = 3;
		}
		sec -= centennials * 3155673600ULL;

		quadrennials = (uint)(sec / 126230400); // 4*(365+1/4)*24*3600
		if (quadrennials > 24) {
			quadrennials = 24;
		}
		sec -= quadrennials * 126230400ULL;

		annuals = (uint)(sec / 31536000); // 365*24*3600
		if (annuals > 3) {
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
		for (mday = month = 1; month < 13; month++) {
			if (yday < daysSinceJan1st[leap][month]) {
				mday += yday - daysSinceJan1st[leap][month - 1];
				break;
			}
		}
		dest[i] = year;
	}
};

struct gpu_getmonth {
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
		const uint daysSinceJan1st[2][13]= {
			{0, 31, 59, 90, 120, 151, 181, 212, 243, 273, 304, 334, 365}, // 365 days, non-leap
			{0, 31, 60, 91, 121, 152, 182, 213, 244, 274, 305, 335, 366}  // 366 days, leap
		};
		unsigned long long int SecondsSinceEpoch = source[i]/1000;
		sec = SecondsSinceEpoch + 11644473600;

		//wday = (uint)((sec / 86400 + 1) % 7); // day of week
		quadricentennials = (uint)(sec / 12622780800ULL); // 400*365.2425*24*3600
		sec %= 12622780800ULL;

		centennials = (uint)(sec / 3155673600ULL); // 100*(365+24/100)*24*3600
		if (centennials > 3) {
			centennials = 3;
		}
		sec -= centennials * 3155673600ULL;

		quadrennials = (uint)(sec / 126230400); // 4*(365+1/4)*24*3600
		if (quadrennials > 24) {
			quadrennials = 24;
		}
		sec -= quadrennials * 126230400ULL;

		annuals = (uint)(sec / 31536000); // 365*24*3600
		if (annuals > 3) {
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
		for (mday = month = 1; month < 13; month++) {
			if (yday < daysSinceJan1st[leap][month]) {
				mday += yday - daysSinceJan1st[leap][month - 1];
				break;
			}
		}
		dest[i] = year*100+month;
	}
};

struct gpu_getday {
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
		uint yday, hour, min;
		uint month, mday, wday;
		const uint daysSinceJan1st[2][13]= {
			{0, 31, 59, 90, 120, 151, 181, 212, 243, 273, 304, 334, 365}, // 365 days, non-leap
			{0, 31, 60, 91, 121, 152, 182, 213, 244, 274, 305, 335, 366}  // 366 days, leap
		};
		unsigned long long int SecondsSinceEpoch = source[i]/1000;
		sec = SecondsSinceEpoch + 11644473600;

		wday = (uint)((sec / 86400 + 1) % 7); // day of week
		quadricentennials = (uint)(sec / 12622780800ULL); // 400*365.2425*24*3600
		sec %= 12622780800ULL;

		centennials = (uint)(sec / 3155673600ULL); // 100*(365+24/100)*24*3600
		if (centennials > 3) {
			centennials = 3;
		}
		sec -= centennials * 3155673600ULL;

		quadrennials = (uint)(sec / 126230400); // 4*(365+1/4)*24*3600
		if (quadrennials > 24) {
			quadrennials = 24;
		}
		sec -= quadrennials * 126230400ULL;

		annuals = (uint)(sec / 31536000); // 365*24*3600
		if (annuals > 3) {
			annuals = 3;
		}
		sec -= annuals * 31536000ULL;

		year = 1601 + quadricentennials * 400 + centennials * 100 + quadrennials * 4 + annuals;
		leap = !(year % 4) && (year % 100 || !(year % 400));

		// Calculate the day of the year and the time
		yday = sec / 86400;
		sec %= 86400;
		hour = sec / 3600;
		sec %= 3600;
		min = sec / 60;
		sec %= 60;

		// Calculate the month
		for (mday = month = 1; month < 13; month++) {
			if (yday < daysSinceJan1st[leap][month]) {
				mday += yday - daysSinceJan1st[leap][month - 1];
				break;
			}
		}
		dest[i] = year*10000+month*100+mday;
	}
};

} // namespace alenka



