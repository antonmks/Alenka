#ifndef ZONE_MAP_H_
#define ZONE_MAP_H_

#include <stack>
#include <queue>
#include <math.h>
#include <time.h>

#include "CudaSet.h"
#include "types.h"
#include "log.h"

using namespace std;

unsigned int precision_func(unsigned int& p1, unsigned int& p2, string op);
char zone_map_check(queue<string> op_type, queue<string> op_value, queue<int_type> op_nums,queue<float_type> op_nums_f, queue<unsigned int> op_nums_precision, CudaSet* a, unsigned int segment);


#endif /* ZONE_MAP_H_ */
