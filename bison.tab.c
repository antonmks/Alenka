
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
     YEAR = 273,
     REGEXP = 274,
     LIKE = 275,
     IS = 276,
     IN = 277,
     NOT = 278,
     BETWEEN = 279,
     COMPARISON = 280,
     SHIFT = 281,
     MOD = 282,
     FROM = 283,
     MULITE = 284,
     DELETE = 285,
     LOAD = 286,
     FILTER = 287,
     BY = 288,
     JOIN = 289,
     STORE = 290,
     INTO = 291,
     GROUP = 292,
     SELECT = 293,
     AS = 294,
     ORDER = 295,
     ASC = 296,
     DESC = 297,
     COUNT = 298,
     USING = 299,
     SUM = 300,
     AVG = 301,
     MIN = 302,
     MAX = 303,
     LIMIT = 304,
     ON = 305,
     BINARY = 306,
     LEFT = 307,
     RIGHT = 308,
     OUTER = 309,
     SEMI = 310,
     ANTI = 311,
     SORT = 312,
     SEGMENTS = 313,
     PRESORTED = 314,
     PARTITION = 315,
     INSERT = 316,
     WHERE = 317,
     DISPLAY = 318,
     CASE = 319,
     WHEN = 320,
     THEN = 321,
     ELSE = 322,
     END = 323,
     SHOW = 324,
     TABLES = 325,
     TABLE = 326,
     DESCRIBE = 327,
     DROP = 328,
     CREATE = 329,
     INDEX = 330
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
#line 204 "bison.tab.c"
} YYSTYPE;
# define YYSTYPE_IS_TRIVIAL 1
# define yystype YYSTYPE /* obsolescent; will be withdrawn */
# define YYSTYPE_IS_DECLARED 1
#endif


/* Copy the second part of user declarations.  */


/* Line 264 of yacc.c  */
#line 216 "bison.tab.c"

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
#define YYFINAL  22
/* YYLAST -- Last index in YYTABLE.  */
#define YYLAST   789

/* YYNTOKENS -- Number of terminals.  */
#define YYNTOKENS  93
/* YYNNTS -- Number of nonterminals.  */
#define YYNNTS  14
/* YYNRULES -- Number of rules.  */
#define YYNRULES  93
/* YYNRULES -- Number of states.  */
#define YYNSTATES  272

/* YYTRANSLATE(YYLEX) -- Bison symbol number corresponding to YYLEX.  */
#define YYUNDEFTOK  2
#define YYMAXUTOK   330

#define YYTRANSLATE(YYX)						\
  ((unsigned int) (YYX) <= YYMAXUTOK ? yytranslate[YYX] : YYUNDEFTOK)

/* YYTRANSLATE[YYLEX] -- Bison symbol number corresponding to YYLEX.  */
static const yytype_uint8 yytranslate[] =
{
       0,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,    23,     2,     2,     2,    34,    28,     2,
      86,    87,    32,    30,    89,    31,    88,    33,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,    92,    85,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,    36,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,    90,    27,    91,     2,     2,     2,     2,
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
      15,    16,    17,    18,    19,    20,    21,    22,    24,    25,
      26,    29,    35,    37,    38,    39,    40,    41,    42,    43,
      44,    45,    46,    47,    48,    49,    50,    51,    52,    53,
      54,    55,    56,    57,    58,    59,    60,    61,    62,    63,
      64,    65,    66,    67,    68,    69,    70,    71,    72,    73,
      74,    75,    76,    77,    78,    79,    80,    81,    82,    83,
      84
};

#if YYDEBUG
/* YYPRHS[YYN] -- Index of the first RHS symbol of rule number YYN in
   YYRHS.  */
static const yytype_uint16 yyprhs[] =
{
       0,     0,     3,     6,    10,    12,    20,    33,    39,    46,
      55,    65,    73,    76,    84,    90,    98,   101,   105,   128,
     130,   134,   136,   138,   140,   142,   144,   146,   158,   168,
     175,   178,   181,   186,   191,   196,   201,   206,   209,   214,
     218,   222,   226,   230,   234,   238,   242,   246,   250,   254,
     258,   262,   265,   268,   272,   276,   282,   286,   295,   299,
     304,   305,   309,   313,   319,   321,   323,   327,   329,   333,
     334,   336,   339,   344,   351,   358,   365,   371,   377,   384,
     390,   396,   404,   412,   419,   427,   434,   442,   449,   450,
     453,   454,   459,   467
};

/* YYRHS -- A `-1'-separated list of the rules' RHS.  */
static const yytype_int8 yyrhs[] =
{
      94,     0,    -1,    95,    85,    -1,    94,    95,    85,    -1,
      96,    -1,     4,    11,    47,    99,    37,     4,    98,    -1,
       4,    11,    40,     3,    53,    86,     3,    87,    48,    86,
     100,    87,    -1,     4,    11,    41,     4,   103,    -1,     4,
      11,    49,     4,    42,   102,    -1,     4,    11,    47,    99,
      37,     4,   104,    98,    -1,    44,     4,    45,     3,    53,
      86,     3,    87,   105,    -1,    44,     4,    45,     3,   105,
      60,   106,    -1,    81,     4,    -1,    70,    45,     4,    47,
      99,    37,     4,    -1,    39,    37,     4,    71,    97,    -1,
      72,     4,    53,    86,     3,    87,   105,    -1,    78,    79,
      -1,    82,    80,     4,    -1,    83,    84,     4,    59,     4,
      86,     4,    88,     4,    87,    37,     4,    89,     4,    71,
       4,    88,     4,    12,     4,    88,     4,    -1,     4,    -1,
       4,    88,     4,    -1,    10,    -1,     5,    -1,     6,    -1,
       7,    -1,     9,    -1,     8,    -1,     4,    90,     6,    91,
      92,     4,    86,     6,    89,     6,    87,    -1,     4,    90,
       6,    91,    92,     4,    86,     6,    87,    -1,     4,    90,
       6,    91,    92,     4,    -1,     4,    50,    -1,     4,    51,
      -1,    52,    86,    97,    87,    -1,    54,    86,    97,    87,
      -1,    55,    86,    97,    87,    -1,    56,    86,    97,    87,
      -1,    57,    86,    97,    87,    -1,    17,    97,    -1,    18,
      86,    97,    87,    -1,    97,    30,    97,    -1,    97,    31,
      97,    -1,    97,    32,    97,    -1,    97,    33,    97,    -1,
      97,    34,    97,    -1,    97,    35,    97,    -1,    97,    16,
      97,    -1,    97,    12,    97,    -1,    97,    13,    97,    -1,
      97,    14,    97,    -1,    97,    15,    97,    -1,    97,    29,
      97,    -1,    24,    97,    -1,    23,    97,    -1,    97,    26,
      97,    -1,    97,    20,    97,    -1,    97,    26,    86,    96,
      87,    -1,    86,    97,    87,    -1,    73,    74,    97,    75,
      97,    76,    97,    77,    -1,    97,    21,     8,    -1,    97,
      21,    24,     8,    -1,    -1,    46,    42,   101,    -1,    97,
      48,     4,    -1,    99,    89,    97,    48,     4,    -1,    32,
      -1,    97,    -1,   100,    89,    97,    -1,    97,    -1,    97,
      89,   101,    -1,    -1,   101,    -1,    42,    97,    -1,    43,
       4,    59,    97,    -1,    65,    43,    61,     4,    59,    97,
      -1,    65,    43,    62,     4,    59,    97,    -1,    61,    64,
      43,     4,    59,    97,    -1,    61,    43,     4,    59,    97,
      -1,    62,    43,     4,    59,    97,    -1,    62,    64,    43,
       4,    59,    97,    -1,    63,    43,     4,    59,    97,    -1,
      43,     4,    59,    97,   104,    -1,    65,    43,    61,     4,
      59,    97,   104,    -1,    65,    43,    62,     4,    59,    97,
     104,    -1,    61,    43,     4,    59,    97,   104,    -1,    61,
      64,    43,     4,    59,    97,   104,    -1,    62,    43,     4,
      59,    97,   104,    -1,    62,    64,    43,     4,    59,    97,
     104,    -1,    63,    43,     4,    59,    97,   104,    -1,    -1,
      58,     6,    -1,    -1,    66,    67,    42,     4,    -1,    66,
      67,    42,     4,    69,    42,     6,    -1,    68,    42,     4,
      -1
};

/* YYRLINE[YYN] -- source line where rule number YYN was defined.  */
static const yytype_uint16 yyrline[] =
{
       0,   123,   123,   124,   128,   131,   133,   135,   137,   139,
     141,   143,   145,   147,   149,   151,   153,   155,   157,   162,
     163,   164,   165,   166,   167,   168,   169,   170,   171,   172,
     173,   174,   175,   176,   177,   178,   179,   180,   181,   185,
     186,   187,   188,   189,   190,   192,   193,   194,   195,   196,
     197,   198,   199,   200,   201,   203,   204,   205,   209,   210,
     213,   216,   220,   221,   222,   226,   227,   231,   232,   235,
     237,   240,   244,   245,   246,   247,   248,   249,   250,   251,
     252,   253,   254,   255,   256,   257,   258,   259,   261,   264,
     266,   269,   270,   271
};
#endif

#if YYDEBUG || YYERROR_VERBOSE || YYTOKEN_TABLE
/* YYTNAME[SYMBOL-NUM] -- String name of the symbol SYMBOL-NUM.
   First, the terminals, then, starting at YYNTOKENS, nonterminals.  */
static const char *const yytname[] =
{
  "$end", "error", "$undefined", "FILENAME", "NAME", "STRING", "INTNUM",
  "DECIMAL1", "BOOL1", "APPROXNUM", "USERVAR", "ASSIGN", "EQUAL",
  "NONEQUAL", "OR", "XOR", "AND", "DISTINCT", "YEAR", "REGEXP", "LIKE",
  "IS", "IN", "'!'", "NOT", "BETWEEN", "COMPARISON", "'|'", "'&'", "SHIFT",
  "'+'", "'-'", "'*'", "'/'", "'%'", "MOD", "'^'", "FROM", "MULITE",
  "DELETE", "LOAD", "FILTER", "BY", "JOIN", "STORE", "INTO", "GROUP",
  "SELECT", "AS", "ORDER", "ASC", "DESC", "COUNT", "USING", "SUM", "AVG",
  "MIN", "MAX", "LIMIT", "ON", "BINARY", "LEFT", "RIGHT", "OUTER", "SEMI",
  "ANTI", "SORT", "SEGMENTS", "PRESORTED", "PARTITION", "INSERT", "WHERE",
  "DISPLAY", "CASE", "WHEN", "THEN", "ELSE", "END", "SHOW", "TABLES",
  "TABLE", "DESCRIBE", "DROP", "CREATE", "INDEX", "';'", "'('", "')'",
  "'.'", "','", "'{'", "'}'", "':'", "$accept", "stmt_list", "stmt",
  "select_stmt", "expr", "opt_group_list", "expr_list", "load_list",
  "val_list", "opt_val_list", "opt_where", "join_list", "opt_limit",
  "sort_def", 0
};
#endif

# ifdef YYPRINT
/* YYTOKNUM[YYLEX-NUM] -- Internal token number corresponding to
   token YYLEX-NUM.  */
static const yytype_uint16 yytoknum[] =
{
       0,   256,   257,   258,   259,   260,   261,   262,   263,   264,
     265,   266,   267,   268,   269,   270,   271,   272,   273,   274,
     275,   276,   277,    33,   278,   279,   280,   124,    38,   281,
      43,    45,    42,    47,    37,   282,    94,   283,   284,   285,
     286,   287,   288,   289,   290,   291,   292,   293,   294,   295,
     296,   297,   298,   299,   300,   301,   302,   303,   304,   305,
     306,   307,   308,   309,   310,   311,   312,   313,   314,   315,
     316,   317,   318,   319,   320,   321,   322,   323,   324,   325,
     326,   327,   328,   329,   330,    59,    40,    41,    46,    44,
     123,   125,    58
};
# endif

/* YYR1[YYN] -- Symbol number of symbol that rule YYN derives.  */
static const yytype_uint8 yyr1[] =
{
       0,    93,    94,    94,    95,    96,    96,    96,    96,    96,
      96,    96,    96,    96,    96,    96,    96,    96,    96,    97,
      97,    97,    97,    97,    97,    97,    97,    97,    97,    97,
      97,    97,    97,    97,    97,    97,    97,    97,    97,    97,
      97,    97,    97,    97,    97,    97,    97,    97,    97,    97,
      97,    97,    97,    97,    97,    97,    97,    97,    97,    97,
      98,    98,    99,    99,    99,   100,   100,   101,   101,   102,
     102,   103,   104,   104,   104,   104,   104,   104,   104,   104,
     104,   104,   104,   104,   104,   104,   104,   104,   105,   105,
     106,   106,   106,   106
};

/* YYR2[YYN] -- Number of symbols composing right hand side of rule YYN.  */
static const yytype_uint8 yyr2[] =
{
       0,     2,     2,     3,     1,     7,    12,     5,     6,     8,
       9,     7,     2,     7,     5,     7,     2,     3,    22,     1,
       3,     1,     1,     1,     1,     1,     1,    11,     9,     6,
       2,     2,     4,     4,     4,     4,     4,     2,     4,     3,
       3,     3,     3,     3,     3,     3,     3,     3,     3,     3,
       3,     2,     2,     3,     3,     5,     3,     8,     3,     4,
       0,     3,     3,     5,     1,     1,     3,     1,     3,     0,
       1,     2,     4,     6,     6,     6,     5,     5,     6,     5,
       5,     7,     7,     6,     7,     6,     7,     6,     0,     2,
       0,     4,     7,     3
};

/* YYDEFACT[STATE-NAME] -- Default rule to reduce with in state
   STATE-NUM when YYTABLE doesn't specify something else to do.  Zero
   means the default is an error.  */
static const yytype_uint8 yydefact[] =
{
       0,     0,     0,     0,     0,     0,     0,     0,     0,     0,
       0,     0,     4,     0,     0,     0,     0,     0,    16,    12,
       0,     0,     1,     0,     2,     0,     0,     0,     0,     0,
       0,     0,     0,    17,     0,     3,     0,     0,    19,    22,
      23,    24,    26,    25,    21,     0,     0,     0,     0,    64,
       0,     0,     0,     0,     0,     0,     0,     0,     0,     0,
       0,    88,     0,     0,     0,     0,     0,     7,    30,    31,
       0,     0,    37,     0,    52,    51,     0,     0,     0,     0,
       0,     0,     0,     0,     0,     0,     0,     0,     0,     0,
       0,     0,     0,     0,     0,     0,     0,     0,     0,     0,
       0,    69,    14,     0,     0,     0,     0,     0,     0,     0,
      71,    20,     0,     0,     0,     0,     0,     0,     0,     0,
      56,    46,    47,    48,    49,    45,    54,    58,     0,     0,
      53,    50,    39,    40,    41,    42,    43,    44,    62,    60,
       0,    67,    70,     8,     0,    89,    90,     0,    88,     0,
       0,     0,    38,    32,    33,    34,    35,    36,     0,    59,
      19,     0,     0,     0,     0,     0,     0,     0,     5,    60,
       0,     0,     0,     0,     0,    11,    13,    15,     0,     0,
       0,     0,    55,     0,     0,     0,     0,     0,     0,     0,
       0,     9,    63,    68,    88,     0,     0,     0,     0,    29,
       0,     0,    61,     0,     0,     0,     0,     0,     0,     0,
      10,     0,    93,     0,     0,     0,     0,    72,     0,     0,
       0,     0,     0,     0,     0,    91,     0,    65,     0,     0,
      57,    80,    76,     0,    77,     0,    79,     0,     0,     0,
       0,     6,     0,    28,     0,    83,    75,    85,    78,    87,
      73,    74,     0,     0,    66,     0,    84,    86,    81,    82,
      92,     0,    27,     0,     0,     0,     0,     0,     0,     0,
       0,    18
};

/* YYDEFGOTO[NTERM-NUM].  */
static const yytype_int16 yydefgoto[] =
{
      -1,    10,    11,    12,   141,   168,    58,   228,   142,   143,
      67,   169,   105,   175
};

/* YYPACT[STATE-NUM] -- Index in YYTABLE of the portion describing
   STATE-NUM.  */
#define YYPACT_NINF -158
static const yytype_int16 yypact[] =
{
      36,    -6,   -21,    18,   -15,    30,   -42,    68,    -3,   -22,
       4,    -7,  -158,    58,    84,    44,    93,    47,  -158,  -158,
      97,   108,  -158,    31,  -158,   112,   118,   195,   120,    61,
     130,    87,    50,  -158,    85,  -158,    92,   104,    33,  -158,
    -158,  -158,  -158,  -158,  -158,   236,    62,   236,   236,  -158,
      64,    66,    69,    71,    74,    73,   236,   644,   -34,   119,
     236,   -41,   195,   159,   171,    77,   236,  -158,  -158,  -158,
     173,   172,   241,   236,   747,   747,   236,   236,   236,   236,
     236,   236,   336,   236,   236,   236,   236,   236,   236,    -1,
     290,   236,   236,   236,   236,   236,   236,   236,   182,   184,
     236,   236,   698,   103,   186,   134,   -18,   109,   111,   187,
     698,  -158,   107,   365,   395,   424,   454,   483,   513,   596,
    -158,   698,   721,   150,   200,   241,   737,  -158,   199,    86,
     754,   252,    94,    94,  -158,  -158,  -158,  -158,  -158,   -37,
     674,   303,  -158,  -158,   206,  -158,   -53,   210,   164,   213,
     136,   132,  -158,  -158,  -158,  -158,  -158,  -158,   236,  -158,
      -9,   138,   224,   194,   -33,   -32,   196,   205,  -158,   191,
     234,   236,   168,   189,   215,  -158,  -158,  -158,   170,   216,
     259,   572,  -158,   207,   236,   261,   226,   273,   235,   275,
     -17,  -158,  -158,  -158,   164,   238,   285,   297,   217,   218,
     236,   236,  -158,   243,   301,   247,   306,   253,   307,   316,
    -158,   317,  -158,   239,   236,   319,   542,   620,   236,   268,
     236,   269,   236,   271,   272,   270,   304,   698,   -51,    24,
    -158,  -158,   620,   236,   620,   236,   620,   236,   236,   298,
     339,  -158,   236,  -158,   347,  -158,   620,  -158,   620,  -158,
     620,   620,   348,   266,   698,   274,  -158,  -158,  -158,  -158,
    -158,   354,  -158,   288,   356,   276,   368,   361,   370,   287,
     378,  -158
};

/* YYPGOTO[NTERM-NUM].  */
static const yytype_int16 yypgoto[] =
{
    -158,  -158,   373,   255,   -27,   219,   325,  -158,  -157,  -158,
    -158,   -97,  -147,  -158
};

/* YYTABLE[YYPACT[STATE-NUM]].  What to do in state STATE-NUM.  If
   positive, shift that token.  If negative, reduce the rule which
   number is the opposite.  If zero, do what YYDEFACT says.
   If YYTABLE_NINF, syntax error.  */
#define YYTABLE_NINF -1
static const yytype_int16 yytable[] =
{
      57,   177,    13,    99,    22,    13,   162,   127,     1,   163,
     185,   187,   103,   173,   193,   174,    14,   104,    72,   147,
      74,    75,    15,   128,   164,   165,   166,   202,   167,    82,
      16,   186,   188,   102,    17,    57,   241,    18,   242,   110,
       1,    68,    69,     2,   208,   209,   113,   210,     3,   114,
     115,   116,   117,   118,   119,   100,   121,   122,   123,   124,
     125,   126,    21,   130,   131,   132,   133,   134,   135,   136,
     137,   100,    19,   140,     4,     2,     5,    20,    24,    70,
       3,    71,     6,    68,    69,     7,     8,     9,    29,    30,
     160,    39,    40,    41,    42,    43,    44,    31,    25,    26,
      32,    33,    82,    45,    46,    27,     4,    28,     5,    47,
      48,   243,    34,   244,     6,    36,    35,     7,     8,     9,
     231,    70,    37,    71,    59,     2,    94,    95,    96,    97,
       3,   181,    60,    61,    62,   245,    63,   247,    50,   249,
      51,    52,    53,    54,    64,    65,    66,    81,    73,   256,
      76,   257,    77,   258,   259,    78,     4,    79,     5,    55,
      80,   101,   107,   109,     6,    86,    87,     7,     8,     9,
      88,    89,    56,   216,   217,   108,    90,   111,   112,    91,
      92,    93,    94,    95,    96,    97,   138,   227,   139,   144,
     150,   232,   145,   234,   146,   236,   148,   149,   151,    38,
      39,    40,    41,    42,    43,    44,   246,   159,   248,   172,
     250,   251,    45,    46,   176,   254,    87,   178,    47,    48,
      88,    89,   104,   179,   180,   182,    90,    49,   183,    91,
      92,    93,    94,    95,    96,    97,   184,   163,   192,   189,
      38,    39,    40,    41,    42,    43,    44,    50,   190,    51,
      52,    53,    54,    45,    46,   194,   195,   196,   197,    47,
      48,    88,    89,   199,   198,   203,   201,    90,    55,   204,
      91,    92,    93,    94,    95,    96,    97,   205,   206,   207,
     211,    56,    92,    93,    94,    95,    96,    97,    50,   212,
      51,    52,    53,    54,    38,    39,    40,    41,    42,    43,
      44,   213,   218,   214,   215,   219,   220,    45,    46,    55,
     221,   223,   222,    47,    48,    83,    84,    85,    86,    87,
     224,   225,    56,    88,    89,   229,   226,   233,   235,    90,
     237,   238,    91,    92,    93,    94,    95,    96,    97,   239,
     252,   240,    50,   253,    51,    52,    53,    54,    83,    84,
      85,    86,    87,   255,   260,   261,    88,    89,   263,   264,
     265,   262,    90,    55,   266,    91,    92,    93,    94,    95,
      96,    97,   267,   268,   269,   270,   129,    83,    84,    85,
      86,    87,   271,    23,   161,    88,    89,   106,   191,     0,
       0,    90,   171,     0,    91,    92,    93,    94,    95,    96,
      97,     0,     0,     0,     0,     0,     0,    83,    84,    85,
      86,    87,     0,     0,     0,    88,    89,     0,     0,     0,
       0,    90,     0,   120,    91,    92,    93,    94,    95,    96,
      97,     0,     0,     0,     0,     0,    83,    84,    85,    86,
      87,     0,     0,     0,    88,    89,     0,     0,     0,     0,
      90,     0,   152,    91,    92,    93,    94,    95,    96,    97,
       0,     0,     0,     0,     0,     0,    83,    84,    85,    86,
      87,     0,     0,     0,    88,    89,     0,     0,     0,     0,
      90,     0,   153,    91,    92,    93,    94,    95,    96,    97,
       0,     0,     0,     0,     0,    83,    84,    85,    86,    87,
       0,     0,     0,    88,    89,     0,     0,     0,     0,    90,
       0,   154,    91,    92,    93,    94,    95,    96,    97,     0,
       0,     0,     0,     0,     0,    83,    84,    85,    86,    87,
       0,     0,     0,    88,    89,     0,     0,     0,     0,    90,
       0,   155,    91,    92,    93,    94,    95,    96,    97,     0,
       0,     0,     0,     0,    83,    84,    85,    86,    87,     0,
       0,     0,    88,    89,     0,     0,     0,     0,    90,     0,
     156,    91,    92,    93,    94,    95,    96,    97,     0,     0,
       0,     0,     0,     0,    83,    84,    85,    86,    87,     0,
       0,     0,    88,    89,     0,     0,     0,     0,    90,     0,
     157,    91,    92,    93,    94,    95,    96,    97,    83,    84,
      85,    86,    87,     0,     0,     0,    88,    89,     0,   230,
       0,     0,    90,     0,     0,    91,    92,    93,    94,    95,
      96,    97,    83,    84,    85,    86,    87,     0,     0,     0,
      88,    89,     0,     0,     0,     0,    90,     0,   200,    91,
      92,    93,    94,    95,    96,    97,    83,    84,    85,    86,
      87,     0,     0,   162,    88,    89,     0,     0,     0,     0,
      90,   158,     0,    91,    92,    93,    94,    95,    96,    97,
       0,   164,   165,   166,     0,   167,    83,    84,    85,    86,
      87,     0,    98,     0,    88,    89,     0,     0,     0,     0,
      90,     0,     0,    91,    92,    93,    94,    95,    96,    97,
      83,    84,    85,    86,    87,     0,     0,     0,    88,    89,
       0,     0,   170,     0,    90,     0,     0,    91,    92,    93,
      94,    95,    96,    97,    84,    85,    86,    87,     0,     0,
       0,    88,    89,     0,     0,     0,     0,    90,     0,     0,
      91,    92,    93,    94,    95,    96,    97,    -1,    -1,     0,
       0,     0,     0,    90,     0,     0,    91,    92,    93,    94,
      95,    96,    97,    90,     0,     0,    91,    92,    93,    94,
      95,    96,    97,    91,    92,    93,    94,    95,    96,    97
};

static const yytype_int16 yycheck[] =
{
      27,   148,    11,    37,     0,    11,    43,     8,     4,    46,
      43,    43,    53,    66,   171,    68,    37,    58,    45,    37,
      47,    48,     4,    24,    61,    62,    63,   184,    65,    56,
      45,    64,    64,    60,     4,    62,    87,    79,    89,    66,
       4,    50,    51,    39,    61,    62,    73,   194,    44,    76,
      77,    78,    79,    80,    81,    89,    83,    84,    85,    86,
      87,    88,    84,    90,    91,    92,    93,    94,    95,    96,
      97,    89,     4,   100,    70,    39,    72,    80,    85,    88,
      44,    90,    78,    50,    51,    81,    82,    83,     4,    45,
       4,     5,     6,     7,     8,     9,    10,     4,    40,    41,
      53,     4,   129,    17,    18,    47,    70,    49,    72,    23,
      24,    87,     4,    89,    78,     3,    85,    81,    82,    83,
     217,    88,     4,    90,     4,    39,    32,    33,    34,    35,
      44,   158,    71,     3,    47,   232,    86,   234,    52,   236,
      54,    55,    56,    57,    59,    53,    42,    74,    86,   246,
      86,   248,    86,   250,   251,    86,    70,    86,    72,    73,
      86,    42,     3,    86,    78,    15,    16,    81,    82,    83,
      20,    21,    86,   200,   201,     4,    26,     4,     6,    29,
      30,    31,    32,    33,    34,    35,     4,   214,     4,    86,
       3,   218,     6,   220,    60,   222,    87,    86,    91,     4,
       5,     6,     7,     8,     9,    10,   233,     8,   235,     3,
     237,   238,    17,    18,     4,   242,    16,     4,    23,    24,
      20,    21,    58,    87,    92,    87,    26,    32,     4,    29,
      30,    31,    32,    33,    34,    35,    42,    46,     4,    43,
       4,     5,     6,     7,     8,     9,    10,    52,    43,    54,
      55,    56,    57,    17,    18,    87,    67,    42,    88,    23,
      24,    20,    21,     4,    48,     4,    59,    26,    73,    43,
      29,    30,    31,    32,    33,    34,    35,     4,    43,     4,
      42,    86,    30,    31,    32,    33,    34,    35,    52,     4,
      54,    55,    56,    57,     4,     5,     6,     7,     8,     9,
      10,     4,    59,    86,    86,     4,    59,    17,    18,    73,
       4,     4,    59,    23,    24,    12,    13,    14,    15,    16,
       4,     4,    86,    20,    21,     6,    87,    59,    59,    26,
      59,    59,    29,    30,    31,    32,    33,    34,    35,    69,
      42,    37,    52,     4,    54,    55,    56,    57,    12,    13,
      14,    15,    16,     6,     6,    89,    20,    21,     4,    71,
       4,    87,    26,    73,    88,    29,    30,    31,    32,    33,
      34,    35,     4,    12,     4,    88,    86,    12,    13,    14,
      15,    16,     4,    10,   129,    20,    21,    62,   169,    -1,
      -1,    26,    89,    -1,    29,    30,    31,    32,    33,    34,
      35,    -1,    -1,    -1,    -1,    -1,    -1,    12,    13,    14,
      15,    16,    -1,    -1,    -1,    20,    21,    -1,    -1,    -1,
      -1,    26,    -1,    87,    29,    30,    31,    32,    33,    34,
      35,    -1,    -1,    -1,    -1,    -1,    12,    13,    14,    15,
      16,    -1,    -1,    -1,    20,    21,    -1,    -1,    -1,    -1,
      26,    -1,    87,    29,    30,    31,    32,    33,    34,    35,
      -1,    -1,    -1,    -1,    -1,    -1,    12,    13,    14,    15,
      16,    -1,    -1,    -1,    20,    21,    -1,    -1,    -1,    -1,
      26,    -1,    87,    29,    30,    31,    32,    33,    34,    35,
      -1,    -1,    -1,    -1,    -1,    12,    13,    14,    15,    16,
      -1,    -1,    -1,    20,    21,    -1,    -1,    -1,    -1,    26,
      -1,    87,    29,    30,    31,    32,    33,    34,    35,    -1,
      -1,    -1,    -1,    -1,    -1,    12,    13,    14,    15,    16,
      -1,    -1,    -1,    20,    21,    -1,    -1,    -1,    -1,    26,
      -1,    87,    29,    30,    31,    32,    33,    34,    35,    -1,
      -1,    -1,    -1,    -1,    12,    13,    14,    15,    16,    -1,
      -1,    -1,    20,    21,    -1,    -1,    -1,    -1,    26,    -1,
      87,    29,    30,    31,    32,    33,    34,    35,    -1,    -1,
      -1,    -1,    -1,    -1,    12,    13,    14,    15,    16,    -1,
      -1,    -1,    20,    21,    -1,    -1,    -1,    -1,    26,    -1,
      87,    29,    30,    31,    32,    33,    34,    35,    12,    13,
      14,    15,    16,    -1,    -1,    -1,    20,    21,    -1,    77,
      -1,    -1,    26,    -1,    -1,    29,    30,    31,    32,    33,
      34,    35,    12,    13,    14,    15,    16,    -1,    -1,    -1,
      20,    21,    -1,    -1,    -1,    -1,    26,    -1,    76,    29,
      30,    31,    32,    33,    34,    35,    12,    13,    14,    15,
      16,    -1,    -1,    43,    20,    21,    -1,    -1,    -1,    -1,
      26,    75,    -1,    29,    30,    31,    32,    33,    34,    35,
      -1,    61,    62,    63,    -1,    65,    12,    13,    14,    15,
      16,    -1,    48,    -1,    20,    21,    -1,    -1,    -1,    -1,
      26,    -1,    -1,    29,    30,    31,    32,    33,    34,    35,
      12,    13,    14,    15,    16,    -1,    -1,    -1,    20,    21,
      -1,    -1,    48,    -1,    26,    -1,    -1,    29,    30,    31,
      32,    33,    34,    35,    13,    14,    15,    16,    -1,    -1,
      -1,    20,    21,    -1,    -1,    -1,    -1,    26,    -1,    -1,
      29,    30,    31,    32,    33,    34,    35,    20,    21,    -1,
      -1,    -1,    -1,    26,    -1,    -1,    29,    30,    31,    32,
      33,    34,    35,    26,    -1,    -1,    29,    30,    31,    32,
      33,    34,    35,    29,    30,    31,    32,    33,    34,    35
};

/* YYSTOS[STATE-NUM] -- The (internal number of the) accessing
   symbol of state STATE-NUM.  */
static const yytype_uint8 yystos[] =
{
       0,     4,    39,    44,    70,    72,    78,    81,    82,    83,
      94,    95,    96,    11,    37,     4,    45,     4,    79,     4,
      80,    84,     0,    95,    85,    40,    41,    47,    49,     4,
      45,     4,    53,     4,     4,    85,     3,     4,     4,     5,
       6,     7,     8,     9,    10,    17,    18,    23,    24,    32,
      52,    54,    55,    56,    57,    73,    86,    97,    99,     4,
      71,     3,    47,    86,    59,    53,    42,   103,    50,    51,
      88,    90,    97,    86,    97,    97,    86,    86,    86,    86,
      86,    74,    97,    12,    13,    14,    15,    16,    20,    21,
      26,    29,    30,    31,    32,    33,    34,    35,    48,    37,
      89,    42,    97,    53,    58,   105,    99,     3,     4,    86,
      97,     4,     6,    97,    97,    97,    97,    97,    97,    97,
      87,    97,    97,    97,    97,    97,    97,     8,    24,    86,
      97,    97,    97,    97,    97,    97,    97,    97,     4,     4,
      97,    97,   101,   102,    86,     6,    60,    37,    87,    86,
       3,    91,    87,    87,    87,    87,    87,    87,    75,     8,
       4,    96,    43,    46,    61,    62,    63,    65,    98,   104,
      48,    89,     3,    66,    68,   106,     4,   105,     4,    87,
      92,    97,    87,     4,    42,    43,    64,    43,    64,    43,
      43,    98,     4,   101,    87,    67,    42,    88,    48,     4,
      76,    59,   101,     4,    43,     4,    43,     4,    61,    62,
     105,    42,     4,     4,    86,    86,    97,    97,    59,     4,
      59,     4,    59,     4,     4,     4,    87,    97,   100,     6,
      77,   104,    97,    59,    97,    59,    97,    59,    59,    69,
      37,    87,    89,    87,    89,   104,    97,   104,    97,   104,
      97,    97,    42,     4,    97,     6,   104,   104,   104,   104,
       6,    89,    87,     4,    71,     4,    88,     4,    12,     4,
      88,     4
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
#line 128 "bison.y"
    { emit("STMT"); ;}
    break;

  case 5:

/* Line 1455 of yacc.c  */
#line 132 "bison.y"
    { emit_select((yyvsp[(1) - (7)].strval), (yyvsp[(6) - (7)].strval), (yyvsp[(7) - (7)].intval)); ;}
    break;

  case 6:

/* Line 1455 of yacc.c  */
#line 134 "bison.y"
    {  emit_load((yyvsp[(1) - (12)].strval), (yyvsp[(4) - (12)].strval), (yyvsp[(11) - (12)].intval), (yyvsp[(7) - (12)].strval)); ;}
    break;

  case 7:

/* Line 1455 of yacc.c  */
#line 136 "bison.y"
    {  emit_filter((yyvsp[(1) - (5)].strval), (yyvsp[(4) - (5)].strval));;}
    break;

  case 8:

/* Line 1455 of yacc.c  */
#line 138 "bison.y"
    {  emit_order((yyvsp[(1) - (6)].strval), (yyvsp[(4) - (6)].strval), (yyvsp[(6) - (6)].intval));;}
    break;

  case 9:

/* Line 1455 of yacc.c  */
#line 140 "bison.y"
    {  emit_join((yyvsp[(1) - (8)].strval),(yyvsp[(6) - (8)].strval),(yyvsp[(7) - (8)].intval),0,-1); ;}
    break;

  case 10:

/* Line 1455 of yacc.c  */
#line 142 "bison.y"
    {  emit_store((yyvsp[(2) - (9)].strval),(yyvsp[(4) - (9)].strval),(yyvsp[(7) - (9)].strval)); ;}
    break;

  case 11:

/* Line 1455 of yacc.c  */
#line 144 "bison.y"
    {  emit_store_binary((yyvsp[(2) - (7)].strval),(yyvsp[(4) - (7)].strval)); ;}
    break;

  case 12:

/* Line 1455 of yacc.c  */
#line 146 "bison.y"
    {  emit_describe_table((yyvsp[(2) - (2)].strval));;}
    break;

  case 13:

/* Line 1455 of yacc.c  */
#line 148 "bison.y"
    {  emit_insert((yyvsp[(3) - (7)].strval), (yyvsp[(7) - (7)].strval));;}
    break;

  case 14:

/* Line 1455 of yacc.c  */
#line 150 "bison.y"
    {  emit_delete((yyvsp[(3) - (5)].strval));;}
    break;

  case 15:

/* Line 1455 of yacc.c  */
#line 152 "bison.y"
    {  emit_display((yyvsp[(2) - (7)].strval), (yyvsp[(5) - (7)].strval));;}
    break;

  case 16:

/* Line 1455 of yacc.c  */
#line 154 "bison.y"
    {  emit_show_tables();;}
    break;

  case 17:

/* Line 1455 of yacc.c  */
#line 156 "bison.y"
    {  emit_drop_table((yyvsp[(3) - (3)].strval));;}
    break;

  case 18:

/* Line 1455 of yacc.c  */
#line 158 "bison.y"
    {  emit_create_bitmap_index((yyvsp[(3) - (22)].strval), (yyvsp[(5) - (22)].strval), (yyvsp[(7) - (22)].strval), (yyvsp[(9) - (22)].strval), (yyvsp[(18) - (22)].strval), (yyvsp[(22) - (22)].strval));;}
    break;

  case 19:

/* Line 1455 of yacc.c  */
#line 162 "bison.y"
    { emit_name((yyvsp[(1) - (1)].strval)); ;}
    break;

  case 20:

/* Line 1455 of yacc.c  */
#line 163 "bison.y"
    { emit_fieldname((yyvsp[(1) - (3)].strval), (yyvsp[(3) - (3)].strval)); ;}
    break;

  case 21:

/* Line 1455 of yacc.c  */
#line 164 "bison.y"
    { emit("USERVAR %s", (yyvsp[(1) - (1)].strval)); ;}
    break;

  case 22:

/* Line 1455 of yacc.c  */
#line 165 "bison.y"
    { emit_string((yyvsp[(1) - (1)].strval)); ;}
    break;

  case 23:

/* Line 1455 of yacc.c  */
#line 166 "bison.y"
    { emit_number((yyvsp[(1) - (1)].intval)); ;}
    break;

  case 24:

/* Line 1455 of yacc.c  */
#line 167 "bison.y"
    { emit_decimal((yyvsp[(1) - (1)].strval)); ;}
    break;

  case 25:

/* Line 1455 of yacc.c  */
#line 168 "bison.y"
    { emit_float((yyvsp[(1) - (1)].floatval)); ;}
    break;

  case 26:

/* Line 1455 of yacc.c  */
#line 169 "bison.y"
    { emit("BOOL %d", (yyvsp[(1) - (1)].intval)); ;}
    break;

  case 27:

/* Line 1455 of yacc.c  */
#line 170 "bison.y"
    { emit_vardecimal((yyvsp[(1) - (11)].strval), (yyvsp[(3) - (11)].intval), (yyvsp[(6) - (11)].strval),  (yyvsp[(8) - (11)].intval), (yyvsp[(10) - (11)].intval));;}
    break;

  case 28:

/* Line 1455 of yacc.c  */
#line 171 "bison.y"
    { emit_varchar((yyvsp[(1) - (9)].strval), (yyvsp[(3) - (9)].intval), (yyvsp[(6) - (9)].strval), (yyvsp[(8) - (9)].intval), "", "");;}
    break;

  case 29:

/* Line 1455 of yacc.c  */
#line 172 "bison.y"
    { emit_var((yyvsp[(1) - (6)].strval), (yyvsp[(3) - (6)].intval), (yyvsp[(6) - (6)].strval), "", "");;}
    break;

  case 30:

/* Line 1455 of yacc.c  */
#line 173 "bison.y"
    { emit_var_asc((yyvsp[(1) - (2)].strval));;}
    break;

  case 31:

/* Line 1455 of yacc.c  */
#line 174 "bison.y"
    { emit_var_desc((yyvsp[(1) - (2)].strval));;}
    break;

  case 32:

/* Line 1455 of yacc.c  */
#line 175 "bison.y"
    { emit_count(); ;}
    break;

  case 33:

/* Line 1455 of yacc.c  */
#line 176 "bison.y"
    { emit_sum(); ;}
    break;

  case 34:

/* Line 1455 of yacc.c  */
#line 177 "bison.y"
    { emit_average(); ;}
    break;

  case 35:

/* Line 1455 of yacc.c  */
#line 178 "bison.y"
    { emit_min(); ;}
    break;

  case 36:

/* Line 1455 of yacc.c  */
#line 179 "bison.y"
    { emit_max(); ;}
    break;

  case 37:

/* Line 1455 of yacc.c  */
#line 180 "bison.y"
    { emit_distinct(); ;}
    break;

  case 38:

/* Line 1455 of yacc.c  */
#line 181 "bison.y"
    { emit_year(); ;}
    break;

  case 39:

/* Line 1455 of yacc.c  */
#line 185 "bison.y"
    { emit_add(); ;}
    break;

  case 40:

/* Line 1455 of yacc.c  */
#line 186 "bison.y"
    { emit_minus(); ;}
    break;

  case 41:

/* Line 1455 of yacc.c  */
#line 187 "bison.y"
    { emit_mul(); ;}
    break;

  case 42:

/* Line 1455 of yacc.c  */
#line 188 "bison.y"
    { emit_div(); ;}
    break;

  case 43:

/* Line 1455 of yacc.c  */
#line 189 "bison.y"
    { emit("MOD"); ;}
    break;

  case 44:

/* Line 1455 of yacc.c  */
#line 190 "bison.y"
    { emit("MOD"); ;}
    break;

  case 45:

/* Line 1455 of yacc.c  */
#line 192 "bison.y"
    { emit_and(); ;}
    break;

  case 46:

/* Line 1455 of yacc.c  */
#line 193 "bison.y"
    { emit_eq(); ;}
    break;

  case 47:

/* Line 1455 of yacc.c  */
#line 194 "bison.y"
    { emit_neq(); ;}
    break;

  case 48:

/* Line 1455 of yacc.c  */
#line 195 "bison.y"
    { emit_or(); ;}
    break;

  case 49:

/* Line 1455 of yacc.c  */
#line 196 "bison.y"
    { emit("XOR"); ;}
    break;

  case 50:

/* Line 1455 of yacc.c  */
#line 197 "bison.y"
    { emit("SHIFT %s", (yyvsp[(2) - (3)].subtok)==1?"left":"right"); ;}
    break;

  case 51:

/* Line 1455 of yacc.c  */
#line 198 "bison.y"
    { emit("NOT"); ;}
    break;

  case 52:

/* Line 1455 of yacc.c  */
#line 199 "bison.y"
    { emit("NOT"); ;}
    break;

  case 53:

/* Line 1455 of yacc.c  */
#line 200 "bison.y"
    { emit_cmp((yyvsp[(2) - (3)].subtok)); ;}
    break;

  case 54:

/* Line 1455 of yacc.c  */
#line 201 "bison.y"
    { emit_cmp(7); ;}
    break;

  case 55:

/* Line 1455 of yacc.c  */
#line 203 "bison.y"
    { emit("CMPSELECT %d", (yyvsp[(2) - (5)].subtok)); ;}
    break;

  case 56:

/* Line 1455 of yacc.c  */
#line 204 "bison.y"
    {emit("EXPR");;}
    break;

  case 57:

/* Line 1455 of yacc.c  */
#line 205 "bison.y"
    { emit_case(); ;}
    break;

  case 58:

/* Line 1455 of yacc.c  */
#line 209 "bison.y"
    { emit("ISBOOL %d", (yyvsp[(3) - (3)].intval)); ;}
    break;

  case 59:

/* Line 1455 of yacc.c  */
#line 210 "bison.y"
    { emit("ISBOOL %d", (yyvsp[(4) - (4)].intval)); emit("NOT"); ;}
    break;

  case 60:

/* Line 1455 of yacc.c  */
#line 213 "bison.y"
    { /* nil */
    (yyval.intval) = 0;
;}
    break;

  case 61:

/* Line 1455 of yacc.c  */
#line 216 "bison.y"
    { (yyval.intval) = (yyvsp[(3) - (3)].intval);;}
    break;

  case 62:

/* Line 1455 of yacc.c  */
#line 220 "bison.y"
    { (yyval.intval) = 1; emit_sel_name((yyvsp[(3) - (3)].strval));;}
    break;

  case 63:

/* Line 1455 of yacc.c  */
#line 221 "bison.y"
    { (yyval.intval) = (yyvsp[(1) - (5)].intval) + 1; emit_sel_name((yyvsp[(5) - (5)].strval));;}
    break;

  case 64:

/* Line 1455 of yacc.c  */
#line 222 "bison.y"
    { emit_sel_name("*");;}
    break;

  case 65:

/* Line 1455 of yacc.c  */
#line 226 "bison.y"
    { (yyval.intval) = 1; ;}
    break;

  case 66:

/* Line 1455 of yacc.c  */
#line 227 "bison.y"
    {(yyval.intval) = (yyvsp[(1) - (3)].intval) + 1; ;}
    break;

  case 67:

/* Line 1455 of yacc.c  */
#line 231 "bison.y"
    { (yyval.intval) = 1; ;}
    break;

  case 68:

/* Line 1455 of yacc.c  */
#line 232 "bison.y"
    { (yyval.intval) = 1 + (yyvsp[(3) - (3)].intval); ;}
    break;

  case 69:

/* Line 1455 of yacc.c  */
#line 235 "bison.y"
    { /* nil */
    (yyval.intval) = 0;
;}
    break;

  case 71:

/* Line 1455 of yacc.c  */
#line 240 "bison.y"
    { emit("FILTER BY"); ;}
    break;

  case 72:

/* Line 1455 of yacc.c  */
#line 244 "bison.y"
    { (yyval.intval) = 1; emit_join_tab((yyvsp[(2) - (4)].strval), 'I');;}
    break;

  case 73:

/* Line 1455 of yacc.c  */
#line 245 "bison.y"
    { (yyval.intval) = 1; emit_join_tab((yyvsp[(4) - (6)].strval), '3');;}
    break;

  case 74:

/* Line 1455 of yacc.c  */
#line 246 "bison.y"
    { (yyval.intval) = 1; emit_join_tab((yyvsp[(4) - (6)].strval), '4');;}
    break;

  case 75:

/* Line 1455 of yacc.c  */
#line 247 "bison.y"
    { (yyval.intval) = 1; emit_join_tab((yyvsp[(4) - (6)].strval), '1');;}
    break;

  case 76:

/* Line 1455 of yacc.c  */
#line 248 "bison.y"
    { (yyval.intval) = 1; emit_join_tab((yyvsp[(3) - (5)].strval), 'S');;}
    break;

  case 77:

/* Line 1455 of yacc.c  */
#line 249 "bison.y"
    { (yyval.intval) = 1; emit_join_tab((yyvsp[(3) - (5)].strval), 'R');;}
    break;

  case 78:

/* Line 1455 of yacc.c  */
#line 250 "bison.y"
    { (yyval.intval) = 1; emit_join_tab((yyvsp[(4) - (6)].strval), '2');;}
    break;

  case 79:

/* Line 1455 of yacc.c  */
#line 251 "bison.y"
    { (yyval.intval) = 1; emit_join_tab((yyvsp[(3) - (5)].strval), 'O');;}
    break;

  case 80:

/* Line 1455 of yacc.c  */
#line 252 "bison.y"
    { (yyval.intval) = 1; emit_join_tab((yyvsp[(2) - (5)].strval), 'I'); ;}
    break;

  case 81:

/* Line 1455 of yacc.c  */
#line 253 "bison.y"
    { (yyval.intval) = 1; emit_join_tab((yyvsp[(4) - (7)].strval), '3'); ;}
    break;

  case 82:

/* Line 1455 of yacc.c  */
#line 254 "bison.y"
    { (yyval.intval) = 1; emit_join_tab((yyvsp[(4) - (7)].strval), '4'); ;}
    break;

  case 83:

/* Line 1455 of yacc.c  */
#line 255 "bison.y"
    { (yyval.intval) = 1; emit_join_tab((yyvsp[(3) - (6)].strval), 'L'); ;}
    break;

  case 84:

/* Line 1455 of yacc.c  */
#line 256 "bison.y"
    { (yyval.intval) = 1; emit_join_tab((yyvsp[(4) - (7)].strval), '1'); ;}
    break;

  case 85:

/* Line 1455 of yacc.c  */
#line 257 "bison.y"
    { (yyval.intval) = 1; emit_join_tab((yyvsp[(3) - (6)].strval), 'R'); ;}
    break;

  case 86:

/* Line 1455 of yacc.c  */
#line 258 "bison.y"
    { (yyval.intval) = 1; emit_join_tab((yyvsp[(4) - (7)].strval), 'R'); ;}
    break;

  case 87:

/* Line 1455 of yacc.c  */
#line 259 "bison.y"
    { (yyval.intval) = 1; emit_join_tab((yyvsp[(3) - (6)].strval), 'O'); ;}
    break;

  case 88:

/* Line 1455 of yacc.c  */
#line 261 "bison.y"
    { /* nil */
    (yyval.intval) = 0;
;}
    break;

  case 89:

/* Line 1455 of yacc.c  */
#line 264 "bison.y"
    { emit_limit((yyvsp[(2) - (2)].intval)); ;}
    break;

  case 90:

/* Line 1455 of yacc.c  */
#line 266 "bison.y"
    { /* nil */
    (yyval.intval) = 0;
;}
    break;

  case 91:

/* Line 1455 of yacc.c  */
#line 269 "bison.y"
    { emit_sort((yyvsp[(4) - (4)].strval), 0); ;}
    break;

  case 92:

/* Line 1455 of yacc.c  */
#line 270 "bison.y"
    { emit_sort((yyvsp[(4) - (7)].strval), (yyvsp[(7) - (7)].intval)); ;}
    break;

  case 93:

/* Line 1455 of yacc.c  */
#line 271 "bison.y"
    { emit_presort((yyvsp[(3) - (3)].strval)); ;}
    break;



/* Line 1455 of yacc.c  */
#line 2376 "bison.tab.c"
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
#line 273 "bison.y"


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
	scratch.resize(0);
	scratch.shrink_to_fit();
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



