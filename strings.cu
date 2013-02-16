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

    template<unsigned int N>
	struct Str {
	    char A[N];
			
        __host__ __device__
         bool operator<(const Str& other) const
         {
		    		    
		    for(unsigned int i = 0; i < N ; i++) {
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
         bool operator>(const Str& other) const
         {
		    for(unsigned int i = 0; i < N ; i++) {
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
         bool operator!=(const Str& other) const
         {
		    for(unsigned int i = 0; i < N ; i++) {
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
	        thrust::gather(d_int, d_int + real_count, (Str<1> *)d, (Str<1> *)d_char);       
		}
		else if(len  == 2) {	
   	        thrust::gather(d_int, d_int + real_count, (Str<2> *)d, (Str<2> *)d_char);       
		}
		else if(len  == 3) {	
	        thrust::gather(d_int, d_int + real_count, (Str<3> *)d, (Str<3> *)d_char);       
		}
		else if(len  == 4) {	
	        thrust::gather(d_int, d_int + real_count, (Str<4> *)d, (Str<4> *)d_char);       
		}
		else if(len  == 5) {	
	        thrust::gather(d_int, d_int + real_count, (Str<5> *)d, (Str<5> *)d_char);       
		}
		else if(len  == 6) {	
	        thrust::gather(d_int, d_int + real_count, (Str<6> *)d, (Str<6> *)d_char);       
		}
		else if(len  == 7) {	
	        thrust::gather(d_int, d_int + real_count, (Str<7> *)d, (Str<7> *)d_char);       
		}
		else if(len  == 8) {	
	        thrust::gather(d_int, d_int + real_count, (Str<8> *)d, (Str<8> *)d_char);       
		}
		else if(len  == 9) {	
	        thrust::gather(d_int, d_int + real_count, (Str<9> *)d, (Str<9> *)d_char);       
		}
		else if(len  == 10) {	
	        thrust::gather(d_int, d_int + real_count, (Str<10> *)d, (Str<10> *)d_char);       
		}
		else if(len  == 20) {	
	        thrust::gather(d_int, d_int + real_count, (Str<20> *)d, (Str<20> *)d_char);       
		}
		else if(len  == 50) {	
	        thrust::gather(d_int, d_int + real_count, (Str<50> *)d, (Str<50> *)d_char);       
		}
		else if(len  == 100) {	
	        thrust::gather(d_int, d_int + real_count, (Str<100> *)d, (Str<100> *)d_char);       
		};		

}		 
	

void str_gather(void* d_int, unsigned int real_count, void* d, void* d_char, const unsigned int len)
{

    thrust::device_ptr<unsigned int> res((unsigned int*)d_int);

	   if(len  == 1) {	
	        thrust::device_ptr<Str<1> > dev_ptr_char((Str<1>*)d_char);
	        thrust::device_ptr<Str<1> > dev_ptr((Str<1>*)d);			
	        thrust::gather(res, res + real_count, dev_ptr, dev_ptr_char);       
		}
		else if(len  == 2) {	
	        thrust::device_ptr<Str<2> > dev_ptr_char((Str<2>*)d_char);
		    thrust::device_ptr<Str<2> > dev_ptr((Str<2>*)d);			
	        thrust::gather(res, res + real_count, dev_ptr, dev_ptr_char);       
		}
		else if(len  == 3) {	
	        thrust::device_ptr<Str<3> > dev_ptr_char((Str<3>*)d_char);
		    thrust::device_ptr<Str<3> > dev_ptr((Str<3>*)d);			
	        thrust::gather(res, res + real_count, dev_ptr, dev_ptr_char);       
		}
		else if(len  == 4) {	
	        thrust::device_ptr<Str<4> > dev_ptr_char((Str<4>*)d_char);
		    thrust::device_ptr<Str<4> > dev_ptr((Str<4>*)d);			
	        thrust::gather(res, res + real_count, dev_ptr, dev_ptr_char);       
		}
		else if(len  == 5) {	
	        thrust::device_ptr<Str<5> > dev_ptr_char((Str<5>*)d_char);
		    thrust::device_ptr<Str<5> > dev_ptr((Str<5>*)d);			
	        thrust::gather(res, res + real_count, dev_ptr, dev_ptr_char);       
		}
		else if(len  == 6) {	
	        thrust::device_ptr<Str<6> > dev_ptr_char((Str<6> *)d_char);
		    thrust::device_ptr<Str<6> > dev_ptr((Str<6> *)d);			
	        thrust::gather(res, res + real_count, dev_ptr, dev_ptr_char);       
		}
		else if(len  == 7) {	
	        thrust::device_ptr<Str<7> > dev_ptr_char((Str<7> *)d_char);
		    thrust::device_ptr<Str<7> > dev_ptr((Str<7> *)d);			
	        thrust::gather(res, res + real_count, dev_ptr, dev_ptr_char);       
		}
		else if(len  == 8) {	
	        thrust::device_ptr<Str<8> > dev_ptr_char((Str<8> *)d_char);
		    thrust::device_ptr<Str<8> > dev_ptr((Str<8> *)d);			
	        thrust::gather(res, res + real_count, dev_ptr, dev_ptr_char);       
		}
		else if(len  == 9) {	
	        thrust::device_ptr<Str<9> > dev_ptr_char((Str<9> *)d_char);
		    thrust::device_ptr<Str<9> > dev_ptr((Str<9> *)d);			
	        thrust::gather(res, res + real_count, dev_ptr, dev_ptr_char);       
		}
		else if(len  == 10) {	
	        thrust::device_ptr<Str<10> > dev_ptr_char((Str<10> *)d_char);
		    thrust::device_ptr<Str<10> > dev_ptr((Str<10> *)d);			
	        thrust::gather(res, res + real_count, dev_ptr, dev_ptr_char);     
		}
		else if(len  == 20) {	
	        thrust::device_ptr<Str<20> > dev_ptr_char((Str<20> *)d_char);
		    thrust::device_ptr<Str<20> > dev_ptr((Str<20> *)d);			
	        thrust::gather(res, res + real_count, dev_ptr, dev_ptr_char);     
		}
		else if(len  == 50) {	
	        thrust::device_ptr<Str<50> > dev_ptr_char((Str<50> *)d_char);
		    thrust::device_ptr<Str<50> > dev_ptr((Str<50> *)d);			
	        thrust::gather(res, res + real_count, dev_ptr, dev_ptr_char);     
		}
		else if(len  == 100) {	
	        thrust::device_ptr<Str<100> > dev_ptr_char((Str<100> *)d_char);
		    thrust::device_ptr<Str<100> > dev_ptr((Str<100> *)d);			
	        thrust::gather(res, res + real_count, dev_ptr, dev_ptr_char);     
		};


}


void str_sort_host(char* tmp, unsigned int RecCount, unsigned int* permutation, bool srt, unsigned int len)
{
	if(len  == 1) {	
        if(srt)
            thrust::stable_sort_by_key((Str<1> *)tmp, (Str<1> *)tmp+RecCount, permutation, thrust::greater<Str<1> >());			
		else
            thrust::stable_sort_by_key((Str<1> *)tmp, (Str<1> *)tmp+RecCount, permutation);				        
	}
	if(len  == 2) {	
        if(srt)
            thrust::stable_sort_by_key((Str<2> *)tmp, (Str<2> *)tmp+RecCount, permutation, thrust::greater<Str<2> >());			
		else
            thrust::stable_sort_by_key((Str<2> *)tmp, (Str<2> *)tmp+RecCount, permutation);				        
	}
	if(len  == 3) {	
        if(srt)
            thrust::stable_sort_by_key((Str<3> *)tmp, (Str<3> *)tmp+RecCount, permutation, thrust::greater<Str<3> >());			
		else
            thrust::stable_sort_by_key((Str<3> *)tmp, (Str<3> *)tmp+RecCount, permutation);				        
	}
	if(len  == 4) {	
        if(srt)
            thrust::stable_sort_by_key((Str<4> *)tmp, (Str<4> *)tmp+RecCount, permutation, thrust::greater<Str<4> >());			
		else
            thrust::stable_sort_by_key((Str<4> *)tmp, (Str<4> *)tmp+RecCount, permutation);				        
	}
	if(len  == 5) {	
        if(srt)
            thrust::stable_sort_by_key((Str<5> *)tmp, (Str<5> *)tmp+RecCount, permutation, thrust::greater<Str<5> >());			
		else
            thrust::stable_sort_by_key((Str<5> *)tmp, (Str<5> *)tmp+RecCount, permutation);				        
	}
	if(len  == 6) {	
        if(srt)
            thrust::stable_sort_by_key((Str<6> *)tmp, (Str<6> *)tmp+RecCount, permutation, thrust::greater<Str<6> >());			
		else
            thrust::stable_sort_by_key((Str<6> *)tmp, (Str<6> *)tmp+RecCount, permutation);				        
	}
	if(len  == 7) {	
        if(srt)
            thrust::stable_sort_by_key((Str<7> *)tmp, (Str<7> *)tmp+RecCount, permutation, thrust::greater<Str<7> >());			
		else
            thrust::stable_sort_by_key((Str<7> *)tmp, (Str<7> *)tmp+RecCount, permutation);				        
	}
	if(len  == 8) {	
        if(srt)
            thrust::stable_sort_by_key((Str<8> *)tmp, (Str<8> *)tmp+RecCount, permutation, thrust::greater<Str<8> >());			
		else
            thrust::stable_sort_by_key((Str<8> *)tmp, (Str<8> *)tmp+RecCount, permutation);				        
	}
	if(len  == 9) {	
        if(srt)
            thrust::stable_sort_by_key((Str<9> *)tmp, (Str<9> *)tmp+RecCount, permutation, thrust::greater<Str<9> >());			
		else
            thrust::stable_sort_by_key((Str<9> *)tmp, (Str<9> *)tmp+RecCount, permutation);				        
	}
	if(len  == 10) {	
        if(srt)
            thrust::stable_sort_by_key((Str<10> *)tmp, (Str<10> *)tmp+RecCount, permutation, thrust::greater<Str<10> >());			
		else
            thrust::stable_sort_by_key((Str<10> *)tmp, (Str<10> *)tmp+RecCount, permutation);				        
	}
	if(len  == 20) {	
        if(srt)
            thrust::stable_sort_by_key((Str<20> *)tmp, (Str<20> *)tmp+RecCount, permutation, thrust::greater<Str<20> >());			
		else
            thrust::stable_sort_by_key((Str<20> *)tmp, (Str<20> *)tmp+RecCount, permutation);				        
	}
	if(len  == 50) {	
        if(srt)
            thrust::stable_sort_by_key((Str<50> *)tmp, (Str<50> *)tmp+RecCount, permutation, thrust::greater<Str<50> >());			
		else
            thrust::stable_sort_by_key((Str<50> *)tmp, (Str<50> *)tmp+RecCount, permutation);				        
	}
	if(len  == 100) {	
        if(srt)
            thrust::stable_sort_by_key((Str<100> *)tmp, (Str<100> *)tmp+RecCount, permutation, thrust::greater<Str<100> >());			
		else
            thrust::stable_sort_by_key((Str<100> *)tmp, (Str<100> *)tmp+RecCount, permutation);				        
	}
	
}


void str_sort(char* tmp, unsigned int RecCount, unsigned int* permutation, bool srt, unsigned int len)
{
	thrust::device_ptr<unsigned int> dev_per((unsigned int*)permutation);

		if(len  == 1) {	
	        thrust::device_ptr<Str<1> > temp((Str<1> *)tmp);
            if(srt)
                thrust::stable_sort_by_key(temp, temp+RecCount, dev_per, thrust::greater<Str<1> >());			
			else
                thrust::stable_sort_by_key(temp, temp+RecCount, dev_per);				        
		}
		else if(len  == 2) {	
	        thrust::device_ptr<Str<2> > temp((Str<2> *)tmp);
            if(srt)
                thrust::stable_sort_by_key(temp, temp+RecCount, dev_per, thrust::greater<Str<2> >());			
			else
                thrust::stable_sort_by_key(temp, temp+RecCount, dev_per);				        
		}
		else if(len  == 3) {	
	        thrust::device_ptr<Str<3> > temp((Str<3> *)tmp);
            if(srt)
                thrust::stable_sort_by_key(temp, temp+RecCount, dev_per, thrust::greater<Str<3> >());			
			else
                thrust::stable_sort_by_key(temp, temp+RecCount, dev_per);				        
		}
		else if(len  == 4) {	
	        thrust::device_ptr<Str<4> > temp((Str<4> *)tmp);
            if(srt)
                thrust::stable_sort_by_key(temp, temp+RecCount, dev_per, thrust::greater<Str<4> >());			
			else
                thrust::stable_sort_by_key(temp, temp+RecCount, dev_per);				        
		}
		else if(len  == 5) {	
	        thrust::device_ptr<Str<5> > temp((Str<5> *)tmp);
            if(srt)
                thrust::stable_sort_by_key(temp, temp+RecCount, dev_per, thrust::greater<Str<5> >());			
			else
                thrust::stable_sort_by_key(temp, temp+RecCount, dev_per);				        
		}
		else if(len  == 6) {	
	        thrust::device_ptr<Str<6> > temp((Str<6> *)tmp);
            if(srt)
                thrust::stable_sort_by_key(temp, temp+RecCount, dev_per, thrust::greater<Str<6> >());			
			else
                thrust::stable_sort_by_key(temp, temp+RecCount, dev_per);				        
		}
		else if(len  == 7) {	
	        thrust::device_ptr<Str<7> > temp((Str<7> *)tmp);
            if(srt)
                thrust::stable_sort_by_key(temp, temp+RecCount, dev_per, thrust::greater<Str<7> >());			
			else
                thrust::stable_sort_by_key(temp, temp+RecCount, dev_per);				        
		}
		else if(len  == 8) {	
	        thrust::device_ptr<Str<8> > temp((Str<8> *)tmp);
            if(srt)
                thrust::stable_sort_by_key(temp, temp+RecCount, dev_per, thrust::greater<Str<8> >());			
			else
                thrust::stable_sort_by_key(temp, temp+RecCount, dev_per);				        
		}
		else if(len  == 9) {	
	        thrust::device_ptr<Str<9> > temp((Str<9> *)tmp);
            if(srt)
                thrust::stable_sort_by_key(temp, temp+RecCount, dev_per, thrust::greater<Str<9> >());			
			else
                thrust::stable_sort_by_key(temp, temp+RecCount, dev_per);				        
		}
		else if(len  == 10) {	
			thrust::device_ptr<Str<10> > temp((Str<10> *)tmp);			
            if(srt) {
                thrust::stable_sort_by_key(temp, temp+RecCount, dev_per, thrust::greater<Str<10> >());			
			}	
			else {				
                thrust::stable_sort_by_key(temp, temp+RecCount, dev_per);				        				
			};	
		}	
		else if(len  == 20) {	
			thrust::device_ptr<Str<20> > temp((Str<20> *)tmp);			
            if(srt) {
                thrust::stable_sort_by_key(temp, temp+RecCount, dev_per, thrust::greater<Str<20> >());			
			}	
			else {				
                thrust::stable_sort_by_key(temp, temp+RecCount, dev_per);				        				
			};	
		}	
		else if(len  == 50) {	
			thrust::device_ptr<Str<50> > temp((Str<50> *)tmp);			
            if(srt) {
                thrust::stable_sort_by_key(temp, temp+RecCount, dev_per, thrust::greater<Str<50> >());			
			}	
			else {				
                thrust::stable_sort_by_key(temp, temp+RecCount, dev_per);				        				
			};	
		}	
		else if(len  == 100) {	
			thrust::device_ptr<Str<100> > temp((Str<100> *)tmp);			
            if(srt) {
                thrust::stable_sort_by_key(temp, temp+RecCount, dev_per, thrust::greater<Str<100> >());			
			}	
			else {				
                thrust::stable_sort_by_key(temp, temp+RecCount, dev_per);				        				
			};	
		}	
		
}


void str_grp(char* d_char, unsigned int real_count, thrust::device_ptr<bool>& d_group, unsigned int len)
{


		if(len  == 1) {	
	        thrust::device_ptr<Str<1> > d_str((Str<1> *)d_char);
            thrust::transform(d_str, d_str + real_count -1 , d_str+1, d_group, thrust::not_equal_to<Str<1> >());			
		}
		else if(len  == 2) {	
	        thrust::device_ptr<Str<2> > d_str((Str<2> *)d_char);
            thrust::transform(d_str, d_str + real_count -1, d_str+1, d_group, thrust::not_equal_to<Str<2> >());			
		}
		else if(len  == 3) {	
	        thrust::device_ptr<Str<3> > d_str((Str<3> *)d_char);
            thrust::transform(d_str, d_str + real_count -1, d_str+1, d_group, thrust::not_equal_to<Str<3> >());			
		}
		else if(len  == 4) {	
	        thrust::device_ptr<Str<4> > d_str((Str<4> *)d_char);
            thrust::transform(d_str, d_str + real_count -1, d_str+1, d_group, thrust::not_equal_to<Str<4> >());			
		}
		else if(len  == 5) {	
	        thrust::device_ptr<Str<5> > d_str((Str<5> *)d_char);
            thrust::transform(d_str, d_str + real_count -1, d_str+1, d_group, thrust::not_equal_to<Str<5> >());			
		}
		else if(len  == 6) {	
	        thrust::device_ptr<Str<6> > d_str((Str<6> *)d_char);
            thrust::transform(d_str, d_str + real_count -1, d_str+1, d_group, thrust::not_equal_to<Str<6> >());			
		}
		else if(len  == 7) {	
	        thrust::device_ptr<Str<7> > d_str((Str<7> *)d_char);
            thrust::transform(d_str, d_str + real_count -1, d_str+1, d_group, thrust::not_equal_to<Str<7> >());			
		}
		else if(len  == 8) {	
	        thrust::device_ptr<Str<8> > d_str((Str<8> *)d_char);
            thrust::transform(d_str, d_str + real_count -1, d_str+1, d_group, thrust::not_equal_to<Str<8> >());			
		}
		else if(len  == 9) {	
	        thrust::device_ptr<Str<9> > d_str((Str<9> *)d_char);
            thrust::transform(d_str, d_str + real_count -1, d_str+1, d_group, thrust::not_equal_to<Str<9> >());			
		}
		else if(len  == 10) {	
	        thrust::device_ptr<Str<10> > d_str((Str<10> *)d_char);
            thrust::transform(d_str, d_str + real_count -1, d_str+1, d_group, thrust::not_equal_to<Str<10> >());			
		}
		else if(len  == 20) {	
	        thrust::device_ptr<Str<20> > d_str((Str<20> *)d_char);
            thrust::transform(d_str, d_str + real_count -1, d_str+1, d_group, thrust::not_equal_to<Str<20> >());			
		}
		else if(len  == 50) {	
	        thrust::device_ptr<Str<50> > d_str((Str<50> *)d_char);
            thrust::transform(d_str, d_str + real_count -1, d_str+1, d_group, thrust::not_equal_to<Str<50> >());			
		}
		else if(len  == 100) {	
	        thrust::device_ptr<Str<100> > d_str((Str<100> *)d_char);
            thrust::transform(d_str, d_str + real_count -1, d_str+1, d_group, thrust::not_equal_to<Str<100> >());			
		}
		

}


void str_copy_if(char* source, unsigned int mRecCount, char* dest, thrust::device_ptr<bool>& d_grp, unsigned int len)
{
		if(len  == 1) {	
	        thrust::device_ptr<Str<1> > d_str((Str<1> *)source);
			thrust::device_ptr<Str<1> > d_dest((Str<1> *)dest);			
			
            thrust::copy_if(d_str, d_str + mRecCount, d_grp, d_dest, thrust::identity<bool>());
		}
		else if(len  == 2) {	
	        thrust::device_ptr<Str<2> > d_str((Str<2> *)source);
			thrust::device_ptr<Str<2> > d_dest((Str<2> *)dest);
			
            thrust::copy_if(d_str, d_str + mRecCount, d_grp, d_dest, thrust::identity<bool>());
		}
		else if(len  == 3) {	
	        thrust::device_ptr<Str<3> > d_str((Str<3> *)source);
			thrust::device_ptr<Str<3> > d_dest((Str<3> *)dest);
			
            thrust::copy_if(d_str, d_str + mRecCount, d_grp, d_dest, thrust::identity<bool>());
		}
		else if(len  == 4) {	
	        thrust::device_ptr<Str<4> > d_str((Str<4> *)source);
			thrust::device_ptr<Str<4> > d_dest((Str<4> *)dest);
			
            thrust::copy_if(d_str, d_str + mRecCount, d_grp, d_dest, thrust::identity<bool>());
		}
		else if(len  == 5) {	
	        thrust::device_ptr<Str<5> > d_str((Str<5> *)source);
			thrust::device_ptr<Str<5> > d_dest((Str<5> *)dest);
			
            thrust::copy_if(d_str, d_str + mRecCount, d_grp, d_dest, thrust::identity<bool>());
		}
		else if(len  == 6) {	
	        thrust::device_ptr<Str<6> > d_str((Str<6> *)source);
			thrust::device_ptr<Str<6> > d_dest((Str<6> *)dest);
			
            thrust::copy_if(d_str, d_str + mRecCount, d_grp, d_dest, thrust::identity<bool>());
		}
		else if(len  == 7) {	
	        thrust::device_ptr<Str<7> > d_str((Str<7> *)source);
			thrust::device_ptr<Str<7> > d_dest((Str<7> *)dest);
			
            thrust::copy_if(d_str, d_str + mRecCount, d_grp, d_dest, thrust::identity<bool>());
		}
		else if(len  == 8) {	
	        thrust::device_ptr<Str<8> > d_str((Str<8> *)source);
			thrust::device_ptr<Str<8> > d_dest((Str<8> *)dest);
			
            thrust::copy_if(d_str, d_str + mRecCount, d_grp, d_dest, thrust::identity<bool>());
		}
		else if(len  == 9) {	
	        thrust::device_ptr<Str<9> > d_str((Str<9> *)source);
			thrust::device_ptr<Str<9> > d_dest((Str<9> *)dest);
			
            thrust::copy_if(d_str, d_str + mRecCount, d_grp, d_dest, thrust::identity<bool>());
		}
		else if(len  == 10) {	
	        thrust::device_ptr<Str<10> > d_str((Str<10> *)source);
			thrust::device_ptr<Str<10> > d_dest((Str<10> *)dest);
			
            thrust::copy_if(d_str, d_str + mRecCount, d_grp, d_dest, thrust::identity<bool>());
		}
		else if(len  == 20) {	
	        thrust::device_ptr<Str<20> > d_str((Str<20> *)source);
			thrust::device_ptr<Str<20> > d_dest((Str<20> *)dest);
			
            thrust::copy_if(d_str, d_str + mRecCount, d_grp, d_dest, thrust::identity<bool>());
		}
		else if(len  == 50) {	
	        thrust::device_ptr<Str<50> > d_str((Str<50> *)source);
			thrust::device_ptr<Str<50> > d_dest((Str<50> *)dest);
			
            thrust::copy_if(d_str, d_str + mRecCount, d_grp, d_dest, thrust::identity<bool>());
		}
		else if(len  == 100) {	
	        thrust::device_ptr<Str<100> > d_str((Str<100> *)source);
			thrust::device_ptr<Str<100> > d_dest((Str<100> *)dest);
			
            thrust::copy_if(d_str, d_str + mRecCount, d_grp, d_dest, thrust::identity<bool>());
		}
		

}






       		
	
	