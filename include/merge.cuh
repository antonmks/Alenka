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

#ifndef MERGE_CUH_
#define MERGE_CUH_

#include "types.h"

namespace alenka {

struct float_avg {
    __host__
    float_type operator()(const float_type &lhs, const int_type &rhs) const {
        return lhs/rhs;
    }
};

struct float_avg1 {
    __host__
    float_type operator()(const int_type &lhs, const int_type &rhs) const {
        return ((float_type)lhs)/rhs;
    }
};

struct div100 {
    __host__
    int_type operator()(const int_type &lhs, const int_type &rhs) const {
        return (lhs*100)/rhs;
    }
};

} // namespace alenka

#endif /* MERGE_CUH_ */
