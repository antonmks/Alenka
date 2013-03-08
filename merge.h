#include "cm.h"

void create_c(CudaSet* c, CudaSet* b);
void add(CudaSet* c, CudaSet* b, queue<string> op_v3, boost::unordered_map<long long int, unsigned int>& mymap, map<string,string> aliases,
		 vector<thrust::device_vector<int_type> >& distinct_tmp, vector<thrust::device_vector<int_type> >& distinct_val,
         vector<thrust::device_vector<int_type> >& distinct_hash, CudaSet* a);
void count_avg(CudaSet* c, boost::unordered_map<long long int, unsigned int>& mymap, vector<thrust::device_vector<int_type> >& distinct_hash);		 




