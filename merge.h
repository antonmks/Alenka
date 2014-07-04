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
#include <stdio.h>

void create_c(CudaSet* c, CudaSet* b);
void add(CudaSet* c, CudaSet* b, queue<string> op_v3, map<string,string> aliases,
		 vector<thrust::device_vector<int_type> >& distinct_tmp, vector<thrust::device_vector<int_type> >& distinct_val,
         vector<thrust::device_vector<int_type> >& distinct_hash, CudaSet* a);
void count_avg(CudaSet* c, vector<thrust::device_vector<int_type> >& distinct_hash);		 
void count_simple(CudaSet* c);