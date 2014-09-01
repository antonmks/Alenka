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

%{


#include "lex.yy.c"
#include "cm.h"

    void clean_queues();
    void order_inplace(CudaSet* a, stack<string> exe_type, bool update_int);
    void yyerror(char *s, ...);
    void emit(const char *s, ...);
    void emit_mul();
    void emit_add();
    void emit_minus();
    void emit_distinct();
    void emit_div();
    void emit_and();
    void emit_eq();
    void emit_or();
    void emit_cmp(const int val);
    void emit_var(const char *s, const int c, const char *f, const char* ref, const char* ref_name);
    void emit_var_asc(const char *s);
    void emit_var_desc(const char *s);
    void emit_name(const char *name);
    void emit_count();
    void emit_sum();
    void emit_average();
    void emit_min();
    void emit_max();
    void emit_string(const char *str);
    void emit_number(const int_type val);
    void emit_float(const float_type val);
    void emit_decimal(const float_type val);
    void emit_sel_name(const char* name);
    void emit_limit(const int val);
    void emit_union(const char *s, const char *f1, const char *f2);
    void emit_varchar(const char *s, const int c, const char *f, const int d, const char *ref, const char* ref_name);
    void emit_load(const char *s, const char *f, const int d, const char* sep);
    void emit_load_binary(const char *s, const char *f, const int d);
    void emit_store(const char *s, const char *f, const char* sep);
    void emit_store_binary(const char *s, const char *f, const char* sep);
    void emit_store_binary(const char *s, const char *f);
    void emit_filter(char *s, char *f);
    void emit_delete(const char *f);
    void emit_insert(const char *f, const char* s);
    void emit_order(const char *s, const char *f, const int e, const int ll = 0);
    void emit_group(const char *s, const char *f, const int e);
    void emit_select(const char *s, const char *f, const int ll);
    void emit_join(const char *s, const char *j1, const int grp, const int start_seg, const int end_seg);
    void emit_join_tab(const char *s, const char tp);
    void emit_distinct();
    void emit_sort(const char* s, const int p);
    void emit_presort(const char* s);
    void emit_display(const char *s, const char* sep);
    void emit_case();
    void emit_show_tables();
    void emit_describe_table(const char* table_name);
    void emit_drop_table(const char* table_name);
    void process_error(const int severity, const string err);
	void emit_create_bitmap_index(const char *index_name, const char *ltable, const char *rtable, const char *rcolumn, const char *lid, const char *rid);

%}

%union {
    long long int intval;
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

%token FROM
%token MULITE
%token DELETE
%token OR
%token LOAD
%token FILTER
%token BY
%token JOIN
%token STORE
%token INTO
%token GROUP
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
%token INSERT
%token WHERE
%token DISPLAY
%token CASE
%token WHEN
%token THEN
%token ELSE
%token END
%token REFERENCES
%token SHOW
%token TABLES
%token TABLE
%token DESCRIBE
%token DROP
%token CREATE
%token BITMAP
%token INDEX

%type <intval> load_list  opt_where opt_limit sort_def
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
{ emit_select($1, $6, $7); }
| NAME ASSIGN LOAD FILENAME USING '(' FILENAME ')' AS '(' load_list ')'
{  emit_load($1, $4, $11, $7); }
| NAME ASSIGN FILTER NAME opt_where
{  emit_filter($1, $4);}
| NAME ASSIGN ORDER NAME BY opt_val_list
{  emit_order($1, $4, $6);}
| NAME ASSIGN SELECT expr_list FROM NAME join_list opt_group_list
{  emit_join($1,$6,$7,0,-1); }
| STORE NAME INTO FILENAME USING '(' FILENAME ')' opt_limit
{  emit_store($2,$4,$7); }
| STORE NAME INTO FILENAME opt_limit BINARY sort_def
{  emit_store_binary($2,$4); }
| DESCRIBE NAME
{  emit_describe_table($2);}
| INSERT INTO NAME SELECT expr_list FROM NAME
{  emit_insert($3, $7);}
| DELETE FROM NAME WHERE expr
{  emit_delete($3);}
| DISPLAY NAME USING '(' FILENAME ')' opt_limit
{  emit_display($2, $5);}
| SHOW TABLES
{  emit_show_tables();}
| DROP TABLE NAME
{  emit_drop_table($3);}
| CREATE BITMAP INDEX NAME ON NAME '(' NAME '.' NAME ')' FROM NAME ',' NAME WHERE NAME '.' NAME EQUAL NAME '.' NAME
{  emit_create_bitmap_index($4, $6, $8, $10, $19, $23);};


expr:
NAME { emit_name($1); }
| NAME '.' NAME { emit("FIELDNAME %s.%s", $1, $3); }
| USERVAR { emit("USERVAR %s", $1); }
| STRING { emit_string($1); }
| INTNUM { emit_number($1); }
| APPROXNUM { emit_float($1); }
| DECIMAL1 { emit_decimal($1); }
| BOOL1 { emit("BOOL %d", $1); }
| NAME '{' INTNUM '}' ':' NAME '(' INTNUM ')' REFERENCES NAME '(' NAME ')' { emit_varchar($1, $3, $6, $8, $11, $13);}
| NAME '{' INTNUM '}' ':' NAME '(' INTNUM ')' { emit_varchar($1, $3, $6, $8, "", "");}
| NAME '{' INTNUM '}' ':' NAME REFERENCES NAME '(' NAME ')' { emit_var($1, $3, $6, $8, $10);}
| NAME '{' INTNUM '}' ':' NAME  { emit_var($1, $3, $6, "", "");}
| NAME ASC { emit_var_asc($1);}
| NAME DESC { emit_var_desc($1);}
| COUNT '(' expr ')' { emit_count(); }
| SUM '(' expr ')' { emit_sum(); }
| AVG '(' expr ')' { emit_average(); }
| MIN '(' expr ')' { emit_min(); }
| MAX '(' expr ')' { emit_max(); }
| DISTINCT expr { emit_distinct(); }
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
| expr LIKE expr { emit_cmp(7); }
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
| GROUP BY val_list { $$ = $3;}


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
    $$ = 0;
}  | val_list;

opt_where:
BY expr { emit("FILTER BY"); };


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
    $$ = 0;
}
| LIMIT INTNUM { emit_limit($2); };

sort_def: { /* nil */
    $$ = 0;
}
|SORT SEGMENTS BY NAME { emit_sort($4, 0); };
|SORT SEGMENTS BY NAME PARTITION BY INTNUM { emit_sort($4, $7); };
|PRESORTED BY NAME { emit_presort($3); };

%%

#include "filter.h"
#include "select.h"
#include "merge.h"
#include "sorts.cu"
#include "callbacks.h"

using namespace mgpu;
using namespace std;

size_t int_size = sizeof(int_type);
size_t float_size = sizeof(float_type);

queue<string> namevars;
queue<string> typevars;
queue<int> sizevars;
queue<int> cols;
queue<string> references;
queue<string> references_names;

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
map<string, map<string, bool> > used_vars;
bool save_dict = 0;
ContextPtr context;
void* p_tmp1 = nullptr;
bool set_p = 0;
int p_sz = 0;

void emit_multijoin(const string s, const string j1, const string j2, const unsigned int tab, const char* res_name, const int start_segment, const int end_segment);

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
    string sss(str,1, strlen(str)-2);
    op_type.push("STRING");
    op_value.push(sss);
}


void emit_number(const int_type val)
{
    op_type.push("NUMBER");
    op_nums.push(val);	
}

void emit_float(const float_type val)
{
    op_type.push("FLOAT");
    op_nums_f.push(val);
}

void emit_decimal(const float_type val)
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
    references.push(ref);
    references_names.push(ref_name);
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
    references.push(ref);
    references_names.push(ref_name);
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

void order_inplace_host(CudaSet* a, stack<string> exe_type, bool update_str)
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
        if (a->type[exe_type.top()] == 0)
            update_permutation_host(a->h_columns_int[exe_type.top()].data(), permutation, a->mRecCount, exe_value.top(), (int_type*)temp);
        else if (a->type[exe_type.top()] == 1)
            update_permutation_host(a->h_columns_float[exe_type.top()].data(), permutation, a->mRecCount,exe_value.top(), (float_type*)temp);
        else {
            update_permutation_char_host(a->h_columns_char[exe_type.top()], permutation, a->mRecCount, exe_value.top(), temp, a->char_size[exe_type.top()]);
        };
    };

    for (auto i = 0; i < a->mColumnCount; i++) {
        if (a->type[a->columnNames[i]] == 0) {
            thrust::gather(permutation, permutation + a->mRecCount, a->h_columns_int[a->columnNames[i]].data(), (int_type*)temp);
            thrust::copy((int_type*)temp, (int_type*)temp + a->mRecCount, a->h_columns_int[a->columnNames[i]].data());
        }
        else if (a->type[a->columnNames[i]] == 1) {
            thrust::gather(permutation, permutation + a->mRecCount, a->h_columns_float[a->columnNames[i]].data(), (float_type*)temp);
            thrust::copy((float_type*)temp, (float_type*)temp + a->mRecCount, a->h_columns_float[a->columnNames[i]].data());
        }
        else {
            apply_permutation_char_host(a->h_columns_char[a->columnNames[i]], permutation, a->mRecCount, temp, a->char_size[a->columnNames[i]]);
            thrust::copy(temp, temp + a->mRecCount*a->char_size[a->columnNames[i]], a->h_columns_float[a->columnNames[i]].data());
        };
    };

    delete [] temp;
    delete [] permutation;
}


void order_inplace1(CudaSet* a, stack<string> exe_type, set<string> field_names, bool update_str)
{
    thrust::device_ptr<unsigned int> permutation = thrust::device_malloc<unsigned int>(a->mRecCount);
    thrust::sequence(permutation, permutation+a->mRecCount,0,1);

    unsigned int* raw_ptr = thrust::raw_pointer_cast(permutation);
    void* temp;
    CUDA_SAFE_CALL(cudaMalloc((void **) &temp, a->mRecCount*max_char(a, field_names)));

    for(; !exe_type.empty(); exe_type.pop()) {
        if (a->type[exe_type.top()] == 0 ) {
            a->d_columns_int[exe_type.top()].resize(a->mRecCount);
            thrust::copy(a->h_columns_int[exe_type.top()].begin(), a->h_columns_int[exe_type.top()].begin() + a->mRecCount, a->d_columns_int[exe_type.top()].begin());
            update_permutation(a->d_columns_int[exe_type.top()], raw_ptr, a->mRecCount, "ASC", (int_type*)temp);
            a->d_columns_int[exe_type.top()].resize(0);
            a->d_columns_int[exe_type.top()].shrink_to_fit();
        }
        else if (a->type[exe_type.top()] == 1) {
            a->d_columns_float[exe_type.top()].resize(a->mRecCount);
            thrust::copy(a->h_columns_float[exe_type.top()].begin(), a->h_columns_float[exe_type.top()].begin() + a->mRecCount, a->d_columns_float[exe_type.top()].begin());
            update_permutation(a->d_columns_float[exe_type.top()], raw_ptr, a->mRecCount,"ASC", (float_type*)temp);
            a->d_columns_float[exe_type.top()].resize(0);
            a->d_columns_float[exe_type.top()].shrink_to_fit();
        }
        else {
            // use int col int_col_count
            a->d_columns_int[exe_type.top()].resize(a->mRecCount);
            thrust::copy(a->h_columns_int[exe_type.top()].begin(), a->h_columns_int[exe_type.top()].begin() + a->mRecCount, a->d_columns_int[exe_type.top()].begin());
            update_permutation(a->d_columns_int[exe_type.top()], raw_ptr, a->mRecCount, "ASC", (int_type*)temp);
            a->d_columns_int[exe_type.top()].resize(0);
            a->d_columns_int[exe_type.top()].shrink_to_fit();
        };
    };
	

    for (auto it=field_names.begin(); it!=field_names.end(); ++it) {
        if (a->type[*it] == 0) {
            a->d_columns_int[*it].resize(a->mRecCount);
            thrust::copy(a->h_columns_int[*it].begin(), a->h_columns_int[*it].begin() + a->mRecCount, a->d_columns_int[*it].begin());
            apply_permutation(a->d_columns_int[*it], raw_ptr, a->mRecCount, (int_type*)temp);
            thrust::copy(a->d_columns_int[*it].begin(), a->d_columns_int[*it].begin() + a->mRecCount, a->h_columns_int[*it].begin());
            a->d_columns_int[*it].resize(0);
            a->d_columns_int[*it].shrink_to_fit();
        }
        else if (a->type[*it] == 1) {
            a->d_columns_float[*it].resize(a->mRecCount);
            thrust::copy(a->h_columns_float[*it].begin(), a->h_columns_float[*it].begin() + a->mRecCount, a->d_columns_float[*it].begin());
            apply_permutation(a->d_columns_float[*it], raw_ptr, a->mRecCount, (float_type*)temp);
            thrust::copy(a->d_columns_float[*it].begin(), a->d_columns_float[*it].begin() + a->mRecCount, a->h_columns_float[*it].begin());
            a->d_columns_float[*it].resize(0);
            a->d_columns_float[*it].shrink_to_fit();
        }
        else {
            a->allocColumnOnDevice(*it, a->mRecCount);
            cudaMemcpy( a->d_columns_char[*it], (void *)a->h_columns_char[*it], a->mRecCount*a->char_size[*it], cudaMemcpyHostToDevice);
            apply_permutation_char(a->d_columns_char[*it], raw_ptr, a->mRecCount, (char*)temp, a->char_size[*it]);
            cudaMemcpy( a->h_columns_char[*it], a->d_columns_char[*it], a->mRecCount*a->char_size[*it], cudaMemcpyDeviceToHost);
            a->deAllocColumnOnDevice(*it);
            if(update_str) {
                a->d_columns_int[*it].resize(a->mRecCount);
                cudaMemcpy( a->d_columns_char[*it], (void *)a->h_columns_char[*it], a->mRecCount*a->char_size[*it], cudaMemcpyHostToDevice);
                apply_permutation(a->d_columns_int[*it], raw_ptr, a->mRecCount, (int_type*)temp);
            }

        };
    };
    cudaFree(temp);
    thrust::device_free(permutation);
	
    for (auto it=field_names.begin(); it!=field_names.end(); ++it) {
        if (a->type[*it] == 0) {
            a->d_columns_int[*it].resize(a->mRecCount);
            thrust::copy(a->h_columns_int[*it].begin(), a->h_columns_int[*it].begin() + a->mRecCount, a->d_columns_int[*it].begin());
        }
        else if (a->type[*it] == 1) {
            a->d_columns_float[*it].resize(a->mRecCount);
            thrust::copy(a->h_columns_float[*it].begin(), a->h_columns_float[*it].begin() + a->mRecCount, a->d_columns_float[*it].begin());
        }
        else {
            a->allocColumnOnDevice(*it, a->mRecCount);
            cudaMemcpy( a->d_columns_char[*it], (void *)a->h_columns_char[*it], a->mRecCount*a->char_size[*it], cudaMemcpyHostToDevice);
        };
    };
}


void order_inplace(CudaSet* a, stack<string> exe_type, set<string> field_names, bool update_str)
{
    thrust::device_ptr<unsigned int> permutation = thrust::device_malloc<unsigned int>(a->mRecCount);
    thrust::sequence(permutation, permutation+a->mRecCount,0,1);

    unsigned int* raw_ptr = thrust::raw_pointer_cast(permutation);
    void* temp;
    CUDA_SAFE_CALL(cudaMalloc((void **) &temp, a->mRecCount*max_char(a, field_names)));

    for(; !exe_type.empty(); exe_type.pop()) {
        if (a->type[exe_type.top()] == 0)
            update_permutation(a->d_columns_int[exe_type.top()], raw_ptr, a->mRecCount, "ASC", (int_type*)temp);
        else if (a->type[exe_type.top()] == 1)
            update_permutation(a->d_columns_float[exe_type.top()], raw_ptr, a->mRecCount,"ASC", (float_type*)temp);
        else {
            // use int col int_col_count
            update_permutation(a->d_columns_int[exe_type.top()], raw_ptr, a->mRecCount, "ASC", (int_type*)temp);
        };
    };


    for (auto it=field_names.begin(); it!=field_names.end(); ++it) {
        if (a->type[*it] == 0) {
            apply_permutation(a->d_columns_int[*it], raw_ptr, a->mRecCount, (int_type*)temp);
        }
        else if (a->type[*it] == 1)
            apply_permutation(a->d_columns_float[*it], raw_ptr, a->mRecCount, (float_type*)temp);
        else {
            apply_permutation_char(a->d_columns_char[*it], raw_ptr, a->mRecCount, (char*)temp, a->char_size[*it]);
            if(update_str) {
                if(a->d_columns_int[*it].size() > 0) {
                    apply_permutation(a->d_columns_int[*it], raw_ptr, a->mRecCount, (int_type*)temp);
                };
            };
        };
    };
    cudaFree(temp);
    thrust::device_free(permutation);
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
			if(!star || !check_bitmap_file_exist(varNames[j1], varNames[op_join.front()])) {
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
    CudaSet* c = new CudaSet(op_sel_s, op_sel_s_as, op_join);

    bool str_join = 0;
    string f1, f2;
	map<string, string> key_map;
	map<string, char> sort_map;
	map<string, string> r_map;
	std::clock_t start1;

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

        //tab_map[op_jj.front()] = i;
		key_map[op_jj.front()] = f1;
		//cout << "Set " << op_jj.front() << " to " << f1 << endl;

        CudaSet* right = varNames.find(op_jj.front())->second;
		if(!check_bitmaps_exist(left, right)) {
			cout << "Required bitmap on table " << op_jj.front() << " doesn't exists" << endl;
			exit(0);		
		};
		//cout << "table " << op_jj.front() << " " << f2 << endl;
		
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
            load_queue(second, right, str_join, "", rcount, 0, right->segCount, 0,0); // put all used columns into GPU
		};				
    };


	queue<string> idx;
	set<string> already_loaded;		
    for (unsigned int i = 0; i < left->segCount; i++) {
		std::clock_t start2 = std::clock();
		if(verbose)
			cout << "segment " << i << " " << getFreeMem() <<  endl;
			
		idx = left->fil_value;	
		already_loaded.clear();
		start1 = std::clock();	
		while(!idx.empty()) {
			//load the index
			if(idx.front().find(".") != string::npos && (already_loaded.find(idx.front()) == already_loaded.end())) { 
				//extract table name and colname from index name	
				already_loaded.insert(idx.front());	
				size_t pos1 = idx.front().find_first_of(".", 0);
				size_t pos2 = idx.front().find_first_of(".", pos1+1);				
				CudaSet* r = varNames.find(idx.front().substr(pos1+1, pos2-pos1-1))->second;
				char a;
				a = left->loadIndex(idx.front(), i, r->char_size[idx.front().substr(pos2+1, string::npos)]);
				sort_map[idx.front().substr(pos1+1, pos2-pos1-1)] = a;
			};
			idx.pop();
		};
		std::cout<< "filter load " <<  ( ( std::clock() - start1 ) / (double)CLOCKS_PER_SEC ) << " " << getFreeMem() << endl;

		left->filtered = 0;
		size_t cnt_c = 0;
		allocColumns(left, left->fil_value);		
		copyColumns(left, left->fil_value, i, cnt_c);		
		bool* res = filter(left->fil_type, left->fil_value, left->fil_nums, left->fil_nums_f, left, i);				
        thrust::device_ptr<bool> star((bool*)res);
		size_t cnt = thrust::count(star, star + (unsigned int)left->mRecCount, 1);
		cout << "res " << cnt << " out of " << left->mRecCount << endl;
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
            CudaSet *t;
            unsigned int cnt1, bits;
            int_type lower_val;	
			thrust::device_vector<unsigned int> output(cnt);											
			//std::cout<< "seg start " <<  ( ( std::clock() - start1 ) / (double)CLOCKS_PER_SEC ) << " " << getFreeMem() << endl;

            while(!op_sel1.empty()) {
				
				if(std::find(left->columnNames.begin(), left->columnNames.end(), op_sel1.front()) !=  left->columnNames.end()) {
					//out << "Left " << op_sel1.front() << endl;					
										
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
							t->readSegmentsFromFile(i, op_sel1.front(), 0);
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
							cnt1 = ((unsigned int*)h)[0];
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
						
						//cout << "lower_val bits " << lower_val << " " << bits << endl;
						if(left->type[op_sel1.front()] == 0) 
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
							//cout << "Right " << op_sel1.front() << " " << it->first << " " << key_map[it->first] << endl;
							
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

								t->readSegmentsFromFile(i, key_map[it->first], 0);		
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
							   // cout << cnt1 << " " << lower_val << " " << bits << endl;														
						

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
									r->CopyColumnToGpu(r_map[key_map[it->first]]);									
								};	
								
								thrust::lower_bound(r->d_columns_int[r_map[key_map[it->first]]].begin(), r->d_columns_int[r_map[key_map[it->first]]].end(),
													output.begin(), output.end(),
													prm_tmp_d.begin());								
							};			

                            if(r->type[op_sel1.front()] == 0) {
                                thrust::device_ptr<int_type> d_tmp((int_type*)temp);
                                thrust::sequence(d_tmp, d_tmp+cnt,0,0);
                                thrust::gather(prm_tmp_d.begin(), prm_tmp_d.end(), r->d_columns_int[op_sel1.front()].begin(), d_tmp);
                                thrust::copy(d_tmp, d_tmp + cnt, c->h_columns_int[op_sel1.front()].begin() + offset);
                            }
                            else if(r->type[op_sel1.front()] == 1) {
                                thrust::device_ptr<float_type> d_tmp((float_type*)temp);
                                thrust::sequence(d_tmp, d_tmp+cnt,0,0);
                                thrust::gather(prm_tmp_d.begin(), prm_tmp_d.end(), r->d_columns_float[op_sel1.front()].begin(), d_tmp);
                                thrust::copy(d_tmp, d_tmp + cnt, c->h_columns_float[op_sel1.front()].begin() + offset);
                            }
                            else { //strings	
                                thrust::device_ptr<char> d_tmp((char*)temp);
                                thrust::fill(d_tmp, d_tmp+cnt*r->char_size[op_sel1.front()],0);	
                                str_gather(thrust::raw_pointer_cast(prm_tmp_d.data()), cnt, (void*)r->d_columns_char[op_sel1.front()],
                                           (void*) thrust::raw_pointer_cast(d_tmp), r->char_size[op_sel1.front()]);										   
                                cudaMemcpy( (void*)&c->h_columns_char[op_sel1.front()][offset*c->char_size[op_sel1.front()]], (void*) thrust::raw_pointer_cast(d_tmp),
                                            c->char_size[op_sel1.front()] * cnt, cudaMemcpyDeviceToHost);											
                            };
							break;
						};
					};
					
				};
				op_sel1.pop();
				//std::cout<<  ( ( std::clock() - start1 ) / (double)CLOCKS_PER_SEC ) << endl;
            };
			cudaFree(temp);
        };	
		//std::cout<< "SEG " << i << " "  <<  ( ( std::clock() - start2 ) / (double)CLOCKS_PER_SEC ) << " " << getFreeMem() << endl;
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
        if (stat.find(j1) == stat.end() && data_dict.count(j1) == 0) {
            process_error(2, "Join : couldn't find variable " + string(j1) );
        };
        if (stat.find(op_join.front()) == stat.end() && data_dict.count(op_join.front()) == 0) {
            process_error(2, "Join : couldn't find variable " + op_join.front() );
        };
        stat[s] = statement_count;
        stat[j1] = statement_count;
        check_used_vars();
        while(!op_join.empty()) {
            stat[op_join.front()] = statement_count;
            op_join.pop();
        };
        return;
    };

    queue<string> op_m(op_value);

	if(star && check_star_join(j1)) {
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

    if(stat[s] == statement_count) {
        varNames[s]->free();
        varNames.erase(s);
    };

    if(op_join.size()) {
        if(stat[op_join.front()] == statement_count && op_join.front().compare(j1) != 0) {
            varNames[op_join.front()]->free();
            varNames.erase(op_join.front());
        };
    };

}


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
	
	// check if there are join bitmap indexes
	
	//if(check_bitmaps_exist(left, right)) {
	//	cout << "Bitmap join" << endl;
	//	exit(0);
	//};	
	
	

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


    bool decimal_join = 0;
    if (left->type[colname1] == 1 && right->type[colname2]  == 1)
        decimal_join = 1;

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
    unsigned int r_parts = calc_right_partition(left, right, op_sel);
    //cout << "partitioned to " << r_parts << endl;
    unsigned int start_part = 0;
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
    MGPU_MEM(int) aIndicesDevice, bIndicesDevice;
    std::vector<int> j_data;

    stack<string> exe_type;
    set<string> field_names;
    exe_type.push(f2);
	for(unsigned int i = 0; i < right->columnNames.size(); i++) {
        if (std::find(c->columnNames.begin(), c->columnNames.end(), right->columnNames[i]) != c->columnNames.end() || right->columnNames[i] == f2) {
            field_names.insert(right->columnNames[i]);
        };
    };
	
    right->hostRecCount = right->mRecCount;
	
	thrust::device_vector<int> p_tmp;
    while(start_part < right->segCount) {

        bool rsz = 1;
        right->deAllocOnDevice();

        //cout << "loading " << start_part << " " << r_parts << " " << getFreeMem() << endl;

        if(start_part + r_parts >= right->segCount ) {
            cnt_r = load_right(right, colname2, f2, op_g1, op_sel, op_alt, decimal_join, str_join, rcount, start_part, right->segCount, rsz);
            start_part = right->segCount;
        }
        else {
            cnt_r = load_right(right, colname2, f2, op_g1, op_sel, op_alt, decimal_join, str_join, rcount, start_part, start_part+r_parts, rsz);
            start_part = start_part+r_parts;
        };
        right->mRecCount = cnt_r;
		//cout << "loaded right " << getFreeMem() << endl;
		
		if(thrust::is_sorted(right->d_columns_int[f2].begin(), right->d_columns_int[f2].end()) && right->d_columns_int[f2][0] == 1 && right->d_columns_int[f2][right->d_columns_int[f2].size()-1] == right->d_columns_int[f2].size())
			right->sort_check = '1';
		else 
			right->sort_check = '0';

        if(right->not_compressed && getFreeMem() < right->mRecCount*maxsz(right)*2) {
            right->CopyToHost(0, right->mRecCount);			
            right->deAllocOnDevice();
            if (left->type[colname1]  != 2) {
				if(getFreeMem() < right->mRecCount*maxsz(right)*4)
					order_inplace_host(right, exe_type, 0);
				else	
					order_inplace1(right, exe_type, field_names, 0);
			}	
            else 
				order_inplace1(right, exe_type, field_names, 1);
        }
        else {
            if (left->type[colname1]  != 2) {
                order_inplace(right, exe_type, field_names, 0);
			}	
            else {
                order_inplace(right, exe_type, field_names, 1);
            };
        };		
		
		cout << "ordered right " << getFreeMem() << endl;


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
            j_data.clear();

            //for (set<unsigned int>::iterator it = left->ref_joins[colInd1][i].begin(); it != left->ref_joins[colInd1][i].end(); it++) {
            //	cout << "seg match " << *it << endl;
            //};

            //for (set<unsigned int>::iterator it = right->orig_segs[left->ref_sets[colInd1]].begin(); it != right->orig_segs[left->ref_sets[colInd1]].end(); it++) {
            //	cout << "right segs " << *it << endl;
            //};
			if(!left->ref_joins.empty() && !right->orig_segs.empty()) {
				if(left->ref_joins[colname1][i].size() && right->orig_segs[left->ref_sets[colname1]].size()) {
					set_intersection(left->ref_joins[colname1][i].begin(),left->ref_joins[colname1][i].end(),
									right->orig_segs[left->ref_sets[colname1]].begin(), right->orig_segs[left->ref_sets[colname1]].end(),
									std::back_inserter(j_data));
					if(j_data.empty()) {
						cout << "skipping a segment " << endl;
						continue;
					};
				};
			};	
			
            cnt_l = 0;
			cout << "host " << left->hostRecCount << endl;
            if (left->type[colname1]  != 2) {
                copyColumns(left, lc, i, cnt_l);
				cout << "copied seg " << i << " " << cnt_l << endl;
            }
            else {
				if(left->filtered) {
					filter_op(left->fil_s, left->fil_f, i);
				};
                left->add_hashed_strings(f1, i);
            };
		

            if(!left->filtered) {
                if (left->type[colname1]  != 2)
                    cnt_l = left->mRecCount;
                else
                    cnt_l = left->d_columns_int[colname1].size();
            }
            else {
                cnt_l = left->mRecCount;
            };
			cout << "cnt_l " << cnt_l << " " << left->mRecCount << endl;

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

                if(do_sort)
                    thrust::sort_by_key(d_col, d_col + cnt_l, v_l.begin());
                else if(verbose)
                    cout << "No need of sorting " << endl;

                cout << "join " << cnt_l << ":" << cnt_r << " " << join_type.front() << endl;
                //cout << "SZ " << left->d_columns_int[colname1].size() << endl;


                if (left->d_columns_int[colname1][0] > right->d_columns_int[colname2][cnt_r-1] ||
                        left->d_columns_int[colname1][cnt_l-1] < right->d_columns_int[colname2][0]) {
                    cout << endl << "skipping after copying " << endl;
                    continue;
                };
                //else
                //    cout << "JOINING " << left->d_columns_int[colname1][0] << ":" << left->d_columns_int[colname1][cnt_l-1] << " AND " << right->d_columns_int[colname2][0] << ":" << right->d_columns_int[colname2][cnt_r-1] << endl;

                //cout << "joining " << left->d_columns_int[colname1][0] << " : " << left->d_columns_int[colname1][cnt_l-1] << " and " << right->d_columns_int[colname2][0] << " : " << right->d_columns_int[colname2][cnt_r-1] << endl;

                char join_kind = join_type.front();
				
				/*	if(cnt_r > 10) {	
                    for(int z = 0; z < 10 ; z++)
                    	cout << " R " << right->d_columns_int[colname2][z] << endl;

                    for(int z = 0; z < 10 ; z++)
                    	cout << " L " << left->d_columns_int[colname1][z] << endl;
					};	
				*/	
					
				

                if (left->type[colname1] == 2) {
                    thrust::device_ptr<int_type> d_col_r((int_type*)thrust::raw_pointer_cast(right->d_columns_int[colname2].data()));

                    res_count = RelationalJoin<MgpuJoinKindInner>(thrust::raw_pointer_cast(d_col), cnt_l,
                                thrust::raw_pointer_cast(d_col_r), cnt_r,
                                &aIndicesDevice, &bIndicesDevice,
                                mgpu::less<unsigned long long int>(), *context);

                }
                else {

                    if (join_kind == 'I')
                        res_count = RelationalJoin<MgpuJoinKindInner>(thrust::raw_pointer_cast(left->d_columns_int[colname1].data()), cnt_l,
                                    thrust::raw_pointer_cast(right->d_columns_int[colname2].data()), cnt_r,
                                    &aIndicesDevice, &bIndicesDevice,
                                    mgpu::less<int_type>(), *context);
                    else if(join_kind == 'L')
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
                };

				if(verbose)
					cout << "RES " << res_count << " seg " << i << endl;

                int* r1 = aIndicesDevice->get();
                thrust::device_ptr<int> d_res1((int*)r1);
                int* r2 = bIndicesDevice->get();
                thrust::device_ptr<int> d_res2((int*)r2);
				
                if(res_count) {
                    p_tmp.resize(res_count);
                    thrust::sequence(p_tmp.begin(), p_tmp.end(),-1);
                    thrust::gather_if(d_res1, d_res1+res_count, d_res1, v_l.begin(), p_tmp.begin(), is_positive<int>());
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

                    cout << "ADDITIONAL COL JOIN " << f3 << " " << f4 << " " << getFreeMem() << endl;

                    queue<string> rc;
                    rc.push(f3);

                    allocColumns(left, rc);
					//left->hostRecCount = left->mRecCount;                    
                    size_t offset = 0;
                    copyColumns(left, rc, i, offset, 0, 0);
                    rc.pop();

                    void* temp;
                    CUDA_SAFE_CALL(cudaMalloc((void **) &temp, res_count*float_size));
                    void* temp1;
                    CUDA_SAFE_CALL(cudaMalloc((void **) &temp1, res_count*float_size));
                    cudaMemset(temp,0,res_count*float_size);
                    cudaMemset(temp1,0,res_count*float_size);

                    if (res_count) {
                        thrust::device_ptr<bool> d_add = thrust::device_malloc<bool>(res_count);

                        if (left->type[f3] == 1 && right->type[f4]  == 1) {

                            if(right->d_columns_float[f4].size() == 0)
                                load_queue(rc, right, 0, f4, rcount, 0, right->segCount, 0, 0);

                            thrust::device_ptr<float_type> d_tmp((float_type*)temp);
                            thrust::device_ptr<float_type> d_tmp1((float_type*)temp1);
                            thrust::gather_if(p_tmp.begin(), p_tmp.end(), p_tmp.begin(), left->d_columns_float[f3].begin(), d_tmp, is_positive<int>());
                            thrust::gather_if(d_res2, d_res2+res_count, d_res2, right->d_columns_float[f4].begin(), d_tmp1, is_positive<int>());
                            thrust::transform(d_tmp, d_tmp+res_count, d_tmp1, d_add, float_equal_to());
                        }
                        else {
                            if(right->d_columns_int[f4].size() == 0) {
                                load_queue(rc, right, 0, f4, rcount, 0, right->segCount, 0, 0);
                            };	
						
                            thrust::device_ptr<int_type> d_tmp((int_type*)temp);
                            thrust::device_ptr<int_type> d_tmp1((int_type*)temp1);							
                            thrust::gather_if(p_tmp.begin(), p_tmp.end(), p_tmp.begin(), left->d_columns_int[f3].begin(), d_tmp, is_positive<int>());
                            thrust::gather_if(d_res2, d_res2+res_count, d_res2, right->d_columns_int[f4].begin(), d_tmp1, is_positive<int>());						
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
				
                tot_count = tot_count + res_count;

                if(res_count) {

                    for (auto itr = left->orig_segs.begin(); itr != left->orig_segs.end(); itr++) {
                        for (auto it = itr->second.begin(); it != itr->second.end(); it++) {
                            //cout << "LEFT SEGS " << itr->first << " : " << *it << endl;
                            c->orig_segs[itr->first].insert(*it);
                        };
                    };

                    for (auto itr = right->orig_segs.begin(); itr != right->orig_segs.end(); itr++) {
                        for (auto it = itr->second.begin(); it != itr->second.end(); it++) {
                            //cout << "RIGHT SEGS " << itr->first << " : " << *it << endl;
                            c->orig_segs[itr->first].insert(*it);
                        };
                    };
					
					//if(i == 0 && left->segCount != 1) {
					//	c->reserve(res_count*(left->segCount+1));
					//};

                    offset = c->mRecCount;
                    queue<string> op_sel1(op_sel_s);
                    c->resize_join(res_count);
                    void* temp;
                    CUDA_SAFE_CALL(cudaMalloc((void **) &temp, res_count*max_char(c)));

                    thrust::host_vector<unsigned int> prm_vh;
                    std::map<string,bool> processed;
					//bool cmp_type, copied = 0;

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

						if(std::find(left->columnNames.begin(), left->columnNames.end(), op_sel1.front()) !=  left->columnNames.end()) {
                                allocColumns(left, cc);
                                copyColumns(left, cc, i, k, 0, 0);
								
                                //gather
                                if(left->type[op_sel1.front()] == 0) {
                                    thrust::device_ptr<int_type> d_tmp((int_type*)temp);
                                    thrust::sequence(d_tmp, d_tmp+res_count,0,0);
                                    thrust::gather_if(p_tmp.begin(), p_tmp.begin() + res_count, p_tmp.begin(), left->d_columns_int[op_sel1.front()].begin(), d_tmp, is_positive<int>());
                                    thrust::copy(d_tmp, d_tmp + res_count, c->h_columns_int[op_sel1.front()].begin() + offset);
                                }
                                else if(left->type[op_sel1.front()] == 1) {
                                    thrust::device_ptr<float_type> d_tmp((float_type*)temp);
                                    thrust::sequence(d_tmp, d_tmp+res_count,0,0);
                                    thrust::gather_if(p_tmp.begin(), p_tmp.begin() + res_count, p_tmp.begin(), left->d_columns_float[op_sel1.front()].begin(), d_tmp, is_positive<int>());
                                    thrust::copy(d_tmp, d_tmp + res_count, c->h_columns_float[op_sel1.front()].begin() + offset);
                                }
                                else { //strings
                                    thrust::device_ptr<char> d_tmp((char*)temp);
                                    thrust::fill(d_tmp, d_tmp+res_count*left->char_size[op_sel1.front()],0);
                                    str_gather(thrust::raw_pointer_cast(p_tmp.data()), res_count, (void*)left->d_columns_char[op_sel1.front()],
                                               (void*) thrust::raw_pointer_cast(d_tmp), left->char_size[op_sel1.front()]);
                                    cudaMemcpy( (void*)&c->h_columns_char[op_sel1.front()][offset*c->char_size[op_sel1.front()]], (void*) thrust::raw_pointer_cast(d_tmp),
                                                c->char_size[op_sel1.front()] * res_count, cudaMemcpyDeviceToHost);
                                };


                                if(op_sel1.front() != colname1)
                                    left->deAllocColumnOnDevice(op_sel1.front());
                            }
						else if(std::find(right->columnNames.begin(), right->columnNames.end(), op_sel1.front()) !=  right->columnNames.end()) {

                            //gather
							std::clock_t start2 = std::clock();
                            if(right->type[op_sel1.front()] == 0) {
                                thrust::device_ptr<int_type> d_tmp((int_type*)temp);
                                thrust::sequence(d_tmp, d_tmp+res_count,0,0);
                                thrust::gather_if(d_res2, d_res2 + res_count, d_res2, right->d_columns_int[op_sel1.front()].begin(), d_tmp, is_positive<int>());
                                thrust::copy(d_tmp, d_tmp + res_count, c->h_columns_int[op_sel1.front()].begin() + offset);

                            }
                            else if(right->type[op_sel1.front()] == 1) {
                                thrust::device_ptr<float_type> d_tmp((float_type*)temp);
                                thrust::sequence(d_tmp, d_tmp+res_count,0,0);
                                thrust::gather_if(d_res2, d_res2 + res_count, d_res2, right->d_columns_float[op_sel1.front()].begin(), d_tmp, is_positive<int>());
                                thrust::copy(d_tmp, d_tmp + res_count, c->h_columns_float[op_sel1.front()].begin() + offset);
                            }
                            else { //strings
							
                                thrust::device_ptr<char> d_tmp((char*)temp);
                                thrust::fill(d_tmp, d_tmp+res_count*right->char_size[op_sel1.front()],0);
                                str_gather(thrust::raw_pointer_cast(d_res2), res_count, (void*)right->d_columns_char[op_sel1.front()],
                                           (void*) thrust::raw_pointer_cast(d_tmp), right->char_size[op_sel1.front()]);
                                cudaMemcpy( (void*)&c->h_columns_char[op_sel1.front()][offset*c->char_size[op_sel1.front()]], (void*) thrust::raw_pointer_cast(d_tmp),
                                            c->char_size[op_sel1.front()] * res_count, cudaMemcpyDeviceToHost);
											
                            };
                        }
                        else {
                        };
                        op_sel1.pop();
                    };
                    cudaFree(temp);
                };
            };
            //std::cout<< endl << "seg time " <<  ( ( std::clock() - start2 ) / (double)CLOCKS_PER_SEC ) << " " << getFreeMem() << endl;
        };
    };
	
	if(set_p) {
		if(p_tmp1)
			cudaFree(p_tmp1);
		cudaMalloc((void **) &p_tmp1, 4*p_tmp.size());
		thrust::device_ptr<int> d_tmp((int*)p_tmp1);
		p_sz = p_tmp.size();
		thrust::copy(p_tmp.begin(), p_tmp.end(), d_tmp);
	};	

    left->deAllocOnDevice();
    right->deAllocOnDevice();
    c->deAllocOnDevice();

    varNames[s] = c;
    c->mRecCount = tot_count;
    c->hostRecCount = tot_count;
    c->name = s;

    if(verbose)
        cout << endl << "tot res " << tot_count << " " << getFreeMem() << endl;

    size_t tot_size = 0;
    for (unsigned int i = 0; i < c->columnNames.size(); i++ ) {
        if(c->type[c->columnNames[i]] <= 1)
            tot_size = tot_size + tot_count*8;
        else
            tot_size = tot_size + tot_count*c->char_size[c->columnNames[i]];
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

        if (a->type[exe_type.top()] == 0)
            update_permutation_host(a->h_columns_int[exe_type.top()].data(), permutation, a->mRecCount, exe_value.top(), (int_type*)temp);
        else if (a->type[exe_type.top()] == 1)
            update_permutation_host(a->h_columns_float[exe_type.top()].data(), permutation, a->mRecCount,exe_value.top(), (float_type*)temp);
        else {
            update_permutation_char_host(a->h_columns_char[exe_type.top()], permutation, a->mRecCount, exe_value.top(), b->h_columns_char[exe_type.top()], a->char_size[exe_type.top()]);
        };
    };

    for (unsigned int i = 0; i < a->mColumnCount; i++) {
        if (a->type[a->columnNames[i]] == 0) {
            apply_permutation_host(a->h_columns_int[a->columnNames[i]].data(), permutation, a->mRecCount, b->h_columns_int[a->columnNames[i]].data());
        }
        else if (a->type[a->columnNames[i]] == 1)
            apply_permutation_host(a->h_columns_float[a->columnNames[i]].data(), permutation, a->mRecCount, b->h_columns_float[a->columnNames[i]].data());
        else {
            apply_permutation_char_host(a->h_columns_char[a->columnNames[i]], permutation, a->mRecCount, b->h_columns_char[a->columnNames[i]], a->char_size[a->columnNames[i]]);
        };
    };

    delete [] temp;
    delete [] permutation;
}



void emit_order(const char *s, const char *f, const int e, const int ll)
{
    if(ll == 0)
        statement_count++;

    if (scan_state == 0 && ll == 0) {
        if (stat.find(f) == stat.end() && data_dict.count(f) == 0) {
            process_error(2, "Order : couldn't find variable " + string(f));
        };
        stat[s] = statement_count;
        stat[f] = statement_count;
        return;
    };

    if (scan_state == 0)
        check_used_vars();

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
        thrust::device_ptr<unsigned int> permutation = thrust::device_malloc<unsigned int>(a->mRecCount);
        thrust::sequence(permutation, permutation+(a->mRecCount));

        unsigned int* raw_ptr = thrust::raw_pointer_cast(permutation);

        void* temp;
        CUDA_SAFE_CALL(cudaMalloc((void **) &temp, a->mRecCount*max_char(a)));

        if(a->filtered)
            varNames[a->source_name]->hostRecCount = varNames[a->source_name]->mRecCount;
        else
            a->hostRecCount = a->mRecCount;;

        size_t rcount;
        a->mRecCount = load_queue(names, a, 1, op_vx.front(), rcount, 0, a->segCount);

        if(a->filtered)
            varNames[a->source_name]->mRecCount = varNames[a->source_name]->hostRecCount;
        else
            a->mRecCount = a->hostRecCount;;


        for(int i=0; !exe_type.empty(); ++i, exe_type.pop(),exe_value.pop()) {
            if (a->type[exe_type.top()] == 0)
                update_permutation(a->d_columns_int[exe_type.top()], raw_ptr, a->mRecCount, exe_value.top(), (int_type*)temp);
            else if (a->type[exe_type.top()] == 1)
                update_permutation(a->d_columns_float[exe_type.top()], raw_ptr, a->mRecCount,exe_value.top(), (float_type*)temp);
            else {
                update_permutation_char(a->d_columns_char[exe_type.top()], raw_ptr, a->mRecCount, exe_value.top(), (char*)temp, a->char_size[exe_type.top()]);
                //update_permutation(a->d_columns_int[int_col_count+str_count], raw_ptr, a->mRecCount, exe_value.top(), (int_type*)temp);
                //str_count++;
            };
        };

        b->resize(a->mRecCount); //resize host arrays
        b->mRecCount = a->mRecCount;
        //str_count = 0;

        for (unsigned int i = 0; i < a->mColumnCount; i++) {
            if (a->type[a->columnNames[i]] == 0)
                apply_permutation(a->d_columns_int[a->columnNames[i]], raw_ptr, a->mRecCount, (int_type*)temp);
            else if (a->type[a->columnNames[i]] == 1)
                apply_permutation(a->d_columns_float[a->columnNames[i]], raw_ptr, a->mRecCount, (float_type*)temp);
            else {
                apply_permutation_char(a->d_columns_char[a->columnNames[i]], raw_ptr, a->mRecCount, (char*)temp, a->char_size[a->columnNames[i]]);
                //str_count++;
            };
        };

        for(unsigned int i = 0; i < a->mColumnCount; i++) {
            switch(a->type[a->columnNames[i]]) {
            case 0 :
                thrust::copy(a->d_columns_int[a->columnNames[i]].begin(), a->d_columns_int[a->columnNames[i]].begin() + a->mRecCount, b->h_columns_int[a->columnNames[i]].begin());
                break;
            case 1 :
                thrust::copy(a->d_columns_float[a->columnNames[i]].begin(), a->d_columns_float[a->columnNames[i]].begin() + a->mRecCount, b->h_columns_float[a->columnNames[i]].begin());
                break;
            default :
                cudaMemcpy(b->h_columns_char[a->columnNames[i]], a->d_columns_char[a->columnNames[i]], a->char_size[a->columnNames[i]]*a->mRecCount, cudaMemcpyDeviceToHost);
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


void emit_select(const char *s, const char *f, const int ll)
{

    statement_count++;
    if (scan_state == 0) {
        if (stat.find(f) == stat.end() && data_dict.count(f) == 0) {
            process_error(2, "Select : couldn't find variable " + string(f) );
        };
        stat[s] = statement_count;
        stat[f] = statement_count;
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

    while(!op_s.empty()) {
        if (a->type[op_s.top()] == 2) {
            a->d_columns_int[op_s.top()] = thrust::device_vector<int_type>(a->maxRecs);
        };
        op_s.pop();
    };

    bool one_liner;


    for(unsigned int i = 0; i < cycle_count; i++) {          // MAIN CYCLE
        if(verbose)
            cout << "segment " << i << " select mem " << getFreeMem() << endl;
        std::clock_t start3 = std::clock();

        cnt = 0;
        copyColumns(a, op_vx, i, cnt);
        op_s = op_v2;

        while(!op_s.empty() && a->mRecCount != 0 && a->not_compressed) {

            if (a->type[op_s.top()] == 2) {
                a->d_columns_int[op_s.top()].resize(0);
                a->add_hashed_strings(op_s.top(), i);
            };
            op_s.pop();
        };
		
        if(a->mRecCount) {
            if (ll != 0) {
                order_inplace(a, op_v2, field_names, 1);
                a->GroupBy(op_v2);
            };

            select(op_type,op_value,op_nums, op_nums_f,a,b, distinct_tmp, one_liner);

            if(i == 0)
                std::reverse(b->columnNames.begin(), b->columnNames.end());

            if(!b_set) {
                b_set = 1;
                unsigned int old_cnt = b->mRecCount;
                b->mRecCount = 0;
                b->resize(a->maxRecs);
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

                for(unsigned int j=0; j < b->columnNames.size(); j++) {
                    if (b->type[b->columnNames[j]] == 0) {
                        thrust::copy(b->d_columns_int[b->columnNames[j]].begin(), b->d_columns_int[b->columnNames[j]].begin() + b->mRecCount, c->h_columns_int[b->columnNames[j]].begin() + c_offset);
                    }
                    else if (b->type[b->columnNames[j]] == 1) {
                        thrust::copy(b->d_columns_float[b->columnNames[j]].begin(), b->d_columns_float[b->columnNames[j]].begin() + b->mRecCount, c->h_columns_float[b->columnNames[j]].begin() + c_offset);
                    }
                    else {
                        cudaMemcpy((void*)(thrust::raw_pointer_cast(c->h_columns_char[b->columnNames[j]] + b->char_size[b->columnNames[j]]*c_offset)), (void*)thrust::raw_pointer_cast(b->d_columns_char[b->columnNames[j]]),
                                   b->char_size[b->columnNames[j]] * b->mRecCount, cudaMemcpyDeviceToHost);
                    };
                };
            };
        };
        //std::cout<< "cycle sel time " <<  ( ( std::clock() - start3 ) / (double)CLOCKS_PER_SEC ) << " " << getFreeMem() << '\n';
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
    //cout << "select res " << c->mRecCount << endl;


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


void emit_insert(const char *f, const char* s) {
    statement_count++;
    if (scan_state == 0) {
        if (stat.find(f) == stat.end() && data_dict.count(f) == 0) {
            process_error(2, "Insert : couldn't find variable " + string(f));
        };
        if (stat.find(s) == stat.end() && data_dict.count(s) == 0) {
            process_error(2, "Insert : couldn't find variable " + string(s) );
        };
        check_used_vars();
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

void emit_mulite(const char *f)
{

};


void emit_delete(const char *f)
{
    statement_count++;
    if (scan_state == 0) {
        if (stat.find(f) == stat.end()  && data_dict.count(f) == 0) {
            process_error(2, "Delete : couldn't find variable " + string(f));
        };
        stat[f] = statement_count;
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

void emit_create_bitmap_index(const char *index_name, const char *ltable, const char *rtable, const char *rcolumn, const char *lid, const char *rid)
{
	statement_count++;	
	if (scan_state == 0) {		
		emit_name(rcolumn);
		emit_sel_name(rcolumn);
		emit_name(lid);
		emit_name(rid);
		emit_eq();
		emit_join_tab(rtable,'I');	
		check_used_vars();		
		stat["BITMAP"] = std::numeric_limits<unsigned int>::max();
		stat[rtable] = std::numeric_limits<unsigned int>::max();
		stat[ltable] = std::numeric_limits<unsigned int>::max();
	}	
	else {
		CudaSet* left = varNames.find(ltable)->second;		
		set_p = 1;
		for(int i = 0; i < left->segCount; i++) {
			emit_name(rcolumn);
			emit_sel_name(rcolumn);
			emit_name(lid);
			emit_name(rid);
			emit_eq();
			emit_join_tab(rtable,'I');
			emit_join("BITMAP", ltable, 0, i, i+1);			
			CudaSet* res = varNames.find("BITMAP")->second;		
			
			thrust::host_vector<unsigned int> s_tmp(p_sz);
			thrust::device_ptr<int> d_tmp((int*)p_tmp1);
			thrust::copy(d_tmp, d_tmp + p_sz, s_tmp.begin());
			thrust::device_free(d_tmp);
			p_tmp1 = 0;
			
			string str = std::string(ltable) + std::string(".") + std::string(rtable) + std::string(".") + std::string(rcolumn) + std::string(".") + to_string(i);
			
            if(res->type[rcolumn] == 0) {
                int_type* d_tmp = new int_type[res->mRecCount];
                thrust::scatter(res->h_columns_int[rcolumn].begin(), res->h_columns_int[rcolumn].begin() + res->mRecCount,
								s_tmp.begin(), d_tmp);
                thrust::copy(d_tmp, d_tmp + res->mRecCount, res->h_columns_int[rcolumn].begin());
				delete [] d_tmp;
				res->compress_int(str, rcolumn, res->mRecCount);
				check_sort(str, rtable, rid);
            }
            else if(res->type[rcolumn] == 1) {
                float_type* d_tmp = new float_type[res->mRecCount];
                thrust::scatter(res->h_columns_float[rcolumn].begin(), res->h_columns_float[rcolumn].begin() + res->mRecCount,
								s_tmp.begin(), d_tmp);
                thrust::copy(d_tmp, d_tmp + res->mRecCount, res->h_columns_float[rcolumn].begin());				
				delete [] d_tmp;				
            }
            else { //strings							
                char* d_tmp = new char[res->mRecCount*res->char_size[rcolumn]];
				memset(d_tmp, 0, res->mRecCount*res->char_size[rcolumn]);
                str_scatter_host(thrust::raw_pointer_cast(s_tmp.data()), res->mRecCount, (void*)res->h_columns_char[rcolumn],
                                (void*)d_tmp, res->char_size[rcolumn]);							
				memcpy(res->h_columns_char[rcolumn], d_tmp, res->mRecCount*res->char_size[rcolumn]);					
				delete [] d_tmp;				
				res->compress_char(str, rcolumn, res->mRecCount, 0);
				check_sort(str, rtable, rid);
            };	
			
		};	
		set_p = 0;
	};	
}

void emit_display(const char *f, const char* sep)
{
    statement_count++;
    if (scan_state == 0) {
        if (stat.find(f) == stat.end() && data_dict.count(f) == 0) {
            process_error(2, "Filter : couldn't find variable " + string(f) );
        };
        stat[f] = statement_count;
        //check_used_vars();
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

    //a->Store("",sep, limit, 0, 1);
    a->Display(limit, 0, 1);
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
        if (stat.find(f) == stat.end() && data_dict.count(f) == 0) {
            process_error(1, "Filter : couldn't find variable " + string(f));
            //cout << "Filter : couldn't find variable " << f << endl;
            //exit(1);
        };
        stat[s] = statement_count;
        stat[f] = statement_count;
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
        b->filtered = 1;
		b->tmp_table = a->tmp_table;
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

            while(!a->fil_nums_f.empty()) {
                b->fil_nums_f.push(a->fil_nums_f.front());
                a->fil_nums_f.pop();
            };
            a->filtered = 0;
            //a->free();
            varNames.erase(f);
        }
        else
            b->source_name = f;
        b->maxRecs = a->maxRecs;
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

void emit_store(const char *s, const char *f, const char* sep)
{
    statement_count++;
    if (scan_state == 0) {
        if (stat.find(s) == stat.end() && data_dict.count(s) == 0) {
            process_error(2, "Store : couldn't find variable " + string(s) );
        };
        stat[s] = statement_count;
        //check_used_vars();
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

    a->Store(f,sep, limit, 0);

    if(stat[s] == statement_count  && a->keep == 0) {
        a->free();
        varNames.erase(s);
    };
};


void emit_store_binary(const char *s, const char *f)
{
    statement_count++;
    if (scan_state == 0) {
        if (stat.find(s) == stat.end() && data_dict.count(s) == 0) {
            process_error(2, "Store : couldn't find variable " + string(s));
        };
        stat[s] = statement_count;
        //check_used_vars();
        clean_queues();
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
            if (!file_p) {
                process_error(2, "Could not open file " + a->load_file_name );
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


void emit_load_binary(const char *s, const char *f, const int d)
{
    statement_count++;
    if (scan_state == 0) {
        stat[s] = statement_count;
        return;
    };

    if(verbose)
        printf("BINARY LOAD: %s \n", s, f);

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


void emit_load(const char *s, const char *f, const int d, const char* sep)
{
    statement_count++;
    if (scan_state == 0) {
        stat[s] = statement_count;
        return;
    };

    printf("LOAD: %s %s %d  %s \n", s, f, d, sep);

    CudaSet *a;

    a = new CudaSet(namevars, typevars, sizevars, cols, process_count, references, references_names);
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

void
alenkaSetSegSize(long segsize) {
 process_count = segsize;
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
    while(!references_names.empty()) references_names.pop();
    while(!op_presort.empty()) op_presort.pop();
	while(!join_type.empty()) join_type.pop();

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
            if(stat.count((*it).first) != 0) {
                auto c = (*it).second;
                for (auto sit=c.begin() ; sit != c.end(); ++sit ) {
                    //cout << "name " << (*sit).first << endl;
                    namevars.push((*sit).first);
                    if(data_dict[(*it).first][(*sit).first].col_type == 0)
                        typevars.push("int");
                    else if(data_dict[(*it).first][(*sit).first].col_type == 1)
                        typevars.push("float");
                    else if(data_dict[(*it).first][(*sit).first].col_type == 3)
                        typevars.push("decimal");
                    else typevars.push("char");
                    sizevars.push(data_dict[(*it).first][(*sit).first].col_length);
                    cols.push(0);
                };
                emit_load_binary((*it).first.c_str(), (*it).first.c_str(), 0);
            };
        };
    };
}


int execute_file(int ac, char **av)
{
    bool just_once  = 0;
    string script;

    process_count = 6200000;
    verbose = 0;
	ssd = 0;
	delta = 0;
	star = 0;
    total_buffer_size = 0;
	hash_seed = 100;

    for (int i = 1; i < ac; i++) {
        if(strcmp(av[i],"-l") == 0) {
            process_count = atoff(av[i+1]);
        }
        else if(strcmp(av[i],"-v") == 0) {
            verbose = 1;
        }
        else if(strcmp(av[i],"-star") == 0) {
            star = 1;
        }				
        else if(strcmp(av[i],"-delta") == 0) {
            delta = 1;
        }		
        else if(strcmp(av[i],"-ssd") == 0) {
            ssd = 1;
        }		
        else if(strcmp(av[i],"-i") == 0) {
            interactive = 1;
            break;
        }
        else if(strcmp(av[i],"-s") == 0) {
            just_once = 1;
            interactive = 1;
            script = av[i+1];
        };
    };

    load_col_data(data_dict, "data.dictionary");

    if (!interactive) {
        if((yyin = fopen(av[ac-1], "r")) == nullptr) {
            perror(av[ac-1]);
            exit(1);
        };

        if(yyparse()) {
            printf("SQL scan parse failed\n");
            exit(1);
        };

        scan_state = 1;
        std::clock_t start1 = std::clock();

        load_vars();
		
        statement_count = 0;
        clean_queues();

        yyin = fopen(av[ac-1], "r");
        PROC_FLUSH_BUF ( yyin );
        statement_count = 0;

        extern FILE *yyin;
        context = CreateCudaDevice(0, nullptr, verbose);

        if(!yyparse()) {
            if(verbose)
                cout << "SQL scan parse worked " << endl;
        }
        else
            cout << "SQL scan parse failed" << endl;

        fclose(yyin);
        for (auto it=varNames.begin() ; it != varNames.end(); ++it ) {
            (*it).second->free();
        };

        if(verbose) {
            cout<< "cycle time " << ( ( std::clock() - start1 ) / (double)CLOCKS_PER_SEC ) << " " << getFreeMem() << endl;
        };
    }
    else {
        context = CreateCudaDevice(0, nullptr, verbose);        
        if(!just_once)
            getline(cin, script);

        while (script != "exit" && script != "EXIT") {

            used_vars.clear();
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

            load_vars();

            statement_count = 0;
            clean_queues();
            yy_scan_string(script.c_str());
            std::clock_t start1 = std::clock();

            if(!yyparse()) {
                if(verbose)
                    cout << "SQL scan parse worked " <<  endl;
            };
            for (auto it=varNames.begin() ; it != varNames.end(); ++it ) {
                (*it).second->free();
            };
            varNames.clear();

            if(verbose) {
                cout<< "cycle time " << ( ( std::clock() - start1 ) / (double)CLOCKS_PER_SEC ) << endl;
            };
            if(!just_once)
                getline(cin, script);
            else
                script = "exit";
        };

        while(!buffer_names.empty()) {
            delete [] buffers[buffer_names.front()];
            buffer_sizes.erase(buffer_names.front());
            buffers.erase(buffer_names.front());
            buffer_names.pop();
        };
		for(auto it = index_buffers.begin(); it != index_buffers.end();it++) {
			cudaFreeHost(it->second);
        };

    };
    if(save_dict)
        save_col_data(data_dict,"data.dictionary");

    if(alloced_sz) {
        cudaFree(alloced_tmp);
        alloced_sz = 0;
    };
    if(raw_decomp_length) {
        cudaFree(raw_decomp);
        raw_decomp_length = 0;
    };

    return 0;
}



//external c global to report errors
//char alenka_err[4048];


int alenkaExecute(char *s)
{
    YY_BUFFER_STATE bp;

    total_buffer_size = 0;
    scan_state = 0;
    load_col_data(data_dict, "data.dictionary");
    std::clock_t start;

    if(verbose)
        start = std::clock();
    bp = yy_scan_string(s);
    yy_switch_to_buffer(bp);
    int ret = yyparse();
    //printf("execute: returned [%d]\n", ret);
    if(!ret) {
        if(verbose)
            cout << "SQL scan parse worked" << endl;
    }

    scan_state = 1;
    load_vars();
    statement_count = 0;
    clean_queues();
    bp = yy_scan_string(s);
    yy_switch_to_buffer(bp);
    if(!yyparse()) {
        if(verbose)
            cout << "SQL scan parse worked " << endl;
    }
    else
        cout << "SQL scan parse failed" << endl;

    yy_delete_buffer(bp);

    // Clear Vars
    for (auto it=varNames.begin() ; it != varNames.end(); ++it ) {
        (*it).second->free();
    };
    varNames.clear();

    if(verbose)
        cout<< "statement time " <<  ( ( std::clock() - start ) / (double)CLOCKS_PER_SEC ) << endl;
    if(save_dict)
        save_col_data(data_dict,"data.dictionary");
    return ret;
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
    process_count = 6200000;
    verbose = 0;
    scan_state = 1;
    statement_count = 0;
    clean_queues();
    context = CreateCudaDevice(0, nullptr, true);
    printf("Alenka initialised\n");
}


void alenkaClose()
{
    statement_count = 0;

    if(alloced_sz){
		cudaFree(alloced_tmp);
		alloced_sz = 0;
	};
	if(raw_decomp_length) {
		cudaFree(raw_decomp);
		raw_decomp_length = 0;
	};
	printf("Alenka closed\n");
}






