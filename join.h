//#include "mgpu-master/util/cucpp.h"
//#include "mgpu-master/inc/mgpusearch.h"
#include <thrust/binary_search.h>
#include <climits>
#include "cm.h"


unsigned int join(int_type* right,int_type* left,
				  thrust::device_vector<unsigned int>& d_res1, thrust::device_vector<unsigned int>& d_res2,
                  unsigned int cnt_l, unsigned int cnt_r, bool left_join);
