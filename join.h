#include "mgpu-master/util/cucpp.h"
#include "mgpu-master/inc/mgpusearch.h"
#include <climits>
#include "cm.h"


unsigned int join(int_type* d_input,int_type* d_values,
          thrust::device_vector<unsigned int>& d_res1, thrust::device_vector<unsigned int>& d_res2,
          unsigned int bRecCount, unsigned int aRecCount, bool left_join, searchEngine_t engine, CuDeviceMem* btree);
