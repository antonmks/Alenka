
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



/* Line 189 of yacc.c  */
#line 124 "bison.cu"

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
     REGEXP = 271,
     LIKE = 272,
     IS = 273,
     IN = 274,
     NOT = 275,
     BETWEEN = 276,
     COMPARISON = 277,
     SHIFT = 278,
     MOD = 279,
     UMINUS = 280,
     LOAD = 281,
     STREAM = 282,
     FILTER = 283,
     BY = 284,
     JOIN = 285,
     STORE = 286,
     INTO = 287,
     GROUP = 288,
     FROM = 289,
     SELECT = 290,
     AS = 291,
     ORDER = 292,
     ASC = 293,
     DESC = 294,
     COUNT = 295,
     USING = 296,
     SUM = 297,
     AVG = 298,
     MIN = 299,
     MAX = 300,
     LIMIT = 301,
     ON = 302,
     BINARY = 303
   };
#endif



#if ! defined YYSTYPE && ! defined YYSTYPE_IS_DECLARED
typedef union YYSTYPE
{

/* Line 214 of yacc.c  */
#line 67 "bison.y"

    int intval;
    float floatval;
    char *strval;
    int subtok;



/* Line 214 of yacc.c  */
#line 217 "bison.cu"
} YYSTYPE;
# define YYSTYPE_IS_TRIVIAL 1
# define yystype YYSTYPE /* obsolescent; will be withdrawn */
# define YYSTYPE_IS_DECLARED 1
#endif


/* Copy the second part of user declarations.  */


/* Line 264 of yacc.c  */
#line 229 "bison.cu"

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
#define YYFINAL  8
/* YYLAST -- Last index in YYTABLE.  */
#define YYLAST   446

/* YYNTOKENS -- Number of terminals.  */
#define YYNTOKENS  66
/* YYNNTS -- Number of nonterminals.  */
#define YYNNTS  13
/* YYNRULES -- Number of rules.  */
#define YYNRULES  62
/* YYNRULES -- Number of states.  */
#define YYNSTATES  153

/* YYTRANSLATE(YYLEX) -- Bison symbol number corresponding to YYLEX.  */
#define YYUNDEFTOK  2
#define YYMAXUTOK   303

#define YYTRANSLATE(YYX)						\
  ((unsigned int) (YYX) <= YYMAXUTOK ? yytranslate[YYX] : YYUNDEFTOK)

/* YYTRANSLATE[YYLEX] -- Bison symbol number corresponding to YYLEX.  */
static const yytype_uint8 yytranslate[] =
{
       0,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,    20,     2,     2,     2,    31,    25,     2,
      59,    60,    29,    27,    65,    28,    61,    30,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,    64,    58,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,    33,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,    62,    24,    63,     2,     2,     2,     2,
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
      15,    16,    17,    18,    19,    21,    22,    23,    26,    32,
      34,    35,    36,    37,    38,    39,    40,    41,    42,    43,
      44,    45,    46,    47,    48,    49,    50,    51,    52,    53,
      54,    55,    56,    57
};

#if YYDEBUG
/* YYPRHS[YYN] -- Index of the first RHS symbol of rule number YYN in
   YYRHS.  */
static const yytype_uint16 yyprhs[] =
{
       0,     0,     3,     6,    10,    12,    20,    33,    43,    49,
      56,    64,    74,    81,    83,    87,    89,    91,    93,    95,
      97,    99,   109,   116,   119,   122,   127,   132,   137,   142,
     147,   151,   155,   159,   163,   167,   171,   175,   179,   183,
     187,   191,   194,   197,   201,   207,   211,   215,   220,   221,
     225,   229,   235,   237,   241,   243,   247,   248,   250,   253,
     258,   264,   265
};

/* YYRHS -- A `-1'-separated list of the rules' RHS.  */
static const yytype_int8 yyrhs[] =
{
      67,     0,    -1,    68,    58,    -1,    67,    68,    58,    -1,
      69,    -1,     4,    11,    44,    72,    43,     4,    71,    -1,
       4,    11,    35,     3,    50,    59,     3,    60,    45,    59,
      73,    60,    -1,     4,    11,    35,     3,    57,    45,    59,
      73,    60,    -1,     4,    11,    37,     4,    76,    -1,     4,
      11,    46,     4,    38,    75,    -1,     4,    11,    44,    72,
      43,     4,    77,    -1,    40,     4,    41,     3,    50,    59,
       3,    60,    78,    -1,    40,     4,    41,     3,    78,    57,
      -1,     4,    -1,     4,    61,     4,    -1,    10,    -1,     5,
      -1,     6,    -1,     9,    -1,     7,    -1,     8,    -1,     4,
      62,     6,    63,    64,     4,    59,     6,    60,    -1,     4,
      62,     6,    63,    64,     4,    -1,     4,    47,    -1,     4,
      48,    -1,    49,    59,    70,    60,    -1,    51,    59,    70,
      60,    -1,    52,    59,    70,    60,    -1,    53,    59,    70,
      60,    -1,    54,    59,    70,    60,    -1,    70,    27,    70,
      -1,    70,    28,    70,    -1,    70,    29,    70,    -1,    70,
      30,    70,    -1,    70,    31,    70,    -1,    70,    32,    70,
      -1,    70,    15,    70,    -1,    70,    12,    70,    -1,    70,
      13,    70,    -1,    70,    14,    70,    -1,    70,    26,    70,
      -1,    21,    70,    -1,    20,    70,    -1,    70,    23,    70,
      -1,    70,    23,    59,    69,    60,    -1,    59,    70,    60,
      -1,    70,    18,     8,    -1,    70,    18,    21,     8,    -1,
      -1,    42,    38,    74,    -1,    70,    45,     4,    -1,    72,
      65,    70,    45,     4,    -1,    70,    -1,    73,    65,    70,
      -1,    70,    -1,    70,    65,    74,    -1,    -1,    74,    -1,
      38,    70,    -1,    39,     4,    56,    70,    -1,    39,     4,
      56,    70,    77,    -1,    -1,    55,     6,    -1
};

/* YYRLINE[YYN] -- source line where rule number YYN was defined.  */
static const yytype_uint8 yyrline[] =
{
       0,   137,   137,   138,   142,   145,   147,   149,   151,   153,
     155,   157,   159,   164,   165,   166,   167,   168,   169,   170,
     171,   172,   173,   174,   175,   176,   177,   178,   179,   180,
     184,   185,   186,   187,   188,   189,   191,   192,   193,   194,
     195,   196,   197,   198,   200,   201,   205,   206,   209,   212,
     216,   217,   221,   222,   226,   227,   230,   232,   235,   238,
     239,   241,   244
};
#endif

#if YYDEBUG || YYERROR_VERBOSE || YYTOKEN_TABLE
/* YYTNAME[SYMBOL-NUM] -- String name of the symbol SYMBOL-NUM.
   First, the terminals, then, starting at YYNTOKENS, nonterminals.  */
static const char *const yytname[] =
{
  "$end", "error", "$undefined", "FILENAME", "NAME", "STRING", "INTNUM",
  "DECIMAL1", "BOOL1", "APPROXNUM", "USERVAR", "ASSIGN", "EQUAL", "OR",
  "XOR", "AND", "REGEXP", "LIKE", "IS", "IN", "'!'", "NOT", "BETWEEN",
  "COMPARISON", "'|'", "'&'", "SHIFT", "'+'", "'-'", "'*'", "'/'", "'%'",
  "MOD", "'^'", "UMINUS", "LOAD", "STREAM", "FILTER", "BY", "JOIN",
  "STORE", "INTO", "GROUP", "FROM", "SELECT", "AS", "ORDER", "ASC", "DESC",
  "COUNT", "USING", "SUM", "AVG", "MIN", "MAX", "LIMIT", "ON", "BINARY",
  "';'", "'('", "')'", "'.'", "'{'", "'}'", "':'", "','", "$accept",
  "stmt_list", "stmt", "select_stmt", "expr", "opt_group_list",
  "expr_list", "load_list", "val_list", "opt_val_list", "opt_where",
  "join_list", "opt_limit", 0
};
#endif

# ifdef YYPRINT
/* YYTOKNUM[YYLEX-NUM] -- Internal token number corresponding to
   token YYLEX-NUM.  */
static const yytype_uint16 yytoknum[] =
{
       0,   256,   257,   258,   259,   260,   261,   262,   263,   264,
     265,   266,   267,   268,   269,   270,   271,   272,   273,   274,
      33,   275,   276,   277,   124,    38,   278,    43,    45,    42,
      47,    37,   279,    94,   280,   281,   282,   283,   284,   285,
     286,   287,   288,   289,   290,   291,   292,   293,   294,   295,
     296,   297,   298,   299,   300,   301,   302,   303,    59,    40,
      41,    46,   123,   125,    58,    44
};
# endif

/* YYR1[YYN] -- Symbol number of symbol that rule YYN derives.  */
static const yytype_uint8 yyr1[] =
{
       0,    66,    67,    67,    68,    69,    69,    69,    69,    69,
      69,    69,    69,    70,    70,    70,    70,    70,    70,    70,
      70,    70,    70,    70,    70,    70,    70,    70,    70,    70,
      70,    70,    70,    70,    70,    70,    70,    70,    70,    70,
      70,    70,    70,    70,    70,    70,    70,    70,    71,    71,
      72,    72,    73,    73,    74,    74,    75,    75,    76,    77,
      77,    78,    78
};

/* YYR2[YYN] -- Number of symbols composing right hand side of rule YYN.  */
static const yytype_uint8 yyr2[] =
{
       0,     2,     2,     3,     1,     7,    12,     9,     5,     6,
       7,     9,     6,     1,     3,     1,     1,     1,     1,     1,
       1,     9,     6,     2,     2,     4,     4,     4,     4,     4,
       3,     3,     3,     3,     3,     3,     3,     3,     3,     3,
       3,     2,     2,     3,     5,     3,     3,     4,     0,     3,
       3,     5,     1,     3,     1,     3,     0,     1,     2,     4,
       5,     0,     2
};

/* YYDEFACT[STATE-NAME] -- Default rule to reduce with in state
   STATE-NUM when YYTABLE doesn't specify something else to do.  Zero
   means the default is an error.  */
static const yytype_uint8 yydefact[] =
{
       0,     0,     0,     0,     0,     4,     0,     0,     1,     0,
       2,     0,     0,     0,     0,     0,     3,     0,     0,    13,
      16,    17,    19,    20,    18,    15,     0,     0,     0,     0,
       0,     0,     0,     0,     0,     0,     0,    61,     0,     0,
       0,     8,    23,    24,     0,     0,    42,    41,     0,     0,
       0,     0,     0,     0,     0,     0,     0,     0,     0,     0,
       0,     0,     0,     0,     0,     0,     0,     0,     0,     0,
      56,     0,     0,     0,     0,     0,    58,    14,     0,     0,
       0,     0,     0,     0,    45,    37,    38,    39,    36,    46,
       0,     0,    43,    40,    30,    31,    32,    33,    34,    35,
      50,    48,     0,    54,    57,     9,     0,    62,    12,     0,
       0,     0,    25,    26,    27,    28,    29,    47,    13,     0,
       0,     0,     5,    10,     0,     0,     0,     0,    52,     0,
       0,    44,     0,     0,    51,    55,    61,     0,     7,     0,
      22,     0,    49,    11,     0,    53,     0,    59,     0,     0,
      60,     6,    21
};

/* YYDEFGOTO[NTERM-NUM].  */
static const yytype_int16 yydefgoto[] =
{
      -1,     3,     4,     5,   103,   122,    35,   129,   104,   105,
      41,   123,    73
};

/* YYPACT[STATE-NUM] -- Index in YYTABLE of the portion describing
   STATE-NUM.  */
#define YYPACT_NINF -122
static const yytype_int16 yypact[] =
{
      14,    -3,     7,     5,   -34,  -122,    50,    23,  -122,    28,
    -122,    52,    61,    62,    77,    85,  -122,   -35,    51,   -45,
    -122,  -122,  -122,  -122,  -122,  -122,    62,    62,    33,    36,
      44,    49,    58,    62,   300,   -42,    71,   -29,    59,    65,
      62,  -122,  -122,  -122,   115,   114,     2,     2,    62,    62,
      62,    62,    62,   171,    62,    62,    62,    62,    -2,   128,
      62,    62,    62,    62,    62,    62,    62,   118,   119,    62,
      62,    66,   121,    67,   126,    84,   364,  -122,    81,   192,
     214,   235,   257,   278,  -122,   364,   383,   401,   142,  -122,
     122,    53,   408,   414,    69,    69,  -122,  -122,  -122,  -122,
    -122,   -32,   321,   127,  -122,  -122,   143,  -122,  -122,    87,
      62,    88,  -122,  -122,  -122,  -122,  -122,  -122,    29,    91,
     157,   124,  -122,  -122,   159,    62,   104,   130,   364,    15,
     162,  -122,   111,    62,  -122,  -122,   123,   117,  -122,    62,
     129,    62,  -122,  -122,    62,   364,   184,   342,    19,   131,
    -122,  -122,  -122
};

/* YYPGOTO[NTERM-NUM].  */
static const yytype_int16 yypgoto[] =
{
    -122,  -122,   190,   105,   -13,  -122,  -122,    64,  -121,  -122,
    -122,    48,    73
};

/* YYTABLE[YYPACT[STATE-NUM]].  What to do in state STATE-NUM.  If
   positive, shift that token.  If negative, reduce the rule which
   number is the opposite.  If zero, do what YYDEFACT says.
   If YYTABLE_NINF, syntax error.  */
#define YYTABLE_NINF -1
static const yytype_uint8 yytable[] =
{
      34,    68,    42,    43,   135,     8,    89,   120,     6,     1,
     121,     7,   142,    46,    47,    38,    44,    45,     1,    90,
      53,    71,    39,    69,    10,    59,    72,    76,    60,    61,
      62,    63,    64,    65,    66,    79,    80,    81,    82,    83,
       6,    85,    86,    87,    88,     2,    92,    93,    94,    95,
      96,    97,    98,    99,     2,    17,   102,   118,    20,    21,
      22,    23,    24,    25,    15,    18,    19,    20,    21,    22,
      23,    24,    25,    26,    27,   138,    42,    43,    53,   151,
     139,    36,    26,    27,   139,    11,    16,    12,    37,    40,
      44,    45,    48,     2,    13,    49,    14,   128,    63,    64,
      65,    66,    28,    50,    29,    30,    31,    32,    51,    70,
      75,    28,    33,    29,    30,    31,    32,    52,    74,    77,
      78,    33,   100,   101,   108,   106,   145,   107,   147,   109,
     117,   128,    19,    20,    21,    22,    23,    24,    25,    54,
      55,    56,    57,   110,   111,    58,   126,   127,    26,    27,
      59,   131,   130,    60,    61,    62,    63,    64,    65,    66,
      58,   132,   133,   134,   136,    59,   140,   141,    60,    61,
      62,    63,    64,    65,    66,   137,   144,    28,    72,    29,
      30,    31,    32,    54,    55,    56,    57,    91,   146,    58,
     149,   152,   125,     9,    59,   150,   119,    60,    61,    62,
      63,    64,    65,    66,    54,    55,    56,    57,   148,   143,
      58,     0,     0,     0,     0,    59,     0,     0,    60,    61,
      62,    63,    64,    65,    66,     0,    54,    55,    56,    57,
       0,    84,    58,     0,     0,     0,     0,    59,     0,     0,
      60,    61,    62,    63,    64,    65,    66,    54,    55,    56,
      57,     0,   112,    58,     0,     0,     0,     0,    59,     0,
       0,    60,    61,    62,    63,    64,    65,    66,     0,    54,
      55,    56,    57,     0,   113,    58,     0,     0,     0,     0,
      59,     0,     0,    60,    61,    62,    63,    64,    65,    66,
      54,    55,    56,    57,     0,   114,    58,     0,     0,     0,
       0,    59,     0,     0,    60,    61,    62,    63,    64,    65,
      66,     0,    54,    55,    56,    57,     0,   115,    58,     0,
       0,     0,     0,    59,     0,     0,    60,    61,    62,    63,
      64,    65,    66,    54,    55,    56,    57,     0,   116,    58,
       0,     0,     0,     0,    59,    67,     0,    60,    61,    62,
      63,    64,    65,    66,    54,    55,    56,    57,     0,     0,
      58,     0,     0,     0,     0,    59,   124,     0,    60,    61,
      62,    63,    64,    65,    66,     0,    54,    55,    56,    57,
       0,   120,    58,     0,     0,     0,     0,    59,     0,     0,
      60,    61,    62,    63,    64,    65,    66,    56,    57,     0,
       0,    58,     0,     0,     0,     0,    59,     0,     0,    60,
      61,    62,    63,    64,    65,    66,    57,     0,     0,    58,
       0,     0,     0,     0,    59,     0,     0,    60,    61,    62,
      63,    64,    65,    66,    60,    61,    62,    63,    64,    65,
      66,    61,    62,    63,    64,    65,    66
};

static const yytype_int16 yycheck[] =
{
      13,    43,    47,    48,   125,     0,     8,    39,    11,     4,
      42,     4,   133,    26,    27,    50,    61,    62,     4,    21,
      33,    50,    57,    65,    58,    23,    55,    40,    26,    27,
      28,    29,    30,    31,    32,    48,    49,    50,    51,    52,
      11,    54,    55,    56,    57,    40,    59,    60,    61,    62,
      63,    64,    65,    66,    40,     3,    69,     4,     5,     6,
       7,     8,     9,    10,    41,     4,     4,     5,     6,     7,
       8,     9,    10,    20,    21,    60,    47,    48,    91,    60,
      65,     4,    20,    21,    65,    35,    58,    37,     3,    38,
      61,    62,    59,    40,    44,    59,    46,   110,    29,    30,
      31,    32,    49,    59,    51,    52,    53,    54,    59,    38,
      45,    49,    59,    51,    52,    53,    54,    59,    59,     4,
       6,    59,     4,     4,    57,    59,   139,     6,   141,     3,
       8,   144,     4,     5,     6,     7,     8,     9,    10,    12,
      13,    14,    15,    59,    63,    18,     3,    60,    20,    21,
      23,    60,    64,    26,    27,    28,    29,    30,    31,    32,
      18,     4,    38,     4,    60,    23,     4,    56,    26,    27,
      28,    29,    30,    31,    32,    45,    59,    49,    55,    51,
      52,    53,    54,    12,    13,    14,    15,    59,    59,    18,
       6,    60,    65,     3,    23,   147,    91,    26,    27,    28,
      29,    30,    31,    32,    12,    13,    14,    15,   144,   136,
      18,    -1,    -1,    -1,    -1,    23,    -1,    -1,    26,    27,
      28,    29,    30,    31,    32,    -1,    12,    13,    14,    15,
      -1,    60,    18,    -1,    -1,    -1,    -1,    23,    -1,    -1,
      26,    27,    28,    29,    30,    31,    32,    12,    13,    14,
      15,    -1,    60,    18,    -1,    -1,    -1,    -1,    23,    -1,
      -1,    26,    27,    28,    29,    30,    31,    32,    -1,    12,
      13,    14,    15,    -1,    60,    18,    -1,    -1,    -1,    -1,
      23,    -1,    -1,    26,    27,    28,    29,    30,    31,    32,
      12,    13,    14,    15,    -1,    60,    18,    -1,    -1,    -1,
      -1,    23,    -1,    -1,    26,    27,    28,    29,    30,    31,
      32,    -1,    12,    13,    14,    15,    -1,    60,    18,    -1,
      -1,    -1,    -1,    23,    -1,    -1,    26,    27,    28,    29,
      30,    31,    32,    12,    13,    14,    15,    -1,    60,    18,
      -1,    -1,    -1,    -1,    23,    45,    -1,    26,    27,    28,
      29,    30,    31,    32,    12,    13,    14,    15,    -1,    -1,
      18,    -1,    -1,    -1,    -1,    23,    45,    -1,    26,    27,
      28,    29,    30,    31,    32,    -1,    12,    13,    14,    15,
      -1,    39,    18,    -1,    -1,    -1,    -1,    23,    -1,    -1,
      26,    27,    28,    29,    30,    31,    32,    14,    15,    -1,
      -1,    18,    -1,    -1,    -1,    -1,    23,    -1,    -1,    26,
      27,    28,    29,    30,    31,    32,    15,    -1,    -1,    18,
      -1,    -1,    -1,    -1,    23,    -1,    -1,    26,    27,    28,
      29,    30,    31,    32,    26,    27,    28,    29,    30,    31,
      32,    27,    28,    29,    30,    31,    32
};

/* YYSTOS[STATE-NUM] -- The (internal number of the) accessing
   symbol of state STATE-NUM.  */
static const yytype_uint8 yystos[] =
{
       0,     4,    40,    67,    68,    69,    11,     4,     0,    68,
      58,    35,    37,    44,    46,    41,    58,     3,     4,     4,
       5,     6,     7,     8,     9,    10,    20,    21,    49,    51,
      52,    53,    54,    59,    70,    72,     4,     3,    50,    57,
      38,    76,    47,    48,    61,    62,    70,    70,    59,    59,
      59,    59,    59,    70,    12,    13,    14,    15,    18,    23,
      26,    27,    28,    29,    30,    31,    32,    45,    43,    65,
      38,    50,    55,    78,    59,    45,    70,     4,     6,    70,
      70,    70,    70,    70,    60,    70,    70,    70,    70,     8,
      21,    59,    70,    70,    70,    70,    70,    70,    70,    70,
       4,     4,    70,    70,    74,    75,    59,     6,    57,     3,
      59,    63,    60,    60,    60,    60,    60,     8,     4,    69,
      39,    42,    71,    77,    45,    65,     3,    60,    70,    73,
      64,    60,     4,    38,     4,    74,    60,    45,    60,    65,
       4,    56,    74,    78,    59,    70,    59,    70,    73,     6,
      77,    60,    60
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
#line 142 "bison.y"
    { emit("STMT"); ;}
    break;

  case 5:

/* Line 1455 of yacc.c  */
#line 146 "bison.y"
    { emit_select((yyvsp[(1) - (7)].strval), (yyvsp[(6) - (7)].strval), (yyvsp[(7) - (7)].intval)); ;}
    break;

  case 6:

/* Line 1455 of yacc.c  */
#line 148 "bison.y"
    {  emit_load((yyvsp[(1) - (12)].strval), (yyvsp[(4) - (12)].strval), (yyvsp[(11) - (12)].intval), (yyvsp[(7) - (12)].strval)); ;}
    break;

  case 7:

/* Line 1455 of yacc.c  */
#line 150 "bison.y"
    {  emit_load_binary((yyvsp[(1) - (9)].strval), (yyvsp[(4) - (9)].strval), (yyvsp[(8) - (9)].intval)); ;}
    break;

  case 8:

/* Line 1455 of yacc.c  */
#line 152 "bison.y"
    {  emit_filter((yyvsp[(1) - (5)].strval), (yyvsp[(4) - (5)].strval), (yyvsp[(5) - (5)].intval));;}
    break;

  case 9:

/* Line 1455 of yacc.c  */
#line 154 "bison.y"
    {  emit_order((yyvsp[(1) - (6)].strval), (yyvsp[(4) - (6)].strval), (yyvsp[(6) - (6)].intval));;}
    break;

  case 10:

/* Line 1455 of yacc.c  */
#line 156 "bison.y"
    { emit_join((yyvsp[(1) - (7)].strval),(yyvsp[(6) - (7)].strval)); ;}
    break;

  case 11:

/* Line 1455 of yacc.c  */
#line 158 "bison.y"
    { emit_store((yyvsp[(2) - (9)].strval),(yyvsp[(4) - (9)].strval),(yyvsp[(7) - (9)].strval)); ;}
    break;

  case 12:

/* Line 1455 of yacc.c  */
#line 160 "bison.y"
    { emit_store_binary((yyvsp[(2) - (6)].strval),(yyvsp[(4) - (6)].strval)); ;}
    break;

  case 13:

/* Line 1455 of yacc.c  */
#line 164 "bison.y"
    { emit_name((yyvsp[(1) - (1)].strval)); ;}
    break;

  case 14:

/* Line 1455 of yacc.c  */
#line 165 "bison.y"
    { emit("FIELDNAME %s.%s", (yyvsp[(1) - (3)].strval), (yyvsp[(3) - (3)].strval)); ;}
    break;

  case 15:

/* Line 1455 of yacc.c  */
#line 166 "bison.y"
    { emit("USERVAR %s", (yyvsp[(1) - (1)].strval)); ;}
    break;

  case 16:

/* Line 1455 of yacc.c  */
#line 167 "bison.y"
    { emit_string((yyvsp[(1) - (1)].strval)); ;}
    break;

  case 17:

/* Line 1455 of yacc.c  */
#line 168 "bison.y"
    { emit_number((yyvsp[(1) - (1)].intval)); ;}
    break;

  case 18:

/* Line 1455 of yacc.c  */
#line 169 "bison.y"
    { emit_float((yyvsp[(1) - (1)].floatval)); ;}
    break;

  case 19:

/* Line 1455 of yacc.c  */
#line 170 "bison.y"
    { emit_decimal((yyvsp[(1) - (1)].intval)); ;}
    break;

  case 20:

/* Line 1455 of yacc.c  */
#line 171 "bison.y"
    { emit("BOOL %d", (yyvsp[(1) - (1)].intval)); ;}
    break;

  case 21:

/* Line 1455 of yacc.c  */
#line 172 "bison.y"
    { emit_varchar((yyvsp[(1) - (9)].strval), (yyvsp[(3) - (9)].intval), (yyvsp[(6) - (9)].strval), (yyvsp[(8) - (9)].intval));;}
    break;

  case 22:

/* Line 1455 of yacc.c  */
#line 173 "bison.y"
    { emit_var((yyvsp[(1) - (6)].strval), (yyvsp[(3) - (6)].intval), (yyvsp[(6) - (6)].strval));;}
    break;

  case 23:

/* Line 1455 of yacc.c  */
#line 174 "bison.y"
    { emit_var_asc((yyvsp[(1) - (2)].strval));;}
    break;

  case 24:

/* Line 1455 of yacc.c  */
#line 175 "bison.y"
    { emit_var_desc((yyvsp[(1) - (2)].strval));;}
    break;

  case 25:

/* Line 1455 of yacc.c  */
#line 176 "bison.y"
    { emit_count(); ;}
    break;

  case 26:

/* Line 1455 of yacc.c  */
#line 177 "bison.y"
    { emit_sum(); ;}
    break;

  case 27:

/* Line 1455 of yacc.c  */
#line 178 "bison.y"
    { emit_average(); ;}
    break;

  case 28:

/* Line 1455 of yacc.c  */
#line 179 "bison.y"
    { emit_min(); ;}
    break;

  case 29:

/* Line 1455 of yacc.c  */
#line 180 "bison.y"
    { emit_max(); ;}
    break;

  case 30:

/* Line 1455 of yacc.c  */
#line 184 "bison.y"
    { emit_add(); ;}
    break;

  case 31:

/* Line 1455 of yacc.c  */
#line 185 "bison.y"
    { emit_minus(); ;}
    break;

  case 32:

/* Line 1455 of yacc.c  */
#line 186 "bison.y"
    { emit_mul(); ;}
    break;

  case 33:

/* Line 1455 of yacc.c  */
#line 187 "bison.y"
    { emit_div(); ;}
    break;

  case 34:

/* Line 1455 of yacc.c  */
#line 188 "bison.y"
    { emit("MOD"); ;}
    break;

  case 35:

/* Line 1455 of yacc.c  */
#line 189 "bison.y"
    { emit("MOD"); ;}
    break;

  case 36:

/* Line 1455 of yacc.c  */
#line 191 "bison.y"
    { emit_and(); ;}
    break;

  case 37:

/* Line 1455 of yacc.c  */
#line 192 "bison.y"
    { emit_eq(); ;}
    break;

  case 38:

/* Line 1455 of yacc.c  */
#line 193 "bison.y"
    { emit_or(); ;}
    break;

  case 39:

/* Line 1455 of yacc.c  */
#line 194 "bison.y"
    { emit("XOR"); ;}
    break;

  case 40:

/* Line 1455 of yacc.c  */
#line 195 "bison.y"
    { emit("SHIFT %s", (yyvsp[(2) - (3)].subtok)==1?"left":"right"); ;}
    break;

  case 41:

/* Line 1455 of yacc.c  */
#line 196 "bison.y"
    { emit("NOT"); ;}
    break;

  case 42:

/* Line 1455 of yacc.c  */
#line 197 "bison.y"
    { emit("NOT"); ;}
    break;

  case 43:

/* Line 1455 of yacc.c  */
#line 198 "bison.y"
    { emit_cmp((yyvsp[(2) - (3)].subtok)); ;}
    break;

  case 44:

/* Line 1455 of yacc.c  */
#line 200 "bison.y"
    { emit("CMPSELECT %d", (yyvsp[(2) - (5)].subtok)); ;}
    break;

  case 45:

/* Line 1455 of yacc.c  */
#line 201 "bison.y"
    {emit("EXPR");;}
    break;

  case 46:

/* Line 1455 of yacc.c  */
#line 205 "bison.y"
    { emit("ISBOOL %d", (yyvsp[(3) - (3)].intval)); ;}
    break;

  case 47:

/* Line 1455 of yacc.c  */
#line 206 "bison.y"
    { emit("ISBOOL %d", (yyvsp[(4) - (4)].intval)); emit("NOT"); ;}
    break;

  case 48:

/* Line 1455 of yacc.c  */
#line 209 "bison.y"
    { /* nil */
    (yyval.intval) = 0;
;}
    break;

  case 49:

/* Line 1455 of yacc.c  */
#line 212 "bison.y"
    { (yyval.intval) = (yyvsp[(3) - (3)].intval);}
    break;

  case 50:

/* Line 1455 of yacc.c  */
#line 216 "bison.y"
    { (yyval.intval) = 1; emit_sel_name((yyvsp[(3) - (3)].strval));;}
    break;

  case 51:

/* Line 1455 of yacc.c  */
#line 217 "bison.y"
    { (yyval.intval) = (yyvsp[(1) - (5)].intval) + 1; emit_sel_name((yyvsp[(5) - (5)].strval));;}
    break;

  case 52:

/* Line 1455 of yacc.c  */
#line 221 "bison.y"
    { (yyval.intval) = 1; ;}
    break;

  case 53:

/* Line 1455 of yacc.c  */
#line 222 "bison.y"
    {(yyval.intval) = (yyvsp[(1) - (3)].intval) + 1; ;}
    break;

  case 54:

/* Line 1455 of yacc.c  */
#line 226 "bison.y"
    { (yyval.intval) = 1; ;}
    break;

  case 55:

/* Line 1455 of yacc.c  */
#line 227 "bison.y"
    { (yyval.intval) = 1 + (yyvsp[(3) - (3)].intval); ;}
    break;

  case 56:

/* Line 1455 of yacc.c  */
#line 230 "bison.y"
    { /* nil */
    (yyval.intval) = 0
;}
    break;

  case 58:

/* Line 1455 of yacc.c  */
#line 235 "bison.y"
    { emit("FILTER BY"); ;}
    break;

  case 59:

/* Line 1455 of yacc.c  */
#line 238 "bison.y"
    { (yyval.intval) = 1; emit_join_tab((yyvsp[(2) - (4)].strval));;}
    break;

  case 60:

/* Line 1455 of yacc.c  */
#line 239 "bison.y"
    { (yyval.intval) = 1; emit_join_tab((yyvsp[(2) - (5)].strval)); ;}
    break;

  case 61:

/* Line 1455 of yacc.c  */
#line 241 "bison.y"
    { /* nil */
    (yyval.intval) = 0
;}
    break;

  case 62:

/* Line 1455 of yacc.c  */
#line 244 "bison.y"
    { emit_limit((yyvsp[(2) - (2)].intval)); ;}
    break;



/* Line 1455 of yacc.c  */
#line 2023 "bison.cu"
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
#line 247 "bison.y"



#include "filter.cu"
#include "select.cu"
#include "merge.cu"
#include "zone_map.cu"

FILE *file_pointer;
queue<string> namevars;
queue<string> typevars;
queue<int> sizevars;
queue<int> cols;

queue<unsigned int> j_col_count;
unsigned int sel_count = 0;
unsigned int join_cnt = 0;
int join_col_cnt = 0;
unsigned int eqq = 0;
stack<string> op_join;

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




void order_inplace(CudaSet* a, stack<string> exe_type, set<string> field_names, unsigned int segment)
{
    unsigned int sz = a->mRecCount;
    thrust::device_ptr<unsigned int> permutation = thrust::device_malloc<unsigned int>(sz);
    thrust::sequence(permutation, permutation+sz,0,1);


    unsigned int* raw_ptr = thrust::raw_pointer_cast(permutation);
    void* temp;
    // find the largest mRecSize of all data sources exe_type.top()
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
    thrust::device_free(permutation);
	
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

    cout << "JOIN " << s <<  " " <<  getFreeMem() <<  endl;

    std::clock_t start1 = std::clock();
    CudaSet* c = new CudaSet(right,left,0,op_sel, op_sel_as);	

    if (left->mRecCount == 0 || right->mRecCount == 0) {
        c = new CudaSet(left,right,0, op_sel, op_sel_as);        
        varNames[s] = c;
        clean_queues();
        return;
    };

    unsigned int colInd1 = (left->columnNames).find(f1)->second;
    unsigned int colInd2 = (right->columnNames).find(f2)->second;
	
	if ((left->type)[colInd1] != 0 || (right->type)[colInd2]  != 0) {
	    cout << "Right now only integer joins are supported " << endl;
		exit(0);
	};	

    set<string> field_names;
    stack<string> exe_type;
    exe_type.push(f2);
    field_names.insert(f2);

    // need to allocate all right columns	
    queue<string> cc;
	queue<string> c1(op_sel);;
	
	while(!c1.empty()) {	
        if(right->columnNames.find(c1.front()) !=  right->columnNames.end()) {
		    if(f2 != c1.front())
                cc.push(c1.front());
		};	
		c1.pop();		
	};	
    cc.push(f2);	

	if(right->prm.size())
        allocColumns(right, cc);	
	
    unsigned int rcount;
    if(!right->prm.empty()) {
 	    rcount = std::accumulate(right->prm_count.begin(), right->prm_count.end(), 0 );
    }
    else
        rcount = right->mRecCount;
	//cout << "rcount = " << rcount << endl;	
	
	queue<string> ct(cc);
	while(!ct.empty()) {	
	    right->allocColumnOnDevice(right->columnNames[ct.front()], rcount);
		ct.pop();		
	};	

	
    //thrust::device_ptr<unsigned int> rr = thrust::device_malloc<unsigned int>(rcount);		
	//right->allocColumnOnDevice(colInd2, rcount);	
	unsigned int cnt_r = 0;	
	   
	if(right->prm.size() == 0) {
       //copy all records	    
	   for(unsigned int i = 0; i < right->mColumnCount; i++)
	       right->CopyColumnToGpu(i);
		   cnt_r = right->mRecCount;
    }	
	else { 
	    //copy and gather all records					
         for(unsigned int i = 0; i < right->segCount; i++) {		 
             //gatherJoin(right, f2, i, cnt_r);	
             copyColumns(right, cc, i, cnt_r);			  			 	 
			 cnt_r = cnt_r + right->prm_count[i];
		 };				
	};
	
	
	unsigned int tt;
    if(left->maxRecs > rcount)	
	    tt = left->maxRecs;
	else
        tt = rcount;
		
	thrust::device_ptr<int_type> d_tmp = thrust::device_malloc<int_type>(tt);			
	
	//here we need to make sure that rr is ordered. If not then we order it and keep the permutation	
	bool sorted = thrust::is_sorted(right->d_columns_int[right->type_index[colInd2]].begin(), right->d_columns_int[right->type_index[colInd2]].begin() + cnt_r);
	
    thrust::device_vector<unsigned int> v(cnt_r);
	thrust::sequence(v.begin(),v.end(),0,1);
    	
	if(!sorted) {
	    thrust::sort_by_key(right->d_columns_int[right->type_index[colInd2]].begin(), right->d_columns_int[right->type_index[colInd2]].begin() + cnt_r, v.begin());
		for(unsigned int i = 0; i < right->mColumnCount; i++) {
		    if(i != colInd2) {
			    if(right->type[i] == 0) {
			        thrust::gather(v.begin(), v.end(), right->d_columns_int[right->type_index[i]].begin(), d_tmp);
				    thrust::copy(d_tmp, d_tmp + cnt_r, right->d_columns_int[right->type_index[i]].begin());					
				}
			    else if(right->type[i] == 1) {			
			        thrust::gather(v.begin(), v.end(), right->d_columns_float[right->type_index[i]].begin(), d_tmp);
				    thrust::copy(d_tmp, d_tmp + cnt_r, right->d_columns_float[right->type_index[i]].begin());
				}                				
			};	
		};
		thrust::sequence(v.begin(),v.end(),0,1);
	};
	thrust::device_free(d_tmp);		
	
	while(!cc.empty())
        cc.pop();
	
    cc.push(f1);
    allocColumns(left, cc);	

    //cout << "successfully loaded l && r " << cnt_l << " " << cnt_r << " " << getFreeMem() << endl;
	
    thrust::device_vector<unsigned int> d_res1;
    thrust::device_vector<unsigned int> d_res2;
    
	thrust::device_ptr<uint2> res = thrust::device_malloc<uint2>(left->maxRecs);
	
	unsigned int cnt_l, res_count, tot_count = 0, offset = 0, k = 0;
    void* g;
    CUDA_SAFE_CALL(cudaMalloc((void **) &g, left->maxRecs*int_size));

	//thrust::device_ptr<int_type> g = thrust::device_malloc<int_type>(left->maxRecs);
	queue<string> lc(cc);
	curr_segment = 10000000;	
	CUDPPResult result;
	
	// now for 64bit values we need to create several HashTables where each of them will keep a certain range of values
	// lets find out how many tables we need
	int_type max_val = right->d_columns_int[right->type_index[colInd2]][rcount-1];   
    unsigned int tab_count = (max_val / std::numeric_limits<unsigned int>::max()) + 1;	
    vector<CUDPPHandle> tabs;
    vector<unsigned int> tab_nums;
	unsigned int v_offset = 0;
	int_type min_v, max_v;
	thrust::device_ptr<unsigned int> d_r = thrust::device_malloc<unsigned int>(tt);			
	
	for(unsigned int i = 0; i < tab_count; i ++) {

	    // find out rcount
		min_v = i*std::numeric_limits<unsigned int>::max();
		max_v =  min_v + std::numeric_limits<unsigned int>::max();
      		
		unsigned int loc_count = thrust::count_if(right->d_columns_int[right->type_index[colInd2]].begin(), right->d_columns_int[right->type_index[colInd2]].begin() + rcount,
                                            	  _1 > min_v && _1 <= max_v );
        CUDPPHandle hash_table_handle;
        CUDPPHashTableConfig config;
        config.type = CUDPP_MULTIVALUE_HASH_TABLE;
        config.kInputSize = loc_count;
        config.space_usage = 1.5f;
		
        //cout << "creating table with " << loc_count << " " << getFreeMem()  << endl;		
	    result = cudppHashTable(theCudpp, &hash_table_handle, &config);
        //if (result == CUDPP_SUCCESS)
        //    cout << "hash table created " << getFreeMem() << endl;
					
        //cout << "INSERT " <<  " " << loc_count << " " << getFreeMem() << endl;	

		if(i != 0)				
		    thrust::transform(right->d_columns_int[right->type_index[colInd2]].begin() + v_offset, right->d_columns_int[right->type_index[colInd2]].begin() + v_offset + loc_count,
                              d_r, _1 - i*std::numeric_limits<unsigned int>::max());					
		else
	        thrust::copy(right->d_columns_int[right->type_index[colInd2]].begin() + v_offset, right->d_columns_int[right->type_index[colInd2]].begin() + v_offset + loc_count, d_r);	
	
        result = cudppHashInsert(hash_table_handle, thrust::raw_pointer_cast(d_r),
                                 thrust::raw_pointer_cast(v.data() + v_offset), loc_count);								 
							 
        //if (result == CUDPP_SUCCESS)
        //    cout << "hash table inserted " << getFreeMem() << endl;		
			
		v_offset = v_offset + loc_count;	
		tabs.push_back(hash_table_handle);	
		tab_nums.push_back(loc_count);
	};		
	
	//thrust::device_ptr<int_type> d_trans = thrust::device_malloc<int_type>(tt);			
	
    for (unsigned int i = 0; i < left->segCount; i++) {		
	    
		cout << "segment " << i << " " << getFreeMem() << endl;				
		cnt_l = 0;
		copyColumns(left, lc, i, cnt_l);
        if(left->prm.size() == 0) {
           //copy all records	    
		    cnt_l = left->mRecCount;
        }			
		else {				    	 		
			cnt_l = left->prm_count[i];
		};			
		
		if (cnt_l) { 					        
			
			
			unsigned int off = 0;
			for(unsigned int j = 0; j < tab_count; j ++) {
			
				
				if(j)
				    off = off + tab_nums[j-1];
				
				thrust::device_vector<unsigned int> tc(1);
				tc[0] = j;
			    //when copying to d_r need to make sure to set non-relevant values to zero otherwise they will get truncated to relevant values
				thrust::counting_iterator<unsigned int, thrust::device_space_tag> begin(0);
                trans_int t(thrust::raw_pointer_cast(tc.data()),thrust::raw_pointer_cast(left->d_columns_int[left->type_index[colInd1]].data()), thrust::raw_pointer_cast(d_r));
                thrust::for_each(begin, begin + cnt_l, t);		
					
			
			    result = cudppHashRetrieve(tabs[j], thrust::raw_pointer_cast(d_r),
                                           thrust::raw_pointer_cast(res), cnt_l);
			    if (result != CUDPP_SUCCESS)						   
			        cout << "Failed retrieve " << endl;					


	
		        uint2 rr = thrust::reduce(res, res+cnt_l, make_uint2(0,0), Uint2Sum());		
			    res_count = rr.y;

                if(res_count) {		 				

                
                    uint2_split ff(thrust::raw_pointer_cast(res),thrust::raw_pointer_cast(d_r));
                    thrust::for_each(begin, begin + cnt_l, ff);		
		
		            thrust::exclusive_scan(d_r, d_r+cnt_l, d_r );  // addresses	
		
				    tot_count = tot_count + res_count;
                    d_res1.resize(res_count);
                    d_res2.resize(res_count);				
			
                    join_functor ff1(thrust::raw_pointer_cast(res),
                                     thrust::raw_pointer_cast(d_r),
	     			        		 thrust::raw_pointer_cast(d_res1.data()),
		    			        	 thrust::raw_pointer_cast(d_res2.data()));
                    thrust::for_each(begin, begin + cnt_l, ff1);
					
					thrust::transform(d_res2.begin(), d_res2.end(), d_res2.begin(), _1 + off);		
				

	
				    offset = c->mRecCount;
			        c->resize(res_count);				
			
		            queue<string> op_sel1(op_sel);					
                    while(!op_sel1.empty()) {

	                    while(!cc.empty())
                            cc.pop();

                        cc.push(op_sel1.front());
				
                        if(left->columnNames.find(op_sel1.front()) !=  left->columnNames.end()) {
						    // copy field's segment to device, gather it and copy to the host  
					        unsigned int colInd = left->columnNames[op_sel1.front()];	
                            allocColumns(left, cc);						
					        copyColumns(left, cc, i, k);
					       //gather	   
					       if(left->type[colInd] == 0) {
					           thrust::device_ptr<int_type> d_col((int_type*)g);
					           thrust::gather(d_res1.begin(), d_res1.begin() + res_count, left->d_columns_int[left->type_index[colInd]].begin(), d_col);
					           thrust::copy(d_col, d_col + res_count, c->h_columns_int[c->type_index[c->columnNames[op_sel1.front()]]].begin() + offset);								   
					       }	   
					       else if(left->type[colInd] == 1) {
					           thrust::device_ptr<float_type> d_col((float_type*)g);
					           thrust::gather(d_res1.begin(), d_res1.begin() + res_count, left->d_columns_float[left->type_index[colInd]].begin(), d_col);						   
					           thrust::copy(d_col, d_col + res_count, c->h_columns_float[c->type_index[c->columnNames[op_sel1.front()]]].begin() + offset);												   						   
					       };	   					   

					    }
                        else {
						    unsigned int colInd = right->columnNames[op_sel1.front()];		
					       //gather	   					   
					       if(right->type[colInd] == 0) {
					           thrust::device_ptr<int_type> d_col((int_type*)g);
					           thrust::gather(d_res2.begin(), d_res2.begin() + res_count, right->d_columns_int[right->type_index[colInd]].begin(), d_col);						   
					           thrust::copy(d_col, d_col + res_count, c->h_columns_int[c->type_index[c->columnNames[op_sel1.front()]]].begin() + offset);
					       }
					       else if(right->type[colInd] == 1) {
					           thrust::device_ptr<float_type> d_col((float_type*)g);
					           thrust::gather(d_res2.begin(), d_res2.begin() + res_count, right->d_columns_float[right->type_index[colInd]].begin(), d_col);
					           thrust::copy(d_col, d_col + res_count, c->h_columns_float[c->type_index[c->columnNames[op_sel1.front()]]].begin() + offset);
					       };					   
					    };
                        op_sel1.pop();		  
                    };	
				};	
			};			
        };
    };

	for(unsigned int i = 0; i < tab_count; i ++) 
	    cudppDestroyHashTable(theCudpp, tabs[i]);   
	thrust::device_free(res);				
	cudaFree(g);
	thrust::device_free(d_r);		
    d_res1.resize(0);
    d_res1.shrink_to_fit();
    d_res2.resize(0);
    d_res2.shrink_to_fit();
	
	

    cout << "join final end " << tot_count << "  " << getFreeMem() << endl;
		
    left->deAllocOnDevice();
    right->deAllocOnDevice();

    varNames[s] = c;
	c->mRecCount = tot_count; 
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

	//exit(0);
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

    // find the largest mRecSize of all data sources

    stack<string> tp(exe_type);
    queue<string> op_vx;
    while (!tp.empty()) {
        op_vx.push(tp.top());
        tp.pop();
    };
	
    unsigned int maxSize =  a->mRecCount, cnt = 0;

    void* temp;
    CUDA_SAFE_CALL(cudaMalloc((void **) &temp, maxSize*float_size));

    varNames[setMap[exe_type.top()]]->oldRecCount = varNames[setMap[exe_type.top()]]->mRecCount;
    allocColumns(a, op_vx);
    copyColumns(a, op_vx, 0, cnt);

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
    thrust::device_vector<unsigned int> p(a->mRecCount);
    if(a->prm.size() != 0) {
	
        thrust::device_vector<unsigned int> p_a(a->mRecCount);
        b->prm.push_back(new unsigned int[a->mRecCount]);
        b->prm_count.push_back(a->mRecCount);
		b->prm_index.push_back('R');
        cudaMemcpy((void**)(thrust::raw_pointer_cast(p_a.data())), (void**)a->prm[0], 4*a->mRecCount, cudaMemcpyHostToDevice);
        thrust::gather(permutation, permutation+a->mRecCount, p_a.begin(), p.begin());
        cudaMemcpy((void**)b->prm[0], (void**)(thrust::raw_pointer_cast(p.data())), 4*a->mRecCount, cudaMemcpyDeviceToHost);
    }
    else {
        b->prm.push_back(new unsigned int[a->mRecCount]);
        b->prm_count.push_back(a->mRecCount);
		b->prm_index.push_back('R');
        thrust::copy(permutation, permutation+a->mRecCount, p.begin());
        cudaMemcpy((void**)b->prm[0], (void**)(thrust::raw_pointer_cast(p.data())), 4*a->mRecCount, cudaMemcpyDeviceToHost);
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

	curr_segment = 10000000;
    allocColumns(a, op_vx);

	unsigned int cycle_count = 1;
	if(a->prm.size())
        cycle_count = varNames[setMap[op_value.front()]]->segCount;
     	

    unsigned int ol_count = a->mRecCount, cnt;
    varNames[setMap[op_value.front()]]->oldRecCount = varNames[setMap[op_value.front()]]->mRecCount;
	
	
    for(unsigned int i = 0; i < cycle_count; i++) {          // MAIN CYCLE
        cout << "cycle " << i << " select mem " << getFreeMem() << endl;

        if(i == 0)
            b = new CudaSet(0, col_count);			

			cnt = 0;
            copyColumns(a, op_vx, i, cnt);			

            if (ll != 0) {
                order_inplace(a,op_v2,field_names,i);
                a->GroupBy(op_v3);
            };
            select(op_type,op_value,op_nums, op_nums_f,a,b, a->mRecCount);

        if(i == 0) {
            for ( map<string,int>::iterator it=b->columnNames.begin() ; it != b->columnNames.end(); ++it )
                setMap[(*it).first] = s;
        };

        if (ll != 0) {
            if (i == 0) {
                c = new CudaSet(b->mRecCount, col_count);
                c->fact_table = 1;
                c->segCount = 1;
            }
            else {
                c->resize(b->mRecCount);
			};	
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
        cout << "FILTER " << s << " " << f << " " << getFreeMem() << endl;
		

        b = a->copyDeviceStruct();
        b->name = s;

        unsigned int cycle_count = 1, cnt = 0;
        allocColumns(a, op_value);
		
        varNames[setMap[op_value.front()]]->oldRecCount = varNames[setMap[op_value.front()]]->mRecCount;

        if(a->segCount != 1)
            cycle_count = varNames[setMap[op_value.front()]]->segCount;
        
		oldCount = a->mRecCount;
        thrust::device_vector<unsigned int> p(a->maxRecs);


        for(unsigned int i = 0; i < cycle_count; i++) {		 
		    cout << "cycle " << i << endl;
        	map_check = zone_map_check(op_type,op_value,op_nums, op_nums_f, a, i);
	        cout << "MAP CHECK " << map_check << endl;		
            if(map_check == 'R') {			
                copyColumns(a, op_value, i, cnt);
                filter(op_type,op_value,op_nums, op_nums_f,a, b, i, p);
			}
            else  {		
				setPrm(a,b,map_check,i);
			}
        };
		a->mRecCount = oldCount;
        varNames[setMap[op_value.front()]]->mRecCount = varNames[setMap[op_value.front()]]->oldRecCount;
        cout << "filter is finished " << b->mRecCount << " " << getFreeMem()  << endl;             
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
    std::cout<< "filter time " <<  ( ( std::clock() - start1 ) / (double)CLOCKS_PER_SEC ) << " " << getFreeMem() << '\n';
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
        //cout << "STORING " << f << " " << limit << endl;
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


