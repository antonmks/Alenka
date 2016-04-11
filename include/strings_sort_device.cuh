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

#ifndef STRING_SORT_DEVICE_CUH_
#define STRING_SORT_DEVICE_CUH_

namespace alenka {

/// The conversion between big endian and little endian, it need for sort strings as like fundamental types
struct T_swap_le_be_64 {
	__host__ __device__
	inline unsigned long long operator()(unsigned long long const& val) const {
		return ((((unsigned long long)255 << (8*7)) & val) >> (8*7)) |
			((((unsigned long long)255 << (8*6)) & val) >> (8*5)) |
			((((unsigned long long)255 << (8*5)) & val) >> (8*3)) |
			((((unsigned long long)255 << (8*4)) & val) >> (8*1)) |
			((((unsigned long long)255 << (8*3)) & val) << (8*1)) |
			((((unsigned long long)255 << (8*2)) & val) << (8*3)) |
			((((unsigned long long)255 << (8*1)) & val) << (8*5)) |
			((((unsigned long long)255 << (8*0)) & val) << (8*7));
	}
};

struct T_swap_le_be_32 {
	__host__ __device__
	inline unsigned int operator()(unsigned int const& val) const {
		return ((val >> 24)) |			// move byte 3 to byte 0
				((val << 8)&0xff0000) |	// move byte 1 to byte 2
				((val >> 8)&0xff00) |	// move byte 2 to byte 1
				((val << 24));			// byte 0 to byte 3
	}
};

struct T_swap_le_be_16 {
	__host__ __device__
	inline unsigned short int operator()(unsigned short int const& val) const {
		return (val << 8) |		// move byte 0 to byte 1
				(val >> 8);		// move byte 1 to byte 0
	}
};

struct T_swap_le_be_8 {
	__host__ __device__
	inline unsigned char operator()(unsigned char const& val) const { return val; }
};

} // namespace alenka

#endif /* STRING_SORT_DEVICE_CUH_ */
