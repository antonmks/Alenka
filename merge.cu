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

#include <unordered_map>
#include "cm.h"

head_flag_predicate<bool> binary_pred_l;

int myPow(long long int x, long long int p)
{
  if (p == 0) return 1;
  if (p == 1) return x;

  int tmp = myPow(x, p/2);
  if (p%2 == 0) return tmp * tmp;
  else return x * tmp * tmp;
}

void add(CudaSet* c, CudaSet* b, queue<string> op_v3, std::unordered_map<long long int, unsigned int>& mymap, map<string,string> aliases)
{
    if (c->columnNames.empty()) {
        // create d_columns and h_columns

        map<string,int>::iterator it;

        for (  it=b->columnNames.begin() ; it != b->columnNames.end(); ++it ) {
            c->columnNames[(*it).first] = (*it).second;
        };

        c->grp_type = new unsigned int[c->mColumnCount];

        for(unsigned int i=0; i < b->mColumnCount; i++) {
            c->cols[i] = b->cols[i];
            c->type[i] = b->type[i];
            c->grp_type[i] = b->grp_type[i];

            if (b->type[i] == 0) {
                c->h_columns_int.push_back(thrust::host_vector<int_type>());
            }
            else if (b->type[i] == 1) {
                c->h_columns_float.push_back(thrust::host_vector<float_type>());
            }
            else {
				c->h_columns_char.push_back(NULL); 
				c->char_size.push_back(b->char_size[b->type_index[i]]);
            };
			c->type_index[i] = b->type_index[i];
        };
    }
	
	
	std::unordered_map<long long int, unsigned int>::const_iterator got;	 	  
	 
     b->CopyToHost(0, b->mRecCount);
	 
   
	// store in a variable c only unique records
	// we have do it on a host because the hash table for the expected set sizes(~5 bln records) won't fit into a GPU memory
	// gonna be kinda on the slow side 
	
	
	long long int *b_hash = new long long int[b->mRecCount];
	long long int res, loc;
	unsigned int idx;
	for(unsigned int i = 0; i < b->mRecCount; i++) {
	     queue<string> op_v(op_v3);		 
		 res = 0;
	     for(unsigned int z = 0; z < op_v.size(); op_v.pop()) {	
		     idx = b->columnNames[aliases[op_v.front()]];
		     if(b->type[b->columnNames[aliases[op_v.front()]]] == 0) {  //int
			     loc = MurmurHash64A(thrust::raw_pointer_cast(b->h_columns_int[b->type_index[idx]].data()) + i, int_size, hash_seed)/2;
			 }
			 else if(b->type[b->columnNames[aliases[op_v.front()]]] == 2) {  //string
			     loc = MurmurHash64A(b->h_columns_char[b->type_index[idx]] + i*b->char_size[b->type_index[idx]], b->char_size[b->type_index[idx]], hash_seed);
			 }
			 else {  //float
			     cout << "Group by on float is not supported !!! " << endl;
				 exit(0);
			 };	
             res = res + myPow(loc, z+1);
		 };
	     b_hash[i] = res;
	};
	
	
	 //resize c
	 unsigned int cnt = 0;
	 for(unsigned int i = 0; i < b->mRecCount; i++) {
	     got = mymap.find(b_hash[i]);
	     if(got == mymap.end())
		     cnt++;
	 };
	 unsigned int old_cnt = c->mRecCount;
	 if(cnt)
	     c->resize(cnt);
	
	
	// now lets add to c those records that are not already there and update those that are there
	for(unsigned int i = 0; i < b->mRecCount; i++) {
	    queue<string> op_v(op_v3);
		
	    got = mymap.find(b_hash[i]);		
	    if(got == mymap.end()) {	//not found, need to insert
	//	cout << "insert " << b_hash[i] << endl;
		    mymap[b_hash[i]] = old_cnt;			
			for(unsigned int j=0; j < b->mColumnCount; j++) {	
			    
			    if(b->type[j] == 0) {  //int
					 c->h_columns_int[c->type_index[j]][old_cnt] = b->h_columns_int[b->type_index[j]][i];
				}
				else if(b->type[j] == 1) {  //float
 				    c->h_columns_float[c->type_index[j]][old_cnt] = b->h_columns_float[b->type_index[j]][i];
				}
				else if(b->type[j] == 2) {  //string
					cudaMemcpy(c->h_columns_char[c->type_index[j]] + old_cnt*b->char_size[b->type_index[j]], b->h_columns_char[b->type_index[j]] + i*b->char_size[b->type_index[j]],
					           b->char_size[b->type_index[j]], cudaMemcpyHostToHost);
				};			
			};		
            old_cnt++;			
		}
		else { //need to update
//		    cout << "update " << b_hash[i] << endl;
		    for(unsigned int j=0; j < b->mColumnCount; j++) {	
			    
			    if (c->grp_type[j] == 2 || c->grp_type[j] == 1 || c->grp_type[j] == 0) {  // SUM || AVG || COUNT
				    if (c->type[j] == 0) {
					   c->h_columns_int[c->type_index[j]][got->second] +=  b->h_columns_int[b->type_index[j]][i];
					}
					else {
					    c->h_columns_float[c->type_index[j]][got->second] += b->h_columns_float[b->type_index[j]][i];
					};
				}
				else if(c->grp_type[j] == 4) {  // MIN
				    if (c->type[j] == 0) {
					     if (c->h_columns_int[c->type_index[j]][got->second] >  b->h_columns_int[b->type_index[j]][i])
					       c->h_columns_int[c->type_index[j]][got->second] =  b->h_columns_int[b->type_index[j]][i];
					}
					else {
					    if (c->h_columns_float[c->type_index[j]][got->second] > b->h_columns_float[b->type_index[j]][i])
						    c->h_columns_float[c->type_index[j]][got->second] = b->h_columns_float[b->type_index[j]][i];
					};				
                } 			
				else if(c->grp_type[j] == 5) {  // MAX
				    if (c->type[j] == 0) {
					     if (c->h_columns_int[c->type_index[j]][got->second] <  b->h_columns_int[b->type_index[j]][i])
					       c->h_columns_int[c->type_index[j]][got->second] =  b->h_columns_int[b->type_index[j]][i];
					}
					else {
					    if (c->h_columns_float[c->type_index[j]][got->second] < b->h_columns_float[b->type_index[j]][i])
						    c->h_columns_float[c->type_index[j]][got->second] = b->h_columns_float[b->type_index[j]][i];
					};				
                } 							
			};
		};		
	};	
	delete [] b_hash;
}





void count_avg(CudaSet* c)
{
    int countIndex;

    for(unsigned int i = 0; i < c->mColumnCount; i++) {
        if(c->grp_type[i] == 0) // COUNT
            countIndex = i;
    };    
	
    if (c->mRecCount != 0) {    
    	
        for(unsigned int k = 0; k < c->mColumnCount; k++)	{
            if(c->grp_type[k] == 1) {   // AVG
            
                if (c->type[k] == 0 ) { // int
                    //create a float column k						
                    c->h_columns_float.push_back(thrust::host_vector<float_type>(c->mRecCount));                    
                    unsigned int idx = c->h_columns_float.size()-1;

				    for(unsigned int z = 0; z < c->mRecCount; z++) {
					    c->h_columns_float[idx][z] =  ((float_type)c->h_columns_int[c->type_index[k]][z]) / (float_type)c->h_columns_int[c->type_index[countIndex]][z];										  
					};				  
                    c->type[k] = 1;
                    c->h_columns_int[c->type_index[k]].resize(0);
                    c->h_columns_int[c->type_index[k]].shrink_to_fit();
                    c->type_index[k] = idx;
                }
                else {              // float
					for(unsigned int z = 0; z < c->mRecCount; z++) {
					    c->h_columns_float[c->type_index[k]][z] =  c->h_columns_float[c->type_index[k]][z] / (float_type)c->h_columns_int[c->type_index[countIndex]][z];										  
					};				  
				};	
            };
        };
    };

    c->segCount = 1;
    c->maxRecs = c->mRecCount;
};

