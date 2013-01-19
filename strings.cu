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

#include <thrust/copy.h>

using namespace std;


	struct Str1 {
	    char A[1];
			
        __host__ __device__
         bool operator<(const Str1& other) const
         {
		    		    
		    for(unsigned int i = 0; i < 1 ; i++) {
			    if(A[i] > other.A[i]) {
				    return 0;
				};	
			    if(A[i] < other.A[i]) {
                    return 1;
				};	
				
			};	
            return 0;   
         }				 
		 
        __host__ __device__
         bool operator>(const Str1& other) const
         {
		    for(unsigned int i = 0; i < 1 ; i++) {
			    if(A[i] > other.A[i]) {
				    return 1;
				};	
			    if(A[i] < other.A[i]) {
				    return 0;
				};					
			};	
            return 0;   
         }			
		 
		 
         __host__ __device__
         bool operator!=(const Str1& other) const
         {
		    for(unsigned int i = 0; i < 1 ; i++) {
			    if(A[i] != other.A[i]) {
				    return 1;
				};					
			};	
            return 0;   
         }					 
		 
		 
		 
	};

    
	struct Str2 {
	    char A[2];
			
        __host__ __device__
         bool operator<(const Str2& other) const
         {
		    		    
		    for(unsigned int i = 0; i < 2 ; i++) {
			    if(A[i] > other.A[i]) {
				    return 0;
				};	
			    if(A[i] < other.A[i]) {
                    return 1;
				};	
				
			};	
            return 0;   
         }				 
		 
        __host__ __device__
         bool operator>(const Str2& other) const
         {
		    for(unsigned int i = 0; i < 2 ; i++) {
			    if(A[i] > other.A[i]) {
				    return 1;
				};	
			    if(A[i] < other.A[i]) {
				    return 0;
				};					
			};	
            return 0;   
         }			
		 
		 
         __host__ __device__
         bool operator!=(const Str2& other) const
         {
		    for(unsigned int i = 0; i < 2 ; i++) {
			    if(A[i] != other.A[i]) {
				    return 1;
				};					
			};	
            return 0;   
         }					 
		 
		 
		 
	};

	struct Str3 {
	    char A[3];
			
        __host__ __device__
         bool operator<(const Str3& other) const
         {
		    		    
		    for(unsigned int i = 0; i < 3 ; i++) {
			    if(A[i] > other.A[i]) {
				    return 0;
				};	
			    if(A[i] < other.A[i]) {
                    return 1;
				};	
				
			};	
            return 0;   
         }				 
		 
        __host__ __device__
         bool operator>(const Str3& other) const
         {
		    for(unsigned int i = 0; i < 3 ; i++) {
			    if(A[i] > other.A[i]) {
				    return 1;
				};	
			    if(A[i] < other.A[i]) {
				    return 0;
				};					
			};	
            return 0;   
         }			
		 
		 
         __host__ __device__
         bool operator!=(const Str3& other) const
         {
		    for(unsigned int i = 0; i < 3 ; i++) {
			    if(A[i] != other.A[i]) {
				    return 1;
				};					
			};	
            return 0;   
         }					 
		 
		 
		 
	};

	struct Str4 {
	    char A[4];
			
        __host__ __device__
         bool operator<(const Str4& other) const
         {
		    		    
		    for(unsigned int i = 0; i < 4 ; i++) {
			    if(A[i] > other.A[i]) {
				    return 0;
				};	
			    if(A[i] < other.A[i]) {
                    return 1;
				};	
				
			};	
            return 0;   
         }				 
		 
        __host__ __device__
         bool operator>(const Str4& other) const
         {
		    for(unsigned int i = 0; i < 4 ; i++) {
			    if(A[i] > other.A[i]) {
				    return 1;
				};	
			    if(A[i] < other.A[i]) {
				    return 0;
				};					
			};	
            return 0;   
         }			
		 
		 
         __host__ __device__
         bool operator!=(const Str4& other) const
         {
		    for(unsigned int i = 0; i < 4 ; i++) {
			    if(A[i] != other.A[i]) {
				    return 1;
				};					
			};	
            return 0;   
         }					 
		 
		 
		 
	};

	struct Str5 {
	    char A[5];
			
        __host__ __device__
         bool operator<(const Str5& other) const
         {
		    		    
		    for(unsigned int i = 0; i < 5 ; i++) {
			    if(A[i] > other.A[i]) {
				    return 0;
				};	
			    if(A[i] < other.A[i]) {
                    return 1;
				};	
				
			};	
            return 0;   
         }				 
		 
        __host__ __device__
         bool operator>(const Str5& other) const
         {
		    for(unsigned int i = 0; i < 5 ; i++) {
			    if(A[i] > other.A[i]) {
				    return 1;
				};	
			    if(A[i] < other.A[i]) {
				    return 0;
				};					
			};	
            return 0;   
         }			
		 
		 
         __host__ __device__
         bool operator!=(const Str5& other) const
         {
		    for(unsigned int i = 0; i < 5 ; i++) {
			    if(A[i] != other.A[i]) {
				    return 1;
				};					
			};	
            return 0;   
         }					 
		 
		 
		 
	};

	struct Str6 {
	    char A[6];
			
        __host__ __device__
         bool operator<(const Str6& other) const
         {
		    		    
		    for(unsigned int i = 0; i < 6 ; i++) {
			    if(A[i] > other.A[i]) {
				    return 0;
				};	
			    if(A[i] < other.A[i]) {
                    return 1;
				};	
				
			};	
            return 0;   
         }				 
		 
        __host__ __device__
         bool operator>(const Str6& other) const
         {
		    for(unsigned int i = 0; i < 6 ; i++) {
			    if(A[i] > other.A[i]) {
				    return 1;
				};	
			    if(A[i] < other.A[i]) {
				    return 0;
				};					
			};	
            return 0;   
         }			
		 
		 
         __host__ __device__
         bool operator!=(const Str6& other) const
         {
		    for(unsigned int i = 0; i < 6 ; i++) {
			    if(A[i] != other.A[i]) {
				    return 1;
				};					
			};	
            return 0;   
         }					 

		 
		 
	};

	struct Str7 {
	    char A[7];
			
        __host__ __device__
         bool operator<(const Str7& other) const
         {
		    		    
		    for(unsigned int i = 0; i < 7 ; i++) {
			    if(A[i] > other.A[i]) {
				    return 0;
				};	
			    if(A[i] < other.A[i]) {
                    return 1;
				};	
				
			};	
            return 0;   
         }				 
		 
        __host__ __device__
         bool operator>(const Str7& other) const
         {
		    for(unsigned int i = 0; i < 7 ; i++) {
			    if(A[i] > other.A[i]) {
				    return 1;
				};	
			    if(A[i] < other.A[i]) {
				    return 0;
				};					
			};	
            return 0;   
         }			
		 
		 
         __host__ __device__
         bool operator!=(const Str7& other) const
         {
		    for(unsigned int i = 0; i < 7 ; i++) {
			    if(A[i] != other.A[i]) {
				    return 1;
				};					
			};	
            return 0;   
         }					 
		 
		 
		 
	};

	struct Str8 {
	    char A[8];
			
        __host__ __device__
         bool operator<(const Str8& other) const
         {
		    		    
		    for(unsigned int i = 0; i < 8 ; i++) {
			    if(A[i] > other.A[i]) {
				    return 0;
				};	
			    if(A[i] < other.A[i]) {
                    return 1;
				};	
				
			};	
            return 0;   
         }				 
		 
        __host__ __device__
         bool operator>(const Str8& other) const
         {
		    for(unsigned int i = 0; i < 8 ; i++) {
			    if(A[i] > other.A[i]) {
				    return 1;
				};	
			    if(A[i] < other.A[i]) {
				    return 0;
				};					
			};	
            return 0;   
         }			
		 
		 
         __host__ __device__
         bool operator!=(const Str8& other) const
         {
		    for(unsigned int i = 0; i < 8 ; i++) {
			    if(A[i] != other.A[i]) {
				    return 1;
				};					
			};	
            return 0;   
         }					 
		 
		 
	};

	struct Str9 {
	    char A[9];
			
        __host__ __device__
         bool operator<(const Str9& other) const
         {
		    		    
		    for(unsigned int i = 0; i < 9 ; i++) {
			    if(A[i] > other.A[i]) {
				    return 0;
				};	
			    if(A[i] < other.A[i]) {
                    return 1;
				};	
				
			};	
            return 0;   
         }				 
		 
        __host__ __device__
         bool operator>(const Str9& other) const
         {
		    for(unsigned int i = 0; i < 9 ; i++) {
			    if(A[i] > other.A[i]) {
				    return 1;
				};	
			    if(A[i] < other.A[i]) {
				    return 0;
				};					
			};	
            return 0;   
         }			
		 
		 
         __host__ __device__
         bool operator!=(const Str9& other) const
         {
		    for(unsigned int i = 0; i < 9 ; i++) {
			    if(A[i] != other.A[i]) {
				    return 1;
				};					
			};	
            return 0;   
         }					 
		 
		 
		 
	};
	
	
	struct   Str10 {
	    char A[10];
			
        __host__ __device__
         bool operator<(const Str10& other) const
         {
		    		    
		    for(unsigned int i = 0; i < 10 ; i++) {
			    //printf("CMP %s %s \n ", A, other.A);
			    if(A[i] > other.A[i]) {
				    return 0;
				};	
			    if(A[i] < other.A[i]) {
                    return 1;
				};	
				
			};	
            return 0;   
         }				 
		 
        __host__ __device__
         bool operator>(const Str10& other) const
         {
		    for(unsigned int i = 0; i < 10 ; i++) {
			    if(A[i] > other.A[i]) {
				    return 1;
				};	
			    if(A[i] < other.A[i]) {
				    return 0;
				};					
			};	
            return 0;   
         }			
		 
		 
         __host__ __device__
         bool operator!=(const Str10& other) const
         {
		    for(unsigned int i = 0; i < 10 ; i++) {
			    if(A[i] != other.A[i]) {
				    return 1;
				};					
			};	
            return 0;   
         }					 
		 
		
		 
	};
	
	
 
		
void str_gather_host(unsigned int* d_int, unsigned int real_count, void* d, void* d_char, unsigned int len)
{
		if(len  == 1) {	
	        thrust::gather(d_int, d_int + real_count, (Str1*)d, (Str1*)d_char);       
		}
		else if(len  == 2) {	
   	        thrust::gather(d_int, d_int + real_count, (Str2*)d, (Str2*)d_char);       
		}
		else if(len  == 3) {	
	        thrust::gather(d_int, d_int + real_count, (Str3*)d, (Str3*)d_char);       
		}
		else if(len  == 4) {	
	        thrust::gather(d_int, d_int + real_count, (Str4*)d, (Str4*)d_char);       
		}
		else if(len  == 5) {	
	        thrust::gather(d_int, d_int + real_count, (Str5*)d, (Str5*)d_char);       
		}
		else if(len  == 6) {	
	        thrust::gather(d_int, d_int + real_count, (Str6*)d, (Str6*)d_char);       
		}
		else if(len  == 7) {	
	        thrust::gather(d_int, d_int + real_count, (Str7*)d, (Str7*)d_char);       
		}
		else if(len  == 8) {	
	        thrust::gather(d_int, d_int + real_count, (Str8*)d, (Str8*)d_char);       
		}
		else if(len  == 9) {	
	        thrust::gather(d_int, d_int + real_count, (Str9*)d, (Str9*)d_char);       
		}
		else if(len  == 10) {	
	        thrust::gather(d_int, d_int + real_count, (Str10*)d, (Str10*)d_char);       
		};		

}		 
	

void str_gather(void* d_int, unsigned int real_count, void* d, void* d_char, unsigned int len)
{

    thrust::device_ptr<unsigned int> res((unsigned int*)d_int);

		if(len  == 1) {	
	        thrust::device_ptr<Str1> dev_ptr_char((Str1*)d_char);
		    thrust::device_ptr<Str1> dev_ptr((Str1*)d);			
	        thrust::gather(res, res + real_count, dev_ptr, dev_ptr_char);       
		}
		else if(len  == 2) {	
	        thrust::device_ptr<Str2> dev_ptr_char((Str2*)d_char);
		    thrust::device_ptr<Str2> dev_ptr((Str2*)d);			
	        thrust::gather(res, res + real_count, dev_ptr, dev_ptr_char);       
		}
		else if(len  == 3) {	
	        thrust::device_ptr<Str3> dev_ptr_char((Str3*)d_char);
		    thrust::device_ptr<Str3> dev_ptr((Str3*)d);			
	        thrust::gather(res, res + real_count, dev_ptr, dev_ptr_char);       
		}
		else if(len  == 4) {	
	        thrust::device_ptr<Str4> dev_ptr_char((Str4*)d_char);
		    thrust::device_ptr<Str4> dev_ptr((Str4*)d);			
	        thrust::gather(res, res + real_count, dev_ptr, dev_ptr_char);       
		}
		else if(len  == 5) {	
	        thrust::device_ptr<Str5> dev_ptr_char((Str5*)d_char);
		    thrust::device_ptr<Str5> dev_ptr((Str5*)d);			
	        thrust::gather(res, res + real_count, dev_ptr, dev_ptr_char);       
		}
		else if(len  == 6) {	
	        thrust::device_ptr<Str6> dev_ptr_char((Str6*)d_char);
		    thrust::device_ptr<Str6> dev_ptr((Str6*)d);			
	        thrust::gather(res, res + real_count, dev_ptr, dev_ptr_char);       
		}
		else if(len  == 7) {	
	        thrust::device_ptr<Str7> dev_ptr_char((Str7*)d_char);
		    thrust::device_ptr<Str7> dev_ptr((Str7*)d);			
	        thrust::gather(res, res + real_count, dev_ptr, dev_ptr_char);       
		}
		else if(len  == 8) {	
	        thrust::device_ptr<Str8> dev_ptr_char((Str8*)d_char);
		    thrust::device_ptr<Str8> dev_ptr((Str8*)d);			
	        thrust::gather(res, res + real_count, dev_ptr, dev_ptr_char);       
		}
		else if(len  == 9) {	
	        thrust::device_ptr<Str9> dev_ptr_char((Str9*)d_char);
		    thrust::device_ptr<Str9> dev_ptr((Str9*)d);			
	        thrust::gather(res, res + real_count, dev_ptr, dev_ptr_char);       
		}
		else if(len  == 10) {	
	        thrust::device_ptr<Str10> dev_ptr_char((Str10*)d_char);
		    thrust::device_ptr<Str10> dev_ptr((Str10*)d);			
	        thrust::gather(res, res + real_count, dev_ptr, dev_ptr_char);     
		};


}


void str_sort_host(char* tmp, unsigned int RecCount, unsigned int* permutation, bool srt, unsigned int len)
{
	if(len  == 1) {	
        if(srt)
            thrust::stable_sort_by_key((Str1*)tmp, (Str1*)tmp+RecCount, permutation, thrust::greater<Str1>());			
		else
            thrust::stable_sort_by_key((Str1*)tmp, (Str1*)tmp+RecCount, permutation);				        
	}
	if(len  == 2) {	
        if(srt)
            thrust::stable_sort_by_key((Str2*)tmp, (Str2*)tmp+RecCount, permutation, thrust::greater<Str2>());			
		else
            thrust::stable_sort_by_key((Str2*)tmp, (Str2*)tmp+RecCount, permutation);				        
	}
	if(len  == 3) {	
        if(srt)
            thrust::stable_sort_by_key((Str3*)tmp, (Str3*)tmp+RecCount, permutation, thrust::greater<Str3>());			
		else
            thrust::stable_sort_by_key((Str3*)tmp, (Str3*)tmp+RecCount, permutation);				        
	}
	if(len  == 4) {	
        if(srt)
            thrust::stable_sort_by_key((Str4*)tmp, (Str4*)tmp+RecCount, permutation, thrust::greater<Str4>());			
		else
            thrust::stable_sort_by_key((Str4*)tmp, (Str4*)tmp+RecCount, permutation);				        
	}
	if(len  == 5) {	
        if(srt)
            thrust::stable_sort_by_key((Str5*)tmp, (Str5*)tmp+RecCount, permutation, thrust::greater<Str5>());			
		else
            thrust::stable_sort_by_key((Str5*)tmp, (Str5*)tmp+RecCount, permutation);				        
	}
	if(len  == 6) {	
        if(srt)
            thrust::stable_sort_by_key((Str6*)tmp, (Str6*)tmp+RecCount, permutation, thrust::greater<Str6>());			
		else
            thrust::stable_sort_by_key((Str6*)tmp, (Str6*)tmp+RecCount, permutation);				        
	}
	if(len  == 7) {	
        if(srt)
            thrust::stable_sort_by_key((Str7*)tmp, (Str7*)tmp+RecCount, permutation, thrust::greater<Str7>());			
		else
            thrust::stable_sort_by_key((Str7*)tmp, (Str7*)tmp+RecCount, permutation);				        
	}
	if(len  == 8) {	
        if(srt)
            thrust::stable_sort_by_key((Str8*)tmp, (Str8*)tmp+RecCount, permutation, thrust::greater<Str8>());			
		else
            thrust::stable_sort_by_key((Str8*)tmp, (Str8*)tmp+RecCount, permutation);				        
	}
	if(len  == 9) {	
        if(srt)
            thrust::stable_sort_by_key((Str9*)tmp, (Str9*)tmp+RecCount, permutation, thrust::greater<Str9>());			
		else
            thrust::stable_sort_by_key((Str9*)tmp, (Str9*)tmp+RecCount, permutation);				        
	}
	if(len  == 10) {	
        if(srt)
            thrust::stable_sort_by_key((Str10*)tmp, (Str10*)tmp+RecCount, permutation, thrust::greater<Str10>());			
		else
            thrust::stable_sort_by_key((Str10*)tmp, (Str10*)tmp+RecCount, permutation);				        
	}
	

}



void str_sort(char* tmp, unsigned int RecCount, unsigned int* permutation, bool srt, unsigned int len)
{
	thrust::device_ptr<unsigned int> dev_per((unsigned int*)permutation);

		if(len  == 1) {	
	        thrust::device_ptr<Str1> temp((Str1*)tmp);
            if(srt)
                thrust::stable_sort_by_key(temp, temp+RecCount, dev_per, thrust::greater<Str1>());			
			else
                thrust::stable_sort_by_key(temp, temp+RecCount, dev_per);				        
		}
		else if(len  == 2) {	
	        thrust::device_ptr<Str2> temp((Str2*)tmp);
            if(srt)
                thrust::stable_sort_by_key(temp, temp+RecCount, dev_per, thrust::greater<Str2>());			
			else
                thrust::stable_sort_by_key(temp, temp+RecCount, dev_per);				        
		}
		else if(len  == 3) {	
	        thrust::device_ptr<Str3> temp((Str3*)tmp);
            if(srt)
                thrust::stable_sort_by_key(temp, temp+RecCount, dev_per, thrust::greater<Str3>());			
			else
                thrust::stable_sort_by_key(temp, temp+RecCount, dev_per);				        
		}
		else if(len  == 4) {	
	        thrust::device_ptr<Str4> temp((Str4*)tmp);
            if(srt)
                thrust::stable_sort_by_key(temp, temp+RecCount, dev_per, thrust::greater<Str4>());			
			else
                thrust::stable_sort_by_key(temp, temp+RecCount, dev_per);				        
		}
		else if(len  == 5) {	
	        thrust::device_ptr<Str5> temp((Str5*)tmp);
            if(srt)
                thrust::stable_sort_by_key(temp, temp+RecCount, dev_per, thrust::greater<Str5>());			
			else
                thrust::stable_sort_by_key(temp, temp+RecCount, dev_per);				        
		}
		else if(len  == 6) {	
	        thrust::device_ptr<Str6> temp((Str6*)tmp);
            if(srt)
                thrust::stable_sort_by_key(temp, temp+RecCount, dev_per, thrust::greater<Str6>());			
			else
                thrust::stable_sort_by_key(temp, temp+RecCount, dev_per);				        
		}
		else if(len  == 7) {	
	        thrust::device_ptr<Str7> temp((Str7*)tmp);
            if(srt)
                thrust::stable_sort_by_key(temp, temp+RecCount, dev_per, thrust::greater<Str7>());			
			else
                thrust::stable_sort_by_key(temp, temp+RecCount, dev_per);				        
		}
		else if(len  == 8) {	
	        thrust::device_ptr<Str8> temp((Str8*)tmp);
            if(srt)
                thrust::stable_sort_by_key(temp, temp+RecCount, dev_per, thrust::greater<Str8>());			
			else
                thrust::stable_sort_by_key(temp, temp+RecCount, dev_per);				        
		}
		else if(len  == 9) {	
	        thrust::device_ptr<Str9> temp((Str9*)tmp);
            if(srt)
                thrust::stable_sort_by_key(temp, temp+RecCount, dev_per, thrust::greater<Str9>());			
			else
                thrust::stable_sort_by_key(temp, temp+RecCount, dev_per);				        
		}
		else if(len  == 10) {	
			thrust::device_ptr<Str10> temp((Str10*)tmp);
			
			
            if(srt) {
                thrust::stable_sort_by_key(temp, temp+RecCount, dev_per, thrust::greater<Str10>());			
			}	
			else {
//			    char* c = new char[10*RecCount];                
	//			char* dd = new char[10];
				
		//	    cudaMemcpy( c, (void *) tmp, 10*RecCount, cudaMemcpyDeviceToHost);
			//	cout << "Printing " << RecCount << endl;
			  //  for(int z = 0; z < RecCount; z++) {
                //   std::cout << "before " << z << " " << strncpy(dd,&c[z*10],10) << std::endl;				
			    //};				
				
                thrust::stable_sort_by_key(temp, temp+RecCount, dev_per);				        
				
			};	
		}	

}


void str_grp(char* d_char, unsigned int real_count, thrust::device_ptr<bool>& d_group, unsigned int len)
{


		if(len  == 1) {	
	        thrust::device_ptr<Str1> d_str((Str1*)d_char);
            thrust::transform(d_str, d_str + real_count -1 , d_str+1, d_group, thrust::not_equal_to<Str1>());			
		}
		else if(len  == 2) {	
	        thrust::device_ptr<Str2> d_str((Str2*)d_char);
            thrust::transform(d_str, d_str + real_count -1, d_str+1, d_group, thrust::not_equal_to<Str2>());			
		}
		else if(len  == 3) {	
	        thrust::device_ptr<Str3> d_str((Str3*)d_char);
            thrust::transform(d_str, d_str + real_count -1, d_str+1, d_group, thrust::not_equal_to<Str3>());			
		}
		else if(len  == 4) {	
	        thrust::device_ptr<Str4> d_str((Str4*)d_char);
            thrust::transform(d_str, d_str + real_count -1, d_str+1, d_group, thrust::not_equal_to<Str4>());			
		}
		else if(len  == 5) {	
	        thrust::device_ptr<Str5> d_str((Str5*)d_char);
            thrust::transform(d_str, d_str + real_count -1, d_str+1, d_group, thrust::not_equal_to<Str5>());			
		}
		else if(len  == 6) {	
	        thrust::device_ptr<Str6> d_str((Str6*)d_char);
            thrust::transform(d_str, d_str + real_count -1, d_str+1, d_group, thrust::not_equal_to<Str6>());			
		}
		else if(len  == 7) {	
	        thrust::device_ptr<Str7> d_str((Str7*)d_char);
            thrust::transform(d_str, d_str + real_count -1, d_str+1, d_group, thrust::not_equal_to<Str7>());			
		}
		else if(len  == 8) {	
	        thrust::device_ptr<Str8> d_str((Str8*)d_char);
            thrust::transform(d_str, d_str + real_count -1, d_str+1, d_group, thrust::not_equal_to<Str8>());			
		}
		else if(len  == 9) {	
	        thrust::device_ptr<Str9> d_str((Str9*)d_char);
            thrust::transform(d_str, d_str + real_count -1, d_str+1, d_group, thrust::not_equal_to<Str9>());			
		}
		else if(len  == 10) {	
	        thrust::device_ptr<Str10> d_str((Str10*)d_char);
            thrust::transform(d_str, d_str + real_count -1, d_str+1, d_group, thrust::not_equal_to<Str10>());			
		}
		

}


void str_copy_if(char* source, unsigned int mRecCount, char* dest, thrust::device_ptr<bool>& d_grp, unsigned int len)
{
		if(len  == 1) {	
	        thrust::device_ptr<Str1> d_str((Str1*)source);
			thrust::device_ptr<Str1> d_dest((Str1*)dest);			
			
            thrust::copy_if(d_str, d_str + mRecCount, d_grp, d_dest, thrust::identity<bool>());
		}
		else if(len  == 2) {	
	        thrust::device_ptr<Str2> d_str((Str2*)source);
			thrust::device_ptr<Str2> d_dest((Str2*)dest);
			
            thrust::copy_if(d_str, d_str + mRecCount, d_grp, d_dest, thrust::identity<bool>());
		}
		if(len  == 3) {	
	        thrust::device_ptr<Str3> d_str((Str3*)source);
			thrust::device_ptr<Str3> d_dest((Str3*)dest);
			
            thrust::copy_if(d_str, d_str + mRecCount, d_grp, d_dest, thrust::identity<bool>());
		}
		if(len  == 4) {	
	        thrust::device_ptr<Str4> d_str((Str4*)source);
			thrust::device_ptr<Str4> d_dest((Str4*)dest);
			
            thrust::copy_if(d_str, d_str + mRecCount, d_grp, d_dest, thrust::identity<bool>());
		}
		if(len  == 5) {	
	        thrust::device_ptr<Str5> d_str((Str5*)source);
			thrust::device_ptr<Str5> d_dest((Str5*)dest);
			
            thrust::copy_if(d_str, d_str + mRecCount, d_grp, d_dest, thrust::identity<bool>());
		}
		if(len  == 6) {	
	        thrust::device_ptr<Str6> d_str((Str6*)source);
			thrust::device_ptr<Str6> d_dest((Str6*)dest);
			
            thrust::copy_if(d_str, d_str + mRecCount, d_grp, d_dest, thrust::identity<bool>());
		}
		if(len  == 7) {	
	        thrust::device_ptr<Str7> d_str((Str7*)source);
			thrust::device_ptr<Str7> d_dest((Str7*)dest);
			
            thrust::copy_if(d_str, d_str + mRecCount, d_grp, d_dest, thrust::identity<bool>());
		}
		if(len  == 8) {	
	        thrust::device_ptr<Str8> d_str((Str8*)source);
			thrust::device_ptr<Str8> d_dest((Str8*)dest);
			
            thrust::copy_if(d_str, d_str + mRecCount, d_grp, d_dest, thrust::identity<bool>());
		}
		if(len  == 9) {	
	        thrust::device_ptr<Str9> d_str((Str9*)source);
			thrust::device_ptr<Str9> d_dest((Str9*)dest);
			
            thrust::copy_if(d_str, d_str + mRecCount, d_grp, d_dest, thrust::identity<bool>());
		}
		if(len  == 10) {	
	        thrust::device_ptr<Str10> d_str((Str10*)source);
			thrust::device_ptr<Str10> d_dest((Str10*)dest);
			
            thrust::copy_if(d_str, d_str + mRecCount, d_grp, d_dest, thrust::identity<bool>());
		}

}






       		
	
	