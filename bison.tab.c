
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
#line 15 "bison.y"



#include "lex.yy.c"
#include "cm.h"
#include "operators.h"




/* Line 189 of yacc.c  */
#line 84 "bison.tab.c"

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
     NONEQUAL = 268,
     OR = 269,
     XOR = 270,
     AND = 271,
     DISTINCT = 272,
     REGEXP = 273,
     LIKE = 274,
     IS = 275,
     IN = 276,
     NOT = 277,
     BETWEEN = 278,
     COMPARISON = 279,
     SHIFT = 280,
     MOD = 281,
     FROM = 282,
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
     YEAR = 305,
     MONTH = 306,
     DAY = 307,
     CAST_TO_INT = 308,
     LEFT = 309,
     RIGHT = 310,
     OUTER = 311,
     SEMI = 312,
     ANTI = 313,
     SORT = 314,
     SEGMENTS = 315,
     PRESORTED = 316,
     PARTITION = 317,
     INSERT = 318,
     WHERE = 319,
     DISPLAY = 320,
     CASE = 321,
     WHEN = 322,
     THEN = 323,
     ELSE = 324,
     END = 325,
     SHOW = 326,
     TABLES = 327,
     TABLE = 328,
     DESCRIBE = 329,
     DROP = 330,
     CREATE = 331,
     INDEX = 332,
     INTERVAL = 333,
     APPEND = 334
   };
#endif



#if ! defined YYSTYPE && ! defined YYSTYPE_IS_DECLARED
typedef union YYSTYPE
{

/* Line 214 of yacc.c  */
#line 25 "bison.y"

    long long int intval;
    double floatval;
    char *strval;
    int subtok;



/* Line 214 of yacc.c  */
#line 208 "bison.tab.c"
} YYSTYPE;
# define YYSTYPE_IS_TRIVIAL 1
# define yystype YYSTYPE /* obsolescent; will be withdrawn */
# define YYSTYPE_IS_DECLARED 1
#endif


/* Copy the second part of user declarations.  */


/* Line 264 of yacc.c  */
#line 220 "bison.tab.c"

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
#define YYFINAL  23
/* YYLAST -- Last index in YYTABLE.  */
#define YYLAST   847

/* YYNTOKENS -- Number of terminals.  */
#define YYNTOKENS  97
/* YYNNTS -- Number of nonterminals.  */
#define YYNNTS  14
/* YYNRULES -- Number of rules.  */
#define YYNRULES  100
/* YYNRULES -- Number of states.  */
#define YYNSTATES  301

/* YYTRANSLATE(YYLEX) -- Bison symbol number corresponding to YYLEX.  */
#define YYUNDEFTOK  2
#define YYMAXUTOK   334

#define YYTRANSLATE(YYX)						\
  ((unsigned int) (YYX) <= YYMAXUTOK ? yytranslate[YYX] : YYUNDEFTOK)

/* YYTRANSLATE[YYLEX] -- Bison symbol number corresponding to YYLEX.  */
static const yytype_uint8 yytranslate[] =
{
       0,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,    22,     2,     2,     2,    33,    27,     2,
      90,    91,    31,    29,    93,    30,    92,    32,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,    96,    89,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,    35,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,    94,    26,    95,     2,     2,     2,     2,
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
      15,    16,    17,    18,    19,    20,    21,    23,    24,    25,
      28,    34,    36,    37,    38,    39,    40,    41,    42,    43,
      44,    45,    46,    47,    48,    49,    50,    51,    52,    53,
      54,    55,    56,    57,    58,    59,    60,    61,    62,    63,
      64,    65,    66,    67,    68,    69,    70,    71,    72,    73,
      74,    75,    76,    77,    78,    79,    80,    81,    82,    83,
      84,    85,    86,    87,    88
};

#if YYDEBUG
/* YYPRHS[YYN] -- Index of the first RHS symbol of rule number YYN in
   YYRHS.  */
static const yytype_uint16 yyprhs[] =
{
       0,     0,     3,     6,    10,    12,    20,    33,    39,    46,
      55,    65,    73,    82,    85,    93,    99,   107,   110,   114,
     137,   146,   157,   159,   163,   165,   167,   169,   171,   173,
     175,   187,   197,   204,   207,   210,   215,   220,   225,   230,
     235,   238,   243,   248,   253,   258,   263,   267,   271,   275,
     279,   283,   287,   291,   295,   299,   303,   307,   311,   314,
     317,   321,   325,   331,   335,   344,   348,   353,   354,   358,
     362,   368,   370,   372,   376,   378,   382,   383,   385,   388,
     393,   400,   407,   414,   420,   426,   433,   439,   445,   453,
     461,   468,   476,   483,   491,   498,   499,   502,   503,   508,
     516
};

/* YYRHS -- A `-1'-separated list of the rules' RHS.  */
static const yytype_int8 yyrhs[] =
{
      98,     0,    -1,    99,    89,    -1,    98,    99,    89,    -1,
     100,    -1,     4,    11,    45,   103,    36,     4,   102,    -1,
       4,    11,    38,     3,    51,    90,     3,    91,    46,    90,
     104,    91,    -1,     4,    11,    39,     4,   107,    -1,     4,
      11,    47,     4,    40,   106,    -1,     4,    11,    45,   103,
      36,     4,   108,   102,    -1,    42,     4,    43,     3,    51,
      90,     3,    91,   109,    -1,    42,     4,    43,     3,   109,
      58,   110,    -1,    42,     4,    43,     3,    88,   109,    58,
     110,    -1,    83,     4,    -1,    72,    43,     4,    45,   103,
      36,     4,    -1,    37,    36,     4,    73,   101,    -1,    74,
       4,    51,    90,     3,    91,   109,    -1,    80,    81,    -1,
      84,    82,     4,    -1,    85,    86,     4,    57,     4,    90,
       4,    92,     4,    91,    36,     4,    93,     4,    73,     4,
      92,     4,    12,     4,    92,     4,    -1,    85,    86,     4,
      57,     4,    90,     4,    91,    -1,    85,    87,     4,    57,
       4,    90,     4,    93,     4,    91,    -1,     4,    -1,     4,
      92,     4,    -1,    10,    -1,     5,    -1,     6,    -1,     7,
      -1,     9,    -1,     8,    -1,     4,    94,     6,    95,    96,
       4,    90,     6,    93,     6,    91,    -1,     4,    94,     6,
      95,    96,     4,    90,     6,    91,    -1,     4,    94,     6,
      95,    96,     4,    -1,     4,    48,    -1,     4,    49,    -1,
      50,    90,   101,    91,    -1,    52,    90,   101,    91,    -1,
      53,    90,   101,    91,    -1,    54,    90,   101,    91,    -1,
      55,    90,   101,    91,    -1,    17,   101,    -1,    59,    90,
     101,    91,    -1,    60,    90,   101,    91,    -1,    61,    90,
     101,    91,    -1,    62,    90,   101,    91,    -1,     4,    90,
       5,    91,    -1,   101,    29,   101,    -1,   101,    30,   101,
      -1,   101,    31,   101,    -1,   101,    32,   101,    -1,   101,
      33,   101,    -1,   101,    34,   101,    -1,   101,    16,   101,
      -1,   101,    12,   101,    -1,   101,    13,   101,    -1,   101,
      14,   101,    -1,   101,    15,   101,    -1,   101,    28,   101,
      -1,    23,   101,    -1,    22,   101,    -1,   101,    25,   101,
      -1,   101,    19,   101,    -1,   101,    25,    90,   100,    91,
      -1,    90,   101,    91,    -1,    75,    76,   101,    77,   101,
      78,   101,    79,    -1,   101,    20,     8,    -1,   101,    20,
      23,     8,    -1,    -1,    44,    40,   105,    -1,   101,    46,
       4,    -1,   103,    93,   101,    46,     4,    -1,    31,    -1,
     101,    -1,   104,    93,   101,    -1,   101,    -1,   101,    93,
     105,    -1,    -1,   105,    -1,    40,   101,    -1,    41,     4,
      57,   101,    -1,    63,    67,    41,     4,    57,   101,    -1,
      64,    67,    41,     4,    57,   101,    -1,    63,    66,    41,
       4,    57,   101,    -1,    63,    41,     4,    57,   101,    -1,
      64,    41,     4,    57,   101,    -1,    64,    66,    41,     4,
      57,   101,    -1,    65,    41,     4,    57,   101,    -1,    41,
       4,    57,   101,   108,    -1,    63,    67,    41,     4,    57,
     101,   108,    -1,    64,    67,    41,     4,    57,   101,   108,
      -1,    63,    41,     4,    57,   101,   108,    -1,    63,    66,
      41,     4,    57,   101,   108,    -1,    64,    41,     4,    57,
     101,   108,    -1,    64,    66,    41,     4,    57,   101,   108,
      -1,    65,    41,     4,    57,   101,   108,    -1,    -1,    56,
       6,    -1,    -1,    68,    69,    40,     4,    -1,    68,    69,
      40,     4,    71,    40,     6,    -1,    70,    40,     4,    -1
};

/* YYRLINE[YYN] -- source line where rule number YYN was defined.  */
static const yytype_uint16 yyrline[] =
{
       0,   126,   126,   127,   131,   134,   136,   138,   140,   142,
     144,   146,   148,   150,   152,   154,   156,   158,   160,   162,
     164,   166,   172,   173,   174,   175,   176,   177,   178,   179,
     180,   181,   182,   183,   184,   185,   186,   187,   188,   189,
     190,   191,   192,   193,   194,   195,   199,   200,   201,   202,
     203,   204,   205,   206,   207,   208,   209,   210,   211,   212,
     213,   214,   216,   217,   218,   222,   223,   226,   229,   233,
     234,   235,   239,   240,   244,   245,   248,   250,   253,   257,
     258,   259,   260,   261,   262,   263,   264,   265,   266,   267,
     268,   269,   270,   271,   272,   274,   277,   279,   282,   283,
     284
};
#endif

#if YYDEBUG || YYERROR_VERBOSE || YYTOKEN_TABLE
/* YYTNAME[SYMBOL-NUM] -- String name of the symbol SYMBOL-NUM.
   First, the terminals, then, starting at YYNTOKENS, nonterminals.  */
static const char *const yytname[] =
{
  "$end", "error", "$undefined", "FILENAME", "NAME", "STRING", "INTNUM",
  "DECIMAL1", "BOOL1", "APPROXNUM", "USERVAR", "ASSIGN", "EQUAL",
  "NONEQUAL", "OR", "XOR", "AND", "DISTINCT", "REGEXP", "LIKE", "IS", "IN",
  "'!'", "NOT", "BETWEEN", "COMPARISON", "'|'", "'&'", "SHIFT", "'+'",
  "'-'", "'*'", "'/'", "'%'", "MOD", "'^'", "FROM", "DELETE", "LOAD",
  "FILTER", "BY", "JOIN", "STORE", "INTO", "GROUP", "SELECT", "AS",
  "ORDER", "ASC", "DESC", "COUNT", "USING", "SUM", "AVG", "MIN", "MAX",
  "LIMIT", "ON", "BINARY", "YEAR", "MONTH", "DAY", "CAST_TO_INT", "LEFT",
  "RIGHT", "OUTER", "SEMI", "ANTI", "SORT", "SEGMENTS", "PRESORTED",
  "PARTITION", "INSERT", "WHERE", "DISPLAY", "CASE", "WHEN", "THEN",
  "ELSE", "END", "SHOW", "TABLES", "TABLE", "DESCRIBE", "DROP", "CREATE",
  "INDEX", "INTERVAL", "APPEND", "';'", "'('", "')'", "'.'", "','", "'{'",
  "'}'", "':'", "$accept", "stmt_list", "stmt", "select_stmt", "expr",
  "opt_group_list", "expr_list", "load_list", "val_list", "opt_val_list",
  "opt_where", "join_list", "opt_limit", "sort_def", 0
};
#endif

# ifdef YYPRINT
/* YYTOKNUM[YYLEX-NUM] -- Internal token number corresponding to
   token YYLEX-NUM.  */
static const yytype_uint16 yytoknum[] =
{
       0,   256,   257,   258,   259,   260,   261,   262,   263,   264,
     265,   266,   267,   268,   269,   270,   271,   272,   273,   274,
     275,   276,    33,   277,   278,   279,   124,    38,   280,    43,
      45,    42,    47,    37,   281,    94,   282,   283,   284,   285,
     286,   287,   288,   289,   290,   291,   292,   293,   294,   295,
     296,   297,   298,   299,   300,   301,   302,   303,   304,   305,
     306,   307,   308,   309,   310,   311,   312,   313,   314,   315,
     316,   317,   318,   319,   320,   321,   322,   323,   324,   325,
     326,   327,   328,   329,   330,   331,   332,   333,   334,    59,
      40,    41,    46,    44,   123,   125,    58
};
# endif

/* YYR1[YYN] -- Symbol number of symbol that rule YYN derives.  */
static const yytype_uint8 yyr1[] =
{
       0,    97,    98,    98,    99,   100,   100,   100,   100,   100,
     100,   100,   100,   100,   100,   100,   100,   100,   100,   100,
     100,   100,   101,   101,   101,   101,   101,   101,   101,   101,
     101,   101,   101,   101,   101,   101,   101,   101,   101,   101,
     101,   101,   101,   101,   101,   101,   101,   101,   101,   101,
     101,   101,   101,   101,   101,   101,   101,   101,   101,   101,
     101,   101,   101,   101,   101,   101,   101,   102,   102,   103,
     103,   103,   104,   104,   105,   105,   106,   106,   107,   108,
     108,   108,   108,   108,   108,   108,   108,   108,   108,   108,
     108,   108,   108,   108,   108,   109,   109,   110,   110,   110,
     110
};

/* YYR2[YYN] -- Number of symbols composing right hand side of rule YYN.  */
static const yytype_uint8 yyr2[] =
{
       0,     2,     2,     3,     1,     7,    12,     5,     6,     8,
       9,     7,     8,     2,     7,     5,     7,     2,     3,    22,
       8,    10,     1,     3,     1,     1,     1,     1,     1,     1,
      11,     9,     6,     2,     2,     4,     4,     4,     4,     4,
       2,     4,     4,     4,     4,     4,     3,     3,     3,     3,
       3,     3,     3,     3,     3,     3,     3,     3,     2,     2,
       3,     3,     5,     3,     8,     3,     4,     0,     3,     3,
       5,     1,     1,     3,     1,     3,     0,     1,     2,     4,
       6,     6,     6,     5,     5,     6,     5,     5,     7,     7,
       6,     7,     6,     7,     6,     0,     2,     0,     4,     7,
       3
};

/* YYDEFACT[STATE-NAME] -- Default rule to reduce with in state
   STATE-NUM when YYTABLE doesn't specify something else to do.  Zero
   means the default is an error.  */
static const yytype_uint8 yydefact[] =
{
       0,     0,     0,     0,     0,     0,     0,     0,     0,     0,
       0,     0,     4,     0,     0,     0,     0,     0,    17,    13,
       0,     0,     0,     1,     0,     2,     0,     0,     0,     0,
       0,     0,     0,     0,    18,     0,     0,     3,     0,     0,
      22,    25,    26,    27,    29,    28,    24,     0,     0,     0,
      71,     0,     0,     0,     0,     0,     0,     0,     0,     0,
       0,     0,     0,     0,     0,     0,    95,     0,     0,     0,
       0,     0,     0,     7,    33,    34,     0,     0,     0,    40,
      59,    58,     0,     0,     0,     0,     0,     0,     0,     0,
       0,     0,     0,     0,     0,     0,     0,     0,     0,     0,
       0,     0,     0,     0,     0,     0,     0,     0,     0,     0,
       0,    76,    15,     0,     0,    95,     0,     0,     0,     0,
       0,     0,    78,     0,    23,     0,     0,     0,     0,     0,
       0,     0,     0,     0,     0,     0,    63,    53,    54,    55,
      56,    52,    61,    65,     0,     0,    60,    57,    46,    47,
      48,    49,    50,    51,    69,    67,     0,    74,    77,     8,
       0,    96,     0,    97,     0,    95,     0,     0,     0,    45,
       0,    35,    36,    37,    38,    39,    41,    42,    43,    44,
       0,    66,    22,     0,     0,     0,     0,     0,     0,     5,
      67,     0,     0,     0,    97,     0,     0,    11,    14,    16,
       0,     0,     0,     0,     0,    62,     0,     0,     0,     0,
       0,     0,     0,     0,     0,     9,    70,    75,    95,    12,
       0,     0,    20,     0,     0,     0,    32,     0,     0,    68,
       0,     0,     0,     0,     0,     0,     0,    10,     0,   100,
       0,     0,     0,     0,     0,    79,     0,     0,     0,     0,
       0,     0,     0,    98,     0,    21,    72,     0,     0,    64,
      87,    83,     0,     0,    84,     0,     0,    86,     0,     0,
       6,     0,    31,     0,    90,    82,    80,    92,    85,    81,
      94,     0,     0,    73,     0,    91,    88,    93,    89,    99,
       0,    30,     0,     0,     0,     0,     0,     0,     0,     0,
      19
};

/* YYDEFGOTO[NTERM-NUM].  */
static const yytype_int16 yydefgoto[] =
{
      -1,    10,    11,    12,   157,   189,    63,   257,   158,   159,
      73,   190,   116,   197
};

/* YYPACT[STATE-NUM] -- Index in YYTABLE of the portion describing
   STATE-NUM.  */
#define YYPACT_NINF -234
static const yytype_int16 yypact[] =
{
     108,    -5,   -27,    18,   -16,    37,   -34,    49,    13,    -6,
      93,     2,  -234,   110,    96,    60,   101,    64,  -234,  -234,
     107,   114,   116,  -234,    47,  -234,   134,   138,   200,   139,
      71,   143,   102,    66,  -234,   103,   104,  -234,   115,   118,
     135,  -234,  -234,  -234,  -234,  -234,  -234,   259,   259,   259,
    -234,    78,    80,    81,    82,    84,    85,    89,    91,    95,
     113,   259,   713,   -29,   146,   259,   -48,   200,   187,   194,
     197,   112,   259,  -234,  -234,  -234,   198,   207,   206,   797,
     255,   255,   259,   259,   259,   259,   259,   259,   259,   259,
     259,   259,   344,   259,   259,   259,   259,   259,   259,     9,
     293,   259,   259,   259,   259,   259,   259,   259,   209,   211,
     259,   259,   759,   126,   213,   164,   168,   -22,   137,   140,
     142,   230,   759,   145,  -234,   144,   372,   395,   418,   441,
     464,   487,   510,   533,   556,   636,  -234,   759,   781,   307,
     678,   797,   813,  -234,   232,    79,   609,   215,   163,   163,
    -234,  -234,  -234,  -234,  -234,   -39,   736,    94,  -234,  -234,
     238,  -234,   184,   -55,   247,   164,   252,   253,   167,  -234,
     174,  -234,  -234,  -234,  -234,  -234,  -234,  -234,  -234,  -234,
     259,  -234,     0,   180,   268,   233,   -37,   -31,   236,  -234,
     234,   270,   259,   188,   -55,   222,   254,  -234,  -234,  -234,
       7,   199,   249,   289,   602,  -234,   239,   259,   300,   264,
     265,   303,   267,   276,   320,  -234,  -234,  -234,   164,  -234,
     285,   324,  -234,   325,   326,   241,   243,   259,   259,  -234,
     287,   338,   346,   294,   357,   358,   308,  -234,   362,  -234,
     279,   280,   259,   361,   579,   659,   259,   322,   323,   259,
     332,   333,   259,   310,   359,  -234,   759,   -75,   -41,  -234,
    -234,   659,   259,   259,   659,   259,   259,   659,   342,   389,
    -234,   259,  -234,   388,  -234,   659,   659,  -234,   659,   659,
    -234,   390,   305,   759,   321,  -234,  -234,  -234,  -234,  -234,
     409,  -234,   343,   413,   327,   414,   387,   417,   330,   432,
    -234
};

/* YYPGOTO[NTERM-NUM].  */
static const yytype_int16 yypgoto[] =
{
    -234,  -234,   429,   295,   -28,   251,   375,  -234,  -169,  -234,
    -234,  -233,  -114,   250
};

/* YYTABLE[YYPACT[STATE-NUM]].  What to do in state STATE-NUM.  If
   positive, shift that token.  If negative, reduce the rule which
   number is the opposite.  If zero, do what YYDEFACT says.
   If YYTABLE_NINF, syntax error.  */
#define YYTABLE_NINF -1
static const yytype_int16 yytable[] =
{
      62,   162,   184,   113,   208,   185,    13,   109,   114,    14,
     211,    13,   260,   195,   164,   196,   270,   143,   271,    79,
      80,    81,    15,   217,   186,   187,   188,    16,   274,   209,
     210,   277,   144,    92,   280,   212,   213,   112,   229,    62,
     115,    17,   285,   286,   122,   287,   288,    18,    74,    75,
     272,   199,   273,    19,   126,   127,   128,   129,   130,   131,
     132,   133,   134,   135,   110,   137,   138,   139,   140,   141,
     142,   110,   146,   147,   148,   149,   150,   151,   152,   153,
      21,    22,   156,   182,    41,    42,    43,    44,    45,    46,
      76,    25,    77,    23,    78,    20,    47,     1,   222,   223,
      30,    48,    49,    31,   237,    32,    93,    94,    95,    96,
      97,    34,     1,    98,    99,    33,     2,    92,    35,   100,
      36,     3,   101,   102,   103,   104,   105,   106,   107,    51,
       2,    52,    53,    54,    55,     3,    37,    38,    56,    57,
      58,    59,    39,    64,    65,     2,    66,    67,    26,    27,
       3,     4,   204,     5,    60,    28,    68,    29,    72,     6,
      69,    70,     7,     8,     9,     4,    71,     5,    82,    61,
      83,    84,    85,     6,    86,    87,     7,     8,     9,    88,
       4,    89,     5,    74,    75,    90,   111,   192,     6,    91,
     118,     7,     8,     9,   104,   105,   106,   107,   119,   244,
     245,   120,   121,   123,    40,    41,    42,    43,    44,    45,
      46,   124,   125,   154,   256,   155,   160,    47,   261,   161,
     114,   264,    48,    49,   267,    76,   163,    77,   165,    78,
     166,    50,   167,   168,   275,   276,   169,   278,   279,   170,
     181,   193,   194,   283,   102,   103,   104,   105,   106,   107,
      51,   198,    52,    53,    54,    55,   200,   201,   202,    56,
      57,    58,    59,    40,    41,    42,    43,    44,    45,    46,
     203,   205,   206,   207,   216,    60,    47,   214,   185,   218,
     100,    48,    49,   101,   102,   103,   104,   105,   106,   107,
      61,   220,   224,   226,   221,   225,   228,    40,    41,    42,
      43,    44,    45,    46,   230,   231,   232,   233,   234,    51,
      47,    52,    53,    54,    55,    48,    49,   235,    56,    57,
      58,    59,    96,    97,   236,   238,    98,    99,   239,   240,
     241,   242,   100,   243,    60,   101,   102,   103,   104,   105,
     106,   107,   247,    51,   246,    52,    53,    54,    55,    61,
     248,   249,    56,    57,    58,    59,    93,    94,    95,    96,
      97,   250,   251,    98,    99,   252,   253,   258,    60,   100,
     254,   255,   101,   102,   103,   104,   105,   106,   107,   262,
     263,   268,   281,   145,    93,    94,    95,    96,    97,   265,
     266,    98,    99,   282,   284,   269,   289,   100,   290,   297,
     101,   102,   103,   104,   105,   106,   107,    93,    94,    95,
      96,    97,   291,   292,    98,    99,   293,   294,   296,   295,
     100,   298,   299,   101,   102,   103,   104,   105,   106,   107,
      93,    94,    95,    96,    97,   136,   300,    98,    99,    24,
     183,   215,   117,   100,   219,     0,   101,   102,   103,   104,
     105,   106,   107,    93,    94,    95,    96,    97,     0,     0,
      98,    99,     0,   171,     0,     0,   100,     0,     0,   101,
     102,   103,   104,   105,   106,   107,    93,    94,    95,    96,
      97,     0,     0,    98,    99,     0,   172,     0,     0,   100,
       0,     0,   101,   102,   103,   104,   105,   106,   107,    93,
      94,    95,    96,    97,     0,     0,    98,    99,     0,   173,
       0,     0,   100,     0,     0,   101,   102,   103,   104,   105,
     106,   107,    93,    94,    95,    96,    97,     0,     0,    98,
      99,     0,   174,     0,     0,   100,     0,     0,   101,   102,
     103,   104,   105,   106,   107,    93,    94,    95,    96,    97,
       0,     0,    98,    99,     0,   175,     0,     0,   100,     0,
       0,   101,   102,   103,   104,   105,   106,   107,    93,    94,
      95,    96,    97,     0,     0,    98,    99,     0,   176,     0,
       0,   100,     0,     0,   101,   102,   103,   104,   105,   106,
     107,    93,    94,    95,    96,    97,     0,     0,    98,    99,
       0,   177,     0,     0,   100,     0,     0,   101,   102,   103,
     104,   105,   106,   107,    93,    94,    95,    96,    97,     0,
       0,    98,    99,     0,   178,     0,     0,   100,     0,     0,
     101,   102,   103,   104,   105,   106,   107,   101,   102,   103,
     104,   105,   106,   107,     0,     0,     0,   179,    93,    94,
      95,    96,    97,     0,     0,    98,    99,     0,   259,     0,
       0,   100,     0,     0,   101,   102,   103,   104,   105,   106,
     107,    93,    94,    95,    96,    97,     0,     0,    98,    99,
     227,     0,     0,     0,   100,     0,     0,   101,   102,   103,
     104,   105,   106,   107,    97,     0,     0,    98,    99,     0,
     184,     0,     0,   100,     0,     0,   101,   102,   103,   104,
     105,   106,   107,   180,     0,     0,     0,     0,     0,     0,
       0,     0,   186,   187,   188,    93,    94,    95,    96,    97,
       0,     0,    98,    99,     0,     0,     0,     0,   100,     0,
       0,   101,   102,   103,   104,   105,   106,   107,    93,    94,
      95,    96,    97,     0,     0,    98,    99,     0,     0,   108,
       0,   100,     0,     0,   101,   102,   103,   104,   105,   106,
     107,    93,    94,    95,    96,    97,     0,     0,    98,    99,
       0,     0,   191,     0,   100,     0,     0,   101,   102,   103,
     104,   105,   106,   107,    94,    95,    96,    97,     0,     0,
      98,    99,     0,     0,     0,     0,   100,     0,     0,   101,
     102,   103,   104,   105,   106,   107,    98,    99,     0,     0,
       0,     0,   100,     0,     0,   101,   102,   103,   104,   105,
     106,   107,    -1,    -1,     0,     0,     0,     0,   100,     0,
       0,   101,   102,   103,   104,   105,   106,   107
};

static const yytype_int16 yycheck[] =
{
      28,   115,    41,    51,    41,    44,    11,    36,    56,    36,
      41,    11,   245,    68,    36,    70,    91,     8,    93,    47,
      48,    49,     4,   192,    63,    64,    65,    43,   261,    66,
      67,   264,    23,    61,   267,    66,    67,    65,   207,    67,
      88,     4,   275,   276,    72,   278,   279,    81,    48,    49,
      91,   165,    93,     4,    82,    83,    84,    85,    86,    87,
      88,    89,    90,    91,    93,    93,    94,    95,    96,    97,
      98,    93,   100,   101,   102,   103,   104,   105,   106,   107,
      86,    87,   110,     4,     5,     6,     7,     8,     9,    10,
      90,    89,    92,     0,    94,    82,    17,     4,    91,    92,
       4,    22,    23,    43,   218,     4,    12,    13,    14,    15,
      16,     4,     4,    19,    20,    51,    37,   145,     4,    25,
       4,    42,    28,    29,    30,    31,    32,    33,    34,    50,
      37,    52,    53,    54,    55,    42,    89,     3,    59,    60,
      61,    62,     4,     4,    73,    37,     3,    45,    38,    39,
      42,    72,   180,    74,    75,    45,    90,    47,    40,    80,
      57,    57,    83,    84,    85,    72,    51,    74,    90,    90,
      90,    90,    90,    80,    90,    90,    83,    84,    85,    90,
      72,    90,    74,    48,    49,    90,    40,    93,    80,    76,
       3,    83,    84,    85,    31,    32,    33,    34,     4,   227,
     228,     4,    90,     5,     4,     5,     6,     7,     8,     9,
      10,     4,     6,     4,   242,     4,    90,    17,   246,     6,
      56,   249,    22,    23,   252,    90,    58,    92,    91,    94,
      90,    31,    90,     3,   262,   263,    91,   265,   266,    95,
       8,     3,    58,   271,    29,    30,    31,    32,    33,    34,
      50,     4,    52,    53,    54,    55,     4,     4,    91,    59,
      60,    61,    62,     4,     5,     6,     7,     8,     9,    10,
      96,    91,     4,    40,     4,    75,    17,    41,    44,    91,
      25,    22,    23,    28,    29,    30,    31,    32,    33,    34,
      90,    69,    93,     4,    40,    46,    57,     4,     5,     6,
       7,     8,     9,    10,     4,    41,    41,     4,    41,    50,
      17,    52,    53,    54,    55,    22,    23,    41,    59,    60,
      61,    62,    15,    16,     4,    40,    19,    20,     4,     4,
       4,    90,    25,    90,    75,    28,    29,    30,    31,    32,
      33,    34,     4,    50,    57,    52,    53,    54,    55,    90,
       4,    57,    59,    60,    61,    62,    12,    13,    14,    15,
      16,     4,     4,    19,    20,    57,     4,     6,    75,    25,
      91,    91,    28,    29,    30,    31,    32,    33,    34,    57,
      57,    71,    40,    90,    12,    13,    14,    15,    16,    57,
      57,    19,    20,     4,     6,    36,     6,    25,    93,    12,
      28,    29,    30,    31,    32,    33,    34,    12,    13,    14,
      15,    16,    91,     4,    19,    20,    73,     4,     4,    92,
      25,     4,    92,    28,    29,    30,    31,    32,    33,    34,
      12,    13,    14,    15,    16,    91,     4,    19,    20,    10,
     145,   190,    67,    25,   194,    -1,    28,    29,    30,    31,
      32,    33,    34,    12,    13,    14,    15,    16,    -1,    -1,
      19,    20,    -1,    91,    -1,    -1,    25,    -1,    -1,    28,
      29,    30,    31,    32,    33,    34,    12,    13,    14,    15,
      16,    -1,    -1,    19,    20,    -1,    91,    -1,    -1,    25,
      -1,    -1,    28,    29,    30,    31,    32,    33,    34,    12,
      13,    14,    15,    16,    -1,    -1,    19,    20,    -1,    91,
      -1,    -1,    25,    -1,    -1,    28,    29,    30,    31,    32,
      33,    34,    12,    13,    14,    15,    16,    -1,    -1,    19,
      20,    -1,    91,    -1,    -1,    25,    -1,    -1,    28,    29,
      30,    31,    32,    33,    34,    12,    13,    14,    15,    16,
      -1,    -1,    19,    20,    -1,    91,    -1,    -1,    25,    -1,
      -1,    28,    29,    30,    31,    32,    33,    34,    12,    13,
      14,    15,    16,    -1,    -1,    19,    20,    -1,    91,    -1,
      -1,    25,    -1,    -1,    28,    29,    30,    31,    32,    33,
      34,    12,    13,    14,    15,    16,    -1,    -1,    19,    20,
      -1,    91,    -1,    -1,    25,    -1,    -1,    28,    29,    30,
      31,    32,    33,    34,    12,    13,    14,    15,    16,    -1,
      -1,    19,    20,    -1,    91,    -1,    -1,    25,    -1,    -1,
      28,    29,    30,    31,    32,    33,    34,    28,    29,    30,
      31,    32,    33,    34,    -1,    -1,    -1,    91,    12,    13,
      14,    15,    16,    -1,    -1,    19,    20,    -1,    79,    -1,
      -1,    25,    -1,    -1,    28,    29,    30,    31,    32,    33,
      34,    12,    13,    14,    15,    16,    -1,    -1,    19,    20,
      78,    -1,    -1,    -1,    25,    -1,    -1,    28,    29,    30,
      31,    32,    33,    34,    16,    -1,    -1,    19,    20,    -1,
      41,    -1,    -1,    25,    -1,    -1,    28,    29,    30,    31,
      32,    33,    34,    77,    -1,    -1,    -1,    -1,    -1,    -1,
      -1,    -1,    63,    64,    65,    12,    13,    14,    15,    16,
      -1,    -1,    19,    20,    -1,    -1,    -1,    -1,    25,    -1,
      -1,    28,    29,    30,    31,    32,    33,    34,    12,    13,
      14,    15,    16,    -1,    -1,    19,    20,    -1,    -1,    46,
      -1,    25,    -1,    -1,    28,    29,    30,    31,    32,    33,
      34,    12,    13,    14,    15,    16,    -1,    -1,    19,    20,
      -1,    -1,    46,    -1,    25,    -1,    -1,    28,    29,    30,
      31,    32,    33,    34,    13,    14,    15,    16,    -1,    -1,
      19,    20,    -1,    -1,    -1,    -1,    25,    -1,    -1,    28,
      29,    30,    31,    32,    33,    34,    19,    20,    -1,    -1,
      -1,    -1,    25,    -1,    -1,    28,    29,    30,    31,    32,
      33,    34,    19,    20,    -1,    -1,    -1,    -1,    25,    -1,
      -1,    28,    29,    30,    31,    32,    33,    34
};

/* YYSTOS[STATE-NUM] -- The (internal number of the) accessing
   symbol of state STATE-NUM.  */
static const yytype_uint8 yystos[] =
{
       0,     4,    37,    42,    72,    74,    80,    83,    84,    85,
      98,    99,   100,    11,    36,     4,    43,     4,    81,     4,
      82,    86,    87,     0,    99,    89,    38,    39,    45,    47,
       4,    43,     4,    51,     4,     4,     4,    89,     3,     4,
       4,     5,     6,     7,     8,     9,    10,    17,    22,    23,
      31,    50,    52,    53,    54,    55,    59,    60,    61,    62,
      75,    90,   101,   103,     4,    73,     3,    45,    90,    57,
      57,    51,    40,   107,    48,    49,    90,    92,    94,   101,
     101,   101,    90,    90,    90,    90,    90,    90,    90,    90,
      90,    76,   101,    12,    13,    14,    15,    16,    19,    20,
      25,    28,    29,    30,    31,    32,    33,    34,    46,    36,
      93,    40,   101,    51,    56,    88,   109,   103,     3,     4,
       4,    90,   101,     5,     4,     6,   101,   101,   101,   101,
     101,   101,   101,   101,   101,   101,    91,   101,   101,   101,
     101,   101,   101,     8,    23,    90,   101,   101,   101,   101,
     101,   101,   101,   101,     4,     4,   101,   101,   105,   106,
      90,     6,   109,    58,    36,    91,    90,    90,     3,    91,
      95,    91,    91,    91,    91,    91,    91,    91,    91,    91,
      77,     8,     4,   100,    41,    44,    63,    64,    65,   102,
     108,    46,    93,     3,    58,    68,    70,   110,     4,   109,
       4,     4,    91,    96,   101,    91,     4,    40,    41,    66,
      67,    41,    66,    67,    41,   102,     4,   105,    91,   110,
      69,    40,    91,    92,    93,    46,     4,    78,    57,   105,
       4,    41,    41,     4,    41,    41,     4,   109,    40,     4,
       4,     4,    90,    90,   101,   101,    57,     4,     4,    57,
       4,     4,    57,     4,    91,    91,   101,   104,     6,    79,
     108,   101,    57,    57,   101,    57,    57,   101,    71,    36,
      91,    93,    91,    93,   108,   101,   101,   108,   101,   101,
     108,    40,     4,   101,     6,   108,   108,   108,   108,     6,
      93,    91,     4,    73,     4,    92,     4,    12,     4,    92,
       4
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
#line 131 "bison.y"
    { emit("STMT"); ;}
    break;

  case 5:

/* Line 1455 of yacc.c  */
#line 135 "bison.y"
    { emit_select((yyvsp[(1) - (7)].strval), (yyvsp[(6) - (7)].strval), (yyvsp[(7) - (7)].intval)); ;}
    break;

  case 6:

/* Line 1455 of yacc.c  */
#line 137 "bison.y"
    {  emit_load((yyvsp[(1) - (12)].strval), (yyvsp[(4) - (12)].strval), (yyvsp[(11) - (12)].intval), (yyvsp[(7) - (12)].strval)); ;}
    break;

  case 7:

/* Line 1455 of yacc.c  */
#line 139 "bison.y"
    {  emit_filter((yyvsp[(1) - (5)].strval), (yyvsp[(4) - (5)].strval));;}
    break;

  case 8:

/* Line 1455 of yacc.c  */
#line 141 "bison.y"
    {  emit_order((yyvsp[(1) - (6)].strval), (yyvsp[(4) - (6)].strval), (yyvsp[(6) - (6)].intval));;}
    break;

  case 9:

/* Line 1455 of yacc.c  */
#line 143 "bison.y"
    {  emit_join((yyvsp[(1) - (8)].strval),(yyvsp[(6) - (8)].strval),(yyvsp[(7) - (8)].intval),0,-1); ;}
    break;

  case 10:

/* Line 1455 of yacc.c  */
#line 145 "bison.y"
    {  emit_store((yyvsp[(2) - (9)].strval),(yyvsp[(4) - (9)].strval),(yyvsp[(7) - (9)].strval)); ;}
    break;

  case 11:

/* Line 1455 of yacc.c  */
#line 147 "bison.y"
    {  emit_store_binary((yyvsp[(2) - (7)].strval),(yyvsp[(4) - (7)].strval),0); ;}
    break;

  case 12:

/* Line 1455 of yacc.c  */
#line 149 "bison.y"
    {  emit_store_binary((yyvsp[(2) - (8)].strval),(yyvsp[(4) - (8)].strval),1); ;}
    break;

  case 13:

/* Line 1455 of yacc.c  */
#line 151 "bison.y"
    {  emit_describe_table((yyvsp[(2) - (2)].strval));;}
    break;

  case 14:

/* Line 1455 of yacc.c  */
#line 153 "bison.y"
    {  emit_insert((yyvsp[(3) - (7)].strval), (yyvsp[(7) - (7)].strval));;}
    break;

  case 15:

/* Line 1455 of yacc.c  */
#line 155 "bison.y"
    {  emit_delete((yyvsp[(3) - (5)].strval));;}
    break;

  case 16:

/* Line 1455 of yacc.c  */
#line 157 "bison.y"
    {  emit_display((yyvsp[(2) - (7)].strval), (yyvsp[(5) - (7)].strval));;}
    break;

  case 17:

/* Line 1455 of yacc.c  */
#line 159 "bison.y"
    {  emit_show_tables();;}
    break;

  case 18:

/* Line 1455 of yacc.c  */
#line 161 "bison.y"
    {  emit_drop_table((yyvsp[(3) - (3)].strval));;}
    break;

  case 19:

/* Line 1455 of yacc.c  */
#line 163 "bison.y"
    {  emit_create_bitmap_index((yyvsp[(3) - (22)].strval), (yyvsp[(5) - (22)].strval), (yyvsp[(7) - (22)].strval), (yyvsp[(9) - (22)].strval), (yyvsp[(18) - (22)].strval), (yyvsp[(22) - (22)].strval));;}
    break;

  case 20:

/* Line 1455 of yacc.c  */
#line 165 "bison.y"
    {  emit_create_index((yyvsp[(3) - (8)].strval), (yyvsp[(5) - (8)].strval), (yyvsp[(7) - (8)].strval));;}
    break;

  case 21:

/* Line 1455 of yacc.c  */
#line 167 "bison.y"
    {  emit_create_interval((yyvsp[(3) - (10)].strval), (yyvsp[(5) - (10)].strval), (yyvsp[(7) - (10)].strval), (yyvsp[(9) - (10)].strval));;}
    break;

  case 22:

/* Line 1455 of yacc.c  */
#line 172 "bison.y"
    { emit_name((yyvsp[(1) - (1)].strval)); ;}
    break;

  case 23:

/* Line 1455 of yacc.c  */
#line 173 "bison.y"
    { emit_fieldname((yyvsp[(1) - (3)].strval), (yyvsp[(3) - (3)].strval)); ;}
    break;

  case 24:

/* Line 1455 of yacc.c  */
#line 174 "bison.y"
    { emit("USERVAR %s", (yyvsp[(1) - (1)].strval)); ;}
    break;

  case 25:

/* Line 1455 of yacc.c  */
#line 175 "bison.y"
    { emit_string((yyvsp[(1) - (1)].strval)); ;}
    break;

  case 26:

/* Line 1455 of yacc.c  */
#line 176 "bison.y"
    { emit_number((yyvsp[(1) - (1)].intval)); ;}
    break;

  case 27:

/* Line 1455 of yacc.c  */
#line 177 "bison.y"
    { emit_decimal((yyvsp[(1) - (1)].strval)); ;}
    break;

  case 28:

/* Line 1455 of yacc.c  */
#line 178 "bison.y"
    { emit_float((yyvsp[(1) - (1)].floatval)); ;}
    break;

  case 29:

/* Line 1455 of yacc.c  */
#line 179 "bison.y"
    { emit("BOOL %d", (yyvsp[(1) - (1)].intval)); ;}
    break;

  case 30:

/* Line 1455 of yacc.c  */
#line 180 "bison.y"
    { emit_vardecimal((yyvsp[(1) - (11)].strval), (yyvsp[(3) - (11)].intval), (yyvsp[(6) - (11)].strval),  (yyvsp[(8) - (11)].intval), (yyvsp[(10) - (11)].intval));;}
    break;

  case 31:

/* Line 1455 of yacc.c  */
#line 181 "bison.y"
    { emit_varchar((yyvsp[(1) - (9)].strval), (yyvsp[(3) - (9)].intval), (yyvsp[(6) - (9)].strval), (yyvsp[(8) - (9)].intval), "", "");;}
    break;

  case 32:

/* Line 1455 of yacc.c  */
#line 182 "bison.y"
    { emit_var((yyvsp[(1) - (6)].strval), (yyvsp[(3) - (6)].intval), (yyvsp[(6) - (6)].strval), "", "");;}
    break;

  case 33:

/* Line 1455 of yacc.c  */
#line 183 "bison.y"
    { emit_var_asc((yyvsp[(1) - (2)].strval));;}
    break;

  case 34:

/* Line 1455 of yacc.c  */
#line 184 "bison.y"
    { emit_var_desc((yyvsp[(1) - (2)].strval));;}
    break;

  case 35:

/* Line 1455 of yacc.c  */
#line 185 "bison.y"
    { emit_count(); ;}
    break;

  case 36:

/* Line 1455 of yacc.c  */
#line 186 "bison.y"
    { emit_sum(); ;}
    break;

  case 37:

/* Line 1455 of yacc.c  */
#line 187 "bison.y"
    { emit_average(); ;}
    break;

  case 38:

/* Line 1455 of yacc.c  */
#line 188 "bison.y"
    { emit_min(); ;}
    break;

  case 39:

/* Line 1455 of yacc.c  */
#line 189 "bison.y"
    { emit_max(); ;}
    break;

  case 40:

/* Line 1455 of yacc.c  */
#line 190 "bison.y"
    { emit_distinct(); ;}
    break;

  case 41:

/* Line 1455 of yacc.c  */
#line 191 "bison.y"
    { emit_year(); ;}
    break;

  case 42:

/* Line 1455 of yacc.c  */
#line 192 "bison.y"
    { emit_month(); ;}
    break;

  case 43:

/* Line 1455 of yacc.c  */
#line 193 "bison.y"
    { emit_day(); ;}
    break;

  case 44:

/* Line 1455 of yacc.c  */
#line 194 "bison.y"
    { emit_cast(); ;}
    break;

  case 45:

/* Line 1455 of yacc.c  */
#line 195 "bison.y"
    { emit_string_grp((yyvsp[(1) - (4)].strval), (yyvsp[(3) - (4)].strval)); ;}
    break;

  case 46:

/* Line 1455 of yacc.c  */
#line 199 "bison.y"
    { emit_add(); ;}
    break;

  case 47:

/* Line 1455 of yacc.c  */
#line 200 "bison.y"
    { emit_minus(); ;}
    break;

  case 48:

/* Line 1455 of yacc.c  */
#line 201 "bison.y"
    { emit_mul(); ;}
    break;

  case 49:

/* Line 1455 of yacc.c  */
#line 202 "bison.y"
    { emit_div(); ;}
    break;

  case 50:

/* Line 1455 of yacc.c  */
#line 203 "bison.y"
    { emit("MOD"); ;}
    break;

  case 51:

/* Line 1455 of yacc.c  */
#line 204 "bison.y"
    { emit("MOD"); ;}
    break;

  case 52:

/* Line 1455 of yacc.c  */
#line 205 "bison.y"
    { emit_and(); ;}
    break;

  case 53:

/* Line 1455 of yacc.c  */
#line 206 "bison.y"
    { emit_eq(); ;}
    break;

  case 54:

/* Line 1455 of yacc.c  */
#line 207 "bison.y"
    { emit_neq(); ;}
    break;

  case 55:

/* Line 1455 of yacc.c  */
#line 208 "bison.y"
    { emit_or(); ;}
    break;

  case 56:

/* Line 1455 of yacc.c  */
#line 209 "bison.y"
    { emit("XOR"); ;}
    break;

  case 57:

/* Line 1455 of yacc.c  */
#line 210 "bison.y"
    { emit("SHIFT %s", (yyvsp[(2) - (3)].subtok)==1?"left":"right"); ;}
    break;

  case 58:

/* Line 1455 of yacc.c  */
#line 211 "bison.y"
    { emit("NOT"); ;}
    break;

  case 59:

/* Line 1455 of yacc.c  */
#line 212 "bison.y"
    { emit("NOT"); ;}
    break;

  case 60:

/* Line 1455 of yacc.c  */
#line 213 "bison.y"
    { emit_cmp((yyvsp[(2) - (3)].subtok)); ;}
    break;

  case 61:

/* Line 1455 of yacc.c  */
#line 214 "bison.y"
    { emit_cmp(7); ;}
    break;

  case 62:

/* Line 1455 of yacc.c  */
#line 216 "bison.y"
    { emit("CMPSELECT %d", (yyvsp[(2) - (5)].subtok)); ;}
    break;

  case 63:

/* Line 1455 of yacc.c  */
#line 217 "bison.y"
    {emit("EXPR");;}
    break;

  case 64:

/* Line 1455 of yacc.c  */
#line 218 "bison.y"
    { emit_case(); ;}
    break;

  case 65:

/* Line 1455 of yacc.c  */
#line 222 "bison.y"
    { emit("ISBOOL %d", (yyvsp[(3) - (3)].intval)); ;}
    break;

  case 66:

/* Line 1455 of yacc.c  */
#line 223 "bison.y"
    { emit("ISBOOL %d", (yyvsp[(4) - (4)].intval)); emit("NOT"); ;}
    break;

  case 67:

/* Line 1455 of yacc.c  */
#line 226 "bison.y"
    { /* nil */
    (yyval.intval) = 0;
;}
    break;

  case 68:

/* Line 1455 of yacc.c  */
#line 229 "bison.y"
    { (yyval.intval) = (yyvsp[(3) - (3)].intval);;}
    break;

  case 69:

/* Line 1455 of yacc.c  */
#line 233 "bison.y"
    { (yyval.intval) = 1; emit_sel_name((yyvsp[(3) - (3)].strval));;}
    break;

  case 70:

/* Line 1455 of yacc.c  */
#line 234 "bison.y"
    { (yyval.intval) = (yyvsp[(1) - (5)].intval) + 1; emit_sel_name((yyvsp[(5) - (5)].strval));;}
    break;

  case 71:

/* Line 1455 of yacc.c  */
#line 235 "bison.y"
    { emit_sel_name("*");;}
    break;

  case 72:

/* Line 1455 of yacc.c  */
#line 239 "bison.y"
    { (yyval.intval) = 1; ;}
    break;

  case 73:

/* Line 1455 of yacc.c  */
#line 240 "bison.y"
    {(yyval.intval) = (yyvsp[(1) - (3)].intval) + 1; ;}
    break;

  case 74:

/* Line 1455 of yacc.c  */
#line 244 "bison.y"
    { (yyval.intval) = 1; ;}
    break;

  case 75:

/* Line 1455 of yacc.c  */
#line 245 "bison.y"
    { (yyval.intval) = 1 + (yyvsp[(3) - (3)].intval); ;}
    break;

  case 76:

/* Line 1455 of yacc.c  */
#line 248 "bison.y"
    { /* nil */
    (yyval.intval) = 0;
;}
    break;

  case 78:

/* Line 1455 of yacc.c  */
#line 253 "bison.y"
    { emit("FILTER BY"); ;}
    break;

  case 79:

/* Line 1455 of yacc.c  */
#line 257 "bison.y"
    { (yyval.intval) = 1; emit_join_tab((yyvsp[(2) - (4)].strval), 'I');;}
    break;

  case 80:

/* Line 1455 of yacc.c  */
#line 258 "bison.y"
    { (yyval.intval) = 1; emit_join_tab((yyvsp[(4) - (6)].strval), '3');;}
    break;

  case 81:

/* Line 1455 of yacc.c  */
#line 259 "bison.y"
    { (yyval.intval) = 1; emit_join_tab((yyvsp[(4) - (6)].strval), '4');;}
    break;

  case 82:

/* Line 1455 of yacc.c  */
#line 260 "bison.y"
    { (yyval.intval) = 1; emit_join_tab((yyvsp[(4) - (6)].strval), '1');;}
    break;

  case 83:

/* Line 1455 of yacc.c  */
#line 261 "bison.y"
    { (yyval.intval) = 1; emit_join_tab((yyvsp[(3) - (5)].strval), 'S');;}
    break;

  case 84:

/* Line 1455 of yacc.c  */
#line 262 "bison.y"
    { (yyval.intval) = 1; emit_join_tab((yyvsp[(3) - (5)].strval), 'R');;}
    break;

  case 85:

/* Line 1455 of yacc.c  */
#line 263 "bison.y"
    { (yyval.intval) = 1; emit_join_tab((yyvsp[(4) - (6)].strval), '2');;}
    break;

  case 86:

/* Line 1455 of yacc.c  */
#line 264 "bison.y"
    { (yyval.intval) = 1; emit_join_tab((yyvsp[(3) - (5)].strval), 'O');;}
    break;

  case 87:

/* Line 1455 of yacc.c  */
#line 265 "bison.y"
    { (yyval.intval) = 1; emit_join_tab((yyvsp[(2) - (5)].strval), 'I'); ;}
    break;

  case 88:

/* Line 1455 of yacc.c  */
#line 266 "bison.y"
    { (yyval.intval) = 1; emit_join_tab((yyvsp[(4) - (7)].strval), '3'); ;}
    break;

  case 89:

/* Line 1455 of yacc.c  */
#line 267 "bison.y"
    { (yyval.intval) = 1; emit_join_tab((yyvsp[(4) - (7)].strval), '4'); ;}
    break;

  case 90:

/* Line 1455 of yacc.c  */
#line 268 "bison.y"
    { (yyval.intval) = 1; emit_join_tab((yyvsp[(3) - (6)].strval), 'L'); ;}
    break;

  case 91:

/* Line 1455 of yacc.c  */
#line 269 "bison.y"
    { (yyval.intval) = 1; emit_join_tab((yyvsp[(4) - (7)].strval), '1'); ;}
    break;

  case 92:

/* Line 1455 of yacc.c  */
#line 270 "bison.y"
    { (yyval.intval) = 1; emit_join_tab((yyvsp[(3) - (6)].strval), 'R'); ;}
    break;

  case 93:

/* Line 1455 of yacc.c  */
#line 271 "bison.y"
    { (yyval.intval) = 1; emit_join_tab((yyvsp[(4) - (7)].strval), 'R'); ;}
    break;

  case 94:

/* Line 1455 of yacc.c  */
#line 272 "bison.y"
    { (yyval.intval) = 1; emit_join_tab((yyvsp[(3) - (6)].strval), 'O'); ;}
    break;

  case 95:

/* Line 1455 of yacc.c  */
#line 274 "bison.y"
    { /* nil */
    (yyval.intval) = 0;
;}
    break;

  case 96:

/* Line 1455 of yacc.c  */
#line 277 "bison.y"
    { emit_limit((yyvsp[(2) - (2)].intval)); ;}
    break;

  case 97:

/* Line 1455 of yacc.c  */
#line 279 "bison.y"
    { /* nil */
    (yyval.intval) = 0;
;}
    break;

  case 98:

/* Line 1455 of yacc.c  */
#line 282 "bison.y"
    { emit_sort((yyvsp[(4) - (4)].strval), 0); ;}
    break;

  case 99:

/* Line 1455 of yacc.c  */
#line 283 "bison.y"
    { emit_sort((yyvsp[(4) - (7)].strval), (yyvsp[(7) - (7)].intval)); ;}
    break;

  case 100:

/* Line 1455 of yacc.c  */
#line 284 "bison.y"
    { emit_presort((yyvsp[(3) - (3)].strval)); ;}
    break;



/* Line 1455 of yacc.c  */
#line 2458 "bison.tab.c"
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
#line 286 "bison.y"


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



