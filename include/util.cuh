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

#ifndef UTIL_H_
#define UTIL_H_

#include "types.h"
#include "thrust.h"

namespace alenka {

struct f_equal_to {
	__host__ __device__
	bool operator()(const float_type x, const float_type y) {
		return (((x - y) < EPSILON) && ((x - y) > -EPSILON));
	}
};

struct f_less {
	__host__ __device__
	bool operator()(const float_type x, const float_type y) {
		return ((y - x) > EPSILON);
	}
};

struct f_greater {
	__host__ __device__
	bool operator()(const float_type x, const float_type y) {
		return ((x - y) > EPSILON);
	}
};

struct f_greater_equal_to {
	__host__ __device__
	bool operator()(const float_type x, const float_type y) {
		return (((x - y) > EPSILON)
				|| (((x - y) < EPSILON) && ((x - y) > -EPSILON)));
	}
};

struct f_less_equal {
	__host__ __device__
	bool operator()(const float_type x, const float_type y) {
		return (((y - x) > EPSILON)
				|| (((x - y) < EPSILON) && ((x - y) > -EPSILON)));
	}
};

struct f_not_equal_to {
	__host__ __device__
	bool operator()(const float_type x, const float_type y) {
		return ((x - y) > EPSILON) || ((x - y) < -EPSILON);
	}
};

struct long_to_float_type {
	__host__ __device__ float_type operator()(const int_type x) {
		return (float_type) x;
	}
};

template<typename T>
struct power_functor: public thrust::unary_function<T, T> {
	unsigned int a;

	__host__ __device__ power_functor(unsigned int a_) {
		a = a_;
	}

	__host__ __device__ T operator()(T x) {
		return x * (unsigned int) pow((double) 10, (double) a);
	}
};

struct is_zero {
	__host__ __device__
	bool operator()(const int &x) {
		return x == 0;
	}
};

struct is_even {
	__host__ __device__
	bool operator()(const int &x) {
		return (x % 2) == 0;
	}
};

template<typename T>
struct uninitialized_host_allocator: std::allocator<T> {
	// note that construct is annotated as
	__host__
	void construct(T *p) {
		// no-op
	}
};

template<typename T>
struct uninitialized_allocator: thrust::device_malloc_allocator<T> {
	// note that construct is annotated as
	// a __host__ __device__ function
	__host__ __device__
	void construct(T *p) {
		// no-op
	}
};

struct set_minus: public thrust::binary_function<int, bool, int> {
	/*! Function call operator. The return value is <tt>lhs + rhs</tt>.
	 */
	__host__ __device__ int operator()(const int &lhs, const bool &rhs) const {
		if (rhs)
			return lhs;
		else
			return -1;
	}
};

template<typename HeadFlagType>
struct head_flag_predicate: public thrust::binary_function<HeadFlagType,
		HeadFlagType, bool> {
	__host__ __device__
	bool operator()(HeadFlagType left, HeadFlagType right) const {
		return !left;
	}
};

struct float_to_long {
	__device__
	long long int operator()(const float_type x) {
		return __double2ll_rn(x * 100);
	}
};

struct decrease {
	__device__
	unsigned int operator()(const unsigned int x) {
		if (x > 0)
			return x - 1;
		else
			return x;
	}
};

struct float_equal_to {
	__device__
	bool operator()(const float_type &lhs, const float_type &rhs) const {
		return (__double2ll_rn(lhs * 100) == __double2ll_rn(rhs * 100));
	}
};

struct int_upper_equal_to {
	/*! Function call operator. The return value is <tt>lhs == rhs</tt>.
	 */
	__host__ __device__ bool operator()(const int_type &lhs,
			const int_type &rhs) const {
		return (lhs >> 32) == (rhs >> 32);
	}
};

struct float_upper_equal_to {
	/*! Function call operator. The return value is <tt>lhs == rhs</tt>.
	 */
	__host__ __device__ bool operator()(const float_type &lhs,
			const float_type &rhs) const {
		return ((int_type) lhs >> 32) == ((int_type) rhs >> 32);
	}
};

struct long_to_float {
	__host__ __device__ float_type operator()(const long long int x) {
		return (((float_type) x) / 100.0);
	}
};

struct is_break {
	__host__ __device__
	bool operator()(const char x) {
		return x == '\n';
	}
};

struct gpu_interval_char {
	const long long int *dt1;
	long long int *dt2;
	const char *index;
	const unsigned int* len;

	gpu_interval_char(const long long int *_dt1, long long int *_dt2,
			const char* _index, const unsigned int* _len) :
			dt1(_dt1), dt2(_dt2), index(_index), len(_len) {
	}
	template<typename IndexType>
	__host__ __device__
	void operator()(const IndexType & i) {
		bool test = 1;
		if (dt2[i] == 0) {
			for (int z = 0; z < *len; z++) {
				if (index[i * (*len) + z] != index[(i + 1) * (*len) + z]) {
					test = 0;
					break;
				}
			}
		}
		if (test)
			dt2[i] = dt1[i + 1];
	}
};

struct gpu_interval {
	const long long int *dt1;
	long long int *dt2;
	const long long int *index;

	gpu_interval(const long long int *_dt1, long long int *_dt2,
			const long long int* _index) :
			dt1(_dt1), dt2(_dt2), index(_index) {
	}
	template<typename IndexType>
	__host__ __device__
	void operator()(const IndexType & i) {
		if (dt2[i] == 0 && index[i + 1] == index[i])
			dt2[i] = dt1[i + 1];
	}
};

struct gpu_interval_set {
	const long long int *dt1;
	long long int *dt2;
	const long long int *index1;
	const long long int *index2;
	const unsigned int* bs;

	gpu_interval_set(const long long int *_dt1, long long int *_dt2,
			const long long int* _index1, const long long int* _index2,
			const unsigned int* _bs) :
			dt1(_dt1), dt2(_dt2), index1(_index1), index2(_index2), bs(_bs) {
	}
	template<typename IndexType>
	__host__ __device__
	void operator()(const IndexType & i) {
		//printf("T %d %lld %lld %lld %lld %d %lld \n", i, dt1[i], dt2[i], index1[i], index2[bs[index1[i]]], bs[index1[i]], index2[i]);
		if (dt2[i] == 0 && index1[i] == index2[bs[i]]) {
			dt2[i] = dt1[bs[i]];
		}
	}
};

struct gpu_date {
	const char *source;
	long long int *dest;

	gpu_date(const char *_source, long long int *_dest) :
			source(_source), dest(_dest) {
	}
	template<typename IndexType>
	__host__ __device__
	void operator()(const IndexType & i) {
		const char *s;
		long long int acc;
		int z = 0, c;

		s = source + 23 * i;
		c = (unsigned char) *s++;

		for (acc = 0; z < 10; c = (unsigned char) *s++) {
			if (c != '-') {
				c -= '0';
				acc *= 10;
				acc += c;
			}
			z++;
		}
		dest[i] = acc;
	}
};

struct gpu_tdate {
	const char *source;
	long long int *dest;

	gpu_tdate(const char *_source, long long int *_dest) :
			source(_source), dest(_dest) {
	}
	template<typename IndexType>
	__host__ __device__
	void operator()(const IndexType & i) {
		const char *s;
		long long int acc;
		int z = 0, c;
		int y, m, d, h, min, sec, ms;
		bool year_set = 0;

		s = source + 23 * i;
		c = (unsigned char) *s++;

		for (acc = 0; z < 10; c = (unsigned char) *s++) {
			if (c != '-') {
				c -= '0';
				acc *= 10;
				acc += c;
			} else {
				if (!year_set) {
					y = acc;
					year_set = 1;
				} else {
					m = acc;
				}
				acc = 0;
			}
			z++;
		}

		d = acc;

		c = (unsigned char) s[0];
		c -= '0';
		h = c * 10;
		c = (unsigned char) s[1];
		c -= '0';
		h = h + c;

		c = (unsigned char) s[3];
		c -= '0';
		min = c * 10;
		c = (unsigned char) s[4];
		c -= '0';
		min = min + c;

		c = (unsigned char) s[6];
		c -= '0';
		sec = c * 10;
		c = (unsigned char) s[7];
		c -= '0';
		sec = sec + c;

		c = (unsigned char) s[9];
		c -= '0';
		ms = c * 100;
		c = (unsigned char) s[10];
		c -= '0';
		ms = ms + c * 10;
		c = (unsigned char) s[11];
		c -= '0';
		ms = ms + c;

		y -= m <= 2;
		const int era = (y >= 0 ? y : y - 399) / 400;
		const unsigned yoe = static_cast<unsigned>(y - era * 400);   // [0, 399]
		const unsigned doy = (153 * (m + (m > 2 ? -3 : 9)) + 2) / 5 + d - 1; // [0, 365]
		const unsigned doe = yoe * 365 + yoe / 4 - yoe / 100 + doy; // [0, 146096]
		dest[i] =
				(long long int) (era * 146097 + static_cast<int>(doe) - 719468)
						* 24 * 60 * 60 * 1000
						+ (long long int) h * 60 * 60 * 1000
						+ (long long int) min * 60 * 1000
						+ (long long int) sec * 1000 + (long long int) ms;
	}
};

struct gpu_atof {
	const char *source;
	double *dest;
	const unsigned int *len;

	gpu_atof(const char *_source, double *_dest, const unsigned int *_len) :
			source(_source), dest(_dest), len(_len) {
	}
	template<typename IndexType>
	__host__ __device__
	void operator()(const IndexType & i) {
		const char *p;
		int frac;
		double sign, value, scale;

		p = source + len[0] * i;

		while (*p == ' ') {
			p += 1;
		}

		sign = 1.0;
		if (*p == '-') {
			sign = -1.0;
			p += 1;
		} else if (*p == '+') {
			p += 1;
		}

		for (value = 0.0; *p >= '0' && *p <= '9'; p += 1) {
			value = value * 10.0 + (*p - '0');
		}

		if (*p == '.') {
			double pow10 = 10.0;
			p += 1;
			while (*p >= '0' && *p <= '9') {
				value += (*p - '0') / pow10;
				pow10 *= 10.0;
				p += 1;
			}
		}

		frac = 0;
		scale = 1.0;

		dest[i] = sign * (frac ? (value / scale) : (value * scale));
	}
};

struct gpu_atod {
	const char *source;
	int_type *dest;
	const unsigned int *len;
	const unsigned int *sc;

	gpu_atod(const char *_source, int_type *_dest, const unsigned int *_len,
			const unsigned int *_sc) :
			source(_source), dest(_dest), len(_len), sc(_sc) {
	}
	template<typename IndexType>
	__host__ __device__
	void operator()(const IndexType & i) {
		const char *p;
		int frac;
		double sign, value, scale;

		p = source + len[0] * i;

		while (*p == ' ') {
			p += 1;
		}

		sign = 1.0;
		if (*p == '-') {
			sign = -1.0;
			p += 1;
		} else if (*p == '+') {
			p += 1;
		}

		for (value = 0.0; *p >= '0' && *p <= '9'; p += 1) {
			value = value * 10.0 + (*p - '0');
		}

		if (*p == '.') {
			double pow10 = 10.0;
			p += 1;
			while (*p >= '0' && *p <= '9') {
				value += (*p - '0') / pow10;
				pow10 *= 10.0;
				p += 1;
			}
		}

		frac = 0;
		scale = 1.0;

		dest[i] = (sign * (frac ? (value / scale) : (value * scale))) * sc[0];
	}
};

struct gpu_atold {
	const char *source;
	long long int *dest;
	const unsigned int *len;
	const unsigned int *sc;

	gpu_atold(const char *_source, long long int *_dest,
			const unsigned int *_len, const unsigned int *_sc) :
			source(_source), dest(_dest), len(_len), sc(_sc) {
	}
	template<typename IndexType>
	__host__ __device__
	void operator()(const IndexType & i) {
		const char *s;
		long long int acc;
		int c;
		int neg;
		int point = 0;
		bool cnt = 0;

		s = source + len[0] * i;

		do {
			c = (unsigned char) *s++;
		} while (c == ' ');

		if (c == '-') {
			neg = 1;
			c = *s++;
		} else {
			neg = 0;
			if (c == '+')
				c = *s++;
		}

		for (acc = 0;; c = (unsigned char) *s++) {
			if (c >= '0' && c <= '9') {
				c -= '0';
			} else {
				if (c != '.')
					break;
				cnt = 1;
				continue;
			}
			if (c >= 10)
				break;
			if (neg) {
				acc *= 10;
				acc -= c;
			} else {
				acc *= 10;
				acc += c;
			}
			if (cnt)
				point++;
			if (point == sc[0])
				break;
		}
		dest[i] = acc * (unsigned int) exp10((double) sc[0] - point);
	}
};

struct gpu_atoll {
	const char *source;
	long long int *dest;
	const unsigned int *len;

	gpu_atoll(const char *_source, long long int *_dest,
			const unsigned int *_len) :
			source(_source), dest(_dest), len(_len) {
	}
	template<typename IndexType>
	__host__ __device__
	void operator()(const IndexType & i) {
		const char *s;
		long long int acc;
		int c;
		int neg;

		s = source + len[0] * i;

		do {
			c = (unsigned char) *s++;
		} while (c == ' ');

		if (c == '-') {
			neg = 1;
			c = *s++;
		} else {
			neg = 0;
			if (c == '+')
				c = *s++;
		}

		for (acc = 0;; c = (unsigned char) *s++) {
			if (c >= '0' && c <= '9')
				c -= '0';
			else
				break;
			if (c >= 10)
				break;
			if (neg) {
				acc *= 10;
				acc -= c;
			} else {
				acc *= 10;
				acc += c;
			}
		}
		dest[i] = acc;
	}
};

struct parse_functor
{
	const char *source;
    char **dest;
    const unsigned int *ind;
	const unsigned int *cnt;
	const char *separator;
	const long long int *src_ind;
	const unsigned int *dest_len;

    parse_functor(const char* _source, char** _dest, const unsigned int* _ind, const unsigned int* _cnt, const char* _separator,
				  const long long int* _src_ind, const unsigned int* _dest_len):
        source(_source), dest(_dest), ind(_ind), cnt(_cnt),  separator(_separator), src_ind(_src_ind), dest_len(_dest_len) {}

    template <typename IndexType>
    __host__ __device__
    void operator()(const IndexType & i) {
		unsigned int curr_cnt = 0, dest_curr = 0, j = 0, t, pos;
		bool open_quotes = 0;
		pos = src_ind[i]+1;
		
		while(dest_curr < *cnt) {
			if(ind[dest_curr] == curr_cnt) { //process				
				t = 0;
				while(source[pos+j] != *separator || open_quotes) {
					//printf("REG %d ", j);
					if(source[pos+j] == '"') {						
						open_quotes = !open_quotes;						
					};
					if(source[pos+j] != 0) {
						dest[dest_curr][dest_len[dest_curr]*i+t] = source[pos+j];
						t++;
					};	
					j++;					
				};
				j++;
				dest_curr++;				
			}
			else {
				//printf("Skip %d \n", j);
				while(source[pos+j] != *separator || open_quotes) {
					if(source[pos+j] == '"') {						
						open_quotes = !open_quotes;						
					};	
					j++;
					//printf("CONT Skip %d \n", j);
				};	
				j++;
			};
			curr_cnt++;			
			//printf("DEST CURR %d %d %d %d \n" , j, dest_curr, ind[dest_curr], curr_cnt);
		}
		
    }
};

struct split_int2
{
	int *v1;
    int *v2;
	const int2 *source;
		
	split_int2(int *_v1, int *_v2, const int2* _source):
			  v1(_v1), v2(_v2), source(_source) {}
    template <typename IndexType>
    __host__ __device__
    void operator()(const IndexType & i) {	
	
		v1[i] = source[i].x;
		v2[i] = source[i].y;
	}
};	

} // namespace alenka

#endif /* UTIL_H_ */
