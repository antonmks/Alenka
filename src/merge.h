#ifndef MERGE_H_
#define MERGE_H_

#include "CudaSet.h"
#include "merge.cuh"

#if defined(_MSC_VER)
#define BIG_CONSTANT(x) (x)
// Other compilers
#else   // defined(_MSC_VER)
#define BIG_CONSTANT(x) (x##LLU)
#endif // !defined(_MSC_VER)

using namespace std;
using namespace thrust::placeholders;

void create_c(CudaSet* c, CudaSet* b);
void add(CudaSet* c, CudaSet* b, queue<string> op_v3, map<string,string> aliases,
		 vector<thrust::device_vector<int_type> >& distinct_tmp, vector<thrust::device_vector<int_type> >& distinct_val,
         vector<thrust::device_vector<int_type> >& distinct_hash, CudaSet* a);
void count_avg(CudaSet* c, vector<thrust::device_vector<int_type> >& distinct_hash);
void count_simple(CudaSet* c);

#endif /* MERGE_H_ */
