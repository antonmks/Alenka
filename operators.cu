#include "operators.h"
#include <thrust/iterator/permutation_iterator.h>
#include <thrust/set_operations.h>
#include "moderngpu/src/moderngpu/kernel_join.hxx"


struct is_even
   {
     __host__ __device__
     bool operator()(const int &x)
     {
       return (x % 2) == 0;
     }
   };

using namespace mgpu;
using namespace std;
using namespace thrust::placeholders;


size_t int_size = sizeof(int_type);
size_t float_size = sizeof(float_type);

queue<string> namevars;
queue<string> typevars;
queue<int> sizevars;
queue<int> cols;

queue<unsigned int> j_col_count;
unsigned int sel_count = 0;
unsigned int join_cnt = 0;
unsigned int distinct_cnt = 0;
unsigned int join_col_cnt = 0;
unsigned int join_tab_cnt = 0;
unsigned int tab_cnt = 0;
queue<string> op_join;
queue<char> join_type;
queue<char> join_eq_type;
unsigned int partition_count;
map<string,unsigned int> mystat;
map<unsigned int, unsigned int> join_and_cnt;
map<string, map<string, bool> > used_vars;
bool save_dict = 0;

thrust::device_vector<unsigned char> scratch;
map<string, string> filter_var; 
thrust::device_vector<int> ranj;
unsigned long long int currtime;
standard_context_t context;	


void check_used_vars()
{
    for (auto it=data_dict.begin() ; it != data_dict.end(); ++it ) {
        auto s = (*it).second;
        auto vars(op_value);
        while(!vars.empty()) {
            if(s.count(vars.front()) != 0) {
                used_vars[(*it).first][vars.front()] = 1;
            };
            vars.pop();
        }
    };
}


void emit_name(const char *name)
{
    op_type.push("NAME");
    op_value.push(name);
}

void emit_limit(const int val)
{
    op_nums.push(val);
}


void emit_string(const char *str)
{   // remove the float_type quotes
	if(str[0] == '"') {
		string sss(str,1, strlen(str)-2);		
		op_value.push(sss);
	}
	else {	
		string sss(str);		
		op_value.push(sss);		
	};
	op_type.push("STRING");
}

void emit_string_grp(const char *str, const char *str_grp) 
{
	emit_string(str);
	grp_val = str_grp;	
};

void emit_fieldname(const char* name1, const char* name2)
{
    string s1(name1);
    string s2(name2);
    op_type.push("FIELD");
    op_value.push(s1 + "." + s2);
};

void emit_number(const int_type val)
{
    op_type.push("NUMBER");
    op_nums.push(val);
	op_nums_precision.push(0);
}

void emit_float(const float_type val)
{
    op_type.push("FLOAT");
    op_nums_f.push(val);
}

void emit_decimal(const char* str)
{
    op_type.push("NUMBER");
    string s1(str);
	unsigned int precision;
	auto pos = s1.find(".");
	if(pos == std::string::npos)
		precision = 0;
	else {
		precision = (s1.length() - pos) -1;
		s1.erase(pos,1);
	};	
	op_nums.push(stoi(s1));
    op_nums_precision.push(precision);
}

void emit_mul()
{
    op_type.push("MUL");
}

void emit_add()
{
    op_type.push("ADD");
}

void emit_div()
{
    op_type.push("DIV");
}

unsigned int misses = 0;

void emit_and()
{
    op_type.push("AND");
    join_col_cnt++;
}

void emit_eq()
{
    op_type.push("JOIN");
	join_eq_type.push('E');
    if(misses == 0) {
        join_and_cnt[tab_cnt] = join_col_cnt;
        misses = join_col_cnt;
        join_col_cnt = 0;
        tab_cnt++;
    }
    else {
        misses--;
    }
}

void emit_neq()
{
    op_type.push("JOIN");
	join_eq_type.push('N');
    if(misses == 0) {
        join_and_cnt[tab_cnt] = join_col_cnt;
        misses = join_col_cnt;
        join_col_cnt = 0;
        tab_cnt++;
    }
    else {
        misses--;
    }
}


void emit_distinct()
{
    op_type.push("DISTINCT");
    distinct_cnt++;
}

void emit_year()
{
    op_type.push("YEAR");
}

void emit_month()
{
    op_type.push("MONTH");
}


void emit_day()
{
    op_type.push("DAY");
}

void emit_cast()
{
    op_type.push("CAST");
}


void emit_or()
{
    op_type.push("OR");
}


void emit_minus()
{
    op_type.push("MINUS");
}

void emit_cmp(int val)
{
    op_type.push("CMP");
    op_nums.push(val);
}

void emit(const char *s, ...)
{
}

void emit_var(const char *s, const int c, const char *f, const char* ref, const char* ref_name)
{
    namevars.push(s);
    typevars.push(f);
    sizevars.push(0);
    cols.push(c);
}

void emit_var_asc(const char *s)
{
    op_type.push(s);
    op_value.push("ASC");
}

void emit_var_desc(const char *s)
{
    op_type.push(s);
    op_value.push("DESC");
}

void emit_sort(const char *s, const int p)
{
    op_sort.push(s);
    partition_count = p;
}

void emit_presort(const char *s)
{
    op_presort.push(s);
}


void emit_varchar(const char *s, const int c, const char *f, const int d, const char *ref, const char* ref_name)
{
    namevars.push(s);
    typevars.push(f);
    sizevars.push(d);
    cols.push(c);
}

void emit_vardecimal(const char *s, const int c, const char *f, const int scale, const int precision)
{
    namevars.push(s);
    typevars.push(f);
    sizevars.push(precision);
    cols.push(c);	
}

void emit_sel_name(const char *s)
{
    op_type.push("emit sel_name");
    op_value.push(s);
    sel_count++;
}

void emit_count()
{
    op_type.push("COUNT");
}

void emit_sum()
{
    op_type.push("SUM");
}


void emit_average()
{
    op_type.push("AVG");
}

void emit_min()
{
    op_type.push("MIN");
}

void emit_max()
{
    op_type.push("MAX");
}

void emit_join_tab(const char *s, const char tp)
{
    op_join.push(s);
    join_tab_cnt++;
    join_type.push(tp);
};


void order_inplace_host(CudaSet* a, stack<string> exe_type, set<string> field_names,  bool update_str)
{
    unsigned int* permutation = new unsigned int[a->mRecCount];
    thrust::sequence(permutation, permutation + a->mRecCount);

    char* temp = new char[a->mRecCount*max_char(a)];
    stack<string> exe_type1(exe_type), exe_value;

    while(!exe_type1.empty()) {
        exe_value.push("ASC");
        exe_type1.pop();
    };

    // sort on host

    for(;!exe_type.empty(); exe_type.pop(),exe_value.pop()) {
        if (a->type[exe_type.top()] != 1)
            update_permutation_host(a->h_columns_int[exe_type.top()].data(), permutation, a->mRecCount, exe_value.top(), (int_type*)temp);
        else 
            update_permutation_host(a->h_columns_float[exe_type.top()].data(), permutation, a->mRecCount,exe_value.top(), (float_type*)temp);
    };

	for (auto it=field_names.begin(); it!=field_names.end(); ++it) {
        if (a->type[*it] != 1) {
            thrust::gather(permutation, permutation + a->mRecCount, a->h_columns_int[*it].data(), (int_type*)temp);
            thrust::copy((int_type*)temp, (int_type*)temp + a->mRecCount, a->h_columns_int[*it].data());
        }
        else  {
            thrust::gather(permutation, permutation + a->mRecCount, a->h_columns_float[*it].data(), (float_type*)temp);
            thrust::copy((float_type*)temp, (float_type*)temp + a->mRecCount, a->h_columns_float[*it].data());
        }
    };

    delete [] temp;
    delete [] permutation;
}


void order_inplace(CudaSet* a, stack<string> exe_type, set<string> field_names, bool update_str)
{
	if(scratch.size() < a->mRecCount*4)
		scratch.resize(a->mRecCount*4);
	thrust::device_ptr<unsigned int> permutation((unsigned int*)thrust::raw_pointer_cast(scratch.data()));	
    thrust::sequence(permutation, permutation+a->mRecCount,0,1);
    unsigned int* raw_ptr = thrust::raw_pointer_cast(permutation);
	
	if(a->grp.size() < a->mRecCount*8)
		a->grp.resize(a->mRecCount*8);
 	unsigned int bits;
	
    for(; !exe_type.empty(); exe_type.pop()) {	
	
		if(cpy_bits.empty())
			bits = 0;
		else	
			bits = cpy_bits[exe_type.top()];			

        if (a->type[exe_type.top()] != 1) {
            update_permutation(a->d_columns_int[exe_type.top()], raw_ptr, a->mRecCount, "ASC", (int_type*)thrust::raw_pointer_cast(a->grp.data()), bits);
		}	
        else
            update_permutation(a->d_columns_float[exe_type.top()], raw_ptr, a->mRecCount,"ASC", (float_type*)thrust::raw_pointer_cast(a->grp.data()), bits);			
    };	
	
    for (auto it=field_names.begin(); it!=field_names.end(); ++it) {
		if(cpy_bits.empty())
			bits = 0;
		else	
			bits = cpy_bits[*it];
			
        if (a->type[*it] != 1) {
            apply_permutation(a->d_columns_int[*it], raw_ptr, a->mRecCount, (int_type*)thrust::raw_pointer_cast(a->grp.data()), bits);		
        }
        else {
            apply_permutation(a->d_columns_float[*it], raw_ptr, a->mRecCount, (float_type*)thrust::raw_pointer_cast(a->grp.data()), bits);			
		};				
    };
}

bool check_star_join(const string j1)
{
    auto op_vals(op_value);

    for(auto i=0; i < sel_count; i++) {
        op_vals.pop();
        op_vals.pop();
    };

    if(join_tab_cnt > 0) {

        while(op_vals.size()) {
            if (std::find(varNames[j1]->columnNames.begin(), varNames[j1]->columnNames.end(), op_vals.front()) != varNames[j1]->columnNames.end()) {
                op_vals.pop();
                op_vals.pop();
            }
            else {
                return 0;
            };
        };
        if(join_tab_cnt == 1) {
            if(!check_bitmap_file_exist(varNames[j1], varNames[op_join.front()])) {
                return 0;
            };
        };
        return 1;
    }
    else
        return 0;
}


void star_join(const char *s, const string j1)
{	
    map<string,bool> already_copied;
    queue<string> op_left;
    CudaSet* left = varNames.find(j1)->second;

    queue<string> op_sel;
    queue<string> op_sel_as;
    for(auto i=0; i < sel_count; i++) {
        if(std::find(left->columnNames.begin(), left->columnNames.end(), op_value.front()) != left->columnNames.end())
            op_left.push(op_value.front());
        op_sel.push(op_value.front());
        op_value.pop();
        op_sel_as.push(op_value.front());
        op_value.pop();
    };
    auto op_sel_s(op_sel), op_sel_s_as(op_sel_as), op_g(op_value);
    CudaSet* c = new CudaSet(op_sel_s, op_sel_s_as);

    string f1, f2;
    map<string, string> key_map;
    map<string, char> sort_map;
    map<string, string> r_map;
	
    for(auto i = 0; i < join_tab_cnt; i++) {

        f1 = op_g.front();
        op_g.pop();
        f2 = op_g.front();
        op_g.pop();
        r_map[f1] = f2;
		

        queue<string> op_jj(op_join);
        for(auto z = 0; z < (join_tab_cnt-1) - i; z++)
            op_jj.pop();
		

        size_t rcount;
        queue<string> op_vd(op_g), op_alt(op_sel);
        unsigned int jc = join_col_cnt;
		
        while(jc) {
            jc--;
            op_vd.pop();
            op_alt.push(op_vd.front());
            op_vd.pop();
        };
		
        key_map[op_jj.front()] = f1;

        CudaSet* right = varNames.find(op_jj.front())->second;
        if(!check_bitmaps_exist(left, right)) {
            cout << "Required bitmap on table " << op_jj.front() << " doesn't exists" << endl;
            exit(0);
        };
		
        queue<string> second;
        while(!op_alt.empty()) {
            if(f2.compare(op_alt.front()) != 0 && std::find(right->columnNames.begin(), right->columnNames.end(), op_alt.front()) != right->columnNames.end()) {
                second.push(op_alt.front());
                //cout << "col " << op_alt.front() << " " << op_jj.front() <<  endl;
                op_left.push(f1);
            };
            op_alt.pop();
        };
        if(!second.empty()) {
            right->filtered = 0;
            right->mRecCount = right->maxRecs;
            load_queue(second, right, "", rcount, 0, right->segCount, 0,0); // put all used columns into GPU
        };
    };
	
    queue<string> idx;
    set<string> already_loaded;
    bool right_cpy = 0;
    for (unsigned int i = 0; i < left->segCount; i++) {
        std::clock_t start2 = std::clock();
        if(verbose)
            cout << "segment " << i << " " << getFreeMem() <<  endl;

        idx = left->fil_value;
        already_loaded.clear();
        while(!idx.empty()) {
            //load the index
            if(idx.front().find(".") != string::npos && (already_loaded.find(idx.front()) == already_loaded.end())) {
                //extract table name and colname from index name
                already_loaded.insert(idx.front());
                size_t pos1 = idx.front().find_first_of(".", 0);
                size_t pos2 = idx.front().find_first_of(".", pos1+1);
                CudaSet* r = varNames.find(idx.front().substr(pos1+1, pos2-pos1-1))->second;
                char a;
				//cout << "loading index " << idx.front() << endl;
                a = left->loadIndex(idx.front(), i);
                sort_map[idx.front().substr(pos1+1, pos2-pos1-1)] = a;
            };
            idx.pop();
        };

        left->filtered = 0;
        size_t cnt_c = 0;
        allocColumns(left, left->fil_value);
        copyColumns(left, left->fil_value, i, cnt_c);
        bool* res = filter(left->fil_type, left->fil_value, left->fil_nums, left->fil_nums_f, left->fil_nums_precision, left, i);
        thrust::device_ptr<bool> star((bool*)res);
        size_t cnt = thrust::count(star, star + (unsigned int)left->mRecCount, 1);
        //cout << "join res " << cnt << " out of " << left->mRecCount << endl;
        thrust::host_vector<unsigned int> prm_vh(cnt);
        thrust::device_vector<unsigned int> prm_v(cnt);
        thrust::host_vector<unsigned int> prm_tmp(cnt);
        thrust::device_vector<unsigned int> prm_tmp_d(cnt);
        //std::cout<< "seg filter " <<  ( ( std::clock() - start1 ) / (double)CLOCKS_PER_SEC ) << " " << getFreeMem() << endl;

        if(cnt) { //gather

            //start1 = std::clock();
            left->prm_d.resize(cnt);
            thrust::copy_if(thrust::make_counting_iterator((unsigned int)0), thrust::make_counting_iterator((unsigned int)left->mRecCount-1),
                            star, left->prm_d.begin(), thrust::identity<bool>());
            thrust::device_free(star);
            prm_vh = left->prm_d;

            size_t offset = c->mRecCount;
            c->resize_join(cnt);
            queue<string> op_sel1(op_sel_s);
            void* temp;
            CUDA_SAFE_CALL(cudaMalloc((void **) &temp, cnt*max_char(c)));
			cudaMemset(temp,0,cnt*max_char(c));
            CudaSet *t;
            unsigned int cnt1, bits;
            int_type lower_val;
            thrust::device_vector<unsigned int> output(cnt);
            //std::cout<< "seg start " <<  ( ( std::clock() - start1 ) / (double)CLOCKS_PER_SEC ) << " " << getFreeMem() << endl;

            while(!op_sel1.empty()) {

                if(std::find(left->columnNames.begin(), left->columnNames.end(), op_sel1.front()) !=  left->columnNames.end()) {

                    if(left->filtered)
                        t = varNames[left->source_name];
                    else
                        t = left;

                    if(left->type[op_sel1.front()] <= 1) {

                        if(ssd && !interactive) {
                            //start1 = std::clock();
                            lower_val = t->readSsdSegmentsFromFile(i, op_sel1.front(), offset, prm_vh, c);
                            //std::cout<<  "SSD L SEEK READ " <<  ( ( std::clock() - start1 ) / (double)CLOCKS_PER_SEC ) << endl;
                        }
                        else {
                            t->readSegmentsFromFile(i, op_sel1.front());
                            void* h;
							
                            if(!interactive) {
                                if(left->type[op_sel1.front()] == 0)
                                    h = t->h_columns_int[op_sel1.front()].data();
                                else
                                    h = t->h_columns_float[op_sel1.front()].data();
                            }
                            else {
                                string ff = t->load_file_name + "." + op_sel1.front()+ "." + to_string(i);
                                h = buffers[ff];
                            };
                            cnt1 = ((unsigned int*)h)[0];//bytes
                            lower_val = ((int_type*)(((unsigned int*)h)+1))[0];
                            bits = ((unsigned int*)((char*)h + cnt1))[8];
                            //cout << cnt1 << " " << lower_val << " " << bits << " " << left->type[op_sel1.front()] << endl;

                            if(bits == 8) {
                                if(left->type[op_sel1.front()] == 0) {
                                    thrust::gather(prm_vh.begin(), prm_vh.end(), (char*)((unsigned int*)h + 6), c->h_columns_int[op_sel1.front()].begin() + offset);
                                }
                                else {
                                    int_type* ptr = (int_type*)c->h_columns_float[op_sel1.front()].data();
                                    thrust::gather(prm_vh.begin(), prm_vh.end(), (char*)((unsigned int*)h + 6), ptr + offset);
                                };
                            }
                            else if(bits == 16) {
                                if(left->type[op_sel1.front()] == 0) {
                                    thrust::gather(prm_vh.begin(), prm_vh.end(), (unsigned short int*)((unsigned int*)h + 6), c->h_columns_int[op_sel1.front()].begin() + offset);
                                }
                                else {
                                    int_type* ptr = (int_type*)c->h_columns_float[op_sel1.front()].data();
                                    thrust::gather(prm_vh.begin(), prm_vh.end(), (unsigned short int*)((unsigned int*)h + 6), ptr + offset);
                                };
                            }
                            else if(bits == 32) {
                                if(left->type[op_sel1.front()] == 0) {									
                                    thrust::gather(prm_vh.begin(), prm_vh.end(), (unsigned int*)((unsigned int*)h + 6), c->h_columns_int[op_sel1.front()].begin() + offset);
                                }
                                else {
                                    int_type* ptr = (int_type*)c->h_columns_float[op_sel1.front()].data();
                                    thrust::gather(prm_vh.begin(), prm_vh.end(), (unsigned int*)((unsigned int*)h + 6), ptr + offset);
                                }
                            }
                            else if(bits == 64) {
                                if(left->type[op_sel1.front()] == 0) {
                                    thrust::gather(prm_vh.begin(), prm_vh.end(),  (int_type*)((unsigned int*)h + 6), c->h_columns_int[op_sel1.front()].begin() + offset);
                                }
                                else {
                                    int_type* ptr = (int_type*)c->h_columns_float[op_sel1.front()].data();
                                    thrust::gather(prm_vh.begin(), prm_vh.end(),  (int_type*)((unsigned int*)h + 6), ptr + offset);
                                };
                            };
                        };

                        if(left->type[op_sel1.front()] != 1)
                            thrust::transform( c->h_columns_int[op_sel1.front()].begin() + offset,  c->h_columns_int[op_sel1.front()].begin() + offset + cnt,
                                               thrust::make_constant_iterator(lower_val), c->h_columns_int[op_sel1.front()].begin() + offset, thrust::plus<int_type>());
                        else {
                            int_type* ptr = (int_type*)c->h_columns_float[op_sel1.front()].data();
                            thrust::transform(ptr + offset, ptr + offset + cnt,
                                              thrust::make_constant_iterator(lower_val), ptr + offset, thrust::plus<int_type>());
                            thrust::transform(ptr + offset, ptr + offset + cnt, c->h_columns_float[op_sel1.front()].begin() + offset, long_to_float());
                        };

                    }
                    else { //gather string. There are no strings in fact tables.

                    };
                }
                else {
                    for(auto it = key_map.begin(); it != key_map.end(); it++) {
                        CudaSet* r = varNames.find(it->first)->second;

                        if(std::find(r->columnNames.begin(), r->columnNames.end(), op_sel1.front()) !=  r->columnNames.end()) {

                            if(i == 0) {
                                if(data_dict[varNames[it->first]->load_file_name][op_sel1.front()].col_type == 2) {
                                    //cout << "SET " << op_sel1.front() << " to " << varNames[it->first]->load_file_name + "." + op_sel1.front() << endl;
                                    c->string_map[op_sel1.front()] = varNames[it->first]->load_file_name + "." + op_sel1.front();
                                };
                            }

                            if(left->filtered)
                                t = varNames[left->source_name];
                            else
                                t = left;

                            if(ssd && !interactive) {
                                //start1 = std::clock();
                                lower_val = t->readSsdSegmentsFromFileR(i, key_map[it->first], prm_vh, prm_tmp);
                                //std::cout<<  "SSD R SEEK READ " <<  ( ( std::clock() - start1 ) / (double)CLOCKS_PER_SEC ) << endl;
                            }
                            else {
                                t->readSegmentsFromFile(i, key_map[it->first]);
                                void* h;
                                if(!interactive) {
                                    h = t->h_columns_int[key_map[it->first]].data();
                                }
                                else {
                                    string ff = t->load_file_name + "." + key_map[it->first] + "." + to_string(i);
                                    h = buffers[ff];
                                };
                                cnt1 = ((unsigned int*)h)[0];
                                lower_val = ((int_type*)(((unsigned int*)h)+1))[0];
                                bits = ((unsigned int*)((char*)h + cnt1))[8];
                                //cout << cnt1 << " " << lower_val << " " << bits << endl;

                                if(bits == 8) {
                                    thrust::gather(prm_vh.begin(), prm_vh.end(), (char*)((unsigned int*)h + 6), prm_tmp.begin());
                                }
                                else if(bits == 16) {
                                    thrust::gather(prm_vh.begin(), prm_vh.end(), (unsigned short int*)((unsigned int*)h + 6), prm_tmp.begin());
                                }
                                else if(bits == 32) {
                                    thrust::gather(prm_vh.begin(), prm_vh.end(), (unsigned int*)((unsigned int*)h + 6), prm_tmp.begin());
                                }
                                else if(bits == 64) {
                                    thrust::gather(prm_vh.begin(), prm_vh.end(),  (int_type*)((unsigned int*)h + 6), prm_tmp.begin());
                                };
                            };


                            if(lower_val != 1)
                                thrust::transform(prm_tmp.begin(), prm_tmp.end(), thrust::make_constant_iterator(lower_val-1), prm_tmp.begin(), thrust::plus<unsigned int>());
                            if(sort_map[r->source_name] == '1') { // sorted consecutive starting with 1 dimension keys
                                prm_tmp_d = prm_tmp;
                                //cout << "PATH 1 " << endl;
                            }
                            else {
                                //cout << "PATH 2 " << r->source_name << endl;
                                output = prm_tmp;

                                if(r->d_columns_int[r_map[key_map[it->first]]].size() == 0) {
                                    r->d_columns_int[r_map[key_map[it->first]]].resize(r->maxRecs);
                                };
                                if(right_cpy == 0) {
                                    r->CopyColumnToGpu(r_map[key_map[it->first]]);
                                };

                                thrust::lower_bound(r->d_columns_int[r_map[key_map[it->first]]].begin(), r->d_columns_int[r_map[key_map[it->first]]].end(),
                                                    output.begin(), output.end(),
                                                    prm_tmp_d.begin());

                            };

                            if(r->type[op_sel1.front()] != 1) {
                                thrust::device_ptr<int_type> d_tmp((int_type*)temp);
                                thrust::gather(prm_tmp_d.begin(), prm_tmp_d.end(), r->d_columns_int[op_sel1.front()].begin(), d_tmp);
                                thrust::copy(d_tmp, d_tmp + cnt, c->h_columns_int[op_sel1.front()].begin() + offset);
                            }
                            else {
                                thrust::device_ptr<float_type> d_tmp((float_type*)temp);
                                thrust::gather(prm_tmp_d.begin(), prm_tmp_d.end(), r->d_columns_float[op_sel1.front()].begin(), d_tmp);
                                thrust::copy(d_tmp, d_tmp + cnt, c->h_columns_float[op_sel1.front()].begin() + offset);
                            };
                            break;
                        };
                    };
                };
                op_sel1.pop();
                //std::cout<<  ( ( std::clock() - start1 ) / (double)CLOCKS_PER_SEC ) << endl;
            };
            cudaFree(temp);
            right_cpy = 1;
        };
        //std::cout<< "SEG " << i << " "  <<  ( ( std::clock() - start2 ) / (double)CLOCKS_PER_SEC ) << " " << getFreeMem() << endl;
        //unload the segment indexes :
        idx = left->fil_value;
        already_loaded.clear();
        while(!idx.empty()) {
            if(idx.front().find(".") != string::npos && (already_loaded.find(idx.front()) == already_loaded.end())) {
                //extract table name and colname from index name
                already_loaded.insert(idx.front());
                size_t pos1 = idx.front().find_first_of(".", 0);
                size_t pos2 = idx.front().find_first_of(".", pos1+1);
                CudaSet* r = varNames.find(idx.front().substr(pos1+1, pos2-pos1-1))->second;
                string f1 = idx.front() + "." + to_string(i);
                auto it = index_buffers.find(f1);
                if(it != index_buffers.end()) {
                    cudaFreeHost(index_buffers[f1]);
                    index_buffers.erase(it);
                };
            };
            idx.pop();
        };
    };

    //if(verbose)
    //    std::cout<< "star join time " <<  ( ( std::clock() - start1 ) / (double)CLOCKS_PER_SEC ) << " " << getFreeMem() << endl;


    while(!op_join.empty()) {
        varNames[op_join.front()]->deAllocOnDevice();
        op_join.pop();
    };

    varNames[s] = c;
    c->maxRecs = c->mRecCount;

    if(verbose)
        cout << endl << "join count " << c->mRecCount << endl;
};


void emit_join(const char *s, const char *j1, const int grp, const int start_seg, const int end_seg)
{
    //cout << "emit_join " <<  s << " " << join_tab_cnt << " " << op_join.front() <<  endl;
    statement_count++;
    if (scan_state == 0) {
        if (mystat.find(j1) == mystat.end() && data_dict.count(j1) == 0) {
            process_error(2, "Join : couldn't find variable " + string(j1) );
        };
        if (mystat.find(op_join.front()) == mystat.end() && data_dict.count(op_join.front()) == 0) {
            process_error(2, "Join : couldn't find variable " + op_join.front() );
        };
        mystat[s] = statement_count;
        mystat[j1] = statement_count;
		if(filter_var.find(j1) != filter_var.end()) {
			mystat[filter_var[j1]] = statement_count;
		};
        check_used_vars();
        while(!op_join.empty()) {
            mystat[op_join.front()] = statement_count;
			if(filter_var.find(op_join.front()) != filter_var.end()) {
				mystat[filter_var[op_join.front()]] = statement_count;
			};			
            op_join.pop();			
        };
        return;
    };

    queue<string> op_m(op_value);

    if(check_star_join(j1)) {
        if(verbose)
            cout << "executing star join !! " << endl;
        star_join(s, j1);
    }
    else {
        if(join_tab_cnt > 1) {
            string tab_name;
            for(unsigned int i = 1; i <= join_tab_cnt; i++) {

                if(i == join_tab_cnt)
                    tab_name = s;
                else
                    tab_name = s + to_string(i);

                string j, j2;
                if(i == 1) {
                    j2 = op_join.front();
                    op_join.pop();
                    j = op_join.front();
                    op_join.pop();
                }
                else {
                    if(!op_join.empty()) {
                        j = op_join.front();
                        op_join.pop();
                    }
                    else
                        j = j1;
                    j2 = s + to_string(i-1);
                };
                emit_multijoin(tab_name, j, j2, i, s, start_seg, end_seg);
                op_value = op_m;
            };
        }
        else {
            emit_multijoin(s, j1, op_join.front(), 1, s, start_seg, end_seg);
            op_join.pop();
        };
    };


    queue<string> op_sel;
    queue<string> op_sel_as;
    for(int i=0; i < sel_count; i++) {
        op_sel.push(op_m.front());
        op_m.pop();
        op_sel_as.push(op_m.front());
        op_m.pop();
    };
    while(!op_sel_as.empty()) {
        //cout << "alias " << op_sel.front() << " : " << op_sel_as.front() << endl;
        if(op_sel.front() != op_sel_as.front()) {
            if(varNames[s]->type[op_sel.front()] == 0) {
                varNames[s]->h_columns_int[op_sel_as.front()] = varNames[s]->h_columns_int[op_sel.front()];
                varNames[s]->h_columns_int.erase(op_sel.front());
                varNames[s]->d_columns_int[op_sel_as.front()] = varNames[s]->d_columns_int[op_sel.front()];
                varNames[s]->d_columns_int.erase(op_sel.front());
                varNames[s]->type[op_sel_as.front()] = 0;
                varNames[s]->type.erase(op_sel.front());
            }
            else if(varNames[s]->type[op_sel.front()] == 1) {
                varNames[s]->h_columns_float[op_sel_as.front()] = varNames[s]->h_columns_float[op_sel.front()];
                varNames[s]->h_columns_float.erase(op_sel.front());
                varNames[s]->d_columns_float[op_sel_as.front()] = varNames[s]->d_columns_float[op_sel.front()];
                varNames[s]->d_columns_float.erase(op_sel.front());
                varNames[s]->type[op_sel_as.front()] = 1;
                varNames[s]->type.erase(op_sel.front());
                varNames[s]->decimal.erase(op_sel.front());
            }
            else {
                varNames[s]->h_columns_char[op_sel_as.front()] = varNames[s]->h_columns_char[op_sel.front()];
                varNames[s]->h_columns_char.erase(op_sel.front());
                varNames[s]->d_columns_char[op_sel_as.front()] = varNames[s]->d_columns_char[op_sel.front()];
                varNames[s]->d_columns_char.erase(op_sel.front());
                varNames[s]->type[op_sel_as.front()] = 2;
                varNames[s]->type.erase(op_sel.front());
                varNames[s]->char_size[op_sel_as.front()] = varNames[s]->char_size[op_sel.front()];
                varNames[s]->char_size.erase(op_sel.front());
            };
            varNames[s]->decimal[op_sel_as.front()] = varNames[s]->decimal[op_sel.front()];
            auto it = std::find(varNames[s]->columnNames.begin(), varNames[s]->columnNames.end(), op_sel.front());
            *it = op_sel_as.front();
        };
        op_sel_as.pop();
        op_sel.pop();
    };


    clean_queues();

    if(mystat[s] == statement_count) {
        varNames[s]->free();
        varNames.erase(s);
    };

    if(op_join.size()) {
        if(mystat[op_join.front()] == statement_count && op_join.front().compare(j1) != 0) {
            varNames[op_join.front()]->free();
            varNames.erase(op_join.front());
        };
    };
}

template<typename T, typename P>
void p_gather(thrust::host_vector<int>& h_tmp, T* h, P* dest)
{
	for(int i = 0; i < h_tmp.size(); i++) {
		dest[i] = h[h_tmp[i]];
	};	
};	



void emit_multijoin(const string s, const string j1, const string j2, const unsigned int tab, const char* res_name, const int start_segment, const int end_segment)
{

    if(varNames.find(j1) == varNames.end() || varNames.find(j2) == varNames.end()) {
        clean_queues();
        if(varNames.find(j1) == varNames.end())
            cout << "Couldn't find j1 " << j1 << endl;
        if(varNames.find(j2) == varNames.end())
            cout << "Couldn't find j2 " << j2 << " here " << endl;

        return;
    };

    CudaSet* left = varNames.find(j1)->second;
    CudaSet* right = varNames.find(j2)->second;

    queue<string> op_sel;
    queue<string> op_sel_as;
    for(int i=0; i < sel_count; i++) {
        op_sel.push(op_value.front());
        op_value.pop();
        op_sel_as.push(op_value.front());
        op_value.pop();
    };

    queue<string> op_sel_s(op_sel);
    queue<string> op_sel_s_as(op_sel_as);
    queue<string> op_g(op_value);

    if(tab > 0) {
        for(unsigned int z = 0; z < join_tab_cnt - tab; z++) {
            for(unsigned int j = 0; j < join_and_cnt[z]*2 + 2; j++) {
                op_sel_s.push(op_g.front());
                op_sel_s_as.push(op_g.front());
                op_g.pop();
            };
        };
    };

    string f1 = op_g.front();
    op_g.pop();
    string f2 = op_g.front();
    op_g.pop();

    if (verbose)
        cout << "JOIN " << s <<  " " <<  f1 << " " << f2 << " " << getFreeMem() <<  " " << phase_copy << endl;

    std::clock_t start1 = std::clock();
    CudaSet* c = new CudaSet(right, left, op_sel_s, op_sel_s_as);

    if ((left->mRecCount == 0 && !left->filtered) || (right->mRecCount == 0 && !right->filtered)) {
        c = new CudaSet(left, right, op_sel_s, op_sel_s_as);
        varNames[res_name] = c;
        clean_queues();
        return;
    };

    if(join_tab_cnt > 1 && tab < join_tab_cnt)
        c->tmp_table = 1;
    else
        c->tmp_table = 0;

    string colname1, colname2;
    string tmpstr;
    if (std::find(left->columnNames.begin(), left->columnNames.end(), f1) != left->columnNames.end()) {
        colname1 = f1;
        if (std::find(right->columnNames.begin(), right->columnNames.end(), f2) != right->columnNames.end()) {
            colname2 = f2;
        }
        else {
            process_error(2, "Couldn't find column " + f2 );
        };
    }
    else if (std::find(right->columnNames.begin(), right->columnNames.end(), f1) != right->columnNames.end()) {
        colname2 = f1;
        tmpstr = f1;
        f1 = f2;
        if (std::find(left->columnNames.begin(), left->columnNames.end(), f2) != left->columnNames.end()) {
            colname1 = f2;
            f2 = tmpstr;
        }
        else {
            process_error(2, "Couldn't find column " +f2 );
        };
    }
    else {
        process_error(2, "Couldn't find column " + f1);
    };


    if (!((left->type[colname1] == 0 && right->type[colname2]  == 0) || (left->type[colname1] == 2 && right->type[colname2]  == 2)
            || (left->type[colname1] == 1 && right->type[colname2]  == 1 && left->decimal[colname1] && right->decimal[colname2]))) {
        process_error(2, "Joins on floats are not supported ");
    };


    //bool decimal_join = 0;
    //if (left->type[colname1] == 1 && right->type[colname2]  == 1)
    //    decimal_join = 1;

    queue<string> op_vd(op_g);
    queue<string> op_g1(op_g);
    queue<string> op_alt(op_sel);
	
    unsigned int jc = join_and_cnt[join_tab_cnt - tab];
    while(jc) {
        jc--;
        op_vd.pop();
        op_alt.push(op_vd.front());
        op_vd.pop();
    };

    size_t rcount = 0, cnt_r;
    queue<string> cc;

    if (left->type[colname1]  == 2) {
        left->d_columns_int[colname1] = thrust::device_vector<int_type>();
    }
    else {
        cc.push(f1);
        allocColumns(left, cc);
    };

    left->hostRecCount = left->mRecCount;

    size_t cnt_l, res_count, tot_count = 0, offset = 0, k = 0;
    queue<string> lc(cc);
    thrust::device_vector<unsigned int> v_l(left->maxRecs);
    //MGPU_MEM(int) aIndicesDevice, bIndicesDevice, intersectionDevice;	
    stack<string> exe_type;
    set<string> field_names;
    exe_type.push(f2);
    for(unsigned int i = 0; i < right->columnNames.size(); i++) {
        if (std::find(c->columnNames.begin(), c->columnNames.end(), right->columnNames[i]) != c->columnNames.end() || right->columnNames[i] == f2 || join_and_cnt[join_tab_cnt - tab]) {
            field_names.insert(right->columnNames[i]);
        };
    };

    thrust::device_vector<int> p_tmp;    
    unsigned int start_part = 0;
	bool prejoin = 0;

    while(start_part < right->segCount) {

        right->deAllocOnDevice();
		std::clock_t start12 = std::clock();
        if(right->not_compressed || (!right->filtered && getFreeMem() < right->columnNames.size()*right->hostRecCount*8*2)) {
            cnt_r = load_right(right, f2, op_g1, op_alt, rcount, start_part, start_part+1);
            start_part = start_part+1;			
        }
        else {
            cnt_r = load_right(right, f2, op_g1, op_alt, rcount, start_part, right->segCount);			
            start_part = right->segCount;
			
			for(unsigned int i=0; i < right->columnNames.size(); i++) {
				if (right->type[right->columnNames[i]] != 1) {
					right->d_columns_int[right->columnNames[i]].shrink_to_fit();
				}
				else 
					right->d_columns_float[right->columnNames[i]].shrink_to_fit();
			};    			
        };

        right->mRecCount = cnt_r;
        bool order = 1;
		
		
        if(!right->presorted_fields.empty() && right->presorted_fields.front() == f2) {
            order = 0;
            //cout << "No need to sort " << endl;
            if (right->d_columns_int[f2][0] == 1 && right->d_columns_int[f2][right->d_columns_int[f2].size()-1] == right->d_columns_int[f2].size())
                right->sort_check = '1';
            else {
                right->sort_check = '0';
            };
        };
		
        if(order) {
            if(thrust::is_sorted(right->d_columns_int[f2].begin(), right->d_columns_int[f2].end())) {
                if (right->d_columns_int[f2][0] == 1 && right->d_columns_int[f2][right->d_columns_int[f2].size()-1] == right->d_columns_int[f2].size()) {
                    right->sort_check = '1';
                }
                else {
                    right->sort_check = '0';
                };
            }
            else {
				//cout << "sorting " << endl;
				size_t tot_size = right->mRecCount*8*right->columnNames.size();
				if (getFreeMem() > tot_size*1.5) {
					order_inplace(right, exe_type, field_names, 0);					
				}
				else {
					for (auto it=field_names.begin(); it!=field_names.end(); ++it) {
						//cout << "sorting " << *it << endl;
						if(right->type[*it] != 1) {
							if(right->h_columns_int[*it].size() < right->mRecCount)
								right->h_columns_int[*it].resize(right->mRecCount);
							thrust::copy(right->d_columns_int[*it].begin(), right->d_columns_int[*it].begin() +	right->mRecCount, right->h_columns_int[*it].begin());			
						}	
						else {
							if(right->type[*it] == 1) {						
								if(right->h_columns_float[*it].size() < right->mRecCount)
									right->h_columns_float[*it].resize(right->mRecCount);
							};		
							thrust::copy(right->d_columns_float[*it].begin(), right->d_columns_float[*it].begin() +	right->mRecCount, right->h_columns_float[*it].begin());			
						};		
					};	
					order_inplace_host(right, exe_type, field_names, 0);
				    for (auto it=field_names.begin(); it!=field_names.end(); ++it) {
						if(right->type[*it] != 1) 
							thrust::copy(right->h_columns_int[*it].begin(), right->h_columns_int[*it].begin() + right->mRecCount, right->d_columns_int[*it].begin());
						else	
							thrust::copy(right->h_columns_float[*it].begin(), right->h_columns_float[*it].begin() + right->mRecCount, right->d_columns_float[*it].begin());
					};
				};		
            };
        };

	//std::cout<< "join right load time " <<  ( ( std::clock() - start12 ) / (double)CLOCKS_PER_SEC ) <<  " " << getFreeMem() << '\n';				

        int e_segment;
        if(end_segment == -1) {
            e_segment  = left->segCount;
        }
        else
            e_segment = end_segment;

        for (unsigned int i = start_segment; i < e_segment; i++) {
		
            if(verbose)
                //cout << "segment " << i <<  '\xd';
                cout << "segment " << i <<  endl;
            cnt_l = 0;
			
            copyColumns(left, lc, i, cnt_l);	
            cnt_l = left->mRecCount;
			auto join_eq_type1(join_eq_type);

            if (cnt_l) {							
				
		
                // sort the left index column, save the permutation vector, it might be needed later				
                thrust::device_ptr<int_type> d_col((int_type*)thrust::raw_pointer_cast(left->d_columns_int[colname1].data()));
                thrust::sequence(v_l.begin(), v_l.begin() + cnt_l,0,1);

                bool do_sort = 1;
                if(!left->sorted_fields.empty()) {
                    if(left->sorted_fields.front() == f1) {
                        do_sort = 0;
                    };
                }
                else if(!left->presorted_fields.empty()) {
                    if(left->presorted_fields.front() == f1) {
                        do_sort = 0;
                    };
                };

                if(do_sort) {
                    thrust::sort_by_key(d_col, d_col + cnt_l, v_l.begin());
				}	
                else if(verbose)
                    cout << "No need of sorting " << endl;
				
				if(prejoin) {
					//res_count = SetOpKeys<MgpuSetOpIntersection, true>(thrust::raw_pointer_cast(left->d_columns_int[colname1].data()), cnt_l,
					//										thrust::raw_pointer_cast(right->d_columns_int[colname2].data()), cnt_r,
					//										&intersectionDevice, *context, false);	
					//if(!res_count)
					//	continue;     
				};		
				
					
				

                if (left->d_columns_int[colname1][0] > right->d_columns_int[colname2][cnt_r-1] ||
                        left->d_columns_int[colname1][cnt_l-1] < right->d_columns_int[colname2][0]) {
                    if(verbose)
                        cout << endl << "skipping after copying " << endl;
                    continue;
                };
                //else
                //    cout << "JOINING " << left->d_columns_int[colname1][0] << ":" << left->d_columns_int[colname1][cnt_l-1] << " AND " << right->d_columns_int[colname2][0] << ":" << right->d_columns_int[colname2][cnt_r-1] << endl;

                //cout << "joining " << left->d_columns_int[colname1][0] << " : " << left->d_columns_int[colname1][cnt_l-1] << " and " << right->d_columns_int[colname2][0] << " : " << right->d_columns_int[colname2][cnt_r-1] << endl;

                char join_kind = join_type.front();
				std::clock_t start11 = std::clock();
				mem_t<int2> res;
				
                if (join_kind == 'I' || join_kind == '1' || join_kind == '2' || join_kind == '3' || join_kind == '4') {
                    //res_count = RelationalJoin<MgpuJoinKindInner>(thrust::raw_pointer_cast(left->d_columns_int[colname1].data()), cnt_l,
                    //            thrust::raw_pointer_cast(right->d_columns_int[colname2].data()), cnt_r,
                    //            &aIndicesDevice, &bIndicesDevice,
                    //            mgpu::less<int_type>(), *context);




					res = inner_join(thrust::raw_pointer_cast(left->d_columns_int[colname1].data()), cnt_l, 
									thrust::raw_pointer_cast(right->d_columns_int[colname2].data()), cnt_r, less_t<int_type>(), context);				
									
				};					
				   
				res_count = res.size();
				
               /* else if(join_kind == 'L')
                    res_count = RelationalJoin<MgpuJoinKindLeft>(thrust::raw_pointer_cast(left->d_columns_int[colname1].data()), cnt_l,
                                thrust::raw_pointer_cast(right->d_columns_int[colname2].data()), cnt_r,
                                &aIndicesDevice, &bIndicesDevice,
                                mgpu::less<int_type>(), *context);
                else if(join_kind == 'R')
                    res_count = RelationalJoin<MgpuJoinKindRight>(thrust::raw_pointer_cast(left->d_columns_int[colname1].data()), cnt_l,
                                thrust::raw_pointer_cast(right->d_columns_int[colname2].data()), cnt_r,
                                &aIndicesDevice, &bIndicesDevice,
                                mgpu::less<int_type>(), *context);
                else if(join_kind == 'O')
                    res_count = RelationalJoin<MgpuJoinKindOuter>(thrust::raw_pointer_cast(left->d_columns_int[colname1].data()), cnt_l,
                                thrust::raw_pointer_cast(right->d_columns_int[colname2].data()), cnt_r,
                                &aIndicesDevice, &bIndicesDevice,
                                mgpu::less<int_type>(), *context);
				*/
				if(verbose)	
					std::cout<< "join time " <<  ( ( std::clock() - start11 ) / (double)CLOCKS_PER_SEC ) <<  '\n';				

                if(verbose)
                    cout << "RES " << res_count << endl;
				if(res_count == 0)
					prejoin = 1; 				
				
				
                thrust::device_ptr<int> d_res1 = thrust::device_malloc<int>(res_count);
                thrust::device_ptr<int> d_res2 = thrust::device_malloc<int>(res_count);
				
				thrust::counting_iterator<unsigned int> begin(0);
				split_int2 ff(thrust::raw_pointer_cast(d_res1), thrust::raw_pointer_cast(d_res2), res.data());
				thrust::for_each(begin, begin + res_count, ff);
				

				
                if(res_count) {
                    p_tmp.resize(res_count);
                    thrust::sequence(p_tmp.begin(), p_tmp.end(),-1);
                    thrust::gather_if(d_res1, d_res1+res_count, d_res1, v_l.begin(), p_tmp.begin(), _1 >= 0);					
                };				
				

                // check if the join is a multicolumn join
                unsigned int mul_cnt = join_and_cnt[join_tab_cnt - tab];
                while(mul_cnt) {
					
                    mul_cnt--;
                    queue<string> mult(op_g);
                    string f3 = mult.front();
                    mult.pop();
                    string f4 = mult.front();
                    mult.pop();

                    //cout << "ADDITIONAL COL JOIN " << f3 << " " << f4 << " " << join_eq_type.front() << endl;

                    queue<string> rc;
                    rc.push(f3);
					
                    allocColumns(left, rc);
                    size_t offset = 0;
                    copyColumns(left, rc, i, offset, 0, 0);
                    rc.pop();

                    if (res_count) {
                        thrust::device_ptr<bool> d_add = thrust::device_malloc<bool>(res_count);
						
						if(right->d_columns_int[f4].size() == 0)
							load_queue(rc, right, f4, rcount, 0, right->segCount, 0, 0);                   


                        if (left->type[f3] == 1 && right->type[f4]  == 1) {                        	
							thrust::transform(make_permutation_iterator(left->d_columns_float[f3].begin(), p_tmp.begin()),
											  make_permutation_iterator(left->d_columns_float[f3].begin(), p_tmp.end()),
											  make_permutation_iterator(right->d_columns_float[f4].begin(), d_res2),
											  d_add, float_equal_to());
                        }
                        else {                        	
							if(join_eq_type1.front() != 'N') 
								thrust::transform(make_permutation_iterator(left->d_columns_int[f3].begin(), p_tmp.begin()),
												  make_permutation_iterator(left->d_columns_int[f3].begin(), p_tmp.end()),
												  make_permutation_iterator(right->d_columns_int[f4].begin(), d_res2),
												  d_add, thrust::equal_to<int_type>());
							else  {
								thrust::transform(make_permutation_iterator(left->d_columns_int[f3].begin(), p_tmp.begin()),
												  make_permutation_iterator(left->d_columns_int[f3].begin(), p_tmp.end()),
												  make_permutation_iterator(right->d_columns_int[f4].begin(), d_res2),
												  d_add, thrust::not_equal_to<int_type>());								
							};				  
                        };

						if (join_kind == 'I' || join_kind == '1' || join_kind == '2' || join_kind == '3' || join_kind == '4') {  // result count changes only in case of an inner join
                            unsigned int new_cnt = thrust::count(d_add, d_add+res_count, 1);
                            thrust::stable_partition(d_res2, d_res2 + res_count, d_add, thrust::identity<unsigned int>());
                            thrust::stable_partition(p_tmp.begin(), p_tmp.end(), d_add, thrust::identity<unsigned int>());                            
                            res_count = new_cnt;
						}
						else { //otherwise we consider it a valid left join result with non-nulls on the left side and nulls on the right side
							thrust::transform(d_res2, d_res2 + res_count, d_add , d_res2, set_minus());
						};
						thrust::device_free(d_add);
					};
					if(!join_eq_type1.empty())
						join_eq_type1.pop();
                };
				
				
				while(!join_eq_type1.empty())
					join_eq_type1.pop();
				
				//cout << "MUL res_count " << res_count << endl;			
				
				
				if(join_kind == '1') { //LEFT SEMI
					thrust::sort(p_tmp.begin(), p_tmp.begin() + res_count);
					auto new_end = thrust::unique(p_tmp.begin(), p_tmp.begin() + res_count);
					res_count = new_end - p_tmp.begin();
				}
				else if(join_kind == '2'){ // RIGHT SEMI
					thrust::sort(d_res2, d_res2 + res_count);
					auto new_end = thrust::unique(d_res2, d_res2 + res_count);
					res_count = new_end - d_res2;
					auto old_sz = ranj.size();
					ranj.resize(ranj.size() + res_count);
					thrust::copy(d_res2, d_res2 + res_count, ranj.begin() + old_sz);
					thrust::sort(ranj.begin(), ranj.end());
					auto ra_cnt = thrust::unique(ranj.begin(), ranj.end());
					ranj.resize(ra_cnt-ranj.begin());						
				}
				else if(join_kind == '3'){ // ANTI JOIN LEFT
					thrust::counting_iterator<int> iter(0);
					thrust::device_vector<int> rr(cnt_l);					
					auto new_end = thrust::set_difference(iter, iter+cnt_l, p_tmp.begin(), p_tmp.begin() + res_count, rr.begin());
					res_count = new_end - rr.begin();
					thrust::copy(rr.begin(), new_end, p_tmp.begin());
				}
				else if(join_kind == '4'){ // ANTI JOIN RIGHT
	
					thrust::sort(d_res2, d_res2 + res_count);			
					auto new_end = thrust::unique(d_res2, d_res2 + res_count);			
					auto cnt = new_end - d_res2;
					thrust::device_vector<int> seq(cnt + ranj.size());		
					
					//auto new_end = thrust::set_difference(seq.begin(), seq.end(), d_res2, d_res2 + res_count, rr.begin());
					auto new_end1 = thrust::set_union(d_res2, d_res2 + cnt, ranj.begin(), ranj.end(), seq.begin());					
					auto s_cnt = new_end1 - seq.begin();
					thrust::sort(seq.begin(), seq.begin() + s_cnt);
					auto end_seq = thrust::unique(seq.begin(), seq.begin() + s_cnt);
					auto u_cnt = end_seq - seq.begin();					
					ranj.resize(u_cnt);
					thrust::copy(seq.begin(), seq.begin() + u_cnt, ranj.begin());
					
					thrust::sort(ranj.begin(), ranj.end());
					auto ra_cnt = thrust::unique(ranj.begin(), ranj.end());
					ranj.resize(ra_cnt-ranj.begin());								
				}
				

                tot_count = tot_count + res_count;
				//cout << "tot " << tot_count << endl;

				//std::clock_t start12 = std::clock();
                if(res_count && join_kind != '4' && join_kind != '2') {          		
					
                    offset = c->mRecCount;
                    queue<string> op_sel1(op_sel_s);					
					c->resize_join(res_count);					
					if(scratch.size() < res_count*int_size)
						scratch.resize(res_count*int_size);
					thrust::fill(scratch.begin(), scratch.begin() + res_count*int_size, 0);										
                    std::map<string,bool> processed;
					
                    while(!op_sel1.empty()) {

                        if (processed.find(op_sel1.front()) != processed.end()) {
                            op_sel1.pop();
                            continue;
                        }
                        else
                            processed[op_sel1.front()] = 1;

                        while(!cc.empty())
                            cc.pop();

                        cc.push(op_sel1.front());

                        if(std::find(left->columnNames.begin(), left->columnNames.end(), op_sel1.front()) !=  left->columnNames.end() && join_kind != '2') {												
								allocColumns(left, cc);
								copyColumns(left, cc, i, k, 0, 0);						
								//gather
								if(left->type[op_sel1.front()] != 1 ) {
									thrust::device_ptr<int_type> d_tmp((int_type*)thrust::raw_pointer_cast(scratch.data()));
									thrust::gather(p_tmp.begin(), p_tmp.begin() + res_count, left->d_columns_int[op_sel1.front()].begin(), d_tmp);
									thrust::copy(d_tmp, d_tmp + res_count, c->h_columns_int[op_sel1.front()].begin() + offset);
								}
								else {
									thrust::device_ptr<float_type> d_tmp((float_type*)thrust::raw_pointer_cast(scratch.data()));
									thrust::gather(p_tmp.begin(), p_tmp.begin() + res_count, left->d_columns_float[op_sel1.front()].begin(), d_tmp);
									thrust::copy(d_tmp, d_tmp + res_count, c->h_columns_float[op_sel1.front()].begin() + offset);
								};

								if(op_sel1.front() != colname1)
									left->deAllocColumnOnDevice(op_sel1.front());
							//};
                        }
                        else if(std::find(right->columnNames.begin(), right->columnNames.end(), op_sel1.front()) !=  right->columnNames.end()) {

                            //gather
                            if(right->type[op_sel1.front()] != 1) {
                                thrust::device_ptr<int_type> d_tmp((int_type*)thrust::raw_pointer_cast(scratch.data()));
                                thrust::gather(d_res2, d_res2 + res_count, right->d_columns_int[op_sel1.front()].begin(), d_tmp);
                                thrust::copy(d_tmp, d_tmp + res_count, c->h_columns_int[op_sel1.front()].begin() + offset);								
                            }
                            else {
                                thrust::device_ptr<float_type> d_tmp((float_type*)thrust::raw_pointer_cast(scratch.data()));
                                thrust::gather(d_res2, d_res2 + res_count, right->d_columns_float[op_sel1.front()].begin(), d_tmp);
                                thrust::copy(d_tmp, d_tmp + res_count, c->h_columns_float[op_sel1.front()].begin() + offset);
                            }
                        }
                        else {
                        };
                        op_sel1.pop();
                    };
                };
				thrust::device_free(d_res1);
				thrust::device_free(d_res2);
            };
        };
		
		if(join_type.front() == '4') {
			thrust::device_vector<int> st(cnt_r);
			thrust::sequence(st.begin(), st.end(),0,1);
			thrust::device_vector<int> r(cnt_r);
			auto new_end = thrust::set_difference(st.begin(), st.end(), ranj.begin(), ranj.end(), r.begin());	
			ranj.resize(0);	
			res_count = new_end - r.begin();
			tot_count = res_count;
			
			queue<string> op_sel1(op_sel_s);					
			c->resize_join(res_count);					
			if(scratch.size() < res_count*int_size)
				scratch.resize(res_count*int_size);
			thrust::fill(scratch.begin(), scratch.begin() + res_count*int_size, 0);										
			std::map<string,bool> processed;
			
			while(!op_sel1.empty()) {
				if (processed.find(op_sel1.front()) != processed.end()) {
					op_sel1.pop();
					continue;
				}
				else
					processed[op_sel1.front()] = 1;

				while(!cc.empty())
					cc.pop();

				cc.push(op_sel1.front());			
				thrust::device_ptr<int_type> d_tmp((int_type*)thrust::raw_pointer_cast(scratch.data()));
				thrust::gather(r.begin(), r.end(), right->d_columns_int[op_sel1.front()].begin(), d_tmp);
				thrust::copy(d_tmp, d_tmp + res_count, c->h_columns_int[op_sel1.front()].begin());				
				op_sel1.pop();
			};		
		}
		else if(join_type.front() == '2') {
			res_count = ranj.size();
			tot_count = res_count;		
			queue<string> op_sel1(op_sel_s);					
			c->resize_join(res_count);					
			if(scratch.size() < res_count*int_size)
				scratch.resize(res_count*int_size);
			thrust::fill(scratch.begin(), scratch.begin() + res_count*int_size, 0);										
			std::map<string,bool> processed;
			
			while(!op_sel1.empty()) {
				if (processed.find(op_sel1.front()) != processed.end()) {
					op_sel1.pop();
					continue;
				}
				else
					processed[op_sel1.front()] = 1;

				while(!cc.empty())
					cc.pop();

				cc.push(op_sel1.front());			
				thrust::device_ptr<int_type> d_tmp((int_type*)thrust::raw_pointer_cast(scratch.data()));
				thrust::gather(ranj.begin(), ranj.end(), right->d_columns_int[op_sel1.front()].begin(), d_tmp);
				thrust::copy(d_tmp, d_tmp + res_count, c->h_columns_int[op_sel1.front()].begin());				
				op_sel1.pop();
			};	
			ranj.resize(0);			
		};		
    };	

    left->deAllocOnDevice();
    right->deAllocOnDevice();
    c->deAllocOnDevice();

    varNames[s] = c;
    c->mRecCount = tot_count;
    c->hostRecCount = tot_count;
    c->name = s;

    if(verbose)
        cout << "tot res " << tot_count << " " << getFreeMem() << endl;

    if(right->tmp_table == 1) {
        right->free();
        varNames.erase(j2);
    }
    else {
        if(mystat[j2] == statement_count) {
            right->free();
            varNames.erase(j2);
        };
    };
    if(mystat[j1] == statement_count) {
        left->free();
        varNames.erase(j1);
    };	
	
    join_type.pop();	
	if(!join_eq_type.empty())
		join_eq_type.pop();
	
    size_t tot_size = tot_count*8*c->columnNames.size();		
    if (getFreeMem() > tot_size) {
        c->maxRecs = tot_count;
        c->segCount = 1;
    }
    else {		
        c->segCount = ((tot_size)/getFreeMem() + 1);
        c->maxRecs = c->hostRecCount - (c->hostRecCount/c->segCount)*(c->segCount-1);
    };	

    if(verbose)
        std::cout<< "join time " <<  ( ( std::clock() - start1 ) / (double)CLOCKS_PER_SEC ) << " " << getFreeMem() << endl;	

}


void order_on_host(CudaSet *a, CudaSet* b, queue<string> names, stack<string> exe_type, stack<string> exe_value)
{
    unsigned int tot = 0;
    if(!a->not_compressed) { //compressed
        allocColumns(a, names);

        unsigned int c = 0;
        size_t cnt = 0;
        for(unsigned int i = 0; i < a->segCount; i++) {
            copyColumns(a, names, (a->segCount - i) - 1, cnt);	//uses segment 1 on a host	to copy data from a file to gpu
            if (a->mRecCount) {
                a->CopyToHost((c - tot) - a->mRecCount, a->mRecCount);
                tot = tot + a->mRecCount;
            };
        };
    }
    else
        tot = a->mRecCount;

    b->resize(tot); //resize host arrays
    a->mRecCount = tot;

    unsigned int* permutation = new unsigned int[a->mRecCount];
    thrust::sequence(permutation, permutation + a->mRecCount);

    size_t maxSize =  a->mRecCount;
    char* temp;
    temp = new char[maxSize*max_char(a)];

    // sort on host

    for(int i=0; !exe_type.empty(); ++i, exe_type.pop(),exe_value.pop()) {

        if (a->type[exe_type.top()] == 0)
            update_permutation_host(a->h_columns_int[exe_type.top()].data(), permutation, a->mRecCount, exe_value.top(), (int_type*)temp);
        else if (a->type[exe_type.top()] == 1)
            update_permutation_host(a->h_columns_float[exe_type.top()].data(), permutation, a->mRecCount,exe_value.top(), (float_type*)temp);
        else {
            update_char_permutation(a, exe_type.top(), permutation, exe_value.top(),  temp, 1);
        };
    };

    for (unsigned int i = 0; i < a->mColumnCount; i++) {
        if (a->type[a->columnNames[i]] != 1) {
            apply_permutation_host(a->h_columns_int[a->columnNames[i]].data(), permutation, a->mRecCount, b->h_columns_int[a->columnNames[i]].data());
        }
        else
            apply_permutation_host(a->h_columns_float[a->columnNames[i]].data(), permutation, a->mRecCount, b->h_columns_float[a->columnNames[i]].data());
    };

    delete [] temp;
    delete [] permutation;
}



void emit_order(const char *s, const char *f, const int e, const int ll)
{
    if(ll == 0)
        statement_count++;
	
    if (scan_state == 0 && ll == 0) {
        if (mystat.find(f) == mystat.end() && data_dict.count(f) == 0) {
            process_error(2, "Order : couldn't find variable " + string(f));
        };
        mystat[s] = statement_count;
        mystat[f] = statement_count;
		if(filter_var.find(f) != filter_var.end()) 
			mystat[filter_var[f]] = statement_count;

        return;
    };

    if (scan_state == 0) {
        check_used_vars();
        return;
    };

    if(varNames.find(f) == varNames.end() ) {
        clean_queues();
        return;
    };

    CudaSet* a = varNames.find(f)->second;
    stack<string> exe_type, exe_value;

    if(verbose)
        cout << "ORDER: " << s << " " << f << endl;


    for(int i=0; !op_type.empty(); ++i, op_type.pop(),op_value.pop()) {
        if ((op_type.front()).compare("NAME") == 0) {
            exe_type.push(op_value.front());
            exe_value.push("ASC");
        }
        else {
            exe_type.push(op_type.front());
            exe_value.push(op_value.front());
        };
        if(std::find(a->columnNames.begin(), a->columnNames.end(), exe_type.top()) == a->columnNames.end()) {
            process_error(2, "Couldn't find name " + exe_type.top());
        };

    };

    stack<string> tp(exe_type);
    queue<string> op_vx;
    while (!tp.empty()) {
        op_vx.push(tp.top());
        tp.pop();
    };

    queue<string> names;
    for (unsigned int i = 0; i < a->columnNames.size() ; i++ )
        names.push(a->columnNames[i]);

    CudaSet *b = a->copyDeviceStruct();

    //lets find out if our data set fits into a GPU
    size_t mem_available = getFreeMem();
    size_t rec_size = 0;
    for(unsigned int i = 0; i < a->mColumnCount; i++) {
        if(a->type[a->columnNames[i]] == 0)
            rec_size = rec_size + int_size;
        else if(a->type[a->columnNames[i]] == 1)
            rec_size = rec_size + float_size;
        else
            rec_size = rec_size + a->char_size[a->columnNames[i]];
    };
    bool fits;
    if (rec_size*a->mRecCount > (mem_available/2)) // doesn't fit into a GPU
        fits = 0;
    else fits = 1;

    if(!fits) {
        order_on_host(a, b, names, exe_type, exe_value);
    }
    else {
        // initialize permutation to [0, 1, 2, ... ,N-1]

        size_t rcount;
        if(a->filtered) {
            CudaSet *t = varNames[a->source_name];
            a->mRecCount = t->mRecCount;
            a->hostRecCount = a->mRecCount;
        };

        a->mRecCount = load_queue(names, a, op_vx.front(), rcount, 0, a->segCount);

		if(scratch.size() < a->mRecCount)
			scratch.resize(a->mRecCount*4);
		thrust::device_ptr<unsigned int> permutation((unsigned int*)thrust::raw_pointer_cast(scratch.data())); 
        thrust::sequence(permutation, permutation+(a->mRecCount));
        unsigned int* perm_ptr = thrust::raw_pointer_cast(permutation);

        void* temp;
        CUDA_SAFE_CALL(cudaMalloc((void **) &temp, a->mRecCount*max_char(a)));

        if(a->filtered)
            varNames[a->source_name]->hostRecCount = varNames[a->source_name]->mRecCount;
        else
            a->hostRecCount = a->mRecCount;;


        if(a->filtered)
            varNames[a->source_name]->mRecCount = varNames[a->source_name]->hostRecCount;
        else
            a->mRecCount = a->hostRecCount;

        for(int i=0; !exe_type.empty(); ++i, exe_type.pop(),exe_value.pop()) {
            if (a->type[exe_type.top()] == 0 && a->string_map.find(exe_type.top()) == a->string_map.end())
                update_permutation(a->d_columns_int[exe_type.top()], perm_ptr, a->mRecCount, exe_value.top(), (int_type*)temp, 64);
            else if (a->type[exe_type.top()] == 1)
                update_permutation(a->d_columns_float[exe_type.top()], perm_ptr, a->mRecCount,exe_value.top(), (float_type*)temp, 64);
            else {
                //get strings to device
                update_char_permutation(a, exe_type.top(), perm_ptr, exe_value.top(), temp, 0);
            };
        };

        b->resize(a->mRecCount); //resize host arrays
        b->mRecCount = a->mRecCount;

        for (unsigned int i = 0; i < a->mColumnCount; i++) {
            if (a->type[a->columnNames[i]] != 1) {
                apply_permutation(a->d_columns_int[a->columnNames[i]], perm_ptr, a->mRecCount, (int_type*)temp, 64);
            }
            else
                apply_permutation(a->d_columns_float[a->columnNames[i]], perm_ptr, a->mRecCount, (float_type*)temp, 64);
        };

        for(unsigned int i = 0; i < a->mColumnCount; i++) {
            if(a->type[a->columnNames[i]] != 1) {
                thrust::copy(a->d_columns_int[a->columnNames[i]].begin(), a->d_columns_int[a->columnNames[i]].begin() + a->mRecCount, b->h_columns_int[a->columnNames[i]].begin());
            }
            else
                thrust::copy(a->d_columns_float[a->columnNames[i]].begin(), a->d_columns_float[a->columnNames[i]].begin() + a->mRecCount, b->h_columns_float[a->columnNames[i]].begin());
        };

        b->deAllocOnDevice();
        a->deAllocOnDevice();
        cudaFree(temp);
    };

    varNames[s] = b;
    b->segCount = 1;
    b->not_compressed = 1;
    b->string_map = a->string_map;

    if(mystat[f] == statement_count && !a->keep) {
        a->free();
        varNames.erase(f);
    };
}


void emit_select(const char *s, const char *f, const int grp_cnt)
{	
    statement_count++;
    if (scan_state == 0) {
        if (mystat.find(f) == mystat.end() && data_dict.count(f) == 0) {
            process_error(2, "Select : couldn't find variable " + string(f) );
        };
        mystat[s] = statement_count;
        mystat[f] = statement_count;
		if(filter_var.find(f) != filter_var.end()) 
			mystat[filter_var[f]] = statement_count;
		
        check_used_vars();
        clean_queues();
        return;
    };

    if(varNames.find(f) == varNames.end()) {
        clean_queues();
        cout << "Couldn't find1 " << f << endl;
        process_error(2, "Couldn't find(1) " + string(f) );
        return;
    };

    queue<string> op_v1(op_value);
    while(op_v1.size() > grp_cnt)
        op_v1.pop();


    stack<string> op_v2;
    queue<string> op_v3;

    for(int i=0; i < grp_cnt; ++i) {
        op_v2.push(op_v1.front());
        op_v3.push(op_v1.front());
        op_v1.pop();
    };


    CudaSet *a;
    if(varNames.find(f) != varNames.end())
        a = varNames.find(f)->second;
    else {
        process_error(2, "Couldn't find " + string(f) );
    };

    if(a->mRecCount == 0 && !a->filtered) {
        CudaSet *c;
        c = new CudaSet(0,1);
        varNames[s] = c;
        c->name = s;
        clean_queues();
        if(verbose)
            cout << "SELECT " << s << " count : 0,  Mem " << getFreeMem() << endl;
        return;
    };

    if(verbose)
        cout << "SELECT " << s << " " << f << " " << getFreeMem() << endl;
    std::clock_t start1 = std::clock();

    // here we need to determine the column count and composition

    queue<string> op_v(op_value);
    queue<string> op_vx;
    set<string> field_names;
    map<string,string> aliases;
    string tt;

    while(!op_v.empty()) {
        if(std::find(a->columnNames.begin(), a->columnNames.end(), op_v.front()) != a->columnNames.end()) {
            tt = op_v.front();
            op_v.pop();
            if(!op_v.empty()) {
                if(std::find(a->columnNames.begin(), a->columnNames.end(), op_v.front()) == a->columnNames.end()) {
                    if(aliases.count(tt) == 0) {
                        aliases[tt] = op_v.front();
                    };
                }
                else {
                    while(std::find(a->columnNames.begin(), a->columnNames.end(), op_v.front()) == a->columnNames.end() && !op_v.empty()) {
                        op_v.pop();
                    };
                };
            };
        };
        if(!op_v.empty())
            op_v.pop();
    };

    op_v = op_value;
    while(!op_v.empty()) {
        if(std::find(a->columnNames.begin(), a->columnNames.end(), op_v.front()) != a->columnNames.end()) {
            field_names.insert(op_v.front());
        };
        op_v.pop();
    };

    for (auto it=field_names.begin(); it!=field_names.end(); ++it)  {
        op_vx.push(*it);
    };

    // find out how many columns a new set will have
    queue<string> op_t(op_type);
    int_type col_count = 0;

    for(int i=0; !op_t.empty(); ++i, op_t.pop())
        if((op_t.front()).compare("emit sel_name") == 0)
            col_count++;

    CudaSet *b, *c;

    if(a->segCount <= 1)
        setSegments(a, op_vx);
    allocColumns(a, op_vx);

    unsigned int cycle_count;
    if(a->filtered)
        cycle_count = varNames[a->source_name]->segCount;
    else
        cycle_count = a->segCount;

    size_t ol_count = a->mRecCount, cnt;
    a->hostRecCount = a->mRecCount;
    b = new CudaSet(0, col_count);
    b->name = "tmp b in select";
    bool c_set = 0;

    //size_t tmp_size = a->mRecCount;
    //if(a->segCount > 1)
    //    tmp_size = a->maxRecs;

    vector<thrust::device_vector<int_type> > distinct_val; //keeps array of DISTINCT values for every key
    vector<thrust::device_vector<int_type> > distinct_hash; //keeps array of DISTINCT values for every key
    vector<thrust::device_vector<int_type> > distinct_tmp;

    /* for(unsigned int i = 0; i < distinct_cnt; i++) {
         distinct_tmp.push_back(thrust::device_vector<int_type>(tmp_size));
         distinct_val.push_back(thrust::device_vector<int_type>());
         distinct_hash.push_back(thrust::device_vector<int_type>());
     };
    */

    bool one_liner;	
	if (grp_cnt != 0)
		phase_copy = 1;	

    for(unsigned int i = 0; i < cycle_count; i++) {          // MAIN CYCLE
        if(verbose)
            cout << "segment " << i << " select mem " << getFreeMem() << endl;
        std::clock_t start3 = std::clock();

        cnt = 0;
        copyColumns(a, op_vx, i, cnt);
		
        if(a->mRecCount) {
            if (grp_cnt != 0) {			
				bool not_srt_and_eq = 0;
				stack<string> op_vv(op_v2);
				while(!op_vv.empty()) {
					if(!min_max_eq[op_vv.top()])
						not_srt_and_eq = 1;
					op_vv.pop();	
				};
				if(not_srt_and_eq) {
					order_inplace(a, op_v2, field_names, 1);	
					a->GroupBy(op_v2);				
				}
				else {
					if(a->grp.size() != 1)
						a->grp.resize(1);	
					a->grp[0] = 1;
					a->grp_count = 1;	
				};	
            }
			else
				a->grp_count = 0;			
			
			copyFinalize(a, op_vx,0);
			
					
            one_liner = select(op_type,op_value,op_nums, op_nums_f, op_nums_precision, a,b, distinct_tmp);	

            if(i == 0)
                std::reverse(b->columnNames.begin(), b->columnNames.end());


            if (!c_set && b->mRecCount > 0) {
                c = new CudaSet(0, col_count);
                create_c(c,b);
                c_set = 1;
                c->name = s;
            };			

            if (grp_cnt && cycle_count > 1  && b->mRecCount > 0) {
                add(c,b,op_v3, aliases, distinct_tmp, distinct_val, distinct_hash, a);
            }
            else {
                //copy b to c
                unsigned int c_offset = c->mRecCount;
                c->resize(b->mRecCount);

                for(unsigned int j=0; j < b->columnNames.size(); j++) {
                    if (b->type[b->columnNames[j]] == 0) {
                        thrust::copy(b->d_columns_int[b->columnNames[j]].begin(), b->d_columns_int[b->columnNames[j]].begin() + b->mRecCount, c->h_columns_int[b->columnNames[j]].begin() + c_offset);
                    }
                    else if (b->type[b->columnNames[j]] == 1) {
                        thrust::copy(b->d_columns_float[b->columnNames[j]].begin(), b->d_columns_float[b->columnNames[j]].begin() + b->mRecCount, c->h_columns_float[b->columnNames[j]].begin() + c_offset);
                    };
                };
            };
			//std::cout<< "add time " <<  ( ( std::clock() - start3 ) / (double)CLOCKS_PER_SEC ) <<  '\n';				
        };
        std::cout<< "cycle sel time " <<  ( ( std::clock() - start3 ) / (double)CLOCKS_PER_SEC ) << " " << getFreeMem() << '\n';
    };
	phase_copy = 0;

    a->mRecCount = ol_count;
    a->mRecCount = a->hostRecCount;
    a->deAllocOnDevice();
    b->deAllocOnDevice();
	a->grp.resize(0);
	a->grp.shrink_to_fit();
	for(auto i = 0; i < alloced_mem.size(); i++) {
		cudaFree(alloced_mem[i]);
		alloced_mem.pop_back();
	};

    if(!c_set) {
        CudaSet *c;
        c = new CudaSet(0,1);
        varNames[s] = c;
        c->name = s;
        clean_queues();
        return;
    };
	
    if (grp_cnt) {
        count_avg(c, distinct_hash);
    }
    else {
        if(one_liner) {
            count_simple(c);
        };
    };
	
    c->maxRecs = c->mRecCount;
    c->hostRecCount = c->mRecCount;
    c->string_map = b->string_map;
    c->name = s;
    c->keep = 1;
    if(verbose)
        cout << "select res " << c->mRecCount << endl;
		
    size_t tot_size = c->maxRecs*8*c->columnNames.size();	
    if (getFreeMem() < tot_size*3) {	
        c->segCount = ((tot_size*3)/getFreeMem() + 1);
        c->maxRecs = c->hostRecCount - (c->hostRecCount/c->segCount)*(c->segCount-1);
	};		

    clean_queues();
    varNames[s] = c;
    b->free();
    varNames[s]->keep = 1;

    if(mystat[s] == statement_count) {
        varNames[s]->free();
        varNames.erase(s);
    };

    if(mystat[f] == statement_count && a->keep == 0) {
        a->free();
        varNames.erase(f);
    };
    if(verbose)
        std::cout<< "select time " <<  ( ( std::clock() - start1 ) / (double)CLOCKS_PER_SEC ) <<'\n';

}


void emit_insert(const char *f, const char* s) {
    statement_count++;
    if (scan_state == 0) {
        if (mystat.find(f) == mystat.end() && data_dict.count(f) == 0) {
            process_error(2, "Insert : couldn't find variable " + string(f));
        };
        if (mystat.find(s) == mystat.end() && data_dict.count(s) == 0) {
            process_error(2, "Insert : couldn't find variable " + string(s) );
        };
        check_used_vars();
        mystat[f] = statement_count;
        mystat[s] = statement_count;
        clean_queues();
        return;
    };


    if(varNames.find(f) == varNames.end() || varNames.find(s) == varNames.end()) {
        clean_queues();
        return;
    };

    if(verbose)
        cout << "INSERT " << f << " " << s << endl;
    insert_records(f,s);
    clean_queues();


};


void emit_delete(const char *f)
{
    statement_count++;
    if (scan_state == 0) {
        if (mystat.find(f) == mystat.end()  && data_dict.count(f) == 0) {
            process_error(2, "Delete : couldn't find variable " + string(f));
        };
        mystat[f] = statement_count;
        check_used_vars();
        clean_queues();
        return;
    };

    if(varNames.find(f) == varNames.end()) {
        clean_queues();
        return;
    };

    delete_records(f);
    cout << "DELETE " << f <<  endl;
    clean_queues();

}

void emit_case()
{
    op_case = 1;
    if (scan_state == 1)
        cout << "emit case " << endl;
    //extract releveant values and pass to modified filter
    // get a bool vector back
    /*						while(!op_type.empty())
    						{
    						cout << "CASE type " << op_type.front() << endl;
    						op_type.pop();
    						}
    */
}



void emit_create_index(const char *index_name, const char *table, const char *column)
{
	if (scan_state != 0) {
		FILE *f;
		string s1(table);
		string s3 = s1 + ".key";
		f = fopen(s3.c_str(), "w");
		fputs(column,f);
		fclose(f);
   };
}


void emit_create_interval(const char *interval_name, const char *table, const char *lcolumn, const char *rcolumn)
{
	if (scan_state != 0) {
		FILE *f;
		string s1(table);
		string s3 = s1 + ".interval";
		f = fopen(s3.c_str(), "w");
		fputs(lcolumn,f);
		fputc('|',f);
		fputs(rcolumn,f);
		fclose(f);
   };
}



void emit_create_bitmap_index(const char *index_name, const char *ltable, const char *rtable, const char *rcolumn, const char *lid, const char *rid)
{
    statement_count++;
    if (scan_state == 0) {
        emit_name(rcolumn);
        emit_sel_name(rcolumn);
        emit_name(lid);
        emit_name(rid);
        check_used_vars();
		mystat[rtable] = std::numeric_limits<unsigned int>::max();
        mystat[ltable] = std::numeric_limits<unsigned int>::max();		
    }
    else {
		cout << ltable << " " << rtable << " " << rid << " " << lid << endl;
        emit_name(rcolumn);
        emit_sel_name(rcolumn);
        emit_name(lid);
        emit_name(rid);
        check_used_vars();	
		
        if(varNames.find(ltable) == varNames.end())
            cout << "Couldn't find  " << ltable << endl;
        if(varNames.find(rtable) == varNames.end())
            cout << "Couldn't find  " << rtable << endl;
		
				
        CudaSet* left = varNames.find(ltable)->second;
		CudaSet* right = varNames.find(rtable)->second;
		
		queue<string> op_vx;
		op_vx.push(rcolumn);op_vx.push(rid);
		allocColumns(right, op_vx);		
		right->CopyColumnToGpu(rid, 0, 0);
		right->CopyColumnToGpu(rcolumn, 0, 0);
		op_vx.pop();op_vx.pop();
		op_vx.push(lid);
		allocColumns(left, op_vx);		
		
        for(int i = 0; i < left->segCount; i++) {
			
			left->CopyColumnToGpu(lid, i, 0);			
	
			thrust::device_vector<unsigned int> output(left->mRecCount);
			thrust::lower_bound(right->d_columns_int[rid].begin(), right->d_columns_int[rid].begin() + right->mRecCount, 
							    left->d_columns_int[lid].begin(), left->d_columns_int[lid].begin() + left->mRecCount, output.begin());

            string str = std::string(ltable) + std::string(".") + std::string(rtable) + std::string(".") + std::string(rcolumn) + std::string(".") + to_string(i);

			thrust::device_vector<int_type> res(left->mRecCount);
			thrust::host_vector<int_type> res_h(left->mRecCount);
			
            if(right->type[rcolumn] == 0) {
                thrust::gather(output.begin(), output.begin() + left->mRecCount,  right->d_columns_int[rcolumn].begin() , res.begin());
                thrust::copy(res.begin(), res.begin() + left->mRecCount, res_h.begin());				
                compress_int(str, res_h);
            }
            else if(right->type[rcolumn] == 1) {
            }
            else { //strings
                string f1 = right->load_file_name + "." + rcolumn + ".0.hash"; //need to change it in case if there are dimensions tables larger than 1 segment ?
                FILE* f = fopen(f1.c_str(), "rb" );
                unsigned int cnt;
                fread(&cnt, 4, 1, f);
				if(res_h.size() < cnt)
					res_h.resize(cnt);
				if(res.size() < cnt)
					res.resize(cnt);				
                fread(res_h.data(), cnt*8, 1, f);
				res = res_h;
                fclose(f);

				thrust::device_vector<int_type> output1(left->mRecCount);
				thrust::gather(output.begin(), output.begin() + left->mRecCount ,
								res.begin(), output1.begin());				
							
                thrust::copy(output1.begin(), output1.begin() + left->mRecCount, res_h.begin());
                compress_int(str, res_h);
            };
        };		
    };
}

void emit_display(const char *f, const char* sep)
{
    statement_count++;
    if (scan_state == 0) {
        if (mystat.find(f) == mystat.end() && data_dict.count(f) == 0) {
            process_error(2, "Filter : couldn't find variable " + string(f) );
        };
        mystat[f] = statement_count;
   		if(filter_var.find(f) != filter_var.end()) 
			mystat[filter_var[f]] = statement_count;
        clean_queues();
        return;
    };

    if(varNames.find(f) == varNames.end()) {
        clean_queues();
        return;
    };

    CudaSet* a = varNames.find(f)->second;
    int limit = 0;
    if(!op_nums.empty()) {
        limit = op_nums.front();
        op_nums.pop();
    };

    a->Display(limit, 0, 1);
    clean_queues();
    if(mystat[f] == statement_count  && a->keep == 0) {
        a->free();
        varNames.erase(f);
    };

}


void emit_filter(char *s, char *f)
{
    statement_count++;
    if (scan_state == 0) {
        if (mystat.find(f) == mystat.end() && data_dict.count(f) == 0) {
            process_error(1, "Filter : couldn't find variable " + string(f));
        };
        mystat[s] = statement_count;
        mystat[f] = statement_count;
		filter_var[s] = f;
        // check possible use of other variables in filters
        queue<string> op(op_value);
        while(!op.empty()) {
            size_t pos1 = op.front().find_first_of(".", 0);
            if(pos1 != string::npos) {
                mystat[op.front().substr(0,pos1)] = statement_count;
            };
            op.pop();
        };

        check_used_vars();
        clean_queues();
        return;
    };

	
    CudaSet *a, *b;

    a = varNames.find(f)->second;
    a->name = f;

    if(a->mRecCount == 0 && !a->filtered) {
        b = new CudaSet(0,1);
    }
    else {
        if(verbose)
            cout << "INLINE FILTER " << f << endl;
        b = a->copyDeviceStruct();

        b->name = s;
        b->sorted_fields = a->sorted_fields;
        b->presorted_fields = a->presorted_fields;
        //save the stack
        b->fil_s = s;
        b->fil_f = f;
        b->fil_type = op_type;
        b->fil_value = op_value;
        b->fil_nums = op_nums;		
        b->fil_nums_f = op_nums_f;		
		b->fil_nums_precision = op_nums_precision;
        b->filtered = 1;
        b->tmp_table = a->tmp_table;
        b->string_map = a->string_map;
        if(a->filtered) {

            b->source_name = a->source_name;
            b->fil_f = a->fil_f;
            while(!a->fil_value.empty()) {
                b->fil_value.push(a->fil_value.front());
                a->fil_value.pop();
            };

            while(!a->fil_type.empty()) {
                b->fil_type.push(a->fil_type.front());
                a->fil_type.pop();
            };
            b->fil_type.push("AND");

            while(!a->fil_nums.empty()) {
                b->fil_nums.push(a->fil_nums.front());
                a->fil_nums.pop();
            };
			
			while(!a->fil_nums_precision.empty()) {
				b->fil_nums_precision.push(a->fil_nums_precision.front());
				a->fil_nums_precision.pop();				
			};	

            while(!a->fil_nums_f.empty()) {
                b->fil_nums_f.push(a->fil_nums_f.front());
                a->fil_nums_f.pop();
            };
            a->filtered = 0;
            varNames.erase(f);
        }
        else
            b->source_name = f;
        b->maxRecs = a->maxRecs;
        b->prm_d.resize(a->maxRecs);
    };
    b->hostRecCount = a->hostRecCount;
    clean_queues();


    if (varNames.count(s) > 0)
        varNames[s]->free();
    varNames[s] = b;

    if(mystat[s] == statement_count) {
        b->free();
        varNames.erase(s);
    };
}

void emit_store(const char *s, const char *f, const char* sep)
{
    statement_count++;
    if (scan_state == 0) {
        if (mystat.find(s) == mystat.end() && data_dict.count(s) == 0) {
            process_error(2, "Store : couldn't find variable " + string(s) );
        };
        mystat[s] = statement_count;
		if(filter_var.find(f) != filter_var.end()) 
			mystat[filter_var[f]] = statement_count;
        clean_queues();
        return;
    };

    if(varNames.find(s) == varNames.end())
        return;

    CudaSet* a = varNames.find(s)->second;
    if(verbose)
        cout << "STORE: " << s << " " << f << " " << sep << endl;

    int limit = 0;
    if(!op_nums.empty()) {
        limit = op_nums.front();
        op_nums.pop();
    };

    a->Store(f,sep, limit, 0, 0);

    if(mystat[s] == statement_count  && a->keep == 0) {
        a->free();
        varNames.erase(s);
    };
};


void emit_store_binary(const char *s, const char *f, const bool append)
{
    statement_count++;
    if (scan_state == 0) {
        if (mystat.find(s) == mystat.end() && data_dict.count(s) == 0) {
            process_error(2, "Store : couldn't find variable " + string(s));
        };
        mystat[s] = statement_count;
		if(filter_var.find(f) != filter_var.end()) 
			mystat[filter_var[f]] = statement_count;
        clean_queues();
        return;
    };
	
	cout << "Append " << append << endl;

    if(varNames.find(s) == varNames.end())
        return;

    CudaSet* a = varNames.find(s)->second;

    if(mystat[f] == statement_count)
        a->deAllocOnDevice();

    printf("STORE: %s %s \n", s, f);

    int limit = 0;
    if(!op_nums.empty()) {
        limit = op_nums.front();
        op_nums.pop();
    };
    total_count = 0;
    total_segments = 0;
	a->maxRecs = 0;
	
    if(fact_file_loaded) {
        a->Store(f,"", limit, 1, append);
    }
    else {
        FILE* file_p;
        if(a->text_source) {
            file_p = fopen(a->load_file_name.c_str(), "rb");
            if (!file_p) {
                process_error(2, "Could not open file " + a->load_file_name );
            };
        };		

		thrust::device_vector<char> d_readbuff;
		thrust::device_vector<char*> dest(a->mColumnCount);
		thrust::device_vector<unsigned int> ind(a->mColumnCount);
		thrust::device_vector<unsigned int> dest_len(a->mColumnCount);	
		
        while(!fact_file_loaded) {
            if(verbose)
                cout << "LOADING " << a->load_file_name << " mem: " << getFreeMem() << endl;
            if(a->text_source)
                fact_file_loaded = a->LoadBigFile(file_p, d_readbuff, dest, ind, dest_len);
			if(a->maxRecs < a->mRecCount)
				a->maxRecs = a->mRecCount;
            a->Store(f,"", limit, 1, append);
        };
    };
    a->writeSortHeader(f);

    if(mystat[f] == statement_count && !a->keep) {
        a->free();
        varNames.erase(s);
    };

};


void emit_load_binary(const char *s, const char *f, const int d)
{
	
    statement_count++;
    if (scan_state == 0) {				
        mystat[s] = statement_count;
        return;
    };	
	
    if(verbose)
        printf("BINARY LOAD: %s %s \n", s, f);	
			
	std::clock_t start1 = std::clock();	
    CudaSet *a;
    unsigned int segCount, maxRecs;
    string f1(f);
    f1 += "." + namevars.front() + ".header";

    FILE* ff = fopen(f1.c_str(), "rb");
    if(!ff) {
        process_error(2, "Couldn't open file " + f1);
    };
    size_t totRecs;
    fread((char *)&totRecs, 8, 1, ff);
    fread((char *)&segCount, 4, 1, ff);
    fread((char *)&maxRecs, 4, 1, ff);
    fclose(ff);


    if(verbose)
        cout << "Reading " << totRecs << " records" << endl;

    a = new CudaSet(namevars, typevars, sizevars, cols, totRecs, f, maxRecs);

    a->segCount = segCount;
    a->keep = true;
    a->name = s;
    varNames[s] = a;

    if(mystat[s] == statement_count )  {
        a->free();
        varNames.erase(s);
    };
	std::cout<< "load time " <<  ( ( std::clock() - start1 ) / (double)CLOCKS_PER_SEC ) << " " << getFreeMem() << '\n';
}


void emit_load(const char *s, const char *f, const int d, const char* sep)
{
    statement_count++;
    if (scan_state == 0) {
        mystat[s] = statement_count;
        return;
    };

    printf("LOAD: %s %s %d  %s \n", s, f, d, sep);

    CudaSet *a;

    a = new CudaSet(namevars, typevars, sizevars, cols, process_count);
    a->keep = true;
    a->not_compressed = 1;
    a->load_file_name = f;	
    a->separator = sep;
    varNames[s] = a;
    fact_file_loaded = 0;

    if(mystat[s] == statement_count)  {
        a->free();
        varNames.erase(s);
    };
}


void emit_show_tables()
{
    if (scan_state == 1) {
        for (auto it=data_dict.begin() ; it != data_dict.end(); ++it ) {
            cout << (*it).first << endl;
        };
    };

    return;
}

void emit_drop_table(const char* table_name)
{
    if (scan_state == 1) {

        map<string, map<string, col_data> >::iterator iter;
        if((iter = data_dict.find(table_name)) != data_dict.end()) {
            auto s = (*iter).second;
            for ( map<string, col_data>::iterator it=s.begin() ; it != s.end(); ++it ) {
                int seg = 0;
                string f_name = (*iter).first + "." + (*it).first + "." + to_string(seg);
                while(!remove(f_name.c_str())) {
                    seg++;
                    f_name = (*iter).first + "." + (*it).first + "." + to_string(seg);
                };
                f_name = (*iter).first + "." + (*it).first + ".header";
                remove(f_name.c_str());
            };
        };
        string s_name = (*iter).first + ".presort";
        remove(s_name.c_str());
        s_name = (*iter).first + ".sort";
        remove(s_name.c_str());

        if(data_dict.find(table_name) != data_dict.end()) {
            data_dict.erase(table_name);
        };
        save_dict = 1;
    };

    return;
}


void emit_describe_table(const char* table_name)
{
    if (scan_state == 1) {
        map<string, map<string, col_data> >::iterator iter;
        if((iter = data_dict.find(table_name)) != data_dict.end()) {
            auto s = (*iter).second;
            for (auto it=s.begin() ; it != s.end(); ++it ) {
                if ((*it).second.col_type == 0) {
					if((*it).second.col_length) {
						if((*it).second.col_length != UINT_MAX)
							cout << (*it).first << " decimal with precision of " << (*it).second.col_length << endl;
						else
							cout << (*it).first << " timestamp" << endl;
					}	
					else	
						cout << (*it).first << " integer" << endl;
                }
                else if ((*it).second.col_type == 1) {
                    cout << (*it).first << " float" << endl;
                }
                else if ((*it).second.col_type == 3) {
                    cout << (*it).first << " decimal" << endl;
                }
                else {
                    cout << (*it).first << " char(" << (*it).second.col_length << ")" << endl;
                };
            };
        };
    };
    return;
}


void yyerror(char *s, ...)
{
    extern int yylineno;
    extern char *yytext;

    fprintf(stderr, "%d: error: ", yylineno);
    cout << yytext << endl;
    error_cb(1, s);
}


void clean_queues()
{
    while(!op_type.empty()) op_type.pop();
    while(!op_value.empty()) op_value.pop();
    while(!op_join.empty()) op_join.pop();
    while(!op_nums.empty()) op_nums.pop();
    while(!op_nums_f.empty()) op_nums_f.pop();
	while(!op_nums_precision.empty()) op_nums_precision.pop();
    while(!j_col_count.empty()) j_col_count.pop();
    while(!namevars.empty()) namevars.pop();
    while(!typevars.empty()) typevars.pop();
    while(!sizevars.empty()) sizevars.pop();
    while(!cols.empty()) cols.pop();
    while(!op_sort.empty()) op_sort.pop();
    while(!op_presort.empty()) op_presort.pop();
    while(!join_type.empty()) join_type.pop();
	while(!join_eq_type.empty()) join_eq_type.pop();
		
    op_case = 0;
    sel_count = 0;
    join_cnt = 0;
    join_col_cnt = 0;
    distinct_cnt = 0;
    join_tab_cnt = 0;
    tab_cnt = 0;
    join_and_cnt.clear();
}

void load_vars()
{	
    if(used_vars.size() == 0) {
        //cout << "Error, no valid column names have been found " << endl;
        //exit(0);
    }
    else {
        for (auto it=used_vars.begin(); it != used_vars.end(); ++it ) {

            while(!namevars.empty()) namevars.pop();
            while(!typevars.empty()) typevars.pop();
            while(!sizevars.empty()) sizevars.pop();
            while(!cols.empty()) cols.pop();
            if(mystat.count((*it).first) != 0) {
                auto c = (*it).second;
                for (auto sit=c.begin() ; sit != c.end(); ++sit ) {
                    //cout << "name " << (*sit).first << " " << data_dict[(*it).first][(*sit).first].col_length << endl;
                    namevars.push((*sit).first);
                    if(data_dict[(*it).first][(*sit).first].col_type == 0) {
						if(data_dict[(*it).first][(*sit).first].col_length == 0) {
							typevars.push("int");
						}	
						else {
							if(data_dict[(*it).first][(*sit).first].col_length == UINT_MAX)
								typevars.push("timestamp");
							else
								typevars.push("decimal");
						}	
					}	
                    else if(data_dict[(*it).first][(*sit).first].col_type == 1)
                        typevars.push("float");
                    else typevars.push("char");
                    sizevars.push(data_dict[(*it).first][(*sit).first].col_length);
                    cols.push(0);
                };
                emit_load_binary((*it).first.c_str(), (*it).first.c_str(), 0);
            };
        };
    };	
}




void process_error(int severity, string err) {
    switch (severity) {
    case 1:
        err = "(Warning) " + err;
        break;
    case 2:
        err = "(Fatal) " + err;
        break;
    default:
        err = "(Aborting) " + err;
        break;
    }
    error_cb(severity, err.c_str());            // send the error to the c based callback
}


void alenkaInit(char ** av)
{
    process_count = 1000000000;
    verbose = 0;
    scan_state = 1;
    statement_count = 0;
    clean_queues();	
    //context = CreateCudaDevice(0, nullptr, true);
}


void alenkaClose()
{
    statement_count = 0;

    if(alloced_sz) {
        cudaFree(alloced_tmp);
        alloced_sz = 0;
    };
}




