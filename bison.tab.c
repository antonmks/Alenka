
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



/* Line 189 of yacc.c  */
#line 125 "bison.tab.c"

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
     DECIMAL = 262,
     BOOL = 263,
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
#line 68 "bison.y"

    int intval;
    float floatval;
    char *strval;
    int subtok;



/* Line 214 of yacc.c  */
#line 218 "bison.tab.c"
} YYSTYPE;
# define YYSTYPE_IS_TRIVIAL 1
# define yystype YYSTYPE /* obsolescent; will be withdrawn */
# define YYSTYPE_IS_DECLARED 1
#endif


/* Copy the second part of user declarations.  */


/* Line 264 of yacc.c  */
#line 230 "bison.tab.c"

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
#define YYLAST   444

/* YYNTOKENS -- Number of terminals.  */
#define YYNTOKENS  66
/* YYNNTS -- Number of nonterminals.  */
#define YYNNTS  13
/* YYNRULES -- Number of rules.  */
#define YYNRULES  64
/* YYNRULES -- Number of states.  */
#define YYNSTATES  168

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
       0,     0,     3,     6,    10,    12,    20,    33,    46,    56,
      66,    72,    79,    87,    97,   104,   106,   110,   112,   114,
     116,   118,   120,   122,   132,   139,   142,   145,   150,   155,
     160,   165,   170,   174,   178,   182,   186,   190,   194,   198,
     202,   206,   210,   214,   217,   220,   224,   230,   234,   238,
     243,   244,   248,   252,   258,   260,   264,   266,   270,   271,
     273,   276,   281,   287,   288
};

/* YYRHS -- A `-1'-separated list of the rules' RHS.  */
static const yytype_int8 yyrhs[] =
{
      67,     0,    -1,    68,    58,    -1,    67,    68,    58,    -1,
      69,    -1,     4,    11,    44,    72,    43,     4,    71,    -1,
       4,    11,    35,     3,    50,    59,     3,    60,    45,    59,
      73,    60,    -1,     4,    11,    36,     3,    50,    59,     3,
      60,    45,    59,    73,    60,    -1,     4,    11,    36,     3,
      57,    45,    59,    73,    60,    -1,     4,    11,    35,     3,
      57,    45,    59,    73,    60,    -1,     4,    11,    37,     4,
      76,    -1,     4,    11,    46,     4,    38,    75,    -1,     4,
      11,    44,    72,    43,     4,    77,    -1,    40,     4,    41,
       3,    50,    59,     3,    60,    78,    -1,    40,     4,    41,
       3,    78,    57,    -1,     4,    -1,     4,    61,     4,    -1,
      10,    -1,     5,    -1,     6,    -1,     9,    -1,     7,    -1,
       8,    -1,     4,    62,     6,    63,    64,     4,    59,     6,
      60,    -1,     4,    62,     6,    63,    64,     4,    -1,     4,
      47,    -1,     4,    48,    -1,    49,    59,    70,    60,    -1,
      51,    59,    70,    60,    -1,    52,    59,    70,    60,    -1,
      53,    59,    70,    60,    -1,    54,    59,    70,    60,    -1,
      70,    27,    70,    -1,    70,    28,    70,    -1,    70,    29,
      70,    -1,    70,    30,    70,    -1,    70,    31,    70,    -1,
      70,    32,    70,    -1,    70,    15,    70,    -1,    70,    12,
      70,    -1,    70,    13,    70,    -1,    70,    14,    70,    -1,
      70,    26,    70,    -1,    21,    70,    -1,    20,    70,    -1,
      70,    23,    70,    -1,    70,    23,    59,    69,    60,    -1,
      59,    70,    60,    -1,    70,    18,     8,    -1,    70,    18,
      21,     8,    -1,    -1,    42,    38,    74,    -1,    70,    45,
       4,    -1,    72,    65,    70,    45,     4,    -1,    70,    -1,
      73,    65,    70,    -1,    70,    -1,    70,    65,    74,    -1,
      -1,    74,    -1,    38,    70,    -1,    39,     4,    56,    70,
      -1,    39,     4,    56,    70,    77,    -1,    -1,    55,     6,
      -1
};

/* YYRLINE[YYN] -- source line where rule number YYN was defined.  */
static const yytype_uint8 yyrline[] =
{
       0,   138,   138,   139,   143,   146,   148,   150,   152,   154,
     156,   158,   160,   162,   164,   169,   170,   171,   172,   173,
     174,   175,   176,   177,   178,   179,   180,   181,   182,   183,
     184,   185,   189,   190,   191,   192,   193,   194,   196,   197,
     198,   199,   200,   201,   202,   203,   205,   206,   210,   211,
     214,   217,   221,   222,   226,   227,   231,   232,   235,   237,
     240,   243,   244,   246,   249
};
#endif

#if YYDEBUG || YYERROR_VERBOSE || YYTOKEN_TABLE
/* YYTNAME[SYMBOL-NUM] -- String name of the symbol SYMBOL-NUM.
   First, the terminals, then, starting at YYNTOKENS, nonterminals.  */
static const char *const yytname[] =
{
  "$end", "error", "$undefined", "FILENAME", "NAME", "STRING", "INTNUM",
  "DECIMAL", "BOOL", "APPROXNUM", "USERVAR", "ASSIGN", "EQUAL", "OR",
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
      69,    69,    69,    69,    69,    70,    70,    70,    70,    70,
      70,    70,    70,    70,    70,    70,    70,    70,    70,    70,
      70,    70,    70,    70,    70,    70,    70,    70,    70,    70,
      70,    70,    70,    70,    70,    70,    70,    70,    70,    70,
      71,    71,    72,    72,    73,    73,    74,    74,    75,    75,
      76,    77,    77,    78,    78
};

/* YYR2[YYN] -- Number of symbols composing right hand side of rule YYN.  */
static const yytype_uint8 yyr2[] =
{
       0,     2,     2,     3,     1,     7,    12,    12,     9,     9,
       5,     6,     7,     9,     6,     1,     3,     1,     1,     1,
       1,     1,     1,     9,     6,     2,     2,     4,     4,     4,
       4,     4,     3,     3,     3,     3,     3,     3,     3,     3,
       3,     3,     3,     2,     2,     3,     5,     3,     3,     4,
       0,     3,     3,     5,     1,     3,     1,     3,     0,     1,
       2,     4,     5,     0,     2
};

/* YYDEFACT[STATE-NAME] -- Default rule to reduce with in state
   STATE-NUM when YYTABLE doesn't specify something else to do.  Zero
   means the default is an error.  */
static const yytype_uint8 yydefact[] =
{
       0,     0,     0,     0,     0,     4,     0,     0,     1,     0,
       2,     0,     0,     0,     0,     0,     0,     3,     0,     0,
       0,    15,    18,    19,    21,    22,    20,    17,     0,     0,
       0,     0,     0,     0,     0,     0,     0,     0,     0,    63,
       0,     0,     0,     0,     0,    10,    25,    26,     0,     0,
      44,    43,     0,     0,     0,     0,     0,     0,     0,     0,
       0,     0,     0,     0,     0,     0,     0,     0,     0,     0,
       0,     0,     0,     0,    58,     0,     0,     0,     0,     0,
       0,     0,    60,    16,     0,     0,     0,     0,     0,     0,
      47,    39,    40,    41,    38,    48,     0,     0,    45,    42,
      32,    33,    34,    35,    36,    37,    52,    50,     0,    56,
      59,    11,     0,    64,    14,     0,     0,     0,     0,     0,
      27,    28,    29,    30,    31,    49,    15,     0,     0,     0,
       5,    12,     0,     0,     0,     0,    54,     0,     0,     0,
       0,    46,     0,     0,    53,    57,    63,     0,     9,     0,
       0,     8,    24,     0,    51,    13,     0,    55,     0,     0,
      61,     0,     0,     0,    62,     6,     7,    23
};

/* YYDEFGOTO[NTERM-NUM].  */
static const yytype_int16 yydefgoto[] =
{
      -1,     3,     4,     5,   136,   130,    37,   137,   110,   111,
      45,   131,    77
};

/* YYPACT[STATE-NUM] -- Index in YYTABLE of the portion describing
   STATE-NUM.  */
#define YYPACT_NINF -133
static const yytype_int16 yypact[] =
{
      18,    -4,    21,     8,   -31,  -133,    38,    16,  -133,    10,
    -133,    78,    85,    91,    94,   101,    86,  -133,   -44,    19,
      75,    24,  -133,  -133,  -133,  -133,  -133,  -133,    94,    94,
      58,    59,    68,    79,    81,    94,   288,   -41,   103,   -46,
      83,    99,    92,   105,    94,  -133,  -133,  -133,   148,   149,
     399,   399,    94,    94,    94,    94,    94,   159,    94,    94,
      94,    94,    -5,   116,    94,    94,    94,    94,    94,    94,
      94,   152,   160,    94,    94,   107,   170,   121,   176,   122,
     177,   124,   352,  -133,   133,   180,   202,   223,   245,   266,
    -133,   352,   371,   389,   131,  -133,   189,    57,   406,   412,
     102,   102,  -133,  -133,  -133,  -133,  -133,   -13,   309,     5,
    -133,  -133,   181,  -133,  -133,   139,    94,   140,    94,   137,
    -133,  -133,  -133,  -133,  -133,  -133,    32,   142,   200,   167,
    -133,  -133,   209,    94,   158,   178,   352,   -55,   179,    27,
     217,  -133,   166,    94,  -133,  -133,   171,   168,  -133,    94,
     183,  -133,   184,    94,  -133,  -133,    94,   352,    94,   233,
     330,    31,    47,   185,  -133,  -133,  -133,  -133
};

/* YYPGOTO[NTERM-NUM].  */
static const yytype_int16 yypgoto[] =
{
    -133,  -133,   241,   150,   -14,  -133,  -133,   -28,  -132,  -133,
    -133,    88,   110
};

/* YYTABLE[YYPACT[STATE-NUM]].  What to do in state STATE-NUM.  If
   positive, shift that token.  If negative, reduce the rule which
   number is the opposite.  If zero, do what YYDEFACT says.
   If YYTABLE_NINF, syntax error.  */
#define YYTABLE_NINF -1
static const yytype_uint8 yytable[] =
{
      36,   145,    72,    95,    75,   148,    40,     6,     8,    76,
     149,   154,     1,    41,    50,    51,    96,    58,    59,    60,
      61,    57,     1,    62,    73,     7,   128,    10,    63,   129,
      82,    64,    65,    66,    67,    68,    69,    70,    85,    86,
      87,    88,    89,     6,    91,    92,    93,    94,     2,    98,
      99,   100,   101,   102,   103,   104,   105,    16,     2,   108,
     109,   126,    22,    23,    24,    25,    26,    27,    17,    42,
     133,    46,    47,    11,    12,    13,    43,    28,    29,    46,
      47,    18,    14,    57,    15,    48,    49,   151,    19,    39,
     139,   165,   149,    48,    49,    20,   149,     2,    21,    22,
      23,    24,    25,    26,    27,    38,    30,   166,    31,    32,
      33,    34,   149,    44,    28,    29,    35,    52,    53,   109,
      21,    22,    23,    24,    25,    26,    27,    54,   161,   109,
     162,    67,    68,    69,    70,   157,    28,    29,    55,   160,
      56,    74,    78,    30,    79,    31,    32,    33,    34,    62,
      81,    80,    83,    35,    63,    84,   106,    64,    65,    66,
      67,    68,    69,    70,   107,    30,   112,    31,    32,    33,
      34,    58,    59,    60,    61,    97,   113,    62,   114,   115,
     117,   116,    63,   118,   134,    64,    65,    66,    67,    68,
      69,    70,    58,    59,    60,    61,   119,   125,    62,   135,
     138,   140,   141,    63,   142,   143,    64,    65,    66,    67,
      68,    69,    70,   144,    58,    59,    60,    61,   146,    90,
      62,   152,   153,   147,   150,    63,    76,   156,    64,    65,
      66,    67,    68,    69,    70,    58,    59,    60,    61,   163,
     120,    62,   158,   159,     9,   167,    63,   127,   164,    64,
      65,    66,    67,    68,    69,    70,   155,    58,    59,    60,
      61,     0,   121,    62,     0,     0,     0,     0,    63,     0,
       0,    64,    65,    66,    67,    68,    69,    70,    58,    59,
      60,    61,     0,   122,    62,     0,     0,     0,     0,    63,
       0,     0,    64,    65,    66,    67,    68,    69,    70,     0,
      58,    59,    60,    61,     0,   123,    62,     0,     0,     0,
       0,    63,     0,     0,    64,    65,    66,    67,    68,    69,
      70,    58,    59,    60,    61,     0,   124,    62,     0,     0,
       0,     0,    63,    71,     0,    64,    65,    66,    67,    68,
      69,    70,    58,    59,    60,    61,     0,     0,    62,     0,
       0,     0,     0,    63,   132,     0,    64,    65,    66,    67,
      68,    69,    70,     0,    58,    59,    60,    61,     0,   128,
      62,     0,     0,     0,     0,    63,     0,     0,    64,    65,
      66,    67,    68,    69,    70,    60,    61,     0,     0,    62,
       0,     0,     0,     0,    63,     0,     0,    64,    65,    66,
      67,    68,    69,    70,    61,     0,     0,    62,     0,     0,
       0,     0,    63,     0,     0,    64,    65,    66,    67,    68,
      69,    70,    63,     0,     0,    64,    65,    66,    67,    68,
      69,    70,    64,    65,    66,    67,    68,    69,    70,    65,
      66,    67,    68,    69,    70
};

static const yytype_int16 yycheck[] =
{
      14,   133,    43,     8,    50,    60,    50,    11,     0,    55,
      65,   143,     4,    57,    28,    29,    21,    12,    13,    14,
      15,    35,     4,    18,    65,     4,    39,    58,    23,    42,
      44,    26,    27,    28,    29,    30,    31,    32,    52,    53,
      54,    55,    56,    11,    58,    59,    60,    61,    40,    63,
      64,    65,    66,    67,    68,    69,    70,    41,    40,    73,
      74,     4,     5,     6,     7,     8,     9,    10,    58,    50,
      65,    47,    48,    35,    36,    37,    57,    20,    21,    47,
      48,     3,    44,    97,    46,    61,    62,    60,     3,     3,
     118,    60,    65,    61,    62,     4,    65,    40,     4,     5,
       6,     7,     8,     9,    10,     4,    49,    60,    51,    52,
      53,    54,    65,    38,    20,    21,    59,    59,    59,   133,
       4,     5,     6,     7,     8,     9,    10,    59,   156,   143,
     158,    29,    30,    31,    32,   149,    20,    21,    59,   153,
      59,    38,    59,    49,    45,    51,    52,    53,    54,    18,
      45,    59,     4,    59,    23,     6,     4,    26,    27,    28,
      29,    30,    31,    32,     4,    49,    59,    51,    52,    53,
      54,    12,    13,    14,    15,    59,     6,    18,    57,     3,
       3,    59,    23,    59,     3,    26,    27,    28,    29,    30,
      31,    32,    12,    13,    14,    15,    63,     8,    18,    60,
      60,    64,    60,    23,     4,    38,    26,    27,    28,    29,
      30,    31,    32,     4,    12,    13,    14,    15,    60,    60,
      18,     4,    56,    45,    45,    23,    55,    59,    26,    27,
      28,    29,    30,    31,    32,    12,    13,    14,    15,     6,
      60,    18,    59,    59,     3,    60,    23,    97,   160,    26,
      27,    28,    29,    30,    31,    32,   146,    12,    13,    14,
      15,    -1,    60,    18,    -1,    -1,    -1,    -1,    23,    -1,
      -1,    26,    27,    28,    29,    30,    31,    32,    12,    13,
      14,    15,    -1,    60,    18,    -1,    -1,    -1,    -1,    23,
      -1,    -1,    26,    27,    28,    29,    30,    31,    32,    -1,
      12,    13,    14,    15,    -1,    60,    18,    -1,    -1,    -1,
      -1,    23,    -1,    -1,    26,    27,    28,    29,    30,    31,
      32,    12,    13,    14,    15,    -1,    60,    18,    -1,    -1,
      -1,    -1,    23,    45,    -1,    26,    27,    28,    29,    30,
      31,    32,    12,    13,    14,    15,    -1,    -1,    18,    -1,
      -1,    -1,    -1,    23,    45,    -1,    26,    27,    28,    29,
      30,    31,    32,    -1,    12,    13,    14,    15,    -1,    39,
      18,    -1,    -1,    -1,    -1,    23,    -1,    -1,    26,    27,
      28,    29,    30,    31,    32,    14,    15,    -1,    -1,    18,
      -1,    -1,    -1,    -1,    23,    -1,    -1,    26,    27,    28,
      29,    30,    31,    32,    15,    -1,    -1,    18,    -1,    -1,
      -1,    -1,    23,    -1,    -1,    26,    27,    28,    29,    30,
      31,    32,    23,    -1,    -1,    26,    27,    28,    29,    30,
      31,    32,    26,    27,    28,    29,    30,    31,    32,    27,
      28,    29,    30,    31,    32
};

/* YYSTOS[STATE-NUM] -- The (internal number of the) accessing
   symbol of state STATE-NUM.  */
static const yytype_uint8 yystos[] =
{
       0,     4,    40,    67,    68,    69,    11,     4,     0,    68,
      58,    35,    36,    37,    44,    46,    41,    58,     3,     3,
       4,     4,     5,     6,     7,     8,     9,    10,    20,    21,
      49,    51,    52,    53,    54,    59,    70,    72,     4,     3,
      50,    57,    50,    57,    38,    76,    47,    48,    61,    62,
      70,    70,    59,    59,    59,    59,    59,    70,    12,    13,
      14,    15,    18,    23,    26,    27,    28,    29,    30,    31,
      32,    45,    43,    65,    38,    50,    55,    78,    59,    45,
      59,    45,    70,     4,     6,    70,    70,    70,    70,    70,
      60,    70,    70,    70,    70,     8,    21,    59,    70,    70,
      70,    70,    70,    70,    70,    70,     4,     4,    70,    70,
      74,    75,    59,     6,    57,     3,    59,     3,    59,    63,
      60,    60,    60,    60,    60,     8,     4,    69,    39,    42,
      71,    77,    45,    65,     3,    60,    70,    73,    60,    73,
      64,    60,     4,    38,     4,    74,    60,    45,    60,    65,
      45,    60,     4,    56,    74,    78,    59,    70,    59,    59,
      70,    73,    73,     6,    77,    60,    60,    60
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
#line 143 "bison.y"
    { emit("STMT"); ;}
    break;

  case 5:

/* Line 1455 of yacc.c  */
#line 147 "bison.y"
    { emit_select((yyvsp[(1) - (7)].strval), (yyvsp[(6) - (7)].strval), (yyvsp[(7) - (7)].intval)); ;}
    break;

  case 6:

/* Line 1455 of yacc.c  */
#line 149 "bison.y"
    {  emit_load((yyvsp[(1) - (12)].strval), (yyvsp[(4) - (12)].strval), (yyvsp[(11) - (12)].intval), (yyvsp[(7) - (12)].strval), 0); ;}
    break;

  case 7:

/* Line 1455 of yacc.c  */
#line 151 "bison.y"
    {  emit_load((yyvsp[(1) - (12)].strval), (yyvsp[(4) - (12)].strval), (yyvsp[(11) - (12)].intval), (yyvsp[(7) - (12)].strval), 1); ;}
    break;

  case 8:

/* Line 1455 of yacc.c  */
#line 153 "bison.y"
    {  emit_load_binary((yyvsp[(1) - (9)].strval), (yyvsp[(4) - (9)].strval), (yyvsp[(8) - (9)].intval), 1); ;}
    break;

  case 9:

/* Line 1455 of yacc.c  */
#line 155 "bison.y"
    {  emit_load_binary((yyvsp[(1) - (9)].strval), (yyvsp[(4) - (9)].strval), (yyvsp[(8) - (9)].intval), 0); ;}
    break;

  case 10:

/* Line 1455 of yacc.c  */
#line 157 "bison.y"
    {  emit_filter((yyvsp[(1) - (5)].strval), (yyvsp[(4) - (5)].strval), (yyvsp[(5) - (5)].intval));;}
    break;

  case 11:

/* Line 1455 of yacc.c  */
#line 159 "bison.y"
    {  emit_order((yyvsp[(1) - (6)].strval), (yyvsp[(4) - (6)].strval), (yyvsp[(6) - (6)].intval));;}
    break;

  case 12:

/* Line 1455 of yacc.c  */
#line 161 "bison.y"
    { emit_join((yyvsp[(1) - (7)].strval),(yyvsp[(6) - (7)].strval)); ;}
    break;

  case 13:

/* Line 1455 of yacc.c  */
#line 163 "bison.y"
    { emit_store((yyvsp[(2) - (9)].strval),(yyvsp[(4) - (9)].strval),(yyvsp[(7) - (9)].strval)); ;}
    break;

  case 14:

/* Line 1455 of yacc.c  */
#line 165 "bison.y"
    { emit_store_binary((yyvsp[(2) - (6)].strval),(yyvsp[(4) - (6)].strval)); ;}
    break;

  case 15:

/* Line 1455 of yacc.c  */
#line 169 "bison.y"
    { emit_name((yyvsp[(1) - (1)].strval)); ;}
    break;

  case 16:

/* Line 1455 of yacc.c  */
#line 170 "bison.y"
    { emit("FIELDNAME %s.%s", (yyvsp[(1) - (3)].strval), (yyvsp[(3) - (3)].strval)); ;}
    break;

  case 17:

/* Line 1455 of yacc.c  */
#line 171 "bison.y"
    { emit("USERVAR %s", (yyvsp[(1) - (1)].strval)); ;}
    break;

  case 18:

/* Line 1455 of yacc.c  */
#line 172 "bison.y"
    { emit_string((yyvsp[(1) - (1)].strval)); ;}
    break;

  case 19:

/* Line 1455 of yacc.c  */
#line 173 "bison.y"
    { emit_number((yyvsp[(1) - (1)].intval)); ;}
    break;

  case 20:

/* Line 1455 of yacc.c  */
#line 174 "bison.y"
    { emit_float((yyvsp[(1) - (1)].floatval)); ;}
    break;

  case 21:

/* Line 1455 of yacc.c  */
#line 175 "bison.y"
    { emit_decimal((yyvsp[(1) - (1)].intval)); ;}
    break;

  case 22:

/* Line 1455 of yacc.c  */
#line 176 "bison.y"
    { emit("BOOL %d", (yyvsp[(1) - (1)].intval)); ;}
    break;

  case 23:

/* Line 1455 of yacc.c  */
#line 177 "bison.y"
    { emit_varchar((yyvsp[(1) - (9)].strval), (yyvsp[(3) - (9)].intval), (yyvsp[(6) - (9)].strval), (yyvsp[(8) - (9)].intval));;}
    break;

  case 24:

/* Line 1455 of yacc.c  */
#line 178 "bison.y"
    { emit_var((yyvsp[(1) - (6)].strval), (yyvsp[(3) - (6)].intval), (yyvsp[(6) - (6)].strval));;}
    break;

  case 25:

/* Line 1455 of yacc.c  */
#line 179 "bison.y"
    { emit_var_asc((yyvsp[(1) - (2)].strval));;}
    break;

  case 26:

/* Line 1455 of yacc.c  */
#line 180 "bison.y"
    { emit_var_desc((yyvsp[(1) - (2)].strval));;}
    break;

  case 27:

/* Line 1455 of yacc.c  */
#line 181 "bison.y"
    { emit_count(); ;}
    break;

  case 28:

/* Line 1455 of yacc.c  */
#line 182 "bison.y"
    { emit_sum(); ;}
    break;

  case 29:

/* Line 1455 of yacc.c  */
#line 183 "bison.y"
    { emit_average(); ;}
    break;

  case 30:

/* Line 1455 of yacc.c  */
#line 184 "bison.y"
    { emit_min(); ;}
    break;

  case 31:

/* Line 1455 of yacc.c  */
#line 185 "bison.y"
    { emit_max(); ;}
    break;

  case 32:

/* Line 1455 of yacc.c  */
#line 189 "bison.y"
    { emit_add(); ;}
    break;

  case 33:

/* Line 1455 of yacc.c  */
#line 190 "bison.y"
    { emit_minus(); ;}
    break;

  case 34:

/* Line 1455 of yacc.c  */
#line 191 "bison.y"
    { emit_mul(); ;}
    break;

  case 35:

/* Line 1455 of yacc.c  */
#line 192 "bison.y"
    { emit_div(); ;}
    break;

  case 36:

/* Line 1455 of yacc.c  */
#line 193 "bison.y"
    { emit("MOD"); ;}
    break;

  case 37:

/* Line 1455 of yacc.c  */
#line 194 "bison.y"
    { emit("MOD"); ;}
    break;

  case 38:

/* Line 1455 of yacc.c  */
#line 196 "bison.y"
    { emit_and(); ;}
    break;

  case 39:

/* Line 1455 of yacc.c  */
#line 197 "bison.y"
    { emit_eq(); ;}
    break;

  case 40:

/* Line 1455 of yacc.c  */
#line 198 "bison.y"
    { emit_or(); ;}
    break;

  case 41:

/* Line 1455 of yacc.c  */
#line 199 "bison.y"
    { emit("XOR"); ;}
    break;

  case 42:

/* Line 1455 of yacc.c  */
#line 200 "bison.y"
    { emit("SHIFT %s", (yyvsp[(2) - (3)].subtok)==1?"left":"right"); ;}
    break;

  case 43:

/* Line 1455 of yacc.c  */
#line 201 "bison.y"
    { emit("NOT"); ;}
    break;

  case 44:

/* Line 1455 of yacc.c  */
#line 202 "bison.y"
    { emit("NOT"); ;}
    break;

  case 45:

/* Line 1455 of yacc.c  */
#line 203 "bison.y"
    { emit_cmp((yyvsp[(2) - (3)].subtok)); ;}
    break;

  case 46:

/* Line 1455 of yacc.c  */
#line 205 "bison.y"
    { emit("CMPSELECT %d", (yyvsp[(2) - (5)].subtok)); ;}
    break;

  case 47:

/* Line 1455 of yacc.c  */
#line 206 "bison.y"
    {emit("EXPR");;}
    break;

  case 48:

/* Line 1455 of yacc.c  */
#line 210 "bison.y"
    { emit("ISBOOL %d", (yyvsp[(3) - (3)].intval)); ;}
    break;

  case 49:

/* Line 1455 of yacc.c  */
#line 211 "bison.y"
    { emit("ISBOOL %d", (yyvsp[(4) - (4)].intval)); emit("NOT"); ;}
    break;

  case 50:

/* Line 1455 of yacc.c  */
#line 214 "bison.y"
    { /* nil */
    (yyval.intval) = 0;
;}
    break;

  case 51:

/* Line 1455 of yacc.c  */
#line 217 "bison.y"
    { (yyval.intval) = (yyvsp[(3) - (3)].intval);}
    break;

  case 52:

/* Line 1455 of yacc.c  */
#line 221 "bison.y"
    { (yyval.intval) = 1; emit_sel_name((yyvsp[(3) - (3)].strval));;}
    break;

  case 53:

/* Line 1455 of yacc.c  */
#line 222 "bison.y"
    { (yyval.intval) = (yyvsp[(1) - (5)].intval) + 1; emit_sel_name((yyvsp[(5) - (5)].strval));;}
    break;

  case 54:

/* Line 1455 of yacc.c  */
#line 226 "bison.y"
    { (yyval.intval) = 1; ;}
    break;

  case 55:

/* Line 1455 of yacc.c  */
#line 227 "bison.y"
    {(yyval.intval) = (yyvsp[(1) - (3)].intval) + 1; ;}
    break;

  case 56:

/* Line 1455 of yacc.c  */
#line 231 "bison.y"
    { (yyval.intval) = 1; ;}
    break;

  case 57:

/* Line 1455 of yacc.c  */
#line 232 "bison.y"
    { (yyval.intval) = 1 + (yyvsp[(3) - (3)].intval); ;}
    break;

  case 58:

/* Line 1455 of yacc.c  */
#line 235 "bison.y"
    { /* nil */
    (yyval.intval) = 0
;}
    break;

  case 60:

/* Line 1455 of yacc.c  */
#line 240 "bison.y"
    { emit("FILTER BY"); ;}
    break;

  case 61:

/* Line 1455 of yacc.c  */
#line 243 "bison.y"
    { (yyval.intval) = 1; emit_join_tab((yyvsp[(2) - (4)].strval));;}
    break;

  case 62:

/* Line 1455 of yacc.c  */
#line 244 "bison.y"
    { (yyval.intval) = 1; emit_join_tab((yyvsp[(2) - (5)].strval)); ;}
    break;

  case 63:

/* Line 1455 of yacc.c  */
#line 246 "bison.y"
    { /* nil */
    (yyval.intval) = 0
;}
    break;

  case 64:

/* Line 1455 of yacc.c  */
#line 249 "bison.y"
    { emit_limit((yyvsp[(2) - (2)].intval)); ;}
    break;



/* Line 1455 of yacc.c  */
#line 2044 "bison.tab.c"
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
#line 252 "bison.y"


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



bool fact_file_loaded = 0;
bool fact_file_exists = 0;
FILE *file_pointer;
string fact_file_name = "NULL";
long long int stream_pos = 0;
long long int totalRecs = 0;
long long int runningRecs = 0;
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
    else
	    if (join_col_cnt == -1 )
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

    // initialize permutation to [0, 1, 2, ... ,N-1]
	
	
	

    thrust::device_ptr<unsigned int> permutation = thrust::device_malloc<unsigned int>(a->mRecCount);					
    thrust::sequence(permutation, permutation+(a->mRecCount));
	
	
    unsigned int* raw_ptr = thrust::raw_pointer_cast(permutation);
    void* temp;
    CUDA_SAFE_CALL(cudaMalloc((void **) &temp, a->mRecCount*float_size));
	

    for(int i=0; !exe_type.empty(); ++i, exe_type.pop()) {
	    
        int colInd = (a->columnNames).find(exe_type.top())->second;
        if ((a->type)[colInd] == 0)
            update_permutation((int_type*)(a->d_columns)[colInd], raw_ptr, a->mRecCount, "ASC", (int_type*)temp);
        else if ((a->type)[colInd] == 1)
            update_permutation((float_type*)(a->d_columns)[colInd], raw_ptr, a->mRecCount,"ASC", (float_type*)temp);
        else {
            CudaChar* c = (CudaChar*)(a->h_columns)[colInd];
            for(int j=(c->mColumnCount)-1; j>=0 ; j--)
                update_permutation_char((c->d_columns)[j], raw_ptr, a->mRecCount, (char*)temp, "ASC");
        };
    };
	
    for (set<string>::iterator it=field_names.begin(); it!=field_names.end(); ++it) {
        int i = a->columnNames[*it];
	    if ((a->type)[i] == 0)
            apply_permutation((int_type*)(a->d_columns)[i], raw_ptr, a->mRecCount, (int_type*)temp);
        else if ((a->type)[i] == 1)
            apply_permutation((float_type*)(a->d_columns)[i], raw_ptr, a->mRecCount, (float_type*)temp);
        else {
            CudaChar* c = (CudaChar*)(a->h_columns)[i];
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
	
	
    CudaSet* a = varNames.find(j1)->second;
    CudaSet* b = varNames.find(j2)->second;



    if(a->readyToProcess == 0 || b->readyToProcess == 0) 
        return;

    if (a->fact_table == 0 && b->fact_table == 0 && lc > 1) 
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
	//cout << f1 << " " << f2 << endl;
	

	std::clock_t start1 = std::clock();
	
	
    CudaSet* c;

    //cout << "a count and b count " << a->mRecCount << " : " << b->mRecCount << endl;

    if (a->mRecCount == 0 || b->mRecCount == 0) {
        c = new CudaSet(a,b,0, op_sel, op_sel_as,1);
        c->readyToProcess = 1;
        if (a->fact_table == 1 || b->fact_table == 1)
            c->fact_table = 1;		
        varNames[s] = c;
        clean_queues();
        return;
    };


    int colInd1 = (a->columnNames).find(f1)->second;
    int colInd2 = (b->columnNames).find(f2)->second;	
	
    int_type sza, szb;
    if (a->type[colInd1] == 0)
        sza = int_size*(a->mRecCount);
    else if (a->type[colInd1] == 1)
        sza = float_size*(a->mRecCount);
    else
      sza =  ((CudaChar*)a->h_columns[colInd1])->mColumnCount;

    if (b->type[colInd2] == 0)
        szb = int_size*(b->mRecCount);
    else if (b->type[colInd2] == 1)
        szb = float_size*(b->mRecCount);
    else
        szb =  ((CudaChar*)b->h_columns[colInd2])->mColumnCount;
		
    CudaSet* left;
    CudaSet* right;
    int colLeft, colRight;
    string fLeft, fRight;
    unsigned int pieces;
	bool pp;
	
	//cout << "SZ " << sza << " " << szb << " " << getFreeMem()/2 <<  endl;
	
	if((sza + szb) > getFreeMem()/2) {
	   if(sza < szb) {
           left = b;
		   right = a;
           colLeft = colInd2;
           colRight = colInd1;
           fLeft = f2;
           fRight = f1;
           pp = 0; 
		   pieces = (szb/(getFreeMem()/2 - sza))+1;
       }
       else {
         left = a;
		 right = b;
         colLeft = colInd1;
         colRight = colInd2;
         fLeft = f1;
         fRight = f2;
         pp = 1; 		 
		 pieces = (sza/(getFreeMem()/2 - szb))+1;
       };		   
	}
	else {
        left = a;
		right = b;
        colLeft = colInd1;
        colRight = colInd2;
        fLeft = f1;
        fRight = f2;
        pp = 1; 
        pieces = 1;		
	};
		
	//cout << "join in pieces " << pieces << endl;	

    unsigned int chunk = left->mRecCount/pieces;
    unsigned int oldRecCount = left->mRecCount;  

    bool left_in_gpu = 0;
    bool right_in_gpu = 0;

    if(left->d_columns[0] != 0) {
//	    pieces = 1; // will try to do in-memory join
        if(pieces > 1) {
		    
			if(!left->h_columns[0]) {
                for(unsigned int i=0; i < left->mColumnCount; i++) {				
                    if (left->type[i] == 0) 
                        cudaMallocHost(&left->h_columns[i], int_size*(left->mRecCount+1)); 
                    else if (left->type[i] == 1) 
                        cudaMallocHost(&left->h_columns[i], float_size*left->mRecCount);
                    else {
  		                CudaChar *c = (CudaChar*) left->h_columns[i];
                        for(unsigned int i=0; i <c->mColumnCount; i++)
                            c->h_columns[i] = new char[left->mRecCount];
				        };	
		        };		               
			};	
            left->CopyToHost(0,left->mRecCount);
			left->deAllocOnDevice();
            left_in_gpu = 0;
		}
        else
   		    left_in_gpu = 1;
	};	
    if(right->d_columns[0] != 0)
        right_in_gpu = 1;    

    if(!right_in_gpu) {
        right->allocColumnOnDevice(colRight, right->mRecCount);
        right->CopyColumnToGpu(colRight, 0, right->mRecCount);
    };	

    set<string> field_names;
    stack<string> exe_type;

    exe_type.push(fRight);
    field_names.insert(fRight);	
	
	
	// check if already sorted 
	if(lc == 0 || right->fact_table) {
	
        thrust::device_ptr<unsigned int> perm = order_inplace(right, exe_type, field_names);			
        unsigned int* raw_ptr = thrust::raw_pointer_cast(perm);
        void* temp;
        cudaMalloc((void **) &temp, right->mRecCount*float_size);
	
        for(int i = 0; i < right->mColumnCount; i++) {		

            if(i != colRight && (!right_in_gpu)) {
                right->allocColumnOnDevice(i, right->mRecCount);
                right->CopyColumnToGpu(i, 0, right->mRecCount);
            };

            if ((right->type)[i] == 0 && i != colRight)
                apply_permutation((int_type*)(right->d_columns)[i], raw_ptr, right->mRecCount, (int_type*)temp);
            else if ((right->type)[i] == 1 && i != colRight)
                apply_permutation((float_type*)(right->d_columns)[i], raw_ptr, right->mRecCount, (float_type*)temp);
            else if (i != colRight){
                CudaChar* c = (CudaChar*)(right->h_columns)[i];
                for(int j=(c->mColumnCount)-1; j>=0 ; j--) {
                    apply_permutation_char((c->d_columns)[j], raw_ptr, right->mRecCount, (char*)temp);
                };
            };

            if(!right_in_gpu) {
                right->CopyColumnToHost(i);
                right->deAllocColumnOnDevice(i);
            };
        };
        thrust::device_free(perm);
        cudaFree(temp);
	};

    //if(!right_in_gpu) {
    //    right->allocColumnOnDevice(colRight, right->mRecCount);
    //    right->CopyColumnToGpu(colRight, 0, right->mRecCount);
    //};		

    for(int i = 0; i < pieces; i ++) {  // Main piece cycle
        if (pieces != 1) {
            left->mRecCount = chunk;
            if (i == pieces-1)
                left->mRecCount = oldRecCount - chunk*i;
        };
        if (!left_in_gpu) {
		    if(!left->d_columns[0])
                left->allocColumnOnDevice(colLeft, left->mRecCount);
            left->CopyColumnToGpu(colLeft, i*chunk, left->mRecCount);
        };
        if ( !right_in_gpu) {
		    if(!right->d_columns[0])
                right->allocColumnOnDevice(colRight, right->mRecCount);
            right->CopyColumnToGpu(colRight, 0, right->mRecCount);
        };

        thrust::device_vector<unsigned int> d_res1;
        thrust::device_vector<unsigned int> d_res2;

		std::clock_t start2 = std::clock();
		
//		cout << "right:left " << right->mRecCount << " " << left->mRecCount << endl;

//        cout << "small col is unique : " << small->isUnique(colSmall) << endl;

        if ((left->type)[colLeft] == 0 && (right->type)[colRight]  == 0) {
            join((int_type*)(right->d_columns)[colRight], (int_type*)(left->d_columns)[colLeft],
                 d_res1, d_res2, left->mRecCount, right->mRecCount, right->isUnique(colRight));
		}		 
        else if ((left->type)[colLeft] == 2 && (right->type)[colRight]  == 2)
            join((CudaChar*)(right->h_columns)[colRight], (CudaChar*)(left->h_columns)[colLeft], d_res1, d_res2);
        else if ((left->type)[colLeft] == 1 && (right->type)[colRight]  == 1) {
            thrust::device_ptr<float_type> dev_ptr_left((float_type*)(left->d_columns)[colLeft]);
            thrust::device_ptr<float_type> dev_ptr_right((float_type*)(right->d_columns)[colRight]);
            thrust::device_ptr<int_type> dev_ptr_int_left = thrust::device_malloc<int_type>(left->mRecCount);
            thrust::device_ptr<int_type> dev_ptr_int_right = thrust::device_malloc<int_type>(right->mRecCount);

            thrust::transform(dev_ptr_left, dev_ptr_left + left->mRecCount, dev_ptr_int_left, float_to_decimal());
            thrust::transform(dev_ptr_right, dev_ptr_right + right->mRecCount, dev_ptr_int_right, float_to_decimal());

            join(thrust::raw_pointer_cast(dev_ptr_int_right), thrust::raw_pointer_cast(dev_ptr_int_left),
                 d_res1, d_res2, left->mRecCount, right->mRecCount, 0);

            thrust::device_free(dev_ptr_int_left);
            thrust::device_free(dev_ptr_int_right);
        };		
		

        if (!right_in_gpu)
            right->deAllocColumnOnDevice(colRight);
        if (!left_in_gpu)
            left->deAllocColumnOnDevice(colLeft);

        // Here we need to add possible joins on other columns
        queue<string> op_value1(op_value);		
        while(!op_value1.empty()) {
            f1 = op_value1.front();
            op_value1.pop();
            f2 = op_value1.front();
            op_value1.pop();

            if(pp == 1) { //left = a; so f1 refers to left
                colInd1 = (left->columnNames).find(f1)->second;
                colInd2 = (right->columnNames).find(f2)->second;
            }
            else {
			    colInd1 = (left->columnNames).find(f2)->second;
                colInd2 = (right->columnNames).find(f1)->second;                
            };

            if(left->type[colInd1] != right->type[colInd2]) {
                cout << "Cannot do join on columns of different types : " << f1 << " " << f2 << endl;
                exit(1);
            };

            if (!right_in_gpu) {
                right->allocColumnOnDevice(colInd2, right->mRecCount);
                right->CopyColumnToGpu(colInd2, 0, right->mRecCount);
            };
            if (!left_in_gpu) {
                left->allocColumnOnDevice(colInd1, left->mRecCount);
                left->CopyColumnToGpu(colInd1, 0, left->mRecCount);
            };

            void* d1;
            void* d2;
            if (right->type[colInd2] == 0 ) {
                thrust::device_ptr<int_type> src1((int_type*)(right->d_columns)[colInd2]);
                CUDA_SAFE_CALL(cudaMalloc((void **) &d1, d_res2.size()*int_size));
                thrust::device_ptr<int_type> dest1((int_type*)d1);
                thrust::gather(d_res2.begin(), d_res2.end(), src1, dest1);

                thrust::device_ptr<int_type> src2((int_type*)(left->d_columns)[colInd1]);
                CUDA_SAFE_CALL(cudaMalloc((void **) &d2, d_res2.size()*int_size));
                thrust::device_ptr<int_type> dest2((int_type*)d2);
                thrust::gather(d_res1.begin(), d_res1.end(), src2, dest2);

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
                thrust::device_ptr<float_type> src1((float_type*)(right->d_columns)[colInd2]);
                CUDA_SAFE_CALL(cudaMalloc((void **) &d1, d_res2.size()*float_size));
                thrust::device_ptr<float_type> dest1((float_type*)d1);
                thrust::gather(d_res2.begin(), d_res2.end(), src1, dest1);

                thrust::device_ptr<float_type> src2((float_type*)(left->d_columns)[colInd1]);
                CUDA_SAFE_CALL(cudaMalloc((void **) &d2, d_res2.size()*float_size));
                thrust::device_ptr<float_type> dest2((float_type*)d2);
                thrust::gather(d_res1.begin(), d_res1.end(), src2, dest2);
                thrust::device_ptr<int_type> d3 = thrust::device_malloc<int_type>(d_res2.size());
                thrust::device_ptr<int_type> d4 = thrust::device_malloc<int_type>(d_res2.size());
                thrust::transform(dest1, dest1+d_res2.size(), dest2, d3,f_equal_to());

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
                CudaChar *s1 = (CudaChar*)(right->h_columns)[colInd2];
                CUDA_SAFE_CALL(cudaMalloc((void **) &d1, d_res2.size()));
                thrust::device_ptr<char> dest1((char*)d1);

                CudaChar *s2 = (CudaChar*)(left->h_columns)[colInd1];
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
                    thrust::device_ptr<char> src1(s1->d_columns[j]);
                    thrust::device_ptr<char> src2(s2->d_columns[j]);
                    thrust::gather(d_res2.begin(), d_res2.end(), src1, dest1);
                    thrust::gather(d_res2.begin(), d_res2.end(), src2, dest2);
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

        //cout << "join final end " << d_res1.size() << "  " << getFreeMem() << endl;
		
	

        // need to find if there is enough gpu memory to store the results
        bool in_mem = joinResInGpu(right,left,d_res1.size()) && (pieces == 1);


        // now we need to gather results to CudaSet c
        if(i == 0) {
            c = new CudaSet(right,left,d_res1.size(),op_sel, op_sel_as, in_mem);
            if(in_mem && d_res1.size() != 0)
                c->allocOnDevice(d_res1.size());
            c->readyToProcess = 1;
            if (a->fact_table == 1 || b->fact_table == 1)
                c->fact_table = 1;
            else
                c->fact_table = 0;
            if (d_res1.size() != 0)
                c->gather(right,left,d_res2,d_res1, 0, 0, in_mem, op_sel);
        }
        else {
            if (d_res1.size() != 0)
                c->gather(right,left,d_res2,d_res1, c->mRecCount, i*chunk, in_mem, op_sel);
        };


    };  // end of join piece cycle	


    if (a->fact_table == 0 && b->fact_table == 0) {
        b->deAllocOnDevice();
        a->deAllocOnDevice();
    };

    if (a->fact_table == 0 && b->fact_table == 1) {
        b->deAllocOnDevice();
    };
    if (b->fact_table == 0 && a->fact_table == 1) {
        a->deAllocOnDevice();
    };

    varNames[s] = c;
    clean_queues();

    if(stat[s] == statement_count) {
        c->free();
        varNames.erase(s);
    };
    if(stat[j1] == statement_count && fact_file_loaded == 1) {
        a->free();
        varNames.erase(j1);
    };
    if(stat[j2] == statement_count && (strcmp(j1,j2.c_str()) != 0) && fact_file_loaded == 1) {
        b->free();
        varNames.erase(j2);
    };
    if(stat[j1] == statement_count && fact_file_loaded == 0 && a->fact_table == 0 && b->fact_table == 0) {
        a->free();
        varNames.erase(j1);
    };
    if(stat[j2] == statement_count && fact_file_loaded == 0 && a->fact_table == 0 && b->fact_table == 0) {
        b->free();
        varNames.erase(j2);
    };

    if(stat[j2] == statement_count && a->fact_table == 0 && b->fact_table == 0 && varNames.find(j2) != varNames.end()) {
        b->free();
        varNames.erase(j2);
    };
    if(stat[j1] == statement_count && b->fact_table == 0 && a->fact_table == 0 && varNames.find(j1) != varNames.end()) {
        a->free();
        varNames.erase(j1);
    };
    if(stat[j2] == statement_count &&  b->fact_table == 1 && !b->keep && fact_file_loaded == 0) {
        b->free();
        varNames.erase(j2);
    };
    if(stat[j1] == statement_count &&  a->fact_table == 1 && !a->keep && fact_file_loaded == 0) {
        a->free();
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
    if(a->d_columns[0] != 0)
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
            update_permutation((int_type*)(a->d_columns)[colInd], raw_ptr, a->mRecCount, exe_value.top(), (int_type*)temp);
        else if ((a->type)[colInd] == 1)
            update_permutation((float_type*)(a->d_columns)[colInd], raw_ptr, a->mRecCount,exe_value.top(), (float_type*)temp);
        else {
            CudaChar* c = (CudaChar*)(a->h_columns)[colInd];
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
            thrust::device_ptr<int_type> src((int_type*)(a->d_columns)[i]);
            thrust::device_ptr<int_type> dest((int_type*)(b->d_columns)[i]);
            thrust::copy(src,src+a->mRecCount,dest);
            apply_permutation((int_type*)(b->d_columns)[i], raw_ptr, b->mRecCount, (int_type*)temp);
        }
        else if (a->type[i] == 1 ) {
            thrust::device_ptr<float_type> src((float_type*)(a->d_columns)[i]);
            thrust::device_ptr<float_type> dest((float_type*)(b->d_columns)[i]);
            thrust::copy(src,src+a->mRecCount,dest);
            apply_permutation((float_type*)(b->d_columns)[i], raw_ptr, b->mRecCount, (float_type*)temp);
        }
        else { //CudaChar
            CudaChar *s = (CudaChar*)(a->h_columns)[i];
            CudaChar *d = (CudaChar*)b->h_columns[i];
            for(unsigned int j=0; j < s->mColumnCount; j++) {
                thrust::device_ptr<char> src(s->d_columns[j]);
                thrust::device_ptr<char> dest(d->d_columns[j]);
                thrust::copy(src,src+a->mRecCount,dest);
                apply_permutation_char(thrust::raw_pointer_cast(dest), raw_ptr, b->mRecCount, (char*)temp);
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
    int_type sum = 0;
    set<string> field_names;

    for(int i=0; !op_v.empty(); ++i, op_v.pop())
        if(a->columnNames.find(op_v.front()) != a->columnNames.end())
            field_names.insert(op_v.front());


    for (set<string>::iterator it=field_names.begin(); it!=field_names.end(); ++it) {
        int ind = a->columnNames[*it];
        if(a->type[ind] <= 1)
            sum = sum+int_size;
        else
            sum = sum + ((CudaChar*)((a->h_columns)[ind]))->mColumnCount;
    };


    int_type chunkCount =  (getFreeMem() *  gpu_mem)/sum;
    if (chunkCount > a->mRecCount)
        chunkCount = a->mRecCount;

    bool in_gpu = false;
    if (a->d_columns[0] == 0)
        for (set<string>::iterator it=field_names.begin(); it!=field_names.end(); ++it)
            a->allocColumnOnDevice(a->columnNames[*it], chunkCount);
    else
        in_gpu = true;

    unsigned int pieces = a->mRecCount/chunkCount;

    if (a->mRecCount%chunkCount != 0)
        pieces++;
    if(pieces == 0)
        pieces = 1;

    if (ll == 0 || in_gpu) {
        pieces = 1;
        chunkCount = a->mRecCount;
    };


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


    int_type copy_count = chunkCount;
    int_type old_reccount = a->mRecCount;

    for(unsigned int i = 0; i < pieces; i++) {          // MAIN CYCLE

//        if(ll == 0 && one_line && varNames.find(s) != varNames.end())
        if(ll == 0 && varNames.find(s) != varNames.end())
            b = varNames[s];
        else {
            b = new CudaSet(chunkCount, col_count);
        };
        b->mRecCount = 0;

        if(i == pieces-1)
            copy_count = old_reccount - chunkCount*i;
        a->mRecCount = copy_count;

        if(!in_gpu)
            for (set<string>::iterator it=field_names.begin(); it!=field_names.end(); ++it)
                a->CopyColumnToGpu(a->columnNames[*it], i*chunkCount, copy_count);


        if (ll != 0) {
            thrust::device_ptr<unsigned int> perm = order_inplace(a,op_v2,field_names);
            thrust::device_free(perm);
            a->GroupBy(op_v3);
        };

        select(op_type,op_value,op_nums, op_nums_f,a,b, old_reccount);

        if (ll != 0) {

            if(lc > 1 && varNames.find(s) != varNames.end()) {
                c = varNames[s];
				if(c->mRecCount == 0) {
					c->free();
					c = new CudaSet(b->mRecCount, col_count);
				}
				else
                    c->resize(b->mRecCount);
            }
            else {
                if (i == 0) 
                    c = new CudaSet(b->mRecCount, col_count);
                else
                    c->resize(b->mRecCount);
            };
            add(c,b,op_v3, op_v2);
        };
        b->deAllocOnDevice();
    };

    a->mRecCount = old_reccount;

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
        return;
    };


    if(varNames.find(f) == varNames.end()) {
        clean_queues();
        return;
    };



    CudaSet *a;
    CudaSet* b;
    bool in_gpu = false;

    a = varNames.find(f)->second;

    if(a->mRecCount == 0) {
        b = new CudaSet(0,1);
    }
    else {

        if(a->readyToProcess == 0)
            return;

        if (a->fact_table == 0 && lc > 1)
            return;

        printf("emit filter : %s %s \n", s, f);
		exit(0);
      
        // calculate how many records we can process at once
        // load them into GPU

        unsigned int chunkCount = getChunkCount(a);


        if (a->d_columns[0] == 0)
            a->allocOnDevice(chunkCount);
        else
            in_gpu = true;

        unsigned int pieces;

        pieces = a->mRecCount/chunkCount;
        if (a->mRecCount%chunkCount != 0)
            pieces++;
        if(pieces == 0)
            pieces = 1;

        if(in_gpu)
            pieces = 1;
			
        int_type copy_count = chunkCount;
        int_type old_reccount = a->mRecCount;

        if (lc == 1 || (varNames.find(s) == varNames.end()))
       			b = a->copyDeviceStruct();
        else
            b = varNames.find(s)->second;		
			
		b->mRecCount = 0;	        
		
        // if pieces == 1 then keep the results in GPU		
        for(unsigned int i = 0; i < pieces; i++) {
            if(i == pieces-1)
                copy_count = old_reccount - chunkCount*i;
            a->mRecCount = copy_count;
            if(!in_gpu)
                a->CopyToGpu(i*chunkCount, copy_count);
            filter(op_type,op_value,op_nums, op_nums_f,a,b, pieces);		
        };

        a->mRecCount = old_reccount;

        a->deAllocOnDevice();
        if (pieces != 1) {
            b->deAllocOnDevice();
			if(getSize(b)*b->mRecCount + 200000000 < getFreeMem()) {
			   b->allocOnDevice(b->mRecCount);
			   b->CopyToGpu(0,b->mRecCount);	
			};
			
		};	
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
    char f1[100];
    strcpy(f1, f);
    strcat(f1,".");
    char col_pos[3];
    itoaa(cols.front(),col_pos);
    strcat(f1,col_pos);	
    
    if (!stream && lc==1) {        
	    a = new CudaSet(namevars, typevars, sizevars, cols, findRecordCount(f1, namevars.size()), f);
		a->segCount = findSegmentCount(f1);
        a->fact_table = 0;
    };    

    if (stream) {
        fact_file_loaded = 0;
        if (lc == 1) {
            fact_file_name = f;
            fact_file_exists = 1;
            totalRecs = findRecordCount(f1, namevars.size());
            cout << "total " << totalRecs << endl;		
            a = new CudaSet(namevars, typevars, sizevars, cols, findSegmentCount(f1));
            a->keep = true;
            buffersLoaded = 0;
            th = a;
#ifdef _WIN64
            LoadBuffers(f);
#endif
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
            a->fact_table = 0;
            a->LoadFile(f, sep);
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
        cout << "Cycle " << lc << " " << endl;
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


