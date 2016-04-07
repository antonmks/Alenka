#ifndef SELECT_H_
#define SELECT_H_

#include "global.h"
#include "CudaSet.h"
#include "zone_map.h"
#include "util.cuh"
#include "select.cuh"

void select(queue<string> op_type, queue<string> op_value, queue<int_type> op_nums, queue<float_type> op_nums_f, queue<unsigned int> op_nums_precision, CudaSet* a,
            CudaSet* b, vector<thrust::device_vector<int_type> >& distinct_tmp, bool& one_liner);


#endif /* SELECT_H_ */
