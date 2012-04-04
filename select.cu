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
#include <thrust/iterator/discard_iterator.h>

void select(queue<string> op_type, queue<string> op_value, queue<int_type> op_nums, queue<float_type> op_nums_f, CudaSet* a, CudaSet* b, int_type old_reccount)
{

    stack<string> exe_type;
    stack<string> exe_value;
    stack<int_type*> exe_vectors;
    stack<int_type> exe_nums;
    string  s1, s2, s1_val, s2_val;
    int_type n1, n2, res;
    unsigned int colCount = 0;
    stack<int> col_type;
    string grp_type;
    stack<string> grp_type1;
    stack<string> col_val;
    int_type res_size = 0;
    //thrust::equal_to<bool> binary_pred_l;

    stack<string> exe_value1;
    stack<int_type*> exe_vectors1;
    stack<float_type*> exe_vectors1_d;
    stack<float_type*> exe_vectors_d;
    stack<int_type> exe_nums1;

    stack<float_type*> exe_vectors_f;
    stack<float_type> exe_nums_f;
    float_type n1_f, n2_f, res_f;
    bool one_line = 0;


    if (a->columnGroups.empty() && a->mRecCount != 0)  
        one_line = 1;
	

    thrust::device_ptr<bool> d_di(a->grp);
    
    if (!(a->columnGroups).empty() && (a->mRecCount != 0))
        res_size = a->grp_count;
		

    for(int i=0; !op_type.empty(); ++i, op_type.pop()) {

        string ss = op_type.front();
		
		
        if(ss.compare("emit sel_name") != 0) {
            grp_type = "NULL";

            if (ss.compare("COUNT") == 0  || ss.compare("SUM") == 0  || ss.compare("AVG") == 0 || ss.compare("MIN") == 0 || ss.compare("MAX") == 0) {
			   			
                if (ss.compare("COUNT") == 0) {			
	

                    grp_type = "COUNT";
                    s1 = exe_type.top();
                    exe_type.pop();							
                    s1_val = exe_value.top();
                    exe_value.pop();											
					
                    if (!a->columnGroups.empty()) {
					    thrust::device_ptr<int_type> count_diff = thrust::device_malloc<int_type>(res_size);
					    thrust::reduce_by_key(d_di, d_di+(a->mRecCount), thrust::constant_iterator<int_type>(1), 
						                      thrust::make_discard_iterator(), count_diff, 
											  head_flag_predicate<bool>(),thrust::plus<int_type>()); 
						
                        exe_vectors.push(thrust::raw_pointer_cast(count_diff));
                    }
                    else {
                        thrust::device_ptr<int_type> dest  = thrust::device_malloc<int_type>(1);
                        dest[0] = a->mRecCount;
                        exe_vectors.push(thrust::raw_pointer_cast(dest));
                    }
                }
                else if (ss.compare("SUM") == 0) {
				
                    grp_type = "SUM";
                    s1 = exe_type.top();
                    exe_type.pop();

					if (s1.compare("VECTOR F") == 0) {
                        float_type* s3 = exe_vectors_f.top();
                        exe_vectors_f.pop();
						
                        if (!a->columnGroups.empty()) {                            
                            thrust::device_ptr<float_type> source((float_type*)(s3));
                            thrust::device_ptr<float_type> count_diff = thrust::device_malloc<float_type>(res_size);
							
    						thrust::reduce_by_key(d_di, d_di+(a->mRecCount), source, 
	    					                      thrust::make_discard_iterator(), count_diff, 
		    				        		      head_flag_predicate<bool>(),thrust::plus<float_type>()); 
												  
                            exe_vectors_f.push(thrust::raw_pointer_cast(count_diff));
							exe_type.push("VECTOR F");
                        }
						else {
                            thrust::device_ptr<float_type> source((float_type*)(s3));
                            thrust::device_ptr<float_type> count_diff = thrust::device_malloc<float_type>(1);
						    count_diff[0] = thrust::reduce(source, source+a->mRecCount);							
                            exe_vectors_f.push(thrust::raw_pointer_cast(count_diff));
							exe_type.push("VECTOR F");						
						};
                        cudaFree(s3);								
					}
					if (s1.compare("VECTOR") == 0) {
                        int_type* s3 = exe_vectors.top();
                        exe_vectors.pop();
						
                        if (!a->columnGroups.empty()) {                            
                            thrust::device_ptr<int_type> source((int_type*)(s3));
                            thrust::device_ptr<int_type> count_diff = thrust::device_malloc<int_type>(res_size);
							
    						thrust::reduce_by_key(d_di, d_di+(a->mRecCount), source, 
	    					                      thrust::make_discard_iterator(), count_diff, 
		    				        		      head_flag_predicate<bool>(),thrust::plus<int_type>()); 
												  
                            exe_vectors.push(thrust::raw_pointer_cast(count_diff));
							exe_type.push("VECTOR");
                        }
						else {
                            thrust::device_ptr<int_type> source((int_type*)(s3));
                            thrust::device_ptr<int_type> count_diff = thrust::device_malloc<int_type>(1);
						    count_diff[0] = thrust::reduce(source, source+a->mRecCount);							
                            exe_vectors.push(thrust::raw_pointer_cast(count_diff));
							exe_type.push("VECTOR");						
						};
                        cudaFree(s3);								
					}
					
					else if (s1.compare("NAME") == 0) {		
                        s1_val = exe_value.top();
                        exe_value.pop();		
				
                        unsigned int colIndex = (a->columnNames).find(s1_val)->second;
                        if (!a->columnGroups.empty()) {

                            if((a->type)[colIndex] == 0) {
                                thrust::device_ptr<int_type> source((int_type*)(a->d_columns)[colIndex]);
                                thrust::device_ptr<int_type> count_diff = thrust::device_malloc<int_type>(res_size);
							
						        thrust::reduce_by_key(d_di, d_di+(a->mRecCount), source, 
						                              thrust::make_discard_iterator(), count_diff, 
									    		       head_flag_predicate<bool>(),thrust::plus<int_type>()); 							
                                exe_vectors.push(thrust::raw_pointer_cast(count_diff));	
                                exe_type.push("VECTOR");								
                            }
                            else if((a->type)[colIndex] == 1) {
                                thrust::device_ptr<float_type> source((float_type*)(a->d_columns)[colIndex]);
                                thrust::device_ptr<float_type> count_diff = thrust::device_malloc<float_type>(res_size);
							
    						    thrust::reduce_by_key(d_di, d_di+(a->mRecCount), source, 
	    					                          thrust::make_discard_iterator(), count_diff, 
		    									       head_flag_predicate<bool>(),thrust::plus<float_type>()); 
									
                                exe_vectors_f.push(thrust::raw_pointer_cast(count_diff));
								exe_type.push("VECTOR F");
                            }
                        }
                        else {
                            if((a->type)[colIndex] == 0) {
                                thrust::device_ptr<int_type> source((int_type*)(a->d_columns)[colIndex]);
                                thrust::device_ptr<int_type> dest;
                                int_type cc = thrust::reduce(source, source+a->mRecCount);
                                if (one_line) {
                                    dest = thrust::device_malloc<int_type>(1);
                                    dest[0] = cc;
                                }
                                else {
                                    dest = thrust::device_malloc<int_type>(a->mRecCount);
                                    thrust::sequence(dest, dest+(a->mRecCount), cc, (int_type)0);
                                };
                                exe_vectors.push(thrust::raw_pointer_cast(dest));
								exe_type.push("VECTOR");
                            }
                            else if((a->type)[colIndex] == 1) {
                                thrust::device_ptr<float_type> source((float_type*)(a->d_columns)[colIndex]);
                                thrust::device_ptr<float_type> dest;
                                float_type cc = thrust::reduce(source, source+a->mRecCount);

                                if (one_line) {
                                    dest = thrust::device_malloc<float_type>(1);
                                    dest[0] = cc;
                                }
                                else {
                                    dest = thrust::device_malloc<float_type>(a->mRecCount);
                                    thrust::sequence(dest, dest+a->mRecCount, cc, (float_type)0);
                                };
                                exe_vectors_f.push(thrust::raw_pointer_cast(dest));
                                exe_type.push("VECTOR F");
                            };
                        };
                    }
				}	
                else if (ss.compare("MIN") == 0) {

                    grp_type = "MIN";
                    s1 = exe_type.top();
                    exe_type.pop();		
					
                    s1_val = exe_value.top();
                    exe_value.pop();											
                    unsigned int colIndex = (a->columnNames).find(s1_val)->second;
					
                    if((a->type)[colIndex] == 0) {
                        thrust::device_ptr<int_type> source((int_type*)(a->d_columns)[colIndex]);

                        thrust::device_ptr<int_type> count_diff = thrust::device_malloc<int_type>(res_size);
					    thrust::reduce_by_key(d_di, d_di+(a->mRecCount), source, 
					                          thrust::make_discard_iterator(), count_diff, 
										       head_flag_predicate<bool>(),thrust::minimum<int_type>()); 
                        exe_vectors.push(thrust::raw_pointer_cast(count_diff));

                    }
                    else if((a->type)[colIndex] == 1) {
                        thrust::device_ptr<float_type> source((float_type*)(a->d_columns)[colIndex]);

                        thrust::device_ptr<float_type> count_diff = thrust::device_malloc<float_type>(res_size);
					    thrust::reduce_by_key(d_di, d_di+(a->mRecCount), source, 
						                          thrust::make_discard_iterator(), count_diff, 
											       head_flag_predicate<bool>(),thrust::minimum<float_type>()); 
                        exe_vectors_f.push(thrust::raw_pointer_cast(count_diff));

                    }
                }

                else if (ss.compare("AVG") == 0) {
                    grp_type = "AVG";
                    s1 = exe_type.top();
                    exe_type.pop();		
					
                    s1_val = exe_value.top();
                    exe_value.pop();							

					
                    unsigned int colIndex = (a->columnNames).find(s1_val)->second;
                    if((a->type)[colIndex] == 0) {
                        thrust::device_ptr<int_type> source((int_type*)(a->d_columns)[colIndex]);

                        thrust::device_ptr<int_type> count_diff = thrust::device_malloc<int_type>(res_size);
				        thrust::reduce_by_key(d_di, d_di+(a->mRecCount), source, 
						                      thrust::make_discard_iterator(), count_diff, 
						 			           head_flag_predicate<bool>(),thrust::plus<int_type>()); 

                        exe_vectors.push(thrust::raw_pointer_cast(count_diff));
						exe_type.push("VECTOR");
                    }
                    else if((a->type)[colIndex] == 1) {
                        thrust::device_ptr<float_type> source((float_type*)(a->d_columns)[colIndex]);
                        thrust::device_ptr<float_type> count_diff = thrust::device_malloc<float_type>(res_size);
					    thrust::reduce_by_key(d_di, d_di+(a->mRecCount), source, 
					                          thrust::make_discard_iterator(), count_diff, 
										       head_flag_predicate<bool>(),thrust::plus<float_type>()); 
                        exe_vectors_f.push(thrust::raw_pointer_cast(count_diff));						
						exe_type.push("VECTOR F");
                    }
                };

                //op_value.pop();
            };

            if (ss.compare("NAME") == 0 || ss.compare("NUMBER") == 0 || ss.compare("VECTOR") == 0 || ss.compare("VECTOR F") == 0) {

                exe_type.push(ss);
                if (ss.compare("NUMBER") == 0) {
                    exe_nums.push(op_nums.front());
                    op_nums.pop();
                }
                else if (ss.compare("NAME") == 0) {
                    exe_value.push(op_value.front());
                    op_value.pop();
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

                        exe_type.push("VECTOR F");

                        if (a->type[(a->columnNames)[s1_val]] == 1) {
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

                        exe_type.push("VECTOR F");

                        if (a->type[(a->columnNames)[s2_val]] == 1) {
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

                        if (a->type[(a->columnNames)[s1_val]] == 1) {
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

                        if (a->type[(a->columnNames)[s2_val]] == 1) {
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

                        if (a->type[(a->columnNames)[s1_val]] == 0) {
                            int_type* t1 = a->get_int_by_name(s1_val);
                            if (a->type[(a->columnNames)[s2_val]] == 0) {
                                int_type* t = a->get_int_by_name(s2_val);
                                exe_type.push("VECTOR");
                                exe_vectors.push(a->op(t1,t,ss,0));
                            }
                            else {
                                float_type* t = a->get_float_type_by_name(s2_val);
                                exe_type.push("VECTOR F");
                                exe_vectors_f.push(a->op(t1,t,ss,0));
                            };
                        }
                        else {
                            float_type* t = a->get_float_type_by_name(s1_val);
                            if (a->type[(a->columnNames)[s2_val]] == 0) {
                                int_type* t1 = a->get_int_by_name(s2_val);
                                exe_type.push("VECTOR F");
                                exe_vectors_f.push(a->op(t1,t,ss,0));
                            }
                            else {
                                float_type* t1 = a->get_float_type_by_name(s2_val);
                                exe_type.push("VECTOR F");
                                exe_vectors_f.push(a->op(t1,t,ss,0));
                            };
                        }
                    }
                    else if ((s1.compare("VECTOR") == 0 || s1.compare("VECTOR F") == 0 ) && s2.compare("NAME") == 0) {

                        s2_val = exe_value.top();
                        exe_value.pop();

                        if (a->type[(a->columnNames)[s2_val]] == 0) {
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

                        if (a->type[(a->columnNames)[s1_val]] == 0) {
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
                            exe_vectors_f.push(a->op(s3,n1, ss,1));
                            cudaFree(s3);
                        }
                    }
                    else if (s1.compare("NUMBER") == 0 && (s2.compare("VECTOR") || s2.compare("VECTOR F") == 0)) {
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
                            exe_vectors_f.push(a->op(s3,n1, ss,0));
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
                        n1_f = exe_nums.top();
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
                        exe_vectors.push(a->op(s3, s4,ss,0));
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
            }

        } //
        else {
            // here we need to save what is where
			
            col_val.push(op_value.front());
            op_value.pop();

            grp_type1.push(grp_type);
			
			


            if(!exe_nums.empty()) {  //number
                col_type.push(0);
                exe_nums1.push(exe_nums.top());
                exe_nums.pop();
            };
            if(!exe_value.empty()) {  //field name
                col_type.push(1);
                exe_value1.push(exe_value.top());
                exe_value.pop();
            };
            if(!exe_vectors.empty()) {  //vector int
                exe_vectors1.push(exe_vectors.top());
                exe_vectors.pop();
                col_type.push(2);
            };
            if(!exe_vectors_f.empty()) {  //vector float
                exe_vectors1_d.push(exe_vectors_f.top());
                exe_vectors_f.pop();
                col_type.push(3);
            };

            colCount++;
        };
    };
	

    b->grp_type = new unsigned int[colCount];

    for(int j=0; j<colCount; j++) {
	
        if ((grp_type1.top()).compare("COUNT") == 0 )
            b->grp_type[colCount-j-1] = 0;
        else if ((grp_type1.top()).compare("AVG") == 0 )
            b->grp_type[colCount-j-1] = 1;
        else if ((grp_type1.top()).compare("SUM") == 0 )
            b->grp_type[colCount-j-1] = 2;
        else if ((grp_type1.top()).compare("NULL") == 0 )
            b->grp_type[colCount-j-1] = 3;
        else if ((grp_type1.top()).compare("MIN") == 0 )
            b->grp_type[colCount-j-1] = 4;
        else if ((grp_type1.top()).compare("MAX") == 0 )
            b->grp_type[colCount-j-1] = 5;


        if(col_type.top() == 0) {

            // create a vector

            thrust::device_ptr<int_type> s = thrust::device_malloc<int_type>(a->mRecCount);
            thrust::sequence(s, s+(a->mRecCount), (int)exe_nums1.top(), 0);
            if (!(a->columnGroups).empty()) {
                thrust::device_ptr<int_type> count_diff = thrust::device_malloc<int_type>(res_size);
                thrust::device_ptr<bool> d_grp(a->grp);
                thrust::copy_if(s,s+(a->mRecCount), d_grp, count_diff, nz<bool>());
                b->addDeviceColumn(thrust::raw_pointer_cast(count_diff) , colCount-j-1, col_val.top(), res_size);
                thrust::device_free(count_diff);
            }
            else
                b->addHostColumn(thrust::raw_pointer_cast(s) , colCount-j-1, col_val.top(), a->mRecCount, old_reccount, one_line);
            exe_nums1.pop();
        };
        if(col_type.top() == 1) {

            unsigned int colIndex = (a->columnNames).find(exe_value1.top())->second;


            if(a->type[colIndex] == 0) {
                thrust::device_ptr<int_type> s((int_type*)(a->d_columns)[colIndex]);
                //modify what we push there in case of a grouping
                if (!(a->columnGroups).empty()) {
                    thrust::device_ptr<int_type> count_diff = thrust::device_malloc<int_type>(res_size);
                    thrust::device_ptr<bool> d_grp(a->grp);

                    thrust::copy_if(s,s+(a->mRecCount), d_grp, count_diff, nz<bool>());
                    b->addDeviceColumn(thrust::raw_pointer_cast(count_diff) , colCount-j-1, col_val.top(), res_size);
                    thrust::device_free(count_diff);
                }
                else
                    b->addHostColumn(thrust::raw_pointer_cast(s) , colCount-j-1, col_val.top(), a->mRecCount, old_reccount, one_line);

            }
            else if(a->type[colIndex] == 1) {
                thrust::device_ptr<float_type> s((float_type*)(a->d_columns)[colIndex]);

                //modify what we push there in case of a grouping
                if (!(a->columnGroups).empty()) {
                    thrust::device_ptr<float_type> count_diff = thrust::device_malloc<float_type>(res_size);
                    thrust::device_ptr<bool> d_grp(a->grp);

                    thrust::copy_if(s,s+(a->mRecCount), d_grp, count_diff, nz<bool>());
                    b->addDeviceColumn(thrust::raw_pointer_cast(count_diff) , colCount-j-1, col_val.top(), res_size);
                    thrust::device_free(count_diff);
                }
                else
                    b->addHostColumn(thrust::raw_pointer_cast(s) , colCount-j-1, col_val.top(), a->mRecCount, old_reccount, one_line);
            }
            else if(a->type[colIndex] == 2) { //varchar

                if (b->columnNames.find(col_val.top()) == b->columnNames.end()) {
                    CudaChar* n = new CudaChar(((CudaChar*)(a->h_columns)[colIndex])->mColumnCount, old_reccount);
                    b->h_columns[colCount-j-1] = n;
                    b->columnNames[col_val.top()] = colCount-j-1;
                    b->type[colCount-j-1] = 2;
                };
                CudaChar *cc = (CudaChar*)(a->h_columns)[colIndex];
                CudaChar* nn = (CudaChar*)b->h_columns[colCount-j-1];

                //modify what we push there in case of a grouping
                if (!(a->columnGroups).empty()) {

                    nn->allocOnDevice(a->mRecCount);
                    thrust::device_ptr<bool> d_grp(a->grp);

                    for(unsigned int k=0; k < (nn->mColumnCount); k++) {
                        thrust::device_ptr<char> sr((cc->d_columns)[k]);
                        thrust::device_ptr<char> de((nn->d_columns)[k]);

                        thrust::copy_if(sr,sr+(a->mRecCount), d_grp, de, nz<bool>());
                    };

                }
                else {
                    //copy the cc to new
                    for(unsigned int k=0; k < (nn->mColumnCount); k++)
                        cudaMemcpy((void *) (nn->h_columns[k] + b->mRecCount), (void *) (cc->d_columns)[k], a->mRecCount, cudaMemcpyDeviceToHost);
                }
            }
            exe_value1.pop();
        };

        if(col_type.top() == 2) {	    // int

            if (!(a->columnGroups).empty())
                b->addDeviceColumn(exe_vectors1.top() , colCount-j-1, col_val.top(), res_size);
            else
                b->addHostColumn(exe_vectors1.top() , colCount-j-1, col_val.top(), a->mRecCount, old_reccount, one_line);

            cudaFree(exe_vectors1.top());
            exe_vectors1.pop();
        }
        if(col_type.top() == 3) {        //float

            if (!(a->columnGroups).empty()) {
                b->addDeviceColumn(exe_vectors1_d.top() , colCount-j-1, col_val.top(), res_size);
            }
            else
                b->addHostColumn(exe_vectors1_d.top() , colCount-j-1, col_val.top(), a->mRecCount, old_reccount, one_line);
            cudaFree(exe_vectors1_d.top());
            exe_vectors1_d.pop();
        };


        col_type.pop();
        col_val.pop();
        grp_type1.pop();
    };
    if ((a->columnGroups).empty()) {
        if ( !one_line)
            b->mRecCount = b->mRecCount + a->mRecCount;
        else
            b->mRecCount = b->mRecCount + 1;
    }
    else
        b->mRecCount = res_size;
}

