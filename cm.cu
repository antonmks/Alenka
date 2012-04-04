/*
 *
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

#include <thrust/device_ptr.h>
#include <thrust/device_malloc.h>
#include <thrust/device_free.h>
#include <thrust/device_vector.h>
#include <thrust/copy.h>
#include <thrust/sequence.h>
#include <thrust/sort.h>
#include <thrust/set_operations.h>
#include <thrust/gather.h>
#include <thrust/scan.h>
#include <thrust/reduce.h>
#include <thrust/functional.h>
#include <thrust/iterator/constant_iterator.h>
#include <thrust/adjacent_difference.h>
#include <cuda.h>
#include <iostream>
#include <sstream>
#include <stdio.h>
#include <fstream>
#include <iomanip>
#include <queue>
#include <set>
#include <string>
#include <map>
#include <ctime>
#ifdef _WIN64
#include <process.h>
#endif
#include "cm.h"
#include "atof.h"
#include "itoa.h"
#include "compress.cu"


#ifdef _WIN64
#else
#define _FILE_OFFSET_BITS 64
#endif

#ifdef _WIN64
#define fseeko _fseeki64
#define ftello _ftelli64
#else
#define fseeko fseek
#define ftello ftell
#endif


using namespace std;

unsigned int process_count;
long long int runningRecs = 0;
long long int totalRecs = 0;
bool fact_file_loaded = 0;
bool buffersEmpty = 0;

const double gpu_mem = 0.7;  // amount of gpu memory used to keep the record sets. The rest is used as tmp space

map<string,queue<string>> top_type;
map<string,queue<string>> top_value;
map<string,queue<int_type>> top_nums;
map<string,queue<float_type>> top_nums_f;	


template <typename HeadFlagType>
struct head_flag_predicate
        : public thrust::binary_function<HeadFlagType,HeadFlagType,bool>
{
    __host__ __device__
    bool operator()(HeadFlagType left, HeadFlagType right) const
    {
        return !left;
    }
};

struct f_equal_to
{
    __host__ __device__
    bool operator()(const float_type x, const float_type y)
    {
        return (((x-y) < EPSILON) && ((x-y) > -EPSILON));
    }
};


struct f_less
{
    __host__ __device__
    bool operator()(const float_type x, const float_type y)
    {
        return ((y-x) > EPSILON);
    }
};

struct f_greater
{
    __host__ __device__
    bool operator()(const float_type x, const float_type y)
    {
        return ((x-y) > EPSILON);
    }
};

struct f_greater_equal_to
{
    __host__ __device__
    bool operator()(const float_type x, const float_type y)
    {
        return (((x-y) > EPSILON) || (((x-y) < EPSILON) && ((x-y) > -EPSILON)));
    }
};

struct f_less_equal
{
    __host__ __device__
    bool operator()(const float_type x, const float_type y)
    {
        return (((y-x) > EPSILON) || (((x-y) < EPSILON) && ((x-y) > -EPSILON)));
    }
};

struct f_not_equal_to
{
    __host__ __device__
    bool operator()(const float_type x, const float_type y)
    {
        return !(((x-y) < EPSILON) && ((x-y) > -EPSILON));
    }
};


struct long_to_float_type
{
    __host__ __device__
    float_type operator()(const int_type x)
    {
        return (float_type)x;
    }
};

struct to_zero
{
    __host__ __device__
    bool operator()(const int_type x)
    {
        if(x == -1)
            return 0;
        else
            return 1;
    }
};



struct div_long_to_float_type
{
    __host__ __device__
    float_type operator()(const int_type x, const float_type y)
    {
        return (float_type)x/y;
    }
};

struct float_to_long
{

    __host__ __device__
    long long int operator()(const float_type x)
    {
        if ((long long int)((x+EPSILON)*100.0) > (long long int)(x*100.0))
            return (long long int)((x+EPSILON)*100.0);
        else return (long long int)(x*100.0);


    }
};

struct long_to_float
{
    __host__ __device__
    float_type operator()(const long long int x)
    {
        return (((float_type)x)/100.0);
    }
};




struct comp_bits_functor
{
    const int_type a;

    comp_bits_functor(int_type _a) : a(_a) {}

    __host__ __device__
    unsigned int operator()(const int_type& x, const int_type& y) const {
        return ((x&a) == (y&a));
    }
};

struct cmp_functor
{
    const char * src;
    int_type * output;
    const char * str;
    const unsigned int * len;

    cmp_functor(const char * _src, int_type * _output, const char * _str, const unsigned int * _len):
        src(_src), output(_output), str(_str), len(_len) {}

    template <typename IndexType>
    __host__ __device__
    void operator()(const IndexType & i) {

        if(src[i] != 0 && output[i] >= 0 && output[i] < *len ) {
            if ( src[i] == str[(*len-output[i]) - 1])
                output[i]++;
            else
                output[i] = -1;
        };
    }
};


void LoadBuffers(void* file_name);
class CudaSet;
unsigned int getChunkCount(CudaSet* a);
unsigned int findSegmentCount(char* file_name);
CudaSet *th;
bool buffersLoaded;


size_t getFreeMem();
unsigned int getSize(CudaSet* a); 
bool zone_map_check(queue<string> op_type, queue<string> op_value, queue<int_type> op_nums,queue<float_type> op_nums_f, CudaSet* a);



class CudaChar
{
public:
    char** h_columns;
    char** d_columns;
    char* compressed;
    unsigned int mColumnCount;
    unsigned int mRecCount;

    CudaChar(unsigned int columnCount, unsigned int Recs)
        : mColumnCount(0),
          mRecCount(0)
    {
        initialize(columnCount, Recs);
    }
	
    CudaChar(unsigned int columnCount, unsigned int Recs, bool gpu)
        : mColumnCount(0),
          mRecCount(0)
    {
        initialize(columnCount, Recs, gpu);
    }
	
    CudaChar(unsigned int columnCount, unsigned int Recs, bool gpu, long long int compressed_size)
        : mColumnCount(0),
          mRecCount(0)
    {
        initialize(columnCount, Recs, gpu, compressed_size);
    }
	
	


    ~CudaChar()
    {
        free();
    }
	
	
	void findMinMax(string& minStr, string& maxStr)
	{	
        thrust::device_ptr<unsigned int> permutation = thrust::device_malloc<unsigned int>(mRecCount);					
        thrust::sequence(permutation, permutation+mRecCount);	
	
        unsigned int* raw_ptr = thrust::raw_pointer_cast(permutation);
        void* temp;
        CUDA_SAFE_CALL(cudaMalloc((void **) &temp, mRecCount));	
	
        for(int j=mColumnCount-1; j>=0 ; j--)
            update_permutation_char(d_columns[j], raw_ptr, mRecCount, (char*)temp, "ASC");			
		
        minStr = "";
		maxStr = "";
		
		for(unsigned int j=0; j<mColumnCount; j++) {
		    thrust::device_ptr<char> cc(d_columns[j]);
		    minStr+=cc[permutation[0]];
		    maxStr+=cc[permutation[mRecCount-1]];
		};
		
		cudaFree(temp);
		cudaFree(raw_ptr);	
	}
	

    void resize(unsigned int addRecs)
    {
       /* unsigned int old_count = mRecCount;
        mRecCount = mRecCount + addRecs;
        for(unsigned int i=0; i <mColumnCount; i++) {
            char* n;
            cudaMallocHost(&n, mRecCount);
            if(old_count != 0) {
                if (old_count < mRecCount)
                    memcpy(n,h_columns[i],old_count);
                else
                    memcpy(n,h_columns[i],mRecCount);
                cudaFreeHost(h_columns[i]);
            };
            h_columns[i] = n;
        };
	*/
        mRecCount = mRecCount + addRecs;
        for(unsigned int i=0; i <mColumnCount; i++)
            h_columns[i] = (char *)realloc((void *)h_columns[i], mRecCount);
	
    }

    void allocOnDevice(unsigned int RecordCount)
    {
        for(unsigned int i=0; i <mColumnCount; i++)
            CUDA_SAFE_CALL(cudaMalloc((void **) &d_columns[i], RecordCount));
        mRecCount = RecordCount;
    }

    void deAllocOnDevice()
    {
        for(unsigned int i=0; i <mColumnCount; i++) {
            if (d_columns[i]) {
                cudaFree(d_columns[i]);
                d_columns[i] = 0;
            }
        };
    };

    void free()
    {
        for(unsigned int i=0; i <mColumnCount; i++) {
            if (d_columns[i]) {
                cudaFree(d_columns[i]);
                d_columns[i] = 0;
            };
			if(h_columns[i])
                //cudaFreeHost(h_columns[i]);
	            delete [] h_columns[i];

        };
        delete [] d_columns;
        delete [] h_columns;
        if (compressed) {
		    cudaFreeHost(compressed);
			compressed = 0;
		};			
    };

    void CopyToGpu(unsigned int offset, unsigned int count)
    {
        for(unsigned int i = 0; i < mColumnCount; i++)
            cudaMemcpy((void *) d_columns[i], (void *) (h_columns[i] + offset), count, cudaMemcpyHostToDevice);
    };

    void CopyToHost(unsigned int offset, unsigned int count)
    {
        for(unsigned int i = 0; i < mColumnCount; i++)
            cudaMemcpy((void *) (h_columns[i] + offset), (void *) d_columns[i], count, cudaMemcpyDeviceToHost);               			
    };

    int_type* findStr(string str)
    {
        // return a boolean vector of size mRecCount
        thrust::device_ptr<int_type> res = thrust::device_malloc<int_type>(mRecCount);
        thrust::sequence(res, res+mRecCount, 1, 0);

        thrust::device_ptr<int_type> v = thrust::device_malloc<int_type>(mRecCount);

        for(int i =0; i < str.length(); i++) {
            thrust::device_ptr<char> dev_ptr(d_columns[i]);
            thrust::device_ptr<char> c = thrust::device_malloc<char>(mRecCount);

            thrust::sequence(c, c+mRecCount, (int)str[i], 0);

            thrust::transform(dev_ptr, dev_ptr+mRecCount, c, v, thrust::equal_to<char>());
            thrust::transform(v, v+mRecCount, res, res, thrust::logical_and<int_type>());
        };
        return thrust::raw_pointer_cast(res);
    };


    bool* cmpStr(string str)
    {

	    if (str[str.size()-1] == '%' && str[0] == '%') { // contains
            if(str.size() > mColumnCount) {
                thrust::device_ptr<bool> res_f = thrust::device_malloc<bool>(mRecCount);
                thrust::sequence(res_f, res_f+mRecCount, 0, 0);
                return thrust::raw_pointer_cast(res_f);
            }
            else {
		
		       return 0;
		
		    };		
		}
        else if(str[str.size()-1] == '%') {  // startsWith

            if(str.size() > mColumnCount) {
                thrust::device_ptr<bool> res_f = thrust::device_malloc<bool>(mRecCount);
                thrust::sequence(res_f, res_f+mRecCount, 0, 0);
                return thrust::raw_pointer_cast(res_f);
            }
            else {

                thrust::device_ptr<bool> v = thrust::device_malloc<bool>(mRecCount);

                str.erase(str.size()-1,1);
                thrust::device_ptr<bool> res = thrust::device_malloc<bool>(mRecCount);
                thrust::sequence(res, res+mRecCount, 1, 0);

                for(int i = 0; i < str.size()-1; i++) {
                    thrust::device_ptr<char> dev_ptr(d_columns[i]);
                    thrust::transform(dev_ptr, dev_ptr+mRecCount, thrust::constant_iterator<char>(str[i]), v, thrust::equal_to<char>());
                    thrust::transform(v, v+mRecCount, res, res, thrust::logical_and<bool>());
                };
                thrust::device_free(v);
                return thrust::raw_pointer_cast(res);
            };

        }
        else if(str[0] == '%' ) {  // endsWith

            str.erase(0,1);
            thrust::device_ptr<char> dev_str = thrust::device_malloc<char>(str.size());
            thrust::device_ptr<unsigned int> len = thrust::device_malloc<unsigned int>(1);
            thrust::device_ptr<int_type> output = thrust::device_malloc<int_type>(mRecCount);
			thrust::device_ptr<bool> res = thrust::device_malloc<bool>(mRecCount);
            thrust::sequence(output, output+mRecCount, 0, 0);

            len[0] = str.size();
            for(int z=0; z < str.size(); z++)
                dev_str[z] = str[z];

            for(int i = mColumnCount-1; i >= 0; i--) {
                thrust::device_ptr<char> dev_ptr(d_columns[i]);

                thrust::counting_iterator<unsigned int, thrust::device_space_tag> begin(0);

                cmp_functor ff(thrust::raw_pointer_cast(dev_ptr),
                               thrust::raw_pointer_cast(output),
                               thrust::raw_pointer_cast(dev_str),
                               thrust::raw_pointer_cast(len));


                thrust::for_each(begin, begin + mRecCount, ff);


            };
            thrust::transform(output, output+mRecCount, res, to_zero());
            return thrust::raw_pointer_cast(res);
        }		
        else {                          // equal

            thrust::device_ptr<bool> v = thrust::device_malloc<bool>(mRecCount);
            thrust::device_ptr<bool> res = thrust::device_malloc<bool>(mRecCount);
            thrust::sequence(res, res+mRecCount, 1, 0);

            if(mColumnCount < str.length()) 
            {
                thrust::sequence(res, res+mRecCount, 0, 0);
                return thrust::raw_pointer_cast(res);
            };

            for(int i = 0; i < mColumnCount; i++) {
                thrust::device_ptr<char> dev_ptr(d_columns[i]);
                if (str.length() >= i+1) 
                    thrust::transform(dev_ptr, dev_ptr+mRecCount, thrust::constant_iterator<char>(str[i]), v, thrust::equal_to<char>());
                else
                    thrust::transform(dev_ptr, dev_ptr+mRecCount, thrust::constant_iterator<char>(0), v, thrust::equal_to<char>());
                thrust::transform(v, v+mRecCount, res, res, thrust::logical_and<int_type>());
            };
            thrust::device_free(v);
            return thrust::raw_pointer_cast(res);
        };
    };




protected: // methods

    void initialize(unsigned int columnCount, unsigned int Recs)
    {
        //cudaError_t errVal;
		
        compressed = 0;

        mColumnCount = columnCount;
        mRecCount = Recs;
        h_columns = new char*[mColumnCount];
        d_columns = new char*[mColumnCount];


        for(unsigned int i=0; i <mColumnCount; i++) {
            //errVal = cudaMallocHost(&h_columns[i], Recs);
            h_columns[i] = new char[Recs];

          /*  if(errVal != cudaSuccess) {
                cout << "ALLOC ERROR " << cudaGetErrorString(errVal) << endl;
                exit(-1);
            };
		*/	
            d_columns[i] = 0;
        };

    };
	
    void initialize(unsigned int columnCount, unsigned int Recs, bool gpu)
    {
        compressed = 0;
        mColumnCount = columnCount;
        mRecCount = Recs;
        h_columns = new char*[mColumnCount];
        d_columns = new char*[mColumnCount];

        for(unsigned int i=0; i <mColumnCount; i++) {
            d_columns[i] = 0;
			h_columns[i] = 0;
        };
    };
	
    void initialize(unsigned int columnCount, unsigned int Recs, bool gpu, long long int compressed_size)
    {
        mColumnCount = columnCount;
        mRecCount = Recs;
        h_columns = new char*[mColumnCount];
        d_columns = new char*[mColumnCount];

        for(unsigned int i=0; i <mColumnCount; i++) {
            d_columns[i] = 0;
			h_columns[i] = 0;
        };
		cudaMallocHost(&compressed, compressed_size);
		//compressed = new char[compressed_size];
    };	
	

};



class CudaSet
{
public:
    void** h_columns;
    void** d_columns;
    unsigned int mColumnCount;
    unsigned int mRecCount;
    map<string,int> columnNames;
    map<string, FILE*> filePointers;
    bool *grp;
    queue<string> columnGroups;
    bool fact_table; // 1 = fact table, 0 = dimension table
    FILE *file_p;
    unsigned long long int *offsets; // to store the current offsets for compression routines
    unsigned int *seq;
    bool keep;
	map<int,bool> uniqueColumns;
	unsigned int segCount, maxRecs;
	char* name;


    vector< vector<unsigned int> > m_position; //for partition by lower bits
    vector< vector<unsigned int> > m_size;	//for partition by lower bits
    unsigned int m_current;

    unsigned int* type; // 0 - integer, 1-float_type, 2-char
	bool* decimal; // column is decimal - affects only compression
    unsigned int* grp_type; // type of group : SUM, AVG, COUNT etc
    unsigned int* cols; // column positions in a file
    unsigned int grp_count;
    int readyToProcess;
	
    CudaSet(queue<string> &nameRef, queue<string> &typeRef, queue<int> &sizeRef, queue<int> &colsRef, int_type Recs)
        : mColumnCount(0),
          mRecCount(0)
    {
        initialize(nameRef, typeRef, sizeRef, colsRef, Recs);
        keep = false;
		offsets = 0;
    }
	
    CudaSet(queue<string> &nameRef, queue<string> &typeRef, queue<int> &sizeRef, queue<int> &colsRef, int_type Recs, char* file_name)
        : mColumnCount(0),
          mRecCount(0)
    {
        initialize(nameRef, typeRef, sizeRef, colsRef, Recs, file_name);
        keep = false;
		offsets = 0;
    }
	


    CudaSet(unsigned int RecordCount, unsigned int ColumnCount)
    {
        initialize(RecordCount, ColumnCount);
        keep = false;
		offsets = 0;
    };



    CudaSet(CudaSet* a, CudaSet* b, int_type Recs, queue<string> op_sel, queue<string> op_sel_as)
    {
        initialize(a,b,Recs, op_sel, op_sel_as);
        keep = false;
    };


    ~CudaSet()
    {
        free();
    }
	
	
	
	bool isUnique(unsigned int colIndex) //  run only on already sorted columns
	{	  
	  if (fact_table)
	      uniqueColumns[colIndex] = 0;
	  if (uniqueColumns.find(colIndex) == uniqueColumns.end()) {
          thrust::device_ptr<int_type> d_col((int_type*)d_columns[colIndex]);
		  if(mRecCount == 1 )
		      uniqueColumns[colIndex] = 1;
		  else {	  
		      thrust::device_ptr<unsigned int> d_group = thrust::device_malloc<unsigned int>(mRecCount-1);		  
		  
              thrust::transform(d_col, d_col + mRecCount - 1, d_col+1, d_group, thrust::not_equal_to<int_type>());
		      unsigned int grp_count = thrust::reduce(d_group, d_group+mRecCount-1);		      
		      if(grp_count == mRecCount-1)
		          uniqueColumns[colIndex] = 1;
		      else
		          uniqueColumns[colIndex] = 0;		  
		  };		  

	  };	   
	  return uniqueColumns[colIndex];	
	};
	

    void resize(unsigned int addRecs)
    {
        unsigned int old_count = mRecCount;
        mRecCount = mRecCount + addRecs;
        char* n;
		
		if(!fact_table) {
		    for(unsigned int i=0; i <mColumnCount; i++) {
			    if(type[i] !=2)
                    h_columns[i] = realloc((void *)h_columns[i], mRecCount);
				else 
				((CudaChar*)h_columns[i])->resize(addRecs);				
			};	
		}
        else		

        for(unsigned int i=0; i < mColumnCount; i++) {
            if (type[i] == 0) {
                cudaError_t errVal = cudaMallocHost(&n, mRecCount*int_size);
                if(errVal != cudaSuccess) {
                    cout << "ALLOC ERROR " << cudaGetErrorString(errVal) << endl;
                    exit(0);
                };
                if (old_count != 0) {
                    if (old_count < mRecCount)
                        memcpy(n,h_columns[i],old_count*int_size);
                    else
                        memcpy(n,h_columns[i],mRecCount*int_size);
                    cudaFreeHost(h_columns[i]);
                };
                h_columns[i] = n;
            }
            else if (type[i] == 1) {                
                cudaError_t errVal = cudaMallocHost(&n, mRecCount*float_size);
                if(errVal != cudaSuccess) {
                    cout << "ALLOC ERROR " << cudaGetErrorString(errVal) << endl;
                    exit(0);
                };				
                if (old_count != 0) {
                    if (old_count < mRecCount)
                        memcpy(n,h_columns[i],old_count*float_size);
                    else
                        memcpy(n,h_columns[i],mRecCount*float_size);
                    cudaFreeHost(h_columns[i]);
                };
                h_columns[i] = n;
            }
            else
                ((CudaChar*)h_columns[i])->resize(addRecs);
        };

    }


    void allocColumnOnDevice(unsigned int colIndex, unsigned int RecordCount)
    {
        if (type[colIndex] == 0)
            CUDA_SAFE_CALL(cudaMalloc((void **) &d_columns[colIndex], RecordCount*int_size));
        else if (type[colIndex] == 1)
            CUDA_SAFE_CALL(cudaMalloc((void **) &d_columns[colIndex], RecordCount*float_size));
        else {
            int a = 1;
            ((CudaChar*)h_columns[colIndex])->allocOnDevice(RecordCount);
            d_columns[colIndex] = &a;
        };
    };


    void deAllocColumnOnDevice(unsigned int colIndex)
    {
        if (type[colIndex] == 0 || type[colIndex] == 1) {
            if (d_columns[colIndex]) {
                cudaFree(d_columns[colIndex]);
                d_columns[colIndex] = 0;
            };
        }
        else {
            ((CudaChar*)h_columns[colIndex])->deAllocOnDevice();
            d_columns[colIndex] = 0;
        };
    };
	
	void setTypes(CudaSet* b)
	{
        for(unsigned int i=0; i < b->mColumnCount; i++) 
            type[i] = b->type[i];	   
	
	};
	
    void allocOnDevice(unsigned int RecordCount)
    {
        int a = 1;
        for(unsigned int i=0; i < mColumnCount; i++) {
            if (type[i] == 0)
                CUDA_SAFE_CALL(cudaMalloc((void **) &d_columns[i], RecordCount*int_size));
            else if (type[i] == 1)
                CUDA_SAFE_CALL(cudaMalloc((void **) &d_columns[i], RecordCount*float_size));
            else {
                ((CudaChar*)h_columns[i])->allocOnDevice(RecordCount);
                d_columns[i] = &a;
            };
        };
    };

    void deAllocOnDevice()
    {
        for(unsigned int i=0; i <mColumnCount; i++)
            if (type[i] == 0 || type[i] == 1) {
                cudaFree(d_columns[i]);
                d_columns[i] = 0;
            }
            else {
                ((CudaChar*)h_columns[i])->deAllocOnDevice();
                d_columns[i] = 0;
            }
        if(!columnGroups.empty() && mRecCount !=0)
            cudaFree(grp);

    };
	
	void resizeDeviceColumn(unsigned int RecCount, unsigned int colIndex)
	{
	    void* d;
        int a = 1;		
		
	    if (RecCount) { 
            if (type[colIndex] == 0) {
                CUDA_SAFE_CALL(cudaMalloc( &d, (mRecCount+RecCount)*int_size));
		        if(mRecCount) {
			        cudaMemcpy(d, d_columns[colIndex], mRecCount*int_size, cudaMemcpyDeviceToDevice);
				    cudaFree(d_columns[colIndex]);
				};	
				d_columns[colIndex] = d;
			}	
            else if (type[colIndex] == 1) {
                CUDA_SAFE_CALL(cudaMalloc( &d, (mRecCount+RecCount)*float_size));					
    			if(mRecCount) {
		            cudaMemcpy(d, d_columns[colIndex], mRecCount*float_size, cudaMemcpyDeviceToDevice);
				    cudaFree(d_columns[colIndex]);
				};	
				d_columns[colIndex] = d;
			}	
            else {
			    CudaChar *c = (CudaChar*)h_columns[colIndex];
				for(unsigned int j = 0; j < c->mColumnCount; j++) { 
                    CUDA_SAFE_CALL(cudaMalloc( &d, mRecCount+RecCount));
					if(mRecCount) {
					    cudaMemcpy( d, c->d_columns[j], mRecCount, cudaMemcpyDeviceToDevice);
					    cudaFree(c->d_columns[j]);
					};	
					c->d_columns[j] = (char*)d;
				};	
                d_columns[colIndex] = &a;
            };
	    };
	};
	
	
	
	void resizeDevice(unsigned int RecCount)
	{
	    if (RecCount)  
	        for(unsigned int i=0; i < mColumnCount; i++) 
			    resizeDeviceColumn(RecCount, i);
	};
	


    int_type copy_filter(CudaSet* b, bool* v, bool del_source)
    {

        thrust::device_ptr<bool> dev_ptr(v);		
        thrust::device_ptr<unsigned int> d_grp_int = thrust::device_malloc<unsigned int>(mRecCount);
        thrust::transform(dev_ptr, dev_ptr+mRecCount, d_grp_int, bool_to_int());
        unsigned int newRecCount = thrust::reduce(d_grp_int, d_grp_int+mRecCount);		
		
        thrust::device_free(d_grp_int);		
        if(b->maxRecs < newRecCount)	
		    b->maxRecs = newRecCount;
			
		//cout << "copy filter " << newRecCount << endl;	

		if (!fact_table) {
			
            void* d;
            CUDA_SAFE_CALL(cudaMalloc((void **) &d, newRecCount*float_size));

            for(unsigned int i=0; i < mColumnCount; i++) {
			    //cout << "copy_filter " << i << " " << b->offsets[i] << " " << newRecCount << " " << type[i] << endl;
                if (type[i] == 0 ) {
                    thrust::device_ptr<int_type> src((int_type*)(d_columns)[i]);
                    thrust::device_ptr<int_type> dest((int_type*)d);
                    thrust::copy_if(src,src+mRecCount,dev_ptr,dest,nz<int_type>());					
                    b->offsets[i] = pfor_compress(d, newRecCount*int_size, NULL, b->h_columns[i], 0, b->offsets[i]);                     					
                }
                else if (type[i] == 1 ) {
                    thrust::device_ptr<float_type> src((float_type*)(d_columns)[i]);
                    thrust::device_ptr<float_type> dest((float_type*)d);
                    thrust::copy_if(src,src+mRecCount,dev_ptr,dest,nz<int_type>());	
					if(!decimal[i]) {
					    // need to allocate b->h_columns[i];
						if(!b->h_columns[i])
                            //cudaMallocHost(&(b->h_columns[i]), newRecCount*float_size);
							b->h_columns[i] = new float_type[newRecCount]; 			
						else {
                            b->resize(newRecCount);							
							b->mRecCount = b->mRecCount - newRecCount;
						};	
                        cudaMemcpy((void *) ((float_type*)b->h_columns[i] + b->mRecCount), d, newRecCount*float_size, cudaMemcpyDeviceToHost);
					}	
					else {
                        thrust::device_ptr<long long int> d_col_dec((long long int*)d);
                        thrust::transform(dest,dest+newRecCount,d_col_dec, float_to_long());
                        b->offsets[i] = pfor_compress( d, newRecCount*int_size, NULL, b->h_columns[i], 1, b->offsets[i]);
                    };					
                }
                else { //CudaChar
                    CudaChar *s = (CudaChar*)(h_columns)[i];
                    CudaChar *s1 = (CudaChar*)(b->h_columns)[i];
					void *cmp = (void*)s1->compressed;
                    thrust::device_ptr<char> dest((char*)d);					
					
                    for(unsigned int j=0; j < s->mColumnCount; j++) {
                        thrust::device_ptr<char> src(s->d_columns[j]);
                        thrust::copy_if(src,src+mRecCount,dev_ptr,dest,nz<int_type>());					
     					cudaMemcpy(s->d_columns[j], d, newRecCount, cudaMemcpyDeviceToDevice);
					};
                    b->offsets[i] = pfor_dict_compress(s->d_columns, s->mColumnCount, NULL, newRecCount, cmp, b->offsets[i]);
					s1->compressed = (char*)cmp;					
                };
            };
            b->mRecCount = b->mRecCount + newRecCount;
            cudaFree(d);		   
		}		
        else {
		    if(!del_source)
		        b->resizeDevice(newRecCount);
            //b->allocOnDevice(newRecCount);
            for(unsigned int i=0; i < mColumnCount; i++) {
			
			    if(del_source) 
				    b->resizeDeviceColumn(newRecCount,i);
			
                if (type[i] == 0 ) {
                    thrust::device_ptr<int_type> src((int_type*)(d_columns)[i]);
                    thrust::device_ptr<int_type> dest((int_type*)b->d_columns[i]);
                    thrust::copy_if(src,src+mRecCount,dev_ptr,dest,nz<int_type>());
                }
                else if (type[i] == 1 ) {
                    thrust::device_ptr<float_type> src((float_type*)(d_columns)[i]);
                    thrust::device_ptr<float_type> dest((float_type*)b->d_columns[i]);
                    thrust::copy_if(src,src+mRecCount,dev_ptr,dest,nz<int_type>());
                }
                else { //CudaChar
                    CudaChar *s = (CudaChar*)(h_columns)[i];
                    CudaChar *s1 = (CudaChar*)(b->h_columns)[i];
                    for(unsigned int j=0; j < s->mColumnCount; j++) {
                        thrust::device_ptr<char> src(s->d_columns[j]);
                        thrust::device_ptr<char> dest(s1->d_columns[j]);
                        thrust::copy_if(src,src+mRecCount,dev_ptr,dest,nz<int_type>());
                    };
                };
			    if(del_source) 
					deAllocColumnOnDevice(i);
				
            };
            b->mRecCount = newRecCount;
        };			
        return newRecCount;
    };



    CudaSet* copyStruct(unsigned int mCount)
    {

        CudaSet* a = new CudaSet(mCount, mColumnCount);        
        a->fact_table = fact_table;

        for ( map<string,int>::iterator it=columnNames.begin() ; it != columnNames.end(); ++it ) 
            a->columnNames[(*it).first] = (*it).second;

        for(unsigned int i=0; i < mColumnCount; i++) {

            a->cols[i] = cols[i];
            a->type[i] = type[i];

            if (type[i] == 0) {
			    if(a->fact_table)
                    cudaMallocHost(&(a->h_columns[i]), mCount*int_size);
				else	
				    a->h_columns[i] = new int_type[mCount]; 
			}		
            else if (type[i] == 1) {
			    if(a->fact_table)
                    cudaMallocHost(&(a->h_columns[i]), mCount*float_size);
				else	
				    a->h_columns[i] = new float_type[mCount]; 					
			}	
            else
                a->h_columns[i] = new CudaChar(((CudaChar*) (h_columns)[i])->mColumnCount, mCount);
        };
        return a;
    }
	
    CudaSet* copyDeviceStruct()
    {

        CudaSet* a = new CudaSet(mRecCount, mColumnCount);        
        a->fact_table = fact_table;
		a->segCount = segCount;

        for ( map<string,int>::iterator it=columnNames.begin() ; it != columnNames.end(); ++it ) 
            a->columnNames[(*it).first] = (*it).second;

        for(unsigned int i=0; i < mColumnCount; i++) {
            a->cols[i] = cols[i];
            a->type[i] = type[i];
        };

		for(unsigned int i=0; i < mColumnCount; i++) {
		    if (type[i] == 2)
			    a->h_columns[i] = new CudaChar(((CudaChar*) (h_columns)[i])->mColumnCount, mRecCount, 1);			
		};	
	    if(!a->fact_table) {
		    a->offsets = new unsigned long long int[mColumnCount];
			for(int i =0; i < mColumnCount;i++)
			   a->offsets[i] = 0; 
	    };

		a->mRecCount = 0;
        return a;
    }
	
	



    void gather(CudaSet* a, CudaSet* b , thrust::device_vector<unsigned int>& d_res1,
                thrust::device_vector<unsigned int>& d_res2, unsigned int segment, queue<string> op_sel)
    {
        int_type RecCount = d_res1.size();
        bool alloc;
        map<string,int>::iterator it;
        unsigned int index;		
	    resizeDevice(RecCount);

        for(unsigned int i=0; i < mColumnCount; i++) {
            alloc = 0;
            it = a->columnNames.find(op_sel.front());
            if(it !=  a->columnNames.end()) {
                index = it->second;

                if( (a->type[index] < 2 && a->d_columns[index] == 0) ) {
                    a->allocColumnOnDevice(index,a->mRecCount);
                    a->CopyColumnToGpu(index);
                    alloc = 1;
                };				

                if (type[i] == 0 ) {						
                    thrust::device_ptr<int_type> src((int_type*)(a->d_columns)[index]);				
                    thrust::device_ptr<int_type> dest((int_type*)d_columns[i] + mRecCount);
                    thrust::gather(d_res1.begin(), d_res1.end(), src, dest);
                    if (alloc)
                        a->deAllocColumnOnDevice(index);
                }
                else if (type[i] == 1 ) {
                    thrust::device_ptr<float_type> src((float_type*)(a->d_columns)[index]);
                    thrust::device_ptr<float_type> dest((float_type*)d_columns[i] + mRecCount);
                    thrust::gather(d_res1.begin(), d_res1.end(), src, dest);
                    if (alloc)
                        a->deAllocColumnOnDevice(index);
                }
                else { //CudaChar
                    CudaChar *s = (CudaChar*)(a->h_columns)[index];
                    CudaChar *dc = (CudaChar*)h_columns[i];
                    alloc = (s->d_columns[0] == 0);
					
                    if(alloc) {
						a->allocColumnOnDevice(index, a->mRecCount);
						a->CopyColumnToGpu(index);
                    };
					
                    for(unsigned int j=0; j < s->mColumnCount; j++) {
					
                        thrust::device_ptr<char> src(s->d_columns[j]);
                        thrust::device_ptr<char> dest(dc->d_columns[j] + mRecCount);
                        thrust::gather(d_res1.begin(), d_res1.end(), src, dest);		
					};

                    if (alloc) 
              			a->deAllocColumnOnDevice(index);
					
                };
            }
            else {
                it = b->columnNames.find(op_sel.front());
                index = it->second;
	
                if (b->type[index] < 2 && b->d_columns[index] == 0) {
                    b->allocColumnOnDevice(index,b->maxRecs);
                    b->CopyColumnToGpu(index, segment);
                    alloc = 1;
                }
                if (type[i] == 0 ) {
                    thrust::device_ptr<int_type> src((int_type*)(b->d_columns)[index]);
                    thrust::device_ptr<int_type> dest((int_type*)d_columns[i] + mRecCount);
                    thrust::gather(d_res2.begin(), d_res2.end(), src, dest);
                    if (alloc)
                        b->deAllocColumnOnDevice(index);
                }
                else if (type[i] == 1 ) {
                    thrust::device_ptr<float_type> src((float_type*)(b->d_columns)[index]);
                    thrust::device_ptr<float_type> dest((float_type*)d_columns[i] + mRecCount);
                    thrust::gather(d_res2.begin(), d_res2.end(), src, dest);
                    if (alloc)
                        b->deAllocColumnOnDevice(index);
                }
                else { //CudaChar
                    CudaChar *s = (CudaChar*)(b->h_columns)[index];
                    CudaChar *dc = (CudaChar*)h_columns[i];
                    alloc = (s->d_columns[0] == 0);
					
                    if(alloc) {
						b->allocColumnOnDevice(index, b->mRecCount);
						b->CopyColumnToGpu(index, segment);
                    };					

                    for(unsigned int j=0; j < s->mColumnCount; j++) {
                        thrust::device_ptr<char> src(s->d_columns[j]);
                        thrust::device_ptr<char> dest(dc->d_columns[j] + mRecCount);
                        thrust::gather(d_res2.begin(), d_res2.end(), src, dest);
                    };
					
                    if (alloc)
					    b->deAllocColumnOnDevice(index);
					
                };
            };	
            op_sel.pop();
        };
		
		mRecCount = mRecCount + d_res1.size();
    }
	
	
    unsigned long long int readSegments(unsigned int segNum, unsigned int colIndex) // read segNum number of segments and return the offset of the next segment
	{
	  unsigned long long int offset = 0; // offset measured in bytes if checking chars and in 4 byte integers if checking ints and decimals
	  unsigned int grp_count;
	  unsigned int data_len; 
	  	  
	  for(int i = 0; i < segNum; i++) {	      
		  if(type[colIndex] != 2) {		      
		      data_len = ((unsigned int*)h_columns[colIndex] + offset)[0]; 
//			  cout << "data len " << data_len << endl;
	          offset = offset + data_len*2 + 15;		
//              cout << "offset " << 	offset << endl;		  
		  }	  
		  else {
		      //cout << "seg start " << endl;
		      CudaChar* c = (CudaChar*)h_columns[colIndex];
			  //cout << "seg start 1" << endl;
			  data_len = ((unsigned int*)(c->compressed + offset))[0]; 
			  //cout << "seg start 2 " << data_len << endl;
		      grp_count = ((unsigned int*)(c->compressed + offset + 8*data_len + 12))[0];		
              //cout << "readseg " << data_len << " " << grp_count << endl;			  
              offset = offset + data_len*8 + 14*4 + grp_count*c->mColumnCount;		  
		  };	  
	  };	  
      return offset;		  
	}

    void CopyToGpu(unsigned int offset, unsigned int count)
    {
	    if (fact_table) {
            for(unsigned int i = 0; i < mColumnCount; i++) {
                switch(type[i]) {
                case 0 :
                    cudaMemcpy((void *) d_columns[i], (void *) ((int_type*)h_columns[i] + offset), count*int_size, cudaMemcpyHostToDevice);
                    break;
                case 1 :
                    cudaMemcpy((void *) d_columns[i], (void *) ((float_type*)h_columns[i] + offset), count*float_size, cudaMemcpyHostToDevice);
                    break;
                default :
                    ((CudaChar*)h_columns[i])->CopyToGpu(offset, count);
                };
            };
		}
        else 
		    for(unsigned int i = 0; i < mColumnCount;i++) 
                CopyColumnToGpu(i,  offset, count);
    }
	
	
unsigned int getSegmentRecCount(unsigned int segment, unsigned int colIndex)
{
    long long int data_offset = readSegments(segment,colIndex);
	if (type[colIndex] != 2) {
	    unsigned int data_len = ((unsigned int*)h_columns[colIndex] + data_offset)[0]; 	
	    return ((unsigned int*)h_columns[colIndex] + data_offset)[data_len*2 + 7];		
	}	
	else {
        CudaChar* c = (CudaChar*)h_columns[colIndex];
 	    unsigned int data_len = ((unsigned int*)(c->compressed + data_offset))[0]; 
        return ((unsigned int*)(c->compressed + data_offset))[data_len*2 + 2]; 
    };	
}
	
	
	
    void CopyToGpu(unsigned int segment)
    {
	    if (fact_table) {
            for(unsigned int i = 0; i < mColumnCount; i++) {
                switch(type[i]) {
                case 0 :
                    cudaMemcpy((void *) d_columns[i], h_columns[i] , mRecCount*int_size, cudaMemcpyHostToDevice);
                    break;
                case 1 :
                    cudaMemcpy((void *) d_columns[i], h_columns[i] , mRecCount*float_size, cudaMemcpyHostToDevice);
                    break;
                default :
                    ((CudaChar*)h_columns[i])->CopyToGpu(0, mRecCount);
                };
            };
		}
        else 
		    for(unsigned int i = 0; i < mColumnCount;i++) 
                CopyColumnToGpu(i,  segment);
    }
	
	


    void CopyColumnToGpu(unsigned int colIndex,  unsigned int segment)
    {
	    if(fact_table) {			
            switch(type[colIndex]) {
            case 0 :
                cudaMemcpy((void *) d_columns[colIndex], h_columns[colIndex], mRecCount*int_size, cudaMemcpyHostToDevice);
                break;
            case 1 :
                cudaMemcpy((void *) d_columns[colIndex], h_columns[colIndex], mRecCount*float_size, cudaMemcpyHostToDevice);
                break;
            default :
                ((CudaChar*)h_columns[colIndex])->CopyToGpu(0, mRecCount);
            };			
    	}			
		else {
		    long long int data_offset = readSegments(segment,colIndex);
		
            switch(type[colIndex]) {
                case 0 :
  				    //data_len = ((unsigned int*)h_columns[colIndex] + data_offset)[0]; 
                    pfor_decompress(d_columns[colIndex] , (void*)((unsigned int*)h_columns[colIndex] + data_offset), &mRecCount, 0, NULL);
                    break;
                case 1 :
   			        if(decimal[colIndex]) {
					    //data_len = ((unsigned int*)h_columns[colIndex] + data_offset)[0]; 
					    pfor_decompress( d_columns[colIndex] , (void*)((unsigned int*)h_columns[colIndex] + data_offset), &mRecCount, 0, NULL);
                        thrust::device_ptr<long long int> d_col_int((long long int*)d_columns[colIndex]);
                        thrust::device_ptr<float_type> d_col_float((float_type*)d_columns[colIndex] );
                        thrust::transform(d_col_int,d_col_int+mRecCount,d_col_float, long_to_float());
				    }
                    //else // uncompressed float
                       //cudaMemcpy( d_columns[colIndex], (void *) ((float_type*)h_columns[colIndex] + offset), count*float_size, cudaMemcpyHostToDevice);
					   // will have to fix it later so uncompressed data will be written by segments too
                    break;
                default :
                    CudaChar* c = (CudaChar*)h_columns[colIndex];
					unsigned int data_len = ((unsigned int*)(c->compressed + data_offset))[0]; 
					grp_count = ((unsigned int*)(c->compressed + data_offset + data_len*8 + 12))[0];
                    pfor_dict_decompress(c->compressed + data_offset, c->h_columns , c->d_columns, &mRecCount, NULL,0, c->mColumnCount, 0);
            };
		};	
    }



    void CopyColumnToGpu(unsigned int colIndex) // copy all segments
    {
	    if(fact_table) {			
            switch(type[colIndex]) {
            case 0 :
                cudaMemcpy((void *) d_columns[colIndex], h_columns[colIndex], mRecCount*int_size, cudaMemcpyHostToDevice);
                break;
            case 1 :
                cudaMemcpy((void *) d_columns[colIndex], h_columns[colIndex], mRecCount*float_size, cudaMemcpyHostToDevice);
                break;
            default :
                ((CudaChar*)h_columns[colIndex])->CopyToGpu(0, mRecCount);
            };			
    	}			
		else {
		    long long int data_offset;
			unsigned int totalRecs = 0;
			
			for(unsigned int i = 0; i < segCount; i++) {			
			
		        data_offset = readSegments(i,colIndex);
                switch(type[colIndex]) {
                    case 0 :					    
  				        //data_len = ((unsigned int*)h_columns[colIndex] + data_offset)[0]; 
                        pfor_decompress((void*)((int_type*)d_columns[colIndex] + totalRecs), (void*)((unsigned int*)h_columns[colIndex] + data_offset), &mRecCount, 0, NULL);
                        break;
                    case 1 :
   			            if(decimal[colIndex]) {
					        //data_len = ((unsigned int*)h_columns[colIndex] + data_offset)[0]; 
					        pfor_decompress((void*)((int_type*)d_columns[colIndex] + totalRecs), (void*)((unsigned int*)h_columns[colIndex] + data_offset), &mRecCount, 0, NULL);							
                            thrust::device_ptr<long long int> d_col_int((long long int*)d_columns[colIndex] + totalRecs);							
                            thrust::device_ptr<float_type> d_col_float((float_type*)d_columns[colIndex] + totalRecs);
                            thrust::transform(d_col_int,d_col_int+mRecCount,d_col_float, long_to_float());
				        }
                       // else  uncompressed float
                           //cudaMemcpy( d_columns[colIndex], (void *) ((float_type*)h_columns[colIndex] + offset), count*float_size, cudaMemcpyHostToDevice);
					       // will have to fix it later so uncompressed data will be written by segments too
                        break;
                    default :
                        CudaChar* c = (CudaChar*)h_columns[colIndex];
                        pfor_dict_decompress(c->compressed + data_offset, c->h_columns , c->d_columns, &mRecCount, NULL,0, c->mColumnCount, totalRecs);
				};	
                totalRecs = totalRecs + mRecCount;				
            };
			mRecCount = totalRecs;
		};	
    }


	

    void CopyColumnToGpu(unsigned int colIndex,  unsigned int offset, unsigned int count)
    {
        if(m_size.empty()) {
		
		    if(fact_table) {			
                switch(type[colIndex]) {
                case 0 :
                    cudaMemcpy((void *) d_columns[colIndex], (void *) ((int_type*)h_columns[colIndex] + offset), count*int_size, cudaMemcpyHostToDevice);
                    break;
                case 1 :
                    cudaMemcpy((void *) d_columns[colIndex], (void *) ((float_type*)h_columns[colIndex] + offset), count*float_size, cudaMemcpyHostToDevice);
                    break;
                default :
                    ((CudaChar*)h_columns[colIndex])->CopyToGpu(offset, count);
                };			
			}			
			else {
		        
		        unsigned int start_seg, seg_num, grp_count, data_len, mCount;
			    start_seg = offset/segCount; // starting segment
			    seg_num = count/segCount;    // number of segments that we need
			    long long int data_offset = readSegments(start_seg,colIndex);
				
		
                switch(type[colIndex]) {
                case 0 :
                    for(unsigned int j = 0; j < seg_num; j++) {
						data_len = ((unsigned int*)h_columns[colIndex] + data_offset)[0]; 
                        pfor_decompress((int_type*)d_columns[colIndex] + segCount*j , (void*)((unsigned int*)h_columns[colIndex] + data_offset), &data_len, 0, NULL);
						data_offset = data_offset + data_len*2 + 15;
					};	

                    break;
                case 1 :
   			        if(decimal[colIndex]) {
						for(unsigned int j = 0; j < seg_num; j++) {
						    data_len = ((unsigned int*)h_columns[colIndex] + data_offset)[0]; 
						    pfor_decompress( (int_type*)d_columns[colIndex] + segCount*j, (void*)((unsigned int*)h_columns[colIndex] + data_offset), &data_len, 0, NULL);
                            thrust::device_ptr<long long int> d_col_int((long long int*)d_columns[colIndex] + segCount*j);
                            thrust::device_ptr<float_type> d_col_float((float_type*)d_columns[colIndex] + segCount*j);
                            thrust::transform(d_col_int,d_col_int+mRecCount,d_col_float, long_to_float());
							data_offset = data_offset + data_len*2 + 15;
                        };
				    }
                    else // uncompressed float
                       cudaMemcpy((void *) d_columns[colIndex], (void *) ((float_type*)h_columns[colIndex] + offset), count*float_size, cudaMemcpyHostToDevice);

                    break;
                default :
                    CudaChar* c = (CudaChar*)h_columns[colIndex];
                    for(unsigned int j = 0; j < seg_num; j++) {
					    data_len = ((unsigned int*)(c->compressed + data_offset))[0]; 
						grp_count = ((unsigned int*)(c->compressed + data_offset + data_len*8 + 12))[0];				
                        pfor_dict_decompress(c->compressed + data_offset, c->h_columns , c->d_columns, &mCount, NULL,0, c->mColumnCount, segCount*j);
						data_offset = data_offset + data_len*8 + 14*4 + grp_count*c->mColumnCount;		  
					};	
                };
            };
        }
        else {
            unsigned int curr_pos = 0;
            for(int i = 0; i < (m_position[0]).size(); i++) {

                switch(type[colIndex]) {
                case 0 :
                    cudaMemcpy((void *) ((int_type*)d_columns[colIndex] + curr_pos), (void *) ((int_type*)h_columns[colIndex] + (m_position[m_current])[i]), (m_size[m_current])[i]*int_size, cudaMemcpyHostToDevice);
                    break;
                case 1 :
                    cudaMemcpy((void *) ((float_type*)d_columns[colIndex]  + curr_pos), (void *) ((float_type*)h_columns[colIndex] + (m_position[m_current])[i]), (m_size[m_current])[i]*float_size, cudaMemcpyHostToDevice);
                    break;
                default :
                    CudaChar *c = (CudaChar*)h_columns[colIndex];
                    for(unsigned int k = 0; k < c->mColumnCount; k++)
                        cudaMemcpy((void *) (c->d_columns[k] + curr_pos), (void *) (c->h_columns[k] + (m_position[m_current])[i]), (m_size[m_current])[i], cudaMemcpyHostToDevice);
                };
                curr_pos = curr_pos + (m_size[m_current])[i];
            };
        };
    }

    void CopyColumnToHost(int colIndex, unsigned int offset, unsigned int RecCount)
    {
        if(m_size.empty()) {
		    if(fact_table) {
                switch(type[colIndex]) {
                case 0 :
                    cudaMemcpy((void*)((int_type*)h_columns[colIndex] + offset), d_columns[colIndex], RecCount*int_size, cudaMemcpyDeviceToHost);
                    break;
                case 1 :
                    cudaMemcpy((void*)((float_type*)h_columns[colIndex] + offset), d_columns[colIndex] , RecCount*float_size, cudaMemcpyDeviceToHost);
                    break;
                default :
                    ((CudaChar*)h_columns[colIndex])->CopyToHost(offset,RecCount);
               }
			}   
			else { 
			    unsigned long long int comp_offset = 0;
			    //for(unsigned int i = 0; i < segCount; i++) {
                    switch(type[colIndex]) {
                    case 0 :			
                        comp_offset = pfor_compress(d_columns[colIndex], RecCount*int_size, NULL, h_columns[colIndex], 0, comp_offset);
						break;
                    case 1 :			
					    if (decimal[colIndex]) {
                            thrust::device_ptr<long long int> d_col_dec((long long int*)(d_columns[colIndex]));
							thrust::device_ptr<float_type> d_col_fl((float_type*)(d_columns[colIndex]));
                            thrust::transform(d_col_fl,d_col_fl+RecCount,d_col_dec, float_to_long());						
                            comp_offset = pfor_compress(d_columns[colIndex], RecCount*float_size, NULL, h_columns[colIndex], 0, comp_offset); 													
						}	
                        else { // add code for float
                        } ;
						break;							
                    default :			
                        CudaChar *s = (CudaChar*)(h_columns)[colIndex];       
					    void *cmp = s->compressed;
                        comp_offset = pfor_dict_compress(s->d_columns, s->mColumnCount, NULL, RecCount, cmp, comp_offset);			
                        s->compressed = (char*)cmp;
                    };
				//};	
 					
            };			
        }
    }


    void CopyColumnToHost(int colIndex)
    {
        if(m_size.empty()) 
		    CopyColumnToHost(colIndex, 0, mRecCount);  
        else {
            unsigned int curr_pos = 0;
            for(int i = 0; i < (m_position[0]).size(); i++) {
                switch(type[colIndex]) {
                case 0 :
                    cudaMemcpy((void *) ((int_type*)h_columns[colIndex] + (m_position[m_current])[i]), (void *) ((int_type*)d_columns[colIndex] + curr_pos), (m_size[m_current])[i]*int_size, cudaMemcpyDeviceToHost);
                    break;
                case 1 :
                    cudaMemcpy((void *) ((float_type*)h_columns[colIndex]  + (m_position[m_current])[i]), (void *) ((float_type*)d_columns[colIndex] + curr_pos), (m_size[m_current])[i]*float_size, cudaMemcpyDeviceToHost);
                    break;
                default :
                    CudaChar *c = (CudaChar*)h_columns[colIndex];
                    for(unsigned int k = 0; k < c->mColumnCount; k++)
                        cudaMemcpy((void *) (c->h_columns[k] + (m_position[m_current])[i]), (void *) (c->d_columns[k] + curr_pos), (m_size[m_current])[i], cudaMemcpyDeviceToHost);
                };
                curr_pos = curr_pos + (m_size[m_current])[i];
            };
        };

    }

    void CopyToHost(unsigned int offset, unsigned int count)
    {
        for(unsigned int i = 0; i < mColumnCount; i++) 
		    CopyColumnToHost(i, offset, count);
    }

    float_type* get_float_type_by_name(string name)
    {
        unsigned int colIndex = columnNames.find(name)->second;
        return (float_type*)(d_columns[colIndex]);
    }

    int_type* get_int_by_name(string name)
    {
        unsigned int colIndex = columnNames.find(name)->second;
        return (int_type*)(d_columns[colIndex]);
    }
	
    float_type* get_host_float_by_name(string name)
    {
        unsigned int colIndex = columnNames.find(name)->second;
        return (float_type*)(h_columns[colIndex]);
    }

    int_type* get_host_int_by_name(string name)
    {
        unsigned int colIndex = columnNames.find(name)->second;
        return (int_type*)(h_columns[colIndex]);
    }
	


    void GroupBy(queue<string> columnRef)
    {
        if(!columnGroups.empty())
            cudaFree(grp);

        int grpInd;

        CUDA_SAFE_CALL(cudaMalloc((void **) &grp, mRecCount * sizeof(bool))); // d_di is the vector for segmented scans
        thrust::device_ptr<bool> d_grp(grp);

        thrust::sequence(d_grp, d_grp+mRecCount, 0, 0);

        thrust::device_ptr<bool> d_group = thrust::device_malloc<bool>(mRecCount);
        d_group[mRecCount-1] = 1;

        for(int i = 0; i < columnRef.size(); columnRef.pop()) {
            columnGroups.push(columnRef.front()); // save for future references
            int colIndex = columnNames[columnRef.front()];

            if(d_columns[colIndex] == 0) {
                allocColumnOnDevice(colIndex,mRecCount);
                CopyColumnToGpu(colIndex,  0, mRecCount);
                grpInd = 1;
            }
            else
                grpInd = 0;

            if (type[colIndex] == 0) {  // int_type
                thrust::device_ptr<int_type> d_col((int_type*)d_columns[colIndex]);
                thrust::transform(d_col, d_col + mRecCount - 1, d_col+1, d_group, thrust::not_equal_to<int_type>());
                thrust::transform(d_group, d_group+mRecCount, d_grp, d_grp, thrust::logical_or<bool>());
            }
            else if (type[colIndex] == 1) {  // float_type
                thrust::device_ptr<float_type> d_col((float_type*)d_columns[colIndex]);
                thrust::transform(d_col, d_col + mRecCount - 1, d_col+1, d_group, f_not_equal_to());
                thrust::transform(d_group, d_group+mRecCount, d_grp, d_grp, thrust::logical_or<bool>());
            }
            else  {  // CudaChar
                char* i1;
                for(unsigned int j=0; j < ((CudaChar*)(h_columns)[colIndex])->mColumnCount; j++) {
                    i1 = (((CudaChar*)(h_columns)[colIndex])->d_columns[j]);
                    thrust::device_ptr<char> d_col(i1);
                    thrust::transform(d_col, d_col + mRecCount - 1, d_col+1, d_group, thrust::not_equal_to<char>());
                    thrust::transform(d_group, d_group+mRecCount, d_grp, d_grp, thrust::logical_or<int>());
                }
            };
            if (grpInd == 1)
                deAllocColumnOnDevice(colIndex);
        };

        thrust::device_free(d_group);
        thrust::device_ptr<unsigned int> d_grp_int = thrust::device_malloc<unsigned int>(mRecCount);
        thrust::transform(d_grp, d_grp+mRecCount, d_grp_int, bool_to_int());

        grp_count = thrust::reduce(d_grp_int, d_grp_int+mRecCount);
        thrust::device_free(d_grp_int);
    }


    void addDeviceColumn(int_type* col, int colIndex, string colName, int_type recCount)
    {
        if (columnNames.find(colName) == columnNames.end()) {
            columnNames[colName] = colIndex;
            type[colIndex] = 0;
            allocColumnOnDevice(colIndex, recCount);
        };
        // copy data to d columns
        cudaMemcpy((void *) d_columns[colIndex], (void *) col, recCount*int_size, cudaMemcpyDeviceToDevice);
        mRecCount = recCount;
    };

    void addDeviceColumn(float_type* col, int colIndex, string colName, int_type recCount)
    {
        if (columnNames.find(colName) == columnNames.end()) {
            columnNames[colName] = colIndex;
            type[colIndex] = 1;
            allocColumnOnDevice(colIndex, recCount);
        };
        cudaMemcpy((void *) d_columns[colIndex], (void *) col, recCount*float_size, cudaMemcpyDeviceToDevice);
        mRecCount = recCount;
    };



    void addHostColumn(int_type* col, int colIndex, string colName, int_type recCount, int_type old_reccount, bool one_line)
    {
        if (columnNames.find(colName) == columnNames.end()) {
            columnNames[colName] = colIndex;
            type[colIndex] = 0;
            if (!one_line) {
			    if(!fact_table)
                    h_columns[colIndex] = new int_type[old_reccount];
				else	
                    cudaMallocHost(&h_columns[colIndex], old_reccount*int_size);					
			}	
            else {
			    if(!fact_table)
                    h_columns[colIndex] = new int_type[1];
				else	
                    cudaMallocHost(&h_columns[colIndex], int_size);
			};	

        };

        if (!one_line)
            cudaMemcpy((void *) ((int_type*)h_columns[colIndex] + mRecCount), (void *) col, recCount*int_size, cudaMemcpyDeviceToHost);
        else {
            thrust::device_ptr<int_type> src(col);
            ((int_type*)h_columns[colIndex])[0] = ((int_type*)h_columns[colIndex])[0] + src[0];
        };
    };

    void addHostColumn(float_type* col, int colIndex, string colName, int_type recCount, int_type old_reccount, bool one_line)
    {
        if (columnNames.find(colName) == columnNames.end()) {
            columnNames[colName] = colIndex;
            type[colIndex] = 1;
            if (!one_line) {
			    if(!fact_table)
                    h_columns[colIndex] = new float_type[old_reccount];
				else	
                    cudaMallocHost(&h_columns[colIndex], old_reccount*float_size);
			}	
            else {
			    if(!fact_table)
                    h_columns[colIndex] = new float_type[1];
                else
				    cudaMallocHost(&h_columns[colIndex], float_size);
			};	
        };

        if (!one_line)
            cudaMemcpy((void *) ((float_type*)h_columns[colIndex] + mRecCount), (void *) col, recCount*float_size, cudaMemcpyDeviceToHost);
        else {
            thrust::device_ptr<float_type> src(col);
            ((float_type*)h_columns[colIndex])[0] = ((float_type*)h_columns[colIndex])[0] + src[0];
        };
    };



// a procedure to partition a cudaset by lower bits of the key columns
// the data are on the host.  results should be on the host too

    int partitionCudaSet(unsigned int keyColumn)
    {
        unsigned int current_pos = 0;
        unsigned int copy_count;
        unsigned int chunkCount = getChunkCount(this)/3;
        //chunkCount = 1000;
        unsigned int pieces = mRecCount/chunkCount;
        if (mRecCount%chunkCount != 0)
            pieces++;
        if(pieces == 0)
            pieces = 1;

        unsigned int sz = 0;

        // find a degree of 2 to create bucketCount
        unsigned int degree = 2;

        while(degree < pieces)
            degree = degree*2;

        int_type power = degree-1;
        //cout << "power " <<  power << endl;

        allocOnDevice(chunkCount);

        m_position.clear();
        m_size.clear();
        for(int i = 0 ; i < degree; i++) {
            m_position.push_back(vector <unsigned int>());
            m_size.push_back(vector <unsigned int>());
        };

        // now lets do it for every chunk of records :
        copy_count = chunkCount;
        for(unsigned int i = 0; i < pieces; i++) {

            // copy all columns to device

            if(i == pieces-1)
                copy_count = mRecCount - chunkCount*i;

            CopyToGpu(i*chunkCount, copy_count);


            // power is the count of lower bits of key column that we need to partition on

            thrust::device_ptr<int_type> sd((int_type*)(d_columns)[keyColumn]);
            thrust::device_ptr<unsigned int> d_l = thrust::device_malloc<unsigned int>(copy_count);

            /*	if (i ==0) {
            	  for(int y =0;y < 10;y++) {
            	    int_type a = sd[y];
            		int_type b = a & power;
            	    cout << "SD " << a << " " << b << endl;

            	  };

            	};
            	*/


            unsigned int *d;
            CUDA_SAFE_CALL(cudaMalloc((void **) &d, copy_count * float_size));

            for(int_type ii = 0; ii < degree; ii++) {

                thrust::transform(sd,sd + copy_count, thrust::make_constant_iterator(ii), d_l, comp_bits_functor(power));

                sz = thrust::reduce(d_l, d_l+copy_count);

//	  cout << "SZ for " << ii << " = " << sz << endl;

                if(sz != 0) {
                    m_position[ii].push_back(current_pos);
                    m_size[ii].push_back(sz);

                    for(unsigned int j = 0; j < mColumnCount; j++) {
                        if(type[j] == 0) {
                            thrust::device_ptr<int_type> s((int_type*)(d_columns)[j]);
                            thrust::device_ptr<int_type> ti((int_type*)d);
                            thrust::copy_if(s,s + copy_count, d_l, ti, nz<unsigned int>());
                            cudaMemcpy((void *) ((int_type*)h_columns[j] + current_pos) , (void*)thrust::raw_pointer_cast(ti), sz*int_size, cudaMemcpyDeviceToHost);
                        }
                        else if (type[j] == 1) {
                            thrust::device_ptr<float_type> s((float_type*)(d_columns)[j]);
                            thrust::device_ptr<float_type> tf((float_type*)d);
                            thrust::copy_if(s,s + copy_count, d_l, tf, nz<unsigned int>());
                            cudaMemcpy((void *) ((float_type*)h_columns[j] + current_pos) , (void*)thrust::raw_pointer_cast(tf), sz*float_size, cudaMemcpyDeviceToHost);
                        }
                        else {
                            CudaChar* bb = (CudaChar*)h_columns[j];
                            for (unsigned int z = 0; z < bb->mColumnCount; z++) {
                                thrust::device_ptr<char> s((char*)(bb->d_columns)[z]);
                                thrust::device_ptr<char> tc((char*)d);
                                thrust::copy_if(s, s + copy_count, d_l, tc, nz<unsigned int>());
                                cudaMemcpy((void *) ((char*)bb->h_columns[z] + current_pos) , (void*)thrust::raw_pointer_cast(tc), sz, cudaMemcpyDeviceToHost);
                            };
                        };
                    };
                    current_pos = current_pos + sz;
                }
                else {
                    m_position[ii].push_back(current_pos);
                    m_size[ii].push_back(0);
                };
            };
            thrust::device_free(d_l);
            cudaFree(d);
        };
        deAllocOnDevice();
        return pieces;
    }



    void Store(char* file_name, char* sep, int limit, bool binary )
    {
        if (mRecCount == 0)
            return;

        unsigned int mCount;


        if(limit != 0 && limit < mRecCount)
            mCount = limit;
        else
            mCount = mRecCount;
			
		
        if(binary == 0) {

            FILE *file_pr = fopen(file_name, "w");
            if (file_pr  == NULL)
                cout << "Could not open file " << file_name << endl;

            char buffer [33];	
		    if(d_columns[0] != 0) {	
                for(unsigned int i=0; i < mColumnCount; i++) {				
                    if (type[i] == 0) 
                        cudaMallocHost(&h_columns[i], int_size*(mCount+1)); 
                    else if (type[i] == 1) 
                        cudaMallocHost(&h_columns[i], float_size*mCount);
                    else {
				        CudaChar *c = (CudaChar*) h_columns[i];
                        for(unsigned int i=0; i <c->mColumnCount; i++)
                            c->h_columns[i] = new char[mCount];
				    };	
		        };	
				bool ch = 0;
				if(!fact_table) {
				    fact_table = 1;
					ch = 1;
				};	
                CopyToHost(0,mCount);				
				if(ch)
				    fact_table = 0;
		    }
            else {   // compressed on the host
			   if(!fact_table) {
			       allocOnDevice(mCount);
			       for(unsigned int i=0; i < mColumnCount; i++) {				       
                       CopyColumnToGpu(i);					   
					   
                        if (type[i] == 0) 
                            cudaMallocHost(&h_columns[i], int_size*(mCount+1)); 
                        else if (type[i] == 1) 
                            cudaMallocHost(&h_columns[i], float_size*mCount);
                        else {
				            CudaChar *c = (CudaChar*) h_columns[i];
                            for(unsigned int i=0; i <c->mColumnCount; i++)
                            c->h_columns[i] = new char[mCount];
						};	
				    };	
					fact_table = 1;
					CopyToHost(0,mCount);				
					fact_table = 0;
		        };					
            };  		

            for(unsigned int i=0; i < mCount; i++) {
                for(unsigned int j=0; j < mColumnCount; j++) {
                    if (type[j] == 0) {
                        sprintf(buffer, "%lld", ((int_type*)h_columns[j])[i] );
                        fputs(buffer,file_pr);
                        fputs(sep, file_pr);
                    }
                    else if (type[j] == 1) {
                        sprintf(buffer, "%.2f", ((float_type*)h_columns[j])[i] );
                        fputs(buffer,file_pr);
                        fputs(sep, file_pr);
                    }
                    else {
                        CudaChar* cc = (CudaChar*)(h_columns)[j];
                        char *buf = new char[(cc->mColumnCount)+1];
                        for(int z=0; z<(cc->mColumnCount); z++)
                            buf[z] = (cc->h_columns[z])[i];
                        buf[cc->mColumnCount] = 0;
                        fputs(buf, file_pr);
                        fputs(sep, file_pr);
						delete [] buf;
                    };
                };
                if (i != mCount -1)
                    fputs("\n",file_pr);
            };
            fclose(file_pr);
        }
        else {
            char str[100];
            char col_pos[3];

            bool in_gpu = false;
            if(d_columns[0] != 0)
                in_gpu = true;

			
	        void* d;
			if(!in_gpu) 
                CUDA_SAFE_CALL(cudaMalloc((void **) &d, mCount*float_size));			

            void* host;
            cudaMallocHost(&host, float_size*mCount);			
			
			for(int i = 0; i< mColumnCount; i++)
              if(type[i] == 2 && !in_gpu ) {			    
				  allocColumnOnDevice(i, mCount);
				  CopyColumnToGpu(i,  0, mCount);
			  };	  
				

            for(int i = 0; i< mColumnCount; i++) {

                strcpy(str, file_name);
                strcat(str,".");
                itoaa(cols[i],col_pos);
                strcat(str,col_pos);
                if(type[i] == 0) {
				    if(!in_gpu) {
                        cudaMemcpy(d, (void *) (int_type*)h_columns[i], mCount*int_size, cudaMemcpyHostToDevice);		
						pfor_compress( d, mCount*int_size, str, host, 0, 0);
					}	
                    else 
					    pfor_compress( d_columns[i], mCount*int_size, str, host, 0, 0);
				}		
                else if(type[i] == 1) {
				    if(decimal[i]) {
				        if(!in_gpu) {
                            cudaMemcpy(d, (void *) (float_type*)h_columns[i], mCount*float_size, cudaMemcpyHostToDevice);								
                            thrust::device_ptr<float_type> d_col((float_type*)d);
                            thrust::device_ptr<long long int> d_col_dec((long long int*)d);
                            thrust::transform(d_col,d_col+mCount,d_col_dec, float_to_long());
                            pfor_compress( d, mCount*float_size, str, host, 1, 0);
					    }
                        else {					
				            thrust::device_ptr<float_type> d_col((float_type*)d_columns[i]);
                            thrust::device_ptr<long long int> d_col_dec((long long int*)d_columns[i]);
                            thrust::transform(d_col,d_col+mCount,d_col_dec, float_to_long());
                            pfor_compress( d_columns[i], mCount*float_size, str, host, 1, 0);
					    };	
					}
					else { // do not compress
                        fstream binary_file(str,ios::out|ios::binary|fstream::app);
				        binary_file.write((char *)&mCount, 4);
					    if(in_gpu) {
                            cudaMemcpy(host, d_columns[i], mCount*float_size, cudaMemcpyDeviceToHost);								
                            binary_file.write((char *)host,mCount*float_size);							
					    }
						else
                           binary_file.write((char *)h_columns[i],mCount*float_size);		
						unsigned int comp_type = 3;
                        binary_file.write((char *)&comp_type, 4);						   
                        binary_file.close();
					};
                }
                else {
                    CudaChar *a = (CudaChar*)h_columns[i];
                    pfor_dict_compress(a->d_columns, a->mColumnCount, str, mCount, host, 0);
                };
            };

			for(int i = 0; i< mColumnCount; i++)
              if(type[i] == 2 && !in_gpu)			    
				  deAllocColumnOnDevice(i);
			
			if(!in_gpu) 
			    cudaFree(d);
            cudaFreeHost(host);

        }
    }

    void LoadBigBinaryFile(char* file_name,  long long int diff)
    {
        char str[100];
        char col_pos[3];


		if (d_columns[0] == 0)
            allocOnDevice(mRecCount);
        th = this;

#ifdef _WIN64
//cout << "start waiting " << endl;
        while(!buffersLoaded);
//std::cout<< "waiting time " <<  ( ( std::clock() - start1 ) / (double)CLOCKS_PER_SEC ) <<'\n';
#else
        LoadBuffers((void*)file_name);
#endif

        if(buffersEmpty) {
		    fact_file_loaded = 1;
			mRecCount = 0;
			return;
		};	 
		

        for(int i = 0; i< mColumnCount; i++) {		

            strcpy(str, file_name);
            strcat(str,".");
            itoaa(cols[i],col_pos);
            strcat(str,col_pos);
		
            if (type[i] == 0) 
	            pfor_decompress(d_columns[i], h_columns[i], &mRecCount, 0, filePointers[str]);
	        else if (type[i] == 1)  {			
			    if(decimal[i]) {
                    pfor_decompress(d_columns[i],  h_columns[i], &mRecCount, 0, filePointers[str]);				
                    thrust::device_ptr<long long int> d_col_int((long long int*)d_columns[i]);				
                    thrust::device_ptr<float_type> d_col_float((float_type*)d_columns[i]);				
                    thrust::transform(d_col_int,d_col_int+mRecCount,d_col_float, long_to_float());					
				}
                else  // non compressed float
					CopyColumnToGpu(i,0, mRecCount);
            }
            else {
                CudaChar* a = (CudaChar*)h_columns[i];
                pfor_dict_decompress(a->compressed, a->h_columns, a->d_columns, &mRecCount, filePointers[str], 0, a->mColumnCount, 0);
            };
			
        };
#ifdef _WIN64
        buffersLoaded = 0;
        if (mRecCount != diff)
            _beginthread( LoadBuffers, 0, (void*)file_name );

#endif

    }


	



    void LoadFile(char* file_name, char* sep )
    {
        unsigned int count = 0;
        char line[500];
        int l;
        char* field;
        int current_column = 1;

        FILE *file_ptr = fopen(file_name, "r");
        if (file_ptr  == NULL)
            cout << "Could not open file " << file_name << endl;

        unsigned int *seq = new unsigned int[mColumnCount];
        thrust::sequence(seq, seq+mColumnCount,0,1);
        thrust::stable_sort_by_key(cols, cols+mColumnCount, seq);


        while (fgets(line, 500, file_ptr) != NULL ) {

            current_column = 1;
            field = strtok(line,sep);
			cout << line << endl;

            for(int i = 0; i< mColumnCount; i++) {

                while(cols[i] > current_column) {
                    field = strtok(NULL,sep);
                    current_column++;
                };

                if (type[seq[i]] == 0) {
                    if (strchr(field,'-') == NULL) {
                        ((int_type*)h_columns[seq[i]])[count] = atoi(field);
                    }
                    else {   // handling possible dates
                        strncpy(field+4,field+5,2);
                        strncpy(field+6,field+8,2);
                        field[8] = '\0';
                        ((int_type*)h_columns[seq[i]])[count] = atoi(field);
                    };
                }
                else if (type[seq[i]] == 1)
                    ((float_type*)h_columns[seq[i]])[count] = atoff(field);
                else {
                    l = strlen(field);
                    for(int j =0; j< l; j++)
                        (((CudaChar*)h_columns[seq[i]])->h_columns[j])[count] = field[j];
                    for(int j =l; j< ((CudaChar*)(h_columns)[i])->mColumnCount; j++)
                        (((CudaChar*)h_columns[seq[i]])->h_columns[j])[count] = 0;

                };

            };
            count++;
            if (count == mRecCount)
                resize(process_count);
        };

        //delete [] seq;
        fclose(file_ptr);

		cout << "finished " << count << " " << mRecCount << endl;
        resize(count-mRecCount);
		cout << "resized " << endl;


    }


    int LoadBigFile(char* file_name, char* sep )
    {
        unsigned int count = 0;
        char line[500];
        char* field;
        int current_column = 1;
        int l;

        if (file_p == NULL) 
            file_p = fopen(file_name, "r");
        if (file_p  == NULL)
            cout << "Could not open file " << file_name << endl;

        if (seq == 0) {
            seq = new unsigned int[mColumnCount];
            thrust::sequence(seq, seq+mColumnCount,0,1);
            thrust::stable_sort_by_key(cols, cols+mColumnCount, seq);
        };


        while (count < process_count && fgets(line, 500, file_p) != NULL) {

            current_column = 1;
            field = strtok(line,sep);

            for(int i = 0; i< mColumnCount; i++) {

                while(cols[i] > current_column) {
                    field = strtok(NULL,sep);
                    current_column++;
                };
                if (type[seq[i]] == 0) {
                    if (strchr(field,'-') == NULL) {
                        ((int_type*)h_columns[seq[i]])[count] = atoi(field);
                    }
                    else {   // handling possible dates
                        strncpy(field+4,field+5,2);
                        strncpy(field+6,field+8,2);
                        field[8] = '\0';
                        ((int_type*)h_columns[seq[i]])[count] = atoi(field);
                    };
                }
                else if (type[seq[i]] == 1)
                    ((float_type*)h_columns[seq[i]])[count] = atoff(field);
                else {
                    l = strlen(field);
                    for(int j =0; j< l; j++)
                        (((CudaChar*)h_columns[seq[i]])->h_columns[j])[count] = field[j];
                    for(int j =l; j< ((CudaChar*)(h_columns)[i])->mColumnCount; j++)
                        (((CudaChar*)h_columns[seq[i]])->h_columns[j])[count] = 0;
                };

            };
            count++;
        };

        if (count != mRecCount)
            resize(count-mRecCount);

        if(count < process_count)  {
            fclose(file_p);
            return 1;
        }
        else
            return 0;

    }





    void free()  {
        if(mRecCount !=0) {
            for(unsigned int i=0; i <mColumnCount; i++) {
                if(type[i] != 2) {
                    if(d_columns[i] != 0) {
                        cudaFree(d_columns[i]);
                        d_columns[i] = 0;
                    };
                    if (h_columns[i] != 0) {
					    if(fact_table) {
                            cudaFreeHost(h_columns[i]);
						}	
						else {
                          delete [] h_columns[i];			
						};  
						
					};	
                }
                else 
                    ((CudaChar*)h_columns[i])->free();
            };
        };
        delete [] d_columns;
        delete [] h_columns;
        delete type;
        delete cols;
        if (!seq)
            delete seq;

        if(!columnGroups.empty() && mRecCount !=0)
            cudaFree(grp);
    };




    bool* logical_and(bool* column1, bool* column2)
    {
        thrust::device_ptr<bool> dev_ptr1(column1);
        thrust::device_ptr<bool> dev_ptr2(column2);

        thrust::transform(dev_ptr1, dev_ptr1+mRecCount, dev_ptr2, dev_ptr1, thrust::logical_and<bool>());

        thrust::device_free(dev_ptr2);
        return column1;

    }


    bool* logical_or(bool* column1, bool* column2)
    {

        thrust::device_ptr<bool> dev_ptr1(column1);
        thrust::device_ptr<bool> dev_ptr2(column2);

        thrust::transform(dev_ptr1, dev_ptr1+mRecCount, dev_ptr2, dev_ptr1, thrust::logical_or<bool>());

        thrust::device_free(dev_ptr2);

        return column1;

    }



    bool* compare(int_type s, int_type d, int_type op_type)
    {
        bool res;

        if (op_type == 2) // >
            if(d>s) res = 1;
            else res = 0;
        else if (op_type == 1)  // <
            if(d<s) res = 1;
            else res = 0;
        else if (op_type == 6) // >=
            if(d>=s) res = 1;
            else res = 0;
        else if (op_type == 5)  // <=
            if(d<=s) res = 1;
            else res = 0;
        else if (op_type == 4)// =
            if(d==s) res = 1;
            else res = 0;
        else // !=
            if(d!=s) res = 1;
            else res = 0;

        thrust::device_ptr<bool> p = thrust::device_malloc<bool>(mRecCount);
        thrust::sequence(p, p+mRecCount,res,(bool)0);

        return thrust::raw_pointer_cast(p);
    }


    bool* compare(float_type s, float_type d, int_type op_type)
    {
        bool res;

        if (op_type == 2) // >
            if ((d-s) > EPSILON) res = 1;
            else res = 0;
        else if (op_type == 1)  // <
            if ((s-d) > EPSILON) res = 1;
            else res = 0;
        else if (op_type == 6) // >=
            if (((d-s) > EPSILON) || (((d-s) < EPSILON) && ((d-s) > -EPSILON))) res = 1;
            else res = 0;
        else if (op_type == 5)  // <=
            if (((s-d) > EPSILON) || (((d-s) < EPSILON) && ((d-s) > -EPSILON))) res = 1;
            else res = 0;
        else if (op_type == 4)// =
            if (((d-s) < EPSILON) && ((d-s) > -EPSILON)) res = 1;
            else res = 0;
        else // !=
            if (!(((d-s) < EPSILON) && ((d-s) > -EPSILON))) res = 1;
            else res = 0;

        thrust::device_ptr<bool> p = thrust::device_malloc<bool>(mRecCount);
        thrust::sequence(p, p+mRecCount,res,(bool)0);

        return thrust::raw_pointer_cast(p);


    }


    bool* compare(int_type* column1, int_type d, int_type op_type)
    {
        thrust::device_ptr<bool> temp = thrust::device_malloc<bool>(mRecCount);
        thrust::device_ptr<int_type> dev_ptr(column1);


        if (op_type == 2) // >
            thrust::transform(dev_ptr, dev_ptr+mRecCount, thrust::make_constant_iterator(d), temp, thrust::greater<int_type>());
        else if (op_type == 1)  // <
            thrust::transform(dev_ptr, dev_ptr+mRecCount, thrust::make_constant_iterator(d), temp, thrust::less<int_type>());
        else if (op_type == 6) // >=
            thrust::transform(dev_ptr, dev_ptr+mRecCount, thrust::make_constant_iterator(d), temp, thrust::greater_equal<int_type>());
        else if (op_type == 5)  // <=
            thrust::transform(dev_ptr, dev_ptr+mRecCount, thrust::make_constant_iterator(d), temp, thrust::less_equal<int_type>());
        else if (op_type == 4)// =
            thrust::transform(dev_ptr, dev_ptr+mRecCount, thrust::make_constant_iterator(d), temp, thrust::equal_to<int_type>());
        else // !=
            thrust::transform(dev_ptr, dev_ptr+mRecCount, thrust::make_constant_iterator(d), temp, thrust::not_equal_to<int_type>());

        return thrust::raw_pointer_cast(temp);

    }

    bool* compare(float_type* column1, float_type d, int_type op_type)
    {
        thrust::device_ptr<bool> res = thrust::device_malloc<bool>(mRecCount);
        thrust::device_ptr<float_type> dev_ptr(column1);

        if (op_type == 2) // >
            thrust::transform(dev_ptr, dev_ptr+mRecCount, thrust::make_constant_iterator(d), res, f_greater());
        else if (op_type == 1)  // <
            thrust::transform(dev_ptr, dev_ptr+mRecCount, thrust::make_constant_iterator(d), res, f_less());
        else if (op_type == 6) // >=
            thrust::transform(dev_ptr, dev_ptr+mRecCount, thrust::make_constant_iterator(d), res, f_greater_equal_to());
        else if (op_type == 5)  // <=
            thrust::transform(dev_ptr, dev_ptr+mRecCount, thrust::make_constant_iterator(d), res, f_less_equal());
        else if (op_type == 4)// =
            thrust::transform(dev_ptr, dev_ptr+mRecCount, thrust::make_constant_iterator(d), res, f_equal_to());
        else // !=
            thrust::transform(dev_ptr, dev_ptr+mRecCount, thrust::make_constant_iterator(d), res, f_not_equal_to());

        return thrust::raw_pointer_cast(res);

    }


    bool* compare(int_type* column1, int_type* column2, int_type op_type)
    {
        thrust::device_ptr<int_type> dev_ptr1(column1);
        thrust::device_ptr<int_type> dev_ptr2(column2);
        thrust::device_ptr<bool> temp = thrust::device_malloc<bool>(mRecCount);

        if (op_type == 2) // >
            thrust::transform(dev_ptr1, dev_ptr1+mRecCount, dev_ptr2, temp, thrust::greater<int_type>());
        else if (op_type == 1)  // <
            thrust::transform(dev_ptr1, dev_ptr1+mRecCount, dev_ptr2, temp, thrust::less<int_type>());
        else if (op_type == 6) // >=
            thrust::transform(dev_ptr1, dev_ptr1+mRecCount, dev_ptr2, temp, thrust::greater_equal<int_type>());
        else if (op_type == 5)  // <=
            thrust::transform(dev_ptr1, dev_ptr1+mRecCount, dev_ptr2, temp, thrust::less_equal<int_type>());
        else if (op_type == 4)// =
            thrust::transform(dev_ptr1, dev_ptr1+mRecCount, dev_ptr2, temp, thrust::equal_to<int_type>());
        else // !=
            thrust::transform(dev_ptr1, dev_ptr1+mRecCount, dev_ptr2, temp, thrust::not_equal_to<int_type>());

        return thrust::raw_pointer_cast(temp);

    }

    bool* compare(float_type* column1, float_type* column2, int_type op_type)
    {
        thrust::device_ptr<float_type> dev_ptr1(column1);
        thrust::device_ptr<float_type> dev_ptr2(column2);
        thrust::device_ptr<bool> temp = thrust::device_malloc<bool>(mRecCount);

        if (op_type == 2) // >
            thrust::transform(dev_ptr1, dev_ptr1+mRecCount, dev_ptr2, temp, f_greater());
        else if (op_type == 1)  // <
            thrust::transform(dev_ptr1, dev_ptr1+mRecCount, dev_ptr2, temp, f_less());
        else if (op_type == 6) // >=
            thrust::transform(dev_ptr1, dev_ptr1+mRecCount, dev_ptr2, temp, f_greater_equal_to());
        else if (op_type == 5)  // <=
            thrust::transform(dev_ptr1, dev_ptr1+mRecCount, dev_ptr2, temp, f_less_equal());
        else if (op_type == 4)// =
            thrust::transform(dev_ptr1, dev_ptr1+mRecCount, dev_ptr2, temp, f_equal_to());
        else // !=
            thrust::transform(dev_ptr1, dev_ptr1+mRecCount, dev_ptr2, temp, f_not_equal_to());

        return thrust::raw_pointer_cast(temp);

    }


    bool* compare(float_type* column1, int_type* column2, int_type op_type)
    {
        thrust::device_ptr<float_type> dev_ptr1(column1);
        thrust::device_ptr<int_type> dev_ptr(column2);
        thrust::device_ptr<float_type> dev_ptr2 = thrust::device_malloc<float_type>(mRecCount);;
        thrust::device_ptr<bool> temp = thrust::device_malloc<bool>(mRecCount);

        thrust::transform(dev_ptr, dev_ptr + mRecCount, dev_ptr2, long_to_float_type());

        if (op_type == 2) // >
            thrust::transform(dev_ptr1, dev_ptr1+mRecCount, dev_ptr2, temp, f_greater());
        else if (op_type == 1)  // <
            thrust::transform(dev_ptr1, dev_ptr1+mRecCount, dev_ptr2, temp, f_less());
        else if (op_type == 6) // >=
            thrust::transform(dev_ptr1, dev_ptr1+mRecCount, dev_ptr2, temp, f_greater_equal_to());
        else if (op_type == 5)  // <=
            thrust::transform(dev_ptr1, dev_ptr1+mRecCount, dev_ptr2, temp, f_less_equal());
        else if (op_type == 4)// =
            thrust::transform(dev_ptr1, dev_ptr1+mRecCount, dev_ptr2, temp, f_equal_to());
        else // !=
            thrust::transform(dev_ptr1, dev_ptr1+mRecCount, dev_ptr2, temp, f_not_equal_to());

        thrust::device_free(dev_ptr2);
        return thrust::raw_pointer_cast(temp);

    }




    float_type* op(int_type* column1, float_type* column2, string op_type, int reverse)
    {

        thrust::device_ptr<float_type> temp = thrust::device_malloc<float_type>(mRecCount);
        thrust::device_ptr<int_type> dev_ptr(column1);

        thrust::transform(dev_ptr, dev_ptr + mRecCount, temp, long_to_float_type()); // in-place transformation

        thrust::device_ptr<float_type> dev_ptr1(column2);

        if(reverse == 0) {
            if (op_type.compare("MUL") == 0)
                thrust::transform(dev_ptr1, dev_ptr1+mRecCount, temp, temp, thrust::multiplies<float_type>());
            else if (op_type.compare("ADD") == 0)
                thrust::transform(dev_ptr1, dev_ptr1+mRecCount, temp, temp, thrust::plus<float_type>());
            else if (op_type.compare("MINUS") == 0)
                thrust::transform(dev_ptr1, dev_ptr1+mRecCount, temp, temp, thrust::minus<float_type>());
            else
                thrust::transform(dev_ptr1, dev_ptr1+mRecCount, temp, temp, thrust::divides<float_type>());
        }
        else {
            if (op_type.compare("MUL") == 0)
                thrust::transform(temp, temp+mRecCount, dev_ptr1, temp, thrust::multiplies<float_type>());
            else if (op_type.compare("ADD") == 0)
                thrust::transform(temp, temp+mRecCount, dev_ptr1, temp, thrust::plus<float_type>());
            else if (op_type.compare("MINUS") == 0)
                thrust::transform(temp, temp+mRecCount, dev_ptr1, temp, thrust::minus<float_type>());
            else
                thrust::transform(temp, temp+mRecCount, dev_ptr1, temp, thrust::divides<float_type>());

        };

        return thrust::raw_pointer_cast(temp);

    }




    int_type* op(int_type* column1, int_type* column2, string op_type, int reverse)
    {

        thrust::device_ptr<int_type> temp = thrust::device_malloc<int_type>(mRecCount);
        thrust::device_ptr<int_type> dev_ptr1(column1);
        thrust::device_ptr<int_type> dev_ptr2(column2);

        if(reverse == 0) {
            if (op_type.compare("MUL") == 0)
                thrust::transform(dev_ptr1, dev_ptr1+mRecCount, dev_ptr2, temp, thrust::multiplies<int_type>());
            else if (op_type.compare("ADD") == 0)
                thrust::transform(dev_ptr1, dev_ptr1+mRecCount, dev_ptr2, temp, thrust::plus<int_type>());
            else if (op_type.compare("MINUS") == 0)
                thrust::transform(dev_ptr1, dev_ptr1+mRecCount, dev_ptr2, temp, thrust::minus<int_type>());
            else
                thrust::transform(dev_ptr1, dev_ptr1+mRecCount, dev_ptr2, temp, thrust::divides<int_type>());
        }
        else  {
            if (op_type.compare("MUL") == 0)
                thrust::transform(dev_ptr2, dev_ptr2+mRecCount, dev_ptr1, temp, thrust::multiplies<int_type>());
            else if (op_type.compare("ADD") == 0)
                thrust::transform(dev_ptr2, dev_ptr2+mRecCount, dev_ptr1, temp, thrust::plus<int_type>());
            else if (op_type.compare("MINUS") == 0)
                thrust::transform(dev_ptr2, dev_ptr2+mRecCount, dev_ptr1, temp, thrust::minus<int_type>());
            else
                thrust::transform(dev_ptr2, dev_ptr2+mRecCount, dev_ptr1, temp, thrust::divides<int_type>());
        }

        return thrust::raw_pointer_cast(temp);

    }

    float_type* op(float_type* column1, float_type* column2, string op_type, int reverse)
    {

        thrust::device_ptr<float_type> temp = thrust::device_malloc<float_type>(mRecCount);
        thrust::device_ptr<float_type> dev_ptr1(column1);
        thrust::device_ptr<float_type> dev_ptr2(column2);

        if(reverse == 0) {
            if (op_type.compare("MUL") == 0)
                thrust::transform(dev_ptr1, dev_ptr1+mRecCount, dev_ptr2, temp, thrust::multiplies<float_type>());
            else if (op_type.compare("ADD") == 0)
                thrust::transform(dev_ptr1, dev_ptr1+mRecCount, dev_ptr2, temp, thrust::plus<float_type>());
            else if (op_type.compare("MINUS") == 0)
                thrust::transform(dev_ptr1, dev_ptr1+mRecCount, dev_ptr2, temp, thrust::minus<float_type>());
            else
                thrust::transform(dev_ptr1, dev_ptr1+mRecCount, dev_ptr2, temp, thrust::divides<float_type>());
        }
        else {
            if (op_type.compare("MUL") == 0)
                thrust::transform(dev_ptr2, dev_ptr2+mRecCount, dev_ptr1, temp, thrust::multiplies<float_type>());
            else if (op_type.compare("ADD") == 0)
                thrust::transform(dev_ptr2, dev_ptr2+mRecCount, dev_ptr1, temp, thrust::plus<float_type>());
            else if (op_type.compare("MINUS") == 0)
                thrust::transform(dev_ptr2, dev_ptr2+mRecCount, dev_ptr1, temp, thrust::minus<float_type>());
            else
                thrust::transform(dev_ptr2, dev_ptr2+mRecCount, dev_ptr1, temp, thrust::divides<float_type>());
        };

        return thrust::raw_pointer_cast(temp);

    }

    int_type* op(int_type* column1, int_type d, string op_type, int reverse)
    {
        thrust::device_ptr<int_type> temp = thrust::device_malloc<int_type>(mRecCount);
        thrust::fill(temp, temp+mRecCount, d);

        thrust::device_ptr<int_type> dev_ptr1(column1);

        if(reverse == 0) {
            if (op_type.compare("MUL") == 0)
                thrust::transform(dev_ptr1, dev_ptr1+mRecCount, temp, temp, thrust::multiplies<int_type>());
            else if (op_type.compare("ADD") == 0)
                thrust::transform(dev_ptr1, dev_ptr1+mRecCount, temp, temp, thrust::plus<int_type>());
            else if (op_type.compare("MINUS") == 0)
                thrust::transform(dev_ptr1, dev_ptr1+mRecCount, temp, temp, thrust::minus<int_type>());
            else
                thrust::transform(dev_ptr1, dev_ptr1+mRecCount, temp, temp, thrust::divides<int_type>());
        }
        else {
            if (op_type.compare("MUL") == 0)
                thrust::transform(temp, temp+mRecCount, dev_ptr1, temp, thrust::multiplies<int_type>());
            else if (op_type.compare("ADD") == 0)
                thrust::transform(temp, temp+mRecCount, dev_ptr1, temp, thrust::plus<int_type>());
            else if (op_type.compare("MINUS") == 0)
                thrust::transform(temp, temp+mRecCount, dev_ptr1, temp, thrust::minus<int_type>());
            else
                thrust::transform(temp, temp+mRecCount, dev_ptr1, temp, thrust::divides<int_type>());

        };

        return thrust::raw_pointer_cast(temp);

    }

    float_type* op(int_type* column1, float_type d, string op_type, int reverse)
    {
        thrust::device_ptr<float_type> temp = thrust::device_malloc<float_type>(mRecCount);
        thrust::fill(temp, temp+mRecCount, d);

        thrust::device_ptr<int_type> dev_ptr(column1);
        thrust::device_ptr<float_type> dev_ptr1 = thrust::device_malloc<float_type>(mRecCount);
        thrust::transform(dev_ptr, dev_ptr + mRecCount, dev_ptr1, long_to_float_type());

        if(reverse == 0) {
            if (op_type.compare("MUL") == 0)
                thrust::transform(dev_ptr1, dev_ptr1+mRecCount, temp, temp, thrust::multiplies<float_type>());
            else if (op_type.compare("ADD") == 0)
                thrust::transform(dev_ptr1, dev_ptr1+mRecCount, temp, temp, thrust::plus<float_type>());
            else if (op_type.compare("MINUS") == 0)
                thrust::transform(dev_ptr1, dev_ptr1+mRecCount, temp, temp, thrust::minus<float_type>());
            else
                thrust::transform(dev_ptr1, dev_ptr1+mRecCount, temp, temp, thrust::divides<float_type>());
        }
        else  {
            if (op_type.compare("MUL") == 0)
                thrust::transform(temp, temp+mRecCount, dev_ptr1, temp, thrust::multiplies<float_type>());
            else if (op_type.compare("ADD") == 0)
                thrust::transform(temp, temp+mRecCount, dev_ptr1, temp, thrust::plus<float_type>());
            else if (op_type.compare("MINUS") == 0)
                thrust::transform(temp, temp+mRecCount, dev_ptr1, temp, thrust::minus<float_type>());
            else
                thrust::transform(temp, temp+mRecCount, dev_ptr1, temp, thrust::divides<float_type>());

        };

        thrust::device_free(dev_ptr1);
        return thrust::raw_pointer_cast(temp);

    }



    float_type* op(float_type* column1, float_type d, string op_type,int reverse)
    {
        thrust::device_ptr<float_type> temp = thrust::device_malloc<float_type>(mRecCount);
        thrust::device_ptr<float_type> dev_ptr1(column1);

        if(reverse == 0) {
            if (op_type.compare("MUL") == 0)
                thrust::transform(dev_ptr1, dev_ptr1+mRecCount, thrust::make_constant_iterator(d), temp, thrust::multiplies<float_type>());
            else if (op_type.compare("ADD") == 0)
                thrust::transform(dev_ptr1, dev_ptr1+mRecCount, thrust::make_constant_iterator(d), temp, thrust::plus<float_type>());
            else if (op_type.compare("MINUS") == 0)
                thrust::transform(dev_ptr1, dev_ptr1+mRecCount, thrust::make_constant_iterator(d), temp, thrust::minus<float_type>());
            else
                thrust::transform(dev_ptr1, dev_ptr1+mRecCount, thrust::make_constant_iterator(d), temp, thrust::divides<float_type>());
        }
        else	{
            if (op_type.compare("MUL") == 0)
                thrust::transform(thrust::make_constant_iterator(d), thrust::make_constant_iterator(d)+mRecCount, dev_ptr1, temp, thrust::multiplies<float_type>());
            else if (op_type.compare("ADD") == 0)
                thrust::transform(thrust::make_constant_iterator(d), thrust::make_constant_iterator(d)+mRecCount, dev_ptr1, temp, thrust::plus<float_type>());
            else if (op_type.compare("MINUS") == 0)
                thrust::transform(thrust::make_constant_iterator(d), thrust::make_constant_iterator(d)+mRecCount, dev_ptr1, temp, thrust::minus<float_type>());
            else
                thrust::transform(thrust::make_constant_iterator(d), thrust::make_constant_iterator(d)+mRecCount, dev_ptr1, temp, thrust::divides<float_type>());

        };

        return thrust::raw_pointer_cast(temp);

    }


protected: // methods


    void initialize(queue<string> &nameRef, queue<string> &typeRef, queue<int> &sizeRef, queue<int> &colsRef, int_type Recs, char* file_name) // compressed data for DIM tables
    {
        mColumnCount = nameRef.size();
        h_columns = new void*[mColumnCount];
        d_columns = new void*[mColumnCount];
        type = new unsigned int[mColumnCount];
        cols = new unsigned int[mColumnCount];
		decimal = new bool[mColumnCount];
        file_p = NULL;
		long long int sz;
		FILE* f;
		char f1[100];
		
        readyToProcess = 1;
        mRecCount = Recs;

        for(unsigned int i=0; i < mColumnCount; i++) {

            columnNames[nameRef.front()] = i;
            cols[i] = colsRef.front();
            d_columns[i] = 0;
            seq = 0;
            
            strcpy(f1, file_name);
            strcat(f1,".");
            char col_pos[3];
            itoaa(colsRef.front(),col_pos);
            strcat(f1,col_pos); // read the size of the file			
						
            f = fopen (f1 , "rb" );
			fseeko(f, 0, SEEK_END);
            sz = ftello(f);			
			fseeko(f, 0, SEEK_SET);
			

            if ((typeRef.front()).compare("int") == 0) {
                type[i] = 0;
				decimal[i] = 0;
	            h_columns[i] = new char[sz]; 			

//                if( cudaSuccess != cudaMallocHost(&h_columns[i], sz)) {
//                    cout << "couldn't allocate " << sz << " bytes " << endl;
//                    exit(-1);
//				};	
            }				
            else if ((typeRef.front()).compare("float") == 0) {
                type[i] = 1;
				decimal[i] = 0;
				h_columns[i] = new char[sz]; 			
//                if( cudaSuccess != cudaMallocHost(&h_columns[i], sz)) {
//                    cout << "couldn't allocate " << sz << " bytes " << endl;
//                    exit(-1);
//				};					
            }
            else if ((typeRef.front()).compare("decimal") == 0) {
                type[i] = 1;
				decimal[i] = 1;
				h_columns[i] = new char[sz]; 			
//                if( cudaSuccess != cudaMallocHost(&h_columns[i], sz)) {
//                    cout << "couldn't allocate " << sz << " bytes " << endl;
//                    exit(-1);				
//				};
            }			
            else {
                type[i] = 2;
				decimal[i] = 0;				
                h_columns[i] = new CudaChar(sizeRef.front(), Recs, 0, sz);				
                size_t tt = fread(((CudaChar*)h_columns[i])->compressed,sz,1,f);								
            };
			if(type[i] != 2) 
                fread(h_columns[i],sz,1,f);			
			
 		    fclose(f);										
            nameRef.pop();
            typeRef.pop();
            sizeRef.pop();
            colsRef.pop();			
        };
    };



    void initialize(queue<string> &nameRef, queue<string> &typeRef, queue<int> &sizeRef, queue<int> &colsRef, int_type Recs)
    {
        mColumnCount = nameRef.size();
        h_columns = new void*[mColumnCount];
        d_columns = new void*[mColumnCount];
        type = new unsigned int[mColumnCount];
        cols = new unsigned int[mColumnCount];
		decimal = new bool[mColumnCount];
		
        file_p = NULL;

        readyToProcess = 1;
        mRecCount = Recs;
		segCount = 1;

        for(unsigned int i=0; i < mColumnCount; i++) {

            columnNames[nameRef.front()] = i;
            cols[i] = colsRef.front();
            d_columns[i] = 0;
            seq = 0;

            if ((typeRef.front()).compare("int") == 0) {
                type[i] = 0;
				decimal[i] = 0;
                if( cudaSuccess != cudaMallocHost(&h_columns[i], int_size*(Recs+1))) {
                    cout << "couldn't allocate " << int_size*(Recs+1) << " bytes " << endl;
                    exit(-1);
                };
            }
            else if ((typeRef.front()).compare("float") == 0) {
                type[i] = 1;
				decimal[i] = 0;
                if( cudaSuccess != cudaMallocHost(&h_columns[i], float_size*(Recs+1))) {
                    cout << "couldn't allocate " << float_size*Recs << " bytes " << endl;
                    exit(-1);
                };
            }
            else if ((typeRef.front()).compare("decimal") == 0) {
                type[i] = 1;
				decimal[i] = 1;
                if( cudaSuccess != cudaMallocHost(&h_columns[i], float_size*(Recs+1))) {
                    cout << "couldn't allocate " << float_size*Recs << " bytes " << endl;
                    exit(-1);
                };
            }
			
            else {
                type[i] = 2;
				decimal[i] = 0;
                h_columns[i] = new CudaChar(sizeRef.front(), Recs);
            };
            nameRef.pop();
            typeRef.pop();
            sizeRef.pop();
            colsRef.pop();
        };
    };

    void initialize(unsigned int RecordCount, unsigned int ColumnCount)
    {
        mRecCount = RecordCount;
        mColumnCount = ColumnCount;
		
        h_columns = new void*[mColumnCount];
        d_columns = new void*[mColumnCount];

        type = new unsigned int[mColumnCount];
        cols = new unsigned int[mColumnCount];
		decimal = new bool[mColumnCount];
		
        seq = 0;

        for(int i =0; i < mColumnCount; i++) {
            d_columns[i] = 0;
            h_columns[i] = 0;
            cols[i] = i;
        };
    };
	

    void initialize(CudaSet* a, CudaSet* b, int_type Recs, queue<string> op_sel, queue<string> op_sel_as)
    {
        mRecCount = Recs;
        mColumnCount = op_sel.size();

        h_columns = new void*[mColumnCount];
		
        type = new unsigned int[mColumnCount];
        cols = new unsigned int[mColumnCount];
		decimal = new bool[mColumnCount];

        map<string,int>::iterator it;
        map<int,string> columnNames1;
        readyToProcess = 1;
		
        if (b->fact_table == 1 || a->fact_table == 1) 
            fact_table = 1;
        else {
            fact_table = 0;
		//    offsets = new unsigned long long int[mColumnCount];		
		//	for(unsigned int i = 0; i < mColumnCount;i++)
		//	    offsets[i]= 0;
        };			
			

        d_columns = new void*[mColumnCount];
        for(int i =0; i < mColumnCount; i++) {
            d_columns[i] = 0;			
			h_columns[i] = 0;
		};	

        seq = 0;
        unsigned int i = 0;

        while(!op_sel_as.empty()) {
            columnNames[op_sel_as.front()] = i;
            op_sel_as.pop();
            i++;
        };

        if (Recs != 0) {
		    unsigned int index;
            for(unsigned int i=0; i < mColumnCount; i++) {

                d_columns[i] = 0;				
                if((it = a->columnNames.find(op_sel.front())) !=  a->columnNames.end()) {
                    index = it->second;
                    cols[i] = i;
					decimal[i] = a->decimal[i];

                    if ((a->type)[index] == 0) 
                        type[i] = 0;
                    else if ((a->type)[index] == 1) 
                        type[i] = 1;
                    else {
                        type[i] = 2;
                        h_columns[i] = new CudaChar(((CudaChar*) (a->h_columns)[index])->mColumnCount, Recs, 1);						
                    };
                }
                else {
                    it = b->columnNames.find(op_sel.front());
                    index = it->second;

                    cols[i] = i;
					decimal[i] = b->decimal[index];

                    if ((b->type)[index] == 0) 
                        type[i] = 0;
                    else if ((b->type)[index] == 1) 
                        type[i] = 1;
                    else {
                        type[i] = 2;
                        h_columns[i] = new CudaChar(((CudaChar*) (b->h_columns)[index])->mColumnCount, Recs, 1);						
                    };
                }
                op_sel.pop();
            };
        };
        //if(Recs != 0)
        //    allocOnDevice(Recs);
	    mRecCount = 0;		
    }

};



int reverse_op(int op_type)
{
    if (op_type == 2) // >
        return 5;
    else if (op_type == 1)  // <
        return 6;
    else if (op_type == 6) // >=
        return 1;
    else if (op_type == 5)  // <=
        return 2;
    else return op_type;
}


size_t getFreeMem()
{
    size_t free, total;

    cuMemGetInfo(&free, &total);
//  cout << "Free memory " << free/(1024 * 1024) << " Mbytes out of " << total/(1024 * 1024) << " Mbytes" << endl;
    return free;
} ;

// a procedure that determines how many records of a recordset can fit into GPU memory

unsigned int getSize(CudaSet* a) 
{
    unsigned int sz = 0;
    for(unsigned int i = 0; i < a->mColumnCount; i++) {
        switch(a->type[i]) {
        case 0 :
            sz=sz+int_size;
            break;
        case 1 :
            sz=sz+float_size;
            break;
        default :
            sz = sz +((CudaChar*)a->h_columns[i])->mColumnCount;
        };
    };
    return sz;
}

unsigned int getChunkCount(CudaSet* a)
{
    unsigned int sz = 0;
    for(unsigned int i = 0; i < a->mColumnCount; i++) {
        switch(a->type[i]) {
        case 0 :
            sz=sz+int_size;
            break;
        case 1 :
            sz=sz+float_size;
            break;
        default :
            sz = sz +((CudaChar*)a->h_columns[i])->mColumnCount;
        };
    };
    unsigned int t =  (getFreeMem() *  gpu_mem)/(sz*2);
    if (t > a->mRecCount)
        return a->mRecCount;
    else
        return t;

}

bool joinResInGpu(CudaSet* a, CudaSet* b, unsigned int res_size)
{
    unsigned int sz = 0;
    unsigned int sz1 = 0;
    unsigned int largest_col = 0;
    bool l_a = 1;

    for(unsigned int i = 0; i < a->mColumnCount; i++) {
        switch(a->type[i]) {
        case 0 :
            sz=sz+int_size;
            if(largest_col < int_size)
                largest_col = int_size;
            break;
        case 1 :
            sz=sz+float_size;
            if(largest_col < float_size)
                largest_col = float_size;
            break;
        default :
            sz = sz +((CudaChar*)a->h_columns[i])->mColumnCount;
            if(largest_col < 1)
                largest_col = 1;
        };
    };

    for(unsigned int i = 0; i < b->mColumnCount; i++) {
        switch(b->type[i]) {
        case 0 :
            sz1=sz1+int_size;
            if(largest_col < int_size) {
                largest_col = int_size;
                l_a = 0;
            };
            break;
        case 1 :
            sz1=sz1+float_size;
            if(largest_col < float_size) {
                largest_col = float_size;
                l_a = 0;
            };
            break;
        default :
            sz1 = sz1 +((CudaChar*)b->h_columns[i])->mColumnCount;
            if(largest_col < 1)
                largest_col = 1;
        };
    };

    unsigned int res;
    if(l_a)
        res = (sz+sz1)*res_size + (sz*a->mRecCount);
    else
        res = (sz+sz1)*res_size + (sz1*b->mRecCount);

    if  (getFreeMem() > res)
        return 1;
    else
        return 0;

};





void LoadBuffers(void* file_name)
{
    char str[100];
    char col_pos[3];
    unsigned int cnt;
	long long int lower_val, upper_val;
	map<unsigned int,unsigned int> counts;
	bool check_res = 0;
	FILE* f;

    while(runningRecs < totalRecs && !check_res) {
        for(int i = 0; i< th->mColumnCount; i++) {	
            strcpy(str, (char*)file_name);
            strcat(str,".");
            itoaa(th->cols[i],col_pos);
            strcat(str,col_pos);	

            if (th->filePointers.find(str) == th->filePointers.end())
                th->filePointers[str] = fopen(str, "rb");
            f = th->filePointers[str];
		
            if (th->type[i] == 0 || (th->type[i] == 1 && th->decimal[i]))  {
                fread(&cnt, 4, 1, f);
			    counts[i] = cnt;
			    fread(&lower_val, 8, 1, f);
			    fread(&upper_val, 8, 1, f);
			    //cout << "segment upper lower " << upper_val << " " << lower_val << endl;
			    if (th->type[i] == 0) {
			        ((int_type*)(th->h_columns[i]))[0] = lower_val;
			        ((int_type*)(th->h_columns[i]))[1] = upper_val;
			    }
                else {			
			        ((float_type*)(th->h_columns[i]))[0] = ((float_type)lower_val)/100.0;
			        ((float_type*)(th->h_columns[i]))[1] = ((float_type)upper_val)/100.0;			
			    };
            }		
	    };	
		

	    if(!top_type[th->name].empty()) {
	        check_res = zone_map_check(top_type[th->name],top_value[th->name],top_nums[th->name],top_nums_f[th->name],th);
  	        //cout << "check result "	<< check_res << endl;
		    if (!check_res) {   // do not process segment, move the pointers to the next segment
		        runningRecs = runningRecs + th->maxRecs;
                if (runningRecs >= totalRecs) {
                   buffersEmpty = 1;	
				   buffersLoaded = 1;
				   return;
				}	   
				else   {
			    // adjust file pointers	
				    for(int z = 0; z< th->mColumnCount; z++) {						
					
			            strcpy(str, (char*)file_name);
                        strcat(str,".");
                        itoaa(th->cols[z],col_pos);
                        strcat(str,col_pos);	
						f = th->filePointers[str];

						if (th->type[z] == 0 || (th->type[z] == 1 && th->decimal[z]))  
						    fseeko(f, counts[z]*8 + 40, SEEK_CUR);						
						else if (th->type[z] == 1 && !th->decimal[z]) 
						    fseeko(f, counts[z]*8 + 8, SEEK_CUR);						
						else {
                            unsigned int grp_count;
                            CudaChar *c = (CudaChar*)th->h_columns[z];
                            fread(&cnt, 4, 1, f);
							fseeko(f,cnt*8 + 8,SEEK_CUR);		
							fread(&grp_count, 4, 1, f);
                            fseeko(f,grp_count*c->mColumnCount,SEEK_CUR);		
                        };						
					};
				};
		    };
	    }
		else
		    check_res = 1;
	};	
	
	
    for(int i = 0; i< th->mColumnCount; i++) {	
        strcpy(str, (char*)file_name);
        strcat(str,".");
        itoaa(th->cols[i],col_pos);
        strcat(str,col_pos);	

        f = th->filePointers[str];		

        if (th->type[i] == 0 || (th->type[i] == 1 && th->decimal[i]))  {
            //fread(&cnt, 4, 1, f);
			//fread(&lower_val, 8, 1, f);
			//fread(&upper_val, 8, 1, f);
            fread(th->h_columns[i],counts[i]*8,1,f);			
        }
		else if (th->type[i] == 1 && !th->decimal[i]) {
		    unsigned int grp_count;
		    fread(&cnt, 4, 1, f);
		    fread(th->h_columns[i],cnt*8,1,f);		
			fread(&grp_count, 4, 1, f);
		}	
        else {
            unsigned int grp_count;
            CudaChar *c = (CudaChar*)th->h_columns[i];

            fread(&cnt, 4, 1, f);
            if(!c->compressed) {
                if( cudaSuccess != cudaMallocHost(&(c->compressed), cnt*8)) {
                    cout << "couldn't allocate " << cnt*8 << " chars " << endl;
                    exit(-1);
                };
            };
            fread(c->compressed,cnt*8,1,f);
            fread(&grp_count, 4, 1, f);
            fread(&grp_count, 4, 1, f);
            fread(&grp_count, 4, 1, f);
            for(int j = 0; j < c->mColumnCount; j++)
                fread(c->h_columns[j],grp_count,1,f);
        };
    };
    buffersLoaded = 1;

}




unsigned int findSegmentCount(char* file_name)
{
    unsigned int orig_recCount;
    unsigned int comp_type, cnt;


    FILE* f;
    f = fopen ( file_name , "rb" );
    if (f==NULL) {
        cout << "Cannot open file " << file_name << endl;
        exit (1);
    }
    fread(&cnt, 4, 1, f);
    fseeko(f, cnt*8 + 16, SEEK_CUR);
    fread(&comp_type, 4, 1, f);
    if(comp_type == 2)
        fread(&orig_recCount, 4, 1, f);
	else if(comp_type == 3)	
	    orig_recCount = cnt;
    else {
        fread(&orig_recCount, 4, 1, f);
        fread(&orig_recCount, 4, 1, f);
    };

    fclose(f);

    return orig_recCount;
};



long long int findRecordCount(char* file_name, unsigned int mColumnCount, unsigned int& segCount, unsigned int& maxRecs)
{
    FILE* f;
    unsigned int grp_count;
    f = fopen ( file_name , "rb" );
    if (f==NULL) {
        cout << "Cannot open file " << file_name << endl;
        exit (1);
    }


    long long int RecCount = 0;
	segCount = 0;
	maxRecs = 0;

    unsigned int bits, cnt, fit_count, orig_recCount;
    int_type orig_lower_val;
    unsigned int comp_type;
    long long int start_val;

    while (!feof(f)) {
        fread(&cnt, 4, 1, f);
        if (feof(f)) {
		    fclose(f);
		    return RecCount;
		}
	    segCount++;
        fseeko(f, cnt*8 + 16 , SEEK_CUR);
        fread(&comp_type, 4, 1, f);

        if(comp_type == 3) {
		
		}
		else {
            if(comp_type == 2) {
                fread(&orig_recCount, 4, 1, f);
                fread(&grp_count, 4, 1, f);
                fseeko(f, grp_count*mColumnCount , SEEK_CUR);
                fread(&grp_count, 4, 3, f);
            }		 
            else {
                fread(&orig_recCount, 4, 1, f);
                fread(&orig_recCount, 4, 1, f);
            };
			
       		if (orig_recCount > maxRecs) 
		            maxRecs = orig_recCount;								
			
            RecCount = RecCount + orig_recCount;
            fread(&bits, 4, 1 ,f);
            fread(&orig_lower_val, 8, 1, f);
            fread(&fit_count, 4, 1 ,f);
            fread((char *)&start_val, 8, 1, f);
            fread((char *)&comp_type, 4, 1, f);
		};	

    };
    fclose(f);
    //cout << "found reccount " << RecCount << endl;
    return RecCount;


}

