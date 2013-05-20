
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
    void emit_join(char *s, char *j1, int grp);
    void emit_join_tab(char *s, bool left);
    void emit_distinct();



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
     UMINUS = 281,
     LOAD = 282,
     STREAM = 283,
     FILTER = 284,
     BY = 285,
     JOIN = 286,
     STORE = 287,
     INTO = 288,
     GROUP = 289,
     FROM = 290,
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
     LEFT = 305
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
#line 219 "bison.cu"
} YYSTYPE;
# define YYSTYPE_IS_TRIVIAL 1
# define yystype YYSTYPE /* obsolescent; will be withdrawn */
# define YYSTYPE_IS_DECLARED 1
#endif


/* Copy the second part of user declarations.  */


/* Line 264 of yacc.c  */
#line 231 "bison.cu"

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
#define YYLAST   457

/* YYNTOKENS -- Number of terminals.  */
#define YYNTOKENS  68
/* YYNNTS -- Number of nonterminals.  */
#define YYNNTS  13
/* YYNRULES -- Number of rules.  */
#define YYNRULES  64
/* YYNRULES -- Number of states.  */
#define YYNSTATES  161

/* YYTRANSLATE(YYLEX) -- Bison symbol number corresponding to YYLEX.  */
#define YYUNDEFTOK  2
#define YYMAXUTOK   305

#define YYTRANSLATE(YYX)						\
  ((unsigned int) (YYX) <= YYMAXUTOK ? yytranslate[YYX] : YYUNDEFTOK)

/* YYTRANSLATE[YYLEX] -- Bison symbol number corresponding to YYLEX.  */
static const yytype_uint8 yytranslate[] =
{
       0,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,    21,     2,     2,     2,    32,    26,     2,
      61,    62,    30,    28,    67,    29,    63,    31,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,    66,    60,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,    34,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,    64,    25,    65,     2,     2,     2,     2,
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
      54,    55,    56,    57,    58,    59
};

#if YYDEBUG
/* YYPRHS[YYN] -- Index of the first RHS symbol of rule number YYN in
   YYRHS.  */
static const yytype_uint16 yyprhs[] =
{
       0,     0,     3,     6,    10,    12,    20,    33,    43,    49,
      56,    65,    75,    82,    84,    88,    90,    92,    94,    96,
      98,   100,   110,   117,   120,   123,   128,   133,   138,   143,
     148,   151,   155,   159,   163,   167,   171,   175,   179,   183,
     187,   191,   195,   198,   201,   205,   211,   215,   219,   224,
     225,   229,   233,   239,   241,   245,   247,   251,   252,   254,
     257,   262,   268,   274,   275
};

/* YYRHS -- A `-1'-separated list of the rules' RHS.  */
static const yytype_int8 yyrhs[] =
{
      69,     0,    -1,    70,    60,    -1,    69,    70,    60,    -1,
      71,    -1,     4,    11,    45,    74,    44,     4,    73,    -1,
       4,    11,    36,     3,    51,    61,     3,    62,    46,    61,
      75,    62,    -1,     4,    11,    36,     3,    58,    46,    61,
      75,    62,    -1,     4,    11,    38,     4,    78,    -1,     4,
      11,    47,     4,    39,    77,    -1,     4,    11,    45,    74,
      44,     4,    79,    73,    -1,    41,     4,    42,     3,    51,
      61,     3,    62,    80,    -1,    41,     4,    42,     3,    80,
      58,    -1,     4,    -1,     4,    63,     4,    -1,    10,    -1,
       5,    -1,     6,    -1,     9,    -1,     7,    -1,     8,    -1,
       4,    64,     6,    65,    66,     4,    61,     6,    62,    -1,
       4,    64,     6,    65,    66,     4,    -1,     4,    48,    -1,
       4,    49,    -1,    50,    61,    72,    62,    -1,    52,    61,
      72,    62,    -1,    53,    61,    72,    62,    -1,    54,    61,
      72,    62,    -1,    55,    61,    72,    62,    -1,    16,    72,
      -1,    72,    28,    72,    -1,    72,    29,    72,    -1,    72,
      30,    72,    -1,    72,    31,    72,    -1,    72,    32,    72,
      -1,    72,    33,    72,    -1,    72,    15,    72,    -1,    72,
      12,    72,    -1,    72,    13,    72,    -1,    72,    14,    72,
      -1,    72,    27,    72,    -1,    22,    72,    -1,    21,    72,
      -1,    72,    24,    72,    -1,    72,    24,    61,    71,    62,
      -1,    61,    72,    62,    -1,    72,    19,     8,    -1,    72,
      19,    22,     8,    -1,    -1,    43,    39,    76,    -1,    72,
      46,     4,    -1,    74,    67,    72,    46,     4,    -1,    72,
      -1,    75,    67,    72,    -1,    72,    -1,    72,    67,    76,
      -1,    -1,    76,    -1,    39,    72,    -1,    40,     4,    57,
      72,    -1,    59,    40,     4,    57,    72,    -1,    40,     4,
      57,    72,    79,    -1,    -1,    56,     6,    -1
};

/* YYRLINE[YYN] -- source line where rule number YYN was defined.  */
static const yytype_uint8 yyrline[] =
{
       0,   140,   140,   141,   145,   148,   150,   152,   154,   156,
     158,   160,   162,   167,   168,   169,   170,   171,   172,   173,
     174,   175,   176,   177,   178,   179,   180,   181,   182,   183,
     184,   188,   189,   190,   191,   192,   193,   195,   196,   197,
     198,   199,   200,   201,   202,   204,   205,   209,   210,   213,
     216,   220,   221,   225,   226,   230,   231,   234,   236,   239,
     242,   243,   244,   246,   249
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
  "'/'", "'%'", "MOD", "'^'", "UMINUS", "LOAD", "STREAM", "FILTER", "BY",
  "JOIN", "STORE", "INTO", "GROUP", "FROM", "SELECT", "AS", "ORDER", "ASC",
  "DESC", "COUNT", "USING", "SUM", "AVG", "MIN", "MAX", "LIMIT", "ON",
  "BINARY", "LEFT", "';'", "'('", "')'", "'.'", "'{'", "'}'", "':'", "','",
  "$accept", "stmt_list", "stmt", "select_stmt", "expr", "opt_group_list",
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
     275,    33,   276,   277,   278,   124,    38,   279,    43,    45,
      42,    47,    37,   280,    94,   281,   282,   283,   284,   285,
     286,   287,   288,   289,   290,   291,   292,   293,   294,   295,
     296,   297,   298,   299,   300,   301,   302,   303,   304,   305,
      59,    40,    41,    46,   123,   125,    58,    44
};
# endif

/* YYR1[YYN] -- Symbol number of symbol that rule YYN derives.  */
static const yytype_uint8 yyr1[] =
{
       0,    68,    69,    69,    70,    71,    71,    71,    71,    71,
      71,    71,    71,    72,    72,    72,    72,    72,    72,    72,
      72,    72,    72,    72,    72,    72,    72,    72,    72,    72,
      72,    72,    72,    72,    72,    72,    72,    72,    72,    72,
      72,    72,    72,    72,    72,    72,    72,    72,    72,    73,
      73,    74,    74,    75,    75,    76,    76,    77,    77,    78,
      79,    79,    79,    80,    80
};

/* YYR2[YYN] -- Number of symbols composing right hand side of rule YYN.  */
static const yytype_uint8 yyr2[] =
{
       0,     2,     2,     3,     1,     7,    12,     9,     5,     6,
       8,     9,     6,     1,     3,     1,     1,     1,     1,     1,
       1,     9,     6,     2,     2,     4,     4,     4,     4,     4,
       2,     3,     3,     3,     3,     3,     3,     3,     3,     3,
       3,     3,     2,     2,     3,     5,     3,     3,     4,     0,
       3,     3,     5,     1,     3,     1,     3,     0,     1,     2,
       4,     5,     5,     0,     2
};

/* YYDEFACT[STATE-NAME] -- Default rule to reduce with in state
   STATE-NUM when YYTABLE doesn't specify something else to do.  Zero
   means the default is an error.  */
static const yytype_uint8 yydefact[] =
{
       0,     0,     0,     0,     0,     4,     0,     0,     1,     0,
       2,     0,     0,     0,     0,     0,     3,     0,     0,    13,
      16,    17,    19,    20,    18,    15,     0,     0,     0,     0,
       0,     0,     0,     0,     0,     0,     0,     0,    63,     0,
       0,     0,     8,    23,    24,     0,     0,    30,    43,    42,
       0,     0,     0,     0,     0,     0,     0,     0,     0,     0,
       0,     0,     0,     0,     0,     0,     0,     0,     0,     0,
       0,     0,    57,     0,     0,     0,     0,     0,    59,    14,
       0,     0,     0,     0,     0,     0,    46,    38,    39,    40,
      37,    47,     0,     0,    44,    41,    31,    32,    33,    34,
      35,    36,    51,    49,     0,    55,    58,     9,     0,    64,
      12,     0,     0,     0,    25,    26,    27,    28,    29,    48,
      13,     0,     0,     0,     0,     5,    49,     0,     0,     0,
       0,    53,     0,     0,    45,     0,     0,     0,    10,    52,
      56,    63,     0,     7,     0,    22,     0,    50,     0,    11,
       0,    54,     0,    60,     0,     0,     0,    62,    61,     6,
      21
};

/* YYDEFGOTO[NTERM-NUM].  */
static const yytype_int16 yydefgoto[] =
{
      -1,     3,     4,     5,   105,   125,    36,   132,   106,   107,
      42,   126,    75
};

/* YYPACT[STATE-NUM] -- Index in YYTABLE of the portion describing
   STATE-NUM.  */
#define YYPACT_NINF -126
static const yytype_int16 yypact[] =
{
       6,    -3,     5,     1,   -44,  -126,    59,   -18,  -126,   -34,
    -126,    53,    64,   113,    65,    54,  -126,   -39,    31,    37,
    -126,  -126,  -126,  -126,  -126,  -126,   113,   113,   113,    33,
      41,    67,    71,    75,   113,   337,   -42,    76,    27,    77,
      78,   113,  -126,  -126,  -126,   122,   133,   401,   411,   411,
     113,   113,   113,   113,   113,   182,   113,   113,   113,   113,
      -2,   138,   113,   113,   113,   113,   113,   113,   113,   136,
     145,   113,   113,    89,   146,    93,   150,    94,   386,  -126,
      91,   204,   226,   248,   270,   292,  -126,   386,     3,   154,
     401,  -126,   149,    55,   418,   424,    81,    81,  -126,  -126,
    -126,  -126,  -126,   -36,   363,    60,  -126,  -126,   155,  -126,
    -126,    99,   113,    96,  -126,  -126,  -126,  -126,  -126,  -126,
      18,   102,   166,   132,   135,  -126,   129,   172,   113,   115,
     134,   386,    36,   175,  -126,   141,   113,   185,  -126,  -126,
    -126,   144,   142,  -126,   113,   143,   113,  -126,   148,  -126,
     113,   386,   196,   315,   113,    63,   158,  -126,   386,  -126,
    -126
};

/* YYPGOTO[NTERM-NUM].  */
static const yytype_int16 yypgoto[] =
{
    -126,  -126,   205,   114,   -13,    95,  -126,    72,  -125,  -126,
    -126,    73,    83
};

/* YYTABLE[YYPACT[STATE-NUM]].  What to do in state STATE-NUM.  If
   positive, shift that token.  If negative, reduce the rule which
   number is the opposite.  If zero, do what YYDEFACT says.
   If YYTABLE_NINF, syntax error.  */
#define YYTABLE_NINF -1
static const yytype_uint8 yytable[] =
{
      35,     8,    70,   140,   122,     1,    91,   123,     6,     7,
       1,   147,    39,    47,    48,    49,    10,    58,    59,    40,
      92,    55,    60,   124,    15,    71,    16,    61,    78,     6,
      62,    63,    64,    65,    66,    67,    68,    81,    82,    83,
      84,    85,     2,    87,    88,    89,    90,     2,    94,    95,
      96,    97,    98,    99,   100,   101,    17,    38,   104,   120,
      20,    21,    22,    23,    24,    25,    43,    44,    18,    37,
      41,    26,    56,    57,    58,    59,    27,    28,    73,    60,
      55,    45,    46,    74,    61,    43,    44,    62,    63,    64,
      65,    66,    67,    68,    50,    11,     2,    12,   143,   131,
      45,    46,    51,   144,    13,    29,    14,    30,    31,    32,
      33,    65,    66,    67,    68,    72,    34,    19,    20,    21,
      22,    23,    24,    25,    77,   159,    79,   128,    52,    26,
     144,   151,    53,   153,    27,    28,    54,   131,    76,    80,
     102,   158,    19,    20,    21,    22,    23,    24,    25,   103,
     108,   110,   109,   111,    26,   112,   113,   119,   129,    27,
      28,   130,   133,    29,   134,    30,    31,    32,    33,    59,
     135,   136,   123,    60,    34,   137,   139,   141,    61,   145,
     142,    62,    63,    64,    65,    66,    67,    68,    29,   148,
      30,    31,    32,    33,    56,    57,    58,    59,   146,    93,
      74,    60,   156,   150,   152,   154,    61,   121,     9,    62,
      63,    64,    65,    66,    67,    68,    56,    57,    58,    59,
     160,   138,   155,    60,   149,     0,   157,     0,    61,     0,
       0,    62,    63,    64,    65,    66,    67,    68,    56,    57,
      58,    59,     0,     0,    86,    60,     0,     0,     0,     0,
      61,     0,     0,    62,    63,    64,    65,    66,    67,    68,
      56,    57,    58,    59,     0,     0,   114,    60,     0,     0,
       0,     0,    61,     0,     0,    62,    63,    64,    65,    66,
      67,    68,    56,    57,    58,    59,     0,     0,   115,    60,
       0,     0,     0,     0,    61,     0,     0,    62,    63,    64,
      65,    66,    67,    68,    56,    57,    58,    59,     0,     0,
     116,    60,     0,     0,     0,     0,    61,     0,     0,    62,
      63,    64,    65,    66,    67,    68,     0,    56,    57,    58,
      59,     0,   117,     0,    60,     0,     0,     0,     0,    61,
       0,     0,    62,    63,    64,    65,    66,    67,    68,    56,
      57,    58,    59,     0,   118,   122,    60,     0,     0,     0,
       0,    61,     0,     0,    62,    63,    64,    65,    66,    67,
      68,     0,     0,     0,   124,    56,    57,    58,    59,     0,
       0,     0,    60,    69,     0,     0,     0,    61,     0,     0,
      62,    63,    64,    65,    66,    67,    68,     0,    56,    57,
      58,    59,     0,     0,     0,    60,     0,     0,     0,   127,
      61,     0,     0,    62,    63,    64,    65,    66,    67,    68,
      60,     0,     0,     0,     0,    61,     0,     0,    62,    63,
      64,    65,    66,    67,    68,    61,     0,     0,    62,    63,
      64,    65,    66,    67,    68,    62,    63,    64,    65,    66,
      67,    68,    63,    64,    65,    66,    67,    68
};

static const yytype_int16 yycheck[] =
{
      13,     0,    44,   128,    40,     4,     8,    43,    11,     4,
       4,   136,    51,    26,    27,    28,    60,    14,    15,    58,
      22,    34,    19,    59,    42,    67,    60,    24,    41,    11,
      27,    28,    29,    30,    31,    32,    33,    50,    51,    52,
      53,    54,    41,    56,    57,    58,    59,    41,    61,    62,
      63,    64,    65,    66,    67,    68,     3,     3,    71,     4,
       5,     6,     7,     8,     9,    10,    48,    49,     4,     4,
      39,    16,    12,    13,    14,    15,    21,    22,    51,    19,
      93,    63,    64,    56,    24,    48,    49,    27,    28,    29,
      30,    31,    32,    33,    61,    36,    41,    38,    62,   112,
      63,    64,    61,    67,    45,    50,    47,    52,    53,    54,
      55,    30,    31,    32,    33,    39,    61,     4,     5,     6,
       7,     8,     9,    10,    46,    62,     4,    67,    61,    16,
      67,   144,    61,   146,    21,    22,    61,   150,    61,     6,
       4,   154,     4,     5,     6,     7,     8,     9,    10,     4,
      61,    58,     6,     3,    16,    61,    65,     8,     3,    21,
      22,    62,    66,    50,    62,    52,    53,    54,    55,    15,
       4,    39,    43,    19,    61,    40,     4,    62,    24,     4,
      46,    27,    28,    29,    30,    31,    32,    33,    50,     4,
      52,    53,    54,    55,    12,    13,    14,    15,    57,    61,
      56,    19,     6,    61,    61,    57,    24,    93,     3,    27,
      28,    29,    30,    31,    32,    33,    12,    13,    14,    15,
      62,   126,   150,    19,   141,    -1,   153,    -1,    24,    -1,
      -1,    27,    28,    29,    30,    31,    32,    33,    12,    13,
      14,    15,    -1,    -1,    62,    19,    -1,    -1,    -1,    -1,
      24,    -1,    -1,    27,    28,    29,    30,    31,    32,    33,
      12,    13,    14,    15,    -1,    -1,    62,    19,    -1,    -1,
      -1,    -1,    24,    -1,    -1,    27,    28,    29,    30,    31,
      32,    33,    12,    13,    14,    15,    -1,    -1,    62,    19,
      -1,    -1,    -1,    -1,    24,    -1,    -1,    27,    28,    29,
      30,    31,    32,    33,    12,    13,    14,    15,    -1,    -1,
      62,    19,    -1,    -1,    -1,    -1,    24,    -1,    -1,    27,
      28,    29,    30,    31,    32,    33,    -1,    12,    13,    14,
      15,    -1,    62,    -1,    19,    -1,    -1,    -1,    -1,    24,
      -1,    -1,    27,    28,    29,    30,    31,    32,    33,    12,
      13,    14,    15,    -1,    62,    40,    19,    -1,    -1,    -1,
      -1,    24,    -1,    -1,    27,    28,    29,    30,    31,    32,
      33,    -1,    -1,    -1,    59,    12,    13,    14,    15,    -1,
      -1,    -1,    19,    46,    -1,    -1,    -1,    24,    -1,    -1,
      27,    28,    29,    30,    31,    32,    33,    -1,    12,    13,
      14,    15,    -1,    -1,    -1,    19,    -1,    -1,    -1,    46,
      24,    -1,    -1,    27,    28,    29,    30,    31,    32,    33,
      19,    -1,    -1,    -1,    -1,    24,    -1,    -1,    27,    28,
      29,    30,    31,    32,    33,    24,    -1,    -1,    27,    28,
      29,    30,    31,    32,    33,    27,    28,    29,    30,    31,
      32,    33,    28,    29,    30,    31,    32,    33
};

/* YYSTOS[STATE-NUM] -- The (internal number of the) accessing
   symbol of state STATE-NUM.  */
static const yytype_uint8 yystos[] =
{
       0,     4,    41,    69,    70,    71,    11,     4,     0,    70,
      60,    36,    38,    45,    47,    42,    60,     3,     4,     4,
       5,     6,     7,     8,     9,    10,    16,    21,    22,    50,
      52,    53,    54,    55,    61,    72,    74,     4,     3,    51,
      58,    39,    78,    48,    49,    63,    64,    72,    72,    72,
      61,    61,    61,    61,    61,    72,    12,    13,    14,    15,
      19,    24,    27,    28,    29,    30,    31,    32,    33,    46,
      44,    67,    39,    51,    56,    80,    61,    46,    72,     4,
       6,    72,    72,    72,    72,    72,    62,    72,    72,    72,
      72,     8,    22,    61,    72,    72,    72,    72,    72,    72,
      72,    72,     4,     4,    72,    72,    76,    77,    61,     6,
      58,     3,    61,    65,    62,    62,    62,    62,    62,     8,
       4,    71,    40,    43,    59,    73,    79,    46,    67,     3,
      62,    72,    75,    66,    62,     4,    39,    40,    73,     4,
      76,    62,    46,    62,    67,     4,    57,    76,     4,    80,
      61,    72,    61,    72,    57,    75,     6,    79,    72,    62,
      62
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
#line 145 "bison.y"
    { emit("STMT"); ;}
    break;

  case 5:

/* Line 1455 of yacc.c  */
#line 149 "bison.y"
    { emit_select((yyvsp[(1) - (7)].strval), (yyvsp[(6) - (7)].strval), (yyvsp[(7) - (7)].intval)); ;}
    break;

  case 6:

/* Line 1455 of yacc.c  */
#line 151 "bison.y"
    {  emit_load((yyvsp[(1) - (12)].strval), (yyvsp[(4) - (12)].strval), (yyvsp[(11) - (12)].intval), (yyvsp[(7) - (12)].strval)); ;}
    break;

  case 7:

/* Line 1455 of yacc.c  */
#line 153 "bison.y"
    {  emit_load_binary((yyvsp[(1) - (9)].strval), (yyvsp[(4) - (9)].strval), (yyvsp[(8) - (9)].intval)); ;}
    break;

  case 8:

/* Line 1455 of yacc.c  */
#line 155 "bison.y"
    {  emit_filter((yyvsp[(1) - (5)].strval), (yyvsp[(4) - (5)].strval), (yyvsp[(5) - (5)].intval));;}
    break;

  case 9:

/* Line 1455 of yacc.c  */
#line 157 "bison.y"
    {  emit_order((yyvsp[(1) - (6)].strval), (yyvsp[(4) - (6)].strval), (yyvsp[(6) - (6)].intval));;}
    break;

  case 10:

/* Line 1455 of yacc.c  */
#line 159 "bison.y"
    { emit_join((yyvsp[(1) - (8)].strval),(yyvsp[(6) - (8)].strval),(yyvsp[(7) - (8)].intval)); ;}
    break;

  case 11:

/* Line 1455 of yacc.c  */
#line 161 "bison.y"
    { emit_store((yyvsp[(2) - (9)].strval),(yyvsp[(4) - (9)].strval),(yyvsp[(7) - (9)].strval)); ;}
    break;

  case 12:

/* Line 1455 of yacc.c  */
#line 163 "bison.y"
    { emit_store_binary((yyvsp[(2) - (6)].strval),(yyvsp[(4) - (6)].strval)); ;}
    break;

  case 13:

/* Line 1455 of yacc.c  */
#line 167 "bison.y"
    { emit_name((yyvsp[(1) - (1)].strval)); ;}
    break;

  case 14:

/* Line 1455 of yacc.c  */
#line 168 "bison.y"
    { emit("FIELDNAME %s.%s", (yyvsp[(1) - (3)].strval), (yyvsp[(3) - (3)].strval)); ;}
    break;

  case 15:

/* Line 1455 of yacc.c  */
#line 169 "bison.y"
    { emit("USERVAR %s", (yyvsp[(1) - (1)].strval)); ;}
    break;

  case 16:

/* Line 1455 of yacc.c  */
#line 170 "bison.y"
    { emit_string((yyvsp[(1) - (1)].strval)); ;}
    break;

  case 17:

/* Line 1455 of yacc.c  */
#line 171 "bison.y"
    { emit_number((yyvsp[(1) - (1)].intval)); ;}
    break;

  case 18:

/* Line 1455 of yacc.c  */
#line 172 "bison.y"
    { emit_float((yyvsp[(1) - (1)].floatval)); ;}
    break;

  case 19:

/* Line 1455 of yacc.c  */
#line 173 "bison.y"
    { emit_decimal((yyvsp[(1) - (1)].intval)); ;}
    break;

  case 20:

/* Line 1455 of yacc.c  */
#line 174 "bison.y"
    { emit("BOOL %d", (yyvsp[(1) - (1)].intval)); ;}
    break;

  case 21:

/* Line 1455 of yacc.c  */
#line 175 "bison.y"
    { emit_varchar((yyvsp[(1) - (9)].strval), (yyvsp[(3) - (9)].intval), (yyvsp[(6) - (9)].strval), (yyvsp[(8) - (9)].intval));;}
    break;

  case 22:

/* Line 1455 of yacc.c  */
#line 176 "bison.y"
    { emit_var((yyvsp[(1) - (6)].strval), (yyvsp[(3) - (6)].intval), (yyvsp[(6) - (6)].strval));;}
    break;

  case 23:

/* Line 1455 of yacc.c  */
#line 177 "bison.y"
    { emit_var_asc((yyvsp[(1) - (2)].strval));;}
    break;

  case 24:

/* Line 1455 of yacc.c  */
#line 178 "bison.y"
    { emit_var_desc((yyvsp[(1) - (2)].strval));;}
    break;

  case 25:

/* Line 1455 of yacc.c  */
#line 179 "bison.y"
    { emit_count(); ;}
    break;

  case 26:

/* Line 1455 of yacc.c  */
#line 180 "bison.y"
    { emit_sum(); ;}
    break;

  case 27:

/* Line 1455 of yacc.c  */
#line 181 "bison.y"
    { emit_average(); ;}
    break;

  case 28:

/* Line 1455 of yacc.c  */
#line 182 "bison.y"
    { emit_min(); ;}
    break;

  case 29:

/* Line 1455 of yacc.c  */
#line 183 "bison.y"
    { emit_max(); ;}
    break;

  case 30:

/* Line 1455 of yacc.c  */
#line 184 "bison.y"
    { emit_distinct(); ;}
    break;

  case 31:

/* Line 1455 of yacc.c  */
#line 188 "bison.y"
    { emit_add(); ;}
    break;

  case 32:

/* Line 1455 of yacc.c  */
#line 189 "bison.y"
    { emit_minus(); ;}
    break;

  case 33:

/* Line 1455 of yacc.c  */
#line 190 "bison.y"
    { emit_mul(); ;}
    break;

  case 34:

/* Line 1455 of yacc.c  */
#line 191 "bison.y"
    { emit_div(); ;}
    break;

  case 35:

/* Line 1455 of yacc.c  */
#line 192 "bison.y"
    { emit("MOD"); ;}
    break;

  case 36:

/* Line 1455 of yacc.c  */
#line 193 "bison.y"
    { emit("MOD"); ;}
    break;

  case 37:

/* Line 1455 of yacc.c  */
#line 195 "bison.y"
    { emit_and(); ;}
    break;

  case 38:

/* Line 1455 of yacc.c  */
#line 196 "bison.y"
    { emit_eq(); ;}
    break;

  case 39:

/* Line 1455 of yacc.c  */
#line 197 "bison.y"
    { emit_or(); ;}
    break;

  case 40:

/* Line 1455 of yacc.c  */
#line 198 "bison.y"
    { emit("XOR"); ;}
    break;

  case 41:

/* Line 1455 of yacc.c  */
#line 199 "bison.y"
    { emit("SHIFT %s", (yyvsp[(2) - (3)].subtok)==1?"left":"right"); ;}
    break;

  case 42:

/* Line 1455 of yacc.c  */
#line 200 "bison.y"
    { emit("NOT"); ;}
    break;

  case 43:

/* Line 1455 of yacc.c  */
#line 201 "bison.y"
    { emit("NOT"); ;}
    break;

  case 44:

/* Line 1455 of yacc.c  */
#line 202 "bison.y"
    { emit_cmp((yyvsp[(2) - (3)].subtok)); ;}
    break;

  case 45:

/* Line 1455 of yacc.c  */
#line 204 "bison.y"
    { emit("CMPSELECT %d", (yyvsp[(2) - (5)].subtok)); ;}
    break;

  case 46:

/* Line 1455 of yacc.c  */
#line 205 "bison.y"
    {emit("EXPR");;}
    break;

  case 47:

/* Line 1455 of yacc.c  */
#line 209 "bison.y"
    { emit("ISBOOL %d", (yyvsp[(3) - (3)].intval)); ;}
    break;

  case 48:

/* Line 1455 of yacc.c  */
#line 210 "bison.y"
    { emit("ISBOOL %d", (yyvsp[(4) - (4)].intval)); emit("NOT"); ;}
    break;

  case 49:

/* Line 1455 of yacc.c  */
#line 213 "bison.y"
    { /* nil */
    (yyval.intval) = 0;
;}
    break;

  case 50:

/* Line 1455 of yacc.c  */
#line 216 "bison.y"
    { (yyval.intval) = (yyvsp[(3) - (3)].intval);}
    break;

  case 51:

/* Line 1455 of yacc.c  */
#line 220 "bison.y"
    { (yyval.intval) = 1; emit_sel_name((yyvsp[(3) - (3)].strval));;}
    break;

  case 52:

/* Line 1455 of yacc.c  */
#line 221 "bison.y"
    { (yyval.intval) = (yyvsp[(1) - (5)].intval) + 1; emit_sel_name((yyvsp[(5) - (5)].strval));;}
    break;

  case 53:

/* Line 1455 of yacc.c  */
#line 225 "bison.y"
    { (yyval.intval) = 1; ;}
    break;

  case 54:

/* Line 1455 of yacc.c  */
#line 226 "bison.y"
    {(yyval.intval) = (yyvsp[(1) - (3)].intval) + 1; ;}
    break;

  case 55:

/* Line 1455 of yacc.c  */
#line 230 "bison.y"
    { (yyval.intval) = 1; ;}
    break;

  case 56:

/* Line 1455 of yacc.c  */
#line 231 "bison.y"
    { (yyval.intval) = 1 + (yyvsp[(3) - (3)].intval); ;}
    break;

  case 57:

/* Line 1455 of yacc.c  */
#line 234 "bison.y"
    { /* nil */
    (yyval.intval) = 0
;}
    break;

  case 59:

/* Line 1455 of yacc.c  */
#line 239 "bison.y"
    { emit("FILTER BY"); ;}
    break;

  case 60:

/* Line 1455 of yacc.c  */
#line 242 "bison.y"
    { (yyval.intval) = 1; emit_join_tab((yyvsp[(2) - (4)].strval), 0);;}
    break;

  case 61:

/* Line 1455 of yacc.c  */
#line 243 "bison.y"
    { (yyval.intval) = 1; emit_join_tab((yyvsp[(3) - (5)].strval), 1);;}
    break;

  case 62:

/* Line 1455 of yacc.c  */
#line 244 "bison.y"
    { (yyval.intval) = 1; emit_join_tab((yyvsp[(2) - (5)].strval), 0); ;}
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
#line 2045 "bison.cu"
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


#include "filter.h"
#include "select.h"
#include "merge.h"
#include "zone_map.h"
#include "atof.h"
#include "sorts.cu"
#include "cudpp_src_2.0/include/cudpp_hash.h"


#include "sstream"
string to_string1(long long int i) {
	stringstream res;
	res << i;
	return res.str();
}



size_t int_size = sizeof(int_type);
size_t float_size = sizeof(float_type);

FILE *file_pointer;
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
queue<string> op_join;
bool left_join;

unsigned int statement_count = 0;
map<string,unsigned int> stat;
map<unsigned int, unsigned int> join_and_cnt;
bool scan_state = 0;
string separator, f_file;
unsigned int int_col_count;
CUDPPHandle theCudpp;

void emit_multijoin(string s, string j1, string j2, unsigned int tab, char* res_name);

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
    join_col_cnt++;
	if(join_and_cnt.count(join_tab_cnt) == 0)
	    join_and_cnt[join_tab_cnt] = 1;
	else	
		join_and_cnt[join_tab_cnt] = join_and_cnt[join_tab_cnt] + 1;
}

void emit_eq()
{
    op_type.push("JOIN");
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

void emit_join_tab(char *s, bool left)
{
    op_join.push(s);
	join_tab_cnt++;
    left_join = left;
};




void order_inplace(CudaSet* a, stack<string> exe_type, set<string> field_names, unsigned int segment)
{
    //std::clock_t start1 = std::clock();
    unsigned int sz = a->mRecCount;
    thrust::device_ptr<unsigned int> permutation = thrust::device_malloc<unsigned int>(sz);
    thrust::sequence(permutation, permutation+sz,0,1);

    unsigned int* raw_ptr = thrust::raw_pointer_cast(permutation);
    void* temp;
    // find the largest mRecSize of all data sources exe_type.top()
    unsigned int maxSize = 0;
    for (set<string>::iterator it=field_names.begin(); it!=field_names.end(); ++it) {
        CudaSet *t = varNames[setMap[*it]];
        if(t->mRecCount > maxSize)
            maxSize = t->mRecCount;
    };


    unsigned int max_c = max_char(a, field_names);
	//cout << "max_c " << max_c << " " << maxSize << endl;

    if(max_c > float_size)
        CUDA_SAFE_CALL(cudaMalloc((void **) &temp, maxSize*max_c));
    else
        CUDA_SAFE_CALL(cudaMalloc((void **) &temp, maxSize*float_size));

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
	queue<string> op_j(op_join);
	CudaSet* fact_table;
	
    for(unsigned int i=0; i < sel_count; i++) {        
        op_vals.pop();
        op_vals.pop();
    };
	
    if(join_tab_cnt > 1) {
	    fact_table = varNames[j1];
		
		while(op_vals.size()) {
			if (fact_table->columnNames.find(op_vals.front()) != fact_table->columnNames.end()) {
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

/*hopefully will get a good performance on a gpu */
void star_join(char *s, string j1)
{
   //need to copy to gpu all dimension keys, sort the dimension tables and
   //build an array of hash tables for the dimension tables
    CUDPPResult result;
	map<string,bool> already_copied;
   
    //cout << j1 << endl;
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

		cout << "PROCESSING " << f2 <<   endl;
		
        unsigned int rcount;
        curr_segment = 10000000;
        queue<string> op_vd(op_g);
        queue<string> op_alt(op_sel);
        unsigned int jc = join_col_cnt;
        while(jc) {
            jc--;
            op_vd.pop();
            op_alt.push(op_vd.front());
            op_vd.pop();
        };
		
		//cout << "right is " << op_jj.front() << endl;
		tab_map[op_jj.front()] = i;
		var_map[op_jj.front()] = f1;

		CudaSet* right = varNames.find(op_jj.front())->second;
		colInd2 = right->columnNames[f2];
		
        unsigned int cnt_r = load_queue(op_alt, right, str_join, f2, rcount); // put all used columns into GPU
		
		bool sorted = thrust::is_sorted(right->d_columns_int[right->type_index[colInd2]].begin(), right->d_columns_int[right->type_index[colInd2]].begin() + cnt_r);


		if(!sorted) {

			queue<string> ss(op_sel);
			thrust::device_vector<unsigned int> v(cnt_r);
			thrust::sequence(v.begin(),v.end(),0,1);

			unsigned int max_c	= max_char(right);
			unsigned int mm;
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
		//cout << "creating table with " << cnt_r << " " << getFreeMem()  << endl;
		result = cudppHashTable(theCudpp, &hash_table_handle[i], &config);

		if (result == CUDPP_SUCCESS)
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

		if (result == CUDPP_SUCCESS)
			cout << "hash table inserted " << getFreeMem() << endl;		
	
	};
	
	thrust::device_ptr<unsigned int> d_r = thrust::device_malloc<unsigned int>(tt);
	thrust::device_vector<unsigned int> d_s(tt);
	
	thrust::device_ptr<uint2> res = thrust::device_malloc<uint2>(left->maxRecs);
	
    thrust::device_vector<unsigned int> d_res1;
    thrust::device_vector<unsigned int> d_res2;
	
	thrust::device_vector<bool> d_star(left->maxRecs);
		
    unsigned int cnt_l, res_count, tot_count = 0, offset = 0, k = 0;
	string ttt;
	queue<string> lc;
		
	
    for (unsigned int i = 0; i < left->segCount; i++) {
	//for (unsigned int i = 0; i < 100; i++) {

        cout << "segment " << i << " " << getFreeMem() << endl;		        
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
		
			if(left->prm.empty()) {
				cnt_l = left->mRecCount;
			}
			else {
				cnt_l = left->prm_count[i];
			};
			

            queue<string> op_jj(op_join);	
		    for(unsigned int j = 0; j < (join_tab_cnt-1) - z; j++) {
				op_jj.pop();
			};	
			
				
			unsigned int idx;	
			if (cnt_l) {								
				
				idx = left->type_index[left->columnNames[lc.front()]];	
				//cout << "left idx " << idx << endl;
				//cout << "right col " << op_jj.front() << endl;
                CudaSet* right = varNames.find(op_jj.front())->second;				
				colInd2 = right->columnNames[f2];

				thrust::copy(left->d_columns_int[idx].begin(), left->d_columns_int[idx].begin() + cnt_l, d_r);

                result = cudppHashRetrieve(hash_table_handle[z], thrust::raw_pointer_cast(d_r),
										   thrust::raw_pointer_cast(res), cnt_l);
				if (result != CUDPP_SUCCESS)
					cout << "Failed retrieve " << endl;

				uint2 rr = thrust::reduce(res, res+cnt_l, make_uint2(0,0), Uint2Sum());
			
	    
				res_count = rr.y;
				d_res1.resize(res_count);
				d_res2.resize(res_count);
				cout << "res cnt of " << f2 << " = " << res_count << endl;

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
		cout << "Star join result count " << n_cnt << endl;
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
					//cout << "gathering left " << op_sel1.front() << endl;  
						
					if(already_copied.count(op_sel1.front()) == 0) {	
						reset_offsets();
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
				
				    //cout << "gathering right " << op_sel1.front() << endl;  
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
					//cout << "leftcolind " << colInd << endl;
					
					CudaSet* right = varNames[right_tab_name];				
					unsigned int r_colInd = right->columnNames[op_sel1.front()];
					
					//cout << "rcolind " << r_colInd << endl;
					
	                while(!cc.empty())
						cc.pop();
                    cc.push(var_map[right_tab_name]);
					
					if(c->columnNames.find(op_sel1.front()) != c->columnNames.end()) {
						c_colInd = c->columnNames[op_sel1.front()];						
					};	
					
					if(already_copied.count(var_map[right_tab_name]) == 0) {
						reset_offsets();
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
					if (result != CUDPP_SUCCESS)
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
					//cout << "right gathered " << endl;
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
	cout << "join count " << tot_count << endl;
    for ( map<string,int>::iterator it=c->columnNames.begin() ; it != c->columnNames.end(); ++it ) {
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
      
    if(check_star_join(j1)) {	   
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
					tab_name = s + to_string1((long long int)i);
			  
				string j, j2;	  
				if(i == 1) {	  		      
					j2 = op_join.front();
					op_join.pop();
					j = op_join.front();
					op_join.pop();
				}
				else {
					if(!op_join.empty())
						j = op_join.front();	
					else
						j = j1;			  
					op_join.pop();
					j2 = s + to_string1((long long int)i-1);
				};
				emit_multijoin(tab_name, j, j2, i, s);
				op_value = op_m;
			};	
		}
		else {
			string j2 = op_join.front();	
			op_join.pop();
			emit_multijoin(s, j1, j2, 0, s);
		}; 
    };		
	
    clean_queues();
   
    if(stat[s] == statement_count) {
        varNames[s]->free();
        varNames.erase(s);
    };

    if(stat[j1] == statement_count) {
        varNames[j1]->free();
        varNames.erase(j1);
    };

    if(stat[op_join.front()] == statement_count && op_join.front().compare(j1) != 0) {
        varNames[op_join.front()]->free();
        varNames.erase(op_join.front());
    };
   
}


void emit_multijoin(string s, string j1, string j2, unsigned int tab, char* res_name)
{
	
	//cout << "j2 " << j2 << endl;
	//cout << "j1 " << j1 << endl;
    

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
	
	
	
	//cout << "left right " << left->name << " " << right->name <<  endl;
	//cout << "selcount " <<  sel_count << endl;

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
	
	
	//cout << "join_col_cnt " << join_col_cnt << endl;			 
	if(tab) {
	
	    unsigned int mul_count = 0;
		unsigned int sm = 0;
	    if(join_and_cnt.size()) {
			
			for(int z = 0; z < join_and_cnt.size() - (tab-1); z++) {
				mul_count = mul_count + join_and_cnt[z];
			};	
			
			//cout << "mul count " << mul_count << endl;	
		
			//cout << "join_and_cnt size " << join_and_cnt.size() << endl;
			for(int z = 0; z < join_and_cnt.size(); z++)
				sm = sm + join_and_cnt[z];
		
			//cout << "sm count " << sm << endl;		
            //cout << "SZ " << join_and_cnt.size() << endl;			
		
		    if (join_and_cnt.count(join_tab_cnt - tab))
			    join_col_cnt = join_and_cnt[join_tab_cnt - tab];
			else 
               join_col_cnt = 0;			
		
			//cout << "join_col_cnt " << join_col_cnt << endl;						
		};
	
	    while(op_g.size() != (tab*2 + (sm - mul_count)*2) ) {
		    if(tab != join_tab_cnt) {
				op_sel_s.push(op_g.front());
				op_sel_s_as.push(op_g.front());			
			};	
		    op_g.pop();	
		};	
	};
	

    string f1 = op_g.front();
    op_g.pop();
    string f2 = op_g.front();
    op_g.pop();

    cout << "JOIN " << s <<  " " <<  f1 << " " << f2 <<  endl;

    std::clock_t start1 = std::clock();
	//cout << "creating c with " << op_sel.size() << endl;
	if(tab != join_tab_cnt) {
	//	op_sel_s.push(f1);
	//	op_sel_s.push(f2);
	//	op_sel_s_as.push(f1);
	//	op_sel_s_as.push(f2);
	};	
	
		
    CudaSet* c = new CudaSet(right, left, op_sel_s, op_sel_s_as);

    if (left->mRecCount == 0 || right->mRecCount == 0) {
        c = new CudaSet(left, right, op_sel_s, op_sel_s_as);
        varNames[res_name] = c;
        clean_queues();
        cout << "Join result " << res_name << " : " << c->mRecCount << endl; 		
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

    bool str_join = 0;
    //if join is on strings then add integer columns to left and right tables and modify colInd1 and colInd2

    if (right->type[colInd2]  == 2) {
        str_join = 1;
        right->d_columns_int.push_back(thrust::device_vector<int_type>());
        for(unsigned int i = 0; i < right->segCount; i++) {
            right->add_hashed_strings(f2, i, right->d_columns_int.size()-1);
        };
    };

    // need to allocate all right columns
    queue<string> cc;
    unsigned int rcount;
    curr_segment = 10000000;


    queue<string> op_vd(op_g);
    queue<string> op_alt(op_sel);
    unsigned int jc = join_col_cnt;
    while(jc) {
        jc--;
        op_vd.pop();
        op_alt.push(op_vd.front());
        op_vd.pop();
    };
    unsigned int cnt_r = load_queue(op_alt, right, str_join, f2, rcount);

    if(str_join) {
        colInd2 = right->mColumnCount+1;
        right->type_index[colInd2] = right->d_columns_int.size()-1;
    };


    //here we need to make sure that right column is ordered. If not then we order it and keep the permutation
    bool sorted;
    if(!decimal_join)
        sorted = thrust::is_sorted(right->d_columns_int[right->type_index[colInd2]].begin(), right->d_columns_int[right->type_index[colInd2]].begin() + cnt_r);
    else
        sorted = thrust::is_sorted(right->d_columns_float[right->type_index[colInd2]].begin(), right->d_columns_float[right->type_index[colInd2]].begin() + cnt_r);


    if(!sorted) {

        queue<string> ss(op_sel);
        //thrust::device_vector<unsigned int> v(cnt_r);
		thrust::device_ptr<unsigned int> v = thrust::device_malloc<unsigned int>(cnt_r);
        thrust::sequence(v, v + cnt_r, 0, 1);

        unsigned int max_c	= max_char(right);
        unsigned int mm;
        if(max_c > 8)
            mm = (max_c/8) + 1;
        else
            mm = 1;

        thrust::device_ptr<int_type> d_tmp = thrust::device_malloc<int_type>(cnt_r*mm);
        thrust::sort_by_key(right->d_columns_int[right->type_index[colInd2]].begin(), right->d_columns_int[right->type_index[colInd2]].begin() + cnt_r, v);

        unsigned int i;
        while(!ss.empty()) {
            if (right->columnNames.find(ss.front()) != right->columnNames.end()) {
                i = right->columnNames[ss.front()];

                if(i != colInd2) {
                    if(right->type[i] == 0) {
                        thrust::gather(v, v+cnt_r, right->d_columns_int[right->type_index[i]].begin(), d_tmp);
                        thrust::copy(d_tmp, d_tmp + cnt_r, right->d_columns_int[right->type_index[i]].begin());
                    }
                    else if(right->type[i] == 1) {
                        thrust::gather(v, v+cnt_r, right->d_columns_float[right->type_index[i]].begin(), d_tmp);
                        thrust::copy(d_tmp, d_tmp + cnt_r, right->d_columns_float[right->type_index[i]].begin());
                    }
                    else {
                        str_gather(thrust::raw_pointer_cast(v), cnt_r, (void*)right->d_columns_char[right->type_index[i]], (void*) thrust::raw_pointer_cast(d_tmp), right->char_size[right->type_index[i]]);
                        cudaMemcpy( (void*)right->d_columns_char[right->type_index[i]], (void*) thrust::raw_pointer_cast(d_tmp), cnt_r*right->char_size[right->type_index[i]], cudaMemcpyDeviceToDevice);
                    };
                };
            };
            ss.pop();
        };
        thrust::device_free(d_tmp);
		thrust::device_free(v);
    };

    bool v64bit;
    if(right->d_columns_int[right->type_index[colInd2]][cnt_r-1] > std::numeric_limits<unsigned int>::max())
        v64bit = 1;
    else
        v64bit = 0;


    while(!cc.empty())
        cc.pop();

    if (left->type[colInd1]  == 2) {
        left->d_columns_int.push_back(thrust::device_vector<int_type>());
        //colInd1 = left->mColumnCount+1;
        //left->type_index[colInd1] = left->d_columns_int.size()-1;
    }
    else {
        cc.push(f1);
        allocColumns(left, cc);
    };
	left->oldRecCount = left->mRecCount;

    thrust::device_vector<unsigned int> d_res1;
    thrust::device_vector<unsigned int> d_res2;
    unsigned int cnt_l, res_count, tot_count = 0, offset = 0, k = 0;

    queue<string> lc(cc);
    curr_segment = 10000000;
    CUDPPResult result;

    CUDPPHandle hash_table_handle;
    CUDPPHashTableConfig config;
    config.type = CUDPP_MULTIVALUE_HASH_TABLE;
    config.kInputSize = cnt_r;
    config.space_usage = 1.1f;

    cout << "creating table with " << cnt_r << " " << getFreeMem()  << endl;
    result = cudppHashTable(theCudpp, &hash_table_handle, &config);

    if (result == CUDPP_SUCCESS)
        cout << "hash tables created " << getFreeMem() << endl;

    unsigned int tt;
    if(left->maxRecs > rcount)
        tt = left->maxRecs;
    else
        tt = rcount;
		
	//cout << "tt	" << tt << endl;

    thrust::device_ptr<unsigned int> d_r = thrust::device_malloc<unsigned int>(tt);
	//cout << "d_r " << getFreeMem() << endl;
	thrust::device_ptr<unsigned int> v = thrust::device_malloc<unsigned int>(cnt_r);
	//cout << "v " << getFreeMem() << endl;
    //thrust::device_vector<unsigned int> v(cnt_r);
    thrust::sequence(v, v+cnt_r, 0, 1);
		
    thrust::copy(right->d_columns_int[right->type_index[colInd2]].begin(), right->d_columns_int[right->type_index[colInd2]].begin() + cnt_r,
                 d_r);
	//cout << "1 " << getFreeMem() << endl;			 
				 
    result = cudppHashInsert(hash_table_handle, thrust::raw_pointer_cast(d_r),
                             thrust::raw_pointer_cast(v), cnt_r);
	//cout << "2 " << getFreeMem() << endl;						 
							 
	thrust::device_free(v);						 

    if (result == CUDPP_SUCCESS)
        cout << "hash table inserted " << getFreeMem() << endl;

    thrust::device_ptr<uint2> res = thrust::device_malloc<uint2>(left->maxRecs);
	
    for (unsigned int i = 0; i < left->segCount; i++) {

        cout << "segment " << i << " " << getFreeMem() << endl;
        cnt_l = 0;

		
        if (left->type[colInd1]  != 2) {
            copyColumns(left, lc, i, cnt_l);	
        }
        else {
		    left->d_columns_int.resize(0);
            left->add_hashed_strings(f1, i, left->d_columns_int.size());
        };
		
	    if(left->prm.empty()) {
            //copy all records
            cnt_l = left->mRecCount;
        }
        else {
            cnt_l = left->prm_count[i];
        };
		
				
        if (cnt_l) {

            unsigned int idx;
            if(!str_join)
                idx = left->type_index[colInd1];
            else
                idx = left->d_columns_int.size()-1;

            unsigned int left_sz;
            if(decimal_join) {
                thrust::transform(left->d_columns_float[idx].begin(), left->d_columns_float[idx].begin() + cnt_l,
                                  d_r, float_to_int_lower());
            }
            else {
                thrust::copy(left->d_columns_int[idx].begin(), left->d_columns_int[idx].begin() + cnt_l,
                             d_r);
            };


            result = cudppHashRetrieve(hash_table_handle, thrust::raw_pointer_cast(d_r),
                                       thrust::raw_pointer_cast(res), cnt_l);
            if (result != CUDPP_SUCCESS)
                cout << "Failed retrieve " << endl;

	        uint2 rr = thrust::reduce(res, res+cnt_l, make_uint2(0,0), Uint2Sum());
			
	    
            res_count = rr.y;
            d_res1.resize(res_count);
            d_res2.resize(res_count);
			cout << "res cnt " << res_count << endl;

            if(res_count) {
                thrust::counting_iterator<unsigned int> begin(0);
                uint2_split ff(thrust::raw_pointer_cast(res),thrust::raw_pointer_cast(d_r));
                thrust::for_each(begin, begin + cnt_l, ff);

                thrust::exclusive_scan(d_r, d_r+cnt_l, d_r );  // addresses
                join_functor1 ff1(thrust::raw_pointer_cast(res),
                                  thrust::raw_pointer_cast(d_r),
                                  thrust::raw_pointer_cast(d_res1.data()),
                                  thrust::raw_pointer_cast(d_res2.data()));
                thrust::for_each(begin, begin + cnt_l, ff1);
				if(v64bit) {// need to check the upper 32 bits
				    thrust::device_ptr<bool> d_add = thrust::device_malloc<bool>(d_res1.size());
					if(decimal_join) {
					    thrust::permutation_iterator<ElementIterator_float,IndexIterator> iter_left(left->d_columns_float[idx].begin(), d_res1.begin());
						thrust::permutation_iterator<ElementIterator_float,IndexIterator> iter_right(right->d_columns_float[right->type_index[colInd2]].begin(), d_res2.begin());						
						thrust::transform(iter_left, iter_left+d_res2.size(), iter_right, d_add, float_upper_equal_to());						
					}
					else {
					    thrust::permutation_iterator<ElementIterator_int,IndexIterator> iter_left(left->d_columns_int[idx].begin(), d_res1.begin());
						thrust::permutation_iterator<ElementIterator_int,IndexIterator> iter_right(right->d_columns_int[right->type_index[colInd2]].begin(), d_res2.begin());						
						thrust::transform(iter_left, iter_left+d_res2.size(), iter_right, d_add, int_upper_equal_to());
					};	
                    unsigned int new_cnt = thrust::count(d_add, d_add+d_res1.size(), 1);
                    thrust::stable_partition(d_res1.begin(), d_res1.begin() + d_res2.size(), d_add, thrust::identity<unsigned int>());
                    thrust::stable_partition(d_res2.begin(), d_res2.end(), d_add, thrust::identity<unsigned int>());

                    thrust::device_free(d_add);
                    d_res2.resize(new_cnt);
                    d_res1.resize(new_cnt);
					
				};

            };
			
	
            // check if the join is a multicolumn join
            while(join_col_cnt) {			
			    		    
                join_col_cnt--;
                string f3 = op_g.front();
                op_g.pop();
                string f4 = op_g.front();
                op_g.pop();
				
				//cout << "ADDITIONAL COL JOIN " << f3 << " " << f4 << endl;

                queue<string> rc;
                rc.push(f3);

                allocColumns(left, rc);
                copyColumns(left, rc, i, cnt_l);
                rc.pop();				
				
                if (d_res1.size() && d_res2.size()) {
                    unsigned int colInd3 = (left->columnNames).find(f3)->second;
                    unsigned int colInd4 = (right->columnNames).find(f4)->second;    
					thrust::device_ptr<bool> d_add = thrust::device_malloc<bool>(d_res1.size());
					
                    if (left->type[colInd3] == 1 && right->type[colInd4]  == 1) {

                        if(right->d_columns_float[right->type_index[colInd4]].size() == 0)
                            unsigned int cnt_r = load_queue(rc, right, 0, f4, rcount);

                        thrust::device_ptr<int_type> d_l = thrust::device_malloc<int_type>(d_res1.size());
                        thrust::permutation_iterator<ElementIterator_float,IndexIterator> iter_left(left->d_columns_float[left->type_index[colInd3]].begin(), d_res1.begin());
                        thrust::transform(iter_left, iter_left+d_res1.size(), d_l, float_to_long());

                        thrust::device_ptr<int_type> d_r1 = thrust::device_malloc<int_type>(d_res1.size());
                        thrust::permutation_iterator<ElementIterator_float,IndexIterator> iter_right(right->d_columns_float[right->type_index[colInd4]].begin(), d_res2.begin());
                        thrust::transform(iter_right, iter_right+d_res2.size(), d_r1, float_to_long());
                        thrust::transform(d_l, d_l+d_res1.size(), d_r1, d_add, thrust::equal_to<int_type>());
						thrust::device_free(d_l);
						thrust::device_free(d_r1);
                    }
                    else {
                        thrust::permutation_iterator<ElementIterator_int,IndexIterator> iter_left(left->d_columns_int[left->type_index[colInd3]].begin(), d_res1.begin());
                        thrust::permutation_iterator<ElementIterator_int,IndexIterator> iter_right(right->d_columns_int[right->type_index[colInd4]].begin(), d_res2.begin());
                        thrust::transform(iter_left, iter_left+d_res1.size(), iter_right, d_add, thrust::equal_to<int_type>());
                    };

                    unsigned int new_cnt = thrust::count(d_add, d_add+d_res1.size(), 1);
					
                    thrust::stable_partition(d_res1.begin(), d_res1.begin() + d_res2.size(), d_add, thrust::identity<unsigned int>());
                    thrust::stable_partition(d_res2.begin(), d_res2.end(), d_add, thrust::identity<unsigned int>());
					

                    d_res2.resize(new_cnt);
                    thrust::device_free(d_add);
                    if(!left_join) {
                        d_res1.resize(new_cnt);
                    }
                    else {
                        left_sz = d_res1.size() - d_res2.size();
                    };
                };
            };

            res_count = d_res1.size();
            tot_count = tot_count + res_count;

            if(res_count) {
			
                offset = c->mRecCount;
                if(i == 0 && left->segCount != 1) {
                    c->reserve(res_count*(left->segCount+1));
					//cout << "prealloced " << left->segCount+1 << endl;
				};	
                c->resize_join(res_count);
                queue<string> op_sel1(op_sel_s);
                unsigned int colInd, c_colInd;
                if(left->segCount == 1) {
                    thrust::device_free(d_r);
                    thrust::device_free(res);
                };

                while(!op_sel1.empty()) {
				
				  
                    while(!cc.empty())
                        cc.pop();

                    cc.push(op_sel1.front());
					if(c->columnNames.find(op_sel1.front()) != c->columnNames.end()) {
                        c_colInd = c->columnNames[op_sel1.front()];						
					};	

					if(left->columnNames.find(op_sel1.front()) !=  left->columnNames.end()) {
                        // copy field's segment to device, gather it and copy to the host
                        unsigned int colInd = left->columnNames[op_sel1.front()];						
                    
                        reset_offsets();					
                        allocColumns(left, cc);
                        copyColumns(left, cc, i, k);

                        //gather
                        if(left->type[colInd] == 0) {
                            thrust::permutation_iterator<ElementIterator_int,IndexIterator> iter(left->d_columns_int[left->type_index[colInd]].begin(), d_res1.begin());
                            thrust::copy(iter, iter + res_count, c->h_columns_int[c->type_index[c_colInd]].begin() + offset);
                        }
                        else if(left->type[colInd] == 1) {
                            thrust::permutation_iterator<ElementIterator_float,IndexIterator> iter(left->d_columns_float[left->type_index[colInd]].begin(), d_res1.begin());
                            thrust::copy(iter, iter + res_count, c->h_columns_float[c->type_index[c_colInd]].begin() + offset);
                        }
                        else { //strings
                            thrust::device_ptr<char> d_tmp = thrust::device_malloc<char>(res_count*left->char_size[left->type_index[colInd]]);
							
                            str_gather(thrust::raw_pointer_cast(d_res1.data()), res_count, (void*)left->d_columns_char[left->type_index[colInd]],
                                       (void*) thrust::raw_pointer_cast(d_tmp), left->char_size[left->type_index[colInd]]);
													
                            cudaMemcpy( (void*)&c->h_columns_char[c->type_index[c_colInd]][offset*c->char_size[c->type_index[c_colInd]]], (void*) thrust::raw_pointer_cast(d_tmp),
                                        c->char_size[c->type_index[c_colInd]] * res_count, cudaMemcpyDeviceToHost);

                            thrust::device_free(d_tmp);
                        }
                        left->deAllocColumnOnDevice(colInd);

                    }
                    else if(right->columnNames.find(op_sel1.front()) !=  right->columnNames.end()) {
                        colInd = right->columnNames[op_sel1.front()];

                        //gather
                        if(right->type[colInd] == 0) {
                            thrust::permutation_iterator<ElementIterator_int,IndexIterator> iter(right->d_columns_int[right->type_index[colInd]].begin(), d_res2.begin());
                            thrust::copy(iter, iter + d_res2.size(), c->h_columns_int[c->type_index[c_colInd]].begin() + offset);
                            if(left_join && left_sz) {
                                thrust::fill(c->h_columns_int[c->type_index[c_colInd]].begin() + offset + d_res2.size(),
                                             c->h_columns_int[c->type_index[c_colInd]].begin() + offset + d_res2.size() + left_sz,
                                             0);
                            };
                        }
                        else if(right->type[colInd] == 1) {
                            thrust::permutation_iterator<ElementIterator_float,IndexIterator> iter(right->d_columns_float[right->type_index[colInd]].begin(), d_res2.begin());
                            thrust::copy(iter, iter + d_res2.size(), c->h_columns_float[c->type_index[c_colInd]].begin() + offset);
                            if(left_join && left_sz) {
                                thrust::fill(c->h_columns_float[c->type_index[c_colInd]].begin() + offset + d_res2.size(),
                                             c->h_columns_float[c->type_index[c_colInd]].begin() + offset + d_res2.size() + left_sz,
                                             0);
                            };
                        }
                        else { //strings
                            thrust::device_ptr<char> d_tmp = thrust::device_malloc<char>(d_res2.size()*right->char_size[right->type_index[colInd]]);
													
                            str_gather(thrust::raw_pointer_cast(d_res2.data()), d_res2.size(), (void*)right->d_columns_char[right->type_index[colInd]],
                                       (void*) thrust::raw_pointer_cast(d_tmp), right->char_size[right->type_index[colInd]]);
																   
                            cudaMemcpy( (void*)(c->h_columns_char[c->type_index[c_colInd]] + offset*c->char_size[c->type_index[c_colInd]]), (void*) thrust::raw_pointer_cast(d_tmp),
                                        c->char_size[c->type_index[c_colInd]] * d_res2.size(), cudaMemcpyDeviceToHost);
										
                            if(left_join && left_sz) {
                                memset((void*)(c->h_columns_char[c->type_index[c_colInd]] + (d_res2.size() + offset)*c->char_size[c->type_index[c_colInd]]), 0,
                                       left_sz*c->char_size[c->type_index[c_colInd]]);
                            };
                            thrust::device_free(d_tmp);
                        }
                    }
                    else {
                        //cout << "Couldn't find field " << op_sel1.front() << endl;
                        //exit(0);
                    };
                    op_sel1.pop();
                };
            };			
        };
    };

    d_res1.resize(0);
    d_res1.shrink_to_fit();
    d_res2.resize(0);
    d_res2.shrink_to_fit();
	
    if(left->segCount != 1) {
		thrust::device_free(d_r);
		thrust::device_free(res);
    };

    left->deAllocOnDevice();
    right->deAllocOnDevice();
    c->deAllocOnDevice();
    cudppDestroyHashTable(theCudpp, hash_table_handle);

    unsigned int i = 0;	
    while(!col_aliases.empty() && tab == join_tab_cnt) {
        c->columnNames[col_aliases.front()] = i;
        col_aliases.pop();
        i++;
    };

    varNames[s] = c;
    c->mRecCount = tot_count;
    c->maxRecs = tot_count;
	cout << "join count " << tot_count << endl;
    for ( map<string,int>::iterator it=c->columnNames.begin() ; it != c->columnNames.end(); ++it )
        setMap[(*it).first] = s;

    if(right->tmp_table == 1) {
        varNames[j2]->free();
        varNames.erase(j2);
	};
	
    std::cout<< "join time " <<  ( ( std::clock() - start1 ) / (double)CLOCKS_PER_SEC ) << " " << getFreeMem() << endl;
}


void order_on_host(CudaSet *a, CudaSet* b, queue<string> names, stack<string> exe_type, stack<string> exe_value)
{
    unsigned int tot = 0;
    if(!a->not_compressed) { //compressed
        allocColumns(a, names);

        unsigned int c = 0;
        if(a->prm_count.size())	{
            for(unsigned int i = 0; i < a->prm.size(); i++)
                c = c + a->prm_count[i];
        }
        else
            c = a->mRecCount;
        a->mRecCount = 0;
        a->resize(c);

        unsigned int cnt = 0;
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

    unsigned int maxSize =  a->mRecCount;
    char* temp;
    unsigned int max_c = max_char(a);

    if(max_c > float_size)
        temp = new char[maxSize*max_c];
    else
        temp = new char[maxSize*float_size];

    // sort on host

    for(int i=0; !exe_type.empty(); ++i, exe_type.pop(),exe_value.pop()) {
        int colInd = (a->columnNames).find(exe_type.top())->second;

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
    for ( map<string,int>::iterator it=a->columnNames.begin() ; it != a->columnNames.end(); ++it )
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

        unsigned int maxSize =  a->mRecCount;
        void* temp;
        unsigned int max_c = max_char(a);

        if(max_c > float_size)
            CUDA_SAFE_CALL(cudaMalloc((void **) &temp, maxSize*max_c));
        else
            CUDA_SAFE_CALL(cudaMalloc((void **) &temp, maxSize*float_size));

        varNames[setMap[exe_type.top()]]->oldRecCount = varNames[setMap[exe_type.top()]]->mRecCount;


        unsigned int rcount;

        a->mRecCount = load_queue(names, a, 1, op_vx.front(), rcount);

        varNames[setMap[exe_type.top()]]->mRecCount = varNames[setMap[exe_type.top()]]->oldRecCount;
        //unsigned int str_count = 0;

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
    a = varNames.find(f)->second;
	
    if(a->mRecCount == 0) {
        CudaSet *c;
        c = new CudaSet(0,1);
        varNames[s] = c;
        clean_queues();
		cout << "SELECT " << s << " count : 0 " << endl;
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
	

	//cout << "colsize " << a->columnNames.size() << endl;
	
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

    curr_segment = 10000000;
	
	setSegments(a, op_vx);
    allocColumns(a, op_vx);
	
    unsigned int cycle_count;
    if(!a->prm.empty())
        cycle_count = varNames[setMap[op_value.front()]]->segCount;
    else
        cycle_count = a->segCount;
	cout << "cycle count " << cycle_count << endl;	

    unsigned long long int ol_count = a->mRecCount;
	unsigned int cnt;
    //varNames[setMap[op_value.front()]]->oldRecCount = varNames[setMap[op_value.front()]]->mRecCount;
    a->oldRecCount = a->mRecCount;
    b = new CudaSet(0, col_count);
    bool b_set = 0, c_set = 0;

    unsigned int long long tmp_size = a->mRecCount;
    if(a->segCount > 1)
        tmp_size = a->maxRecs;
		
    boost::unordered_map<long long int, unsigned int> mymap; //this is where we keep the hashes of the records
    vector<thrust::device_vector<int_type> > distinct_val; //keeps array of DISTINCT values for every key
    vector<thrust::device_vector<int_type> > distinct_hash; //keeps array of DISTINCT values for every key
    vector<thrust::device_vector<int_type> > distinct_tmp;

    for(unsigned int i = 0; i < distinct_cnt; i++) {
        distinct_tmp.push_back(thrust::device_vector<int_type>(tmp_size));
        distinct_val.push_back(thrust::device_vector<int_type>());
        distinct_hash.push_back(thrust::device_vector<int_type>());
    };
	

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
        cout << "cycle " << i << " select mem " << getFreeMem() << endl;

		
        cnt = 0;
        copyColumns(a, op_vx, i, cnt);
		
        reset_offsets();
        op_s = op_v2;
        s_cnt = 0;
		

        while(!op_s.empty()) {

            int colInd = (a->columnNames).find(op_s.top())->second;
            if (a->type[colInd] == 2) {
                a->d_columns_int[int_col_count + s_cnt].resize(0);
                a->add_hashed_strings(op_s.top(), i, int_col_count + s_cnt);
                s_cnt++;
            };
            op_s.pop();
        };


        if(a->mRecCount) {
            if (ll != 0) {
                order_inplace(a,op_v2,field_names,i);
                a->GroupBy(op_v2, int_col_count);
            };			
						
            select(op_type,op_value,op_nums, op_nums_f,a,b, distinct_tmp, one_liner);
			
            if(!b_set) {
                for ( map<string,int>::iterator it=b->columnNames.begin() ; it != b->columnNames.end(); ++it )
                    setMap[(*it).first] = s;
                b_set = 1;
                unsigned int old_cnt = b->mRecCount;
                b->mRecCount = 0;
                b->resize(varNames[setMap[op_vx.front()]]->maxRecs);
                b->mRecCount = old_cnt;
            };			

            if (!c_set) {
                c = new CudaSet(0, col_count);
                create_c(c,b);
                c_set = 1;
            };

            if (ll != 0 && cycle_count > 1  ) {
                add(c,b,op_v3, mymap, aliases, distinct_tmp, distinct_val, distinct_hash, a);
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
    a->mRecCount = a->oldRecCount;
    a->deAllocOnDevice();
    b->deAllocOnDevice();

    if (ll != 0) {
        count_avg(c, mymap, distinct_hash);
    }
    else {
        if(one_liner) {
            count_simple(c);
        };
    };

    reset_offsets();
    c->maxRecs = c->mRecCount;
    c->name = s;
    c->keep = 1;

    for ( map<string,int>::iterator it=c->columnNames.begin() ; it != c->columnNames.end(); ++it ) {
        setMap[(*it).first] = s;
    };

    cout << "final select " << c->mRecCount << endl;
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
            map_check = zone_map_check(op_type,op_value,op_nums, op_nums_f, a, i);
            cout << "MAP CHECK segment " << i << " " << map_check << endl;
            reset_offsets();
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
        //a->free();
        //varNames.erase(f);
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
    total_count = 0;
    total_segments = 0;
    fact_file_loaded = 0;

    while(!fact_file_loaded)	{
        cout << "LOADING " << f_file << " " << separator << endl;
        if(a->text_source)
            fact_file_loaded = a->LoadBigFile(f_file.c_str(), separator.c_str());
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
    strcat(f1,".header");

    FILE* ff = fopen(f1, "rb");
	if(ff == NULL) {
	    cout << "Couldn't open file " << f1 << endl;
		exit(0);
	};	
    fread((char *)&totalRecs, 8, 1, ff);
    fread((char *)&segCount, 4, 1, ff);
    fread((char *)&maxRecs, 4, 1, ff);
    fclose(ff);

	cout << "Reading " << totalRecs << " records" << endl;
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
    a->not_compressed = 1;

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
    join_col_cnt = 0;
    distinct_cnt = 0;
    reset_offsets();
	join_tab_cnt = 0;
	join_and_cnt.clear();
}



int main(int ac, char **av)
{
    extern FILE *yyin;
    //cudaDeviceProp deviceProp;

    //cudaGetDeviceProperties(&deviceProp, 0);
    //if (!deviceProp.canMapHostMemory)
    //    cout << "Device 0 cannot map host memory" << endl;

    //cudaSetDeviceFlags(cudaDeviceMapHost);
    cudppCreate(&theCudpp);

    long long int r30 = RAND_MAX*rand()+rand();
    long long int s30 = RAND_MAX*rand()+rand();
    long long int t4  = rand() & 0xf;

    hash_seed = (r30 << 34) + (s30 << 4) + t4;

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

    if(alloced_sz)
        cudaFree(alloced_tmp);

    fclose(yyin);
    std::cout<< "cycle time " <<  ( ( std::clock() - start1 ) / (double)CLOCKS_PER_SEC ) <<'\n';
    cudppDestroy(theCudpp);

}



