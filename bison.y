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
    void emit_load(char *s, char *f, int d, char* sep);
    void emit_load_binary(char *s, char *f, int d);
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
{  emit_load($1, $4, $11, $7); } ;
| NAME ASSIGN LOAD FILENAME BINARY AS '(' load_list ')'
{  emit_load_binary($1, $4, $8); } ;
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
| DECIMAL1 { emit_decimal($1); }
| BOOL1 { emit("BOOL %d", $1); }
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


#include "filter.cu"
#include "select.cu"
#include "merge.cu"
#include "zone_map.cu"

FILE *file_pointer;
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

unsigned int orig_recCount;
unsigned int statement_count = 0;
map<string,unsigned int> stat;
bool scan_state = 0;
string separator, f_file;


CUDPPHandle theCudpp;

using namespace thrust::placeholders;


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




thrust::device_ptr<unsigned int> order_inplace(CudaSet* a, stack<string> exe_type, set<string> field_names, unsigned int segment)
{
    unsigned int sz = a->mRecCount;
    thrust::device_ptr<unsigned int> permutation = thrust::device_malloc<unsigned int>(sz);
    thrust::sequence(permutation, permutation+sz,0,1);


    unsigned int* raw_ptr = thrust::raw_pointer_cast(permutation);
    void* temp;
    // find the largest mRecSize of all data sources
    unsigned int maxSize = 0;
    for (set<string>::iterator it=field_names.begin(); it!=field_names.end(); ++it) {
        CudaSet *t = varNames[setMap[*it]];
        //cout << "MAX of " << setMap[*it] << " = " << t->mRecCount << endl;
        if(t->mRecCount > maxSize)
            maxSize = t->mRecCount;
    };

    //cout << "max size " << maxSize << endl;
    //cout << "sort alloc " << maxSize << endl;
    //cout << "order mem " << getFreeMem() << endl;
    CUDA_SAFE_CALL(cudaMalloc((void **) &temp, maxSize*float_size));

    for(int i=0; !exe_type.empty(); ++i, exe_type.pop()) {
        int colInd = (a->columnNames).find(exe_type.top())->second;
        if ((a->type)[colInd] == 0)
            update_permutation(a->d_columns_int[a->type_index[colInd]], raw_ptr, sz, "ASC", (int_type*)temp);
        else if ((a->type)[colInd] == 1)
            update_permutation(a->d_columns_float[a->type_index[colInd]], raw_ptr, sz,"ASC", (float_type*)temp);
        else {
            CudaChar* c = a->h_columns_cuda_char[a->type_index[colInd]];
            for(int j=(c->mColumnCount)-1; j>=0 ; j--)
                update_permutation((c->d_columns)[j], raw_ptr, sz, "ASC", (char*)temp);
        };
    };

    for (set<string>::iterator it=field_names.begin(); it!=field_names.end(); ++it) {
        int i = a->columnNames[*it];
        if ((a->type)[i] == 0)
            apply_permutation(a->d_columns_int[a->type_index[i]], raw_ptr, sz, (int_type*)temp);
        else if ((a->type)[i] == 1)
            apply_permutation(a->d_columns_float[a->type_index[i]], raw_ptr, sz, (float_type*)temp);
        else {
            CudaChar* c = a->h_columns_cuda_char[a->type_index[i]];
            for(int j=(c->mColumnCount)-1; j>=0 ; j--)
                apply_permutation((c->d_columns)[j], raw_ptr, sz, (char*)temp);
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

    string f1 = op_value.front();
    op_value.pop();
    string f2 = op_value.front();
    op_value.pop();

    cout << "JOIN " << s <<  endl;;


    std::clock_t start1 = std::clock();
    CudaSet* c;

    if (left->mRecCount == 0 || right->mRecCount == 0) {
        c = new CudaSet(left,right,0, op_sel, op_sel_as);
        if (left->fact_table == 1 || right->fact_table == 1)
            c->fact_table = 1;
        varNames[s] = c;
        clean_queues();
        return;
    };


    unsigned int colInd1 = (left->columnNames).find(f1)->second;
    unsigned int colInd2 = (right->columnNames).find(f2)->second;

    set<string> field_names;
    stack<string> exe_type;
    exe_type.push(f2);
    field_names.insert(f2);
	
	unsigned int *A, *B;
    unsigned int *devPtrA, *devPtrB;
    size_t memsize;
    unsigned int rcount = 0;

    if(!left->prm.empty())
        for(int i = 0; i < left->segCount; i ++) {
            rcount = rcount + left->prm_count[setMap[f1]][i];
        }
    else
        rcount = varNames[setMap[f1]]->mRecCount;

    memsize = ((rcount * sizeof(unsigned int) + 4095) / 4096) * 4096;


#ifdef _WIN64
    A = (unsigned int*) VirtualAlloc(NULL, memsize, MEM_COMMIT, PAGE_READWRITE);
#else
    A = (unsigned int*) valloc(memsize);
#endif


    cudaError_t err = cudaHostRegister(A, memsize, cudaHostRegisterMapped);
    if (cudaSuccess != err)
        cout << cudaGetErrorString( err ) << endl;
    cudaHostGetDevicePointer((void **) &devPtrA, (void *) A, 0);
    if (cudaSuccess != err)
        cout << cudaGetErrorString( err ) << endl;
    thrust::device_ptr<unsigned int> ll((unsigned int*)devPtrA);

    rcount = 0;
    if(!right->prm.empty())
        for(int i = 0; i < right->segCount; i ++) {
            rcount = rcount + right->prm_count[setMap[f2]][i];
        }
    else
        rcount = varNames[setMap[f2]]->mRecCount;

    memsize = ((rcount * sizeof(unsigned int) + 4095) / 4096) * 4096;

#ifdef _WIN64
    B = (unsigned int*) VirtualAlloc(NULL, memsize, MEM_COMMIT, PAGE_READWRITE);
#else
    B = (unsigned int*) valloc(memsize);
#endif

    err = cudaHostRegister(B, memsize, cudaHostRegisterMapped);
    if (cudaSuccess != err)
        cout << cudaGetErrorString( err ) << endl;
    cudaHostGetDevicePointer((void **) &devPtrB, (void *) B, 0);
    if (cudaSuccess != err)
        cout << cudaGetErrorString( err ) << endl;
    thrust::device_ptr<unsigned int> rr((unsigned int*)devPtrB);


    queue<string> cc;
    cc.push(f2);
    unsigned int cnt_r = 0;

    varNames[setMap[f2]]->oldRecCount = varNames[setMap[f2]]->mRecCount;
    allocColumns(right, cc);
    for(int i = 0; i < right->segCount; i++) {
        // copy every segment to gpu then copy to host using host mapped memory
        copyGatherJoin(right, rr, cc.front(), i, cnt_r);
    };
	//here we need to make sure that rr is ordered. If not then we order it and keep the permutation
	
	bool sorted = thrust::is_sorted(rr,rr+cnt_r);
	
    thrust::device_vector<unsigned int> v(cnt_r);
	thrust::sequence(v.begin(),v.end(),0,1);
    	
	if(!sorted) {
	    thrust::sort_by_key(rr,rr+cnt_r, v.begin());
	};
	

    varNames[setMap[f2]]->mRecCount = varNames[setMap[f2]]->oldRecCount;


    cc.pop();
    cc.push(f1);
    unsigned int cnt_l = 0;

    varNames[setMap[f1]]->oldRecCount = varNames[setMap[f1]]->mRecCount;
    allocColumns(left, cc);

    for(int i = 0; i < left->segCount; i++) {
        // copy every segment to gpu then copy to host using host mapped memory
        copyGatherJoin(left, ll, cc.front(), i, cnt_l);
    };
    varNames[setMap[f1]]->mRecCount = varNames[setMap[f1]]->oldRecCount;

    cout << "successfully loaded l && r " << cnt_l << " " << cnt_r << endl;


    thrust::device_vector<unsigned int> d_res1;
    thrust::device_vector<unsigned int> d_res2;


    std::clock_t start2 = std::clock();
    thrust::device_vector<uint2> res(left->mRecCount);

    if ((left->type)[colInd1] == 0 && (right->type)[colInd2]  == 0) {
	
	
        CUDPPHandle hash_table_handle;

        //cout << "creating hash table " << cnt_r << endl;

        CUDPPHashTableConfig config;
        config.type = CUDPP_MULTIVALUE_HASH_TABLE;
        config.kInputSize = right->mRecCount;
        config.space_usage = 1.5f;
        CUDPPResult result = cudppHashTable(theCudpp, &hash_table_handle, &config);
        //if (result == CUDPP_SUCCESS)
        //    cout << "hash table created " << endl;
        //cout << "INSERT " << cnt_r << " " << right->mRecCount << endl;
        result = cudppHashInsert(hash_table_handle, thrust::raw_pointer_cast(rr),
                                 thrust::raw_pointer_cast(v.data()), cnt_r);
        //if (result == CUDPP_SUCCESS)
        //    cout << "hash table inserted " << endl;
        cudppHashRetrieve(hash_table_handle, thrust::raw_pointer_cast(ll),
                          thrust::raw_pointer_cast(res.data()), cnt_l);
        cudppDestroyHashTable(theCudpp, hash_table_handle);
		
        //if (result == CUDPP_SUCCESS)
        //    cout << "hash table destroyed " << endl;

        //unsigned int rr = thrust::count_if(res.begin(),res.end(),is_match());
		uint2 rr = thrust::reduce(res.begin(), res.end(), make_uint2(0,0), Uint2Sum());		
        //cout << "final res " << rr << endl;

        if(rr.y) {
		
		    thrust::device_vector<unsigned int> d_r(cnt_l);		
	        thrust::counting_iterator<unsigned int, thrust::device_space_tag> begin(0);
            uint2_split ff(thrust::raw_pointer_cast(res.data()),
                           thrust::raw_pointer_cast(d_r.data()));
            thrust::for_each(begin, begin + cnt_l, ff);							
		
		    thrust::exclusive_scan(d_r.begin(), d_r.end(), d_r.begin() );  // addresses				
		
            d_res1.resize(rr.y);
            d_res2.resize(rr.y);

            join_functor ff1(thrust::raw_pointer_cast(res.data()),
                             thrust::raw_pointer_cast(d_r.data()),
	     					 thrust::raw_pointer_cast(d_res1.data()),
		    				 thrust::raw_pointer_cast(d_res2.data()));
            thrust::for_each(begin, begin + cnt_l, ff1);		

        };
    }

    c = new CudaSet(right,left,d_res1.size(),op_sel, op_sel_as);
    bool left_check;
    thrust::device_vector<unsigned int> p(d_res1.size());
	thrust::device_vector<unsigned int> res_tmp(left->mRecCount);

    //gather prm of left and right vectors
    while(!op_sel.empty()) {
        if(c->prm.count(setMap[op_sel.front()]) == 0) {

            CudaSet *t = varNames[setMap[op_sel.front()]];
            CudaSet *lr;
            if(left->columnNames.find(op_sel.front()) !=  left->columnNames.end()) {
                lr = left;
                left_check = 1;
            }
            else {
                lr = right;
                left_check = 0;
            };

            c->prm[setMap[op_sel.front()]].push_back(new unsigned int[d_res1.size()]);
            c->prm_count[setMap[op_sel.front()]].push_back(d_res1.size());
            if(lr->prm.size() != 0) {
                // join prm segments, add seg_num*maxRecs to values and gather the result

                unsigned int curr_count = 0;
                for(unsigned int i = 0; i < lr->prm[setMap[op_sel.front()]].size(); i++) {

                    //lr->prm_d = lr->prm[setMap[op_sel.front()]][i];
                    if(lr->prm_d.size() == 0) // find the largest prm segment
                        lr->prm_d.resize(largest_prm(lr, op_sel.front()));
                    unsigned int g_size = lr->prm_count[setMap[op_sel.front()]][i];
                    cudaMemcpy((void**)(thrust::raw_pointer_cast(lr->prm_d.data())), (void**)lr->prm[setMap[op_sel.front()]][i], 4*g_size, cudaMemcpyHostToDevice);
                    thrust::transform(lr->prm_d.begin(), lr->prm_d.begin() + g_size,
                                      res_tmp.begin() + curr_count, _1+(i*t->maxRecs));

                    curr_count = curr_count + lr->prm_count[setMap[op_sel.front()]][i];

                };

                if(left_check)
                    thrust::gather(d_res1.begin(), d_res1.end(), res_tmp.begin(), p.begin());
                else
                    thrust::gather(d_res2.begin(), d_res2.end(), res_tmp.begin(), p.begin());

                cudaMemcpy((void**)c->prm[setMap[op_sel.front()]][0], (void**)(thrust::raw_pointer_cast(p.data())), 4*d_res1.size(), cudaMemcpyDeviceToHost);
            }
            else { // copy d_res2 into prm[setMap[op_sel.front()]]
                if(left_check)
                    thrust::copy(d_res1.begin(), d_res1.end(), p.begin());
                else
                    thrust::copy(d_res2.begin(), d_res2.end(), p.begin());

                cudaMemcpy((void**)c->prm[setMap[op_sel.front()]][0], (void**)(thrust::raw_pointer_cast(p.data())), 4*d_res1.size(), cudaMemcpyDeviceToHost);
            }
        };
        op_sel.pop();
    };

    cout << "join final end " << d_res1.size() << "  " << getFreeMem() << endl;

    //right->d_res1
    //left->d_res2

    // modify left's and right's perm tables using D_res1 and d_res2


    left->deAllocOnDevice();
    right->deAllocOnDevice();

    for  (map<string, std::vector<unsigned int*> >::iterator it=left->prm.begin() ; it != left->prm.end(); ++it ) {
        varNames[(*it).first]->deAllocOnDevice();
    };
    for  (map<string, std::vector<unsigned int*> >::iterator it=right->prm.begin() ; it != right->prm.end(); ++it ) {
        varNames[(*it).first]->deAllocOnDevice();
    };


    varNames[s] = c;
    c->maxRecs = c->mRecCount;
    c->segCount = 1;
    clean_queues();


    if(stat[s] == statement_count) {
        c->free();
        varNames.erase(s);
    };

    if(stat[j1] == statement_count) {
        left->free();
        varNames.erase(j1);
    };

    if(stat[j2] == statement_count && (strcmp(j1,j2.c_str()) != 0)) {
        right->free();
        varNames.erase(j2);
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

    cout << "order: " << s << " " << f << endl;;


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
    CudaSet *b = a->copyStruct(a->mRecCount);
    b->isJoined = a->isJoined;

    // find the largest mRecSize of all data sources
    unsigned int maxSize = 0;
    stack<string> tp(exe_type);
    queue<string> op_vx;
    while (!tp.empty()) {
        op_vx.push(tp.top());
        CudaSet *t = varNames[setMap[tp.top()]];
        if(t->mRecCount > maxSize)
            maxSize = t->mRecCount;
        tp.pop();
    };

    void* temp;
    CUDA_SAFE_CALL(cudaMalloc((void **) &temp, maxSize*float_size));

    varNames[setMap[exe_type.top()]]->oldRecCount = varNames[setMap[exe_type.top()]]->mRecCount;
    allocColumns(a, op_vx);
    copyColumns(a, op_vx, 0);

    varNames[setMap[exe_type.top()]]->mRecCount = varNames[setMap[exe_type.top()]]->oldRecCount;

    for(int i=0; !exe_type.empty(); ++i, exe_type.pop(),exe_value.pop()) {
        int colInd = (a->columnNames).find(exe_type.top())->second;

        if ((a->type)[colInd] == 0)
            update_permutation(a->d_columns_int[a->type_index[colInd]], raw_ptr, a->mRecCount, exe_value.top(), (int_type*)temp);
        else if ((a->type)[colInd] == 1)
            update_permutation(a->d_columns_float[a->type_index[colInd]], raw_ptr, a->mRecCount,exe_value.top(), (float_type*)temp);
        else {
            CudaChar* c = a->h_columns_cuda_char[a->type_index[colInd]];
            for(int j=(c->mColumnCount)-1; j>=0 ; j--)
                update_permutation((c->d_columns)[j], raw_ptr, a->mRecCount, exe_value.top(), (char*)temp);
        };
    };

    // gather a's prm  to b's prm
    if(a->prm.size() != 0) {

        thrust::device_vector<unsigned int> p(a->mRecCount);
        thrust::device_vector<unsigned int> p_a(a->mRecCount);

        for ( map<string, std::vector<unsigned int*> >::iterator it=a->prm.begin() ; it != a->prm.end(); ++it ) {
            b->prm[(*it).first].push_back(new unsigned int[a->mRecCount]);
            b->prm_count[(*it).first].push_back(a->mRecCount);
            //p_a = (*it).second[0];
            cudaMemcpy((void**)(thrust::raw_pointer_cast(p_a.data())), (void**)(*it).second[0], 4*a->mRecCount, cudaMemcpyHostToDevice);
            thrust::gather(permutation, permutation+a->mRecCount, p_a.begin(), p.begin());
            //b->prm[(*it).first][0] = p;
            cudaMemcpy((void**)b->prm[(*it).first][0], (void**)(thrust::raw_pointer_cast(p.data())), 4*a->mRecCount, cudaMemcpyDeviceToHost);
        };
    }
    else {
        thrust::device_vector<unsigned int> p(a->mRecCount);
        b->prm[a->name].push_back(new unsigned int[a->mRecCount]);
        b->prm_count[a->name].push_back(a->mRecCount);
        thrust::copy(permutation, permutation+a->mRecCount, p.begin());
        //b->prm[a->name][0] = p;
        cudaMemcpy((void**)b->prm[a->name][0], (void**)(thrust::raw_pointer_cast(p.data())), 4*a->mRecCount, cudaMemcpyDeviceToHost);
    };

    b->deAllocOnDevice();
    a->deAllocOnDevice();


    thrust::device_free(permutation);
    cudaFree(temp);

    varNames[s] = b;
    b->segCount = 1;

    if (a->fact_table == 1)
        b->fact_table = 1;
    else
        b->fact_table = 0;

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


    if(a->mRecCount == 0) {
        CudaSet *c;
        c = new CudaSet(0,1);
        varNames[s] = c;
        clean_queues();
        return;
    };

    cout << "SELECT " << s << " " << f << endl;
    std::clock_t start1 = std::clock();

    // here we need to determine the column count and composition

    queue<string> op_v(op_value);
    queue<string> op_vx;
    set<string> field_names;
    map<string,string> aliases;
    string tt;

    for(int i=0; !op_v.empty(); ++i, op_v.pop()) {
        if(a->columnNames.find(op_v.front()) != a->columnNames.end()) {
            field_names.insert(op_v.front());
            if(aliases.count(op_v.front()) == 0 && aliases.size() < ll) {
                tt = op_v.front();
                op_v.pop();
                aliases[tt] = op_v.front();
            };

        };
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


    CudaSet* b, *c;

    allocColumns(a, op_vx);

    unsigned int cycle_count = 1;
    curr_segment = 100;
    if(a->prm.size() <= 1)
        cycle_count = varNames[setMap[op_value.front()]]->segCount;

    unsigned int ol_count = a->mRecCount;
    varNames[setMap[op_value.front()]]->oldRecCount = varNames[setMap[op_value.front()]]->mRecCount;
    //bck = a;

    for(unsigned int i = 0; i < cycle_count; i++) {          // MAIN CYCLE
        //cout << "cycle " << i << " select mem " << getFreeMem() << endl;
        std::clock_t start2 = std::clock();

        if(i == 0)
            b = new CudaSet(0, col_count);

        copyColumns(a, op_vx, i);


        CudaSet *t = varNames[setMap[op_vx.front()]];

        if (ll != 0) {
            thrust::device_ptr<unsigned int> perm = order_inplace(a,op_v2,field_names,i);
            thrust::device_free(perm);
            a->GroupBy(op_v3);
        };
        select(op_type,op_value,op_nums, op_nums_f,a,b, a->mRecCount);

        if(i == 1) {
            for ( map<string,int>::iterator it=b->columnNames.begin() ; it != b->columnNames.end(); ++it )
                setMap[(*it).first] = s;
        };

        if (ll != 0) {
            if (i == 0) {
                c = new CudaSet(b->mRecCount, col_count);
                c->fact_table = 1;
                c->segCount = 1;
            }
            else
                c->resize(b->mRecCount);
            add(c,b,op_v3);
        };
    };
    a->mRecCount = ol_count;
    varNames[setMap[op_value.front()]]->mRecCount = varNames[setMap[op_value.front()]]->oldRecCount;

    if(stat[f] == statement_count) {
        a->deAllocOnDevice();
    };


    if (ll != 0) {
        CudaSet *r = merge(c,op_v3, op_v2, aliases);
        c->free();
        c = r;
    };


    c->maxRecs = c->mRecCount;
    c->name = s;
    c->keep = 1;

    for ( map<string,int>::iterator it=c->columnNames.begin() ; it != c->columnNames.end(); ++it ) {
        setMap[(*it).first] = s;
    };

    cout << "final select " << c->mRecCount << endl;

    clean_queues();

    if (ll != 0) {
        varNames[s] = c;
        b->free();
    }
    else
        varNames[s] = b;

    varNames[s]->keep = 1;

    if(stat[s] == statement_count) {
        varNames[s]->free();
        varNames.erase(s);
    };

    if(stat[f] == statement_count && a->keep == 0) {
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

    a = varNames.find(f)->second;
    a->name = f;
    std::clock_t start1 = std::clock();

    if(a->mRecCount == 0) {
        b = new CudaSet(0,1);
    }
    else {
        cout << "FILTER " << s << " " << f << endl;

        std::clock_t start1 = std::clock();
        b = a->copyDeviceStruct();
        b->name = s;
        b->isJoined = a->isJoined;

        // if prm.size() <= 1 then process segment by segment
        // else copy entire column to gpu
        unsigned int cycle_count = 1;
        allocColumns(a, op_value);
        varNames[setMap[op_value.front()]]->oldRecCount = varNames[setMap[op_value.front()]]->mRecCount;

        if(!a->isJoined)
            cycle_count = varNames[setMap[op_value.front()]]->segCount;

        thrust::device_vector<unsigned int> p(a->maxRecs);
        curr_segment = 100;

        for(unsigned int i = 0; i < cycle_count; i++) {
            std::clock_t start2 = std::clock();
            copyColumns(a, op_value, i);
            filter(op_type,op_value,op_nums, op_nums_f,a, b, i, p);
        };
        varNames[setMap[op_value.front()]]->mRecCount = varNames[setMap[op_value.front()]]->oldRecCount;
        cout << "filter is finished " << b->mRecCount << " " << getFreeMem()  << endl;

        //dealloc sources
        for  (map<string, std::vector<unsigned int*> >::iterator it=a->prm.begin() ; it != a->prm.end(); ++it ) {
            varNames[(*it).first]->deAllocOnDevice();
        };
        a->deAllocOnDevice();
    };

    clean_queues();

    if (varNames.count(s) > 0)
        varNames[s]->free();

    varNames[s] = b;

    if(stat[s] == statement_count) {
        b->free();
        varNames.erase(s);
    };
    if(stat[f] == statement_count && !a->keep) {
        a->free();
        varNames.erase(f);
    };
    std::cout<< "filter time " <<  ( ( std::clock() - start1 ) / (double)CLOCKS_PER_SEC ) <<'\n';
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

    fact_file_loaded = 0;
    while(!fact_file_loaded)	{
        cout << "LOADING " << f_file << " " << separator << endl;
        fact_file_loaded = a->LoadBigFile(f_file.c_str(), separator.c_str());
        cout << "STORING " << f << " " << limit << endl;
        a->Store(f,"", limit, 1);
    };

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

    printf("BINARY LOAD: %s %s \n", s, f);
    std::clock_t start1 = std::clock();

    CudaSet *a;
    unsigned int segCount, maxRecs;
    char f1[100];
    strcpy(f1, f);
    strcat(f1,".");
    char col_pos[3];
    itoaa(cols.front(),col_pos);
    strcat(f1,col_pos);

    FILE* ff = fopen(f1, "rb");
    fseeko(ff, -16, SEEK_END);
    fread((char *)&totalRecs, 8, 1, ff);
    fread((char *)&segCount, 4, 1, ff);
    fread((char *)&maxRecs, 4, 1, ff);
    fclose(ff);

    queue<string> names(namevars);
    while(!names.empty()) {
        setMap[names.front()] = s;
        names.pop();
    };

    a = new CudaSet(namevars, typevars, sizevars, cols,totalRecs, f);
    a->segCount = segCount;
    a->maxRecs = maxRecs;
    a->keep = 1;
    varNames[s] = a;

    if(stat[s] == statement_count )  {
        a->free();
        varNames.erase(s);
    };
    std::cout<< "load time " <<  ( ( std::clock() - start1 ) / (double)CLOCKS_PER_SEC ) <<'\n';
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

    a = new CudaSet(namevars, typevars, sizevars, cols, process_count);
    a->mRecCount = 0;
    a->resize(process_count);
    a->keep = true;
    a->fact_table = 1;
    //a->LoadBigFile(f, sep);
    string separator1(sep);
    separator = separator1;
    string ff(f);
    f_file = ff;
    a->maxRecs = a->mRecCount;
    a->segCount = 0;
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
    while(!namevars.empty()) namevars.pop();
    while(!typevars.empty()) typevars.pop();
    while(!sizevars.empty()) sizevars.pop();
    while(!cols.empty()) cols.pop();

    sel_count = 0;
    join_cnt = 0;
    join_col_cnt = -1;
    eqq = 0;
}



int main(int ac, char **av)
{
    extern FILE *yyin;
    cudaDeviceProp deviceProp;

    cudaGetDeviceProperties(&deviceProp, 0);
    if (!deviceProp.canMapHostMemory)
        cout << "Device 0 cannot map host memory" << endl;

    cudaSetDeviceFlags(cudaDeviceMapHost);
    cudppCreate(&theCudpp);

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

    std::clock_t start1 = std::clock();
    statement_count = 0;
    clean_queues();

    if(ac > 1 && (yyin = fopen(av[ac-1], "r")) == NULL) {
        perror(av[1]);
        exit(1);
    }

    PROC_FLUSH_BUF ( yyin );
    statement_count = 0;

    if(!yyparse())
        cout << "SQL scan parse worked" << endl;
    else
        cout << "SQL scan parse failed" << endl;

    fclose(yyin);
    std::cout<< "cycle time " <<  ( ( std::clock() - start1 ) / (double)CLOCKS_PER_SEC ) <<'\n';
    cudppDestroy(theCudpp);

}

