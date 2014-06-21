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

#include "cm.h"

struct cmp_functor_str
{
    const char  * source;
    const char *str;
    bool * dest;
    const unsigned int * len;

    cmp_functor_str(const char * _source, const char * _str, bool * _dest,
                    const unsigned int * _len):
        source(_source), str(_str), dest(_dest), len(_len) {}

    template <typename IndexType>
    __host__ __device__
    void operator()(const IndexType & i) {

        unsigned int length = len[0];
        unsigned int start = i*length;

        for(unsigned int z = 0; z < length ; z++) {
            if(source[start+z] != str[z]) {
                dest[i] = 0;
                return;
            };

        };
        dest[i] = 1;

    }
};




struct gpu_regex
{
    char  *source;
    char *pattern;
    bool * dest;
    const unsigned int *len;

    gpu_regex(char * _source,char * _pattern, bool * _dest,
              const unsigned int * _len):
        source(_source), pattern(_pattern), dest(_dest), len(_len) {}

    template <typename IndexType>
    __host__ __device__
    void operator()(const IndexType & i) {

        bool star = 0;
        int j = 0;
        char* s;
        char* p;
        char* str = source + len[0]*i;
        char* pat = pattern;

loopStart:
        for (s = str, p = pat; j < len[0] && *s; ++s, ++p, ++j) {
            switch (*p) {
            case '?':
                if (*s == '.') goto starCheck;
                break;
            case '%':
                star = 1;
                str = s, pat = p;
                do {
                    ++pat;
                }
                while (*pat == '%');
                if (!*pat) {
                    dest[i] = 1;
                    return;
                }
                goto loopStart;
            default:
                if (*s != *p)
                    goto starCheck;
                break;
            } /* endswitch */
        } /* endfor */
        while (*p == '%') ++p;
        dest[i] = !*p;
        return;

starCheck:
        if (!star) {
            dest[i] = 0;
            return;
        };
        str++;
        j++;
        goto loopStart;
    }
};









bool* filter(queue<string> op_type, queue<string> op_value, queue<int_type> op_nums,queue<float_type> op_nums_f, CudaSet* a,
             unsigned int segment)
{

    stack<string> exe_type;
    stack<string> exe_value;
    stack<int_type*> exe_vectors;
    stack<float_type*> exe_vectors_f;
    stack<int_type> exe_nums;
    stack<bool*> bool_vectors;
    stack<float_type> exe_nums_f;
    string  s1, s2, s1_val, s2_val;
    int_type n1, n2, res;
    float_type n1_f, n2_f, res_f;


    for(int i=0; !op_type.empty(); ++i, op_type.pop()) {

        string ss = op_type.front();

        if (ss.compare("NAME") == 0 || ss.compare("NUMBER") == 0 || ss.compare("VECTOR") == 0 || ss.compare("FLOAT") == 0
                || ss.compare("STRING") == 0) {

            exe_type.push(ss);
            if (ss.compare("NUMBER") == 0) {
                exe_nums.push(op_nums.front());
                op_nums.pop();
            }
            else if (ss.compare("NAME") == 0 || ss.compare("STRING") == 0) {
                exe_value.push(op_value.front());
                op_value.pop();
            }
            if (ss.compare("FLOAT") == 0) {
                exe_nums_f.push(op_nums_f.front());
                op_nums_f.pop();
            }

        }
        else {
            if (ss.compare("MUL") == 0  || ss.compare("ADD") == 0 || ss.compare("DIV") == 0 || ss.compare("MINUS") == 0) {
                // get 2 values from the stack
                s1 = exe_type.top();
                exe_type.pop();
                s2 = exe_type.top();
                exe_type.pop();


                if (s1.compare("NUMBER") == 0 && s2.compare("NUMBER") == 0) {
                    n1 = exe_nums.top();
                    exe_nums.pop();
                    n2 = exe_nums.top();
                    exe_nums.pop();

                    if (ss.compare("ADD") == 0 )
                        res = n1+n2;
                    else if (ss.compare("MUL") == 0 )
                        res = n1*n2;
                    else if (ss.compare("DIV") == 0 )
                        res = n1/n2;
                    else
                        res = n1-n2;

                    thrust::device_ptr<int_type> p = thrust::device_malloc<int_type>(a->mRecCount);
                    thrust::sequence(p, p+(a->mRecCount),res,(int_type)0);

                    exe_type.push("VECTOR");
                    exe_vectors.push(thrust::raw_pointer_cast(p));
                }
                else if (s1.compare("FLOAT") == 0 && s2.compare("FLOAT") == 0) {
                    n1_f = exe_nums_f.top();
                    exe_nums_f.pop();
                    n2_f = exe_nums_f.top();
                    exe_nums_f.pop();

                    if (ss.compare("ADD") == 0 )
                        res_f = n1_f+n2_f;
                    else if (ss.compare("MUL") == 0 )
                        res_f = n1_f*n2_f;
                    else if (ss.compare("DIV") == 0 )
                        res_f = n1_f/n2_f;
                    else
                        res_f = n1_f-n2_f;

                    thrust::device_ptr<float_type> p = thrust::device_malloc<float_type>(a->mRecCount);
                    thrust::sequence(p, p+(a->mRecCount),res_f,(float_type)0);

                    exe_type.push("VECTOR F");
                    exe_vectors_f.push(thrust::raw_pointer_cast(p));

                }
                else if (s1.compare("NAME") == 0 && s2.compare("FLOAT") == 0) {
                    s1_val = exe_value.top();
                    exe_value.pop();
                    n1_f = exe_nums_f.top();
                    exe_nums_f.pop();
                    printf("CMPF1 %lld \n" , n1);

                    exe_type.push("VECTOR F");

                    if (a->type[s1_val] == 1) {
                        float_type* t = a->get_float_type_by_name(s1_val);
                        exe_vectors_f.push(a->op(t,n1_f,ss,1));
                    }
                    else {
                        int_type* t = a->get_int_by_name(s1_val);
                        exe_vectors_f.push(a->op(t,n1_f,ss,1));
                    };

                }
                else if (s1.compare("FLOAT") == 0 && s2.compare("NAME") == 0) {
                    n1_f = exe_nums_f.top();
                    exe_nums_f.pop();
                    s2_val = exe_value.top();
                    exe_value.pop();
                    printf("CMPF %lld \n" , n1);

                    exe_type.push("VECTOR F");

                    if (a->type[s2_val] == 1) {
                        float_type* t = a->get_float_type_by_name(s2_val);
                        exe_vectors_f.push(a->op(t,n1_f,ss,0));
                    }
                    else {
                        int_type* t = a->get_int_by_name(s2_val);
                        exe_vectors_f.push(a->op(t,n1_f,ss,0));
                    };
                }
                else if (s1.compare("NAME") == 0 && s2.compare("NUMBER") == 0) {
                    s1_val = exe_value.top();
                    exe_value.pop();
                    n1 = exe_nums.top();
                    exe_nums.pop();

                    printf("CMP1 %lld \n" , n1);

                    if (a->type[s1_val] == 1) {
                        float_type* t = a->get_float_type_by_name(s1_val);
                        exe_type.push("VECTOR F");
                        exe_vectors_f.push(a->op(t,(float_type)n1,ss,1));

                    }
                    else {
                        int_type* t = a->get_int_by_name(s1_val);
                        exe_type.push("VECTOR");
                        exe_vectors.push(a->op(t,n1,ss,1));
                    };
                }
                else if (s1.compare("NUMBER") == 0 && s2.compare("NAME") == 0) {
                    n1 = exe_nums.top();
                    exe_nums.pop();
                    s2_val = exe_value.top();
                    exe_value.pop();
                    printf("CMP %lld \n" , n1);


                    if (a->type[s2_val] == 1) {
                        float_type* t = a->get_float_type_by_name(s2_val);
                        exe_type.push("VECTOR F");
                        exe_vectors_f.push(a->op(t,(float_type)n1,ss,0));
                    }
                    else {
                        int_type* t = a->get_int_by_name(s2_val);
                        exe_type.push("VECTOR");
                        exe_vectors.push(a->op(t,n1,ss,0));
                    };
                }
                else if (s1.compare("NAME") == 0 && s2.compare("NAME") == 0) {
                    s1_val = exe_value.top();
                    exe_value.pop();
                    s2_val = exe_value.top();
                    exe_value.pop();

                    if (a->type[s1_val] == 0) {
                        int_type* t1 = a->get_int_by_name(s1_val);
                        if (a->type[s2_val] == 0) {
                            int_type* t = a->get_int_by_name(s2_val);
                            exe_type.push("VECTOR");
                            exe_vectors.push(a->op(t,t1,ss,0));
                        }
                        else {
                            float_type* t = a->get_float_type_by_name(s2_val);
                            exe_type.push("VECTOR F");
                            exe_vectors_f.push(a->op(t1,t,ss,0));
                        };
                    }
                    else {
                        float_type* t = a->get_float_type_by_name(s1_val);
                        if (a->type[s2_val] == 0) {
                            int_type* t1 = a->get_int_by_name(s2_val);
                            exe_type.push("VECTOR F");
                            exe_vectors_f.push(a->op(t1,t,ss,0));
                        }
                        else {
                            float_type* t1 = a->get_float_type_by_name(s2_val);
                            exe_type.push("VECTOR F");
                            exe_vectors_f.push(a->op(t,t1,ss,0));
                        };
                    }
                }
                else if ((s1.compare("VECTOR") == 0 || s1.compare("VECTOR F") == 0 ) && s2.compare("NAME") == 0) {

                    s2_val = exe_value.top();
                    exe_value.pop();

                    if (a->type[s2_val] == 0) {
                        int_type* t = a->get_int_by_name(s2_val);

                        if (s1.compare("VECTOR") == 0 ) {
                            int_type* s3 = exe_vectors.top();
                            exe_vectors.pop();
                            exe_type.push("VECTOR");
                            exe_vectors.push(a->op(t,s3,ss,0));
                            //free s3
                            cudaFree(s3);

                        }
                        else {
                            float_type* s3 = exe_vectors_f.top();
                            exe_vectors_f.pop();
                            exe_type.push("VECTOR F");
                            exe_vectors_f.push(a->op(t,s3,ss,0));
                            cudaFree(s3);
                        }
                    }
                    else {
                        float_type* t = a->get_float_type_by_name(s2_val);
                        if (s1.compare("VECTOR") == 0 ) {
                            int_type* s3 = exe_vectors.top();
                            exe_vectors.pop();
                            exe_type.push("VECTOR F");
                            exe_vectors_f.push(a->op(s3,t, ss,0));
                            cudaFree(s3);
                        }
                        else {
                            float_type* s3 = exe_vectors_f.top();
                            exe_vectors_f.pop();
                            exe_type.push("VECTOR F");
                            exe_vectors_f.push(a->op(t,s3,ss,0));
                            cudaFree(s3);
                        }
                    };
                }
                else if ((s2.compare("VECTOR") == 0 || s2.compare("VECTOR F") == 0 ) && s1.compare("NAME") == 0) {

                    s1_val = exe_value.top();
                    exe_value.pop();

                    if (a->type[s1_val] == 0) {
                        int_type* t = a->get_int_by_name(s1_val);

                        if (s2.compare("VECTOR") == 0 ) {
                            int_type* s3 = exe_vectors.top();
                            exe_vectors.pop();
                            exe_type.push("VECTOR");
                            exe_vectors.push(a->op(t,s3,ss,1));
                            cudaFree(s3);
                        }
                        else {
                            float_type* s3 = exe_vectors_f.top();
                            exe_vectors_f.pop();
                            exe_type.push("VECTOR F");
                            exe_vectors_f.push(a->op(t,s3,ss,1));
                            cudaFree(s3);
                        }
                    }
                    else {
                        float_type* t = a->get_float_type_by_name(s1_val);
                        if (s2.compare("VECTOR") == 0 ) {
                            int_type* s3 = exe_vectors.top();
                            exe_vectors.pop();
                            exe_type.push("VECTOR F");
                            exe_vectors_f.push(a->op(s3,t,ss,1));
                            cudaFree(s3);
                        }
                        else {
                            float_type* s3 = exe_vectors_f.top();
                            exe_vectors_f.pop();
                            exe_type.push("VECTOR F");
                            exe_vectors_f.push(a->op(t,s3,ss,1));
                            cudaFree(s3);
                        }
                    };
                }
                else if ((s1.compare("VECTOR") == 0 || s1.compare("VECTOR F") == 0)  && s2.compare("NUMBER") == 0) {
                    n1 = exe_nums.top();
                    exe_nums.pop();

                    if (s1.compare("VECTOR") == 0 ) {
                        int_type* s3 = exe_vectors.top();
                        exe_vectors.pop();
                        exe_type.push("VECTOR");
                        exe_vectors.push(a->op(s3,n1, ss,1));
                        cudaFree(s3);
                    }
                    else {
                        float_type* s3 = exe_vectors_f.top();
                        exe_vectors_f.pop();
                        exe_type.push("VECTOR F");
                        exe_vectors_f.push(a->op(s3,(float_type)n1, ss,1));
                        cudaFree(s3);
                    }
                }
                else if (s1.compare("NUMBER") == 0 && s2.compare("VECTOR") || s2.compare("VECTOR F") == 0) {
                    n1 = exe_nums.top();
                    exe_nums.pop();

                    if (s2.compare("VECTOR") == 0 ) {
                        int_type* s3 = exe_vectors.top();
                        exe_vectors.pop();
                        exe_type.push("VECTOR");
                        exe_vectors.push(a->op(s3,n1, ss,0));
                        cudaFree(s3);
                    }
                    else {
                        float_type* s3 = exe_vectors_f.top();
                        exe_vectors_f.pop();
                        exe_type.push("VECTOR F");
                        exe_vectors_f.push(a->op(s3,(float_type)n1, ss,0));
                        cudaFree(s3);
                    }
                }

                else if ((s1.compare("VECTOR") == 0 || s1.compare("VECTOR F") == 0)  && s2.compare("FLOAT") == 0) {
                    n1_f = exe_nums_f.top();
                    exe_nums_f.pop();

                    if (s1.compare("VECTOR") == 0 ) {
                        int_type* s3 = exe_vectors.top();
                        exe_vectors.pop();
                        exe_type.push("VECTOR F");
                        exe_vectors_f.push(a->op(s3,n1_f, ss,1));
                        cudaFree(s3);
                    }
                    else {
                        float_type* s3 = exe_vectors_f.top();
                        exe_vectors_f.pop();
                        exe_type.push("VECTOR F");
                        exe_vectors_f.push(a->op(s3,n1_f, ss,1));
                        cudaFree(s3);
                    }
                }
                else if (s1.compare("FLOAT") == 0 && s2.compare("VECTOR") == 0) {
                    n1_f = exe_nums_f.top();
                    exe_nums.pop();

                    if (s2.compare("VECTOR") == 0 ) {
                        int_type* s3 = exe_vectors.top();
                        exe_vectors.pop();
                        exe_type.push("VECTOR F");
                        exe_vectors_f.push(a->op(s3,n1_f, ss,0));
                        cudaFree(s3);
                    }
                    else {
                        float_type* s3 = exe_vectors_f.top();
                        exe_vectors_f.pop();
                        exe_type.push("VECTOR F");
                        exe_vectors_f.push(a->op(s3,n1_f, ss,0));
                        cudaFree(s3);
                    }
                }

                else if (s1.compare("VECTOR") == 0 && s2.compare("VECTOR") == 0) {
                    int_type* s3 = exe_vectors.top();
                    exe_vectors.pop();
                    int_type* s4 = exe_vectors.top();
                    exe_vectors.pop();
                    exe_type.push("VECTOR");
                    exe_vectors.push(a->op(s3, s4,ss,1));
                    cudaFree(s3);
                    cudaFree(s4);
                }
                else if(s1.compare("VECTOR") == 0 && s2.compare("VECTOR F") == 0) {
                    int_type* s3 = exe_vectors.top();
                    exe_vectors.pop();
                    float_type* s4 = exe_vectors_f.top();
                    exe_vectors_f.pop();
                    exe_type.push("VECTOR F");
                    exe_vectors_f.push(a->op(s3, s4,ss,1));
                    cudaFree(s3);
                    cudaFree(s4);
                }
                else if(s1.compare("VECTOR F") == 0 && s2.compare("VECTOR") == 0) {
                    int_type* s3 = exe_vectors.top();
                    exe_vectors.pop();
                    float_type* s4 = exe_vectors_f.top();
                    exe_vectors_f.pop();
                    exe_type.push("VECTOR F");
                    exe_vectors_f.push(a->op(s3, s4,ss,0));
                    cudaFree(s3);
                    cudaFree(s4);
                }
                else if(s1.compare("VECTOR F") == 0 && s2.compare("VECTOR F") == 0) {
                    float_type* s3 = exe_vectors_f.top();
                    exe_vectors_f.pop();
                    float_type* s4 = exe_vectors_f.top();
                    exe_vectors_f.pop();
                    exe_type.push("VECTOR F");
                    exe_vectors_f.push(a->op(s3, s4,ss,1));
                    cudaFree(s3);
                    cudaFree(s4);
                }
            }

            else if (ss.compare("CMP") == 0) {


                int_type cmp_type = op_nums.front();
                op_nums.pop();

                s1 = exe_type.top();
                exe_type.pop();
                s2 = exe_type.top();
                exe_type.pop();

                if (s1.compare("NUMBER") == 0 && s2.compare("NUMBER") == 0) {
                    n1 = exe_nums.top();
                    exe_nums.pop();
                    n2 = exe_nums.top();
                    exe_nums.pop();
                    exe_type.push("VECTOR");
                    bool_vectors.push(a->compare(n1,n2,cmp_type));
                }
                else if (s1.compare("FLOAT") == 0 && s2.compare("FLOAT") == 0) {
                    n1_f = exe_nums_f.top();
                    exe_nums_f.pop();
                    n2_f = exe_nums_f.top();
                    exe_nums_f.pop();
                    exe_type.push("VECTOR");
                    bool_vectors.push(a->compare(n1_f,n2_f,cmp_type));
                }
                else if (s1.compare("FLOAT") == 0 && s2.compare("NUMBER") == 0) {
                    n1_f = exe_nums_f.top();
                    exe_nums_f.pop();
                    n2 = exe_nums.top();
                    exe_nums.pop();
                    exe_type.push("VECTOR");
                    bool_vectors.push(a->compare(n1_f,float_type(n2),cmp_type));
                }
                else if (s1.compare("NUMBER") == 0 && s2.compare("FLOAT") == 0) {
                    n1_f = exe_nums_f.top();
                    exe_nums_f.pop();
                    n2 = exe_nums.top();
                    exe_nums.pop();
                    exe_type.push("VECTOR");
                    bool_vectors.push(a->compare(n1_f,float_type(n2),cmp_type));
                }

                else if (s1.compare("STRING") == 0 && s2.compare("NAME") == 0) {

                    s1_val = exe_value.top();
                    exe_value.pop();
                    s2_val = exe_value.top();
                    exe_value.pop();

                    void* d_v, *d_str, *d_res;
                    cudaMalloc((void **) &d_v, 8);
                    thrust::device_ptr<unsigned int> dd_v((unsigned int*)d_v);
                    dd_v[0] = a->char_size[s2_val];
                    dd_v[1] = (unsigned int)s1_val.length() + 1;
                    cudaMalloc((void **) &d_res, a->mRecCount);

                    thrust::counting_iterator<unsigned int> begin(0);
                    if(cmp_type != 7) {
                        cudaMalloc((void **) &d_str, a->char_size[s2_val]);
                        cudaMemset(d_str,0,a->char_size[s2_val]);
                        cudaMemcpy( d_str, (void *) s1_val.c_str(), s1_val.length(), cudaMemcpyHostToDevice);
                        cmp_functor_str ff(a->d_columns_char[s2_val], (char*)d_str, (bool*)d_res, (unsigned int*)d_v);
                        thrust::for_each(begin, begin + a->mRecCount, ff);
                    }
                    else {
                        cudaMalloc((void **) &d_str, s1_val.length()+1);
                        cudaMemset(d_str,0, s1_val.length()+1);
                        cudaMemcpy( d_str, (void *) s1_val.c_str(), s1_val.length(), cudaMemcpyHostToDevice);
                        gpu_regex ff(a->d_columns_char[s2_val], (char*)d_str, (bool*)d_res, (unsigned int*)d_v);
                        thrust::for_each(begin, begin + a->mRecCount, ff);
                    };


                    exe_type.push("VECTOR");
                    bool_vectors.push((bool*)d_res);
                    cudaFree(d_v);
                    cudaFree(d_str);

                }
                else if (s1.compare("NAME") == 0 && s2.compare("STRING") == 0) {
                    s1_val = exe_value.top();
                    exe_value.pop();
                    s2_val = exe_value.top();
                    exe_value.pop();

                    void* d_v, *d_res, *d_str;
                    cudaMalloc((void **) &d_v, 4);
                    thrust::device_ptr<unsigned int> dd_v((unsigned int*)d_v);
                    dd_v[0] = a->char_size[s1_val];
                    cudaMalloc((void **) &d_res, a->mRecCount);

                    thrust::counting_iterator<unsigned int> begin(0);
                    if(cmp_type != 7) {
                        cudaMalloc((void **) &d_str, a->char_size[s1_val]);
                        cudaMemset(d_str,0,a->char_size[s1_val]);
                        cudaMemcpy( d_str, (void *) s1_val.c_str(), s1_val.length(), cudaMemcpyHostToDevice);
                        cmp_functor_str ff(a->d_columns_char[s1_val], (char*)d_str, (bool*)d_res, (unsigned int*)d_v);
                        thrust::for_each(begin, begin + a->mRecCount, ff);
                    }
                    else {
                        cudaMalloc((void **) &d_str, s1_val.length()+1);
                        cudaMemset(d_str,0, s1_val.length()+1);
                        cudaMemcpy( d_str, (void *) s1_val.c_str(), s1_val.length(), cudaMemcpyHostToDevice);
                        gpu_regex ff(a->d_columns_char[s2_val], (char*)d_str, (bool*)d_res, (unsigned int*)d_v);
                        thrust::for_each(begin, begin + a->mRecCount, ff);
                    };

                    exe_type.push("VECTOR");
                    bool_vectors.push((bool*)d_res);
                    cudaFree(d_v);
                    cudaFree(d_str);
                }


                else if (s1.compare("NUMBER") == 0 && s2.compare("NAME") == 0) {
                    n1 = exe_nums.top();
                    exe_nums.pop();
                    s1_val = exe_value.top();
                    exe_value.pop();

                    if (a->type[s1_val] == 0) {
                        int_type* t = a->get_int_by_name(s1_val);
                        exe_type.push("VECTOR");
                        bool_vectors.push(a->compare(t,n1,cmp_type));
                    }
                    else {
                        float_type* t = a->get_float_type_by_name(s1_val);
                        exe_type.push("VECTOR");
                        bool_vectors.push(a->compare(t,(float_type)n1,cmp_type));
                    };
                }
                else if (s1.compare("NAME") == 0 && s2.compare("NUMBER") == 0) {
                    cmp_type = reverse_op(cmp_type);
                    n1 = exe_nums.top();
                    exe_nums.pop();
                    s2_val = exe_value.top();
                    exe_value.pop();

                    if (a->type[s2_val] == 0) {
                        int_type* t = a->get_int_by_name(s2_val);
                        exe_type.push("VECTOR");
                        bool_vectors.push(a->compare(t,n1,cmp_type));
                    }
                    else {
                        float_type* t = a->get_float_type_by_name(s2_val);
                        exe_type.push("VECTOR");
                        bool_vectors.push(a->compare(t,(float_type)n1,cmp_type));
                    };
                }

                else if (s1.compare("FLOAT") == 0 && s2.compare("NAME") == 0) {
                    n1_f = exe_nums_f.top();
                    exe_nums_f.pop();
                    s1_val = exe_value.top();
                    exe_value.pop();

                    if (a->type[s1_val] == 0) {
                        int_type* t = a->get_int_by_name(s1_val);
                        exe_type.push("VECTOR");
                        bool_vectors.push(a->compare(t,(int_type)n1_f,cmp_type));
                    }
                    else {
                        float_type* t = a->get_float_type_by_name(s1_val);
                        exe_type.push("VECTOR");
                        bool_vectors.push(a->compare(t,n1_f,cmp_type));
                    };
                }
                else if (s1.compare("NAME") == 0 && s2.compare("FLOAT") == 0) {
                    cmp_type = reverse_op(cmp_type);
                    n1_f = exe_nums_f.top();
                    exe_nums_f.pop();
                    s2_val = exe_value.top();
                    exe_value.pop();

                    if (a->type[s2_val] == 0) {
                        int_type* t = a->get_int_by_name(s2_val);
                        exe_type.push("VECTOR");
                        bool_vectors.push(a->compare(t,(int_type)n1_f,cmp_type));
                    }
                    else {
                        float_type* t = a->get_float_type_by_name(s2_val);
                        exe_type.push("VECTOR");
                        bool_vectors.push(a->compare(t,n1_f,cmp_type));
                    };
                }

                else if (s1.compare("VECTOR F") == 0 && s2.compare("NUMBER") == 0) {
                    cmp_type = reverse_op(cmp_type);
                    float_type* s3 = exe_vectors_f.top();
                    exe_vectors_f.pop();
                    n1 = exe_nums.top();
                    exe_nums.pop();
                    exe_type.push("VECTOR");
                    bool_vectors.push(a->compare(s3,(float_type)n1,cmp_type));
                    cudaFree(s3);
                }

                else if (s1.compare("VECTOR") == 0 && s2.compare("NUMBER") == 0) {
                    cmp_type = reverse_op(cmp_type);
                    int_type* s3 = exe_vectors.top();
                    exe_vectors.pop();
                    n1 = exe_nums.top();
                    exe_nums.pop();
                    exe_type.push("VECTOR");
                    bool_vectors.push(a->compare(s3,n1,cmp_type));
                    cudaFree(s3);
                }
                else if (s1.compare("NUMBER") == 0 && s2.compare("VECTOR F") == 0) {

                    float_type* s3 = exe_vectors_f.top();
                    exe_vectors_f.pop();
                    n1 = exe_nums.top();
                    exe_nums.pop();
                    exe_type.push("VECTOR");
                    bool_vectors.push(a->compare(s3,(float_type)n1,cmp_type));
                    cudaFree(s3);
                }

                else if (s1.compare("NUMBER") == 0 && s2.compare("VECTOR") == 0) {

                    int_type* s3 = exe_vectors.top();
                    exe_vectors.pop();
                    n1 = exe_nums.top();
                    exe_nums.pop();
                    exe_type.push("VECTOR");
                    bool_vectors.push(a->compare(s3,n1,cmp_type));
                    cudaFree(s3);
                }

                else if (s1.compare("VECTOR F") == 0 && s2.compare("FLOAT") == 0) {
                    cmp_type = reverse_op(cmp_type);
                    float_type* s3 = exe_vectors_f.top();
                    exe_vectors_f.pop();
                    n1_f = exe_nums_f.top();
                    exe_nums_f.pop();
                    exe_type.push("VECTOR");
                    bool_vectors.push(a->compare(s3,n1_f,cmp_type));
                    cudaFree(s3);
                }
                else if (s1.compare("VECTOR") == 0 && s2.compare("FLOAT") == 0) {
                    cmp_type = reverse_op(cmp_type);
                    int_type* s3 = exe_vectors.top();
                    exe_vectors.pop();
                    n1_f = exe_nums_f.top();
                    exe_nums_f.pop();
                    exe_type.push("VECTOR");
                    bool_vectors.push(a->compare(s3,(int_type)n1_f,cmp_type));
                    cudaFree(s3);
                }
                else if (s1.compare("FLOAT") == 0 && s2.compare("VECTOR F") == 0) {
                    float_type* s3 = exe_vectors_f.top();
                    exe_vectors_f.pop();
                    n1_f = exe_nums_f.top();
                    exe_nums_f.pop();
                    exe_type.push("VECTOR");
                    bool_vectors.push(a->compare(s3,n1_f,cmp_type));
                    cudaFree(s3);
                }

                else if (s1.compare("FLOAT") == 0 && s2.compare("VECTOR") == 0) {
                    int_type* s3 = exe_vectors.top();
                    exe_vectors.pop();
                    n1_f = exe_nums_f.top();
                    exe_nums_f.pop();
                    exe_type.push("VECTOR");
                    bool_vectors.push(a->compare(s3,(int_type)n1_f,cmp_type));
                    cudaFree(s3);
                }

                else if (s1.compare("VECTOR F") == 0 && s2.compare("NAME") == 0) {
                    float_type* s3 = exe_vectors_f.top();
                    exe_vectors_f.pop();
                    s2_val = exe_value.top();
                    exe_value.pop();
                    exe_type.push("VECTOR");

                    if (a->type[s2_val] == 0) {
                        int_type* t = a->get_int_by_name(s2_val);
                        bool_vectors.push(a->compare(s3,t,cmp_type));
                    }
                    else {
                        float_type* t = a->get_float_type_by_name(s2_val);
                        bool_vectors.push(a->compare(t,s3,cmp_type));
                    };
                    cudaFree(s3);
                }


                else if (s1.compare("VECTOR") == 0 && s2.compare("NAME") == 0) {
                    int_type* s3 = exe_vectors.top();
                    exe_vectors.pop();
                    s2_val = exe_value.top();
                    exe_value.pop();
                    exe_type.push("VECTOR");

                    if (a->type[s2_val] == 0) {
                        int_type* t = a->get_int_by_name(s2_val);
                        bool_vectors.push(a->compare(t,s3,cmp_type));
                    }
                    else {
                        float_type* t = a->get_float_type_by_name(s2_val);
                        bool_vectors.push(a->compare(t,s3,cmp_type));
                    };
                    cudaFree(s3);
                }

                else if (s1.compare("NAME") == 0 && s2.compare("VECTOR F") == 0) {
                    cmp_type = reverse_op(cmp_type);
                    float_type* s3 = exe_vectors_f.top();
                    exe_vectors_f.pop();
                    s2_val = exe_value.top();
                    exe_value.pop();
                    exe_type.push("VECTOR");

                    if (a->type[s2_val] == 0) {
                        int_type* t = a->get_int_by_name(s2_val);
                        bool_vectors.push(a->compare(s3,t,cmp_type));
                    }
                    else {
                        float_type* t = a->get_float_type_by_name(s2_val);
                        bool_vectors.push(a->compare(t,s3,cmp_type));
                    };
                    cudaFree(s3);
                }

                else if (s1.compare("NAME") == 0 && s2.compare("VECTOR") == 0) {
                    cmp_type = reverse_op(cmp_type);
                    int_type* s3 = exe_vectors.top();
                    exe_vectors.pop();
                    s2_val = exe_value.top();
                    exe_value.pop();
                    exe_type.push("VECTOR");

                    if (a->type[s2_val] == 0) {
                        int_type* t = a->get_int_by_name(s2_val);
                        bool_vectors.push(a->compare(t,s3,cmp_type));
                    }
                    else {
                        float_type* t = a->get_float_type_by_name(s2_val);
                        bool_vectors.push(a->compare(t,s3,cmp_type));
                    };
                    cudaFree(s3);
                }

                else if (s1.compare("VECTOR") == 0 && s2.compare("VECTOR") == 0) {
                    int_type* s3 = exe_vectors.top();
                    exe_vectors.pop();
                    int_type* s2 = exe_vectors.top();
                    exe_vectors.pop();
                    exe_type.push("VECTOR");
                    bool_vectors.push(a->compare(s2,s3,cmp_type));
                    cudaFree(s3);
                    cudaFree(s2);
                }

                else if (s1.compare("VECTOR F") == 0 && s2.compare("VECTOR F") == 0) {
                    float_type* s3 = exe_vectors_f.top();
                    exe_vectors_f.pop();
                    float_type* s2 = exe_vectors_f.top();
                    exe_vectors_f.pop();
                    exe_type.push("VECTOR");
                    bool_vectors.push(a->compare(s2,s3,cmp_type));
                    cudaFree(s3);
                    cudaFree(s2);
                }

                else if (s1.compare("VECTOR F") == 0 && s2.compare("VECTOR") == 0) {
                    cmp_type = reverse_op(cmp_type);
                    float_type* s3 = exe_vectors_f.top();
                    exe_vectors_f.pop();
                    int_type* s2 = exe_vectors.top();
                    exe_vectors.pop();
                    exe_type.push("VECTOR");
                    bool_vectors.push(a->compare(s3,s2,cmp_type));
                    cudaFree(s3);
                    cudaFree(s2);
                }

                else if (s1.compare("VECTOR") == 0 && s2.compare("VECTOR F") == 0) {
                    float_type* s3 = exe_vectors_f.top();
                    exe_vectors_f.pop();
                    int_type* s2 = exe_vectors.top();
                    exe_vectors.pop();
                    exe_type.push("VECTOR");
                    bool_vectors.push(a->compare(s3,s2,cmp_type));
                    cudaFree(s3);
                    cudaFree(s2);
                }


                else if (s1.compare("NAME") == 0 && s2.compare("NAME") == 0) {
                    s1_val = exe_value.top();
                    exe_value.pop();
                    s2_val = exe_value.top();
                    exe_value.pop();
                    exe_type.push("VECTOR");

                    if (a->type[s1_val] == 0) {
                        int_type* t = a->get_int_by_name(s1_val);
                        if (a->type[s2_val] == 0) {
                            int_type* t1 = a->get_int_by_name(s2_val);
                            bool_vectors.push(a->compare(t1,t,cmp_type));
                        }
                        else {
                            float_type* t1 = a->get_float_type_by_name(s2_val);
                            bool_vectors.push(a->compare(t1,t,cmp_type));
                        };
                    }
                    else {
                        cmp_type = reverse_op(cmp_type);
                        float_type* t = a->get_float_type_by_name(s1_val);
                        if (a->type[s2_val] == 0) {
                            int_type* t1 = a->get_int_by_name(s2_val);
                            bool_vectors.push(a->compare(t,t1,cmp_type));
                        }
                        else {
                            float_type* t1 = a->get_float_type_by_name(s2_val);
                            bool_vectors.push(a->compare(t,t1,cmp_type));
                        };
                    }
                }
            }

            else if (ss.compare("AND") == 0) {
                bool* s3 = bool_vectors.top();
                bool_vectors.pop();
                bool* s2 = bool_vectors.top();
                bool_vectors.pop();
                exe_type.push("VECTOR");
                bool_vectors.push(a->logical_and(s2,s3));
            }
            else if (ss.compare("OR") == 0) {
                bool* s3 = bool_vectors.top();
                bool_vectors.pop();
                bool* s2 = bool_vectors.top();
                bool_vectors.pop();
                exe_type.push("VECTOR");
                bool_vectors.push(a->logical_or(s2,s3));
            }
            else {
                cout << "found nothing " << endl;
            }
        };
    };

    return bool_vectors.top();
}