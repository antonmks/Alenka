
/* A Bison parser, made by GNU Bison 2.4.1.  */

/* Skeleton implementation for Bison's Yacc-like parsers in C
   
      Copyright (C) 1984, 1989, 1990, 2000, 2001, 2002, 2003, 2004, 2005, 2006
   Free Software Foundation, Inc.
   
   This program is free software: you can redistribute it and/or modify
   it under the terms of the GNU General Public License as published by
   the Free Software Foundation, either version 3 of the License, or
   (at your option) any later version.
   
   This program is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
   GNU General Public License for more details.
   
   You should have received a copy of the GNU General Public License
   along with this program.  If not, see <http://www.gnu.org/licenses/>.  */

/* As a special exception, you may create a larger work that contains
   part or all of the Bison parser skeleton and distribute that work
   under terms of your choice, so long as that work isn't itself a
   parser generator using the skeleton or a modified version thereof
   as a parser skeleton.  Alternatively, if you modify or redistribute
   the parser skeleton itself, you may (at your option) remove this
   special exception, which will cause the skeleton and the resulting
   Bison output files to be licensed under the GNU General Public
   License without this special exception.
   
   This special exception was added by the Free Software Foundation in
   version 2.2 of Bison.  */

/* C LALR(1) parser skeleton written by Richard Stallman, by
   simplifying the original so-called "semantic" parser.  */

/* All symbols defined below should begin with yy or YY, to avoid
   infringing on user name space.  This should be done even for local
   variables, as they might otherwise be expanded by user macros.
   There are some unavoidable exceptions within include files to
   define necessary library symbols; they are noted "INFRINGES ON
   USER NAME SPACE" below.  */

/* Identify Bison output.  */
#define YYBISON 1

/* Bison version.  */
#define YYBISON_VERSION "2.4.1"

/* Skeleton name.  */
#define YYSKELETON_NAME "yacc.c"

/* Pure parsers.  */
#define YYPURE 0

/* Push parsers.  */
#define YYPUSH 0

/* Pull parsers.  */
#define YYPULL 1

/* Using locations.  */
#define YYLSP_NEEDED 0



/* Copy the first part of user declarations.  */

/* Line 189 of yacc.c  */
#line 17 "bison.y"



#include "lex.yy.c"
#include "cm.h"

    void clean_queues();
    void order_inplace(CudaSet* a, stack<string> exe_type, bool update_int);
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
    void emit_var(char *s, int c, char *f, char* ref, char* ref_name);
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
    void emit_varchar(char *s, int c, char *f, int d, char *ref, char* ref_name);	
    void emit_load(char *s, char *f, int d, char* sep);
    void emit_load_binary(const char *s, const char *f, int d);
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
	void emit_show_tables();
	void emit_describe_table(char* table_name);
	void emit_drop_table(char* table_name);
	void process_error(int severity, string err);



/* Line 189 of yacc.c  */
#line 136 "bison.tab.c"

/* Enabling traces.  */
#ifndef YYDEBUG
# define YYDEBUG 0
#endif

/* Enabling verbose error messages.  */
#ifdef YYERROR_VERBOSE
# undef YYERROR_VERBOSE
# define YYERROR_VERBOSE 1
#else
# define YYERROR_VERBOSE 0
#endif

/* Enabling the token table.  */
#ifndef YYTOKEN_TABLE
# define YYTOKEN_TABLE 0
#endif


/* Tokens.  */
#ifndef YYTOKENTYPE
# define YYTOKENTYPE
   /* Put the tokens into the symbol table, so that GDB and other debuggers
      know about them.  */
   enum yytokentype {
     FILENAME = 258,
     NAME = 259,
     STRING = 260,
     INTNUM = 261,
     DECIMAL1 = 262,
     BOOL1 = 263,
     APPROXNUM = 264,
     USERVAR = 265,
     ASSIGN = 266,
     EQUAL = 267,
     OR = 268,
     XOR = 269,
     AND = 270,
     DISTINCT = 271,
     REGEXP = 272,
     LIKE = 273,
     IS = 274,
     IN = 275,
     NOT = 276,
     BETWEEN = 277,
     COMPARISON = 278,
     SHIFT = 279,
     MOD = 280,
     FROM = 281,
     MULITE = 282,
     DELETE = 283,
     LOAD = 284,
     FILTER = 285,
     BY = 286,
     JOIN = 287,
     STORE = 288,
     INTO = 289,
     GROUP = 290,
     SELECT = 291,
     AS = 292,
     ORDER = 293,
     ASC = 294,
     DESC = 295,
     COUNT = 296,
     USING = 297,
     SUM = 298,
     AVG = 299,
     MIN = 300,
     MAX = 301,
     LIMIT = 302,
     ON = 303,
     BINARY = 304,
     LEFT = 305,
     RIGHT = 306,
     OUTER = 307,
     SORT = 308,
     SEGMENTS = 309,
     PRESORTED = 310,
     PARTITION = 311,
     INSERT = 312,
     WHERE = 313,
     DISPLAY = 314,
     CASE = 315,
     WHEN = 316,
     THEN = 317,
     ELSE = 318,
     END = 319,
     REFERENCES = 320,
     SHOW = 321,
     TABLES = 322,
     TABLE = 323,
     DESCRIBE = 324,
     DROP = 325
   };
#endif



#if ! defined YYSTYPE && ! defined YYSTYPE_IS_DECLARED
typedef union YYSTYPE
{

/* Line 214 of yacc.c  */
#line 79 "bison.y"

    long long int intval;
    double floatval;
    char *strval;
    int subtok;



/* Line 214 of yacc.c  */
#line 251 "bison.tab.c"
} YYSTYPE;
# define YYSTYPE_IS_TRIVIAL 1
# define yystype YYSTYPE /* obsolescent; will be withdrawn */
# define YYSTYPE_IS_DECLARED 1
#endif


/* Copy the second part of user declarations.  */


/* Line 264 of yacc.c  */
#line 263 "bison.tab.c"

#ifdef short
# undef short
#endif

#ifdef YYTYPE_UINT8
typedef YYTYPE_UINT8 yytype_uint8;
#else
typedef unsigned char yytype_uint8;
#endif

#ifdef YYTYPE_INT8
typedef YYTYPE_INT8 yytype_int8;
#elif (defined __STDC__ || defined __C99__FUNC__ \
     || defined __cplusplus || defined _MSC_VER)
typedef signed char yytype_int8;
#else
typedef short int yytype_int8;
#endif

#ifdef YYTYPE_UINT16
typedef YYTYPE_UINT16 yytype_uint16;
#else
typedef unsigned short int yytype_uint16;
#endif

#ifdef YYTYPE_INT16
typedef YYTYPE_INT16 yytype_int16;
#else
typedef short int yytype_int16;
#endif

#ifndef YYSIZE_T
# ifdef __SIZE_TYPE__
#  define YYSIZE_T __SIZE_TYPE__
# elif defined size_t
#  define YYSIZE_T size_t
# elif ! defined YYSIZE_T && (defined __STDC__ || defined __C99__FUNC__ \
     || defined __cplusplus || defined _MSC_VER)
#  include <stddef.h> /* INFRINGES ON USER NAME SPACE */
#  define YYSIZE_T size_t
# else
#  define YYSIZE_T unsigned int
# endif
#endif

#define YYSIZE_MAXIMUM ((YYSIZE_T) -1)

#ifndef YY_
# if YYENABLE_NLS
#  if ENABLE_NLS
#   include <libintl.h> /* INFRINGES ON USER NAME SPACE */
#   define YY_(msgid) dgettext ("bison-runtime", msgid)
#  endif
# endif
# ifndef YY_
#  define YY_(msgid) msgid
# endif
#endif

/* Suppress unused-variable warnings by "using" E.  */
#if ! defined lint || defined __GNUC__
# define YYUSE(e) ((void) (e))
#else
# define YYUSE(e) /* empty */
#endif

/* Identity function, used to suppress warnings about constant conditions.  */
#ifndef lint
# define YYID(n) (n)
#else
#if (defined __STDC__ || defined __C99__FUNC__ \
     || defined __cplusplus || defined _MSC_VER)
static int
YYID (int yyi)
#else
static int
YYID (yyi)
    int yyi;
#endif
{
  return yyi;
}
#endif

#if ! defined yyoverflow || YYERROR_VERBOSE

/* The parser invokes alloca or malloc; define the necessary symbols.  */

# ifdef YYSTACK_USE_ALLOCA
#  if YYSTACK_USE_ALLOCA
#   ifdef __GNUC__
#    define YYSTACK_ALLOC __builtin_alloca
#   elif defined __BUILTIN_VA_ARG_INCR
#    include <alloca.h> /* INFRINGES ON USER NAME SPACE */
#   elif defined _AIX
#    define YYSTACK_ALLOC __alloca
#   elif defined _MSC_VER
#    include <malloc.h> /* INFRINGES ON USER NAME SPACE */
#    define alloca _alloca
#   else
#    define YYSTACK_ALLOC alloca
#    if ! defined _ALLOCA_H && ! defined _STDLIB_H && (defined __STDC__ || defined __C99__FUNC__ \
     || defined __cplusplus || defined _MSC_VER)
#     include <stdlib.h> /* INFRINGES ON USER NAME SPACE */
#     ifndef _STDLIB_H
#      define _STDLIB_H 1
#     endif
#    endif
#   endif
#  endif
# endif

# ifdef YYSTACK_ALLOC
   /* Pacify GCC's `empty if-body' warning.  */
#  define YYSTACK_FREE(Ptr) do { /* empty */; } while (YYID (0))
#  ifndef YYSTACK_ALLOC_MAXIMUM
    /* The OS might guarantee only one guard page at the bottom of the stack,
       and a page size can be as small as 4096 bytes.  So we cannot safely
       invoke alloca (N) if N exceeds 4096.  Use a slightly smaller number
       to allow for a few compiler-allocated temporary stack slots.  */
#   define YYSTACK_ALLOC_MAXIMUM 4032 /* reasonable circa 2006 */
#  endif
# else
#  define YYSTACK_ALLOC YYMALLOC
#  define YYSTACK_FREE YYFREE
#  ifndef YYSTACK_ALLOC_MAXIMUM
#   define YYSTACK_ALLOC_MAXIMUM YYSIZE_MAXIMUM
#  endif
#  if (defined __cplusplus && ! defined _STDLIB_H \
       && ! ((defined YYMALLOC || defined malloc) \
	     && (defined YYFREE || defined free)))
#   include <stdlib.h> /* INFRINGES ON USER NAME SPACE */
#   ifndef _STDLIB_H
#    define _STDLIB_H 1
#   endif
#  endif
#  ifndef YYMALLOC
#   define YYMALLOC malloc
#   if ! defined malloc && ! defined _STDLIB_H && (defined __STDC__ || defined __C99__FUNC__ \
     || defined __cplusplus || defined _MSC_VER)
void *malloc (YYSIZE_T); /* INFRINGES ON USER NAME SPACE */
#   endif
#  endif
#  ifndef YYFREE
#   define YYFREE free
#   if ! defined free && ! defined _STDLIB_H && (defined __STDC__ || defined __C99__FUNC__ \
     || defined __cplusplus || defined _MSC_VER)
void free (void *); /* INFRINGES ON USER NAME SPACE */
#   endif
#  endif
# endif
#endif /* ! defined yyoverflow || YYERROR_VERBOSE */


#if (! defined yyoverflow \
     && (! defined __cplusplus \
	 || (defined YYSTYPE_IS_TRIVIAL && YYSTYPE_IS_TRIVIAL)))

/* A type that is properly aligned for any stack member.  */
union yyalloc
{
  yytype_int16 yyss_alloc;
  YYSTYPE yyvs_alloc;
};

/* The size of the maximum gap between one aligned stack and the next.  */
# define YYSTACK_GAP_MAXIMUM (sizeof (union yyalloc) - 1)

/* The size of an array large to enough to hold all stacks, each with
   N elements.  */
# define YYSTACK_BYTES(N) \
     ((N) * (sizeof (yytype_int16) + sizeof (YYSTYPE)) \
      + YYSTACK_GAP_MAXIMUM)

/* Copy COUNT objects from FROM to TO.  The source and destination do
   not overlap.  */
# ifndef YYCOPY
#  if defined __GNUC__ && 1 < __GNUC__
#   define YYCOPY(To, From, Count) \
      __builtin_memcpy (To, From, (Count) * sizeof (*(From)))
#  else
#   define YYCOPY(To, From, Count)		\
      do					\
	{					\
	  YYSIZE_T yyi;				\
	  for (yyi = 0; yyi < (Count); yyi++)	\
	    (To)[yyi] = (From)[yyi];		\
	}					\
      while (YYID (0))
#  endif
# endif

/* Relocate STACK from its old location to the new one.  The
   local variables YYSIZE and YYSTACKSIZE give the old and new number of
   elements in the stack, and YYPTR gives the new location of the
   stack.  Advance YYPTR to a properly aligned location for the next
   stack.  */
# define YYSTACK_RELOCATE(Stack_alloc, Stack)				\
    do									\
      {									\
	YYSIZE_T yynewbytes;						\
	YYCOPY (&yyptr->Stack_alloc, Stack, yysize);			\
	Stack = &yyptr->Stack_alloc;					\
	yynewbytes = yystacksize * sizeof (*Stack) + YYSTACK_GAP_MAXIMUM; \
	yyptr += yynewbytes / sizeof (*yyptr);				\
      }									\
    while (YYID (0))

#endif

/* YYFINAL -- State number of the termination state.  */
#define YYFINAL  20
/* YYLAST -- Last index in YYTABLE.  */
#define YYLAST   679

/* YYNTOKENS -- Number of terminals.  */
#define YYNTOKENS  88
/* YYNNTS -- Number of nonterminals.  */
#define YYNNTS  14
/* YYNRULES -- Number of rules.  */
#define YYNRULES  84
/* YYNRULES -- Number of states.  */
#define YYNSTATES  228

/* YYTRANSLATE(YYLEX) -- Bison symbol number corresponding to YYLEX.  */
#define YYUNDEFTOK  2
#define YYMAXUTOK   325

#define YYTRANSLATE(YYX)						\
  ((unsigned int) (YYX) <= YYMAXUTOK ? yytranslate[YYX] : YYUNDEFTOK)

/* YYTRANSLATE[YYLEX] -- Bison symbol number corresponding to YYLEX.  */
static const yytype_uint8 yytranslate[] =
{
       0,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,    21,     2,     2,     2,    32,    26,     2,
      81,    82,    30,    28,    87,    29,    83,    31,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,    86,    80,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,    34,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,    84,    25,    85,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     1,     2,     3,     4,
       5,     6,     7,     8,     9,    10,    11,    12,    13,    14,
      15,    16,    17,    18,    19,    20,    22,    23,    24,    27,
      33,    35,    36,    37,    38,    39,    40,    41,    42,    43,
      44,    45,    46,    47,    48,    49,    50,    51,    52,    53,
      54,    55,    56,    57,    58,    59,    60,    61,    62,    63,
      64,    65,    66,    67,    68,    69,    70,    71,    72,    73,
      74,    75,    76,    77,    78,    79
};

#if YYDEBUG
/* YYPRHS[YYN] -- Index of the first RHS symbol of rule number YYN in
   YYRHS.  */
static const yytype_uint16 yyprhs[] =
{
       0,     0,     3,     6,    10,    12,    20,    33,    39,    46,
      55,    65,    73,    76,    84,    90,    98,   101,   105,   107,
     111,   113,   115,   117,   119,   121,   123,   138,   148,   160,
     167,   170,   173,   178,   183,   188,   193,   198,   201,   203,
     207,   211,   215,   219,   223,   227,   231,   235,   239,   243,
     247,   250,   253,   257,   261,   267,   271,   280,   284,   289,
     290,   294,   298,   304,   306,   308,   312,   314,   318,   319,
     321,   324,   329,   335,   341,   347,   353,   360,   367,   374,
     375,   378,   379,   384,   392
};

/* YYRHS -- A `-1'-separated list of the rules' RHS.  */
static const yytype_int8 yyrhs[] =
{
      89,     0,    -1,    90,    80,    -1,    89,    90,    80,    -1,
      91,    -1,     4,    11,    45,    94,    35,     4,    93,    -1,
       4,    11,    38,     3,    51,    81,     3,    82,    46,    81,
      95,    82,    -1,     4,    11,    39,     4,    98,    -1,     4,
      11,    47,     4,    40,    97,    -1,     4,    11,    45,    94,
      35,     4,    99,    93,    -1,    42,     4,    43,     3,    51,
      81,     3,    82,   100,    -1,    42,     4,    43,     3,   100,
      58,   101,    -1,    78,     4,    -1,    66,    43,     4,    45,
      94,    35,     4,    -1,    37,    35,     4,    67,    92,    -1,
      68,     4,    51,    81,     3,    82,   100,    -1,    75,    76,
      -1,    79,    77,     4,    -1,     4,    -1,     4,    83,     4,
      -1,    10,    -1,     5,    -1,     6,    -1,     9,    -1,     7,
      -1,     8,    -1,     4,    84,     6,    85,    86,     4,    81,
       6,    82,    74,     4,    81,     4,    82,    -1,     4,    84,
       6,    85,    86,     4,    81,     6,    82,    -1,     4,    84,
       6,    85,    86,     4,    74,     4,    81,     4,    82,    -1,
       4,    84,     6,    85,    86,     4,    -1,     4,    48,    -1,
       4,    49,    -1,    50,    81,    92,    82,    -1,    52,    81,
      92,    82,    -1,    53,    81,    92,    82,    -1,    54,    81,
      92,    82,    -1,    55,    81,    92,    82,    -1,    16,    92,
      -1,    41,    -1,    92,    28,    92,    -1,    92,    29,    92,
      -1,    92,    30,    92,    -1,    92,    31,    92,    -1,    92,
      32,    92,    -1,    92,    33,    92,    -1,    92,    15,    92,
      -1,    92,    12,    92,    -1,    92,    13,    92,    -1,    92,
      14,    92,    -1,    92,    27,    92,    -1,    22,    92,    -1,
      21,    92,    -1,    92,    24,    92,    -1,    92,    18,    92,
      -1,    92,    24,    81,    91,    82,    -1,    81,    92,    82,
      -1,    69,    70,    92,    71,    92,    72,    92,    73,    -1,
      92,    19,     8,    -1,    92,    19,    22,     8,    -1,    -1,
      44,    40,    96,    -1,    92,    46,     4,    -1,    94,    87,
      92,    46,     4,    -1,    30,    -1,    92,    -1,    95,    87,
      92,    -1,    92,    -1,    92,    87,    96,    -1,    -1,    96,
      -1,    40,    92,    -1,    41,     4,    57,    92,    -1,    59,
      41,     4,    57,    92,    -1,    60,    41,     4,    57,    92,
      -1,    61,    41,     4,    57,    92,    -1,    41,     4,    57,
      92,    99,    -1,    59,    41,     4,    57,    92,    99,    -1,
      60,    41,     4,    57,    92,    99,    -1,    61,    41,     4,
      57,    92,    99,    -1,    -1,    56,     6,    -1,    -1,    62,
      63,    40,     4,    -1,    62,    63,    40,     4,    65,    40,
       6,    -1,    64,    40,     4,    -1
};

/* YYRLINE[YYN] -- source line where rule number YYN was defined.  */
static const yytype_uint16 yyrline[] =
{
       0,   171,   171,   172,   176,   179,   181,   183,   185,   187,
     189,   191,   193,   195,   197,   199,   201,   203,   208,   209,
     210,   211,   212,   213,   214,   215,   216,   217,   218,   219,
     220,   221,   222,   223,   224,   225,   226,   227,   228,   232,
     233,   234,   235,   236,   237,   239,   240,   241,   242,   243,
     244,   245,   246,   247,   249,   250,   251,   255,   256,   259,
     262,   266,   267,   268,   272,   273,   277,   278,   281,   283,
     286,   290,   291,   292,   293,   294,   295,   296,   297,   299,
     302,   304,   307,   308,   309
};
#endif

#if YYDEBUG || YYERROR_VERBOSE || YYTOKEN_TABLE
/* YYTNAME[SYMBOL-NUM] -- String name of the symbol SYMBOL-NUM.
   First, the terminals, then, starting at YYNTOKENS, nonterminals.  */
static const char *const yytname[] =
{
  "$end", "error", "$undefined", "FILENAME", "NAME", "STRING", "INTNUM",
  "DECIMAL1", "BOOL1", "APPROXNUM", "USERVAR", "ASSIGN", "EQUAL", "OR",
  "XOR", "AND", "DISTINCT", "REGEXP", "LIKE", "IS", "IN", "'!'", "NOT",
  "BETWEEN", "COMPARISON", "'|'", "'&'", "SHIFT", "'+'", "'-'", "'*'",
  "'/'", "'%'", "MOD", "'^'", "FROM", "MULITE", "DELETE", "LOAD", "FILTER",
  "BY", "JOIN", "STORE", "INTO", "GROUP", "SELECT", "AS", "ORDER", "ASC",
  "DESC", "COUNT", "USING", "SUM", "AVG", "MIN", "MAX", "LIMIT", "ON",
  "BINARY", "LEFT", "RIGHT", "OUTER", "SORT", "SEGMENTS", "PRESORTED",
  "PARTITION", "INSERT", "WHERE", "DISPLAY", "CASE", "WHEN", "THEN",
  "ELSE", "END", "REFERENCES", "SHOW", "TABLES", "TABLE", "DESCRIBE",
  "DROP", "';'", "'('", "')'", "'.'", "'{'", "'}'", "':'", "','",
  "$accept", "stmt_list", "stmt", "select_stmt", "expr", "opt_group_list",
  "expr_list", "load_list", "val_list", "opt_val_list", "opt_where",
  "join_list", "opt_limit", "sort_def", 0
};
#endif

# ifdef YYPRINT
/* YYTOKNUM[YYLEX-NUM] -- Internal token number corresponding to
   token YYLEX-NUM.  */
static const yytype_uint16 yytoknum[] =
{
       0,   256,   257,   258,   259,   260,   261,   262,   263,   264,
     265,   266,   267,   268,   269,   270,   271,   272,   273,   274,
     275,    33,   276,   277,   278,   124,    38,   279,    43,    45,
      42,    47,    37,   280,    94,   281,   282,   283,   284,   285,
     286,   287,   288,   289,   290,   291,   292,   293,   294,   295,
     296,   297,   298,   299,   300,   301,   302,   303,   304,   305,
     306,   307,   308,   309,   310,   311,   312,   313,   314,   315,
     316,   317,   318,   319,   320,   321,   322,   323,   324,   325,
      59,    40,    41,    46,   123,   125,    58,    44
};
# endif

/* YYR1[YYN] -- Symbol number of symbol that rule YYN derives.  */
static const yytype_uint8 yyr1[] =
{
       0,    88,    89,    89,    90,    91,    91,    91,    91,    91,
      91,    91,    91,    91,    91,    91,    91,    91,    92,    92,
      92,    92,    92,    92,    92,    92,    92,    92,    92,    92,
      92,    92,    92,    92,    92,    92,    92,    92,    92,    92,
      92,    92,    92,    92,    92,    92,    92,    92,    92,    92,
      92,    92,    92,    92,    92,    92,    92,    92,    92,    93,
      93,    94,    94,    94,    95,    95,    96,    96,    97,    97,
      98,    99,    99,    99,    99,    99,    99,    99,    99,   100,
     100,   101,   101,   101,   101
};

/* YYR2[YYN] -- Number of symbols composing right hand side of rule YYN.  */
static const yytype_uint8 yyr2[] =
{
       0,     2,     2,     3,     1,     7,    12,     5,     6,     8,
       9,     7,     2,     7,     5,     7,     2,     3,     1,     3,
       1,     1,     1,     1,     1,     1,    14,     9,    11,     6,
       2,     2,     4,     4,     4,     4,     4,     2,     1,     3,
       3,     3,     3,     3,     3,     3,     3,     3,     3,     3,
       2,     2,     3,     3,     5,     3,     8,     3,     4,     0,
       3,     3,     5,     1,     1,     3,     1,     3,     0,     1,
       2,     4,     5,     5,     5,     5,     6,     6,     6,     0,
       2,     0,     4,     7,     3
};

/* YYDEFACT[STATE-NAME] -- Default rule to reduce with in state
   STATE-NUM when YYTABLE doesn't specify something else to do.  Zero
   means the default is an error.  */
static const yytype_uint8 yydefact[] =
{
       0,     0,     0,     0,     0,     0,     0,     0,     0,     0,
       0,     4,     0,     0,     0,     0,     0,    16,    12,     0,
       1,     0,     2,     0,     0,     0,     0,     0,     0,     0,
       0,    17,     3,     0,     0,    18,    21,    22,    24,    25,
      23,    20,     0,     0,     0,    63,    38,     0,     0,     0,
       0,     0,     0,     0,     0,     0,     0,     0,    79,     0,
       0,     0,     0,     7,    30,    31,     0,     0,    37,    51,
      50,     0,     0,     0,     0,     0,     0,     0,     0,     0,
       0,     0,     0,     0,     0,     0,     0,     0,     0,     0,
       0,     0,     0,     0,     0,    68,    14,     0,     0,     0,
       0,     0,     0,    70,    19,     0,     0,     0,     0,     0,
       0,     0,    55,    46,    47,    48,    45,    53,    57,     0,
       0,    52,    49,    39,    40,    41,    42,    43,    44,    61,
      59,     0,    66,    69,     8,     0,    80,    81,     0,    79,
       0,     0,    32,    33,    34,    35,    36,     0,    58,    18,
       0,     0,     0,     0,     0,     0,     5,    59,     0,     0,
       0,     0,     0,    11,    13,    15,     0,     0,     0,    54,
       0,     0,     0,     0,     0,     9,    62,    67,    79,     0,
       0,     0,    29,     0,     0,    60,     0,     0,     0,    10,
       0,    84,     0,     0,     0,     0,    71,     0,     0,     0,
      82,    64,     0,     0,     0,    56,    75,    72,    73,    74,
       0,     6,     0,     0,    27,    76,    77,    78,     0,    65,
       0,     0,    83,    28,     0,     0,     0,    26
};

/* YYDEFGOTO[NTERM-NUM].  */
static const yytype_int16 yydefgoto[] =
{
      -1,     9,    10,    11,   132,   156,    55,   202,   133,   134,
      63,   157,    99,   163
};

/* YYPACT[STATE-NUM] -- Index in YYTABLE of the portion describing
   STATE-NUM.  */
#define YYPACT_NINF -184
static const yytype_int16 yypact[] =
{
      34,    -6,   -23,    16,   -22,    23,   -43,    41,   -19,     2,
     -28,  -184,   117,    71,    36,    81,    42,  -184,  -184,    90,
    -184,    17,  -184,    93,    95,   172,    97,    38,   103,    65,
      30,  -184,  -184,    67,    80,   -41,  -184,  -184,  -184,  -184,
    -184,  -184,   224,   224,   224,  -184,  -184,    40,    52,    58,
      59,    68,    83,   224,   565,   -20,   112,   224,   -15,   172,
     151,    85,   224,  -184,  -184,  -184,   161,   162,   630,   114,
     114,   224,   224,   224,   224,   224,   224,   320,   224,   224,
     224,   224,   224,     1,   276,   224,   224,   224,   224,   224,
     224,   224,   165,   166,   224,   224,   614,    94,   178,   113,
     -13,   101,   182,   614,  -184,   115,   346,   368,   391,   424,
     447,   519,  -184,   614,   292,   239,   630,   646,  -184,   189,
      82,    98,   186,    84,    84,  -184,  -184,  -184,  -184,  -184,
     -30,   591,   177,  -184,  -184,   183,  -184,    20,   194,   143,
     121,   125,  -184,  -184,  -184,  -184,  -184,   224,  -184,    24,
     130,   216,   181,   195,   196,   197,  -184,   179,   231,   224,
     157,   180,   202,  -184,  -184,  -184,   198,   243,   495,  -184,
     191,   224,   245,   246,   247,  -184,  -184,  -184,   143,   212,
     251,   175,   -71,   224,   224,  -184,   203,   204,   205,  -184,
     255,  -184,   224,   269,   281,   469,   541,   224,   224,   224,
     210,   614,    -4,   207,   208,  -184,  -184,   541,   541,   541,
     249,  -184,   224,   287,   220,  -184,  -184,  -184,   289,   614,
     214,   295,  -184,  -184,   219,   297,   221,  -184
};

/* YYPGOTO[NTERM-NUM].  */
static const yytype_int16 yypgoto[] =
{
    -184,  -184,   293,   184,   -25,   152,   253,  -184,  -155,  -184,
    -184,  -183,  -138,  -184
};

/* YYTABLE[YYPACT[STATE-NUM]].  What to do in state STATE-NUM.  If
   positive, shift that token.  If negative, reduce the rule which
   number is the opposite.  If zero, do what YYDEFACT says.
   If YYTABLE_NINF, syntax error.  */
#define YYTABLE_NINF -1
static const yytype_int16 yytable[] =
{
      54,   165,    20,   193,   177,    12,     1,    64,    65,   118,
     194,   151,    13,   206,   152,    93,   185,    68,    69,    70,
      14,    15,   138,   119,   215,   216,   217,    16,    77,   153,
     154,   155,    96,    17,    54,    12,    97,   103,     1,     2,
     189,    98,    66,    67,     3,    18,   106,   107,   108,   109,
     110,   111,    22,   113,   114,   115,   116,   117,    19,   121,
     122,   123,   124,   125,   126,   127,   128,    94,     4,   131,
       5,     2,    64,    65,    94,    27,     3,     6,   211,    28,
       7,     8,   161,   212,   162,    29,   149,    36,    37,    38,
      39,    40,    41,    30,    31,    77,    33,    32,    42,    34,
       4,    56,     5,    43,    44,    57,    58,    66,    67,     6,
      59,    60,     7,     8,    88,    89,    90,    91,    61,     2,
      62,    71,   168,    46,     3,    85,    86,    87,    88,    89,
      90,    91,    47,    72,    48,    49,    50,    51,    84,    73,
      74,    85,    86,    87,    88,    89,    90,    91,     4,    75,
       5,    52,    95,    76,   101,    23,    24,     6,   195,   196,
       7,     8,    25,    53,    26,   104,   102,   201,   105,   129,
     130,   137,   207,   208,   209,   135,    35,    36,    37,    38,
      39,    40,    41,   139,   136,   140,   160,   219,    42,    78,
      79,    80,    81,    43,    44,    82,    83,   148,   164,    98,
     141,    84,    45,   166,    85,    86,    87,    88,    89,    90,
      91,   167,   169,    46,    86,    87,    88,    89,    90,    91,
     170,   171,    47,   152,    48,    49,    50,    51,    35,    36,
      37,    38,    39,    40,    41,   176,   172,   173,   174,   178,
      42,    52,   180,   179,   181,    43,    44,   182,   184,   186,
     187,   188,   190,    53,    81,   191,   192,    82,    83,   200,
     197,   198,   199,    84,   159,    46,    85,    86,    87,    88,
      89,    90,    91,   203,    47,   210,    48,    49,    50,    51,
      35,    36,    37,    38,    39,    40,    41,   204,   213,   218,
     214,   220,    42,    52,   221,   222,   223,    43,    44,   224,
     225,   226,    21,   227,   150,    53,    80,    81,     0,   175,
      82,    83,   100,     0,     0,     0,    84,    46,     0,    85,
      86,    87,    88,    89,    90,    91,    47,     0,    48,    49,
      50,    51,    78,    79,    80,    81,     0,     0,    82,    83,
       0,     0,     0,     0,    84,    52,     0,    85,    86,    87,
      88,    89,    90,    91,     0,     0,     0,   120,    78,    79,
      80,    81,     0,     0,    82,    83,     0,     0,     0,     0,
      84,     0,     0,    85,    86,    87,    88,    89,    90,    91,
      78,    79,    80,    81,     0,     0,    82,    83,     0,     0,
       0,     0,    84,     0,     0,    85,    86,    87,    88,    89,
      90,    91,   112,    78,    79,    80,    81,     0,     0,    82,
      83,     0,     0,     0,     0,    84,     0,     0,    85,    86,
      87,    88,    89,    90,    91,     0,     0,     0,   142,     0,
       0,     0,     0,     0,     0,     0,    78,    79,    80,    81,
       0,     0,    82,    83,     0,     0,     0,     0,    84,     0,
     143,    85,    86,    87,    88,    89,    90,    91,     0,    78,
      79,    80,    81,     0,     0,    82,    83,     0,     0,     0,
       0,    84,     0,   144,    85,    86,    87,    88,    89,    90,
      91,    78,    79,    80,    81,     0,     0,    82,    83,     0,
       0,     0,     0,    84,     0,     0,    85,    86,    87,    88,
      89,    90,    91,     0,     0,     0,   145,    78,    79,    80,
      81,     0,     0,    82,    83,     0,     0,     0,     0,    84,
       0,     0,    85,    86,    87,    88,    89,    90,    91,   146,
       0,    78,    79,    80,    81,     0,     0,    82,    83,     0,
       0,     0,   205,    84,     0,     0,    85,    86,    87,    88,
      89,    90,    91,    78,    79,    80,    81,     0,     0,    82,
      83,     0,     0,     0,     0,    84,     0,   183,    85,    86,
      87,    88,    89,    90,    91,     0,     0,    78,    79,    80,
      81,     0,   151,    82,    83,     0,     0,     0,     0,    84,
     147,     0,    85,    86,    87,    88,    89,    90,    91,     0,
     153,   154,   155,    78,    79,    80,    81,     0,     0,    82,
      83,    92,     0,     0,     0,    84,     0,     0,    85,    86,
      87,    88,    89,    90,    91,     0,    78,    79,    80,    81,
       0,     0,    82,    83,     0,     0,     0,   158,    84,     0,
       0,    85,    86,    87,    88,    89,    90,    91,    82,    83,
       0,     0,     0,     0,    84,     0,     0,    85,    86,    87,
      88,    89,    90,    91,    -1,    -1,     0,     0,     0,     0,
      84,     0,     0,    85,    86,    87,    88,    89,    90,    91
};

static const yytype_int16 yycheck[] =
{
      25,   139,     0,    74,   159,    11,     4,    48,    49,     8,
      81,    41,    35,   196,    44,    35,   171,    42,    43,    44,
       4,    43,    35,    22,   207,   208,   209,     4,    53,    59,
      60,    61,    57,    76,    59,    11,    51,    62,     4,    37,
     178,    56,    83,    84,    42,     4,    71,    72,    73,    74,
      75,    76,    80,    78,    79,    80,    81,    82,    77,    84,
      85,    86,    87,    88,    89,    90,    91,    87,    66,    94,
      68,    37,    48,    49,    87,     4,    42,    75,    82,    43,
      78,    79,    62,    87,    64,     4,     4,     5,     6,     7,
       8,     9,    10,    51,     4,   120,     3,    80,    16,     4,
      66,     4,    68,    21,    22,    67,     3,    83,    84,    75,
      45,    81,    78,    79,    30,    31,    32,    33,    51,    37,
      40,    81,   147,    41,    42,    27,    28,    29,    30,    31,
      32,    33,    50,    81,    52,    53,    54,    55,    24,    81,
      81,    27,    28,    29,    30,    31,    32,    33,    66,    81,
      68,    69,    40,    70,     3,    38,    39,    75,   183,   184,
      78,    79,    45,    81,    47,     4,    81,   192,     6,     4,
       4,    58,   197,   198,   199,    81,     4,     5,     6,     7,
       8,     9,    10,    82,     6,     3,     3,   212,    16,    12,
      13,    14,    15,    21,    22,    18,    19,     8,     4,    56,
      85,    24,    30,    82,    27,    28,    29,    30,    31,    32,
      33,    86,    82,    41,    28,    29,    30,    31,    32,    33,
       4,    40,    50,    44,    52,    53,    54,    55,     4,     5,
       6,     7,     8,     9,    10,     4,    41,    41,    41,    82,
      16,    69,    40,    63,    46,    21,    22,     4,    57,     4,
       4,     4,    40,    81,    15,     4,    81,    18,    19,     4,
      57,    57,    57,    24,    87,    41,    27,    28,    29,    30,
      31,    32,    33,     4,    50,    65,    52,    53,    54,    55,
       4,     5,     6,     7,     8,     9,    10,     6,    81,    40,
      82,     4,    16,    69,    74,     6,    82,    21,    22,     4,
      81,     4,     9,    82,   120,    81,    14,    15,    -1,   157,
      18,    19,    59,    -1,    -1,    -1,    24,    41,    -1,    27,
      28,    29,    30,    31,    32,    33,    50,    -1,    52,    53,
      54,    55,    12,    13,    14,    15,    -1,    -1,    18,    19,
      -1,    -1,    -1,    -1,    24,    69,    -1,    27,    28,    29,
      30,    31,    32,    33,    -1,    -1,    -1,    81,    12,    13,
      14,    15,    -1,    -1,    18,    19,    -1,    -1,    -1,    -1,
      24,    -1,    -1,    27,    28,    29,    30,    31,    32,    33,
      12,    13,    14,    15,    -1,    -1,    18,    19,    -1,    -1,
      -1,    -1,    24,    -1,    -1,    27,    28,    29,    30,    31,
      32,    33,    82,    12,    13,    14,    15,    -1,    -1,    18,
      19,    -1,    -1,    -1,    -1,    24,    -1,    -1,    27,    28,
      29,    30,    31,    32,    33,    -1,    -1,    -1,    82,    -1,
      -1,    -1,    -1,    -1,    -1,    -1,    12,    13,    14,    15,
      -1,    -1,    18,    19,    -1,    -1,    -1,    -1,    24,    -1,
      82,    27,    28,    29,    30,    31,    32,    33,    -1,    12,
      13,    14,    15,    -1,    -1,    18,    19,    -1,    -1,    -1,
      -1,    24,    -1,    82,    27,    28,    29,    30,    31,    32,
      33,    12,    13,    14,    15,    -1,    -1,    18,    19,    -1,
      -1,    -1,    -1,    24,    -1,    -1,    27,    28,    29,    30,
      31,    32,    33,    -1,    -1,    -1,    82,    12,    13,    14,
      15,    -1,    -1,    18,    19,    -1,    -1,    -1,    -1,    24,
      -1,    -1,    27,    28,    29,    30,    31,    32,    33,    82,
      -1,    12,    13,    14,    15,    -1,    -1,    18,    19,    -1,
      -1,    -1,    73,    24,    -1,    -1,    27,    28,    29,    30,
      31,    32,    33,    12,    13,    14,    15,    -1,    -1,    18,
      19,    -1,    -1,    -1,    -1,    24,    -1,    72,    27,    28,
      29,    30,    31,    32,    33,    -1,    -1,    12,    13,    14,
      15,    -1,    41,    18,    19,    -1,    -1,    -1,    -1,    24,
      71,    -1,    27,    28,    29,    30,    31,    32,    33,    -1,
      59,    60,    61,    12,    13,    14,    15,    -1,    -1,    18,
      19,    46,    -1,    -1,    -1,    24,    -1,    -1,    27,    28,
      29,    30,    31,    32,    33,    -1,    12,    13,    14,    15,
      -1,    -1,    18,    19,    -1,    -1,    -1,    46,    24,    -1,
      -1,    27,    28,    29,    30,    31,    32,    33,    18,    19,
      -1,    -1,    -1,    -1,    24,    -1,    -1,    27,    28,    29,
      30,    31,    32,    33,    18,    19,    -1,    -1,    -1,    -1,
      24,    -1,    -1,    27,    28,    29,    30,    31,    32,    33
};

/* YYSTOS[STATE-NUM] -- The (internal number of the) accessing
   symbol of state STATE-NUM.  */
static const yytype_uint8 yystos[] =
{
       0,     4,    37,    42,    66,    68,    75,    78,    79,    89,
      90,    91,    11,    35,     4,    43,     4,    76,     4,    77,
       0,    90,    80,    38,    39,    45,    47,     4,    43,     4,
      51,     4,    80,     3,     4,     4,     5,     6,     7,     8,
       9,    10,    16,    21,    22,    30,    41,    50,    52,    53,
      54,    55,    69,    81,    92,    94,     4,    67,     3,    45,
      81,    51,    40,    98,    48,    49,    83,    84,    92,    92,
      92,    81,    81,    81,    81,    81,    70,    92,    12,    13,
      14,    15,    18,    19,    24,    27,    28,    29,    30,    31,
      32,    33,    46,    35,    87,    40,    92,    51,    56,   100,
      94,     3,    81,    92,     4,     6,    92,    92,    92,    92,
      92,    92,    82,    92,    92,    92,    92,    92,     8,    22,
      81,    92,    92,    92,    92,    92,    92,    92,    92,     4,
       4,    92,    92,    96,    97,    81,     6,    58,    35,    82,
       3,    85,    82,    82,    82,    82,    82,    71,     8,     4,
      91,    41,    44,    59,    60,    61,    93,    99,    46,    87,
       3,    62,    64,   101,     4,   100,    82,    86,    92,    82,
       4,    40,    41,    41,    41,    93,     4,    96,    82,    63,
      40,    46,     4,    72,    57,    96,     4,     4,     4,   100,
      40,     4,    81,    74,    81,    92,    92,    57,    57,    57,
       4,    92,    95,     4,     6,    73,    99,    92,    92,    92,
      65,    82,    87,    81,    82,    99,    99,    99,    40,    92,
       4,    74,     6,    82,     4,    81,     4,    82
};

#define yyerrok		(yyerrstatus = 0)
#define yyclearin	(yychar = YYEMPTY)
#define YYEMPTY		(-2)
#define YYEOF		0

#define YYACCEPT	goto yyacceptlab
#define YYABORT		goto yyabortlab
#define YYERROR		goto yyerrorlab


/* Like YYERROR except do call yyerror.  This remains here temporarily
   to ease the transition to the new meaning of YYERROR, for GCC.
   Once GCC version 2 has supplanted version 1, this can go.  */

#define YYFAIL		goto yyerrlab

#define YYRECOVERING()  (!!yyerrstatus)

#define YYBACKUP(Token, Value)					\
do								\
  if (yychar == YYEMPTY && yylen == 1)				\
    {								\
      yychar = (Token);						\
      yylval = (Value);						\
      yytoken = YYTRANSLATE (yychar);				\
      YYPOPSTACK (1);						\
      goto yybackup;						\
    }								\
  else								\
    {								\
      yyerror (YY_("syntax error: cannot back up")); \
      YYERROR;							\
    }								\
while (YYID (0))


#define YYTERROR	1
#define YYERRCODE	256


/* YYLLOC_DEFAULT -- Set CURRENT to span from RHS[1] to RHS[N].
   If N is 0, then set CURRENT to the empty location which ends
   the previous symbol: RHS[0] (always defined).  */

#define YYRHSLOC(Rhs, K) ((Rhs)[K])
#ifndef YYLLOC_DEFAULT
# define YYLLOC_DEFAULT(Current, Rhs, N)				\
    do									\
      if (YYID (N))                                                    \
	{								\
	  (Current).first_line   = YYRHSLOC (Rhs, 1).first_line;	\
	  (Current).first_column = YYRHSLOC (Rhs, 1).first_column;	\
	  (Current).last_line    = YYRHSLOC (Rhs, N).last_line;		\
	  (Current).last_column  = YYRHSLOC (Rhs, N).last_column;	\
	}								\
      else								\
	{								\
	  (Current).first_line   = (Current).last_line   =		\
	    YYRHSLOC (Rhs, 0).last_line;				\
	  (Current).first_column = (Current).last_column =		\
	    YYRHSLOC (Rhs, 0).last_column;				\
	}								\
    while (YYID (0))
#endif


/* YY_LOCATION_PRINT -- Print the location on the stream.
   This macro was not mandated originally: define only if we know
   we won't break user code: when these are the locations we know.  */

#ifndef YY_LOCATION_PRINT
# if YYLTYPE_IS_TRIVIAL
#  define YY_LOCATION_PRINT(File, Loc)			\
     fprintf (File, "%d.%d-%d.%d",			\
	      (Loc).first_line, (Loc).first_column,	\
	      (Loc).last_line,  (Loc).last_column)
# else
#  define YY_LOCATION_PRINT(File, Loc) ((void) 0)
# endif
#endif


/* YYLEX -- calling `yylex' with the right arguments.  */

#ifdef YYLEX_PARAM
# define YYLEX yylex (YYLEX_PARAM)
#else
# define YYLEX yylex ()
#endif

/* Enable debugging if requested.  */
#if YYDEBUG

# ifndef YYFPRINTF
#  include <stdio.h> /* INFRINGES ON USER NAME SPACE */
#  define YYFPRINTF fprintf
# endif

# define YYDPRINTF(Args)			\
do {						\
  if (yydebug)					\
    YYFPRINTF Args;				\
} while (YYID (0))

# define YY_SYMBOL_PRINT(Title, Type, Value, Location)			  \
do {									  \
  if (yydebug)								  \
    {									  \
      YYFPRINTF (stderr, "%s ", Title);					  \
      yy_symbol_print (stderr,						  \
		  Type, Value); \
      YYFPRINTF (stderr, "\n");						  \
    }									  \
} while (YYID (0))


/*--------------------------------.
| Print this symbol on YYOUTPUT.  |
`--------------------------------*/

/*ARGSUSED*/
#if (defined __STDC__ || defined __C99__FUNC__ \
     || defined __cplusplus || defined _MSC_VER)
static void
yy_symbol_value_print (FILE *yyoutput, int yytype, YYSTYPE const * const yyvaluep)
#else
static void
yy_symbol_value_print (yyoutput, yytype, yyvaluep)
    FILE *yyoutput;
    int yytype;
    YYSTYPE const * const yyvaluep;
#endif
{
  if (!yyvaluep)
    return;
# ifdef YYPRINT
  if (yytype < YYNTOKENS)
    YYPRINT (yyoutput, yytoknum[yytype], *yyvaluep);
# else
  YYUSE (yyoutput);
# endif
  switch (yytype)
    {
      default:
	break;
    }
}


/*--------------------------------.
| Print this symbol on YYOUTPUT.  |
`--------------------------------*/

#if (defined __STDC__ || defined __C99__FUNC__ \
     || defined __cplusplus || defined _MSC_VER)
static void
yy_symbol_print (FILE *yyoutput, int yytype, YYSTYPE const * const yyvaluep)
#else
static void
yy_symbol_print (yyoutput, yytype, yyvaluep)
    FILE *yyoutput;
    int yytype;
    YYSTYPE const * const yyvaluep;
#endif
{
  if (yytype < YYNTOKENS)
    YYFPRINTF (yyoutput, "token %s (", yytname[yytype]);
  else
    YYFPRINTF (yyoutput, "nterm %s (", yytname[yytype]);

  yy_symbol_value_print (yyoutput, yytype, yyvaluep);
  YYFPRINTF (yyoutput, ")");
}

/*------------------------------------------------------------------.
| yy_stack_print -- Print the state stack from its BOTTOM up to its |
| TOP (included).                                                   |
`------------------------------------------------------------------*/

#if (defined __STDC__ || defined __C99__FUNC__ \
     || defined __cplusplus || defined _MSC_VER)
static void
yy_stack_print (yytype_int16 *yybottom, yytype_int16 *yytop)
#else
static void
yy_stack_print (yybottom, yytop)
    yytype_int16 *yybottom;
    yytype_int16 *yytop;
#endif
{
  YYFPRINTF (stderr, "Stack now");
  for (; yybottom <= yytop; yybottom++)
    {
      int yybot = *yybottom;
      YYFPRINTF (stderr, " %d", yybot);
    }
  YYFPRINTF (stderr, "\n");
}

# define YY_STACK_PRINT(Bottom, Top)				\
do {								\
  if (yydebug)							\
    yy_stack_print ((Bottom), (Top));				\
} while (YYID (0))


/*------------------------------------------------.
| Report that the YYRULE is going to be reduced.  |
`------------------------------------------------*/

#if (defined __STDC__ || defined __C99__FUNC__ \
     || defined __cplusplus || defined _MSC_VER)
static void
yy_reduce_print (YYSTYPE *yyvsp, int yyrule)
#else
static void
yy_reduce_print (yyvsp, yyrule)
    YYSTYPE *yyvsp;
    int yyrule;
#endif
{
  int yynrhs = yyr2[yyrule];
  int yyi;
  unsigned long int yylno = yyrline[yyrule];
  YYFPRINTF (stderr, "Reducing stack by rule %d (line %lu):\n",
	     yyrule - 1, yylno);
  /* The symbols being reduced.  */
  for (yyi = 0; yyi < yynrhs; yyi++)
    {
      YYFPRINTF (stderr, "   $%d = ", yyi + 1);
      yy_symbol_print (stderr, yyrhs[yyprhs[yyrule] + yyi],
		       &(yyvsp[(yyi + 1) - (yynrhs)])
		       		       );
      YYFPRINTF (stderr, "\n");
    }
}

# define YY_REDUCE_PRINT(Rule)		\
do {					\
  if (yydebug)				\
    yy_reduce_print (yyvsp, Rule); \
} while (YYID (0))

/* Nonzero means print parse trace.  It is left uninitialized so that
   multiple parsers can coexist.  */
int yydebug;
#else /* !YYDEBUG */
# define YYDPRINTF(Args)
# define YY_SYMBOL_PRINT(Title, Type, Value, Location)
# define YY_STACK_PRINT(Bottom, Top)
# define YY_REDUCE_PRINT(Rule)
#endif /* !YYDEBUG */


/* YYINITDEPTH -- initial size of the parser's stacks.  */
#ifndef	YYINITDEPTH
# define YYINITDEPTH 200
#endif

/* YYMAXDEPTH -- maximum size the stacks can grow to (effective only
   if the built-in stack extension method is used).

   Do not make this value too large; the results are undefined if
   YYSTACK_ALLOC_MAXIMUM < YYSTACK_BYTES (YYMAXDEPTH)
   evaluated with infinite-precision integer arithmetic.  */

#ifndef YYMAXDEPTH
# define YYMAXDEPTH 10000
#endif



#if YYERROR_VERBOSE

# ifndef yystrlen
#  if defined __GLIBC__ && defined _STRING_H
#   define yystrlen strlen
#  else
/* Return the length of YYSTR.  */
#if (defined __STDC__ || defined __C99__FUNC__ \
     || defined __cplusplus || defined _MSC_VER)
static YYSIZE_T
yystrlen (const char *yystr)
#else
static YYSIZE_T
yystrlen (yystr)
    const char *yystr;
#endif
{
  YYSIZE_T yylen;
  for (yylen = 0; yystr[yylen]; yylen++)
    continue;
  return yylen;
}
#  endif
# endif

# ifndef yystpcpy
#  if defined __GLIBC__ && defined _STRING_H && defined _GNU_SOURCE
#   define yystpcpy stpcpy
#  else
/* Copy YYSRC to YYDEST, returning the address of the terminating '\0' in
   YYDEST.  */
#if (defined __STDC__ || defined __C99__FUNC__ \
     || defined __cplusplus || defined _MSC_VER)
static char *
yystpcpy (char *yydest, const char *yysrc)
#else
static char *
yystpcpy (yydest, yysrc)
    char *yydest;
    const char *yysrc;
#endif
{
  char *yyd = yydest;
  const char *yys = yysrc;

  while ((*yyd++ = *yys++) != '\0')
    continue;

  return yyd - 1;
}
#  endif
# endif

# ifndef yytnamerr
/* Copy to YYRES the contents of YYSTR after stripping away unnecessary
   quotes and backslashes, so that it's suitable for yyerror.  The
   heuristic is that double-quoting is unnecessary unless the string
   contains an apostrophe, a comma, or backslash (other than
   backslash-backslash).  YYSTR is taken from yytname.  If YYRES is
   null, do not copy; instead, return the length of what the result
   would have been.  */
static YYSIZE_T
yytnamerr (char *yyres, const char *yystr)
{
  if (*yystr == '"')
    {
      YYSIZE_T yyn = 0;
      char const *yyp = yystr;

      for (;;)
	switch (*++yyp)
	  {
	  case '\'':
	  case ',':
	    goto do_not_strip_quotes;

	  case '\\':
	    if (*++yyp != '\\')
	      goto do_not_strip_quotes;
	    /* Fall through.  */
	  default:
	    if (yyres)
	      yyres[yyn] = *yyp;
	    yyn++;
	    break;

	  case '"':
	    if (yyres)
	      yyres[yyn] = '\0';
	    return yyn;
	  }
    do_not_strip_quotes: ;
    }

  if (! yyres)
    return yystrlen (yystr);

  return yystpcpy (yyres, yystr) - yyres;
}
# endif

/* Copy into YYRESULT an error message about the unexpected token
   YYCHAR while in state YYSTATE.  Return the number of bytes copied,
   including the terminating null byte.  If YYRESULT is null, do not
   copy anything; just return the number of bytes that would be
   copied.  As a special case, return 0 if an ordinary "syntax error"
   message will do.  Return YYSIZE_MAXIMUM if overflow occurs during
   size calculation.  */
static YYSIZE_T
yysyntax_error (char *yyresult, int yystate, int yychar)
{
  int yyn = yypact[yystate];

  if (! (YYPACT_NINF < yyn && yyn <= YYLAST))
    return 0;
  else
    {
      int yytype = YYTRANSLATE (yychar);
      YYSIZE_T yysize0 = yytnamerr (0, yytname[yytype]);
      YYSIZE_T yysize = yysize0;
      YYSIZE_T yysize1;
      int yysize_overflow = 0;
      enum { YYERROR_VERBOSE_ARGS_MAXIMUM = 5 };
      char const *yyarg[YYERROR_VERBOSE_ARGS_MAXIMUM];
      int yyx;

# if 0
      /* This is so xgettext sees the translatable formats that are
	 constructed on the fly.  */
      YY_("syntax error, unexpected %s");
      YY_("syntax error, unexpected %s, expecting %s");
      YY_("syntax error, unexpected %s, expecting %s or %s");
      YY_("syntax error, unexpected %s, expecting %s or %s or %s");
      YY_("syntax error, unexpected %s, expecting %s or %s or %s or %s");
# endif
      char *yyfmt;
      char const *yyf;
      static char const yyunexpected[] = "syntax error, unexpected %s";
      static char const yyexpecting[] = ", expecting %s";
      static char const yyor[] = " or %s";
      char yyformat[sizeof yyunexpected
		    + sizeof yyexpecting - 1
		    + ((YYERROR_VERBOSE_ARGS_MAXIMUM - 2)
		       * (sizeof yyor - 1))];
      char const *yyprefix = yyexpecting;

      /* Start YYX at -YYN if negative to avoid negative indexes in
	 YYCHECK.  */
      int yyxbegin = yyn < 0 ? -yyn : 0;

      /* Stay within bounds of both yycheck and yytname.  */
      int yychecklim = YYLAST - yyn + 1;
      int yyxend = yychecklim < YYNTOKENS ? yychecklim : YYNTOKENS;
      int yycount = 1;

      yyarg[0] = yytname[yytype];
      yyfmt = yystpcpy (yyformat, yyunexpected);

      for (yyx = yyxbegin; yyx < yyxend; ++yyx)
	if (yycheck[yyx + yyn] == yyx && yyx != YYTERROR)
	  {
	    if (yycount == YYERROR_VERBOSE_ARGS_MAXIMUM)
	      {
		yycount = 1;
		yysize = yysize0;
		yyformat[sizeof yyunexpected - 1] = '\0';
		break;
	      }
	    yyarg[yycount++] = yytname[yyx];
	    yysize1 = yysize + yytnamerr (0, yytname[yyx]);
	    yysize_overflow |= (yysize1 < yysize);
	    yysize = yysize1;
	    yyfmt = yystpcpy (yyfmt, yyprefix);
	    yyprefix = yyor;
	  }

      yyf = YY_(yyformat);
      yysize1 = yysize + yystrlen (yyf);
      yysize_overflow |= (yysize1 < yysize);
      yysize = yysize1;

      if (yysize_overflow)
	return YYSIZE_MAXIMUM;

      if (yyresult)
	{
	  /* Avoid sprintf, as that infringes on the user's name space.
	     Don't have undefined behavior even if the translation
	     produced a string with the wrong number of "%s"s.  */
	  char *yyp = yyresult;
	  int yyi = 0;
	  while ((*yyp = *yyf) != '\0')
	    {
	      if (*yyp == '%' && yyf[1] == 's' && yyi < yycount)
		{
		  yyp += yytnamerr (yyp, yyarg[yyi++]);
		  yyf += 2;
		}
	      else
		{
		  yyp++;
		  yyf++;
		}
	    }
	}
      return yysize;
    }
}
#endif /* YYERROR_VERBOSE */


/*-----------------------------------------------.
| Release the memory associated to this symbol.  |
`-----------------------------------------------*/

/*ARGSUSED*/
#if (defined __STDC__ || defined __C99__FUNC__ \
     || defined __cplusplus || defined _MSC_VER)
static void
yydestruct (const char *yymsg, int yytype, YYSTYPE *yyvaluep)
#else
static void
yydestruct (yymsg, yytype, yyvaluep)
    const char *yymsg;
    int yytype;
    YYSTYPE *yyvaluep;
#endif
{
  YYUSE (yyvaluep);

  if (!yymsg)
    yymsg = "Deleting";
  YY_SYMBOL_PRINT (yymsg, yytype, yyvaluep, yylocationp);

  switch (yytype)
    {

      default:
	break;
    }
}

/* Prevent warnings from -Wmissing-prototypes.  */
#ifdef YYPARSE_PARAM
#if defined __STDC__ || defined __cplusplus
int yyparse (void *YYPARSE_PARAM);
#else
int yyparse ();
#endif
#else /* ! YYPARSE_PARAM */
#if defined __STDC__ || defined __cplusplus
int yyparse (void);
#else
int yyparse ();
#endif
#endif /* ! YYPARSE_PARAM */


/* The lookahead symbol.  */
int yychar;

/* The semantic value of the lookahead symbol.  */
YYSTYPE yylval;

/* Number of syntax errors so far.  */
int yynerrs;



/*-------------------------.
| yyparse or yypush_parse.  |
`-------------------------*/

#ifdef YYPARSE_PARAM
#if (defined __STDC__ || defined __C99__FUNC__ \
     || defined __cplusplus || defined _MSC_VER)
int
yyparse (void *YYPARSE_PARAM)
#else
int
yyparse (YYPARSE_PARAM)
    void *YYPARSE_PARAM;
#endif
#else /* ! YYPARSE_PARAM */
#if (defined __STDC__ || defined __C99__FUNC__ \
     || defined __cplusplus || defined _MSC_VER)
int
yyparse (void)
#else
int
yyparse ()

#endif
#endif
{


    int yystate;
    /* Number of tokens to shift before error messages enabled.  */
    int yyerrstatus;

    /* The stacks and their tools:
       `yyss': related to states.
       `yyvs': related to semantic values.

       Refer to the stacks thru separate pointers, to allow yyoverflow
       to reallocate them elsewhere.  */

    /* The state stack.  */
    yytype_int16 yyssa[YYINITDEPTH];
    yytype_int16 *yyss;
    yytype_int16 *yyssp;

    /* The semantic value stack.  */
    YYSTYPE yyvsa[YYINITDEPTH];
    YYSTYPE *yyvs;
    YYSTYPE *yyvsp;

    YYSIZE_T yystacksize;

  int yyn;
  int yyresult;
  /* Lookahead token as an internal (translated) token number.  */
  int yytoken;
  /* The variables used to return semantic value and location from the
     action routines.  */
  YYSTYPE yyval;

#if YYERROR_VERBOSE
  /* Buffer for error messages, and its allocated size.  */
  char yymsgbuf[128];
  char *yymsg = yymsgbuf;
  YYSIZE_T yymsg_alloc = sizeof yymsgbuf;
#endif

#define YYPOPSTACK(N)   (yyvsp -= (N), yyssp -= (N))

  /* The number of symbols on the RHS of the reduced rule.
     Keep to zero when no symbol should be popped.  */
  int yylen = 0;

  yytoken = 0;
  yyss = yyssa;
  yyvs = yyvsa;
  yystacksize = YYINITDEPTH;

  YYDPRINTF ((stderr, "Starting parse\n"));

  yystate = 0;
  yyerrstatus = 0;
  yynerrs = 0;
  yychar = YYEMPTY; /* Cause a token to be read.  */

  /* Initialize stack pointers.
     Waste one element of value and location stack
     so that they stay on the same level as the state stack.
     The wasted elements are never initialized.  */
  yyssp = yyss;
  yyvsp = yyvs;

  goto yysetstate;

/*------------------------------------------------------------.
| yynewstate -- Push a new state, which is found in yystate.  |
`------------------------------------------------------------*/
 yynewstate:
  /* In all cases, when you get here, the value and location stacks
     have just been pushed.  So pushing a state here evens the stacks.  */
  yyssp++;

 yysetstate:
  *yyssp = yystate;

  if (yyss + yystacksize - 1 <= yyssp)
    {
      /* Get the current used size of the three stacks, in elements.  */
      YYSIZE_T yysize = yyssp - yyss + 1;

#ifdef yyoverflow
      {
	/* Give user a chance to reallocate the stack.  Use copies of
	   these so that the &'s don't force the real ones into
	   memory.  */
	YYSTYPE *yyvs1 = yyvs;
	yytype_int16 *yyss1 = yyss;

	/* Each stack pointer address is followed by the size of the
	   data in use in that stack, in bytes.  This used to be a
	   conditional around just the two extra args, but that might
	   be undefined if yyoverflow is a macro.  */
	yyoverflow (YY_("memory exhausted"),
		    &yyss1, yysize * sizeof (*yyssp),
		    &yyvs1, yysize * sizeof (*yyvsp),
		    &yystacksize);

	yyss = yyss1;
	yyvs = yyvs1;
      }
#else /* no yyoverflow */
# ifndef YYSTACK_RELOCATE
      goto yyexhaustedlab;
# else
      /* Extend the stack our own way.  */
      if (YYMAXDEPTH <= yystacksize)
	goto yyexhaustedlab;
      yystacksize *= 2;
      if (YYMAXDEPTH < yystacksize)
	yystacksize = YYMAXDEPTH;

      {
	yytype_int16 *yyss1 = yyss;
	union yyalloc *yyptr =
	  (union yyalloc *) YYSTACK_ALLOC (YYSTACK_BYTES (yystacksize));
	if (! yyptr)
	  goto yyexhaustedlab;
	YYSTACK_RELOCATE (yyss_alloc, yyss);
	YYSTACK_RELOCATE (yyvs_alloc, yyvs);
#  undef YYSTACK_RELOCATE
	if (yyss1 != yyssa)
	  YYSTACK_FREE (yyss1);
      }
# endif
#endif /* no yyoverflow */

      yyssp = yyss + yysize - 1;
      yyvsp = yyvs + yysize - 1;

      YYDPRINTF ((stderr, "Stack size increased to %lu\n",
		  (unsigned long int) yystacksize));

      if (yyss + yystacksize - 1 <= yyssp)
	YYABORT;
    }

  YYDPRINTF ((stderr, "Entering state %d\n", yystate));

  if (yystate == YYFINAL)
    YYACCEPT;

  goto yybackup;

/*-----------.
| yybackup.  |
`-----------*/
yybackup:

  /* Do appropriate processing given the current state.  Read a
     lookahead token if we need one and don't already have one.  */

  /* First try to decide what to do without reference to lookahead token.  */
  yyn = yypact[yystate];
  if (yyn == YYPACT_NINF)
    goto yydefault;

  /* Not known => get a lookahead token if don't already have one.  */

  /* YYCHAR is either YYEMPTY or YYEOF or a valid lookahead symbol.  */
  if (yychar == YYEMPTY)
    {
      YYDPRINTF ((stderr, "Reading a token: "));
      yychar = YYLEX;
    }

  if (yychar <= YYEOF)
    {
      yychar = yytoken = YYEOF;
      YYDPRINTF ((stderr, "Now at end of input.\n"));
    }
  else
    {
      yytoken = YYTRANSLATE (yychar);
      YY_SYMBOL_PRINT ("Next token is", yytoken, &yylval, &yylloc);
    }

  /* If the proper action on seeing token YYTOKEN is to reduce or to
     detect an error, take that action.  */
  yyn += yytoken;
  if (yyn < 0 || YYLAST < yyn || yycheck[yyn] != yytoken)
    goto yydefault;
  yyn = yytable[yyn];
  if (yyn <= 0)
    {
      if (yyn == 0 || yyn == YYTABLE_NINF)
	goto yyerrlab;
      yyn = -yyn;
      goto yyreduce;
    }

  /* Count tokens shifted since error; after three, turn off error
     status.  */
  if (yyerrstatus)
    yyerrstatus--;

  /* Shift the lookahead token.  */
  YY_SYMBOL_PRINT ("Shifting", yytoken, &yylval, &yylloc);

  /* Discard the shifted token.  */
  yychar = YYEMPTY;

  yystate = yyn;
  *++yyvsp = yylval;

  goto yynewstate;


/*-----------------------------------------------------------.
| yydefault -- do the default action for the current state.  |
`-----------------------------------------------------------*/
yydefault:
  yyn = yydefact[yystate];
  if (yyn == 0)
    goto yyerrlab;
  goto yyreduce;


/*-----------------------------.
| yyreduce -- Do a reduction.  |
`-----------------------------*/
yyreduce:
  /* yyn is the number of a rule to reduce with.  */
  yylen = yyr2[yyn];

  /* If YYLEN is nonzero, implement the default value of the action:
     `$$ = $1'.

     Otherwise, the following line sets YYVAL to garbage.
     This behavior is undocumented and Bison
     users should not rely upon it.  Assigning to YYVAL
     unconditionally makes the parser a bit smaller, and it avoids a
     GCC warning that YYVAL may be used uninitialized.  */
  yyval = yyvsp[1-yylen];


  YY_REDUCE_PRINT (yyn);
  switch (yyn)
    {
        case 4:

/* Line 1455 of yacc.c  */
#line 176 "bison.y"
    { emit("STMT"); ;}
    break;

  case 5:

/* Line 1455 of yacc.c  */
#line 180 "bison.y"
    { emit_select((yyvsp[(1) - (7)].strval), (yyvsp[(6) - (7)].strval), (yyvsp[(7) - (7)].intval)); ;}
    break;

  case 6:

/* Line 1455 of yacc.c  */
#line 182 "bison.y"
    {  emit_load((yyvsp[(1) - (12)].strval), (yyvsp[(4) - (12)].strval), (yyvsp[(11) - (12)].intval), (yyvsp[(7) - (12)].strval)); ;}
    break;

  case 7:

/* Line 1455 of yacc.c  */
#line 184 "bison.y"
    {  emit_filter((yyvsp[(1) - (5)].strval), (yyvsp[(4) - (5)].strval));;}
    break;

  case 8:

/* Line 1455 of yacc.c  */
#line 186 "bison.y"
    {  emit_order((yyvsp[(1) - (6)].strval), (yyvsp[(4) - (6)].strval), (yyvsp[(6) - (6)].intval));;}
    break;

  case 9:

/* Line 1455 of yacc.c  */
#line 188 "bison.y"
    {  emit_join((yyvsp[(1) - (8)].strval),(yyvsp[(6) - (8)].strval),(yyvsp[(7) - (8)].intval)); ;}
    break;

  case 10:

/* Line 1455 of yacc.c  */
#line 190 "bison.y"
    {  emit_store((yyvsp[(2) - (9)].strval),(yyvsp[(4) - (9)].strval),(yyvsp[(7) - (9)].strval)); ;}
    break;

  case 11:

/* Line 1455 of yacc.c  */
#line 192 "bison.y"
    {  emit_store_binary((yyvsp[(2) - (7)].strval),(yyvsp[(4) - (7)].strval)); ;}
    break;

  case 12:

/* Line 1455 of yacc.c  */
#line 194 "bison.y"
    {  emit_describe_table((yyvsp[(2) - (2)].strval));;}
    break;

  case 13:

/* Line 1455 of yacc.c  */
#line 196 "bison.y"
    {  emit_insert((yyvsp[(3) - (7)].strval), (yyvsp[(7) - (7)].strval));;}
    break;

  case 14:

/* Line 1455 of yacc.c  */
#line 198 "bison.y"
    {  emit_delete((yyvsp[(3) - (5)].strval));;}
    break;

  case 15:

/* Line 1455 of yacc.c  */
#line 200 "bison.y"
    {  emit_display((yyvsp[(2) - (7)].strval), (yyvsp[(5) - (7)].strval));;}
    break;

  case 16:

/* Line 1455 of yacc.c  */
#line 202 "bison.y"
    {  emit_show_tables();;}
    break;

  case 17:

/* Line 1455 of yacc.c  */
#line 204 "bison.y"
    {  emit_drop_table((yyvsp[(3) - (3)].strval));;}
    break;

  case 18:

/* Line 1455 of yacc.c  */
#line 208 "bison.y"
    { emit_name((yyvsp[(1) - (1)].strval)); ;}
    break;

  case 19:

/* Line 1455 of yacc.c  */
#line 209 "bison.y"
    { emit("FIELDNAME %s.%s", (yyvsp[(1) - (3)].strval), (yyvsp[(3) - (3)].strval)); ;}
    break;

  case 20:

/* Line 1455 of yacc.c  */
#line 210 "bison.y"
    { emit("USERVAR %s", (yyvsp[(1) - (1)].strval)); ;}
    break;

  case 21:

/* Line 1455 of yacc.c  */
#line 211 "bison.y"
    { emit_string((yyvsp[(1) - (1)].strval)); ;}
    break;

  case 22:

/* Line 1455 of yacc.c  */
#line 212 "bison.y"
    { emit_number((yyvsp[(1) - (1)].intval)); ;}
    break;

  case 23:

/* Line 1455 of yacc.c  */
#line 213 "bison.y"
    { emit_float((yyvsp[(1) - (1)].floatval)); ;}
    break;

  case 24:

/* Line 1455 of yacc.c  */
#line 214 "bison.y"
    { emit_decimal((yyvsp[(1) - (1)].intval)); ;}
    break;

  case 25:

/* Line 1455 of yacc.c  */
#line 215 "bison.y"
    { emit("BOOL %d", (yyvsp[(1) - (1)].intval)); ;}
    break;

  case 26:

/* Line 1455 of yacc.c  */
#line 216 "bison.y"
    { emit_varchar((yyvsp[(1) - (14)].strval), (yyvsp[(3) - (14)].intval), (yyvsp[(6) - (14)].strval), (yyvsp[(8) - (14)].intval), (yyvsp[(11) - (14)].strval), (yyvsp[(13) - (14)].strval));;}
    break;

  case 27:

/* Line 1455 of yacc.c  */
#line 217 "bison.y"
    { emit_varchar((yyvsp[(1) - (9)].strval), (yyvsp[(3) - (9)].intval), (yyvsp[(6) - (9)].strval), (yyvsp[(8) - (9)].intval), "", "");;}
    break;

  case 28:

/* Line 1455 of yacc.c  */
#line 218 "bison.y"
    { emit_var((yyvsp[(1) - (11)].strval), (yyvsp[(3) - (11)].intval), (yyvsp[(6) - (11)].strval), (yyvsp[(8) - (11)].strval), (yyvsp[(10) - (11)].strval));;}
    break;

  case 29:

/* Line 1455 of yacc.c  */
#line 219 "bison.y"
    { emit_var((yyvsp[(1) - (6)].strval), (yyvsp[(3) - (6)].intval), (yyvsp[(6) - (6)].strval), "", "");;}
    break;

  case 30:

/* Line 1455 of yacc.c  */
#line 220 "bison.y"
    { emit_var_asc((yyvsp[(1) - (2)].strval));;}
    break;

  case 31:

/* Line 1455 of yacc.c  */
#line 221 "bison.y"
    { emit_var_desc((yyvsp[(1) - (2)].strval));;}
    break;

  case 32:

/* Line 1455 of yacc.c  */
#line 222 "bison.y"
    { emit_count(); ;}
    break;

  case 33:

/* Line 1455 of yacc.c  */
#line 223 "bison.y"
    { emit_sum(); ;}
    break;

  case 34:

/* Line 1455 of yacc.c  */
#line 224 "bison.y"
    { emit_average(); ;}
    break;

  case 35:

/* Line 1455 of yacc.c  */
#line 225 "bison.y"
    { emit_min(); ;}
    break;

  case 36:

/* Line 1455 of yacc.c  */
#line 226 "bison.y"
    { emit_max(); ;}
    break;

  case 37:

/* Line 1455 of yacc.c  */
#line 227 "bison.y"
    { emit_distinct(); ;}
    break;

  case 38:

/* Line 1455 of yacc.c  */
#line 228 "bison.y"
    { emit_join(); ;}
    break;

  case 39:

/* Line 1455 of yacc.c  */
#line 232 "bison.y"
    { emit_add(); ;}
    break;

  case 40:

/* Line 1455 of yacc.c  */
#line 233 "bison.y"
    { emit_minus(); ;}
    break;

  case 41:

/* Line 1455 of yacc.c  */
#line 234 "bison.y"
    { emit_mul(); ;}
    break;

  case 42:

/* Line 1455 of yacc.c  */
#line 235 "bison.y"
    { emit_div(); ;}
    break;

  case 43:

/* Line 1455 of yacc.c  */
#line 236 "bison.y"
    { emit("MOD"); ;}
    break;

  case 44:

/* Line 1455 of yacc.c  */
#line 237 "bison.y"
    { emit("MOD"); ;}
    break;

  case 45:

/* Line 1455 of yacc.c  */
#line 239 "bison.y"
    { emit_and(); ;}
    break;

  case 46:

/* Line 1455 of yacc.c  */
#line 240 "bison.y"
    { emit_eq(); ;}
    break;

  case 47:

/* Line 1455 of yacc.c  */
#line 241 "bison.y"
    { emit_or(); ;}
    break;

  case 48:

/* Line 1455 of yacc.c  */
#line 242 "bison.y"
    { emit("XOR"); ;}
    break;

  case 49:

/* Line 1455 of yacc.c  */
#line 243 "bison.y"
    { emit("SHIFT %s", (yyvsp[(2) - (3)].subtok)==1?"left":"right"); ;}
    break;

  case 50:

/* Line 1455 of yacc.c  */
#line 244 "bison.y"
    { emit("NOT"); ;}
    break;

  case 51:

/* Line 1455 of yacc.c  */
#line 245 "bison.y"
    { emit("NOT"); ;}
    break;

  case 52:

/* Line 1455 of yacc.c  */
#line 246 "bison.y"
    { emit_cmp((yyvsp[(2) - (3)].subtok)); ;}
    break;

  case 53:

/* Line 1455 of yacc.c  */
#line 247 "bison.y"
    { emit_cmp(7); ;}
    break;

  case 54:

/* Line 1455 of yacc.c  */
#line 249 "bison.y"
    { emit("CMPSELECT %d", (yyvsp[(2) - (5)].subtok)); ;}
    break;

  case 55:

/* Line 1455 of yacc.c  */
#line 250 "bison.y"
    {emit("EXPR");;}
    break;

  case 56:

/* Line 1455 of yacc.c  */
#line 251 "bison.y"
    { emit_case(); ;}
    break;

  case 57:

/* Line 1455 of yacc.c  */
#line 255 "bison.y"
    { emit("ISBOOL %d", (yyvsp[(3) - (3)].intval)); ;}
    break;

  case 58:

/* Line 1455 of yacc.c  */
#line 256 "bison.y"
    { emit("ISBOOL %d", (yyvsp[(4) - (4)].intval)); emit("NOT"); ;}
    break;

  case 59:

/* Line 1455 of yacc.c  */
#line 259 "bison.y"
    { /* nil */
    (yyval.intval) = 0;
;}
    break;

  case 60:

/* Line 1455 of yacc.c  */
#line 262 "bison.y"
    { (yyval.intval) = (yyvsp[(3) - (3)].intval);}
    break;

  case 61:

/* Line 1455 of yacc.c  */
#line 266 "bison.y"
    { (yyval.intval) = 1; emit_sel_name((yyvsp[(3) - (3)].strval));;}
    break;

  case 62:

/* Line 1455 of yacc.c  */
#line 267 "bison.y"
    { (yyval.intval) = (yyvsp[(1) - (5)].intval) + 1; emit_sel_name((yyvsp[(5) - (5)].strval));;}
    break;

  case 63:

/* Line 1455 of yacc.c  */
#line 268 "bison.y"
    { emit_sel_name("*");;}
    break;

  case 64:

/* Line 1455 of yacc.c  */
#line 272 "bison.y"
    { (yyval.intval) = 1; ;}
    break;

  case 65:

/* Line 1455 of yacc.c  */
#line 273 "bison.y"
    {(yyval.intval) = (yyvsp[(1) - (3)].intval) + 1; ;}
    break;

  case 66:

/* Line 1455 of yacc.c  */
#line 277 "bison.y"
    { (yyval.intval) = 1; ;}
    break;

  case 67:

/* Line 1455 of yacc.c  */
#line 278 "bison.y"
    { (yyval.intval) = 1 + (yyvsp[(3) - (3)].intval); ;}
    break;

  case 68:

/* Line 1455 of yacc.c  */
#line 281 "bison.y"
    { /* nil */
    (yyval.intval) = 0
;}
    break;

  case 70:

/* Line 1455 of yacc.c  */
#line 286 "bison.y"
    { emit("FILTER BY"); ;}
    break;

  case 71:

/* Line 1455 of yacc.c  */
#line 290 "bison.y"
    { (yyval.intval) = 1; emit_join_tab((yyvsp[(2) - (4)].strval), 'I');;}
    break;

  case 72:

/* Line 1455 of yacc.c  */
#line 291 "bison.y"
    { (yyval.intval) = 1; emit_join_tab((yyvsp[(3) - (5)].strval), 'L');;}
    break;

  case 73:

/* Line 1455 of yacc.c  */
#line 292 "bison.y"
    { (yyval.intval) = 1; emit_join_tab((yyvsp[(3) - (5)].strval), 'R');;}
    break;

  case 74:

/* Line 1455 of yacc.c  */
#line 293 "bison.y"
    { (yyval.intval) = 1; emit_join_tab((yyvsp[(3) - (5)].strval), 'O');;}
    break;

  case 75:

/* Line 1455 of yacc.c  */
#line 294 "bison.y"
    { (yyval.intval) = 1; emit_join_tab((yyvsp[(2) - (5)].strval), 'I'); ;}
    break;

  case 76:

/* Line 1455 of yacc.c  */
#line 295 "bison.y"
    { (yyval.intval) = 1; emit_join_tab((yyvsp[(3) - (6)].strval), 'L'); ;}
    break;

  case 77:

/* Line 1455 of yacc.c  */
#line 296 "bison.y"
    { (yyval.intval) = 1; emit_join_tab((yyvsp[(3) - (6)].strval), 'R'); ;}
    break;

  case 78:

/* Line 1455 of yacc.c  */
#line 297 "bison.y"
    { (yyval.intval) = 1; emit_join_tab((yyvsp[(3) - (6)].strval), 'O'); ;}
    break;

  case 79:

/* Line 1455 of yacc.c  */
#line 299 "bison.y"
    { /* nil */
    (yyval.intval) = 0
;}
    break;

  case 80:

/* Line 1455 of yacc.c  */
#line 302 "bison.y"
    { emit_limit((yyvsp[(2) - (2)].intval)); ;}
    break;

  case 81:

/* Line 1455 of yacc.c  */
#line 304 "bison.y"
    { /* nil */
    (yyval.intval) = 0
;}
    break;

  case 82:

/* Line 1455 of yacc.c  */
#line 307 "bison.y"
    { emit_sort((yyvsp[(4) - (4)].strval), 0); ;}
    break;

  case 83:

/* Line 1455 of yacc.c  */
#line 308 "bison.y"
    { emit_sort((yyvsp[(4) - (7)].strval), (yyvsp[(7) - (7)].intval)); ;}
    break;

  case 84:

/* Line 1455 of yacc.c  */
#line 309 "bison.y"
    { emit_presort((yyvsp[(3) - (3)].strval)); ;}
    break;



/* Line 1455 of yacc.c  */
#line 2308 "bison.tab.c"
      default: break;
    }
  YY_SYMBOL_PRINT ("-> $$ =", yyr1[yyn], &yyval, &yyloc);

  YYPOPSTACK (yylen);
  yylen = 0;
  YY_STACK_PRINT (yyss, yyssp);

  *++yyvsp = yyval;

  /* Now `shift' the result of the reduction.  Determine what state
     that goes to, based on the state we popped back to and the rule
     number reduced by.  */

  yyn = yyr1[yyn];

  yystate = yypgoto[yyn - YYNTOKENS] + *yyssp;
  if (0 <= yystate && yystate <= YYLAST && yycheck[yystate] == *yyssp)
    yystate = yytable[yystate];
  else
    yystate = yydefgoto[yyn - YYNTOKENS];

  goto yynewstate;


/*------------------------------------.
| yyerrlab -- here on detecting error |
`------------------------------------*/
yyerrlab:
  /* If not already recovering from an error, report this error.  */
  if (!yyerrstatus)
    {
      ++yynerrs;
#if ! YYERROR_VERBOSE
      yyerror (YY_("syntax error"));
#else
      {
	YYSIZE_T yysize = yysyntax_error (0, yystate, yychar);
	if (yymsg_alloc < yysize && yymsg_alloc < YYSTACK_ALLOC_MAXIMUM)
	  {
	    YYSIZE_T yyalloc = 2 * yysize;
	    if (! (yysize <= yyalloc && yyalloc <= YYSTACK_ALLOC_MAXIMUM))
	      yyalloc = YYSTACK_ALLOC_MAXIMUM;
	    if (yymsg != yymsgbuf)
	      YYSTACK_FREE (yymsg);
	    yymsg = (char *) YYSTACK_ALLOC (yyalloc);
	    if (yymsg)
	      yymsg_alloc = yyalloc;
	    else
	      {
		yymsg = yymsgbuf;
		yymsg_alloc = sizeof yymsgbuf;
	      }
	  }

	if (0 < yysize && yysize <= yymsg_alloc)
	  {
	    (void) yysyntax_error (yymsg, yystate, yychar);
	    yyerror (yymsg);
	  }
	else
	  {
	    yyerror (YY_("syntax error"));
	    if (yysize != 0)
	      goto yyexhaustedlab;
	  }
      }
#endif
    }



  if (yyerrstatus == 3)
    {
      /* If just tried and failed to reuse lookahead token after an
	 error, discard it.  */

      if (yychar <= YYEOF)
	{
	  /* Return failure if at end of input.  */
	  if (yychar == YYEOF)
	    YYABORT;
	}
      else
	{
	  yydestruct ("Error: discarding",
		      yytoken, &yylval);
	  yychar = YYEMPTY;
	}
    }

  /* Else will try to reuse lookahead token after shifting the error
     token.  */
  goto yyerrlab1;


/*---------------------------------------------------.
| yyerrorlab -- error raised explicitly by YYERROR.  |
`---------------------------------------------------*/
yyerrorlab:

  /* Pacify compilers like GCC when the user code never invokes
     YYERROR and the label yyerrorlab therefore never appears in user
     code.  */
  if (/*CONSTCOND*/ 0)
     goto yyerrorlab;

  /* Do not reclaim the symbols of the rule which action triggered
     this YYERROR.  */
  YYPOPSTACK (yylen);
  yylen = 0;
  YY_STACK_PRINT (yyss, yyssp);
  yystate = *yyssp;
  goto yyerrlab1;


/*-------------------------------------------------------------.
| yyerrlab1 -- common code for both syntax error and YYERROR.  |
`-------------------------------------------------------------*/
yyerrlab1:
  yyerrstatus = 3;	/* Each real token shifted decrements this.  */

  for (;;)
    {
      yyn = yypact[yystate];
      if (yyn != YYPACT_NINF)
	{
	  yyn += YYTERROR;
	  if (0 <= yyn && yyn <= YYLAST && yycheck[yyn] == YYTERROR)
	    {
	      yyn = yytable[yyn];
	      if (0 < yyn)
		break;
	    }
	}

      /* Pop the current state because it cannot handle the error token.  */
      if (yyssp == yyss)
	YYABORT;


      yydestruct ("Error: popping",
		  yystos[yystate], yyvsp);
      YYPOPSTACK (1);
      yystate = *yyssp;
      YY_STACK_PRINT (yyss, yyssp);
    }

  *++yyvsp = yylval;


  /* Shift the error token.  */
  YY_SYMBOL_PRINT ("Shifting", yystos[yyn], yyvsp, yylsp);

  yystate = yyn;
  goto yynewstate;


/*-------------------------------------.
| yyacceptlab -- YYACCEPT comes here.  |
`-------------------------------------*/
yyacceptlab:
  yyresult = 0;
  goto yyreturn;

/*-----------------------------------.
| yyabortlab -- YYABORT comes here.  |
`-----------------------------------*/
yyabortlab:
  yyresult = 1;
  goto yyreturn;

#if !defined(yyoverflow) || YYERROR_VERBOSE
/*-------------------------------------------------.
| yyexhaustedlab -- memory exhaustion comes here.  |
`-------------------------------------------------*/
yyexhaustedlab:
  yyerror (YY_("memory exhausted"));
  yyresult = 2;
  /* Fall through.  */
#endif

yyreturn:
  if (yychar != YYEMPTY)
     yydestruct ("Cleanup: discarding lookahead",
		 yytoken, &yylval);
  /* Do not reclaim the symbols of the rule which action triggered
     this YYABORT or YYACCEPT.  */
  YYPOPSTACK (yylen);
  YY_STACK_PRINT (yyss, yyssp);
  while (yyssp != yyss)
    {
      yydestruct ("Cleanup: popping",
		  yystos[*yyssp], yyvsp);
      YYPOPSTACK (1);
    }
#ifndef yyoverflow
  if (yyss != yyssa)
    YYSTACK_FREE (yyss);
#endif
#if YYERROR_VERBOSE
  if (yymsg != yymsgbuf)
    YYSTACK_FREE (yymsg);
#endif
  /* Make sure YYID is used.  */
  return YYID (yyresult);
}



/* Line 1675 of yacc.c  */
#line 311 "bison.y"


#include "filter.h"
#include "select.h"
#include "merge.h"
#include "zone_map.h"
#include "atof.h"
#include "sstream"
#include "sorts.cu"
#include "callbacks.h"

using namespace mgpu;
using namespace thrust::placeholders;
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

void emit_multijoin(string s, string j1, string j2, unsigned int tab, char* res_name);
void filter_op(char *s, char *f, unsigned int segment);

void check_used_vars()
{
	for (map<string, map<string, col_data> >::iterator it=data_dict.begin() ; it != data_dict.end(); ++it ) {
		
		map<string, col_data> s = (*it).second;
		queue<string> vars(op_value);
		while(!vars.empty()) {
			if(s.count(vars.front()) != 0) {
				used_vars[(*it).first][vars.front()] = 1;
			};
			vars.pop();
		}	
	};	
}


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

void emit_var(char *s, int c, char *f, char* ref, char* ref_name)
{
    namevars.push(s);
    typevars.push(f);
    sizevars.push(0);
    cols.push(c);
	references.push(ref);
	references_names.push(ref_name);	
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


void emit_varchar(char *s, int c, char *f, int d, char *ref, char* ref_name)
{
    namevars.push(s);
    typevars.push(f);
    sizevars.push(d);
    cols.push(c);
	references.push(ref);
	references_names.push(ref_name);
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

void order_inplace_host(CudaSet* a, stack<string> exe_type, set<string> field_names, bool update_str)
{
    unsigned int* permutation = new unsigned int[a->mRecCount];
    thrust::sequence(permutation, permutation + a->mRecCount);

    size_t maxSize =  a->mRecCount;
    char* temp;
    temp = new char[maxSize*max_char(a)];
	stack<string> exe_type1(exe_type);
	stack<string> exe_value;
	
    while(!exe_type1.empty()) {
        exe_value.push("ASC");
		exe_type1.pop();		
	};	


    // sort on host

    for(int i=0; !exe_type.empty(); ++i, exe_type.pop(),exe_value.pop()) {

        if (a->type[exe_type.top()] == 0)
            update_permutation_host(a->h_columns_int[exe_type.top()].data(), permutation, a->mRecCount, exe_value.top(), (int_type*)temp);
        else if (a->type[exe_type.top()] == 1)
            update_permutation_host(a->h_columns_float[exe_type.top()].data(), permutation, a->mRecCount,exe_value.top(), (float_type*)temp);
        else {
            update_permutation_char_host(a->h_columns_char[exe_type.top()], permutation, a->mRecCount, exe_value.top(), temp, a->char_size[exe_type.top()]);
        };
    };

    for (unsigned int i = 0; i < a->mColumnCount; i++) {
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
    unsigned int sz = a->mRecCount;
    thrust::device_ptr<unsigned int> permutation = thrust::device_malloc<unsigned int>(sz);
    thrust::sequence(permutation, permutation+sz,0,1);

    unsigned int* raw_ptr = thrust::raw_pointer_cast(permutation);
    void* temp;	
    CUDA_SAFE_CALL(cudaMalloc((void **) &temp, a->mRecCount*max_char(a, field_names)));
	stack<string> exe_type1(exe_type);
	
    for(int i=0; !exe_type.empty(); ++i, exe_type.pop()) {		
        if (a->type[exe_type.top()] == 0 ) {
			a->d_columns_int[exe_type.top()].resize(sz);
			thrust::copy(a->h_columns_int[exe_type.top()].begin(), a->h_columns_int[exe_type.top()].begin() + sz, a->d_columns_int[exe_type.top()].begin());
            update_permutation(a->d_columns_int[exe_type.top()], raw_ptr, sz, "ASC", (int_type*)temp);			
			a->d_columns_int[exe_type.top()].resize(0);
			a->d_columns_int[exe_type.top()].shrink_to_fit();
		}	
        else if (a->type[exe_type.top()] == 1) {
			a->d_columns_float[exe_type.top()].resize(sz);
			thrust::copy(a->h_columns_float[exe_type.top()].begin(), a->h_columns_float[exe_type.top()].begin() + sz, a->d_columns_float[exe_type.top()].begin());
            update_permutation(a->d_columns_float[exe_type.top()], raw_ptr, sz,"ASC", (float_type*)temp);
			a->d_columns_float[exe_type.top()].resize(0);
			a->d_columns_float[exe_type.top()].shrink_to_fit();			
		}	
        else {
            // use int col int_col_count
			a->d_columns_int[exe_type.top()].resize(sz);
			thrust::copy(a->h_columns_int[exe_type.top()].begin(), a->h_columns_int[exe_type.top()].begin() + sz, a->d_columns_int[exe_type.top()].begin());			
            update_permutation(a->d_columns_int[exe_type.top()], raw_ptr, sz, "ASC", (int_type*)temp);
			a->d_columns_int[exe_type.top()].resize(0);
			a->d_columns_int[exe_type.top()].shrink_to_fit();			
        };		
    };	
	
	
    for (set<string>::iterator it=field_names.begin(); it!=field_names.end(); ++it) {
        if (a->type[*it] == 0) {				
			a->d_columns_int[*it].resize(sz);
			thrust::copy(a->h_columns_int[*it].begin(), a->h_columns_int[*it].begin() + sz, a->d_columns_int[*it].begin());
            apply_permutation(a->d_columns_int[*it], raw_ptr, sz, (int_type*)temp);						
			thrust::copy(a->d_columns_int[*it].begin(), a->d_columns_int[*it].begin() + sz, a->h_columns_int[*it].begin());
			a->d_columns_int[*it].resize(0);
			a->d_columns_int[*it].shrink_to_fit();			
        }
        else if (a->type[*it] == 1) {
			a->d_columns_float[*it].resize(sz);
			thrust::copy(a->h_columns_float[*it].begin(), a->h_columns_float[*it].begin() + sz, a->d_columns_float[*it].begin());		
            apply_permutation(a->d_columns_float[*it], raw_ptr, sz, (float_type*)temp);
			thrust::copy(a->d_columns_float[*it].begin(), a->d_columns_float[*it].begin() + sz, a->h_columns_float[*it].begin());
			a->d_columns_float[*it].resize(0);
			a->d_columns_float[*it].shrink_to_fit();						
		}	
        else {		
			a->allocColumnOnDevice(*it, sz);
			cudaMemcpy( a->d_columns_char[*it], (void *)a->h_columns_char[*it], sz*a->char_size[*it], cudaMemcpyHostToDevice);
            apply_permutation_char(a->d_columns_char[*it], raw_ptr, sz, (char*)temp, a->char_size[*it]);
			cudaMemcpy( a->h_columns_char[*it], a->d_columns_char[*it], sz*a->char_size[*it], cudaMemcpyDeviceToHost);
			a->deAllocColumnOnDevice(*it);
			if(update_str) {
				a->d_columns_int[*it].resize(sz);
				cudaMemcpy( a->d_columns_char[*it], (void *)a->h_columns_char[*it], sz*a->char_size[*it], cudaMemcpyHostToDevice);
				apply_permutation(a->d_columns_int[*it], raw_ptr, sz, (int_type*)temp);
			}	
			
        };
    };
    cudaFree(temp);
    thrust::device_free(permutation);		
	
	for (set<string>::iterator it=field_names.begin(); it!=field_names.end(); ++it) {
        if (a->type[*it] == 0) {			
			a->d_columns_int[*it].resize(sz);		
			thrust::copy(a->h_columns_int[*it].begin(), a->h_columns_int[*it].begin() + sz, a->d_columns_int[*it].begin());
        }
        else if (a->type[*it] == 1) {
			a->d_columns_float[*it].resize(sz);
			thrust::copy(a->h_columns_float[*it].begin(), a->h_columns_float[*it].begin() + sz, a->d_columns_float[*it].begin());		
		}	
        else {		
			a->allocColumnOnDevice(*it, sz);
			cudaMemcpy( a->d_columns_char[*it], (void *)a->h_columns_char[*it], sz*a->char_size[*it], cudaMemcpyHostToDevice);
		};
	
	};
	
}




void order_inplace(CudaSet* a, stack<string> exe_type, set<string> field_names, bool update_str)
{

    unsigned int sz = a->mRecCount;
    thrust::device_ptr<unsigned int> permutation = thrust::device_malloc<unsigned int>(sz);
    thrust::sequence(permutation, permutation+sz,0,1);

    unsigned int* raw_ptr = thrust::raw_pointer_cast(permutation);
    void* temp;	
    CUDA_SAFE_CALL(cudaMalloc((void **) &temp, sz*max_char(a, field_names)));
	
    for(int i=0; !exe_type.empty(); ++i, exe_type.pop()) {		
        if (a->type[exe_type.top()] == 0)
            update_permutation(a->d_columns_int[exe_type.top()], raw_ptr, sz, "ASC", (int_type*)temp);
        else if (a->type[exe_type.top()] == 1)
            update_permutation(a->d_columns_float[exe_type.top()], raw_ptr, sz,"ASC", (float_type*)temp);
        else {
            // use int col int_col_count
            update_permutation(a->d_columns_int[exe_type.top()], raw_ptr, sz, "ASC", (int_type*)temp);
        };				
    };	
	
	
    for (set<string>::iterator it=field_names.begin(); it!=field_names.end(); ++it) {
        if (a->type[*it] == 0) {				
            apply_permutation(a->d_columns_int[*it], raw_ptr, sz, (int_type*)temp);						
        }
        else if (a->type[*it] == 1)
            apply_permutation(a->d_columns_float[*it], raw_ptr, sz, (float_type*)temp);
        else {		
            apply_permutation_char(a->d_columns_char[*it], raw_ptr, sz, (char*)temp, a->char_size[*it]);
			if(update_str) {
				if(a->d_columns_int[*it].size() > 0) {
					apply_permutation(a->d_columns_int[*it], raw_ptr, sz, (int_type*)temp);
				};	
			};	
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
			if (std::find(varNames[j1]->columnNames.begin(), varNames[j1]->columnNames.end(), op_vals.front()) != varNames[j1]->columnNames.end()) {
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


void emit_join(char *s, char *j1, int grp)
{

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
	queue<string> op_m1(op_value);

	
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
			std::vector<string>::iterator it;
			it = std::find(varNames[s]->columnNames.begin(), varNames[s]->columnNames.end(), op_sel.front());
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
	cout << "partitioned to " << r_parts << endl;
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
    thrust::device_vector<int> p_tmp;
    thrust::device_vector<unsigned int> v_l(left->maxRecs);
    MGPU_MEM(int) aIndicesDevice, bIndicesDevice;
	std::vector<int> j_data;
	
	stack<string> exe_type;
	set<string> field_names;
	exe_type.push(f2);
	for (unsigned int i = 0; i < right->columnNames.size() ; i++ ) {
		if (std::find(c->columnNames.begin(), c->columnNames.end(), right->columnNames[i]) != c->columnNames.end() || right->columnNames[i] == f2) {
			field_names.insert(right->columnNames[i]);
		};	
	};	
	
	
	while(start_part < right->segCount) {

	    bool rsz = 1;
		right->deAllocOnDevice();		

		cout << "loading " << start_part << " " << r_parts << endl;
		//if(right->not_compressed)
			//order_inplace_host(right, exe_type, field_names, 0);						
		//cout << "ordered " << endl;
		
		right->hostRecCount = right->mRecCount;
		if(start_part + r_parts >= right->segCount) {
			cnt_r = load_right(right, colname2, f2, op_g1, op_sel, op_alt, decimal_join, str_join, rcount, start_part, right->segCount, rsz);
			start_part = right->segCount;
		}
		else {
			cnt_r = load_right(right, colname2, f2, op_g1, op_sel, op_alt, decimal_join, str_join, rcount, start_part, start_part+r_parts, rsz);
			start_part = start_part+r_parts;			
		};			
		
		cout << "loaded " << cnt_r << " " << getFreeMem() << endl;
		right->mRecCount = cnt_r;
		
		if(right->not_compressed && getFreeMem() < right->mRecCount*max_char(right)*2) {
			cout << "path 1 " << endl;
			right->CopyToHost(0, right->mRecCount);
			right->deAllocOnDevice();
			if (left->type[colname1]  != 2)
				order_inplace1(right, exe_type, field_names, 0);					
			else	
				order_inplace1(right, exe_type, field_names, 1);					
		}
		else {
			cout << "path 2 " << endl;
			if (left->type[colname1]  != 2)
				order_inplace(right, exe_type, field_names, 0);					
			else {	
				order_inplace(right, exe_type, field_names, 1);					
			};	
		};
		cout << "ordered " << endl;
		

		for (unsigned int i = 0; i < left->segCount; i++) {
			
			if(verbose)
				//cout << "segment " << i <<  '\xd';	
				cout << "segment " << i <<  endl;	
			j_data.clear();		
			std::clock_t start2 = std::clock();		
			
			//for (set<unsigned int>::iterator it = left->ref_joins[colInd1][i].begin(); it != left->ref_joins[colInd1][i].end(); it++) {
			//	cout << "seg match " << *it << endl;
			//};
			
			//for (set<unsigned int>::iterator it = right->orig_segs[left->ref_sets[colInd1]].begin(); it != right->orig_segs[left->ref_sets[colInd1]].end(); it++) {
			//	cout << "right segs " << *it << endl;
			//};
			
			
			if(left->ref_joins[colname1][i].size() && right->orig_segs[left->ref_sets[colname1]].size()) {
				set_intersection(left->ref_joins[colname1][i].begin(),left->ref_joins[colname1][i].end(),
								 right->orig_segs[left->ref_sets[colname1]].begin(), right->orig_segs[left->ref_sets[colname1]].end(),
								 std::back_inserter(j_data));
				if(j_data.empty()) {
					cout << "skipping a segment " << endl;
					continue;
				};	
				
			};	
			
					
			cnt_l = 0;
			if (left->type[colname1]  != 2) {
				copyColumns(left, lc, i, cnt_l);			
			}
			else {
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
				else
					if(verbose)
						cout << "No need of sorting " << endl;
					
				cout << "join " << cnt_l << ":" << cnt_r << " " << join_type.front() << endl;
				//cout << "SZ " << left->d_columns_int[colname1].size() << endl;
					
				
				if (left->d_columns_int[colname1][0] > right->d_columns_int[colname2][cnt_r-1] ||
					left->d_columns_int[colname1][cnt_l-1] < right->d_columns_int[colname2][0]) {
					continue;
				};	
				
				cout << "joining " << left->d_columns_int[colname1][0] << " : " << left->d_columns_int[colname1][cnt_l-1] << " and " << right->d_columns_int[colname2][0] << " : " << right->d_columns_int[colname2][cnt_r-1] << endl;
				
								
				char join_kind = join_type.front();
				
				if (left->type[colname1] == 2) {
					thrust::device_ptr<int_type> d_col_r((int_type*)thrust::raw_pointer_cast(right->d_columns_int[colname2].data()));		

					//for(int z = 0; z < cnt_r ; z++)
					//	cout << " R " << right->d_columns_int[colname2][z] << endl;
						
					//for(int z = 0; z < cnt_l ; z++)
					//	cout << " L " << left->d_columns_int[colname1][z] << endl;
	
					
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

				//string sss = s;
				//cout << " " << tot_count << " " << res_count << endl;								
				//if(sss != "OLC") {
				//	cout << "RUN " << tot_count << " " << res_count << endl;				

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
					
					
					queue<string> op_sel1(op_sel_s);					
					c->resize_join(res_count);					
					void* temp;
					CUDA_SAFE_CALL(cudaMalloc((void **) &temp, res_count*max_char(c)));

					bool copied = 0;	
					thrust::host_vector<unsigned int> prm_vh;
					std::map<string,bool> processed;				
					bool cmp_type;			

					
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
							// copy field's segment to device, gather it and copy to the host
							
							if(left->filtered)
								cmp_type = varNames[left->source_name]->compTypes[op_sel1.front()];
							else
								cmp_type = left->compTypes[op_sel1.front()];
							
							if ((((left->type[op_sel1.front()] == 0) || ((left->type[op_sel1.front()] == 1) && 
								   left->decimal[op_sel1.front()])) && cmp_type == 0) && (op_sel1.front() != colname1) && left->not_compressed == 0) { // do the processing on host												
								
								void* h;	
								unsigned int cnt, bits;
								int_type lower_val;								
								
								//if(verbose)
								//	cout << "processing " << op_sel1.front() << " " << i << " " << cmp_type << endl;
								
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
								
								
								CudaSet *t;
								if(left->filtered)
									t = varNames[left->source_name];
								else
									t = left;
									
								t->readSegmentsFromFile(i, op_sel1.front(), 0);
								
								if(t->type[op_sel1.front()] == 0) {
									h = t->h_columns_int[op_sel1.front()].data();								
								}
								else {
									h = t->h_columns_float[op_sel1.front()].data();
								};	
								
								cnt = ((unsigned int*)h)[0];
								lower_val = ((int_type*)(((unsigned int*)h)+1))[0];
								bits = ((unsigned int*)((char*)h + cnt))[8];	
								//cout << cnt << " " << lower_val << " " << bits << endl;																
			
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
									};	
								}
								else if(bits == 64) {
									if(left->type[op_sel1.front()] == 0) {	
										thrust::gather(prm_vh.begin(), prm_vh.end(),  (int_type*)((unsigned int*)h + 6), c->h_columns_int[op_sel1.front()].begin() + offset);
									}	
									else {	
										int_type* ptr = (int_type*)c->h_columns_float[op_sel1.front()].data();
										thrust::gather(prm_vh.begin(), prm_vh.end(), (int_type*)((unsigned int*)h + 6), ptr + offset);
									};
								};
								
								if(left->type[op_sel1.front()] == 0) {	
									thrust::transform(c->h_columns_int[op_sel1.front()].begin() + offset, c->h_columns_int[op_sel1.front()].begin() + offset + res_count, 
													  thrust::make_constant_iterator(lower_val), c->h_columns_int[op_sel1.front()].begin() + offset, thrust::plus<int_type>()); 																	
								}
								else {
									int_type* ptr = (int_type*)c->h_columns_float[op_sel1.front()].data();
									thrust::transform(ptr + offset, ptr + offset + res_count, 
													  thrust::make_constant_iterator(lower_val), ptr + offset, thrust::plus<int_type>()); 																						
									thrust::transform(ptr + offset, ptr + offset + res_count, c->h_columns_float[op_sel1.front()].begin() + offset, long_to_float());													
								};							
								
							}
							else {						
							
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
						}
						else if(std::find(right->columnNames.begin(), right->columnNames.end(), op_sel1.front()) !=  right->columnNames.end()) {
						
							//gather
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
								thrust::sequence(d_tmp, d_tmp+res_count*right->char_size[op_sel1.front()],0,0);							
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
	
		

    left->deAllocOnDevice();
    right->deAllocOnDevice();
    c->deAllocOnDevice();
	

    varNames[s] = c;
    c->mRecCount = tot_count;    
	c->hostRecCount = tot_count;
	c->name = s;
	
	if(verbose)
		cout << endl << "tot res " << tot_count << endl;
	
	unsigned int tot_size = 0;	    
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



void emit_order(char *s, char *f, int e, int ll)
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


void emit_select(char *s, char *f, int ll)
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
		//std::cout<< "cpy time " <<  ( ( std::clock() - start3 ) / (double)CLOCKS_PER_SEC ) << " " << getFreeMem() << '\n';			
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
				start3 = std::clock();		
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


void emit_insert(char *f, char* s) {
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

void emit_mulite(char *f)
{

};


void emit_delete(char *f)
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

void emit_display(char *f, char* sep)
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

void emit_store(char *s, char *f, char* sep)
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


void emit_store_binary(char *s, char *f)
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
		    if (file_p  == NULL) {
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


void emit_load_binary(const char *s, const char *f, int d)
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
    if(ff == NULL) {
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


void emit_load(char *s, char *f, int d, char* sep)
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
		for ( map<string, map<string, col_data> >::iterator it=data_dict.begin() ; it != data_dict.end(); ++it ) {		
			cout << (*it).first << endl;
		};
	};
		
    return;
}

void emit_drop_table(char* table_name)
{
	if (scan_state == 1) {
	
		map<string, map<string, col_data> >::iterator iter;
		if((iter = data_dict.find(table_name)) != data_dict.end()) {	
			map<string, col_data> s = (*iter).second;			
			for ( map<string, col_data>::iterator it=s.begin() ; it != s.end(); ++it ) {	
				int seg = 0;
				string f_name = (*iter).first + "." + (*it).first + "." + int_to_string(seg);				
				while(!remove(f_name.c_str())) {
					seg++;					
					f_name = (*iter).first + "." + (*it).first + "." + int_to_string(seg);														
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


void emit_describe_table(char* table_name)
{
	if (scan_state == 1) {
		map<string, map<string, col_data> >::iterator iter;
		if((iter = data_dict.find(table_name)) != data_dict.end()) {	
			map<string, col_data> s = (*iter).second;
			for ( map<string, col_data>::iterator it=s.begin() ; it != s.end(); ++it ) {	
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
    //va_list ap;
    //va_start(ap, s);	

    fprintf(stderr, "%d: error: ", yylineno);
	cout << yytext << endl;
    //vfprintf(stderr, s, ap);
    //fprintf(stderr, "\n");
	
	
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
		for ( map<string, map<string, bool> >::iterator it=used_vars.begin() ; it != used_vars.end(); ++it ) {
			
			while(!namevars.empty()) namevars.pop();
			while(!typevars.empty()) typevars.pop();
			while(!sizevars.empty()) sizevars.pop();
			while(!cols.empty()) cols.pop();
			if(stat.count((*it).first) != 0) {
				map<string, bool> c = (*it).second;
				for ( map<string, bool>::iterator sit=c.begin() ; sit != c.end(); ++sit ) {
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
	total_buffer_size = 0;
	
    for (int i = 1; i < ac; i++) {
        if(strcmp(av[i],"-l") == 0) {
            process_count = atoff(av[i+1]);
        }
        else if(strcmp(av[i],"-v") == 0) {
            verbose = 1;
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
        if((yyin = fopen(av[ac-1], "r")) == NULL) {
            perror(av[ac-1]);
            exit(1);
        };

        if(yyparse()) {
            printf("SQL scan parse failed\n");
            exit(1);
        };
		
		//exit(0);

        scan_state = 1;
        std::clock_t start1 = std::clock();
		
		load_vars();
		
        statement_count = 0;
        clean_queues();

        yyin = fopen(av[ac-1], "r");
        PROC_FLUSH_BUF ( yyin );
        statement_count = 0;

        extern FILE *yyin;		
        context = CreateCudaDevice(0, av, verbose);	
        hash_seed = 100;

        if(!yyparse()) {
            if(verbose)
            cout << "SQL scan parse worked " << endl;
        }
        else
            cout << "SQL scan parse failed" << endl;

        fclose(yyin);
        for (map<string,CudaSet*>::iterator it=varNames.begin() ; it != varNames.end(); ++it ) {
            (*it).second->free();
        };

        if(verbose) {
            cout<< "cycle time " << ( ( std::clock() - start1 ) / (double)CLOCKS_PER_SEC ) << " " << getFreeMem() << endl;
        };
    }
    else {        
        context = CreateCudaDevice(0, av, verbose);
        hash_seed = 100;
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
            for (map<string,CudaSet*>::iterator it=varNames.begin() ; it != varNames.end(); ++it ) {
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
        for (map<string,CudaSet*>::iterator it=varNames.begin() ; it != varNames.end(); ++it ) {
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
        case 1: err = "(Warning) " + err;
           break;
        case 2: err = "(Fatal) " + err;
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
        context = CreateCudaDevice(0, av, true);
        printf("Alenka initialised\n");
}


void alenkaClose()
{
        statement_count = 0;
        hash_seed = 100;

        if(alloced_sz)
                cudaFree(alloced_tmp);
}







