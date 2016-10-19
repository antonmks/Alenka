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

#include "filter.h"
#include "zone_map.h"
#include <iomanip>
#include <iostream>
#include <sstream>

struct cmp_functor_dict
{
	const unsigned long long* source;
	bool *dest;
	const unsigned int *pars;

	cmp_functor_dict(const unsigned long long int* _source, bool * _dest,  const unsigned int * _pars):
		source(_source), dest(_dest), pars(_pars) {}

	template <typename IndexType>
	__host__ __device__
	void operator()(const IndexType & i) {

		unsigned int idx = pars[0];
		unsigned int cmp = pars[1];
		unsigned int bits = ((unsigned int*)source)[1];
		unsigned int fit_count = ((unsigned int*)source)[0];
		unsigned int int_sz = 64;

		//find the source index
		unsigned int src_idx = i/fit_count;
		// find the exact location
		unsigned int src_loc = i%fit_count;
		//right shift the values
		unsigned int shifted = ((fit_count-src_loc)-1)*bits;
		unsigned long long int tmp = source[src_idx+2]  >> shifted;
		// set  the rest of bits to 0
		tmp	= tmp << (int_sz - bits);
		tmp	= tmp >> (int_sz - bits);
		//printf("COMP1 %llu %d \n", tmp, idx);
		if(cmp == 4) { // ==
			if(tmp == idx)
				dest[i] = 1;
			else
				dest[i] = 0;
		}
		else  { // !=
			if(tmp == idx)
				dest[i] = 0;
			else
				dest[i] = 1;
		};
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
				if (*s == '.')
					goto starCheck;
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
			default
					:
				if (*s != *p)
					goto starCheck;
				break;
			} /* endswitch */
		} /* endfor */
		while (*p == '%')
			++p;
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



bool* filter(queue<string> op_type, queue<string> op_value, queue<int_type> op_nums,queue<float_type> op_nums_f, queue<unsigned int> op_nums_precision, CudaSet* a,
             unsigned int segment)
{

	stack<string> exe_type;
	stack<string> exe_value;
	stack<int_type*> exe_vectors;
	stack<unsigned int> exe_precision;
	stack<int_type> exe_nums;
	stack<bool*> bool_vectors;
	string  s1, s2, s1_val, s2_val;
	int_type n1, n2, res;

	for(int i=0; !op_type.empty(); ++i, op_type.pop()) {

		string ss = op_type.front();
		//cout << endl << ss << " " <<  op_nums.size() << " " << op_nums_precision.size() << endl;

		if (ss.compare("NAME") == 0 || ss.compare("NUMBER") == 0 || ss.compare("FLOAT") == 0
		        || ss.compare("STRING") == 0 || ss.compare("FIELD") == 0) {


			if (ss.compare("NUMBER") == 0) {
				exe_nums.push(op_nums.front());
				op_nums.pop();
				exe_type.push(ss);
				exe_precision.push(op_nums_precision.front());
				op_nums_precision.pop();
			}
			else
				if (ss.compare("NAME") == 0 || ss.compare("STRING") == 0) {
					exe_value.push(op_value.front());
					op_value.pop();
					exe_type.push(ss);
				}
				else
					if(ss.compare("FIELD") == 0) {
						size_t pos1 = op_value.front().find_first_of(".", 0);
						string tbl = op_value.front().substr(0,pos1);
						string field = op_value.front().substr(pos1+1, string::npos);
						op_value.pop();
						CudaSet *b = varNames.find(tbl)->second;
						auto val = b->h_columns_int[field][0];
						exe_nums.push(val);
						exe_type.push("NUMBER");
					}
		}
		else {
			if (ss.compare("MUL") == 0  || ss.compare("ADD") == 0 || ss.compare("DIV") == 0 || ss.compare("MINUS") == 0) {
				// get 2 values from the stack

				s1 = exe_type.top();
				exe_type.pop();
				s2 = exe_type.top();
				exe_type.pop();


				if (s1.compare("NAME") == 0 && s2.compare("STRING") == 0) {
					s1_val = exe_value.top();
					exe_value.pop();
					s2_val = exe_value.top();
					exe_value.pop();

					int_type* t = get_vec(a, s1_val, exe_vectors);
					exe_type.push("NAME");
					exe_value.push("");
					exe_precision.push(0);

				}
				else
					if (s2.compare("NAME") == 0 && s1.compare("STRING") == 0) {
						s2_val = exe_value.top();
						exe_value.pop();
						s1_val = exe_value.top();
						exe_value.pop();
						int_type* t = get_vec(a, s1_val, exe_vectors);
						exe_type.push("NAME");
						exe_value.push("");
						exe_precision.push(0);
					}
					else
						if (s1.compare("NAME") == 0 && s2.compare("STRING") == 0) {
							s1_val = exe_value.top();
							exe_value.pop();
							s2_val = exe_value.top();
							exe_value.pop();

							int_type* t = get_vec(a, s1_val, exe_vectors);

							exe_type.push("NAME");
							exe_value.push("");
							exe_precision.push(0);
						}
						else
							if (s2.compare("NAME") == 0 && s1.compare("STRING") == 0) {
								s1_val = exe_value.top();
								exe_value.pop();
								s2_val = exe_value.top();
								exe_value.pop();

								int_type* t = get_vec(a, s2_val, exe_vectors);

								exe_type.push("NAME");
								exe_value.push("");
								exe_precision.push(0);
							}
							else
								if (s1.compare("NUMBER") == 0 && s2.compare("NUMBER") == 0) {
									n1 = exe_nums.top();
									exe_nums.pop();
									n2 = exe_nums.top();
									exe_nums.pop();

									auto p1 = exe_precision.top();
									exe_precision.pop();
									auto p2 = exe_precision.top();
									exe_precision.pop();
									auto pres = precision_func(p1, p2, ss);
									exe_precision.push(pres);
									if(p1)
										n1 = n1*(unsigned int)pow(10,p1);
									if(p2)
										n2 = n2*(unsigned int)pow(10,p2);

									if (ss.compare("ADD") == 0 )
										res = n1+n2;
									else
										if (ss.compare("MUL") == 0 )
											res = n1*n2;
										else
											if (ss.compare("DIV") == 0 )
												res = n1/n2;
											else
												res = n1-n2;

									thrust::device_ptr<int_type> p = thrust::device_malloc<int_type>(a->mRecCount);
									thrust::sequence(p, p+(a->mRecCount),res,(int_type)0);

									exe_type.push("NAME");
									exe_value.push("");
									exe_vectors.push(thrust::raw_pointer_cast(p));
								}
								else
									if (s1.compare("NAME") == 0 && s2.compare("NUMBER") == 0) {
										s1_val = exe_value.top();
										exe_value.pop();
										n1 = exe_nums.top();
										exe_nums.pop();
										auto p1 = exe_precision.top();
										exe_precision.pop();
										auto p2 = get_decimals(a, s1_val, exe_precision);

										int_type* t = get_vec(a, s1_val, exe_vectors);
										auto pres = precision_func(p1, p2, ss);
										exe_precision.push(pres);
										exe_type.push("NAME");
										exe_value.push("");
										exe_vectors.push(a->op(t,n1,ss,1, p1, p2));

									}
									else
										if (s1.compare("NUMBER") == 0 && s2.compare("NAME") == 0) {
											n1 = exe_nums.top();
											exe_nums.pop();
											s2_val = exe_value.top();
											exe_value.pop();
											auto p1 = exe_precision.top();
											exe_precision.pop();
											auto p2 = get_decimals(a, s2_val, exe_precision);

											int_type* t = get_vec(a, s2_val, exe_vectors);
											auto pres = precision_func(p2, p1, ss);
											exe_precision.push(pres);
											exe_type.push("NAME");
											exe_value.push("");
											exe_vectors.push(a->op(t,n1,ss,0, p2, p1));

										}
										else
											if (s1.compare("NAME") == 0 && s2.compare("NAME") == 0) {
												s1_val = exe_value.top();
												exe_value.pop();
												s2_val = exe_value.top();
												exe_value.pop();

												if (a->type[s1_val] == 0) {
													int_type* t1 = get_vec(a, s1_val, exe_vectors);
													int_type* t = get_vec(a, s2_val, exe_vectors);
													auto p1 = get_decimals(a, s1_val, exe_precision);
													auto p2 = get_decimals(a, s2_val, exe_precision);
													auto pres = precision_func(p1, p2, ss);
													exe_precision.push(pres);
													exe_type.push("NAME");
													exe_value.push("");
													exe_vectors.push(a->op(t,t1,ss,0,p2,p1));
												}
											}
			}

			else
				if (ss.compare("CMP") == 0) {


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
						exe_type.push("NAME");
						exe_value.push("");
						auto p1 = exe_precision.top();
						exe_precision.pop();
						auto p2 = exe_precision.top();
						exe_precision.pop();
						auto pres = precision_func(p1, p2, ss);
						exe_precision.push(pres);
						if(p1)
							n1 = n1*(unsigned int)pow(10,p1);
						if(p2)
							n2 = n2*(unsigned int)pow(10,p2);

						bool_vectors.push(a->compare(n1,n2,cmp_type));
					}
					else
						if ((s1.compare("STRING") == 0 && s2.compare("NAME") == 0) ||
						        (s1.compare("NAME") == 0 && s2.compare("STRING") == 0))
						{
							s1_val = exe_value.top();
							exe_value.pop();
							s2_val = exe_value.top();
							exe_value.pop();


							if (s1.compare("NAME") == 0 && s2.compare("STRING") == 0) {
								s1.swap(s2);
								s1_val.swap(s2_val);
							};


							void* d_res, *d_v;
							if(cmp_type != 7)
								cudaMalloc((void **) &d_res, a->mRecCount);
							else
								cudaMalloc((void **) &d_res, a->hostRecCount);
							thrust::device_ptr<bool> dd_res((bool*)d_res);

							cudaMalloc((void **) &d_v, 8);
							thrust::device_ptr<unsigned int> dd_v((unsigned int*)d_v);
							thrust::counting_iterator<unsigned int> begin(0);

							if(s2_val.find(".") != string::npos) { //bitmap index
								auto pos1 = s2_val.find_first_of(".");
								auto pos2 = s2_val.find_last_of(".");
								auto set = s2_val.substr(pos1+1, (pos2-pos1)-1);
								auto col = s2_val.substr(pos2+1);
								auto len = data_dict[set][col].col_length;

								while(s1_val.length() < len)
									s1_val = s1_val + '\0';

								auto s1_hash = MurmurHash64A(&s1_val[0], len, hash_seed)/2;
								if(a->idx_dictionary_int[s2_val].find(s1_hash) != a->idx_dictionary_int[s2_val].end()) {
									dd_v[0] = a->idx_dictionary_int[s2_val][s1_hash];
									dd_v[1] = (unsigned int)cmp_type;
									cmp_functor_dict ff(idx_vals[s2_val], (bool*)d_res, (unsigned int*)d_v);
									thrust::for_each(begin, begin + a->mRecCount, ff);
								}
								else {
									cudaMemset(d_res,0,a->mRecCount);
								}
							}
							else {

								auto s = a->string_map[s2_val];
								auto pos = s.find_first_of(".");
								auto len = data_dict[s.substr(0, pos)][s.substr(pos+1)].col_length;

								dd_v[0] = len;
								dd_v[1] = (unsigned int)s1_val.length() + 1;

								if(cmp_type != 7) {
									thrust::device_vector<unsigned long long int> vv(1);
									while(s1_val.length() < len) {
										s1_val = s1_val + '\0';
									};

									vv[0] = MurmurHash64A(&s1_val[0], s1_val.length(), hash_seed)/2;

									string f1 = a->load_file_name + "." + s2_val + "." + to_string(segment) + ".hash";
									FILE* f = fopen(f1.c_str(), "rb" );
									unsigned long long int* buff = new unsigned long long int[a->mRecCount];
									unsigned int cnt;
									fread(&cnt, 4, 1, f);
									fread(buff, a->mRecCount*8, 1, f);
									fclose(f);
									thrust::device_vector<unsigned long long int> vals(a->mRecCount);
									thrust::copy(buff, buff+a->mRecCount, vals.begin());
									if(cmp_type == 4) //==
										thrust::transform(vals.begin(), vals.end(), thrust::make_constant_iterator(vv[0]), dd_res, thrust::equal_to<unsigned long long int>());
									else
										if(cmp_type == 3) //!=
											thrust::transform(vals.begin(), vals.end(), thrust::make_constant_iterator(vv[0]), dd_res, thrust::not_equal_to<unsigned long long int>());
									delete [] buff;

								}
								else {
									if(a->map_like.find(s2_val) == a->map_like.end()) {

										void* d_str;
										cudaMalloc((void **) &d_str, len);
										cudaMemset(d_str,0,len);
										cudaMemcpy( d_str, (void *) s1_val.c_str(), s1_val.length(), cudaMemcpyHostToDevice);

										string f1 = a->load_file_name + "." + s2_val;
										FILE* f = fopen(f1.c_str(), "rb" );
										fseek(f, 0, SEEK_END);
										long fileSize = ftell(f);
										fseek(f, 0, SEEK_SET);

										unsigned int pieces = 1;
										if(fileSize > getFreeMem()/2)
											pieces = fileSize /(getFreeMem()/2) + 1;
										auto piece_sz = fileSize/pieces;
										ldiv_t ldivresult = ldiv(fileSize/pieces, len);
										if(ldivresult.rem != 0)
											piece_sz = fileSize/pieces + (len - ldivresult.rem);
										thrust::device_vector<char> dev(piece_sz);
										char* buff = new char[piece_sz];
										a->map_res[s2_val] = thrust::device_vector<unsigned int>();
										for(auto i = 0; i < pieces; i++) {

											if(i == pieces-1)
												piece_sz = fileSize - piece_sz*i;
											fread(buff, piece_sz, 1, f);
											cudaMemcpy( thrust::raw_pointer_cast(dev.data()), (void*)buff, piece_sz, cudaMemcpyHostToDevice);

											gpu_regex ff(thrust::raw_pointer_cast(dev.data()), (char*)d_str, (bool*)d_res, (unsigned int*)d_v);
											thrust::for_each(begin, begin + piece_sz/len, ff);

											auto cnt = thrust::count(dd_res, dd_res + piece_sz/len, 1);
											auto offset = a->map_res[s2_val].size();
											a->map_res[s2_val].resize(a->map_res[s2_val].size() + cnt);
											thrust::copy_if(thrust::make_counting_iterator((unsigned int)(i*(piece_sz/len))), thrust::make_counting_iterator((unsigned int)((i+1)*(piece_sz/len))),
											                dd_res, a->map_res[s2_val].begin() + offset, thrust::identity<bool>());
										};

										fclose(f);
										delete [] buff;
										cudaFree(d_str);
										thrust::sort(a->map_res[s2_val].begin(), a->map_res[s2_val].end());
										a->map_like[s2_val] = 1;


									};
									// now lets calc the current segments's matches
									cudaMemset(d_res, 0, a->hostRecCount);
									binary_search(a->map_res[s2_val].begin(),a->map_res[s2_val].end(), a->d_columns_int[s2_val].begin(), a->d_columns_int[s2_val].end(), dd_res);
								};
							};

							cudaFree(d_v);
							exe_type.push("NAME");
							bool_vectors.push((bool*)d_res);
						}

						else
							if (s1.compare("NUMBER") == 0 && s2.compare("NAME") == 0) {
								n1 = exe_nums.top();
								exe_nums.pop();
								s1_val = exe_value.top();
								exe_value.pop();

								if(s1_val.find(".") != string::npos) { //bitmap index
									void* d_v, *d_res;
									cudaMalloc((void **) &d_v, 8);
									thrust::device_ptr<unsigned int> dd_v((unsigned int*)d_v);
									cudaMalloc((void **) &d_res, a->mRecCount);
									if(a->idx_dictionary_int[s1_val].find(n1) != a->idx_dictionary_int[s1_val].end()) {
										dd_v[0] = a->idx_dictionary_int[s1_val][n1];
										dd_v[1] = (unsigned int)cmp_type;
										thrust::counting_iterator<unsigned int> begin(0);
										cmp_functor_dict ff(idx_vals[s1_val], (bool*)d_res, (unsigned int*)d_v);
										thrust::for_each(begin, begin + a->mRecCount, ff);
									}
									else {
										cudaMemset(d_res,0,a->mRecCount);
									};
									exe_type.push("NAME");
									bool_vectors.push((bool*)d_res);
									cudaFree(d_v);
								}
								else {
									int_type* t = get_vec(a, s1_val, exe_vectors);
									thrust::device_ptr<int_type> bp((int_type*)t);
									auto p2 = exe_precision.top();
									exe_precision.pop();
									auto p1 = get_decimals(a, s1_val, exe_precision);
									auto pres = std::max(p1, p2);
									exe_precision.push(pres);

									exe_type.push("NAME");
									bool_vectors.push(a->compare(t,n1,cmp_type, pres-p1, pres-p2));
								};
							}
							else
								if (s1.compare("NAME") == 0 && s2.compare("NUMBER") == 0) {
									cmp_type = reverse_op(cmp_type);
									n1 = exe_nums.top();
									exe_nums.pop();
									s2_val = exe_value.top();
									exe_value.pop();

									if(s2_val.find(".") != string::npos) { //bitmap index
										void* d_v, *d_res;
										cudaMalloc((void **) &d_v, 8);
										thrust::device_ptr<unsigned int> dd_v((unsigned int*)d_v);
										cudaMalloc((void **) &d_res, a->mRecCount);

										if(a->idx_dictionary_int[s2_val].find(n1) != a->idx_dictionary_int[s2_val].end()) {

											dd_v[0] = a->idx_dictionary_int[s2_val][n1];
											dd_v[1] = (unsigned int)cmp_type;

											thrust::counting_iterator<unsigned int> begin(0);
											cmp_functor_dict ff(idx_vals[s2_val], (bool*)d_res, (unsigned int*)d_v);
											thrust::for_each(begin, begin + a->mRecCount, ff);
										}
										else {
											cudaMemset(d_res,0,a->mRecCount);
										};
										exe_type.push("NAME");
										bool_vectors.push((bool*)d_res);
										cudaFree(d_v);
									}
									else {
										int_type* t = get_vec(a, s2_val, exe_vectors);
										auto p2 = exe_precision.top();
										exe_precision.pop();
										auto p1 = get_decimals(a, s2_val, exe_precision);
										auto pres = std::max(p1, p2);
										exe_precision.push(pres);
										exe_type.push("NAME");
										bool_vectors.push(a->compare(t,n1,cmp_type, p1, p2));
									};
								}

								else
									if (s1.compare("NAME") == 0 && s2.compare("NAME") == 0) {
										s1_val = exe_value.top();
										exe_value.pop();
										s2_val = exe_value.top();
										exe_value.pop();
										exe_type.push("NAME");

										int_type* t = get_vec(a, s1_val, exe_vectors);
										int_type* t1 = get_vec(a, s2_val, exe_vectors);
										auto p1 = get_decimals(a, s1_val, exe_precision);
										auto p2 = get_decimals(a, s2_val, exe_precision);
										auto pres = max(p1, p2);
										exe_precision.push(pres);
										bool_vectors.push(a->compare(t1,t,cmp_type, p2, p1));
									}
				}

				else
					if (ss.compare("AND") == 0) {
						bool* s3 = bool_vectors.top();
						bool_vectors.pop();
						bool* s2 = bool_vectors.top();
						bool_vectors.pop();
						exe_type.push("NAME");
						bool_vectors.push(a->logical_and(s2,s3));
					}
					else
						if (ss.compare("OR") == 0) {
							bool* s3 = bool_vectors.top();
							bool_vectors.pop();
							bool* s2 = bool_vectors.top();
							bool_vectors.pop();
							exe_type.push("NAME");
							bool_vectors.push(a->logical_or(s2,s3));
						}
						else {
							cout << "found nothing " << endl;
						}
		};
	};

	return bool_vectors.top();
}