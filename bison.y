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

#include <stdlib.h>
#include <stack>
#include "lex.yy.c"
#include "cm.cu"


    void clean_queues();
    void order_inplace(CudaSet* a, stack<string> exe_type);
    void yyerror(char *s, ...);
    void emit(char *s, ...);
    void emit_mul();
    void emit_add();
    void emit_minus();
    void emit_div();
    void emit_and();
    void emit_eq();
    void emit_or();
    void emit_cmp(int val);
    void emit_var(char *s, int c, char *f);
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
    void emit_varchar(char *s, int c, char *f, int d);
    void emit_load(char *s, char *f, int d, char* sep, bool stream);
    void emit_load_binary(char *s, char *f, int d, bool stream);
    void emit_store(char *s, char *f, char* sep);
    void emit_store_binary(char *s, char *f, char* sep);
    void emit_store_binary(char *s, char *f);
    void emit_filter(char *s, char *f, int e);
    void emit_order(char *s, char *f, int e, int ll = 0);
    void emit_group(char *s, char *f, int e);
    void emit_select(char *s, char *f, int ll);
    void emit_join(char *s, char *j1);
    void emit_join_tab(char *s);
    void emit_distinct(char *s, char *f);

%}

%union {
    int intval;
    float floatval;
    char *strval;
    int subtok;
}

%token <strval> FILENAME
%token <strval> NAME
%token <strval> STRING
%token <intval> INTNUM
%token <intval> DECIMAL
%token <intval> BOOL
%token <floatval> APPROXNUM
/* user @abc names */
%token <strval> USERVAR
/* operators and precedence levels */
%right ASSIGN
%right EQUAL
%left OR
%left XOR
%left AND
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

%token AND
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


%type <intval> load_list  opt_where opt_limit
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
{  emit_load($1, $4, $11, $7, 0); } ;
| NAME ASSIGN STREAM FILENAME USING '(' FILENAME ')' AS '(' load_list ')'
{  emit_load($1, $4, $11, $7, 1); } ;
| NAME ASSIGN STREAM FILENAME BINARY AS '(' load_list ')'
{  emit_load_binary($1, $4, $8, 1); } ;
| NAME ASSIGN LOAD FILENAME BINARY AS '(' load_list ')'
{  emit_load_binary($1, $4, $8, 0); } ;
| NAME ASSIGN FILTER NAME opt_where
{  emit_filter($1, $4, $5);}
| NAME ASSIGN ORDER NAME BY opt_val_list
{  emit_order($1, $4, $6);}
| NAME ASSIGN SELECT expr_list FROM NAME join_list
{ emit_join($1,$6); }
| STORE NAME INTO FILENAME USING '(' FILENAME ')' opt_limit
{ emit_store($2,$4,$7); }
| STORE NAME INTO FILENAME opt_limit BINARY
{ emit_store_binary($2,$4); }
;

expr:
NAME { emit_name($1); }
| NAME '.' NAME { emit("FIELDNAME %s.%s", $1, $3); }
| USERVAR { emit("USERVAR %s", $1); }
| STRING { emit_string($1); }
| INTNUM { emit_number($1); }
| APPROXNUM { emit_float($1); }
| DECIMAL { emit_decimal($1); }
| BOOL { emit("BOOL %d", $1); }
| NAME '{' INTNUM '}' ':' NAME '(' INTNUM ')' { emit_varchar($1, $3, $6, $8);}
| NAME '{' INTNUM '}' ':' NAME  { emit_var($1, $3, $6);}
| NAME ASC { emit_var_asc($1);}
| NAME DESC { emit_var_desc($1);}
| COUNT '(' expr ')' { emit_count(); }
| SUM '(' expr ')' { emit_sum(); }
| AVG '(' expr ')' { emit_average(); }
| MIN '(' expr ')' { emit_min(); }
| MAX '(' expr ')' { emit_max(); }
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
;

expr:
expr IS BOOL { emit("ISBOOL %d", $3); }
| expr IS NOT BOOL { emit("ISBOOL %d", $4); emit("NOT"); }
;

opt_group_list: { /* nil */
    $$ = 0;
}
| GROUP BY val_list { $$ = $3}


expr_list:
expr AS NAME { $$ = 1; emit_sel_name($3);}
| expr_list ',' expr AS NAME { $$ = $1 + 1; emit_sel_name($5);}
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

join_list:
JOIN NAME ON expr { $$ = 1; emit_join_tab($2);}
| JOIN NAME ON expr join_list { $$ = 1; emit_join_tab($2); };

opt_limit: { /* nil */
    $$ = 0
}
     | LIMIT INTNUM { emit_limit($2); };


%%

struct float_to_decimal
{
    __host__ __device__
    float_type operator()(const float_type x)
    {
        return (int_type)(x*100);
    }
};



#include <iostream>
#include <queue>
#include <string>
#include <map>
#include <set>
#include "join.cu"
#include "filter.cu"
#include "select.cu"
#include "merge.cu"
#include "zone_map.cu"

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
typedef long off_t;
#endif



bool fact_file_exists = 0;
FILE *file_pointer;
string fact_file_name = "NULL";
long long int stream_pos = 0;
unsigned int lc = 0;
queue<string> namevars;
queue<string> typevars;
queue<int> sizevars;
queue<int> cols;
queue<string> op_type;
queue<string> op_value;
queue<int_type> op_nums;
queue<float_type> op_nums_f;

queue<unsigned int> j_col_count;
unsigned int sel_count = 0;
unsigned int join_cnt = 0;
int join_col_cnt = 0;
unsigned int eqq = 0;
stack<string> op_join;

//  STL map to manage CudaSet variables
map<string,CudaSet*> varNames;
unsigned int orig_recCount;
unsigned int statement_count = 0;
map<string,unsigned int> stat;
bool scan_state = 0;


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

void emit_and()
{
    op_type.push("AND");
    if (join_col_cnt == -1)
        join_col_cnt++;
    join_col_cnt++;
    eqq = 0;
}

void emit_eq()
{
    //op_type.push("JOIN");
    eqq++;
    join_cnt++;
    if(eqq == join_col_cnt+1) {
        j_col_count.push(join_col_cnt+1);
        join_col_cnt = -1;
    }
    else if (join_col_cnt == -1 )
        j_col_count.push(1);

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


void emit_var(char *s, int c, char *f)
{
    namevars.push(s);
    typevars.push(f);
    sizevars.push(0);
    cols.push(c);
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


void emit_varchar(char *s, int c, char *f, int d)
{
    namevars.push(s);
    typevars.push(f);
    sizevars.push(d);
    cols.push(c);
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

void emit_join_tab(char *s)
{
    op_join.push(s);
};




thrust::device_ptr<unsigned int> order_inplace(CudaSet* a, stack<string> exe_type, set<string> field_names)
{
    thrust::device_ptr<unsigned int> permutation = thrust::device_malloc<unsigned int>(a->mRecCount);
    thrust::sequence(permutation, permutation+(a->mRecCount));

    unsigned int* raw_ptr = thrust::raw_pointer_cast(permutation);
    void* temp;
    CUDA_SAFE_CALL(cudaMalloc((void **) &temp, a->mRecCount*float_size));


    for(int i=0; !exe_type.empty(); ++i, exe_type.pop()) {

        int colInd = (a->columnNames).find(exe_type.top())->second;
        if ((a->type)[colInd] == 0)
            update_permutation(thrust::raw_pointer_cast((a->d_columns_int[a->type_index[colInd]]).data()), raw_ptr, a->mRecCount, "ASC", (int_type*)temp);
        else if ((a->type)[colInd] == 1)
            update_permutation(thrust::raw_pointer_cast((a->d_columns_float[a->type_index[colInd]]).data()), raw_ptr, a->mRecCount,"ASC", (float_type*)temp);
        else {
            CudaChar* c = a->h_columns_cuda_char[a->type_index[colInd]];
            for(int j=(c->mColumnCount)-1; j>=0 ; j--)
                update_permutation_char((c->d_columns)[j], raw_ptr, a->mRecCount, (char*)temp, "ASC");
        };
    };

    for (set<string>::iterator it=field_names.begin(); it!=field_names.end(); ++it) {
        int i = a->columnNames[*it];
        if ((a->type)[i] == 0)
            apply_permutation(thrust::raw_pointer_cast((a->d_columns_int[a->type_index[i]]).data()), raw_ptr, a->mRecCount, (int_type*)temp);
        else if ((a->type)[i] == 1)
            apply_permutation(thrust::raw_pointer_cast((a->d_columns_float[a->type_index[i]]).data()), raw_ptr, a->mRecCount, (float_type*)temp);
        else {
            CudaChar* c = a->h_columns_cuda_char[a->type_index[i]];
            for(int j=(c->mColumnCount)-1; j>=0 ; j--)
                apply_permutation_char((c->d_columns)[j], raw_ptr, a->mRecCount, (char*)temp);
        };
    };
    cudaFree(temp);
    return permutation;
}




void emit_join(char *s, char *j1)
{
    string j2 = op_join.top();
    op_join.pop();

    statement_count++;
    if (scan_state == 0) {
        if (stat.find(j1) == stat.end()) {
            cout << "Join : couldn't find variable " << j1 << endl;
            exit(1);
        };
        if (stat.find(j2) == stat.end()) {
            cout << "Join : couldn't find variable " << j2 << endl;
            exit(1);
        };
        stat[s] = statement_count;
        stat[j1] = statement_count;
        stat[j2] = statement_count;
        return;
    };


    if(varNames.find(j1) == varNames.end() || varNames.find(j2) == varNames.end()) {
        clean_queues();
        return;
    };


//    while(!op_join.empty()) {
//	  cout << "JOIN TBL " << op_join.top() << endl;
//	  op_join.pop();
//	};

    //cout << "join cnt " << join_cnt << endl;

    //while(!op_value.empty()) {
    //  cout << "JOIN COL " << op_value.front() << endl;;
    //  op_value.pop();
    //};

    //while(!j_col_count.empty()) {
    //  cout << "JOIN AND " << j_col_count.front() << endl;;
    //  j_col_count.pop();
    //};


    CudaSet* left = varNames.find(j1)->second;
    CudaSet* right = varNames.find(j2)->second;

    if(left->readyToProcess == 0 || right->readyToProcess == 0)
        return;

    if (left->fact_table == 0 && right->fact_table == 0 && lc > 1)
        return;


    queue<string> op_sel;
    queue<string> op_sel_as;
    for(int i=0; i < sel_count; i++) {
        op_sel.push(op_value.front());
        op_value.pop();
        op_sel_as.push(op_value.front());
        op_value.pop();
    };

    string f1 = op_value.front();
    op_value.pop();
    string f2 = op_value.front();
    op_value.pop();

    printf("emit join: %s %s  \n", s, j1);

    std::clock_t start1 = std::clock();
    CudaSet* c;

    if (left->mRecCount == 0 || right->mRecCount == 0) {
        c = new CudaSet(left,right,0, op_sel, op_sel_as);
        c->readyToProcess = 1;
        if (left->fact_table == 1 || right->fact_table == 1)
            c->fact_table = 1;
        varNames[s] = c;
        clean_queues();
        return;
    };


    unsigned int colInd1 = (left->columnNames).find(f1)->second;
    unsigned int colInd2 = (right->columnNames).find(f2)->second;

    bool left_in_gpu = 0;
    bool right_in_gpu = 0;

    if(left->onDevice(0))
        left_in_gpu = 1;
    if(right->onDevice(0))
        right_in_gpu = 1;

    //cout << "in gpu " << left_in_gpu << " " << right_in_gpu << endl;
    //cout << "facts " << left->fact_table << " " << right->fact_table << endl;


    set<string> field_names;
    stack<string> exe_type;
    exe_type.push(f2);
    field_names.insert(f2);


    // check if already sorted
    //cout << "alloced " << left->maxRecs << " " << right->mRecCount << endl;
    //cout << "seg counts " << left->segCount << " " << right->segCount << endl;

    //right->Store("f1.txt","|",1000000,0);

    if(!right_in_gpu) {
        right->allocColumnOnDevice(colInd2, right->mRecCount);
        right->CopyColumnToGpu(colInd2);
    };

    if(lc == 1 || right->fact_table) {

        //thrust::device_ptr<int_type> r((int_type*)(right->d_columns[colInd2]));
        if(!thrust::is_sorted(right->d_columns_int[right->type_index[colInd2]].begin(), right->d_columns_int[right->type_index[colInd2]].begin() + right->mRecCount)) {

            thrust::device_ptr<unsigned int> perm = order_inplace(right, exe_type, field_names);
            unsigned int* raw_ptr = thrust::raw_pointer_cast(perm);
            void* temp;
            cudaMalloc((void **) &temp, right->mRecCount*float_size);

            for(int i = 0; i < right->mColumnCount; i++) {

                if(i != colInd2 && !right_in_gpu) {
                    right->allocColumnOnDevice(i, right->mRecCount);
                    right->CopyColumnToGpu(i);
                };

                if ((right->type)[i] == 0 && i != colInd2)
                    apply_permutation(thrust::raw_pointer_cast((right->d_columns_int[right->type_index[i]]).data()), raw_ptr, right->mRecCount, (int_type*)temp);
                else if ((right->type)[i] == 1 && i != colInd2)
                    apply_permutation(thrust::raw_pointer_cast((right->d_columns_float[right->type_index[i]]).data()), raw_ptr, right->mRecCount, (float_type*)temp);
                else if (i != colInd2) {
                    CudaChar* c = right->h_columns_cuda_char[right->type_index[i]];
                    for(int j=(c->mColumnCount)-1; j>=0 ; j--)
                        apply_permutation_char((c->d_columns)[j], raw_ptr, right->mRecCount, (char*)temp);
                };

                if(i != colInd2 && !right_in_gpu) {
                    right->CopyColumnToHost(i);
                    right->deAllocColumnOnDevice(i);
                };

            };
            thrust::device_free(perm);
            cudaFree(temp);
        };
    };

    if (!left_in_gpu)
        left->allocColumnOnDevice(colInd1, left->maxRecs);
    //cout << "alloc max segment " << left->maxRecs << endl;

    thrust::device_vector<unsigned int> d_res1;
    thrust::device_vector<unsigned int> d_res2;

    for(int i = 0; i < left->segCount; i ++) {  // Main piece cycle

        //cout << "cycle start " << getFreeMem() << endl;

        if (!left_in_gpu )
            left->CopyColumnToGpu(colInd1, i);

        std::clock_t start2 = std::clock();

        //cout << "right:left " << right->mRecCount << " " << left->mRecCount << endl;

        //cout << "right col is unique : " << right->isUnique(colInd2) << endl;


        if ((left->type)[colInd1] == 0 && (right->type)[colInd2]  == 0) {
            join(thrust::raw_pointer_cast(right->d_columns_int[right->type_index[colInd2]].data()), thrust::raw_pointer_cast(left->d_columns_int[left->type_index[colInd1]].data()),
                 d_res1, d_res2, left->mRecCount, right->mRecCount, right->isUnique(colInd2));
        }
        else if ((left->type)[colInd1] == 2 && (right->type)[colInd2]  == 2)
            join(right->h_columns_cuda_char[right->type_index[colInd2]], left->h_columns_cuda_char[left->type_index[colInd1]], d_res1, d_res2);
        else if ((left->type)[colInd1] == 1 && (right->type)[colInd2]  == 1) {
            thrust::device_ptr<int_type> dev_ptr_int_left = thrust::device_malloc<int_type>(left->mRecCount);
            thrust::device_ptr<int_type> dev_ptr_int_right = thrust::device_malloc<int_type>(right->mRecCount);

            thrust::transform(left->d_columns_float[left->type_index[colInd1]].begin(), left->d_columns_float[left->type_index[colInd1]].begin() + left->mRecCount,
                              dev_ptr_int_left, float_to_decimal());
            thrust::transform(right->d_columns_float[right->type_index[colInd1]].begin(), right->d_columns_float[right->type_index[colInd1]].begin() + right->mRecCount,
                              dev_ptr_int_right, float_to_decimal());
            join(thrust::raw_pointer_cast(dev_ptr_int_right), thrust::raw_pointer_cast(dev_ptr_int_left),
                 d_res1, d_res2, left->mRecCount, right->mRecCount, 0);

            thrust::device_free(dev_ptr_int_left);
            thrust::device_free(dev_ptr_int_right);
        };


        // Here we need to add possible joins on other columns
        queue<string> op_value1(op_value);
        while(!op_value1.empty()) {
            f1 = op_value1.front();
            op_value1.pop();
            f2 = op_value1.front();
            op_value1.pop();

            colInd1 = (left->columnNames).find(f1)->second;
            colInd2 = (right->columnNames).find(f2)->second;

            if(left->type[colInd1] != right->type[colInd2]) {
                cout << "Cannot do join on columns of different types : " << f1 << " " << f2 << endl;
                exit(1);
            };

            if (!right_in_gpu) {
                right->allocColumnOnDevice(colInd2, right->mRecCount);
                right->CopyColumnToGpu(colInd2);
            };
            if (!left_in_gpu) {
                left->allocColumnOnDevice(colInd1, left->maxRecs);
                left->CopyColumnToGpu(colInd1, i);
            };

            void* d1;
            void* d2;
            if (right->type[colInd2] == 0 ) {
                //thrust::device_ptr<int_type> src1((int_type*)(right->d_columns)[colInd2]);
                CUDA_SAFE_CALL(cudaMalloc((void **) &d1, d_res2.size()*int_size));
                thrust::device_ptr<int_type> dest1((int_type*)d1);
                thrust::gather(d_res2.begin(), d_res2.end(), right->d_columns_int[right->type_index[colInd2]].begin(), dest1);

                //thrust::device_ptr<int_type> src2((int_type*)(left->d_columns)[colInd1]);
                CUDA_SAFE_CALL(cudaMalloc((void **) &d2, d_res2.size()*int_size));
                thrust::device_ptr<int_type> dest2((int_type*)d2);
                thrust::gather(d_res1.begin(), d_res1.end(), left->d_columns_int[left->type_index[colInd1]].begin(), dest2);

                thrust::transform(dest1, dest1+d_res2.size(), dest2, dest2, thrust::equal_to<int_type>());

                int sz = thrust::reduce(dest2, dest2 + d_res2.size());
                thrust::copy_if(d_res1.begin(), d_res1.end(), dest2, dest1, nz<int_type>());
                d_res1.resize(sz);
                thrust::copy(dest1, dest1+sz, d_res1.begin());
                thrust::copy_if(d_res2.begin(), d_res2.end(), dest2, dest1, nz<int_type>());
                d_res2.resize(sz);
                thrust::copy(dest1, dest1+sz, d_res2.begin());
                thrust::device_free(dest1);
                thrust::device_free(dest2);
            }
            else if (right->type[colInd2] == 1 ) {
                //thrust::device_ptr<float_type> src1((float_type*)(right->d_columns)[colInd2]);
                CUDA_SAFE_CALL(cudaMalloc((void **) &d1, d_res2.size()*float_size));
                thrust::device_ptr<float_type> dest1((float_type*)d1);
                thrust::gather(d_res2.begin(), d_res2.end(), right->d_columns_float[right->type_index[colInd2]].begin(), dest1);

                //thrust::device_ptr<float_type> src2((float_type*)(left->d_columns)[colInd1]);
                CUDA_SAFE_CALL(cudaMalloc((void **) &d2, d_res2.size()*float_size));
                thrust::device_ptr<float_type> dest2((float_type*)d2);
                thrust::gather(d_res1.begin(), d_res1.end(), left->d_columns_float[left->type_index[colInd1]].begin(), dest2);
                thrust::device_ptr<int_type> d3 = thrust::device_malloc<int_type>(d_res2.size());
                thrust::device_ptr<int_type> d4 = thrust::device_malloc<int_type>(d_res2.size());
                thrust::transform(dest1, dest1+d_res2.size(), dest2, d3, f_equal_to());

                int sz = thrust::reduce(d3, d3 + d_res2.size());
                thrust::copy_if(d_res1.begin(), d_res1.end(), d3, d4, nz<int_type>());
                d_res1.resize(sz);
                thrust::copy(d4, d4+sz, d_res1.begin());

                thrust::copy_if(d_res2.begin(), d_res2.end(), d3, d4, nz<int_type>());
                d_res2.resize(sz);
                thrust::copy(d4, d4+sz, d_res2.begin());
                thrust::device_free(d3);
                thrust::device_free(d4);
                thrust::device_free(dest1);
                thrust::device_free(dest2);
            }
            else { //CudaChar
                CudaChar *s1 = right->h_columns_cuda_char[right->type_index[colInd2]];
                CUDA_SAFE_CALL(cudaMalloc((void **) &d1, d_res2.size()));
                thrust::device_ptr<char> dest1((char*)d1);

                CudaChar *s2 = left->h_columns_cuda_char[left->type_index[colInd1]];
                CUDA_SAFE_CALL(cudaMalloc((void **) &d2, d_res2.size()));
                thrust::device_ptr<char> dest2((char*)d2);

                int colCnt;
                if (s1->mColumnCount > s2->mColumnCount)
                    colCnt = s2->mColumnCount;
                else
                    colCnt = s1->mColumnCount;

                thrust::device_ptr<int_type> d3 = thrust::device_malloc<int_type>(d_res2.size());
                thrust::device_ptr<int_type> d4 = thrust::device_malloc<int_type>(d_res2.size());

                for(unsigned int j=0; j < colCnt; j++) {
                    //thrust::device_ptr<char> src1(s1->d_columns[j]);
                    //thrust::device_ptr<char> src2(s2->d_columns[j]);
                    thrust::gather(d_res2.begin(), d_res2.end(), s1->d_columns[j].begin(), dest1);
                    thrust::gather(d_res2.begin(), d_res2.end(), s2->d_columns[j].begin(), dest2);
                    thrust::transform(dest1, dest1+d_res2.size(), dest2, d3, thrust::equal_to<char>());

                    int sz = thrust::reduce(d3, d3 + d_res2.size());
                    thrust::copy_if(d_res1.begin(), d_res1.end(), d3, d4, nz<int_type>());
                    d_res1.resize(sz);
                    thrust::copy(d4, d4+sz, d_res1.begin());

                    thrust::copy_if(d_res2.begin(), d_res2.end(), d3, d4, nz<int_type>());
                    d_res2.resize(sz);
                    thrust::copy(d4, d4+sz, d_res2.begin());
                };
                thrust::device_free(d3);
                thrust::device_free(d4);
                thrust::device_free(dest1);
                thrust::device_free(dest2);

                // here we will have to add some code if joined varchar columns are not of the same size
            };
            if (!right_in_gpu)
                right->deAllocColumnOnDevice(colInd2);
            if (!left_in_gpu)
                left->deAllocColumnOnDevice(colInd1);
        }

        cout << "join final end " << d_res1.size() << "  " << getFreeMem() << endl;
        //std::cout<< "join1 time " <<  ( ( std::clock() - start1 ) / (double)CLOCKS_PER_SEC ) <<'\n';

        if(i == 0)
            c = new CudaSet(right,left,d_res1.size(),op_sel, op_sel_as);
        if (d_res1.size() != 0)
            c->gather(right,left,d_res2,d_res1, i, op_sel);

        //cout << " ctotal " << c->mRecCount << endl;
    };  // end of join piece cycle

    // if a and b are not fact tables then lets copy to host all result columns
    if(!c->fact_table) {
        c->resize(0); // initialize h_columns to current mRecCount
        c->CopyToHost(0,c->mRecCount);
        c->deAllocOnDevice();
    };

    if (left->fact_table == 0 && right->fact_table == 0) {
        left->deAllocOnDevice();
        right->deAllocOnDevice();
    };

    if (left->fact_table == 0 && right->fact_table == 1) {
        right->deAllocOnDevice();
    };
    if (right->fact_table == 0 && left->fact_table == 1) {
        left->deAllocOnDevice();
    };

    varNames[s] = c;
    c->maxRecs = c->mRecCount;
    c->segCount = 1;
    clean_queues();

    if(stat[s] == statement_count) {
        c->free();
        varNames.erase(s);
    };

    if(stat[j1] == statement_count && fact_file_loaded == 1) {
        left->free();
        varNames.erase(j1);
    };

    if(stat[j2] == statement_count && (strcmp(j1,j2.c_str()) != 0) && fact_file_loaded == 1) {
        right->free();
        varNames.erase(j2);
    };

    if(stat[j1] == statement_count && fact_file_loaded == 0 && left->fact_table == 0 && right->fact_table == 0) {
        left->free();
        varNames.erase(j1);
    };

    if(stat[j2] == statement_count && fact_file_loaded == 0 && left->fact_table == 0 && right->fact_table == 0) {
        right->free();
        varNames.erase(j2);
    };

    if(stat[j2] == statement_count && left->fact_table == 0 && right->fact_table == 0 && varNames.find(j2) != varNames.end()) {
        right->free();
        varNames.erase(j2);
    };

    if(stat[j1] == statement_count && right->fact_table == 0 && left->fact_table == 0 && varNames.find(j1) != varNames.end()) {
        left->free();
        varNames.erase(j1);
    };

    if(stat[j2] == statement_count &&  right->fact_table == 1 && !right->keep && fact_file_loaded == 0) {
        right->free();
        varNames.erase(j2);
    };

    if(stat[j1] == statement_count &&  left->fact_table == 1 && !left->keep && fact_file_loaded == 0) {
        left->free();
        varNames.erase(j1);
    };

    std::cout<< "join time " <<  ( ( std::clock() - start1 ) / (double)CLOCKS_PER_SEC ) <<'\n';

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


    if(a->readyToProcess == 0)
        return;

    if(a->fact_table == 0 && lc > 1)
        return;

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

    printf("emit order: %s %s \n", s, f);

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

    // initialize permutation to [0, 1, 2, ... ,N-1]


    thrust::device_ptr<unsigned int> permutation = thrust::device_malloc<unsigned int>(a->mRecCount);
    thrust::sequence(permutation, permutation+(a->mRecCount));

    unsigned int* raw_ptr = thrust::raw_pointer_cast(permutation);

    bool in_gpu = false;
    if(a->onDevice(0))
        in_gpu = true;


    CudaSet *b;
    if(lc == 1 || (varNames.find(s) == varNames.end()))
        b = a->copyStruct(a->mRecCount);
    else
        b = varNames.find(s)->second;

    void* temp;
    if(a->mRecCount > b->mRecCount)
        CUDA_SAFE_CALL(cudaMalloc((void **) &temp, a->mRecCount*float_size));
    else
        CUDA_SAFE_CALL(cudaMalloc((void **) &temp, b->mRecCount*float_size));

    for(int i=0; !exe_type.empty(); ++i, exe_type.pop(),exe_value.pop()) {
        int colInd = (a->columnNames).find(exe_type.top())->second;
        //copy column to device
        if(!in_gpu) {
            a->allocColumnOnDevice(colInd,a->mRecCount);
            a->CopyColumnToGpu(colInd,0,a->mRecCount);
        };

        if ((a->type)[colInd] == 0)
            update_permutation(thrust::raw_pointer_cast((a->d_columns_int[a->type_index[colInd]]).data()), raw_ptr, a->mRecCount, exe_value.top(), (int_type*)temp);
        else if ((a->type)[colInd] == 1)
            update_permutation(thrust::raw_pointer_cast((a->d_columns_float[a->type_index[colInd]]).data()), raw_ptr, a->mRecCount,exe_value.top(), (float_type*)temp);
        else {
            CudaChar* c = a->h_columns_cuda_char[a->type_index[colInd]];
            for(int j=(c->mColumnCount)-1; j>=0 ; j--)
                update_permutation_char((c->d_columns)[j], raw_ptr, a->mRecCount, (char*)temp, exe_value.top());
        };
        if(!in_gpu)
            a->deAllocColumnOnDevice(colInd);
    };


    // copy a to b

    for(unsigned int i=0; i < a->mColumnCount; i++) {
        b->allocColumnOnDevice(i,a->mRecCount);
        if(!in_gpu) {
            a->allocColumnOnDevice(i,a->mRecCount);
            a->CopyColumnToGpu(i,0,a->mRecCount);
        };

        if (a->type[i] == 0 ) {
            //thrust::device_ptr<int_type> src((int_type*)(a->d_columns)[i]);
            //thrust::device_ptr<int_type> dest((int_type*)(b->d_columns)[i]);
            thrust::copy(a->d_columns_int[a->type_index[i]].begin(), a->d_columns_int[a->type_index[i]].begin() + a->mRecCount, b->d_columns_int[b->type_index[i]].begin());
            apply_permutation(thrust::raw_pointer_cast((b->d_columns_int[b->type_index[i]]).data()), raw_ptr, b->mRecCount, (int_type*)temp);
        }
        else if (a->type[i] == 1 ) {
            //thrust::device_ptr<float_type> src((float_type*)(a->d_columns)[i]);
            //thrust::device_ptr<float_type> dest((float_type*)(b->d_columns)[i]);
            thrust::copy(a->d_columns_float[a->type_index[i]].begin(), a->d_columns_float[a->type_index[i]].begin() + a->mRecCount, b->d_columns_float[b->type_index[i]].begin());
            apply_permutation(thrust::raw_pointer_cast((b->d_columns_float[b->type_index[i]]).data()), raw_ptr, b->mRecCount, (float_type*)temp);
        }
        else { //CudaChar
            CudaChar *s = a->h_columns_cuda_char[a->type_index[i]];
            CudaChar *d = b->h_columns_cuda_char[b->type_index[i]];
            for(unsigned int j=0; j < s->mColumnCount; j++) {
                thrust::copy(s->d_columns[j].begin(),s->d_columns[j].begin()+a->mRecCount,d->d_columns[j].begin());
                apply_permutation_char(d->d_columns[j], raw_ptr, b->mRecCount, (char*)temp);
            };
        };

        b->CopyColumnToHost(i);
        b->deAllocColumnOnDevice(i);
        if(!in_gpu)
            a->deAllocColumnOnDevice(i);
    };


    thrust::device_free(permutation);
    cudaFree(temp);

    varNames[s] = b;
    b->readyToProcess = 1;

    if (a->fact_table == 1)
        b->fact_table = 1;
    else
        b->fact_table = 0;

    if(stat[f] == statement_count && (a->fact_table == 0 || fact_file_loaded == 1 || fact_file_exists == 0)) {
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
    a = varNames.find(f)->second;

    if (a->fact_table == 0 && lc > 1)
        return;


    if(a->readyToProcess == 0 && fact_file_loaded == 0) {
        clean_queues();
        return;
    };


    if(a->mRecCount == 0) {

        if (a->fact_table == 1 && fact_file_loaded == 1) {
            if (ll != 0 ) {
                printf("emit select final merge %s %s \n", s, f);
                CudaSet *c;
                if(varNames.find(s) == varNames.end())
                    c = new CudaSet(0,1);
                else
                    c = varNames[s];
                CudaSet *r;

                if(c->mRecCount != 0)
                    r = merge(c,op_v3, op_v2);
                else
                    r = new CudaSet(0,1);
                c->free();
                c = r;
                varNames[s] = c;
            };

            if(varNames.find(s) == varNames.end()) {
                CudaSet *c = new CudaSet(0,1);
                varNames[s] = c;
            };
            varNames[s]->readyToProcess = 1;
            clean_queues();
            return;
        }
        else {
            if(varNames.find(s) == varNames.end()) {
                CudaSet *c = new CudaSet(0,1);
                varNames[s] = c;
                varNames[s]->readyToProcess = 0;
            };
            if (ll == 0)
                varNames[s]->mRecCount = 0;
            return;
        };
    };



    printf("emit select %s %s \n", s, f);

    std::clock_t start1 = std::clock();

    // here we need to determine the column count and composition

    queue<string> op_v(op_value);
    set<string> field_names;

    for(int i=0; !op_v.empty(); ++i, op_v.pop())
        if(a->columnNames.find(op_v.front()) != a->columnNames.end())
            field_names.insert(op_v.front());


    bool in_gpu = false;
    if (!a->onDevice(0))
        for (set<string>::iterator it=field_names.begin(); it!=field_names.end(); ++it)
            a->allocColumnOnDevice(a->columnNames[*it], a->maxRecs);
    else
        in_gpu = true;


    // find out how many columns a new set will have
    queue<string> op_t(op_type);
    int_type col_count = 0;

    for(int i=0; !op_t.empty(); ++i, op_t.pop())
        if((op_t.front()).compare("emit sel_name") == 0)
            col_count++;

    bool one_line = 0;
    if (a->columnGroups.empty() && a->mRecCount != 0)
        one_line = 1;

    CudaSet* b;
    CudaSet* c;


//    int_type copy_count = chunkCount;
//    int_type old_reccount = a->mRecCount;


    for(unsigned int i = 0; i < a->segCount; i++) {          // MAIN CYCLE

//        if(ll == 0 && one_line && varNames.find(s) != varNames.end())
        if(ll == 0 && varNames.find(s) != varNames.end())
            b = varNames[s];
        else {
            b = new CudaSet(a->maxRecs, col_count);
        };
        b->mRecCount = 0;


        if(!in_gpu)
            for (set<string>::iterator it=field_names.begin(); it!=field_names.end(); ++it)
                a->CopyColumnToGpu(a->columnNames[*it], i);

        if (ll != 0) {
            thrust::device_ptr<unsigned int> perm = order_inplace(a,op_v2,field_names);
            thrust::device_free(perm);
            a->GroupBy(op_v3);
        };

        select(op_type,op_value,op_nums, op_nums_f,a,b, a->mRecCount);
        cout << "select result " << b->mRecCount << endl;

        if (ll != 0) {

            if(lc > 1 && varNames.find(s) != varNames.end()) {
                c = varNames[s];
                if(c->mRecCount == 0) {
                    c->free();
                    c = new CudaSet(b->mRecCount, col_count);
                    c->segCount = 1;
                }
                else
                    c->resize(b->mRecCount);
            }
            else {
                if (i == 0) {
                    c = new CudaSet(b->mRecCount, col_count);
                    c->fact_table = 1;
                    c->segCount = 1;
                }
                else
                    c->resize(b->mRecCount);
            };
            add(c,b,op_v3, op_v2);
        };
        b->deAllocOnDevice();
    };

    //a->mRecCount = old_reccount;


    if(stat[f] == statement_count)
        a->deAllocOnDevice();


    if (ll != 0 && (fact_file_loaded == 1 || fact_file_exists == 0)) {
        CudaSet *r = merge(c,op_v3, op_v2);
        c->free();
        c = r;
    };

    if (ll != 0) {
        if(a->fact_table == 1 && fact_file_loaded == 0)
            c->readyToProcess = 0;
        else
            c->readyToProcess = 1;
    }
    else {
        if(one_line && a->fact_table == 1 && fact_file_loaded == 0)
            b->readyToProcess = 0;
        else
            b->readyToProcess = 1;
    };

    if (a->fact_table == 0) {
        b->fact_table = 0;
        if (ll != 0)
            c->fact_table = 0;
    }
    else {
        b->fact_table = 1;
        if (ll != 0)
            c->fact_table = 1;
    };

    clean_queues();


    if (ll != 0) {
        varNames[s] = c;
        b->free();
    }
    else
        varNames[s] = b;

    if(stat[s] == statement_count) {
        varNames[s]->free();
        varNames.erase(s);
    };

    if(stat[f] == statement_count && (((a->fact_table == 0 || fact_file_loaded == 1 || fact_file_exists == 0) || a->keep == 0))) {
        a->free();
        varNames.erase(f);
    };

    std::cout<< "select time " <<  ( ( std::clock() - start1 ) / (double)CLOCKS_PER_SEC ) <<'\n';

}



void emit_filter(char *s, char *f, int e)
{
    statement_count++;
    if (scan_state == 0) {
        if (stat.find(f) == stat.end()) {
            cout << "Filter : couldn't find variable " << f << endl;
            exit(1);
        };
        stat[s] = statement_count;
        stat[f] = statement_count;

// save the filter parameters for possible later zone map filtering
        top_type[f] = op_type;
        top_value[f] = op_value;
        top_nums[f] = op_nums;
        top_nums_f[f] = op_nums_f;
        clean_queues();
        return;
    };


    if(varNames.find(f) == varNames.end()) {
        clean_queues();
        return;
    };

    CudaSet *a, *b;
    bool in_gpu = false;

    a = varNames.find(f)->second;
    a->name = f;

    if(a->mRecCount == 0) {
        b = new CudaSet(0,1);
    }
    else {

        if(a->readyToProcess == 0 || (a->fact_table == 0 && lc > 1))
            return;

        printf("emit filter : %s %s \n", s, f);
        std::clock_t start1 = std::clock();

        if (a->onDevice(0))
            //    a->allocOnDevice(a->maxRecs);
            //else
            in_gpu = true;

//		cout << "filter on gpu " <<  in_gpu << endl;

        if (lc == 1 || (varNames.find(s) == varNames.end()))
            b = a->copyDeviceStruct();
        else
            b = varNames.find(s)->second;

        int_type old_reccount = a->mRecCount;
        bool del_source = (stat[f] == statement_count);

        queue<string> op_v(op_value);
        queue<unsigned int> field_names;
        map<string,int>::iterator it;
        while(!op_v.empty()) {
            it = a->columnNames.find(op_v.front());
            if(it != a->columnNames.end() && !in_gpu) {
                field_names.push(it->second);
                a->allocColumnOnDevice(it->second, a->maxRecs);
            };
            op_v.pop();
        };

        for(unsigned int i = 0; i < a->segCount; i++) {
            queue<unsigned int> f(field_names);
            while(!f.empty()) {
                a->CopyColumnToGpu(f.front(), i); // segment i
                f.pop();
            };
            filter(op_type,op_value,op_nums, op_nums_f,a,b,del_source,i);
        };
        cout << "filter is finished " << b->mRecCount << endl;
        a->mRecCount = old_reccount;
        a->deAllocOnDevice();

        if (b->segCount != 1)
            b->deAllocOnDevice();
        std::cout<< "filter time " <<  ( ( std::clock() - start1 ) / (double)CLOCKS_PER_SEC ) <<'\n';
    };

    b->readyToProcess = 1;
    clean_queues();

    if (a->fact_table == 0)
        b->fact_table = 0;
    else
        b->fact_table = 1;

    if (varNames.count(s) > 0 && (b->fact_table == 0 ||  fact_file_exists == 0))
        varNames[s]->free();

    varNames[s] = b;

    if(stat[s] == statement_count) {
        b->free();
        varNames.erase(s);
    };
    if(stat[f] == statement_count && ((a->fact_table == 0 || fact_file_loaded == 1 || fact_file_exists == 0) || a->keep == 0)) {
        a->free();
        varNames.erase(f);
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


    if(a->readyToProcess == 0)
        return;

    printf("emit store: %s %s %s \n", s, f, sep);

    int limit = 0;
    if(!op_nums.empty()) {
        limit = op_nums.front();
        op_nums.pop();
    };

    a->Store(f,sep, limit, 0);

    if(stat[s] == statement_count  && (a->fact_table == 0 || fact_file_loaded == 1 || fact_file_exists == 0)) {
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

    if(a->readyToProcess == 0)
        return;

    printf("emit store: %s %s \n", s, f);

    int limit = 0;
    if(!op_nums.empty()) {
        limit = op_nums.front();
        op_nums.pop();
    };


    a->Store(f,"", limit, 1);

    //if(stat[s] == statement_count && (a->fact_table == 0 || fact_file_loaded == 1 || fact_file_exists == 0)) {
    if(stat[f] == statement_count && a->keep == 0) {
        a->free();
        varNames.erase(s);
    };

};



void emit_load_binary(char *s, char *f, int d, bool stream)
{
    statement_count++;
    if (scan_state == 0) {
        stat[s] = statement_count;
        return;
    };

    if (stream == 0 && lc > 1) {
        while(!namevars.empty()) namevars.pop();
        while(!typevars.empty()) typevars.pop();
        while(!sizevars.empty()) sizevars.pop();
        while(!cols.empty()) cols.pop();
        return;
    };

    printf("emit binary load: %s %s \n", s, f);

    CudaSet *a;
    unsigned int segCount, maxRecs;
    char f1[100];
    strcpy(f1, f);
    strcat(f1,".");
    char col_pos[3];
    itoaa(cols.front(),col_pos);
    strcat(f1,col_pos);

    if (!stream && lc==1) {
        a = new CudaSet(namevars, typevars, sizevars, cols, findRecordCount(f1, namevars.size(), segCount, maxRecs), f);
        a->segCount = segCount;
        a->maxRecs = maxRecs;
        a->fact_table = 0;
    };

    if (stream) {
        fact_file_loaded = 0;
        if (lc == 1) {
            fact_file_name = f;
            fact_file_exists = 1;
            totalRecs = findRecordCount(f1, namevars.size(), segCount, maxRecs);
            cout << "total " << totalRecs << " " << segCount << " " << maxRecs << endl;
            a = new CudaSet(namevars, typevars, sizevars, cols, maxRecs);
            a->keep = true;
            a->name = s;
            a->maxRecs = maxRecs;
            buffersLoaded = 0;
            th = a;
//#ifdef _WIN64
            LoadBuffers(f);
//#endif
        }
        else
            a =  varNames[s];

        a->fact_table = 1;
        a->LoadBigBinaryFile(f, totalRecs-runningRecs);
        runningRecs = runningRecs + a->mRecCount;
        cout << "Processed " << runningRecs  << " records out of total of " << totalRecs << endl;
        if (runningRecs >= totalRecs )
            fact_file_loaded = 1;

    };

    a->readyToProcess = 1;
    varNames[s] = a;

    if(stat[s] == statement_count  && (a->fact_table == 0 || fact_file_loaded == 1 || fact_file_exists == 0))  {
        a->free();
        varNames.erase(s);
    };
}





void emit_load(char *s, char *f, int d, char* sep, bool stream)
{
    statement_count++;
    if (scan_state == 0) {
        stat[s] = statement_count;
        return;
    };

    if (stream == 0 && lc > 1) {
        while(!namevars.empty()) namevars.pop();
        while(!typevars.empty()) typevars.pop();
        while(!sizevars.empty()) sizevars.pop();
        while(!cols.empty()) cols.pop();
        return;
    };


    printf("emit load: %s %s %d  %s \n", s, f, d, sep);

    CudaSet *a;

    if (lc == 1 ) {

        if (stream) {
            fact_file_name = f;
            fact_file_exists = 1;
        }
        else {
            a = new CudaSet(namevars, typevars, sizevars, cols, process_count);
            a->fact_table = 1;
            a->LoadFile(f, sep);
            a->fact_table = 0;
            a->maxRecs = a->mRecCount;
            a->segCount = 1;
            cout << "loaded " << a->maxRecs << endl;
        };
    };

    if (stream) {

        if (lc == 1) {
            a = new CudaSet(namevars, typevars, sizevars, cols, process_count);
            a->keep = true;
        }
        else
            a =  varNames[s];

        a->fact_table = 1;
        if (lc > 1 )
            a->file_p = file_pointer;
        fact_file_loaded = a->LoadBigFile(f, sep);
        a->maxRecs = a->mRecCount;
        a->segCount = 1;

        if (lc == 1 )
            file_pointer = a->file_p;
    };

    a->readyToProcess = 1;
    varNames[s] = a;

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
    sel_count = 0;
    join_cnt = 0;
    join_col_cnt = -1;
    eqq = 0;
}



int main(int ac, char **av)
{
    extern FILE *yyin;


    if (ac == 1) {
        cout << "Usage : alenka -l process_count script.sql" << endl;
        exit(1);
    };


    if(strcmp(av[1],"-l") == 0) {
        process_count = atoff(av[2]);
        cout << "Process count = " << process_count << endl;
    }
    else {
        process_count = 6200000;
        cout << "Process count = 6200000 " << endl;
    };

    if((yyin = fopen(av[ac-1], "r")) == NULL) {
        perror(av[ac-1]);
        exit(1);
    };

    if(yyparse()) {
        printf("SQL scan parse failed\n");
        exit(1);
    };
    fclose(yyin);

    scan_state = 1;

    do {
        cout << "Cycle " << lc << " " << " Mem:" << getFreeMem() << endl;
        std::clock_t start1 = std::clock();
        statement_count = 0;
        lc++;
        while(!namevars.empty()) namevars.pop();
        while(!typevars.empty()) typevars.pop();
        while(!sizevars.empty()) sizevars.pop();
        while(!cols.empty()) cols.pop();
        while(!op_type.empty()) op_type.pop();
        while(!op_value.empty()) op_value.pop();
        while(!op_join.empty()) op_join.pop();
        while(!op_nums.empty()) op_nums.pop();
        while(!op_nums_f.empty()) op_nums_f.pop();
        while(!j_col_count.empty()) j_col_count.pop();
        sel_count = 0;
        join_cnt = 0;
        join_col_cnt = -1;
        eqq = 0;

        if(ac > 1 && (yyin = fopen(av[ac-1], "r")) == NULL) {
            perror(av[1]);
            exit(1);
        }

        //yyrestart(yyin);
        PROC_FLUSH_BUF ( yyin );
        statement_count = 0;

        if(!yyparse())
            printf("SQL scan parse worked\n");
        else
            printf("SQL scan parse failed\n");
        fclose(yyin);
        std::cout<< "cycle time " <<  ( ( std::clock() - start1 ) / (double)CLOCKS_PER_SEC ) <<'\n';
    }
    while (fact_file_exists != 0 && fact_file_loaded == 0 );


} /* main */

