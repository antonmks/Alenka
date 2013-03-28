#include "cm.h"

unsigned long long int filter(queue<string> op_type, queue<string> op_value, queue<int_type> op_nums,queue<float_type> op_nums_f, CudaSet* a,
                              CudaSet* b, unsigned int segment, thrust::device_vector<unsigned int>& dev_p);
