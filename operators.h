#include "cm.h"
#include "filter.h"
#include "select.h"
#include "merge.h"
#include "sorts.cu"
#include "callbacks.h"


void emit_multijoin(const string s, const string j1, const string j2, const unsigned int tab, const char* res_name, const int start_segment, const int end_segment);
void clean_queues();
void order_inplace(CudaSet* a, stack<string> exe_type, bool update_int);
void yyerror(char *s, ...);
void emit(const char *s, ...);
void emit_mul();
void emit_add();
void emit_minus();
void emit_distinct();
void emit_cast();
void emit_year();
void emit_month();
void emit_day();
void emit_div();
void emit_and();
void emit_eq();
void emit_neq();
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
void emit_decimal(const char* str);
void emit_sel_name(const char* name);
void emit_limit(const int val);
void emit_union(const char *s, const char *f1, const char *f2);
void emit_varchar(const char *s, const int c, const char *f, const int d, const char *ref, const char* ref_name);
void emit_vardecimal(const char *s, const int c, const char *f, const int scale, const int precision);
void emit_load(const char *s, const char *f, const int d, const char* sep);
void emit_load_binary(const char *s, const char *f, const int d);
void emit_store(const char *s, const char *f, const char* sep);
void emit_store_binary(const char *s, const char *f, const bool append);
void emit_filter(char *s, char *f);
void emit_delete(const char *f);
void emit_insert(const char *f, const char* s);
void emit_order(const char *s, const char *f, const int e, const int ll = 0);
void emit_group(const char *s, const char *f, const int e);
void emit_select(const char *s, const char *f, const int grp_cnt);
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
void emit_create_index(const char *index_name, const char *table, const char *column);
void emit_create_interval(const char *interval_name, const char *table, const char *lcolumn, const char *rcolumn);
void emit_fieldname(const char* name1, const char* name2);
void load_vars();
void emit_string_grp(const char *str, const char *str_grp); 
