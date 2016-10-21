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
#include "operators.h"


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
%token <strval> DECIMAL1
%token <intval> BOOL1
%token <floatval> APPROXNUM
/* user @abc names */
%token <strval> USERVAR
/* operators and precedence levels */
%right ASSIGN
%right EQUAL
%right NONEQUAL
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
%token YEAR
%token MONTH
%token DAY
%token CAST_TO_INT
%token LEFT
%token RIGHT
%token OUTER
%token SEMI
%token ANTI
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
%token SHOW
%token TABLES
%token TABLE
%token DESCRIBE
%token DROP
%token CREATE
%token INDEX
%token INTERVAL
%token APPEND

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
{  emit_store_binary($2,$4,0); }
| STORE NAME INTO FILENAME APPEND opt_limit BINARY sort_def
{  emit_store_binary($2,$4,1); }
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
| CREATE INDEX NAME ON NAME '(' NAME '.' NAME ')' FROM NAME ',' NAME WHERE NAME '.' NAME EQUAL NAME '.' NAME
{  emit_create_bitmap_index($3, $5, $7, $9, $18, $22);}
| CREATE INDEX NAME ON NAME '(' NAME ')'
{  emit_create_index($3, $5, $7);}
| CREATE INTERVAL NAME ON NAME '(' NAME ',' NAME ')'
{  emit_create_interval($3, $5, $7, $9);};



expr:
NAME { emit_name($1); }
| NAME '.' NAME { emit_fieldname($1, $3); }
| USERVAR { emit("USERVAR %s", $1); }
| STRING { emit_string($1); }
| INTNUM { emit_number($1); }
| DECIMAL1 { emit_decimal($1); }
| APPROXNUM { emit_float($1); }
| BOOL1 { emit("BOOL %d", $1); }
| NAME '{' INTNUM '}' ':' NAME '(' INTNUM ',' INTNUM ')' { emit_vardecimal($1, $3, $6,  $8, $10);}
| NAME '{' INTNUM '}' ':' NAME '(' INTNUM ')' { emit_varchar($1, $3, $6, $8, "", "");}
| NAME '{' INTNUM '}' ':' NAME  { emit_var($1, $3, $6, "", "");}
| NAME ASC { emit_var_asc($1);}
| NAME DESC { emit_var_desc($1);}
| COUNT '(' expr ')' { emit_count(); }
| SUM '(' expr ')' { emit_sum(); }
| AVG '(' expr ')' { emit_average(); }
| MIN '(' expr ')' { emit_min(); }
| MAX '(' expr ')' { emit_max(); }
| DISTINCT expr { emit_distinct(); }
| YEAR '(' expr ')' { emit_year(); }
| MONTH '(' expr ')' { emit_month(); }
| DAY '(' expr ')' { emit_day(); }
| CAST_TO_INT '(' expr ')' { emit_cast(); }
| NAME '(' STRING ')' { emit_string_grp($1, $3); } 
;

expr:
expr '+' expr { emit_add(); }
| expr '-' expr { emit_minus(); }
| expr '*' expr { emit_mul(); }
| expr '/' expr { emit_div(); }
| expr '%' expr { emit("MOD"); }
| expr MOD expr { emit("MOD"); }
| expr AND expr { emit_and(); }
| expr EQUAL expr { emit_eq(); }
| expr NONEQUAL expr { emit_neq(); }
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
| LEFT ANTI JOIN  NAME ON expr { $$ = 1; emit_join_tab($4, '3');}
| RIGHT ANTI JOIN NAME ON expr { $$ = 1; emit_join_tab($4, '4');}
| LEFT SEMI JOIN NAME ON expr { $$ = 1; emit_join_tab($4, '1');}
| LEFT JOIN NAME ON expr { $$ = 1; emit_join_tab($3, 'S');}
| RIGHT JOIN NAME ON expr { $$ = 1; emit_join_tab($3, 'R');}
| RIGHT SEMI JOIN NAME ON expr { $$ = 1; emit_join_tab($4, '2');}
| OUTER JOIN NAME ON expr { $$ = 1; emit_join_tab($3, 'O');}
| JOIN NAME ON expr join_list { $$ = 1; emit_join_tab($2, 'I'); };
| LEFT ANTI JOIN NAME ON expr join_list { $$ = 1; emit_join_tab($4, '3'); };
| RIGHT ANTI JOIN NAME ON expr join_list { $$ = 1; emit_join_tab($4, '4'); };
| LEFT JOIN NAME ON expr join_list { $$ = 1; emit_join_tab($3, 'L'); };
| LEFT SEMI JOIN NAME ON expr join_list { $$ = 1; emit_join_tab($4, '1'); };
| RIGHT JOIN NAME ON expr join_list { $$ = 1; emit_join_tab($3, 'R'); };
| RIGHT SEMI JOIN NAME ON expr join_list { $$ = 1; emit_join_tab($4, 'R'); };
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

bool scan_state;
unsigned int statement_count;
time_t curr_time;

int execute_file(int ac, char **av)
{
    bool just_once  = 0;
    string script;
    process_count = 1000000000; //1GB by default
    verbose = 0;
	ssd = 0;
	delta = 0;
    total_buffer_size = 0;
	hash_seed = 100;

    for (int i = 1; i < ac; i++) {
        if(strcmp(av[i],"-l") == 0) {
            process_count = 1000000*atoff(av[i+1]);
        }
        else if(strcmp(av[i],"-v") == 0) {
            verbose = 1;
        }
        else if(strcmp(av[i],"-delta") == 0) {
            delta = 1;
        }		
        else if(strcmp(av[i],"-ssd") == 0) {
            ssd = 1;
        }		
        else if(strcmp(av[i],"-precision") == 0) {
            prs = atoi(av[i+1]);
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
	tot_disk = 0;

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
		filter_var.clear();

        yyin = fopen(av[ac-1], "r");
        PROC_FLUSH_BUF ( yyin );
        statement_count = 0;
        extern FILE *yyin;		
		curr_time = time(0)*1000;
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
			cout<< "disk time " << ( tot_disk / (double)CLOCKS_PER_SEC ) << " " << getFreeMem() << endl;
        };
    }
    else {
        //context = CreateCudaDevice(0, nullptr, verbose);        
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
			filter_var.clear();
            yy_scan_string(script.c_str());
            std::clock_t start1 = std::clock();
			curr_time = time(0)*1000;
			
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
			cudaFreeHost(buffers[buffer_names.front()]);
            buffer_sizes.erase(buffer_names.front());
            buffers.erase(buffer_names.front());
            buffer_names.pop();
        };
		for(auto it = index_buffers.begin(); it != index_buffers.end();it++) {
			cudaFreeHost(it->second);
        };
		for(auto it = idx_vals.begin(); it != idx_vals.end();it++) {
			cudaFree(it->second);
		idx_vals.clear();	
    };
	

    };
    if(save_dict) {
        save_col_data(data_dict,"data.dictionary");
	};	

    if(alloced_sz) {
        cudaFree(alloced_tmp);
        alloced_sz = 0;
    };
	if(scratch.size()) {
		scratch.resize(0);
		scratch.shrink_to_fit();
	};	
	if(rcol_dev.size()) {
		rcol_dev.resize(0);
		rcol_dev.shrink_to_fit();
	};
	if(ranj.size()) {
		ranj.resize(0);
		ranj.shrink_to_fit();
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


