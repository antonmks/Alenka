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


%{


#include "lex.yy.c"
#include "cm.h"

    void clean_queues();
    void order_inplace(CudaSet* a, stack<string> exe_type);
    void yyerror(char *s, ...);
    void emit(char *s, ...);
    void emit_mul();
    void emit_add();
    void emit_minus();
    void emit_distinct();
    void emit_div();
    void emit_and();
    void emit_eq();
    void emit_or();
    void emit_cmp(int val);
    void emit_var(char *s, int c, char *f, char* ref, int ref_num);
    void emit_var_asc(char *s);
    void emit_var_desc(char *s);
    void emit_name(char *name);
    void emit_count();
    void emit_sum();
    void emit_average();
    void emit_min();
    void emit_max();
    void emit_string(char *str);
    void emit_number(int_type val);
    void emit_float(float_type val);
    void emit_decimal(float_type val);
    void emit_sel_name(char* name);
    void emit_limit(int val);
    void emit_union(char *s, char *f1, char *f2);
    void emit_varchar(char *s, int c, char *f, int d, char *ref, int ref_num);
    void emit_load(char *s, char *f, int d, char* sep);
    void emit_load_binary(char *s, char *f, int d);
    void emit_store(char *s, char *f, char* sep);
    void emit_store_binary(char *s, char *f, char* sep);
    void emit_store_binary(char *s, char *f);
    void emit_filter(char *s, char *f);
	void emit_delete(char *f);
	void emit_insert(char *f, char* s);
    void emit_order(char *s, char *f, int e, int ll = 0);
    void emit_group(char *s, char *f, int e);
    void emit_select(char *s, char *f, int ll);
    void emit_join(char *s, char *j1, int grp);
    void emit_join_tab(char *s, char tp);
    void emit_distinct();
    void emit_join();
    void emit_sort(char* s, int p);
    void emit_presort(char* s);
	void emit_display(char *s, char* sep);
	void emit_case();

%}

%union {
    int intval;
    double floatval;
    char *strval;
    int subtok;
}

%token <strval> FILENAME
%token <strval> NAME
%token <strval> STRING
%token <intval> INTNUM
%token <intval> DECIMAL1
%token <intval> BOOL1
%token <floatval> APPROXNUM
/* user @abc names */
%token <strval> USERVAR
/* operators and precedence levels */
%right ASSIGN
%right EQUAL
%left OR
%left XOR
%left AND
%left DISTINCT
%nonassoc IN IS LIKE REGEXP
%left NOT '!'
%left BETWEEN
%left <subtok> COMPARISON /* = <> < > <= >= <=> */
%left '|'
%left '&'
%left <subtok> SHIFT /* << >> */
%left '+' '-'
%left '*' '/' '%' MOD
%left '^'
%nonassoc UMINUS

%token OR
%token LOAD
%token STREAM
%token FILTER
%token BY
%token JOIN
%token STORE
%token INTO
%token GROUP
%token FROM
%token SELECT
%token AS
%token ORDER
%token ASC
%token DESC
%token COUNT
%token USING
%token SUM
%token AVG
%token MIN
%token MAX
%token LIMIT
%token ON
%token BINARY
%token DISTINCT
%token LEFT
%token RIGHT
%token OUTER
%token AND
%token SORT
%token SEGMENTS
%token PRESORTED
%token PARTITION
%token DELETE
%token INSERT
%token WHERE
%token DISPLAY
%token CASE
%token WHEN
%token THEN
%token ELSE
%token END
%token REFERENCES


%type <intval> load_list  opt_where opt_limit sort_def del_where
%type <intval> val_list opt_val_list expr_list opt_group_list join_list
%start stmt_list
%%


/* Grammar rules and actions follow. */

stmt_list:
stmt ';'
| stmt_list stmt ';'
;

stmt:
select_stmt { emit("STMT"); }
;
select_stmt:
NAME ASSIGN SELECT expr_list FROM NAME opt_group_list
{ emit_select($1, $6, $7); } ;
| NAME ASSIGN LOAD FILENAME USING '(' FILENAME ')' AS '(' load_list ')'
{  emit_load($1, $4, $11, $7); } ;
| NAME ASSIGN LOAD FILENAME BINARY AS '(' load_list ')'
{  emit_load_binary($1, $4, $8); } ;
| NAME ASSIGN FILTER NAME opt_where
{  emit_filter($1, $4);}
| NAME ASSIGN ORDER NAME BY opt_val_list
{  emit_order($1, $4, $6);}
| NAME ASSIGN SELECT expr_list FROM NAME join_list opt_group_list
{ emit_join($1,$6,$7); }
| STORE NAME INTO FILENAME USING '(' FILENAME ')' opt_limit
{ emit_store($2,$4,$7); }
| STORE NAME INTO FILENAME opt_limit BINARY sort_def
{ emit_store_binary($2,$4); }
| DELETE FROM NAME del_where
{  emit_delete($3);}
| INSERT INTO NAME SELECT expr_list FROM NAME
{  emit_insert($3, $7);}
| DISPLAY NAME USING '(' FILENAME ')' opt_limit
{  emit_display($2, $5);}
;

expr:
NAME { emit_name($1); }
| NAME '.' NAME { emit("FIELDNAME %s.%s", $1, $3); }
| USERVAR { emit("USERVAR %s", $1); }
| STRING { emit_string($1); }
| INTNUM { emit_number($1); }
| APPROXNUM { emit_float($1); }
| DECIMAL1 { emit_decimal($1); }
| BOOL1 { emit("BOOL %d", $1); }
| NAME '{' INTNUM '}' ':' NAME '(' INTNUM ')' REFERENCES NAME '(' INTNUM ')' { emit_varchar($1, $3, $6, $8, $11, $13);}
| NAME '{' INTNUM '}' ':' NAME '(' INTNUM ')' { emit_varchar($1, $3, $6, $8, "", 0);}
| NAME '{' INTNUM '}' ':' NAME REFERENCES NAME '(' INTNUM ')' { emit_var($1, $3, $6, $8, $10);}
| NAME '{' INTNUM '}' ':' NAME  { emit_var($1, $3, $6, "", 0);}
| NAME ASC { emit_var_asc($1);}
| NAME DESC { emit_var_desc($1);}
| COUNT '(' expr ')' { emit_count(); }
| SUM '(' expr ')' { emit_sum(); }
| AVG '(' expr ')' { emit_average(); }
| MIN '(' expr ')' { emit_min(); }
| MAX '(' expr ')' { emit_max(); }
| DISTINCT expr { emit_distinct(); }
| JOIN { emit_join(); }
;

expr:
expr '+' expr { emit_add(); }
| expr '-' expr { emit_minus(); }
| expr '*' expr { emit_mul(); }
| expr '/' expr { emit_div(); }
| expr '%' expr { emit("MOD"); }
| expr MOD expr { emit("MOD"); }
/*| '-' expr %prec UMINUS { emit("NEG"); }*/
| expr AND expr { emit_and(); }
| expr EQUAL expr { emit_eq(); }
| expr OR expr { emit_or(); }
| expr XOR expr { emit("XOR"); }
| expr SHIFT expr { emit("SHIFT %s", $2==1?"left":"right"); }
| NOT expr { emit("NOT"); }
| '!' expr { emit("NOT"); }
| expr COMPARISON expr { emit_cmp($2); }
/* recursive selects and comparisons thereto */
| expr COMPARISON '(' select_stmt ')' { emit("CMPSELECT %d", $2); }
| '(' expr ')' {emit("EXPR");}
| CASE WHEN expr THEN expr ELSE expr END { emit_case(); }
;

expr:
expr IS BOOL1 { emit("ISBOOL %d", $3); }
| expr IS NOT BOOL1 { emit("ISBOOL %d", $4); emit("NOT"); }
;



opt_group_list: { /* nil */
    $$ = 0;
}
| GROUP BY val_list { $$ = $3}


expr_list:
expr AS NAME { $$ = 1; emit_sel_name($3);}
| expr_list ',' expr AS NAME { $$ = $1 + 1; emit_sel_name($5);}
| '*' { emit_sel_name("*");}
;

load_list:
expr { $$ = 1; }
| load_list ',' expr {$$ = $1 + 1; }
;

val_list:
expr { $$ = 1; }
| expr ',' val_list { $$ = 1 + $3; }
;

opt_val_list: { /* nil */
    $$ = 0
}  | val_list;

opt_where:
BY expr { emit("FILTER BY"); };

del_where:
WHERE expr { emit("DELETE"); };


join_list:
JOIN NAME ON expr { $$ = 1; emit_join_tab($2, 'I');}
| LEFT JOIN NAME ON expr { $$ = 1; emit_join_tab($3, 'L');}
| RIGHT JOIN NAME ON expr { $$ = 1; emit_join_tab($3, 'R');}
| OUTER JOIN NAME ON expr { $$ = 1; emit_join_tab($3, 'O');}
| JOIN NAME ON expr join_list { $$ = 1; emit_join_tab($2, 'I'); };
| LEFT JOIN NAME ON expr join_list { $$ = 1; emit_join_tab($3, 'L'); };
| RIGHT JOIN NAME ON expr join_list { $$ = 1; emit_join_tab($3, 'R'); };
| OUTER JOIN NAME ON expr join_list { $$ = 1; emit_join_tab($3, 'O'); };

opt_limit: { /* nil */
    $$ = 0
}
     | LIMIT INTNUM { emit_limit($2); };

sort_def: { /* nil */
    $$ = 0
}
     |SORT SEGMENTS BY NAME { emit_sort($4, 0); };
|SORT SEGMENTS BY NAME PARTITION BY INTNUM { emit_sort($4, $7); };
|PRESORTED BY NAME { emit_presort($3); };

%%

#include "filter.h"
#include "select.h"
#include "merge.h"
#include "zone_map.h"
#include "atof.h"
#include "cudpp-2.1/include/cudpp_hash.h"
//#include "moderngpu-master/include/moderngpu.cuh"
#include "sstream"
#include "sorts.cu"

using namespace mgpu;
using namespace thrust::placeholders;

size_t int_size = sizeof(int_type);
size_t float_size = sizeof(float_type);

queue<string> namevars;
queue<string> typevars;
queue<int> sizevars;
queue<int> cols;
queue<string> references;
queue<int> references_nums;

queue<unsigned int> j_col_count;
unsigned int sel_count = 0;
unsigned int join_cnt = 0;
unsigned int distinct_cnt = 0;
unsigned int join_col_cnt = 0;
unsigned int join_tab_cnt = 0;
unsigned int tab_cnt = 0;
queue<string> op_join;
queue<char> join_type;
unsigned int partition_count;

unsigned int statement_count = 0;
map<string,unsigned int> stat;
map<unsigned int, unsigned int> join_and_cnt;
bool scan_state = 0;
unsigned int int_col_count;
CUDPPHandle theCudpp;
ContextPtr context;

void emit_multijoin(string s, string j1, string j2, unsigned int tab, char* res_name);
void filter_op(char *s, char *f, unsigned int segment);


void emit_name(char *name)
{
    op_type.push("NAME");
    op_value.push(name);
}

void emit_limit(int val)
{
    op_nums.push(val);
}


void emit_string(char *str)
{   // remove the float_type quotes
    string sss(str,1, strlen(str)-2);
    op_type.push("STRING");
    op_value.push(sss);
}


void emit_number(int_type val)
{
    op_type.push("NUMBER");
    op_nums.push(val);
}

void emit_float(float_type val)
{
    op_type.push("FLOAT");
    op_nums_f.push(val);
}

void emit_decimal(float_type val)
{
    op_type.push("DECIMAL");
    op_nums_f.push(val);
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

void emit_join()
{
    
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

void emit(char *s, ...)
{


}

void emit_var(char *s, int c, char *f, char* ref, int ref_num)
{
    namevars.push(s);
    typevars.push(f);
    sizevars.push(0);
    cols.push(c);
	references.push(ref);
	references_nums.push(ref_num);	
}

void emit_var_asc(char *s)
{
    op_type.push(s);
    op_value.push("ASC");
}

void emit_var_desc(char *s)
{
    op_type.push(s);
    op_value.push("DESC");
}

void emit_sort(char *s, int p)
{
    op_sort.push(s);
    partition_count = p;
}

void emit_presort(char *s)
{
    op_presort.push(s);
}


void emit_varchar(char *s, int c, char *f, int d, char *ref, int ref_num)
{
    namevars.push(s);
    typevars.push(f);
    sizevars.push(d);
    cols.push(c);
	references.push(ref);
	references_nums.push(ref_num);
}

void emit_sel_name(char *s)
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

void emit_join_tab(char *s, char tp)
{
    op_join.push(s);
    join_tab_cnt++;
    join_type.push(tp);
};


void order_inplace(CudaSet* a, stack<string> exe_type, set<string> field_names)
{

    unsigned int sz = a->mRecCount;
    thrust::device_ptr<unsigned int> permutation = thrust::device_malloc<unsigned int>(sz);
    thrust::sequence(permutation, permutation+sz,0,1);

    unsigned int* raw_ptr = thrust::raw_pointer_cast(permutation);
    void* temp;
    // find the largest mRecSize of all data sources exe_type.top()
    size_t maxSize = 0;
    for (set<string>::iterator it=field_names.begin(); it!=field_names.end(); ++it) {
        CudaSet *t = varNames[setMap[*it]];
        if(t->mRecCount > maxSize)
            maxSize = t->mRecCount;
    };
	
    CUDA_SAFE_CALL(cudaMalloc((void **) &temp, maxSize*max_char(a, field_names)));
    unsigned int str_count = 0;


    for(int i=0; !exe_type.empty(); ++i, exe_type.pop()) {
        int colInd = (a->columnNames).find(exe_type.top())->second;
        if (a->type[colInd] == 0)
            update_permutation(a->d_columns_int[a->type_index[colInd]], raw_ptr, sz, "ASC", (int_type*)temp);
        else if (a->type[colInd] == 1)
            update_permutation(a->d_columns_float[a->type_index[colInd]], raw_ptr, sz,"ASC", (float_type*)temp);
        else {
            // use int col int_col_count
            update_permutation(a->d_columns_int[int_col_count+str_count], raw_ptr, sz, "ASC", (int_type*)temp);
            str_count++;
        };
    };
    str_count = 0;

    for (set<string>::iterator it=field_names.begin(); it!=field_names.end(); ++it) {
        int i = a->columnNames[*it];
        if (a->type[i] == 0) {
            apply_permutation(a->d_columns_int[a->type_index[i]], raw_ptr, sz, (int_type*)temp);
        }
        else if (a->type[i] == 1)
            apply_permutation(a->d_columns_float[a->type_index[i]], raw_ptr, sz, (float_type*)temp);
        else {
            apply_permutation_char(a->d_columns_char[a->type_index[i]], raw_ptr, sz, (char*)temp, a->char_size[a->type_index[i]]);
            apply_permutation(a->d_columns_int[int_col_count + str_count], raw_ptr, sz, (int_type*)temp);
            str_count++;
        };
    };
    cudaFree(temp);
    thrust::device_free(permutation);
}

bool check_star_join(string j1)
{
    queue<string> op_vals(op_value);

    for(unsigned int i=0; i < sel_count; i++) {
        op_vals.pop();
        op_vals.pop();
    };

    if(join_tab_cnt > 1) {

        while(op_vals.size()) {
            if (varNames[j1]->columnNames.find(op_vals.front()) != varNames[j1]->columnNames.end()) {
                op_vals.pop();
                op_vals.pop();
            }
            else {
                return 0;
            };
        };
        return 1;
    }
    else
        return 0;
}

std::ostream &operator<<(std::ostream &os, const uint2 &x)
{
    os << x.x << ", " << x.y;
    return os;
}

void star_join(char *s, string j1)
{
    //need to copy to gpu all dimension keys, sort the dimension tables and
    //build an array of hash tables for the dimension tables
    CUDPPResult result;
    map<string,bool> already_copied;

    CudaSet* left = varNames.find(j1)->second;

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

    CudaSet* c = new CudaSet(op_sel_s, op_sel_s_as);


    CUDPPHandle* hash_table_handle = new CUDPPHandle[join_tab_cnt];
    CUDPPHashTableConfig config;
    config.type = CUDPP_MULTIVALUE_HASH_TABLE;
    config.space_usage = 1.1f;
    bool str_join = 0;
    string f1, f2;
    unsigned int colInd1, tt = 0;
    bool v64bit = 0;
    unsigned int colInd2;
    map<string, unsigned int> tab_map;
    map<string, string> var_map;

    for(unsigned int i = 0; i < join_tab_cnt; i++) {

        f1 = op_g.front();
        op_g.pop();
        f2 = op_g.front();
        op_g.pop();

        queue<string> op_jj(op_join);
        for(unsigned int z = 0; z < (join_tab_cnt-1) - i; z++)
            op_jj.pop();

        size_t rcount;
        queue<string> op_vd(op_g);
        queue<string> op_alt(op_sel);
        unsigned int jc = join_col_cnt;
        while(jc) {
            jc--;
            op_vd.pop();
            op_alt.push(op_vd.front());
            op_vd.pop();
        };

        tab_map[op_jj.front()] = i;
        var_map[op_jj.front()] = f1;

        CudaSet* right = varNames.find(op_jj.front())->second;
        colInd2 = right->columnNames[f2];

        queue<string> first;
        first.push(f2);
        size_t cnt_r = load_queue(first, right, str_join, "", rcount, 0, right->segCount); // put all used columns into GPU

        queue<string> second;
        while(!op_alt.empty()) {
            if(f2.compare(op_alt.front()) != 0 && (right->columnNames.find(op_alt.front()) !=  right->columnNames.end())) {
                second.push(op_alt.front());
            };
            op_alt.pop();
        };
        if(!second.empty())
            load_queue(second, right, str_join, "", rcount, 0, right->segCount, 0,0); // put all used columns into GPU

        bool sorted = thrust::is_sorted(right->d_columns_int[right->type_index[colInd2]].begin(), right->d_columns_int[right->type_index[colInd2]].begin() + cnt_r);


        if(!sorted) {

            queue<string> ss(op_sel);
            thrust::device_vector<unsigned int> v(cnt_r);
            thrust::sequence(v.begin(),v.end(),0,1);

            size_t max_c = max_char(right);
            size_t mm;
            if(max_c > 8)
                mm = (max_c/8) + 1;
            else
                mm = 1;

            thrust::device_ptr<int_type> d_tmp = thrust::device_malloc<int_type>(cnt_r*mm);
            thrust::sort_by_key(right->d_columns_int[right->type_index[colInd2]].begin(), right->d_columns_int[right->type_index[colInd2]].begin() + cnt_r, v.begin());

            unsigned int i;
            while(!ss.empty()) {
                if (right->columnNames.find(ss.front()) != right->columnNames.end()) {
                    i = right->columnNames[ss.front()];

                    if(i != colInd2) {
                        if(right->type[i] == 0) {
                            thrust::gather(v.begin(), v.end(), right->d_columns_int[right->type_index[i]].begin(), d_tmp);
                            thrust::copy(d_tmp, d_tmp + cnt_r, right->d_columns_int[right->type_index[i]].begin());
                        }
                        else if(right->type[i] == 1) {
                            thrust::gather(v.begin(), v.end(), right->d_columns_float[right->type_index[i]].begin(), d_tmp);
                            thrust::copy(d_tmp, d_tmp + cnt_r, right->d_columns_float[right->type_index[i]].begin());
                        }
                        else {
                            str_gather(thrust::raw_pointer_cast(v.data()), cnt_r, (void*)right->d_columns_char[right->type_index[i]], (void*) thrust::raw_pointer_cast(d_tmp), right->char_size[right->type_index[i]]);
                            cudaMemcpy( (void*)right->d_columns_char[right->type_index[i]], (void*) thrust::raw_pointer_cast(d_tmp), cnt_r*right->char_size[right->type_index[i]], cudaMemcpyDeviceToDevice);
                        };
                    };
                };
                ss.pop();
            };
            thrust::device_free(d_tmp);
        };

        if(right->d_columns_int[right->type_index[colInd2]][cnt_r-1] > std::numeric_limits<unsigned int>::max())
            v64bit = 1;

        colInd1 = (left->columnNames).find(f1)->second;
        if (left->type[colInd1]  == 2) {
            cout << "Joins are not yet supported in star joins" << endl;
            exit(0);
        }
        else {
            queue<string> cc;
            cc.push(f1);
            allocColumns(left, cc);
        };

        config.kInputSize = cnt_r;
        result = cudppHashTable(theCudpp, &hash_table_handle[i], &config);

        if (result == CUDPP_SUCCESS && verbose)
            cout << "hash tables created " << getFreeMem() << endl;


        if(left->maxRecs > rcount)
            tt = left->maxRecs;
        else {
            if (rcount > tt)
                tt = rcount;
        };
        thrust::device_vector<unsigned int> d_rr(tt);
        thrust::device_vector<unsigned int> v(cnt_r);
        thrust::sequence(v.begin(),v.end(),0,1);

        thrust::copy(right->d_columns_int[right->type_index[colInd2]].begin(), right->d_columns_int[right->type_index[colInd2]].begin() + cnt_r,
                     d_rr.begin());
        result = cudppHashInsert(hash_table_handle[i], thrust::raw_pointer_cast(d_rr.data()),
                                 thrust::raw_pointer_cast(v.data()), cnt_r);

        if (result == CUDPP_SUCCESS && verbose)
            cout << "hash table inserted " << getFreeMem() << endl;

    };

    thrust::device_ptr<unsigned int> d_r = thrust::device_malloc<unsigned int>(tt);
    thrust::device_vector<unsigned int> d_s(tt);

    thrust::device_ptr<uint2> res = thrust::device_malloc<uint2>(left->maxRecs);

    thrust::device_vector<unsigned int> d_res1;
    thrust::device_vector<unsigned int> d_res2;

    thrust::device_vector<bool> d_star(left->maxRecs);

    unsigned int res_count, tot_count = 0, offset = 0;
    size_t cnt_l, k = 0;
    queue<string> lc;


    for (unsigned int i = 0; i < left->segCount; i++) {

		if(verbose)
			cout << "segment " << i << " " << getFreeMem() <<  '\xd';
        thrust::sequence(d_star.begin(), d_star.end(),1,0);

        //for every hash table
        queue<string> op_g1(op_value);
        for(unsigned int z = 0; z < join_tab_cnt; z++) {

            cnt_l = 0;
            f1 = op_g1.front();
            op_g1.pop();
            f2 = op_g1.front();
            op_g1.pop();

            while(lc.size())
                lc.pop();
            lc.push(f1);
            copyColumns(left, lc, i, cnt_l);
            already_copied[f1] = 1;

            cnt_l = left->mRecCount;

            queue<string> op_jj(op_join);
            for(unsigned int j = 0; j < (join_tab_cnt-1) - z; j++) {
                op_jj.pop();
            };


            if (cnt_l) {

                unsigned int idx = left->type_index[left->columnNames[lc.front()]];
                //cout << "left idx " << idx << endl;
                //cout << "right col " << op_jj.front() << endl;
                CudaSet* right = varNames.find(op_jj.front())->second;
                colInd2 = right->columnNames[f2];

                thrust::copy(left->d_columns_int[idx].begin(), left->d_columns_int[idx].begin() + cnt_l, d_r);

                result = cudppHashRetrieve(hash_table_handle[z], thrust::raw_pointer_cast(d_r),
                                           thrust::raw_pointer_cast(res), cnt_l);
                if (result != CUDPP_SUCCESS && verbose)
                    cout << "Failed retrieve " << endl;

                uint2 rr = thrust::reduce(res, res+cnt_l, make_uint2(0,0), Uint2Sum());


                res_count = rr.y;
                d_res1.resize(res_count);
                d_res2.resize(res_count);
                //cout << "res cnt of " << f2 << " = " << res_count << endl;

                if(res_count) {
                    thrust::counting_iterator<unsigned int> begin(0);
                    uint2_split ff(thrust::raw_pointer_cast(res),thrust::raw_pointer_cast(d_r));
                    thrust::for_each(begin, begin + cnt_l, ff);

                    if(!v64bit) {
                        thrust::transform(d_star.begin(), d_star.begin() + cnt_l, d_r, d_star.begin(), thrust::logical_and<bool>());
                    };

                    thrust::exclusive_scan(d_r, d_r+cnt_l, d_r );  // addresses
                    join_functor1 ff1(thrust::raw_pointer_cast(res),
                                      thrust::raw_pointer_cast(d_r),
                                      thrust::raw_pointer_cast(d_res1.data()),
                                      thrust::raw_pointer_cast(d_res2.data()));
                    thrust::for_each(begin, begin + cnt_l, ff1);

                    if(v64bit) {// need to check the upper 32 bits
                        thrust::device_ptr<bool> d_add = thrust::device_malloc<bool>(d_res1.size());
                        thrust::permutation_iterator<ElementIterator_int,IndexIterator> iter_left(left->d_columns_int[idx].begin(), d_res1.begin());
                        thrust::permutation_iterator<ElementIterator_int,IndexIterator> iter_right(right->d_columns_int[right->type_index[colInd2]].begin(), d_res2.begin());
                        thrust::transform(iter_left, iter_left+d_res2.size(), iter_right, d_add, int_upper_equal_to());
                        unsigned int new_cnt = thrust::count(d_add, d_add+d_res1.size(), 1);
                        if(new_cnt == 0)
                            break;
                        thrust::stable_partition(d_res1.begin(), d_res1.begin() + d_res2.size(), d_add, thrust::identity<unsigned int>());
                        thrust::stable_partition(d_res2.begin(), d_res2.end(), d_add, thrust::identity<unsigned int>());

                        thrust::transform(d_star.begin(), d_star.end(), d_add, d_star.begin(), thrust::logical_and<bool>());
                        thrust::device_free(d_add);
                        d_res2.resize(new_cnt);
                        d_res1.resize(new_cnt);

                    };
                }
                else {
                    thrust::sequence(d_star.begin(), d_star.end(),0,0);
                    break;
                };
            };
        };
        // if our bool vector is not all zeroes then load all left columns and also get indexes and gather values
        // from right hash tables
        unsigned int n_cnt = thrust::count(d_star.begin(), d_star.begin() + cnt_l, 1);
        //cout << "Star join result count " << n_cnt << endl;
        tot_count = tot_count + n_cnt;
        queue<string> cc;
        if(n_cnt) { //gather

            offset = c->mRecCount;
            if(i == 0 && left->segCount != 1) {
                c->reserve(n_cnt*(left->segCount+1));
            };
            c->resize_join(n_cnt);
            queue<string> op_sel1(op_sel_s);
            unsigned int colInd, c_colInd;

            while(!op_sel1.empty()) {


                while(!cc.empty())
                    cc.pop();

                cc.push(op_sel1.front());
                if(c->columnNames.find(op_sel1.front()) != c->columnNames.end()) {
                    c_colInd = c->columnNames[op_sel1.front()];
                };

                if(left->columnNames.find(op_sel1.front()) !=  left->columnNames.end()) {
                    // copy field's segment to device, gather it and copy to the host
                    colInd = left->columnNames[op_sel1.front()];

                    if(already_copied.count(op_sel1.front()) == 0) {
                        allocColumns(left, cc);
                        copyColumns(left, cc, i, k);
                    };

                    //gather
                    if(left->type[colInd] == 0) {
                        thrust::device_ptr<int_type> d_tmp = thrust::device_malloc<int_type>(n_cnt);
                        thrust::copy_if(left->d_columns_int[left->type_index[colInd]].begin(), left->d_columns_int[left->type_index[colInd]].begin() + cnt_l,
                                        d_star.begin(), d_tmp, thrust::identity<bool>());
                        thrust::copy(d_tmp, d_tmp + n_cnt, c->h_columns_int[c->type_index[c_colInd]].begin() + offset);
                        thrust::device_free(d_tmp);
                    }
                    else if(left->type[colInd] == 1) {
                        thrust::device_ptr<float_type> d_tmp = thrust::device_malloc<float_type>(n_cnt);
                        thrust::copy_if(left->d_columns_float[left->type_index[colInd]].begin(), left->d_columns_float[left->type_index[colInd]].begin() + cnt_l,
                                        d_star.begin(), d_tmp, thrust::identity<bool>());
                        thrust::copy(d_tmp, d_tmp + n_cnt, c->h_columns_float[c->type_index[c_colInd]].begin() + offset);
                        thrust::device_free(d_tmp);
                    }
                    else { //strings
                        thrust::device_ptr<char> d_tmp = thrust::device_malloc<char>(n_cnt*left->char_size[left->type_index[colInd]]);

                        thrust::device_ptr<bool> d_g(thrust::raw_pointer_cast(d_star.data()));

                        str_copy_if(left->d_columns_char[left->type_index[colInd]], cnt_l, thrust::raw_pointer_cast(d_tmp),
                                    d_g, c->char_size[c->type_index[c_colInd]]);
                        cudaMemcpy( (void*)&c->h_columns_char[c->type_index[c_colInd]][offset*c->char_size[c->type_index[c_colInd]]], (void*) thrust::raw_pointer_cast(d_tmp),
                                    c->char_size[c->type_index[c_colInd]] * n_cnt, cudaMemcpyDeviceToHost);
                        thrust::device_free(d_tmp);
                    }
                    //left->deAllocColumnOnDevice(colInd);

                }
                else {
                    string right_tab_name;
                    queue<string> op_j(op_join);
                    while(!op_j.empty()) {
                        if(varNames[op_j.front()]->columnNames.count(op_sel1.front())) {
                            right_tab_name = op_j.front();
                            break;
                        };
                        op_j.pop();
                    };

                    colInd = left->columnNames[var_map[right_tab_name]];
                    CudaSet* right = varNames[right_tab_name];
                    unsigned int r_colInd = right->columnNames[op_sel1.front()];

                    while(!cc.empty())
                        cc.pop();
                    cc.push(var_map[right_tab_name]);

                    if(c->columnNames.find(op_sel1.front()) != c->columnNames.end()) {
                        c_colInd = c->columnNames[op_sel1.front()];
                    };

                    if(already_copied.count(var_map[right_tab_name]) == 0) {
                        allocColumns(left, cc);
                        copyColumns(left, cc, i, k);
                    };

                    thrust::device_ptr<int_type> d_t = thrust::device_malloc<int_type>(n_cnt);
                    thrust::copy_if(left->d_columns_int[left->type_index[colInd]].begin(), left->d_columns_int[left->type_index[colInd]].begin() + cnt_l,
                                    d_star.begin(), d_t, thrust::identity<bool>());

                    // get the values from hash table
                    unsigned int hash_ind = tab_map[right_tab_name];

                    thrust::copy(d_t, d_t + n_cnt, d_r);
                    thrust::device_free(d_t);
                    result = cudppHashRetrieve(hash_table_handle[hash_ind], thrust::raw_pointer_cast(d_r),
                                               thrust::raw_pointer_cast(res), n_cnt);
                    if (result != CUDPP_SUCCESS && verbose)
                        cout << "Failed retrieve " << endl;

                    thrust::counting_iterator<unsigned int> begin(0);
                    uint2_split_left ff(thrust::raw_pointer_cast(res),thrust::raw_pointer_cast(d_s.data()));
                    thrust::for_each(begin, begin + n_cnt, ff);

                    //gather
                    if(right->type[r_colInd] == 0) {
                        thrust::permutation_iterator<ElementIterator_int,IndexIterator> iter(right->d_columns_int[right->type_index[r_colInd]].begin(), d_s.begin());
                        thrust::copy(iter, iter + n_cnt, c->h_columns_int[c->type_index[c_colInd]].begin() + offset);
                    }
                    else if(right->type[r_colInd] == 1) {
                        thrust::permutation_iterator<ElementIterator_float,IndexIterator> iter(right->d_columns_float[right->type_index[r_colInd]].begin(), d_s.begin());
                        thrust::copy(iter, iter + n_cnt, c->h_columns_float[c->type_index[c_colInd]].begin() + offset);
                    }
                    else { //strings
                        thrust::device_ptr<char> d_tmp1 = thrust::device_malloc<char>(n_cnt*right->char_size[right->type_index[r_colInd]]);
                        str_gather(thrust::raw_pointer_cast(d_s.data()), n_cnt, (void*)right->d_columns_char[right->type_index[r_colInd]],
                                   (void*) thrust::raw_pointer_cast(d_tmp1), right->char_size[right->type_index[r_colInd]]);
                        cudaMemcpy( (void*)(c->h_columns_char[c->type_index[c_colInd]] + offset*c->char_size[c->type_index[c_colInd]]), (void*) thrust::raw_pointer_cast(d_tmp1),
                                    c->char_size[c->type_index[c_colInd]] * n_cnt, cudaMemcpyDeviceToHost);
                        thrust::device_free(d_tmp1);
                    }
                }
                op_sel1.pop();
            };
        };

    };

    while(!op_join.empty()) {
        varNames[op_join.front()]->deAllocOnDevice();
        op_join.pop();
    };
    left->deAllocOnDevice();

    for(unsigned int i = 0; i < join_tab_cnt; i++) {
        cudppDestroyHashTable(theCudpp, hash_table_handle[i]);
    };
    delete [] hash_table_handle;

    varNames[s] = c;
    c->mRecCount = tot_count;	
    c->maxRecs = tot_count;
	
	if(verbose)
		cout << endl << "join count " << tot_count << endl;
    for (map<string,unsigned int>::iterator it=c->columnNames.begin() ; it != c->columnNames.end(); ++it ) {
        setMap[(*it).first] = s;
    };
};


void emit_join(char *s, char *j1, int grp)
{

    statement_count++;
    if (scan_state == 0) {
        if (stat.find(j1) == stat.end()) {
            cout << "Join : couldn't find variable " << j1 << endl;
            exit(1);
        };
        if (stat.find(op_join.front()) == stat.end()) {
            cout << "Join : couldn't find variable " << op_join.front() << endl;
            exit(1);
        };
        stat[s] = statement_count;
        stat[j1] = statement_count;
        while(!op_join.empty()) {
            stat[op_join.front()] = statement_count;
            op_join.pop();
        };
        return;
    };


    queue<string> op_m(op_value);

    if(check_star_join(j1) && verbose) {
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
                    tab_name = s + int_to_string(i);

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
                    j2 = s + int_to_string(i-1);
                };
                emit_multijoin(tab_name, j, j2, i, s);
                op_value = op_m;
            };
        }
        else {
            string j2 = op_join.front();
            op_join.pop();
            emit_multijoin(s, j1, j2, 1, s);
        };
    };

    clean_queues();

    if(stat[s] == statement_count) {
        varNames[s]->free();
        varNames.erase(s);
    };

    /*if(stat[j1] == statement_count) {
        varNames[j1]->free();
        varNames.erase(j1);
    };
    */

    if(op_join.size()) {
        if(stat[op_join.front()] == statement_count && op_join.front().compare(j1) != 0) {
            varNames[op_join.front()]->free();
            varNames.erase(op_join.front());
        };
    };

}



void emit_multijoin(string s, string j1, string j2, unsigned int tab, char* res_name)
{

    if(varNames.find(j1) == varNames.end() || varNames.find(j2) == varNames.end()) {
        clean_queues();
        if(varNames.find(j1) == varNames.end())
            cout << "Couldn't find j1 " << j1 << endl;
        if(varNames.find(j2) == varNames.end())
            cout << "Couldn't find j2 " << j2 << endl;

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
		cout << "JOIN " << s <<  " " <<  f1 << " " << f2 << " " << getFreeMem() <<  endl;

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

    unsigned int colInd1, colInd2;
    string tmpstr;
    if (left->columnNames.find(f1) != left->columnNames.end()) {
        colInd1 = (left->columnNames).find(f1)->second;
        if (right->columnNames.find(f2) != right->columnNames.end()) {
            colInd2 = (right->columnNames).find(f2)->second;
        }
        else {
            cout << "Couldn't find column " << f2 << endl;
            exit(0);
        };
    }
    else if (right->columnNames.find(f1) != right->columnNames.end()) {
        colInd2 = (right->columnNames).find(f1)->second;
        tmpstr = f1;
        f1 = f2;
        if (left->columnNames.find(f2) != left->columnNames.end()) {
            colInd1 = (left->columnNames).find(f2)->second;
            f2 = tmpstr;
        }
        else {
            cout << "Couldn't find column " << f2 << endl;
            exit(0);
        };
    }
    else {
        cout << "Couldn't find column " << f1 << endl;
        exit(0);
    };


    if (!((left->type[colInd1] == 0 && right->type[colInd2]  == 0) || (left->type[colInd1] == 2 && right->type[colInd2]  == 2)
            || (left->type[colInd1] == 1 && right->type[colInd2]  == 1 && left->decimal[colInd1] && right->decimal[colInd2]))) {
        cout << "Joins on floats are not supported " << endl;
        exit(0);
    };


    bool decimal_join = 0;
    if (left->type[colInd1] == 1 && right->type[colInd2]  == 1)
        decimal_join = 1;

    set<string> field_names;
    stack<string> exe_type;
    exe_type.push(f2);
    field_names.insert(f2);

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

    bool str_join = 0;    
    size_t rcount = 0, cnt_r;
    //need to sort the entire dataset by a key before loading segment by segment
	unsigned int r_parts = calc_right_partition(left, right, op_sel);
	//r_parts = 1;
	unsigned int start_part = 0;
	sort_right(right, colInd2, f2, op_g, op_sel, decimal_join, str_join, rcount); //sort right 
    queue<string> cc;
	
    if (left->type[colInd1]  == 2) {
        left->d_columns_int.push_back(thrust::device_vector<int_type>());
    }
    else {
        cc.push(f1);
        allocColumns(left, cc);
    };


    left->hostRecCount = left->mRecCount;

    size_t cnt_l, res_count, tot_count = 0, offset = 0, k = 0;
    queue<string> lc(cc);
    thrust::device_vector<int> p_tmp;
    thrust::device_vector<unsigned int> v_l(left->maxRecs);
    MGPU_MEM(int) aIndicesDevice, bIndicesDevice;
	std::vector<int> j_data;

	while(start_part != right->segCount) {

	    bool rsz = 1;
	    //if (start_part != 0)
		//	rsz = 0;
		right->deAllocOnDevice();
		
		if(start_part + r_parts >= right->segCount) {
			cnt_r = load_right(right, colInd2, f2, op_g1, op_sel, op_alt, decimal_join, str_join, rcount, start_part, right->segCount, rsz);
			start_part = right->segCount;
		}
		else {
			cnt_r = load_right(right, colInd2, f2, op_g1, op_sel, op_alt, decimal_join, str_join, rcount, start_part, start_part+r_parts, rsz);
			start_part = start_part+r_parts;			
		};

    for (unsigned int i = 0; i < left->segCount; i++) {

		if(verbose)
			cout << "segment " << i <<  '\xd';	
			//cout << "segment " << i <<  endl;	
		j_data.clear();		
			
		/*for (set<unsigned int>::iterator it = left->ref_joins[colInd1][i].begin(); it != left->ref_joins[colInd1][i].end(); it++) {
			cout << "seg match " << *it << endl;
		};
		
		for (set<unsigned int>::iterator it = right->orig_segs[left->ref_sets[colInd1]].begin(); it != right->orig_segs[left->ref_sets[colInd1]].end(); it++) {
			cout << "right segs " << *it << endl;
		};
		*/
		
		if(left->ref_joins[colInd1][i].size() && right->orig_segs[left->ref_sets[colInd1]].size()) {
			set_intersection(left->ref_joins[colInd1][i].begin(),left->ref_joins[colInd1][i].end(),
							 right->orig_segs[left->ref_sets[colInd1]].begin(), right->orig_segs[left->ref_sets[colInd1]].end(),
							 std::back_inserter(j_data));
			if(j_data.empty()) 
				continue;
			//cout << "no need of a join " << endl;
		};	

	
		//std::clock_t start2 = std::clock();		
		        
        cnt_l = 0;
        if (left->type[colInd1]  != 2) {
            copyColumns(left, lc, i, cnt_l);			
        }
        else {
            left->add_hashed_strings(f1, i, left->d_columns_int.size()-1);
        };
		
		//cout << "join1 " << cnt_l << ":" << cnt_r << " " << join_type.front() << " " << left->mRecCount << endl;
		
        if(!left->filtered) {
            if (left->type[colInd1]  != 2)
                cnt_l = left->mRecCount;
            else
                cnt_l = left->d_columns_int[left->d_columns_int.size()-1].size();
        }
        else {
            cnt_l = left->mRecCount;
        };

			
        if (cnt_l) {

            unsigned int idx;
            if(!str_join)
                idx = left->type_index[colInd1];
            else
                idx = left->d_columns_int.size()-1;

            // sort the left index column, save the permutation vector, it might be needed later

            thrust::device_ptr<int_type> d_col((int_type*)thrust::raw_pointer_cast(left->d_columns_int[idx].data()));
            thrust::sequence(v_l.begin(), v_l.begin() + cnt_l,0,1);

            bool do_sort = 1;
            if(!left->sorted_fields.empty()) {
                if(left->sorted_fields.front() == left->cols[idx]) {
                    do_sort = 0;
                };
            }
            if(do_sort)
                thrust::sort_by_key(d_col, d_col + cnt_l, v_l.begin());
				
            //cout << "join " << cnt_l << ":" << cnt_r << " " << join_type.front() << endl;
            //cout << "MIN MAX " << left->d_columns_int[idx][0] << " - " << left->d_columns_int[idx][cnt_l-1] << " : " << right->d_columns_int[right->type_index[colInd2]][0] << "-" << right->d_columns_int[right->type_index[colInd2]][cnt_r-1] << endl;
				
			
			if (left->d_columns_int[left->type_index[colInd1]][0] > right->d_columns_int[right->type_index[colInd2]][cnt_r-1] ||
				left->d_columns_int[left->type_index[colInd1]][cnt_l-1] < right->d_columns_int[right->type_index[colInd2]][0]) {
				continue;
			};	
			
            char join_kind = join_type.front();

            if (left->type[colInd1] == 2) {
				thrust::device_ptr<int_type> d_col_r((int_type*)thrust::raw_pointer_cast(right->d_columns_int[right->type_index[colInd2]].data()));
                res_count = RelationalJoin<MgpuJoinKindInner>(thrust::raw_pointer_cast(d_col), cnt_l,
                            thrust::raw_pointer_cast(d_col_r), cnt_r,
                            &aIndicesDevice, &bIndicesDevice,
                            mgpu::less<unsigned long long int>(), *context);

            }
            else {

                if (join_kind == 'I')
                    res_count = RelationalJoin<MgpuJoinKindInner>(thrust::raw_pointer_cast(left->d_columns_int[idx].data()), cnt_l,
                                thrust::raw_pointer_cast(right->d_columns_int[right->type_index[colInd2]].data()), cnt_r,
                                &aIndicesDevice, &bIndicesDevice,
                                mgpu::less<int_type>(), *context);
                else if(join_kind == 'L')
                    res_count = RelationalJoin<MgpuJoinKindLeft>(thrust::raw_pointer_cast(left->d_columns_int[idx].data()), cnt_l,
                                thrust::raw_pointer_cast(right->d_columns_int[right->type_index[colInd2]].data()), cnt_r,
                                &aIndicesDevice, &bIndicesDevice,
                                mgpu::less<int_type>(), *context);
                else if(join_kind == 'R')
                    res_count = RelationalJoin<MgpuJoinKindRight>(thrust::raw_pointer_cast(left->d_columns_int[idx].data()), cnt_l,
                                thrust::raw_pointer_cast(right->d_columns_int[right->type_index[colInd2]].data()), cnt_r,
                                &aIndicesDevice, &bIndicesDevice,
                                mgpu::less<int_type>(), *context);
                else if(join_kind == 'O')
                    res_count = RelationalJoin<MgpuJoinKindOuter>(thrust::raw_pointer_cast(left->d_columns_int[idx].data()), cnt_l,
                                thrust::raw_pointer_cast(right->d_columns_int[right->type_index[colInd2]].data()), cnt_r,
                                &aIndicesDevice, &bIndicesDevice,
                                mgpu::less<int_type>(), *context);
            };
			
			//cout << "RES " << res_count << " seg " << i << endl;


            int* r1 = aIndicesDevice->get();
            thrust::device_ptr<int> d_res1((int*)r1);
            int* r2 = bIndicesDevice->get();
            thrust::device_ptr<int> d_res2((int*)r2);

            if(res_count) {
                p_tmp.resize(res_count);
                thrust::sequence(p_tmp.begin(), p_tmp.end(),-1);
                thrust::gather_if(d_res1, d_res1+res_count, d_res1, v_l.begin(), p_tmp.begin(), is_positive());
            };


            // check if the join is a multicolumn join
            unsigned int mul_cnt = join_and_cnt[join_tab_cnt - tab];
            while(mul_cnt) {

                mul_cnt--;
                string f3 = op_g.front();
                op_g.pop();
                string f4 = op_g.front();
                op_g.pop();

                //cout << "ADDITIONAL COL JOIN " << f3 << " " << f4 << " " << getFreeMem() << endl;

                queue<string> rc;
                rc.push(f3);

                allocColumns(left, rc);
                left->hostRecCount = left->mRecCount;
                size_t offset = 0;
                copyColumns(left, rc, i, offset, 0, 0);
                rc.pop();

                void* temp;
                CUDA_SAFE_CALL(cudaMalloc((void **) &temp, res_count*float_size));
                void* temp1;
                CUDA_SAFE_CALL(cudaMalloc((void **) &temp1, res_count*float_size));
                cudaMemset(temp,0,res_count);
                cudaMemset(temp1,0,res_count);


                if (res_count) {
                    unsigned int colInd3 = (left->columnNames).find(f3)->second;
                    unsigned int colInd4 = (right->columnNames).find(f4)->second;
                    thrust::device_ptr<bool> d_add = thrust::device_malloc<bool>(res_count);

                    if (left->type[colInd3] == 1 && right->type[colInd4]  == 1) {

                        if(right->d_columns_float[right->type_index[colInd4]].size() == 0)
                            load_queue(rc, right, 0, f4, rcount, 0, right->segCount, 0, 0);

                        thrust::device_ptr<float_type> d_tmp((float_type*)temp);
                        thrust::device_ptr<float_type> d_tmp1((float_type*)temp1);
                        thrust::gather_if(p_tmp.begin(), p_tmp.end(), p_tmp.begin(), left->d_columns_float[left->type_index[colInd3]].begin(), d_tmp, is_positive());
                        thrust::gather_if(d_res2, d_res2+res_count, d_res2, right->d_columns_float[right->type_index[colInd4]].begin(), d_tmp1, is_positive());
                        thrust::transform(d_tmp, d_tmp+res_count, d_tmp1, d_add, float_equal_to());
                    }
                    else {
                        if(right->d_columns_int[right->type_index[colInd4]].size() == 0) {
                            load_queue(rc, right, 0, f4, rcount, 0, right->segCount, 0, 0);
                        };
                        thrust::device_ptr<int_type> d_tmp((int_type*)temp);
                        thrust::device_ptr<int_type> d_tmp1((int_type*)temp1);
                        thrust::gather_if(p_tmp.begin(), p_tmp.end(), p_tmp.begin(), left->d_columns_int[left->type_index[colInd3]].begin(), d_tmp, is_positive());
                        thrust::gather_if(d_res2, d_res2+res_count, d_res2, right->d_columns_int[right->type_index[colInd4]].begin(), d_tmp1, is_positive());
                        thrust::transform(d_tmp, d_tmp+res_count, d_tmp1, d_add, thrust::equal_to<int_type>());
                    };

                    if (join_kind == 'I') {  // result count changes only in case of an inner join
                        unsigned int new_cnt = thrust::count(d_add, d_add+res_count, 1);
                        thrust::stable_partition(d_res2, d_res2 + res_count, d_add, thrust::identity<unsigned int>());
                        thrust::stable_partition(p_tmp.begin(), p_tmp.end(), d_add, thrust::identity<unsigned int>());
                        thrust::device_free(d_add);
                        res_count = new_cnt;
                    }
                    else { //otherwise we consider it a valid left join result with non-nulls on the left side and nulls on the right side
                        thrust::transform(d_res2, d_res2 + res_count, d_add , d_res2, set_minus());
                    };
                };
                cudaFree(temp);
                cudaFree(temp1);
            };
			//if(verbose)
			//	cout << "tot res " << res_count << endl;

            tot_count = tot_count + res_count;

            if(res_count) {
			
				for (map<string, set<unsigned int> >::iterator itr = left->orig_segs.begin(); itr != left->orig_segs.end(); itr++) {
					for (set<unsigned int>::iterator it = itr->second.begin(); it != itr->second.end(); it++) {
						//cout << "LEFT SEGS " << itr->first << " : " << *it << endl;
						c->orig_segs[itr->first].insert(*it);
					};						
				};	

				for (map<string, set<unsigned int> >::iterator itr = right->orig_segs.begin(); itr != right->orig_segs.end(); itr++) {
					for (set<unsigned int>::iterator it = itr->second.begin(); it != itr->second.end(); it++) {
						//cout << "RIGHT SEGS " << itr->first << " : " << *it << endl;
						c->orig_segs[itr->first].insert(*it);
					};						
				};	
					

                offset = c->mRecCount;
                if(i == 0 && left->segCount != 1) {
                    c->reserve(res_count*(left->segCount+1));
                };
                c->resize_join(res_count);

                queue<string> op_sel1(op_sel_s);				
				
                unsigned int colInd, c_colInd;


                void* temp;
                CUDA_SAFE_CALL(cudaMalloc((void **) &temp, res_count*max_char(c)));

				bool copied = 0;	
				thrust::host_vector<unsigned int> prm_vh;
				std::map<string,bool> processed;				
				
				//std::clock_t start1 = std::clock();	
				
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
                    if(c->columnNames.find(op_sel1.front()) != c->columnNames.end()) {
                        c_colInd = c->columnNames[op_sel1.front()];
                    };					

					bool cmp_type;
					
                    if(left->columnNames.find(op_sel1.front()) !=  left->columnNames.end()) {
                        // copy field's segment to device, gather it and copy to the host
                        colInd = left->columnNames[op_sel1.front()];

						if(left->filtered)
							cmp_type = varNames[setMap[op_sel1.front()]]->compTypes[op_sel1.front()];
						else
							cmp_type = left->compTypes[op_sel1.front()];
						
						if ((((left->type[colInd] == 0) || ((left->type[colInd] == 1) && 
							   left->decimal[colInd])) && cmp_type == 0) && (colInd != colInd1) && left->not_compressed == 0) { // do the processing on host												
							
							void* h;	
							unsigned int cnt, lower_val, bits;		

							if(verbose)
								cout << "processing " << op_sel1.front() << " " << i << " " << cmp_type << endl;
							
							if(!copied) {								
								if(left->filtered) {
									thrust::device_vector<unsigned int> prm_v(res_count);
									thrust::gather(p_tmp.begin(), p_tmp.begin() + res_count, left->prm_d.begin(), prm_v.begin());
									prm_vh = prm_v;									
								}	
								else {
									prm_vh = p_tmp;
								};
								copied = 1;
							};								
							
							CudaSet *t = varNames[setMap[op_sel1.front()]];
							unsigned int t_ind = t->columnNames[op_sel1.front()];
							t->readSegmentsFromFile(i, t_ind, 0);
							
							if(t->type[t->columnNames[op_sel1.front()]] == 0) {
								h = t->h_columns_int[t->type_index[t_ind]].data();								
							}
							else {
								h = t->h_columns_float[t->type_index[t_ind]].data();
							};	
							
							cnt = ((unsigned int*)h)[0];
							lower_val = ((unsigned int*)h)[1];
							bits = ((unsigned int*)((char*)h + cnt))[8];	
							//cout << cnt << " " << lower_val << " " << bits << endl;																
		
							if(bits == 8) {
								if(left->type[colInd] == 0) {	
									thrust::gather_if(prm_vh.begin(), prm_vh.end(), prm_vh.begin(), (char*)((unsigned int*)h + 6), c->h_columns_int[c->type_index[c_colInd]].begin() + offset, is_positive());
								}	
								else {	
									int_type* ptr = (int_type*)c->h_columns_float[c->type_index[c_colInd]].data();
									thrust::gather_if(prm_vh.begin(), prm_vh.end(), prm_vh.begin(), (char*)((unsigned int*)h + 6), ptr + offset, is_positive());
								};										
							}
							else if(bits == 16) {
								if(left->type[colInd] == 0) {	
									thrust::gather_if(prm_vh.begin(), prm_vh.end(), prm_vh.begin(), (unsigned short int*)((unsigned int*)h + 6), c->h_columns_int[c->type_index[c_colInd]].begin() + offset, is_positive());
								}	
								else {	
									int_type* ptr = (int_type*)c->h_columns_float[c->type_index[c_colInd]].data();
									thrust::gather_if(prm_vh.begin(), prm_vh.end(), prm_vh.begin(), (unsigned short int*)((unsigned int*)h + 6), ptr + offset, is_positive());
								};
							}
							else if(bits == 32) {
								if(left->type[colInd] == 0) {	
									thrust::gather_if(prm_vh.begin(), prm_vh.end(), prm_vh.begin(), (unsigned int*)((unsigned int*)h + 6), c->h_columns_int[c->type_index[c_colInd]].begin() + offset, is_positive());
								}	
								else {	
									int_type* ptr = (int_type*)c->h_columns_float[c->type_index[c_colInd]].data();
									thrust::gather_if(prm_vh.begin(), prm_vh.end(), prm_vh.begin(), (unsigned int*)((unsigned int*)h + 6), ptr + offset, is_positive());
								};	
							}
							else if(bits == 64) {
								if(left->type[colInd] == 0) {	
									thrust::gather_if(prm_vh.begin(), prm_vh.end(), prm_vh.begin(), (int_type*)((unsigned int*)h + 6), c->h_columns_int[c->type_index[c_colInd]].begin() + offset, is_positive());
								}	
								else {	
									int_type* ptr = (int_type*)c->h_columns_float[c->type_index[c_colInd]].data();
									thrust::gather_if(prm_vh.begin(), prm_vh.end(), prm_vh.begin(), (int_type*)((unsigned int*)h + 6), ptr + offset, is_positive());
								};
							};
							
							if(left->type[colInd] == 0) {	
								thrust::transform(c->h_columns_int[c->type_index[c_colInd]].begin() + offset, c->h_columns_int[c->type_index[c_colInd]].begin() + offset + res_count, 
												  thrust::make_constant_iterator(lower_val), c->h_columns_int[c->type_index[c_colInd]].begin() + offset, thrust::plus<int_type>()); 																	
							}
							else {
								int_type* ptr = (int_type*)c->h_columns_float[c->type_index[c_colInd]].data();
								thrust::transform(ptr + offset, ptr + offset + res_count, 
												  thrust::make_constant_iterator(lower_val), ptr + offset, thrust::plus<int_type>()); 																						
								thrust::transform(ptr + offset, ptr + offset + res_count, c->h_columns_float[c->type_index[c_colInd]].begin() + offset, long_to_float());													
							};							
							
						}
						else {						
						
							allocColumns(left, cc);				
							copyColumns(left, cc, i, k, 0, 0);
						
							//gather
							if(left->type[colInd] == 0) {
								thrust::device_ptr<int_type> d_tmp((int_type*)temp);
								thrust::sequence(d_tmp, d_tmp+res_count,0,0);												
								thrust::gather_if(p_tmp.begin(), p_tmp.begin() + res_count, p_tmp.begin(), left->d_columns_int[left->type_index[colInd]].begin(), d_tmp, is_positive());								
								thrust::copy(d_tmp, d_tmp + res_count, c->h_columns_int[c->type_index[c_colInd]].begin() + offset);
							}
							else if(left->type[colInd] == 1) {
								thrust::device_ptr<float_type> d_tmp((float_type*)temp);
								thrust::sequence(d_tmp, d_tmp+res_count,0,0);
								thrust::gather_if(p_tmp.begin(), p_tmp.begin() + res_count, p_tmp.begin(), left->d_columns_float[left->type_index[colInd]].begin(), d_tmp, is_positive());
								thrust::copy(d_tmp, d_tmp + res_count, c->h_columns_float[c->type_index[c_colInd]].begin() + offset);
							}
							else { //strings
								thrust::device_ptr<char> d_tmp((char*)temp);
								thrust::fill(d_tmp, d_tmp+res_count*left->char_size[left->type_index[colInd]],0);
								
							
								str_gather(thrust::raw_pointer_cast(p_tmp.data()), res_count, (void*)left->d_columns_char[left->type_index[colInd]],
										(void*) thrust::raw_pointer_cast(d_tmp), left->char_size[left->type_index[colInd]]);
								cudaMemcpy( (void*)&c->h_columns_char[c->type_index[c_colInd]][offset*c->char_size[c->type_index[c_colInd]]], (void*) thrust::raw_pointer_cast(d_tmp),
											c->char_size[c->type_index[c_colInd]] * res_count, cudaMemcpyDeviceToHost);
							};
							
						
							if(colInd != colInd1)
								left->deAllocColumnOnDevice(colInd);							
						}
                    }
                    else if(right->columnNames.find(op_sel1.front()) !=  right->columnNames.end()) {
                        colInd = right->columnNames[op_sel1.front()];
					
                        //gather
                        if(right->type[colInd] == 0) {
                            thrust::device_ptr<int_type> d_tmp((int_type*)temp);
                            thrust::sequence(d_tmp, d_tmp+res_count,0,0);
                            thrust::gather_if(d_res2, d_res2 + res_count, d_res2, right->d_columns_int[right->type_index[colInd]].begin(), d_tmp, is_positive());							
                            thrust::copy(d_tmp, d_tmp + res_count, c->h_columns_int[c->type_index[c_colInd]].begin() + offset);
                        }
                        else if(right->type[colInd] == 1) {
                            thrust::device_ptr<float_type> d_tmp((float_type*)temp);
                            thrust::sequence(d_tmp, d_tmp+res_count,0,0);
                            thrust::gather_if(d_res2, d_res2 + res_count, d_res2, right->d_columns_float[right->type_index[colInd]].begin(), d_tmp, is_positive());
                            thrust::copy(d_tmp, d_tmp + res_count, c->h_columns_float[c->type_index[c_colInd]].begin() + offset);
                        }
                        else { //strings

                            thrust::device_ptr<char> d_tmp((char*)temp);
                            thrust::sequence(d_tmp, d_tmp+res_count*right->char_size[right->type_index[colInd]],0,0);							
                            str_gather(thrust::raw_pointer_cast(d_res2), res_count, (void*)right->d_columns_char[right->type_index[colInd]],
                                       (void*) thrust::raw_pointer_cast(d_tmp), right->char_size[right->type_index[colInd]]);									   
                            cudaMemcpy( (void*)&c->h_columns_char[c->type_index[c_colInd]][offset*c->char_size[c->type_index[c_colInd]]], (void*) thrust::raw_pointer_cast(d_tmp),
                                        c->char_size[c->type_index[c_colInd]] * res_count, cudaMemcpyDeviceToHost);
                        };					
                    }
                    else {
                        //cout << "Couldn't find field " << op_sel1.front() << endl;
                        //exit(0);
                    };
                    op_sel1.pop();					
                };
				//std::cout<< "gather time " <<  ( ( std::clock() - start1 ) / (double)CLOCKS_PER_SEC ) << " " << getFreeMem() << '\n';	
                cudaFree(temp);
            };
        };
		//std::cout<< "join TT time " <<  ( ( std::clock() - start2 ) / (double)CLOCKS_PER_SEC ) << " " << getFreeMem() << '\n';	
    };
	
	};


    left->deAllocOnDevice();
    right->deAllocOnDevice();
    c->deAllocOnDevice();

    unsigned int i = 0;
    while(!col_aliases.empty() && tab == join_tab_cnt) {
        c->columnNames[col_aliases.front()] = i;
        col_aliases.pop();
        i++;
    };

    varNames[s] = c;
    c->mRecCount = tot_count;    
	c->hostRecCount = tot_count;
	
	if(verbose)
		cout << endl << "tot res " << tot_count << endl;
	
	unsigned int tot_size = 0;	    
    for (map<string,unsigned int>::iterator it=c->columnNames.begin() ; it != c->columnNames.end(); ++it ) {
        setMap[(*it).first] = s;
		if(c->type[(*it).second] <= 1) 
			tot_size = tot_size + tot_count*8;
		else	
			tot_size = tot_size + tot_count*c->char_size[c->type_index[(*it).second]];
    };
	if ((getFreeMem() - 300000000) > tot_size) {
		c->maxRecs = tot_count;
	}
	else {	 
		c->segCount = ((tot_size/(getFreeMem() - 300000000)) + 1);		
		c->maxRecs = c->hostRecCount - (c->hostRecCount/c->segCount)*(c->segCount-1);
	};	
	

    if(right->tmp_table == 1) {
        right->free();
        varNames.erase(j2);
    }
    else {
        if(stat[j2] == statement_count) {
            right->free();
            varNames.erase(j2);
        };

    };

    if(stat[j1] == statement_count) {
        left->free();
        varNames.erase(j1);
    };
	join_type.pop();	
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
        unsigned int colInd = (a->columnNames).find(exe_type.top())->second;

        if ((a->type)[colInd] == 0)
            update_permutation_host(a->h_columns_int[a->type_index[colInd]].data(), permutation, a->mRecCount, exe_value.top(), (int_type*)temp);
        else if ((a->type)[colInd] == 1)
            update_permutation_host(a->h_columns_float[a->type_index[colInd]].data(), permutation, a->mRecCount,exe_value.top(), (float_type*)temp);
        else {
            update_permutation_char_host(a->h_columns_char[a->type_index[colInd]], permutation, a->mRecCount, exe_value.top(), b->h_columns_char[b->type_index[colInd]], a->char_size[a->type_index[colInd]]);
        };
    };

    for (unsigned int i = 0; i < a->mColumnCount; i++) {
        if ((a->type)[i] == 0) {
            apply_permutation_host(a->h_columns_int[a->type_index[i]].data(), permutation, a->mRecCount, b->h_columns_int[b->type_index[i]].data());
        }
        else if ((a->type)[i] == 1)
            apply_permutation_host(a->h_columns_float[a->type_index[i]].data(), permutation, a->mRecCount, b->h_columns_float[b->type_index[i]].data());
        else {
            apply_permutation_char_host(a->h_columns_char[a->type_index[i]], permutation, a->mRecCount, b->h_columns_char[b->type_index[i]], a->char_size[a->type_index[i]]);
        };
    };

    delete [] temp;
    delete [] permutation;
}



void emit_order(char *s, char *f, int e, int ll)
{
    if(ll == 0)
        statement_count++;

    if (scan_state == 0 && ll == 0) {
        if (stat.find(f) == stat.end()) {
            cout << "Order : couldn't find variable " << f << endl;
            exit(1);
        };
        stat[s] = statement_count;
        stat[f] = statement_count;
        return;
    };

    if(varNames.find(f) == varNames.end() ) {
        clean_queues();
        return;
    };

    CudaSet* a = varNames.find(f)->second;


    if (a->mRecCount == 0)	{
        if(varNames.find(s) == varNames.end())
            varNames[s] = new CudaSet(0,1);
        else {
            CudaSet* c = varNames.find(s)->second;
            c->mRecCount = 0;
        };
        return;
    };

    stack<string> exe_type, exe_value;

	if(verbose)
		cout << "order: " << s << " " << f << endl;


    for(int i=0; !op_type.empty(); ++i, op_type.pop(),op_value.pop()) {
        if ((op_type.front()).compare("NAME") == 0) {
            exe_type.push(op_value.front());
            exe_value.push("ASC");
        }
        else {
            exe_type.push(op_type.front());
            exe_value.push(op_value.front());
        };
    };

    stack<string> tp(exe_type);
    queue<string> op_vx;
    while (!tp.empty()) {
        op_vx.push(tp.top());
        tp.pop();
    };

    queue<string> names;
    for (map<string,unsigned int>::iterator it=a->columnNames.begin() ; it != a->columnNames.end(); ++it )
        names.push((*it).first);

    CudaSet *b = a->copyDeviceStruct();

    //lets find out if our data set fits into a GPU
    size_t mem_available = getFreeMem();
    size_t rec_size = 0;
    for(unsigned int i = 0; i < a->mColumnCount; i++) {
        if(a->type[i] == 0)
            rec_size = rec_size + int_size;
        else if(a->type[i] == 1)
            rec_size = rec_size + float_size;
        else
            rec_size = rec_size + a->char_size[a->type_index[i]];
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
        thrust::device_ptr<unsigned int> permutation = thrust::device_malloc<unsigned int>(a->mRecCount);
        thrust::sequence(permutation, permutation+(a->mRecCount));

        unsigned int* raw_ptr = thrust::raw_pointer_cast(permutation);

        size_t maxSize =  a->mRecCount;
        void* temp;        
        CUDA_SAFE_CALL(cudaMalloc((void **) &temp, maxSize*max_char(a)));
        
        varNames[setMap[exe_type.top()]]->hostRecCount = varNames[setMap[exe_type.top()]]->mRecCount;

        size_t rcount;
        a->mRecCount = load_queue(names, a, 1, op_vx.front(), rcount, 0, a->segCount);

        varNames[setMap[exe_type.top()]]->mRecCount = varNames[setMap[exe_type.top()]]->hostRecCount;
		
        for(int i=0; !exe_type.empty(); ++i, exe_type.pop(),exe_value.pop()) {
            int colInd = (a->columnNames).find(exe_type.top())->second;
            if ((a->type)[colInd] == 0)
                update_permutation(a->d_columns_int[a->type_index[colInd]], raw_ptr, a->mRecCount, exe_value.top(), (int_type*)temp);
            else if ((a->type)[colInd] == 1)
                update_permutation(a->d_columns_float[a->type_index[colInd]], raw_ptr, a->mRecCount,exe_value.top(), (float_type*)temp);
            else {
                update_permutation_char(a->d_columns_char[a->type_index[colInd]], raw_ptr, a->mRecCount, exe_value.top(), (char*)temp, a->char_size[a->type_index[colInd]]);
                //update_permutation(a->d_columns_int[int_col_count+str_count], raw_ptr, a->mRecCount, exe_value.top(), (int_type*)temp);
                //str_count++;
            };
        };

        b->resize(a->mRecCount); //resize host arrays
        b->mRecCount = a->mRecCount;
        //str_count = 0;

        for (unsigned int i = 0; i < a->mColumnCount; i++) {
            if ((a->type)[i] == 0)
                apply_permutation(a->d_columns_int[a->type_index[i]], raw_ptr, a->mRecCount, (int_type*)temp);
            else if ((a->type)[i] == 1)
                apply_permutation(a->d_columns_float[a->type_index[i]], raw_ptr, a->mRecCount, (float_type*)temp);
            else {
                apply_permutation_char(a->d_columns_char[a->type_index[i]], raw_ptr, a->mRecCount, (char*)temp, a->char_size[a->type_index[i]]);
                //str_count++;
            };
        };

        for(unsigned int i = 0; i < a->mColumnCount; i++) {
            switch(a->type[i]) {
            case 0 :
                thrust::copy(a->d_columns_int[a->type_index[i]].begin(), a->d_columns_int[a->type_index[i]].begin() + a->mRecCount, b->h_columns_int[b->type_index[i]].begin());
                break;
            case 1 :
                thrust::copy(a->d_columns_float[a->type_index[i]].begin(), a->d_columns_float[a->type_index[i]].begin() + a->mRecCount, b->h_columns_float[b->type_index[i]].begin());
                break;
            default :
                cudaMemcpy(b->h_columns_char[b->type_index[i]], a->d_columns_char[a->type_index[i]], a->char_size[a->type_index[i]]*a->mRecCount, cudaMemcpyDeviceToHost);
            }
        };

        b->deAllocOnDevice();
        a->deAllocOnDevice();


        thrust::device_free(permutation);
        cudaFree(temp);
    };

    varNames[s] = b;
    b->segCount = 1;
    b->not_compressed = 1;

    if(stat[f] == statement_count && !a->keep) {
        a->free();
        varNames.erase(f);
    };
}


void emit_select(char *s, char *f, int ll)
{
    statement_count++;
    if (scan_state == 0) {
        if (stat.find(f) == stat.end()) {
            cout << "Select : couldn't find variable " << f << endl;
            exit(1);
        };
        stat[s] = statement_count;
        stat[f] = statement_count;
        return;
    };


    if(varNames.find(f) == varNames.end()) {
        clean_queues();
        cout << "Couldn't find " << f << endl;
        return;
    };



    queue<string> op_v1(op_value);
    while(op_v1.size() > ll)
        op_v1.pop();


    stack<string> op_v2;
    queue<string> op_v3;

    for(int i=0; i < ll; ++i) {
        op_v2.push(op_v1.front());
        op_v3.push(op_v1.front());
        op_v1.pop();
    };

    CudaSet *a;
    if(varNames.find(f) != varNames.end())
        a = varNames.find(f)->second;
    else {
        cout << "Couldn't find " << f  << endl;
        exit(0);
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
        if(a->columnNames.find(op_v.front()) != a->columnNames.end()) {
            tt = op_v.front();
            if(!op_v.empty()) {
                op_v.pop();
                if(!op_v.empty()) {
                    if(a->columnNames.find(op_v.front()) == a->columnNames.end()) {
                        if(aliases.count(tt) == 0) {
                            aliases[tt] = op_v.front();
                        };
                    }
                    else {
                        if (!op_v.empty()) {
                            while(a->columnNames.find(op_v.front()) == a->columnNames.end())
                                op_v.pop();
                        };
                    };
                };
            };
        };
        if(!op_v.empty())
            op_v.pop();
    };

    op_v = op_value;
    while(!op_v.empty()) {
        if(a->columnNames.find(op_v.front()) != a->columnNames.end()) {
            field_names.insert(op_v.front());
        };
        op_v.pop();
    };



    for (set<string>::iterator it=field_names.begin(); it!=field_names.end(); ++it)  {
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
        cycle_count = varNames[setMap[op_value.front()]]->segCount;
    else
        cycle_count = a->segCount;

    size_t ol_count = a->mRecCount, cnt;
    a->hostRecCount = a->mRecCount;
    b = new CudaSet(0, col_count);
	b->name = "tmp b in select";
    bool b_set = 0, c_set = 0;

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


// find out how many string columns we have. Add int_type columns to store string hashes for sort/groupby ops.
    stack<string> op_s = op_v2;
    int_col_count = a->d_columns_int.size();

    while(!op_s.empty()) {
        int colInd = (a->columnNames).find(op_s.top())->second;
        if (a->type[colInd] == 2) {
            a->d_columns_int.push_back(thrust::device_vector<int_type>());
        };
        op_s.pop();
    };


    unsigned int s_cnt;
    bool one_liner;
	
    for(unsigned int i = 0; i < cycle_count; i++) {          // MAIN CYCLE
		if(verbose)
			cout << "segment " << i << " select mem " << getFreeMem() << endl;
				
        cnt = 0;		
        copyColumns(a, op_vx, i, cnt);
		//cout << "after cpy " << getFreeMem() << endl;
        op_s = op_v2;
        s_cnt = 0;

        while(!op_s.empty() && a->mRecCount != 0) {

            int colInd = (a->columnNames).find(op_s.top())->second;
            if (a->type[colInd] == 2) {
                a->d_columns_int[int_col_count + s_cnt].resize(0);
				a->d_columns_int[int_col_count + s_cnt].shrink_to_fit();
                a->add_hashed_strings(op_s.top(), i, int_col_count + s_cnt);				
                s_cnt++;
            };
            op_s.pop();
        };		

        if(a->mRecCount) {
            if (ll != 0) {
                order_inplace(a,op_v2,field_names);
                a->GroupBy(op_v2, int_col_count);
            };
            select(op_type,op_value,op_nums, op_nums_f,a,b, distinct_tmp, one_liner);
			//cout << "after sel " << getFreeMem() << endl;
			
            if(!b_set) {
                for (map<string,unsigned int>::iterator it=b->columnNames.begin() ; it != b->columnNames.end(); ++it )
                    setMap[(*it).first] = s;
                b_set = 1;
                unsigned int old_cnt = b->mRecCount;
                b->mRecCount = 0;
                b->resize(varNames[setMap[op_vx.front()]]->maxRecs);
                b->mRecCount = old_cnt;
            };		

            if (!c_set && b->mRecCount > 0) {
                c = new CudaSet(0, col_count);
                create_c(c,b);				
                c_set = 1;
				c->name = s;
            };
			

            if (ll != 0 && cycle_count > 1  && b->mRecCount > 0) {
                add(c,b,op_v3, aliases, distinct_tmp, distinct_val, distinct_hash, a);	
            }
            else {
                //copy b to c
                unsigned int c_offset = c->mRecCount;
                c->resize(b->mRecCount);				
				
                for(unsigned int j=0; j < b->mColumnCount; j++) {
                    if (b->type[j] == 0) {
                        thrust::copy(b->d_columns_int[b->type_index[j]].begin(), b->d_columns_int[b->type_index[j]].begin() + b->mRecCount, c->h_columns_int[c->type_index[j]].begin() + c_offset);
                    }
                    else if (b->type[j] == 1) {
                        thrust::copy(b->d_columns_float[b->type_index[j]].begin(), b->d_columns_float[b->type_index[j]].begin() + b->mRecCount, c->h_columns_float[c->type_index[j]].begin() + c_offset);
                    }
                    else {
                        cudaMemcpy((void*)(thrust::raw_pointer_cast(c->h_columns_char[c->type_index[j]] + b->char_size[b->type_index[j]]*c_offset)), (void*)thrust::raw_pointer_cast(b->d_columns_char[b->type_index[j]]),
                                   b->char_size[b->type_index[j]] * b->mRecCount, cudaMemcpyDeviceToHost);
                    };
                };
            };
        };
    };
	
	
    a->mRecCount = ol_count;
    a->mRecCount = a->hostRecCount;
    a->deAllocOnDevice();
    b->deAllocOnDevice();
	
    if(!c_set) {
        CudaSet *c;
        c = new CudaSet(0,1);
        varNames[s] = c;
		c->name = s;
        clean_queues();
        return;
    };
	
	
    if (ll != 0) {
        count_avg(c, distinct_hash);
    }
    else {
        if(one_liner) {
            count_simple(c);
        };
    };
	
    c->maxRecs = c->mRecCount;
    c->name = s;
    c->keep = 1;

    for ( map<string,unsigned int>::iterator it=c->columnNames.begin() ; it != c->columnNames.end(); ++it ) {
        setMap[(*it).first] = s;
    };

    clean_queues();

    varNames[s] = c;
    b->free();
    varNames[s]->keep = 1;

    if(stat[s] == statement_count) {
        varNames[s]->free();
        varNames.erase(s);
    };

    if(stat[f] == statement_count && a->keep == 0) {
        a->free();
        varNames.erase(f);		
    };
	if(verbose)
		std::cout<< "select time " <<  ( ( std::clock() - start1 ) / (double)CLOCKS_PER_SEC ) <<'\n';
}


//Both the source and destination of the insert operator can be either derived or permanent dataset
//But for now lets see if I can code only permanent to permanent code path and get away with it
void emit_insert(char *f, char* s) {
    statement_count++;
    if (scan_state == 0) {
        if (stat.find(f) == stat.end()) {
            cout << "Delete : couldn't find variable " << f << endl;
            exit(1);
        };
        if (stat.find(s) == stat.end()) {
            cout << "Delete : couldn't find variable " << s << endl;
            exit(1);
        };
		
        stat[f] = statement_count;
		stat[s] = statement_count;
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

void emit_delete(char *f)
{
    statement_count++;
    if (scan_state == 0) {
        if (stat.find(f) == stat.end()) {
            cout << "Delete : couldn't find variable " << f << endl;
            exit(1);
        };
        stat[f] = statement_count;
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

void emit_display(char *f, char* sep)
{
   statement_count++;
    if (scan_state == 0) {
        if (stat.find(f) == stat.end()) {
            cout << "Delete : couldn't find variable " << f << endl;
            exit(1);
        };
        stat[f] = statement_count;
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

    a->Store("",sep, limit, 0, 1);
	if(verbose)
		cout << "DISPLAY " << f << endl;

	clean_queues();
    if(stat[f] == statement_count  && a->keep == 0) {
        a->free();
        varNames.erase(f);
    };
	
}


void emit_filter(char *s, char *f)
{
    statement_count++;
    if (scan_state == 0) {
        if (stat.find(f) == stat.end()) {
            cout << "Filter : couldn't find variable " << f << endl;
            exit(1);
        };
        stat[s] = statement_count;
        stat[f] = statement_count;
        clean_queues();
        return;
    };

    if(varNames.find(f) == varNames.end()) {
        clean_queues();
        return;
    };


    CudaSet *a, *b;

    a = varNames.find(f)->second;
    a->name = f;

    if(a->mRecCount == 0) {
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
        b->filtered = 1;
        b->prm_d.resize(a->maxRecs);
    };
    clean_queues();

    if (varNames.count(s) > 0)
        varNames[s]->free();
    varNames[s] = b;

    if(stat[s] == statement_count) {
        b->free();
        varNames.erase(s);
    };
}

void emit_store(char *s, char *f, char* sep)
{
    statement_count++;
    if (scan_state == 0) {
        if (stat.find(s) == stat.end()) {
            cout << "Store : couldn't find variable " << s << endl;
            exit(1);
        };
        stat[s] = statement_count;
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

    a->Store(f,sep, limit, 0);

    if(stat[s] == statement_count  && a->keep == 0) {
        a->free();
        varNames.erase(s);
    };
};


void emit_store_binary(char *s, char *f)
{
    statement_count++;
    if (scan_state == 0) {
        if (stat.find(s) == stat.end()) {
            cout << "Store : couldn't find variable " << s << endl;
            exit(1);
        };
        stat[s] = statement_count;
        return;
    };

    if(varNames.find(s) == varNames.end())
        return;

    CudaSet* a = varNames.find(s)->second;

    if(stat[f] == statement_count)
        a->deAllocOnDevice();

    printf("STORE: %s %s \n", s, f);

    int limit = 0;
    if(!op_nums.empty()) {
        limit = op_nums.front();
        op_nums.pop();
    };
    total_count = 0;
    total_segments = 0;
	
    if(fact_file_loaded) {
        a->Store(f,"", limit, 1);
    }
    else {
		FILE* file_p;
		if(a->text_source) {
			file_p = fopen(a->load_file_name.c_str(), "r");
		    if (file_p  == NULL) {
				cout << "Could not open file " << a->load_file_name << endl;
				exit(0);
			};
		};

        while(!fact_file_loaded) {
			if(verbose)
				cout << "LOADING " << a->load_file_name << " mem: " << getFreeMem() << endl;
            if(a->text_source)
                fact_file_loaded = a->LoadBigFile(file_p);
            a->Store(f,"", limit, 1);
        };
    };
	a->writeSortHeader(f);

    if(stat[f] == statement_count && !a->keep) {
        a->free();
        varNames.erase(s);
    };

};


void emit_load_binary(char *s, char *f, int d)
{
    statement_count++;
    if (scan_state == 0) {
        stat[s] = statement_count;
        return;
    };

	if(verbose)
		printf("BINARY LOAD: %s %s \n", s, f);

    CudaSet *a;
    unsigned int segCount, maxRecs;
    string f1(f);
    f1 += "." + int_to_string(cols.front()) + ".header";

    FILE* ff = fopen(f1.c_str(), "rb");
    if(ff == NULL) {
        cout << "Couldn't open file " << f1 << endl;
        exit(0);
    };
	size_t totRecs;
    fread((char *)&totRecs, 8, 1, ff);
    fread((char *)&segCount, 4, 1, ff);
    fread((char *)&maxRecs, 4, 1, ff);
    fclose(ff);

	if(verbose)
		cout << "Reading " << totRecs << " records" << endl;
    queue<string> names(namevars);
    while(!names.empty()) {
        setMap[names.front()] = s;
        names.pop();
    };

	a = new CudaSet(namevars, typevars, sizevars, cols, totRecs, f, maxRecs);
    a->segCount = segCount;    
    a->keep = 1;
	a->name = s;
    varNames[s] = a;
	for(unsigned int i = 0; i < segCount; i++)
		a->orig_segs[f].insert(i); 

    if(stat[s] == statement_count )  {
        a->free();
        varNames.erase(s);
    };
}


void emit_load(char *s, char *f, int d, char* sep)
{
    statement_count++;
    if (scan_state == 0) {
        stat[s] = statement_count;
        return;
    };

    printf("LOAD: %s %s %d  %s \n", s, f, d, sep);

    CudaSet *a;

    a = new CudaSet(namevars, typevars, sizevars, cols, process_count, references, references_nums);
    a->mRecCount = 0;
    a->resize(process_count);
    a->keep = true;
    a->not_compressed = 1;
    a->load_file_name = f;
	a->separator = sep;
    a->maxRecs = a->mRecCount;
    a->segCount = 0;
    varNames[s] = a;
    fact_file_loaded = 0;

    if(stat[s] == statement_count)  {
        a->free();
        varNames.erase(s);
    };
}



void yyerror(char *s, ...)
{
    extern int yylineno;
    va_list ap;
    va_start(ap, s);

    fprintf(stderr, "%d: error: ", yylineno);
    vfprintf(stderr, s, ap);
    fprintf(stderr, "\n");
}

void clean_queues()
{
    while(!op_type.empty()) op_type.pop();
    while(!op_value.empty()) op_value.pop();
    while(!op_join.empty()) op_join.pop();
    while(!op_nums.empty()) op_nums.pop();
    while(!op_nums_f.empty()) op_nums_f.pop();
    while(!j_col_count.empty()) j_col_count.pop();
    while(!namevars.empty()) namevars.pop();
    while(!typevars.empty()) typevars.pop();
    while(!sizevars.empty()) sizevars.pop();
    while(!cols.empty()) cols.pop();
    while(!op_sort.empty()) op_sort.pop();
    while(!references.empty()) references.pop();
    while(!references_nums.empty()) references_nums.pop();
    while(!op_presort.empty()) op_presort.pop();

	op_case = 0;
    sel_count = 0;
    join_cnt = 0;
    join_col_cnt = 0;
    distinct_cnt = 0;
    join_tab_cnt = 0;
    tab_cnt = 0;
    join_and_cnt.clear();
}


int main(int ac, char **av)
{
	bool interactive = 0;
    if (ac < 2) {
        cout << "Usage : alenka [-l process_count] [-v] script.sql" << endl;
        exit(1);
    }
	else {

		process_count = 6200000;
		verbose = 0;
		for (int i = 1; i < ac; i++) {
			if(strcmp(av[i],"-l") == 0) {
				process_count = atoff(av[i+1]);				
			}
			else if(strcmp(av[i],"-v") == 0) {
				verbose = 1;
			}
			else if(strcmp(av[i],"-i") == 0) {
				interactive = 1;
			};
		};

		if (!interactive) {
			if((yyin = fopen(av[ac-1], "r")) == NULL) {
				perror(av[ac-1]);
				exit(1);
			};

			if(yyparse()) {
				printf("SQL scan parse failed\n");
				exit(1);
			};

			scan_state = 1;
			std::clock_t start1 = std::clock();
			tot = 0;
			statement_count = 0;
			clean_queues();
			
			yyin = fopen(av[ac-1], "r");
			PROC_FLUSH_BUF ( yyin );
			statement_count = 0;
		
			extern FILE *yyin;
			context = CreateCudaDevice(0, av, verbose);
			cudppCreate(&theCudpp);
			hash_seed = 100;		
		
			if(!yyparse()) {
				if(verbose)
					cout << "SQL scan parse worked" << endl;
			}		
			else
				cout << "SQL scan parse failed" << endl;		

			fclose(yyin);			
			for (map<string,CudaSet*>::iterator it=varNames.begin() ; it != varNames.end(); ++it ) {
				(*it).second->free();
			};		
			
			if(alloced_sz) {
				cudaFree(alloced_tmp);				
			};	
		
			cudppDestroy(theCudpp);
			if(verbose) {
				cout<< endl << "tot disk time " <<  (( tot ) / (double)CLOCKS_PER_SEC ) << endl;
				cout<< "cycle time " <<  ( ( std::clock() - start1 ) / (double)CLOCKS_PER_SEC ) << " " << getFreeMem() << endl;		
			};	
		}
		else {
			string script;
			context = CreateCudaDevice(0, av, verbose);
			cudppCreate(&theCudpp);
			hash_seed = 100;	
			getline(cin, script);
			
			while (script != "exit" && script != "EXIT") {				
				
				yy_scan_string(script.c_str());				
				scan_state = 0;
				statement_count = 0;
				clean_queues();		
				if(yyparse()) {
					printf("SQL scan parse failed \n");
					getline(cin, script);				
					continue;
				};
				
				scan_state = 1;
				statement_count = 0;
				clean_queues();		
				yy_scan_string(script.c_str());
				std::clock_t start1 = std::clock();
		
				if(!yyparse()) {
					if(verbose)
						cout << "SQL scan parse worked" << endl;
				};
				for (map<string,CudaSet*>::iterator it=varNames.begin() ; it != varNames.end(); ++it ) {
					(*it).second->free();					
				};
				varNames.clear();
				
				if(verbose) {				
					cout<< "cycle time " <<  ( ( std::clock() - start1 ) / (double)CLOCKS_PER_SEC ) << endl;		
				};	
				getline(cin, script);				
			};	
			cudppDestroy(theCudpp);
			if(alloced_sz) {
				cudaFree(alloced_tmp);				
				alloced_sz = 0;
			};	
			

		};	

		return 0;
	};	
}


