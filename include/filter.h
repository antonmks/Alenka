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

#ifndef FILTER_H_
#define FILTER_H_

#include <string>
#include <queue>
#include <math.h>
#include <time.h>

#include "global.h"
#include "common.h"
#include "cudaset.h"
#include "filter.cuh"
#include "zone_map.h"

namespace alenka {

unsigned int precision_vec2(unsigned int p1, unsigned int p2, int_type* n1, int_type& n2, string op, size_t cnt);
unsigned int precision_vec3(unsigned int p1, unsigned int p2, int_type* n1, int_type* n2, string op, size_t cnt);
bool* filter(queue<string> op_type, queue<string> op_value, queue<int_type> op_nums, queue<float_type> op_nums_f,
		queue<unsigned int> op_nums_precision, CudaSet* a, unsigned int segment);

} // namespace alenka

#endif /* FILTER_H_ */
