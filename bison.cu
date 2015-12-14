
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
#line 84 "bison.cu"

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
     YEAR = 273,
     MONTH = 274,
     DAY = 275,
     REGEXP = 276,
     LIKE = 277,
     IS = 278,
     IN = 279,
     NOT = 280,
     BETWEEN = 281,
     COMPARISON = 282,
     SHIFT = 283,
     MOD = 284,
     FROM = 285,
     DELETE = 286,
     LOAD = 287,
     FILTER = 288,
     BY = 289,
     JOIN = 290,
     STORE = 291,
     INTO = 292,
     GROUP = 293,
     SELECT = 294,
     AS = 295,
     ORDER = 296,
     ASC = 297,
     DESC = 298,
     COUNT = 299,
     USING = 300,
     SUM = 301,
     AVG = 302,
     MIN = 303,
     MAX = 304,
     LIMIT = 305,
     ON = 306,
     BINARY = 307,
     LEFT = 308,
     RIGHT = 309,
     OUTER = 310,
     SEMI = 311,
     ANTI = 312,
     SORT = 313,
     SEGMENTS = 314,
     PRESORTED = 315,
     PARTITION = 316,
     INSERT = 317,
     WHERE = 318,
     DISPLAY = 319,
     CASE = 320,
     WHEN = 321,
     THEN = 322,
     ELSE = 323,
     END = 324,
     SHOW = 325,
     TABLES = 326,
     TABLE = 327,
     DESCRIBE = 328,
     DROP = 329,
     CREATE = 330,
     INDEX = 331,
     INTERVAL = 332,
     APPEND = 333
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
#line 207 "bison.cu"
} YYSTYPE;
# define YYSTYPE_IS_TRIVIAL 1
# define yystype YYSTYPE /* obsolescent; will be withdrawn */
# define YYSTYPE_IS_DECLARED 1
#endif


/* Copy the second part of user declarations.  */


/* Line 264 of yacc.c  */
#line 219 "bison.cu"

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
#define YYLAST   928

/* YYNTOKENS -- Number of terminals.  */
#define YYNTOKENS  96
/* YYNNTS -- Number of nonterminals.  */
#define YYNNTS  14
/* YYNRULES -- Number of rules.  */
#define YYNRULES  98
/* YYNRULES -- Number of states.  */
#define YYNSTATES  294

/* YYTRANSLATE(YYLEX) -- Bison symbol number corresponding to YYLEX.  */
#define YYUNDEFTOK  2
#define YYMAXUTOK   333

#define YYTRANSLATE(YYX)						\
  ((unsigned int) (YYX) <= YYMAXUTOK ? yytranslate[YYX] : YYUNDEFTOK)

/* YYTRANSLATE[YYLEX] -- Bison symbol number corresponding to YYLEX.  */
static const yytype_uint8 yytranslate[] =
{
       0,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,    25,     2,     2,     2,    36,    30,     2,
      89,    90,    34,    32,    92,    33,    91,    35,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,    95,    88,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,    38,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,    93,    29,    94,     2,     2,     2,     2,
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
      15,    16,    17,    18,    19,    20,    21,    22,    23,    24,
      26,    27,    28,    31,    37,    39,    40,    41,    42,    43,
      44,    45,    46,    47,    48,    49,    50,    51,    52,    53,
      54,    55,    56,    57,    58,    59,    60,    61,    62,    63,
      64,    65,    66,    67,    68,    69,    70,    71,    72,    73,
      74,    75,    76,    77,    78,    79,    80,    81,    82,    83,
      84,    85,    86,    87
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
     235,   238,   243,   248,   253,   257,   261,   265,   269,   273,
     277,   281,   285,   289,   293,   297,   301,   304,   307,   311,
     315,   321,   325,   334,   338,   343,   344,   348,   352,   358,
     360,   362,   366,   368,   372,   373,   375,   378,   383,   390,
     397,   404,   410,   416,   423,   429,   435,   443,   451,   458,
     466,   473,   481,   488,   489,   492,   493,   498,   506
};

/* YYRHS -- A `-1'-separated list of the rules' RHS.  */
static const yytype_int8 yyrhs[] =
{
      97,     0,    -1,    98,    88,    -1,    97,    98,    88,    -1,
      99,    -1,     4,    11,    48,   102,    39,     4,   101,    -1,
       4,    11,    41,     3,    54,    89,     3,    90,    49,    89,
     103,    90,    -1,     4,    11,    42,     4,   106,    -1,     4,
      11,    50,     4,    43,   105,    -1,     4,    11,    48,   102,
      39,     4,   107,   101,    -1,    45,     4,    46,     3,    54,
      89,     3,    90,   108,    -1,    45,     4,    46,     3,   108,
      61,   109,    -1,    45,     4,    46,     3,    87,   108,    61,
     109,    -1,    82,     4,    -1,    71,    46,     4,    48,   102,
      39,     4,    -1,    40,    39,     4,    72,   100,    -1,    73,
       4,    54,    89,     3,    90,   108,    -1,    79,    80,    -1,
      83,    81,     4,    -1,    84,    85,     4,    60,     4,    89,
       4,    91,     4,    90,    39,     4,    92,     4,    72,     4,
      91,     4,    12,     4,    91,     4,    -1,    84,    85,     4,
      60,     4,    89,     4,    90,    -1,    84,    86,     4,    60,
       4,    89,     4,    92,     4,    90,    -1,     4,    -1,     4,
      91,     4,    -1,    10,    -1,     5,    -1,     6,    -1,     7,
      -1,     9,    -1,     8,    -1,     4,    93,     6,    94,    95,
       4,    89,     6,    92,     6,    90,    -1,     4,    93,     6,
      94,    95,     4,    89,     6,    90,    -1,     4,    93,     6,
      94,    95,     4,    -1,     4,    51,    -1,     4,    52,    -1,
      53,    89,   100,    90,    -1,    55,    89,   100,    90,    -1,
      56,    89,   100,    90,    -1,    57,    89,   100,    90,    -1,
      58,    89,   100,    90,    -1,    17,   100,    -1,    18,    89,
     100,    90,    -1,    19,    89,   100,    90,    -1,    20,    89,
     100,    90,    -1,   100,    32,   100,    -1,   100,    33,   100,
      -1,   100,    34,   100,    -1,   100,    35,   100,    -1,   100,
      36,   100,    -1,   100,    37,   100,    -1,   100,    16,   100,
      -1,   100,    12,   100,    -1,   100,    13,   100,    -1,   100,
      14,   100,    -1,   100,    15,   100,    -1,   100,    31,   100,
      -1,    26,   100,    -1,    25,   100,    -1,   100,    28,   100,
      -1,   100,    22,   100,    -1,   100,    28,    89,    99,    90,
      -1,    89,   100,    90,    -1,    74,    75,   100,    76,   100,
      77,   100,    78,    -1,   100,    23,     8,    -1,   100,    23,
      26,     8,    -1,    -1,    47,    43,   104,    -1,   100,    49,
       4,    -1,   102,    92,   100,    49,     4,    -1,    34,    -1,
     100,    -1,   103,    92,   100,    -1,   100,    -1,   100,    92,
     104,    -1,    -1,   104,    -1,    43,   100,    -1,    44,     4,
      60,   100,    -1,    62,    66,    44,     4,    60,   100,    -1,
      63,    66,    44,     4,    60,   100,    -1,    62,    65,    44,
       4,    60,   100,    -1,    62,    44,     4,    60,   100,    -1,
      63,    44,     4,    60,   100,    -1,    63,    65,    44,     4,
      60,   100,    -1,    64,    44,     4,    60,   100,    -1,    44,
       4,    60,   100,   107,    -1,    62,    66,    44,     4,    60,
     100,   107,    -1,    63,    66,    44,     4,    60,   100,   107,
      -1,    62,    44,     4,    60,   100,   107,    -1,    62,    65,
      44,     4,    60,   100,   107,    -1,    63,    44,     4,    60,
     100,   107,    -1,    63,    65,    44,     4,    60,   100,   107,
      -1,    64,    44,     4,    60,   100,   107,    -1,    -1,    59,
       6,    -1,    -1,    67,    68,    43,     4,    -1,    67,    68,
      43,     4,    70,    43,     6,    -1,    69,    43,     4,    -1
};

/* YYRLINE[YYN] -- source line where rule number YYN was defined.  */
static const yytype_uint16 yyrline[] =
{
       0,   128,   128,   129,   133,   136,   138,   140,   142,   144,
     146,   148,   150,   152,   154,   156,   158,   160,   162,   164,
     166,   168,   174,   175,   176,   177,   178,   179,   180,   181,
     182,   183,   184,   185,   186,   187,   188,   189,   190,   191,
     192,   193,   194,   195,   199,   200,   201,   202,   203,   204,
     205,   206,   207,   208,   209,   210,   211,   212,   213,   214,
     216,   217,   218,   222,   223,   226,   229,   233,   234,   235,
     239,   240,   244,   245,   248,   250,   253,   257,   258,   259,
     260,   261,   262,   263,   264,   265,   266,   267,   268,   269,
     270,   271,   272,   274,   277,   279,   282,   283,   284
};
#endif

#if YYDEBUG || YYERROR_VERBOSE || YYTOKEN_TABLE
/* YYTNAME[SYMBOL-NUM] -- String name of the symbol SYMBOL-NUM.
   First, the terminals, then, starting at YYNTOKENS, nonterminals.  */
static const char *const yytname[] =
{
  "$end", "error", "$undefined", "FILENAME", "NAME", "STRING", "INTNUM",
  "DECIMAL1", "BOOL1", "APPROXNUM", "USERVAR", "ASSIGN", "EQUAL",
  "NONEQUAL", "OR", "XOR", "AND", "DISTINCT", "YEAR", "MONTH", "DAY",
  "REGEXP", "LIKE", "IS", "IN", "'!'", "NOT", "BETWEEN", "COMPARISON",
  "'|'", "'&'", "SHIFT", "'+'", "'-'", "'*'", "'/'", "'%'", "MOD", "'^'",
  "FROM", "DELETE", "LOAD", "FILTER", "BY", "JOIN", "STORE", "INTO",
  "GROUP", "SELECT", "AS", "ORDER", "ASC", "DESC", "COUNT", "USING", "SUM",
  "AVG", "MIN", "MAX", "LIMIT", "ON", "BINARY", "LEFT", "RIGHT", "OUTER",
  "SEMI", "ANTI", "SORT", "SEGMENTS", "PRESORTED", "PARTITION", "INSERT",
  "WHERE", "DISPLAY", "CASE", "WHEN", "THEN", "ELSE", "END", "SHOW",
  "TABLES", "TABLE", "DESCRIBE", "DROP", "CREATE", "INDEX", "INTERVAL",
  "APPEND", "';'", "'('", "')'", "'.'", "','", "'{'", "'}'", "':'",
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
     275,   276,   277,   278,   279,    33,   280,   281,   282,   124,
      38,   283,    43,    45,    42,    47,    37,   284,    94,   285,
     286,   287,   288,   289,   290,   291,   292,   293,   294,   295,
     296,   297,   298,   299,   300,   301,   302,   303,   304,   305,
     306,   307,   308,   309,   310,   311,   312,   313,   314,   315,
     316,   317,   318,   319,   320,   321,   322,   323,   324,   325,
     326,   327,   328,   329,   330,   331,   332,   333,    59,    40,
      41,    46,    44,   123,   125,    58
};
# endif

/* YYR1[YYN] -- Symbol number of symbol that rule YYN derives.  */
static const yytype_uint8 yyr1[] =
{
       0,    96,    97,    97,    98,    99,    99,    99,    99,    99,
      99,    99,    99,    99,    99,    99,    99,    99,    99,    99,
      99,    99,   100,   100,   100,   100,   100,   100,   100,   100,
     100,   100,   100,   100,   100,   100,   100,   100,   100,   100,
     100,   100,   100,   100,   100,   100,   100,   100,   100,   100,
     100,   100,   100,   100,   100,   100,   100,   100,   100,   100,
     100,   100,   100,   100,   100,   101,   101,   102,   102,   102,
     103,   103,   104,   104,   105,   105,   106,   107,   107,   107,
     107,   107,   107,   107,   107,   107,   107,   107,   107,   107,
     107,   107,   107,   108,   108,   109,   109,   109,   109
};

/* YYR2[YYN] -- Number of symbols composing right hand side of rule YYN.  */
static const yytype_uint8 yyr2[] =
{
       0,     2,     2,     3,     1,     7,    12,     5,     6,     8,
       9,     7,     8,     2,     7,     5,     7,     2,     3,    22,
       8,    10,     1,     3,     1,     1,     1,     1,     1,     1,
      11,     9,     6,     2,     2,     4,     4,     4,     4,     4,
       2,     4,     4,     4,     3,     3,     3,     3,     3,     3,
       3,     3,     3,     3,     3,     3,     2,     2,     3,     3,
       5,     3,     8,     3,     4,     0,     3,     3,     5,     1,
       1,     3,     1,     3,     0,     1,     2,     4,     6,     6,
       6,     5,     5,     6,     5,     5,     7,     7,     6,     7,
       6,     7,     6,     0,     2,     0,     4,     7,     3
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
       0,     0,     0,    69,     0,     0,     0,     0,     0,     0,
       0,     0,     0,     0,     0,    93,     0,     0,     0,     0,
       0,     0,     7,    33,    34,     0,     0,    40,     0,     0,
       0,    57,    56,     0,     0,     0,     0,     0,     0,     0,
       0,     0,     0,     0,     0,     0,     0,     0,     0,     0,
       0,     0,     0,     0,     0,     0,     0,     0,    74,    15,
       0,     0,    93,     0,     0,     0,     0,     0,     0,    76,
      23,     0,     0,     0,     0,     0,     0,     0,     0,     0,
       0,    61,    51,    52,    53,    54,    50,    59,    63,     0,
       0,    58,    55,    44,    45,    46,    47,    48,    49,    67,
      65,     0,    72,    75,     8,     0,    94,     0,    95,     0,
      93,     0,     0,     0,     0,    41,    42,    43,    35,    36,
      37,    38,    39,     0,    64,    22,     0,     0,     0,     0,
       0,     0,     5,    65,     0,     0,     0,    95,     0,     0,
      11,    14,    16,     0,     0,     0,     0,     0,    60,     0,
       0,     0,     0,     0,     0,     0,     0,     0,     9,    68,
      73,    93,    12,     0,     0,    20,     0,     0,     0,    32,
       0,     0,    66,     0,     0,     0,     0,     0,     0,     0,
      10,     0,    98,     0,     0,     0,     0,     0,    77,     0,
       0,     0,     0,     0,     0,     0,    96,     0,    21,    70,
       0,     0,    62,    85,    81,     0,     0,    82,     0,     0,
      84,     0,     0,     6,     0,    31,     0,    88,    80,    78,
      90,    83,    79,    92,     0,     0,    71,     0,    89,    86,
      91,    87,    97,     0,    30,     0,     0,     0,     0,     0,
       0,     0,     0,    19
};

/* YYDEFGOTO[NTERM-NUM].  */
static const yytype_int16 yydefgoto[] =
{
      -1,    10,    11,    12,   152,   182,    62,   250,   153,   154,
      72,   183,   113,   190
};

/* YYPACT[STATE-NUM] -- Index in YYTABLE of the portion describing
   STATE-NUM.  */
#define YYPACT_NINF -180
static const yytype_int16 yypact[] =
{
     255,     0,   -17,    21,   -15,    36,    -3,    84,    11,   -40,
     282,   -10,  -180,    49,    94,    69,   113,    64,  -180,  -180,
     116,   126,   131,  -180,    48,  -180,   134,   135,   163,   137,
      66,   139,    95,    55,  -180,    86,    88,  -180,    97,   109,
     -49,  -180,  -180,  -180,  -180,  -180,  -180,   236,    65,    67,
      68,   236,   236,  -180,    72,    73,    75,    77,    85,    78,
     236,    91,   -31,   120,   236,   -50,   163,   172,   173,   174,
      87,   236,  -180,  -180,  -180,   180,   179,   875,   236,   236,
     236,   270,   270,   236,   236,   236,   236,   236,   236,   381,
     236,   236,   236,   236,   236,   236,     9,   259,   236,   236,
     236,   236,   236,   236,   236,   182,   183,   236,   236,   789,
     101,   185,   140,   133,   -24,   106,   111,   114,   199,   789,
    -180,   110,   407,   441,   467,   493,   527,   553,   579,   613,
     692,  -180,   789,   814,   837,   859,   875,   891,  -180,   197,
      76,   309,   238,    74,    74,  -180,  -180,  -180,  -180,  -180,
     -34,   761,   355,  -180,  -180,   203,  -180,   147,   -53,   211,
     140,   218,   219,   136,   129,  -180,  -180,  -180,  -180,  -180,
    -180,  -180,  -180,   236,  -180,    -4,   142,   221,   186,   -39,
     -32,   189,  -180,   187,   231,   236,   148,   -53,   171,   204,
    -180,  -180,  -180,   -37,   156,   200,   246,   665,  -180,   191,
     236,   253,   214,   216,   276,   237,   239,   283,  -180,  -180,
    -180,   140,  -180,   245,   286,  -180,   292,   293,   210,   220,
     236,   236,  -180,   248,   307,   314,   260,   315,   317,   263,
    -180,   320,  -180,   223,   240,   236,   323,   639,   718,   236,
     271,   272,   236,   275,   287,   236,   266,   310,  -180,   789,
     -72,   -51,  -180,  -180,   718,   236,   236,   718,   236,   236,
     718,   308,   346,  -180,   236,  -180,   348,  -180,   718,   718,
    -180,   718,   718,  -180,   350,   265,   789,   262,  -180,  -180,
    -180,  -180,  -180,   354,  -180,   288,   358,   268,   359,   360,
     369,   284,   370,  -180
};

/* YYPGOTO[NTERM-NUM].  */
static const yytype_int16 yypgoto[] =
{
    -180,  -180,   366,   241,   -28,   196,   316,  -180,  -179,  -180,
    -180,   -59,  -111,   193
};

/* YYTABLE[YYPACT[STATE-NUM]].  What to do in state STATE-NUM.  If
   positive, shift that token.  If negative, reduce the rule which
   number is the opposite.  If zero, do what YYDEFACT says.
   If YYTABLE_NINF, syntax error.  */
#define YYTABLE_NINF -1
static const yytype_int16 yytable[] =
{
      61,   157,    73,    74,   110,   201,   210,    13,   106,   111,
     177,    13,   204,   178,   188,   159,   189,   138,   263,    77,
     264,   222,    14,    81,    82,    15,   202,   203,   179,   180,
     181,    16,    89,   205,   206,   139,   109,   112,    61,   265,
      17,   266,    75,   119,    76,    21,    22,    73,    74,   192,
     122,   123,   124,   215,   216,   125,   126,   127,   128,   129,
     130,   107,   132,   133,   134,   135,   136,   137,   107,   141,
     142,   143,   144,   145,   146,   147,   148,    18,    25,   151,
     175,    41,    42,    43,    44,    45,    46,    75,    19,    76,
      26,    27,    20,    47,    48,    49,    50,    28,    30,    29,
     230,    51,    52,    90,    91,    92,    93,    94,   101,   102,
     103,   104,    89,    95,    96,    31,     2,    32,    33,    97,
      34,     3,    98,    99,   100,   101,   102,   103,   104,    54,
      35,    55,    56,    57,    58,    36,    37,    38,    64,    39,
     105,    63,    65,    66,    67,   197,    68,     4,    69,     5,
      59,    70,    71,    88,    78,     6,    79,    80,     7,     8,
       9,    83,    84,   108,    85,    60,    86,    40,    41,    42,
      43,    44,    45,    46,    87,   115,   118,   116,   117,   253,
      47,    48,    49,    50,   120,   121,   149,   150,    51,    52,
     155,   156,   237,   238,   158,   267,   160,    53,   270,   111,
     161,   273,   163,   162,   164,   174,   186,   249,   187,   278,
     279,   254,   280,   281,   257,   191,    54,   260,    55,    56,
      57,    58,   193,   194,   196,   199,   195,   268,   269,   200,
     271,   272,   198,   207,   178,   209,   276,    59,   211,   213,
      40,    41,    42,    43,    44,    45,    46,   214,   217,   218,
     219,   221,    60,    47,    48,    49,    50,   223,   224,     1,
     225,    51,    52,    40,    41,    42,    43,    44,    45,    46,
      99,   100,   101,   102,   103,   104,    47,    48,    49,    50,
     226,   227,    23,   228,    51,    52,     1,   229,   231,    54,
     232,    55,    56,    57,    58,     2,   233,   234,    97,   235,
       3,    98,    99,   100,   101,   102,   103,   104,   239,   236,
      59,   240,    54,   247,    55,    56,    57,    58,   241,   243,
     242,   244,     2,   245,   246,    60,     4,     3,     5,   251,
     248,   255,   256,    59,     6,   258,   261,     7,     8,     9,
      98,    99,   100,   101,   102,   103,   104,   259,   140,   262,
     275,   274,   284,     4,   277,     5,   282,   283,   285,   288,
     286,     6,   287,   289,     7,     8,     9,    90,    91,    92,
      93,    94,   290,   291,   293,   292,    24,    95,    96,   208,
     212,   176,   114,    97,     0,     0,    98,    99,   100,   101,
     102,   103,   104,    90,    91,    92,    93,    94,     0,     0,
       0,     0,     0,    95,    96,     0,     0,     0,     0,    97,
       0,     0,    98,    99,   100,   101,   102,   103,   104,    90,
      91,    92,    93,    94,     0,     0,     0,     0,     0,    95,
      96,     0,     0,     0,     0,    97,     0,     0,    98,    99,
     100,   101,   102,   103,   104,     0,     0,   185,     0,     0,
       0,     0,     0,    90,    91,    92,    93,    94,     0,     0,
       0,     0,     0,    95,    96,     0,     0,     0,     0,    97,
       0,   131,    98,    99,   100,   101,   102,   103,   104,    90,
      91,    92,    93,    94,     0,     0,     0,     0,     0,    95,
      96,     0,     0,     0,     0,    97,     0,   165,    98,    99,
     100,   101,   102,   103,   104,    90,    91,    92,    93,    94,
       0,     0,     0,     0,     0,    95,    96,     0,     0,     0,
       0,    97,     0,     0,    98,    99,   100,   101,   102,   103,
     104,   166,     0,     0,     0,     0,     0,     0,     0,    90,
      91,    92,    93,    94,     0,     0,     0,     0,     0,    95,
      96,     0,     0,     0,     0,    97,     0,   167,    98,    99,
     100,   101,   102,   103,   104,    90,    91,    92,    93,    94,
       0,     0,     0,     0,     0,    95,    96,     0,     0,     0,
       0,    97,     0,   168,    98,    99,   100,   101,   102,   103,
     104,    90,    91,    92,    93,    94,     0,     0,     0,     0,
       0,    95,    96,     0,     0,     0,     0,    97,     0,     0,
      98,    99,   100,   101,   102,   103,   104,   169,     0,     0,
       0,     0,     0,     0,     0,    90,    91,    92,    93,    94,
       0,     0,     0,     0,     0,    95,    96,     0,     0,     0,
       0,    97,     0,   170,    98,    99,   100,   101,   102,   103,
     104,    90,    91,    92,    93,    94,     0,     0,     0,     0,
       0,    95,    96,     0,     0,     0,     0,    97,     0,   171,
      98,    99,   100,   101,   102,   103,   104,    90,    91,    92,
      93,    94,     0,     0,     0,     0,     0,    95,    96,     0,
       0,     0,     0,    97,     0,     0,    98,    99,   100,   101,
     102,   103,   104,   172,    90,    91,    92,    93,    94,     0,
       0,     0,     0,     0,    95,    96,     0,   252,     0,     0,
      97,     0,     0,    98,    99,   100,   101,   102,   103,   104,
      90,    91,    92,    93,    94,     0,     0,     0,     0,     0,
      95,    96,   220,     0,     0,     0,    97,     0,     0,    98,
      99,   100,   101,   102,   103,   104,     0,     0,     0,     0,
       0,     0,   177,     0,     0,     0,     0,     0,   173,     0,
       0,     0,     0,    90,    91,    92,    93,    94,     0,     0,
     179,   180,   181,    95,    96,     0,     0,     0,     0,    97,
       0,     0,    98,    99,   100,   101,   102,   103,   104,     0,
       0,    90,    91,    92,    93,    94,     0,     0,     0,     0,
     184,    95,    96,     0,     0,     0,     0,    97,     0,     0,
      98,    99,   100,   101,   102,   103,   104,    91,    92,    93,
      94,     0,     0,     0,     0,     0,    95,    96,     0,     0,
       0,     0,    97,     0,     0,    98,    99,   100,   101,   102,
     103,   104,    93,    94,     0,     0,     0,     0,     0,    95,
      96,     0,     0,     0,     0,    97,     0,     0,    98,    99,
     100,   101,   102,   103,   104,    94,     0,     0,     0,     0,
       0,    95,    96,     0,     0,     0,     0,    97,     0,     0,
      98,    99,   100,   101,   102,   103,   104,    95,    96,     0,
       0,     0,     0,    97,     0,     0,    98,    99,   100,   101,
     102,   103,   104,    -1,    -1,     0,     0,     0,     0,    97,
       0,     0,    98,    99,   100,   101,   102,   103,   104
};

static const yytype_int16 yycheck[] =
{
      28,   112,    51,    52,    54,    44,   185,    11,    39,    59,
      44,    11,    44,    47,    67,    39,    69,     8,    90,    47,
      92,   200,    39,    51,    52,     4,    65,    66,    62,    63,
      64,    46,    60,    65,    66,    26,    64,    87,    66,    90,
       4,    92,    91,    71,    93,    85,    86,    51,    52,   160,
      78,    79,    80,    90,    91,    83,    84,    85,    86,    87,
      88,    92,    90,    91,    92,    93,    94,    95,    92,    97,
      98,    99,   100,   101,   102,   103,   104,    80,    88,   107,
       4,     5,     6,     7,     8,     9,    10,    91,     4,    93,
      41,    42,    81,    17,    18,    19,    20,    48,     4,    50,
     211,    25,    26,    12,    13,    14,    15,    16,    34,    35,
      36,    37,   140,    22,    23,    46,    40,     4,    54,    28,
       4,    45,    31,    32,    33,    34,    35,    36,    37,    53,
       4,    55,    56,    57,    58,     4,    88,     3,    72,     4,
      49,     4,     3,    48,    89,   173,    60,    71,    60,    73,
      74,    54,    43,    75,    89,    79,    89,    89,    82,    83,
      84,    89,    89,    43,    89,    89,    89,     4,     5,     6,
       7,     8,     9,    10,    89,     3,    89,     4,     4,   238,
      17,    18,    19,    20,     4,     6,     4,     4,    25,    26,
      89,     6,   220,   221,    61,   254,    90,    34,   257,    59,
      89,   260,     3,    89,    94,     8,     3,   235,    61,   268,
     269,   239,   271,   272,   242,     4,    53,   245,    55,    56,
      57,    58,     4,     4,    95,     4,    90,   255,   256,    43,
     258,   259,    90,    44,    47,     4,   264,    74,    90,    68,
       4,     5,     6,     7,     8,     9,    10,    43,    92,    49,
       4,    60,    89,    17,    18,    19,    20,     4,    44,     4,
      44,    25,    26,     4,     5,     6,     7,     8,     9,    10,
      32,    33,    34,    35,    36,    37,    17,    18,    19,    20,
       4,    44,     0,    44,    25,    26,     4,     4,    43,    53,
       4,    55,    56,    57,    58,    40,     4,     4,    28,    89,
      45,    31,    32,    33,    34,    35,    36,    37,    60,    89,
      74,     4,    53,    90,    55,    56,    57,    58,     4,     4,
      60,     4,    40,    60,     4,    89,    71,    45,    73,     6,
      90,    60,    60,    74,    79,    60,    70,    82,    83,    84,
      31,    32,    33,    34,    35,    36,    37,    60,    89,    39,
       4,    43,    90,    71,     6,    73,     6,    92,     4,    91,
      72,    79,     4,     4,    82,    83,    84,    12,    13,    14,
      15,    16,    12,     4,     4,    91,    10,    22,    23,   183,
     187,   140,    66,    28,    -1,    -1,    31,    32,    33,    34,
      35,    36,    37,    12,    13,    14,    15,    16,    -1,    -1,
      -1,    -1,    -1,    22,    23,    -1,    -1,    -1,    -1,    28,
      -1,    -1,    31,    32,    33,    34,    35,    36,    37,    12,
      13,    14,    15,    16,    -1,    -1,    -1,    -1,    -1,    22,
      23,    -1,    -1,    -1,    -1,    28,    -1,    -1,    31,    32,
      33,    34,    35,    36,    37,    -1,    -1,    92,    -1,    -1,
      -1,    -1,    -1,    12,    13,    14,    15,    16,    -1,    -1,
      -1,    -1,    -1,    22,    23,    -1,    -1,    -1,    -1,    28,
      -1,    90,    31,    32,    33,    34,    35,    36,    37,    12,
      13,    14,    15,    16,    -1,    -1,    -1,    -1,    -1,    22,
      23,    -1,    -1,    -1,    -1,    28,    -1,    90,    31,    32,
      33,    34,    35,    36,    37,    12,    13,    14,    15,    16,
      -1,    -1,    -1,    -1,    -1,    22,    23,    -1,    -1,    -1,
      -1,    28,    -1,    -1,    31,    32,    33,    34,    35,    36,
      37,    90,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    12,
      13,    14,    15,    16,    -1,    -1,    -1,    -1,    -1,    22,
      23,    -1,    -1,    -1,    -1,    28,    -1,    90,    31,    32,
      33,    34,    35,    36,    37,    12,    13,    14,    15,    16,
      -1,    -1,    -1,    -1,    -1,    22,    23,    -1,    -1,    -1,
      -1,    28,    -1,    90,    31,    32,    33,    34,    35,    36,
      37,    12,    13,    14,    15,    16,    -1,    -1,    -1,    -1,
      -1,    22,    23,    -1,    -1,    -1,    -1,    28,    -1,    -1,
      31,    32,    33,    34,    35,    36,    37,    90,    -1,    -1,
      -1,    -1,    -1,    -1,    -1,    12,    13,    14,    15,    16,
      -1,    -1,    -1,    -1,    -1,    22,    23,    -1,    -1,    -1,
      -1,    28,    -1,    90,    31,    32,    33,    34,    35,    36,
      37,    12,    13,    14,    15,    16,    -1,    -1,    -1,    -1,
      -1,    22,    23,    -1,    -1,    -1,    -1,    28,    -1,    90,
      31,    32,    33,    34,    35,    36,    37,    12,    13,    14,
      15,    16,    -1,    -1,    -1,    -1,    -1,    22,    23,    -1,
      -1,    -1,    -1,    28,    -1,    -1,    31,    32,    33,    34,
      35,    36,    37,    90,    12,    13,    14,    15,    16,    -1,
      -1,    -1,    -1,    -1,    22,    23,    -1,    78,    -1,    -1,
      28,    -1,    -1,    31,    32,    33,    34,    35,    36,    37,
      12,    13,    14,    15,    16,    -1,    -1,    -1,    -1,    -1,
      22,    23,    77,    -1,    -1,    -1,    28,    -1,    -1,    31,
      32,    33,    34,    35,    36,    37,    -1,    -1,    -1,    -1,
      -1,    -1,    44,    -1,    -1,    -1,    -1,    -1,    76,    -1,
      -1,    -1,    -1,    12,    13,    14,    15,    16,    -1,    -1,
      62,    63,    64,    22,    23,    -1,    -1,    -1,    -1,    28,
      -1,    -1,    31,    32,    33,    34,    35,    36,    37,    -1,
      -1,    12,    13,    14,    15,    16,    -1,    -1,    -1,    -1,
      49,    22,    23,    -1,    -1,    -1,    -1,    28,    -1,    -1,
      31,    32,    33,    34,    35,    36,    37,    13,    14,    15,
      16,    -1,    -1,    -1,    -1,    -1,    22,    23,    -1,    -1,
      -1,    -1,    28,    -1,    -1,    31,    32,    33,    34,    35,
      36,    37,    15,    16,    -1,    -1,    -1,    -1,    -1,    22,
      23,    -1,    -1,    -1,    -1,    28,    -1,    -1,    31,    32,
      33,    34,    35,    36,    37,    16,    -1,    -1,    -1,    -1,
      -1,    22,    23,    -1,    -1,    -1,    -1,    28,    -1,    -1,
      31,    32,    33,    34,    35,    36,    37,    22,    23,    -1,
      -1,    -1,    -1,    28,    -1,    -1,    31,    32,    33,    34,
      35,    36,    37,    22,    23,    -1,    -1,    -1,    -1,    28,
      -1,    -1,    31,    32,    33,    34,    35,    36,    37
};

/* YYSTOS[STATE-NUM] -- The (internal number of the) accessing
   symbol of state STATE-NUM.  */
static const yytype_uint8 yystos[] =
{
       0,     4,    40,    45,    71,    73,    79,    82,    83,    84,
      97,    98,    99,    11,    39,     4,    46,     4,    80,     4,
      81,    85,    86,     0,    98,    88,    41,    42,    48,    50,
       4,    46,     4,    54,     4,     4,     4,    88,     3,     4,
       4,     5,     6,     7,     8,     9,    10,    17,    18,    19,
      20,    25,    26,    34,    53,    55,    56,    57,    58,    74,
      89,   100,   102,     4,    72,     3,    48,    89,    60,    60,
      54,    43,   106,    51,    52,    91,    93,   100,    89,    89,
      89,   100,   100,    89,    89,    89,    89,    89,    75,   100,
      12,    13,    14,    15,    16,    22,    23,    28,    31,    32,
      33,    34,    35,    36,    37,    49,    39,    92,    43,   100,
      54,    59,    87,   108,   102,     3,     4,     4,    89,   100,
       4,     6,   100,   100,   100,   100,   100,   100,   100,   100,
     100,    90,   100,   100,   100,   100,   100,   100,     8,    26,
      89,   100,   100,   100,   100,   100,   100,   100,   100,     4,
       4,   100,   100,   104,   105,    89,     6,   108,    61,    39,
      90,    89,    89,     3,    94,    90,    90,    90,    90,    90,
      90,    90,    90,    76,     8,     4,    99,    44,    47,    62,
      63,    64,   101,   107,    49,    92,     3,    61,    67,    69,
     109,     4,   108,     4,     4,    90,    95,   100,    90,     4,
      43,    44,    65,    66,    44,    65,    66,    44,   101,     4,
     104,    90,   109,    68,    43,    90,    91,    92,    49,     4,
      77,    60,   104,     4,    44,    44,     4,    44,    44,     4,
     108,    43,     4,     4,     4,    89,    89,   100,   100,    60,
       4,     4,    60,     4,     4,    60,     4,    90,    90,   100,
     103,     6,    78,   107,   100,    60,    60,   100,    60,    60,
     100,    70,    39,    90,    92,    90,    92,   107,   100,   100,
     107,   100,   100,   107,    43,     4,   100,     6,   107,   107,
     107,   107,     6,    92,    90,     4,    72,     4,    91,     4,
      12,     4,    91,     4
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
#line 133 "bison.y"
    { emit("STMT"); ;}
    break;

  case 5:

/* Line 1455 of yacc.c  */
#line 137 "bison.y"
    { emit_select((yyvsp[(1) - (7)].strval), (yyvsp[(6) - (7)].strval), (yyvsp[(7) - (7)].intval)); ;}
    break;

  case 6:

/* Line 1455 of yacc.c  */
#line 139 "bison.y"
    {  emit_load((yyvsp[(1) - (12)].strval), (yyvsp[(4) - (12)].strval), (yyvsp[(11) - (12)].intval), (yyvsp[(7) - (12)].strval)); ;}
    break;

  case 7:

/* Line 1455 of yacc.c  */
#line 141 "bison.y"
    {  emit_filter((yyvsp[(1) - (5)].strval), (yyvsp[(4) - (5)].strval));;}
    break;

  case 8:

/* Line 1455 of yacc.c  */
#line 143 "bison.y"
    {  emit_order((yyvsp[(1) - (6)].strval), (yyvsp[(4) - (6)].strval), (yyvsp[(6) - (6)].intval));;}
    break;

  case 9:

/* Line 1455 of yacc.c  */
#line 145 "bison.y"
    {  emit_join((yyvsp[(1) - (8)].strval),(yyvsp[(6) - (8)].strval),(yyvsp[(7) - (8)].intval),0,-1); ;}
    break;

  case 10:

/* Line 1455 of yacc.c  */
#line 147 "bison.y"
    {  emit_store((yyvsp[(2) - (9)].strval),(yyvsp[(4) - (9)].strval),(yyvsp[(7) - (9)].strval)); ;}
    break;

  case 11:

/* Line 1455 of yacc.c  */
#line 149 "bison.y"
    {  emit_store_binary((yyvsp[(2) - (7)].strval),(yyvsp[(4) - (7)].strval),0); ;}
    break;

  case 12:

/* Line 1455 of yacc.c  */
#line 151 "bison.y"
    {  emit_store_binary((yyvsp[(2) - (8)].strval),(yyvsp[(4) - (8)].strval),1); ;}
    break;

  case 13:

/* Line 1455 of yacc.c  */
#line 153 "bison.y"
    {  emit_describe_table((yyvsp[(2) - (2)].strval));;}
    break;

  case 14:

/* Line 1455 of yacc.c  */
#line 155 "bison.y"
    {  emit_insert((yyvsp[(3) - (7)].strval), (yyvsp[(7) - (7)].strval));;}
    break;

  case 15:

/* Line 1455 of yacc.c  */
#line 157 "bison.y"
    {  emit_delete((yyvsp[(3) - (5)].strval));;}
    break;

  case 16:

/* Line 1455 of yacc.c  */
#line 159 "bison.y"
    {  emit_display((yyvsp[(2) - (7)].strval), (yyvsp[(5) - (7)].strval));;}
    break;

  case 17:

/* Line 1455 of yacc.c  */
#line 161 "bison.y"
    {  emit_show_tables();;}
    break;

  case 18:

/* Line 1455 of yacc.c  */
#line 163 "bison.y"
    {  emit_drop_table((yyvsp[(3) - (3)].strval));;}
    break;

  case 19:

/* Line 1455 of yacc.c  */
#line 165 "bison.y"
    {  emit_create_bitmap_index((yyvsp[(3) - (22)].strval), (yyvsp[(5) - (22)].strval), (yyvsp[(7) - (22)].strval), (yyvsp[(9) - (22)].strval), (yyvsp[(18) - (22)].strval), (yyvsp[(22) - (22)].strval));;}
    break;

  case 20:

/* Line 1455 of yacc.c  */
#line 167 "bison.y"
    {  emit_create_index((yyvsp[(3) - (8)].strval), (yyvsp[(5) - (8)].strval), (yyvsp[(7) - (8)].strval));;}
    break;

  case 21:

/* Line 1455 of yacc.c  */
#line 169 "bison.y"
    {  emit_create_interval((yyvsp[(3) - (10)].strval), (yyvsp[(5) - (10)].strval), (yyvsp[(7) - (10)].strval), (yyvsp[(9) - (10)].strval));;}
    break;

  case 22:

/* Line 1455 of yacc.c  */
#line 174 "bison.y"
    { emit_name((yyvsp[(1) - (1)].strval)); ;}
    break;

  case 23:

/* Line 1455 of yacc.c  */
#line 175 "bison.y"
    { emit_fieldname((yyvsp[(1) - (3)].strval), (yyvsp[(3) - (3)].strval)); ;}
    break;

  case 24:

/* Line 1455 of yacc.c  */
#line 176 "bison.y"
    { emit("USERVAR %s", (yyvsp[(1) - (1)].strval)); ;}
    break;

  case 25:

/* Line 1455 of yacc.c  */
#line 177 "bison.y"
    { emit_string((yyvsp[(1) - (1)].strval)); ;}
    break;

  case 26:

/* Line 1455 of yacc.c  */
#line 178 "bison.y"
    { emit_number((yyvsp[(1) - (1)].intval)); ;}
    break;

  case 27:

/* Line 1455 of yacc.c  */
#line 179 "bison.y"
    { emit_decimal((yyvsp[(1) - (1)].strval)); ;}
    break;

  case 28:

/* Line 1455 of yacc.c  */
#line 180 "bison.y"
    { emit_float((yyvsp[(1) - (1)].floatval)); ;}
    break;

  case 29:

/* Line 1455 of yacc.c  */
#line 181 "bison.y"
    { emit("BOOL %d", (yyvsp[(1) - (1)].intval)); ;}
    break;

  case 30:

/* Line 1455 of yacc.c  */
#line 182 "bison.y"
    { emit_vardecimal((yyvsp[(1) - (11)].strval), (yyvsp[(3) - (11)].intval), (yyvsp[(6) - (11)].strval),  (yyvsp[(8) - (11)].intval), (yyvsp[(10) - (11)].intval));;}
    break;

  case 31:

/* Line 1455 of yacc.c  */
#line 183 "bison.y"
    { emit_varchar((yyvsp[(1) - (9)].strval), (yyvsp[(3) - (9)].intval), (yyvsp[(6) - (9)].strval), (yyvsp[(8) - (9)].intval), "", "");;}
    break;

  case 32:

/* Line 1455 of yacc.c  */
#line 184 "bison.y"
    { emit_var((yyvsp[(1) - (6)].strval), (yyvsp[(3) - (6)].intval), (yyvsp[(6) - (6)].strval), "", "");;}
    break;

  case 33:

/* Line 1455 of yacc.c  */
#line 185 "bison.y"
    { emit_var_asc((yyvsp[(1) - (2)].strval));;}
    break;

  case 34:

/* Line 1455 of yacc.c  */
#line 186 "bison.y"
    { emit_var_desc((yyvsp[(1) - (2)].strval));;}
    break;

  case 35:

/* Line 1455 of yacc.c  */
#line 187 "bison.y"
    { emit_count(); ;}
    break;

  case 36:

/* Line 1455 of yacc.c  */
#line 188 "bison.y"
    { emit_sum(); ;}
    break;

  case 37:

/* Line 1455 of yacc.c  */
#line 189 "bison.y"
    { emit_average(); ;}
    break;

  case 38:

/* Line 1455 of yacc.c  */
#line 190 "bison.y"
    { emit_min(); ;}
    break;

  case 39:

/* Line 1455 of yacc.c  */
#line 191 "bison.y"
    { emit_max(); ;}
    break;

  case 40:

/* Line 1455 of yacc.c  */
#line 192 "bison.y"
    { emit_distinct(); ;}
    break;

  case 41:

/* Line 1455 of yacc.c  */
#line 193 "bison.y"
    { emit_year(); ;}
    break;

  case 42:

/* Line 1455 of yacc.c  */
#line 194 "bison.y"
    { emit_month(); ;}
    break;

  case 43:

/* Line 1455 of yacc.c  */
#line 195 "bison.y"
    { emit_day(); ;}
    break;

  case 44:

/* Line 1455 of yacc.c  */
#line 199 "bison.y"
    { emit_add(); ;}
    break;

  case 45:

/* Line 1455 of yacc.c  */
#line 200 "bison.y"
    { emit_minus(); ;}
    break;

  case 46:

/* Line 1455 of yacc.c  */
#line 201 "bison.y"
    { emit_mul(); ;}
    break;

  case 47:

/* Line 1455 of yacc.c  */
#line 202 "bison.y"
    { emit_div(); ;}
    break;

  case 48:

/* Line 1455 of yacc.c  */
#line 203 "bison.y"
    { emit("MOD"); ;}
    break;

  case 49:

/* Line 1455 of yacc.c  */
#line 204 "bison.y"
    { emit("MOD"); ;}
    break;

  case 50:

/* Line 1455 of yacc.c  */
#line 205 "bison.y"
    { emit_and(); ;}
    break;

  case 51:

/* Line 1455 of yacc.c  */
#line 206 "bison.y"
    { emit_eq(); ;}
    break;

  case 52:

/* Line 1455 of yacc.c  */
#line 207 "bison.y"
    { emit_neq(); ;}
    break;

  case 53:

/* Line 1455 of yacc.c  */
#line 208 "bison.y"
    { emit_or(); ;}
    break;

  case 54:

/* Line 1455 of yacc.c  */
#line 209 "bison.y"
    { emit("XOR"); ;}
    break;

  case 55:

/* Line 1455 of yacc.c  */
#line 210 "bison.y"
    { emit("SHIFT %s", (yyvsp[(2) - (3)].subtok)==1?"left":"right"); ;}
    break;

  case 56:

/* Line 1455 of yacc.c  */
#line 211 "bison.y"
    { emit("NOT"); ;}
    break;

  case 57:

/* Line 1455 of yacc.c  */
#line 212 "bison.y"
    { emit("NOT"); ;}
    break;

  case 58:

/* Line 1455 of yacc.c  */
#line 213 "bison.y"
    { emit_cmp((yyvsp[(2) - (3)].subtok)); ;}
    break;

  case 59:

/* Line 1455 of yacc.c  */
#line 214 "bison.y"
    { emit_cmp(7); ;}
    break;

  case 60:

/* Line 1455 of yacc.c  */
#line 216 "bison.y"
    { emit("CMPSELECT %d", (yyvsp[(2) - (5)].subtok)); ;}
    break;

  case 61:

/* Line 1455 of yacc.c  */
#line 217 "bison.y"
    {emit("EXPR");;}
    break;

  case 62:

/* Line 1455 of yacc.c  */
#line 218 "bison.y"
    { emit_case(); ;}
    break;

  case 63:

/* Line 1455 of yacc.c  */
#line 222 "bison.y"
    { emit("ISBOOL %d", (yyvsp[(3) - (3)].intval)); ;}
    break;

  case 64:

/* Line 1455 of yacc.c  */
#line 223 "bison.y"
    { emit("ISBOOL %d", (yyvsp[(4) - (4)].intval)); emit("NOT"); ;}
    break;

  case 65:

/* Line 1455 of yacc.c  */
#line 226 "bison.y"
    { /* nil */
    (yyval.intval) = 0;
;}
    break;

  case 66:

/* Line 1455 of yacc.c  */
#line 229 "bison.y"
    { (yyval.intval) = (yyvsp[(3) - (3)].intval);;}
    break;

  case 67:

/* Line 1455 of yacc.c  */
#line 233 "bison.y"
    { (yyval.intval) = 1; emit_sel_name((yyvsp[(3) - (3)].strval));;}
    break;

  case 68:

/* Line 1455 of yacc.c  */
#line 234 "bison.y"
    { (yyval.intval) = (yyvsp[(1) - (5)].intval) + 1; emit_sel_name((yyvsp[(5) - (5)].strval));;}
    break;

  case 69:

/* Line 1455 of yacc.c  */
#line 235 "bison.y"
    { emit_sel_name("*");;}
    break;

  case 70:

/* Line 1455 of yacc.c  */
#line 239 "bison.y"
    { (yyval.intval) = 1; ;}
    break;

  case 71:

/* Line 1455 of yacc.c  */
#line 240 "bison.y"
    {(yyval.intval) = (yyvsp[(1) - (3)].intval) + 1; ;}
    break;

  case 72:

/* Line 1455 of yacc.c  */
#line 244 "bison.y"
    { (yyval.intval) = 1; ;}
    break;

  case 73:

/* Line 1455 of yacc.c  */
#line 245 "bison.y"
    { (yyval.intval) = 1 + (yyvsp[(3) - (3)].intval); ;}
    break;

  case 74:

/* Line 1455 of yacc.c  */
#line 248 "bison.y"
    { /* nil */
    (yyval.intval) = 0;
;}
    break;

  case 76:

/* Line 1455 of yacc.c  */
#line 253 "bison.y"
    { emit("FILTER BY"); ;}
    break;

  case 77:

/* Line 1455 of yacc.c  */
#line 257 "bison.y"
    { (yyval.intval) = 1; emit_join_tab((yyvsp[(2) - (4)].strval), 'I');;}
    break;

  case 78:

/* Line 1455 of yacc.c  */
#line 258 "bison.y"
    { (yyval.intval) = 1; emit_join_tab((yyvsp[(4) - (6)].strval), '3');;}
    break;

  case 79:

/* Line 1455 of yacc.c  */
#line 259 "bison.y"
    { (yyval.intval) = 1; emit_join_tab((yyvsp[(4) - (6)].strval), '4');;}
    break;

  case 80:

/* Line 1455 of yacc.c  */
#line 260 "bison.y"
    { (yyval.intval) = 1; emit_join_tab((yyvsp[(4) - (6)].strval), '1');;}
    break;

  case 81:

/* Line 1455 of yacc.c  */
#line 261 "bison.y"
    { (yyval.intval) = 1; emit_join_tab((yyvsp[(3) - (5)].strval), 'S');;}
    break;

  case 82:

/* Line 1455 of yacc.c  */
#line 262 "bison.y"
    { (yyval.intval) = 1; emit_join_tab((yyvsp[(3) - (5)].strval), 'R');;}
    break;

  case 83:

/* Line 1455 of yacc.c  */
#line 263 "bison.y"
    { (yyval.intval) = 1; emit_join_tab((yyvsp[(4) - (6)].strval), '2');;}
    break;

  case 84:

/* Line 1455 of yacc.c  */
#line 264 "bison.y"
    { (yyval.intval) = 1; emit_join_tab((yyvsp[(3) - (5)].strval), 'O');;}
    break;

  case 85:

/* Line 1455 of yacc.c  */
#line 265 "bison.y"
    { (yyval.intval) = 1; emit_join_tab((yyvsp[(2) - (5)].strval), 'I'); ;}
    break;

  case 86:

/* Line 1455 of yacc.c  */
#line 266 "bison.y"
    { (yyval.intval) = 1; emit_join_tab((yyvsp[(4) - (7)].strval), '3'); ;}
    break;

  case 87:

/* Line 1455 of yacc.c  */
#line 267 "bison.y"
    { (yyval.intval) = 1; emit_join_tab((yyvsp[(4) - (7)].strval), '4'); ;}
    break;

  case 88:

/* Line 1455 of yacc.c  */
#line 268 "bison.y"
    { (yyval.intval) = 1; emit_join_tab((yyvsp[(3) - (6)].strval), 'L'); ;}
    break;

  case 89:

/* Line 1455 of yacc.c  */
#line 269 "bison.y"
    { (yyval.intval) = 1; emit_join_tab((yyvsp[(4) - (7)].strval), '1'); ;}
    break;

  case 90:

/* Line 1455 of yacc.c  */
#line 270 "bison.y"
    { (yyval.intval) = 1; emit_join_tab((yyvsp[(3) - (6)].strval), 'R'); ;}
    break;

  case 91:

/* Line 1455 of yacc.c  */
#line 271 "bison.y"
    { (yyval.intval) = 1; emit_join_tab((yyvsp[(4) - (7)].strval), 'R'); ;}
    break;

  case 92:

/* Line 1455 of yacc.c  */
#line 272 "bison.y"
    { (yyval.intval) = 1; emit_join_tab((yyvsp[(3) - (6)].strval), 'O'); ;}
    break;

  case 93:

/* Line 1455 of yacc.c  */
#line 274 "bison.y"
    { /* nil */
    (yyval.intval) = 0;
;}
    break;

  case 94:

/* Line 1455 of yacc.c  */
#line 277 "bison.y"
    { emit_limit((yyvsp[(2) - (2)].intval)); ;}
    break;

  case 95:

/* Line 1455 of yacc.c  */
#line 279 "bison.y"
    { /* nil */
    (yyval.intval) = 0;
;}
    break;

  case 96:

/* Line 1455 of yacc.c  */
#line 282 "bison.y"
    { emit_sort((yyvsp[(4) - (4)].strval), 0); ;}
    break;

  case 97:

/* Line 1455 of yacc.c  */
#line 283 "bison.y"
    { emit_sort((yyvsp[(4) - (7)].strval), (yyvsp[(7) - (7)].intval)); ;}
    break;

  case 98:

/* Line 1455 of yacc.c  */
#line 284 "bison.y"
    { emit_presort((yyvsp[(3) - (3)].strval)); ;}
    break;



/* Line 1455 of yacc.c  */
#line 2451 "bison.cu"
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
			cout<< "disk time " << ( tot_disk / (double)CLOCKS_PER_SEC ) << " " << getFreeMem() << endl;
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
			filter_var.clear();
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
            //delete [] buffers[buffer_names.front()];
			cudaFreeHost(buffers[buffer_names.front()]);
            buffer_sizes.erase(buffer_names.front());
            buffers.erase(buffer_names.front());
            buffer_names.pop();
        };
		for(auto it = index_buffers.begin(); it != index_buffers.end();it++) {
			cudaFreeHost(it->second);
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



