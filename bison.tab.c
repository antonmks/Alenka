
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
#line 207 "bison.tab.c"
} YYSTYPE;
# define YYSTYPE_IS_TRIVIAL 1
# define yystype YYSTYPE /* obsolescent; will be withdrawn */
# define YYSTYPE_IS_DECLARED 1
#endif


/* Copy the second part of user declarations.  */


/* Line 264 of yacc.c  */
#line 219 "bison.tab.c"

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
#define YYLAST   854

/* YYNTOKENS -- Number of terminals.  */
#define YYNTOKENS  96
/* YYNNTS -- Number of nonterminals.  */
#define YYNNTS  14
/* YYNRULES -- Number of rules.  */
#define YYNRULES  99
/* YYNRULES -- Number of states.  */
#define YYNSTATES  297

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
       2,     2,     2,    22,     2,     2,     2,    33,    27,     2,
      89,    90,    31,    29,    92,    30,    91,    32,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,    95,    88,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,    35,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,    93,    26,    94,     2,     2,     2,     2,
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
     235,   238,   243,   248,   253,   258,   262,   266,   270,   274,
     278,   282,   286,   290,   294,   298,   302,   306,   309,   312,
     316,   320,   326,   330,   339,   343,   348,   349,   353,   357,
     363,   365,   367,   371,   373,   377,   378,   380,   383,   388,
     395,   402,   409,   415,   421,   428,   434,   440,   448,   456,
     463,   471,   478,   486,   493,   494,   497,   498,   503,   511
};

/* YYRHS -- A `-1'-separated list of the rules' RHS.  */
static const yytype_int8 yyrhs[] =
{
      97,     0,    -1,    98,    88,    -1,    97,    98,    88,    -1,
      99,    -1,     4,    11,    45,   102,    36,     4,   101,    -1,
       4,    11,    38,     3,    51,    89,     3,    90,    46,    89,
     103,    90,    -1,     4,    11,    39,     4,   106,    -1,     4,
      11,    47,     4,    40,   105,    -1,     4,    11,    45,   102,
      36,     4,   107,   101,    -1,    42,     4,    43,     3,    51,
      89,     3,    90,   108,    -1,    42,     4,    43,     3,   108,
      58,   109,    -1,    42,     4,    43,     3,    87,   108,    58,
     109,    -1,    82,     4,    -1,    71,    43,     4,    45,   102,
      36,     4,    -1,    37,    36,     4,    72,   100,    -1,    73,
       4,    51,    89,     3,    90,   108,    -1,    79,    80,    -1,
      83,    81,     4,    -1,    84,    85,     4,    57,     4,    89,
       4,    91,     4,    90,    36,     4,    92,     4,    72,     4,
      91,     4,    12,     4,    91,     4,    -1,    84,    85,     4,
      57,     4,    89,     4,    90,    -1,    84,    86,     4,    57,
       4,    89,     4,    92,     4,    90,    -1,     4,    -1,     4,
      91,     4,    -1,    10,    -1,     5,    -1,     6,    -1,     7,
      -1,     9,    -1,     8,    -1,     4,    93,     6,    94,    95,
       4,    89,     6,    92,     6,    90,    -1,     4,    93,     6,
      94,    95,     4,    89,     6,    90,    -1,     4,    93,     6,
      94,    95,     4,    -1,     4,    48,    -1,     4,    49,    -1,
      50,    89,   100,    90,    -1,    52,    89,   100,    90,    -1,
      53,    89,   100,    90,    -1,    54,    89,   100,    90,    -1,
      55,    89,   100,    90,    -1,    17,   100,    -1,    59,    89,
     100,    90,    -1,    60,    89,   100,    90,    -1,    61,    89,
     100,    90,    -1,     4,    89,     5,    90,    -1,   100,    29,
     100,    -1,   100,    30,   100,    -1,   100,    31,   100,    -1,
     100,    32,   100,    -1,   100,    33,   100,    -1,   100,    34,
     100,    -1,   100,    16,   100,    -1,   100,    12,   100,    -1,
     100,    13,   100,    -1,   100,    14,   100,    -1,   100,    15,
     100,    -1,   100,    28,   100,    -1,    23,   100,    -1,    22,
     100,    -1,   100,    25,   100,    -1,   100,    19,   100,    -1,
     100,    25,    89,    99,    90,    -1,    89,   100,    90,    -1,
      74,    75,   100,    76,   100,    77,   100,    78,    -1,   100,
      20,     8,    -1,   100,    20,    23,     8,    -1,    -1,    44,
      40,   104,    -1,   100,    46,     4,    -1,   102,    92,   100,
      46,     4,    -1,    31,    -1,   100,    -1,   103,    92,   100,
      -1,   100,    -1,   100,    92,   104,    -1,    -1,   104,    -1,
      40,   100,    -1,    41,     4,    57,   100,    -1,    62,    66,
      41,     4,    57,   100,    -1,    63,    66,    41,     4,    57,
     100,    -1,    62,    65,    41,     4,    57,   100,    -1,    62,
      41,     4,    57,   100,    -1,    63,    41,     4,    57,   100,
      -1,    63,    65,    41,     4,    57,   100,    -1,    64,    41,
       4,    57,   100,    -1,    41,     4,    57,   100,   107,    -1,
      62,    66,    41,     4,    57,   100,   107,    -1,    63,    66,
      41,     4,    57,   100,   107,    -1,    62,    41,     4,    57,
     100,   107,    -1,    62,    65,    41,     4,    57,   100,   107,
      -1,    63,    41,     4,    57,   100,   107,    -1,    63,    65,
      41,     4,    57,   100,   107,    -1,    64,    41,     4,    57,
     100,   107,    -1,    -1,    56,     6,    -1,    -1,    67,    68,
      40,     4,    -1,    67,    68,    40,     4,    70,    40,     6,
      -1,    69,    40,     4,    -1
};

/* YYRLINE[YYN] -- source line where rule number YYN was defined.  */
static const yytype_uint16 yyrline[] =
{
       0,   125,   125,   126,   130,   133,   135,   137,   139,   141,
     143,   145,   147,   149,   151,   153,   155,   157,   159,   161,
     163,   165,   171,   172,   173,   174,   175,   176,   177,   178,
     179,   180,   181,   182,   183,   184,   185,   186,   187,   188,
     189,   190,   191,   192,   193,   197,   198,   199,   200,   201,
     202,   203,   204,   205,   206,   207,   208,   209,   210,   211,
     212,   214,   215,   216,   220,   221,   224,   227,   231,   232,
     233,   237,   238,   242,   243,   246,   248,   251,   255,   256,
     257,   258,   259,   260,   261,   262,   263,   264,   265,   266,
     267,   268,   269,   270,   272,   275,   277,   280,   281,   282
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
  "LIMIT", "ON", "BINARY", "YEAR", "MONTH", "DAY", "LEFT", "RIGHT",
  "OUTER", "SEMI", "ANTI", "SORT", "SEGMENTS", "PRESORTED", "PARTITION",
  "INSERT", "WHERE", "DISPLAY", "CASE", "WHEN", "THEN", "ELSE", "END",
  "SHOW", "TABLES", "TABLE", "DESCRIBE", "DROP", "CREATE", "INDEX",
  "INTERVAL", "APPEND", "';'", "'('", "')'", "'.'", "','", "'{'", "'}'",
  "':'", "$accept", "stmt_list", "stmt", "select_stmt", "expr",
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
     100,   100,   100,   100,   100,   100,   101,   101,   102,   102,
     102,   103,   103,   104,   104,   105,   105,   106,   107,   107,
     107,   107,   107,   107,   107,   107,   107,   107,   107,   107,
     107,   107,   107,   107,   108,   108,   109,   109,   109,   109
};

/* YYR2[YYN] -- Number of symbols composing right hand side of rule YYN.  */
static const yytype_uint8 yyr2[] =
{
       0,     2,     2,     3,     1,     7,    12,     5,     6,     8,
       9,     7,     8,     2,     7,     5,     7,     2,     3,    22,
       8,    10,     1,     3,     1,     1,     1,     1,     1,     1,
      11,     9,     6,     2,     2,     4,     4,     4,     4,     4,
       2,     4,     4,     4,     4,     3,     3,     3,     3,     3,
       3,     3,     3,     3,     3,     3,     3,     2,     2,     3,
       3,     5,     3,     8,     3,     4,     0,     3,     3,     5,
       1,     1,     3,     1,     3,     0,     1,     2,     4,     6,
       6,     6,     5,     5,     6,     5,     5,     7,     7,     6,
       7,     6,     7,     6,     0,     2,     0,     4,     7,     3
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
      70,     0,     0,     0,     0,     0,     0,     0,     0,     0,
       0,     0,     0,     0,     0,    94,     0,     0,     0,     0,
       0,     0,     7,    33,    34,     0,     0,     0,    40,    58,
      57,     0,     0,     0,     0,     0,     0,     0,     0,     0,
       0,     0,     0,     0,     0,     0,     0,     0,     0,     0,
       0,     0,     0,     0,     0,     0,     0,     0,     0,    75,
      15,     0,     0,    94,     0,     0,     0,     0,     0,     0,
      77,     0,    23,     0,     0,     0,     0,     0,     0,     0,
       0,     0,     0,    62,    52,    53,    54,    55,    51,    60,
      64,     0,     0,    59,    56,    45,    46,    47,    48,    49,
      50,    68,    66,     0,    73,    76,     8,     0,    95,     0,
      96,     0,    94,     0,     0,     0,    44,     0,    35,    36,
      37,    38,    39,    41,    42,    43,     0,    65,    22,     0,
       0,     0,     0,     0,     0,     5,    66,     0,     0,     0,
      96,     0,     0,    11,    14,    16,     0,     0,     0,     0,
       0,    61,     0,     0,     0,     0,     0,     0,     0,     0,
       0,     9,    69,    74,    94,    12,     0,     0,    20,     0,
       0,     0,    32,     0,     0,    67,     0,     0,     0,     0,
       0,     0,     0,    10,     0,    99,     0,     0,     0,     0,
       0,    78,     0,     0,     0,     0,     0,     0,     0,    97,
       0,    21,    71,     0,     0,    63,    86,    82,     0,     0,
      83,     0,     0,    85,     0,     0,     6,     0,    31,     0,
      89,    81,    79,    91,    84,    80,    93,     0,     0,    72,
       0,    90,    87,    92,    88,    98,     0,    30,     0,     0,
       0,     0,     0,     0,     0,     0,    19
};

/* YYDEFGOTO[NTERM-NUM].  */
static const yytype_int16 yydefgoto[] =
{
      -1,    10,    11,    12,   154,   185,    62,   253,   155,   156,
      72,   186,   114,   193
};

/* YYPACT[STATE-NUM] -- Index in YYTABLE of the portion describing
   STATE-NUM.  */
#define YYPACT_NINF -180
static const yytype_int16 yypact[] =
{
      99,    -6,   -26,    10,   -25,    33,    -2,    37,     9,   -55,
      92,   -36,  -180,   -22,    47,    51,    94,    53,  -180,  -180,
     112,   113,   115,  -180,    52,  -180,   132,   138,   196,   141,
      74,   144,   105,    64,  -180,    97,    98,  -180,   107,   116,
      95,  -180,  -180,  -180,  -180,  -180,  -180,   254,   254,   254,
    -180,    70,    75,    77,    79,    80,    84,    88,    90,   122,
     254,   691,   -30,   140,   254,   -48,   196,   184,   194,   195,
     119,   254,  -180,  -180,  -180,   204,   207,   206,   804,   453,
     453,   254,   254,   254,   254,   254,   254,   254,   254,   254,
     267,   254,   254,   254,   254,   254,   254,    -1,   312,   254,
     254,   254,   254,   254,   254,   254,   211,   212,   254,   254,
     749,   133,   215,   168,   167,   -23,   142,   139,   146,   233,
     749,   152,  -180,   149,   362,   390,   413,   441,   476,   504,
     527,   555,   641,  -180,   749,   317,   769,   788,   804,   820,
    -180,   236,    78,   567,   160,    13,    13,  -180,  -180,  -180,
    -180,  -180,   -29,   726,    93,  -180,  -180,   242,  -180,   189,
     -27,   248,   168,   249,   250,   175,  -180,   171,  -180,  -180,
    -180,  -180,  -180,  -180,  -180,  -180,   254,  -180,     0,   177,
     264,   229,   -39,   -37,   231,  -180,   230,   269,   254,   185,
     -27,   210,   244,  -180,  -180,  -180,    20,   197,   245,   284,
     618,  -180,   237,   254,   286,   252,   261,   299,   270,   271,
     301,  -180,  -180,  -180,   168,  -180,   283,   306,  -180,   320,
     321,   238,   251,   254,   254,  -180,   281,   322,   335,   287,
     337,   348,   296,  -180,   350,  -180,   265,   266,   254,   352,
     590,   668,   254,   302,   303,   254,   304,   311,   254,   293,
     333,  -180,   749,   -11,     7,  -180,  -180,   668,   254,   254,
     668,   254,   254,   668,   330,   375,  -180,   254,  -180,   374,
    -180,   668,   668,  -180,   668,   668,  -180,   377,   292,   749,
     295,  -180,  -180,  -180,  -180,  -180,   384,  -180,   325,   385,
     307,   395,   388,   403,   323,   404,  -180
};

/* YYPGOTO[NTERM-NUM].  */
static const yytype_int16 yypgoto[] =
{
    -180,  -180,   401,   274,   -28,   226,   347,  -180,  -179,  -180,
    -180,   -34,  -112,   227
};

/* YYTABLE[YYPACT[STATE-NUM]].  What to do in state STATE-NUM.  If
   positive, shift that token.  If negative, reduce the rule which
   number is the opposite.  If zero, do what YYDEFACT says.
   If YYTABLE_NINF, syntax error.  */
#define YYTABLE_NINF -1
static const yytype_int16 yytable[] =
{
      61,   159,   204,   111,   207,    13,   107,   140,   112,   213,
      14,    13,   180,   161,    15,   181,    26,    27,    16,    78,
      79,    80,   141,    28,   225,    29,   205,   206,   208,   209,
      21,    22,    90,   182,   183,   184,   110,    17,    61,   113,
     191,    19,   192,   120,   102,   103,   104,   105,    73,    74,
     195,    30,    25,   124,   125,   126,   127,   128,   129,   130,
     131,   132,   108,   134,   135,   136,   137,   138,   139,   108,
     143,   144,   145,   146,   147,   148,   149,   150,    18,   266,
     153,   267,   178,    41,    42,    43,    44,    45,    46,    75,
      20,    76,    23,    77,    31,    47,     1,   268,    32,   269,
      48,    49,   233,     1,    33,    91,    92,    93,    94,    95,
     218,   219,    96,    97,    90,     2,    34,    35,    98,    36,
       3,    99,   100,   101,   102,   103,   104,   105,    51,     2,
      52,    53,    54,    55,     3,    38,     2,    56,    57,    58,
      37,     3,    39,    73,    74,    63,    64,    65,   200,     4,
      66,     5,    59,    67,    68,    69,    71,     6,    70,    81,
       7,     8,     9,     4,    82,     5,    83,    60,    84,    85,
       4,     6,     5,    86,     7,     8,     9,    87,     6,    88,
     109,     7,     8,     9,    75,   188,    76,   116,    77,   100,
     101,   102,   103,   104,   105,   240,   241,    89,   117,   118,
      40,    41,    42,    43,    44,    45,    46,   256,   119,   121,
     252,   122,   123,    47,   257,   151,   152,   260,    48,    49,
     263,   158,   157,   270,   112,   160,   273,    50,   163,   276,
     271,   272,   162,   274,   275,   164,   165,   281,   282,   279,
     283,   284,   166,   167,   177,   189,    51,   190,    52,    53,
      54,    55,   194,   196,   197,    56,    57,    58,    40,    41,
      42,    43,    44,    45,    46,   198,   199,   201,   202,   203,
      59,    47,   210,   212,   181,   214,    48,    49,   216,    91,
      92,    93,    94,    95,   217,    60,    96,    97,   222,   220,
     226,   221,    98,   227,   224,    99,   100,   101,   102,   103,
     104,   105,   228,   229,    51,   232,    52,    53,    54,    55,
     235,   230,   231,    56,    57,    58,    40,    41,    42,    43,
      44,    45,    46,   234,   236,   237,   243,   238,    59,    47,
      92,    93,    94,    95,    48,    49,    96,    97,   242,   244,
     239,   246,    98,    60,   245,    99,   100,   101,   102,   103,
     104,   105,   247,   248,   249,   250,   251,   133,   254,   258,
     259,   261,    51,   264,    52,    53,    54,    55,   262,   265,
     277,    56,    57,    58,    91,    92,    93,    94,    95,   278,
     280,    96,    97,   285,   286,   287,    59,    98,   288,   290,
      99,   100,   101,   102,   103,   104,   105,   289,   291,   292,
     293,   142,    91,    92,    93,    94,    95,   294,   296,    96,
      97,    24,   211,   115,   295,    98,   179,   215,    99,   100,
     101,   102,   103,   104,   105,    91,    92,    93,    94,    95,
       0,     0,    96,    97,     0,     0,     0,     0,    98,     0,
       0,    99,   100,   101,   102,   103,   104,   105,     0,     0,
       0,     0,   168,    91,    92,    93,    94,    95,     0,     0,
      96,    97,     0,     0,     0,     0,    98,     0,     0,    99,
     100,   101,   102,   103,   104,   105,     0,     0,    98,     0,
     169,    99,   100,   101,   102,   103,   104,   105,    91,    92,
      93,    94,    95,     0,     0,    96,    97,     0,     0,     0,
       0,    98,     0,   170,    99,   100,   101,   102,   103,   104,
     105,     0,     0,     0,     0,     0,    91,    92,    93,    94,
      95,     0,     0,    96,    97,     0,     0,     0,     0,    98,
       0,   171,    99,   100,   101,   102,   103,   104,   105,    91,
      92,    93,    94,    95,     0,     0,    96,    97,     0,     0,
       0,     0,    98,     0,     0,    99,   100,   101,   102,   103,
     104,   105,     0,     0,     0,     0,   172,    91,    92,    93,
      94,    95,     0,     0,    96,    97,     0,     0,     0,     0,
      98,     0,     0,    99,   100,   101,   102,   103,   104,   105,
       0,     0,     0,     0,   173,    99,   100,   101,   102,   103,
     104,   105,    91,    92,    93,    94,    95,     0,     0,    96,
      97,     0,     0,     0,     0,    98,     0,   174,    99,   100,
     101,   102,   103,   104,   105,     0,     0,     0,     0,     0,
      91,    92,    93,    94,    95,     0,     0,    96,    97,     0,
       0,     0,     0,    98,     0,   175,    99,   100,   101,   102,
     103,   104,   105,    91,    92,    93,    94,    95,     0,     0,
      96,    97,     0,     0,     0,     0,    98,     0,   255,    99,
     100,   101,   102,   103,   104,   105,     0,     0,     0,     0,
      91,    92,    93,    94,    95,     0,     0,    96,    97,     0,
       0,     0,     0,    98,     0,   223,    99,   100,   101,   102,
     103,   104,   105,    91,    92,    93,    94,    95,     0,   180,
      96,    97,     0,     0,     0,     0,    98,   176,     0,    99,
     100,   101,   102,   103,   104,   105,     0,     0,     0,     0,
     182,   183,   184,     0,     0,     0,     0,   106,    91,    92,
      93,    94,    95,     0,     0,    96,    97,     0,     0,     0,
       0,    98,     0,     0,    99,   100,   101,   102,   103,   104,
     105,    91,    92,    93,    94,    95,     0,     0,    96,    97,
       0,     0,   187,     0,    98,     0,     0,    99,   100,   101,
     102,   103,   104,   105,    94,    95,     0,     0,    96,    97,
       0,     0,     0,     0,    98,     0,     0,    99,   100,   101,
     102,   103,   104,   105,    95,     0,     0,    96,    97,     0,
       0,     0,     0,    98,     0,     0,    99,   100,   101,   102,
     103,   104,   105,    96,    97,     0,     0,     0,     0,    98,
       0,     0,    99,   100,   101,   102,   103,   104,   105,    -1,
      -1,     0,     0,     0,     0,    98,     0,     0,    99,   100,
     101,   102,   103,   104,   105
};

static const yytype_int16 yycheck[] =
{
      28,   113,    41,    51,    41,    11,    36,     8,    56,   188,
      36,    11,    41,    36,     4,    44,    38,    39,    43,    47,
      48,    49,    23,    45,   203,    47,    65,    66,    65,    66,
      85,    86,    60,    62,    63,    64,    64,     4,    66,    87,
      67,     4,    69,    71,    31,    32,    33,    34,    48,    49,
     162,     4,    88,    81,    82,    83,    84,    85,    86,    87,
      88,    89,    92,    91,    92,    93,    94,    95,    96,    92,
      98,    99,   100,   101,   102,   103,   104,   105,    80,    90,
     108,    92,     4,     5,     6,     7,     8,     9,    10,    89,
      81,    91,     0,    93,    43,    17,     4,    90,     4,    92,
      22,    23,   214,     4,    51,    12,    13,    14,    15,    16,
      90,    91,    19,    20,   142,    37,     4,     4,    25,     4,
      42,    28,    29,    30,    31,    32,    33,    34,    50,    37,
      52,    53,    54,    55,    42,     3,    37,    59,    60,    61,
      88,    42,     4,    48,    49,     4,    72,     3,   176,    71,
      45,    73,    74,    89,    57,    57,    40,    79,    51,    89,
      82,    83,    84,    71,    89,    73,    89,    89,    89,    89,
      71,    79,    73,    89,    82,    83,    84,    89,    79,    89,
      40,    82,    83,    84,    89,    92,    91,     3,    93,    29,
      30,    31,    32,    33,    34,   223,   224,    75,     4,     4,
       4,     5,     6,     7,     8,     9,    10,   241,    89,     5,
     238,     4,     6,    17,   242,     4,     4,   245,    22,    23,
     248,     6,    89,   257,    56,    58,   260,    31,    89,   263,
     258,   259,    90,   261,   262,    89,     3,   271,   272,   267,
     274,   275,    90,    94,     8,     3,    50,    58,    52,    53,
      54,    55,     4,     4,     4,    59,    60,    61,     4,     5,
       6,     7,     8,     9,    10,    90,    95,    90,     4,    40,
      74,    17,    41,     4,    44,    90,    22,    23,    68,    12,
      13,    14,    15,    16,    40,    89,    19,    20,     4,    92,
       4,    46,    25,    41,    57,    28,    29,    30,    31,    32,
      33,    34,    41,     4,    50,     4,    52,    53,    54,    55,
       4,    41,    41,    59,    60,    61,     4,     5,     6,     7,
       8,     9,    10,    40,     4,     4,     4,    89,    74,    17,
      13,    14,    15,    16,    22,    23,    19,    20,    57,     4,
      89,     4,    25,    89,    57,    28,    29,    30,    31,    32,
      33,    34,     4,    57,     4,    90,    90,    90,     6,    57,
      57,    57,    50,    70,    52,    53,    54,    55,    57,    36,
      40,    59,    60,    61,    12,    13,    14,    15,    16,     4,
       6,    19,    20,     6,    92,    90,    74,    25,     4,     4,
      28,    29,    30,    31,    32,    33,    34,    72,    91,     4,
      12,    89,    12,    13,    14,    15,    16,     4,     4,    19,
      20,    10,   186,    66,    91,    25,   142,   190,    28,    29,
      30,    31,    32,    33,    34,    12,    13,    14,    15,    16,
      -1,    -1,    19,    20,    -1,    -1,    -1,    -1,    25,    -1,
      -1,    28,    29,    30,    31,    32,    33,    34,    -1,    -1,
      -1,    -1,    90,    12,    13,    14,    15,    16,    -1,    -1,
      19,    20,    -1,    -1,    -1,    -1,    25,    -1,    -1,    28,
      29,    30,    31,    32,    33,    34,    -1,    -1,    25,    -1,
      90,    28,    29,    30,    31,    32,    33,    34,    12,    13,
      14,    15,    16,    -1,    -1,    19,    20,    -1,    -1,    -1,
      -1,    25,    -1,    90,    28,    29,    30,    31,    32,    33,
      34,    -1,    -1,    -1,    -1,    -1,    12,    13,    14,    15,
      16,    -1,    -1,    19,    20,    -1,    -1,    -1,    -1,    25,
      -1,    90,    28,    29,    30,    31,    32,    33,    34,    12,
      13,    14,    15,    16,    -1,    -1,    19,    20,    -1,    -1,
      -1,    -1,    25,    -1,    -1,    28,    29,    30,    31,    32,
      33,    34,    -1,    -1,    -1,    -1,    90,    12,    13,    14,
      15,    16,    -1,    -1,    19,    20,    -1,    -1,    -1,    -1,
      25,    -1,    -1,    28,    29,    30,    31,    32,    33,    34,
      -1,    -1,    -1,    -1,    90,    28,    29,    30,    31,    32,
      33,    34,    12,    13,    14,    15,    16,    -1,    -1,    19,
      20,    -1,    -1,    -1,    -1,    25,    -1,    90,    28,    29,
      30,    31,    32,    33,    34,    -1,    -1,    -1,    -1,    -1,
      12,    13,    14,    15,    16,    -1,    -1,    19,    20,    -1,
      -1,    -1,    -1,    25,    -1,    90,    28,    29,    30,    31,
      32,    33,    34,    12,    13,    14,    15,    16,    -1,    -1,
      19,    20,    -1,    -1,    -1,    -1,    25,    -1,    78,    28,
      29,    30,    31,    32,    33,    34,    -1,    -1,    -1,    -1,
      12,    13,    14,    15,    16,    -1,    -1,    19,    20,    -1,
      -1,    -1,    -1,    25,    -1,    77,    28,    29,    30,    31,
      32,    33,    34,    12,    13,    14,    15,    16,    -1,    41,
      19,    20,    -1,    -1,    -1,    -1,    25,    76,    -1,    28,
      29,    30,    31,    32,    33,    34,    -1,    -1,    -1,    -1,
      62,    63,    64,    -1,    -1,    -1,    -1,    46,    12,    13,
      14,    15,    16,    -1,    -1,    19,    20,    -1,    -1,    -1,
      -1,    25,    -1,    -1,    28,    29,    30,    31,    32,    33,
      34,    12,    13,    14,    15,    16,    -1,    -1,    19,    20,
      -1,    -1,    46,    -1,    25,    -1,    -1,    28,    29,    30,
      31,    32,    33,    34,    15,    16,    -1,    -1,    19,    20,
      -1,    -1,    -1,    -1,    25,    -1,    -1,    28,    29,    30,
      31,    32,    33,    34,    16,    -1,    -1,    19,    20,    -1,
      -1,    -1,    -1,    25,    -1,    -1,    28,    29,    30,    31,
      32,    33,    34,    19,    20,    -1,    -1,    -1,    -1,    25,
      -1,    -1,    28,    29,    30,    31,    32,    33,    34,    19,
      20,    -1,    -1,    -1,    -1,    25,    -1,    -1,    28,    29,
      30,    31,    32,    33,    34
};

/* YYSTOS[STATE-NUM] -- The (internal number of the) accessing
   symbol of state STATE-NUM.  */
static const yytype_uint8 yystos[] =
{
       0,     4,    37,    42,    71,    73,    79,    82,    83,    84,
      97,    98,    99,    11,    36,     4,    43,     4,    80,     4,
      81,    85,    86,     0,    98,    88,    38,    39,    45,    47,
       4,    43,     4,    51,     4,     4,     4,    88,     3,     4,
       4,     5,     6,     7,     8,     9,    10,    17,    22,    23,
      31,    50,    52,    53,    54,    55,    59,    60,    61,    74,
      89,   100,   102,     4,    72,     3,    45,    89,    57,    57,
      51,    40,   106,    48,    49,    89,    91,    93,   100,   100,
     100,    89,    89,    89,    89,    89,    89,    89,    89,    75,
     100,    12,    13,    14,    15,    16,    19,    20,    25,    28,
      29,    30,    31,    32,    33,    34,    46,    36,    92,    40,
     100,    51,    56,    87,   108,   102,     3,     4,     4,    89,
     100,     5,     4,     6,   100,   100,   100,   100,   100,   100,
     100,   100,   100,    90,   100,   100,   100,   100,   100,   100,
       8,    23,    89,   100,   100,   100,   100,   100,   100,   100,
     100,     4,     4,   100,   100,   104,   105,    89,     6,   108,
      58,    36,    90,    89,    89,     3,    90,    94,    90,    90,
      90,    90,    90,    90,    90,    90,    76,     8,     4,    99,
      41,    44,    62,    63,    64,   101,   107,    46,    92,     3,
      58,    67,    69,   109,     4,   108,     4,     4,    90,    95,
     100,    90,     4,    40,    41,    65,    66,    41,    65,    66,
      41,   101,     4,   104,    90,   109,    68,    40,    90,    91,
      92,    46,     4,    77,    57,   104,     4,    41,    41,     4,
      41,    41,     4,   108,    40,     4,     4,     4,    89,    89,
     100,   100,    57,     4,     4,    57,     4,     4,    57,     4,
      90,    90,   100,   103,     6,    78,   107,   100,    57,    57,
     100,    57,    57,   100,    70,    36,    90,    92,    90,    92,
     107,   100,   100,   107,   100,   100,   107,    40,     4,   100,
       6,   107,   107,   107,   107,     6,    92,    90,     4,    72,
       4,    91,     4,    12,     4,    91,     4
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
#line 130 "bison.y"
    { emit("STMT"); ;}
    break;

  case 5:

/* Line 1455 of yacc.c  */
#line 134 "bison.y"
    { emit_select((yyvsp[(1) - (7)].strval), (yyvsp[(6) - (7)].strval), (yyvsp[(7) - (7)].intval)); ;}
    break;

  case 6:

/* Line 1455 of yacc.c  */
#line 136 "bison.y"
    {  emit_load((yyvsp[(1) - (12)].strval), (yyvsp[(4) - (12)].strval), (yyvsp[(11) - (12)].intval), (yyvsp[(7) - (12)].strval)); ;}
    break;

  case 7:

/* Line 1455 of yacc.c  */
#line 138 "bison.y"
    {  emit_filter((yyvsp[(1) - (5)].strval), (yyvsp[(4) - (5)].strval));;}
    break;

  case 8:

/* Line 1455 of yacc.c  */
#line 140 "bison.y"
    {  emit_order((yyvsp[(1) - (6)].strval), (yyvsp[(4) - (6)].strval), (yyvsp[(6) - (6)].intval));;}
    break;

  case 9:

/* Line 1455 of yacc.c  */
#line 142 "bison.y"
    {  emit_join((yyvsp[(1) - (8)].strval),(yyvsp[(6) - (8)].strval),(yyvsp[(7) - (8)].intval),0,-1); ;}
    break;

  case 10:

/* Line 1455 of yacc.c  */
#line 144 "bison.y"
    {  emit_store((yyvsp[(2) - (9)].strval),(yyvsp[(4) - (9)].strval),(yyvsp[(7) - (9)].strval)); ;}
    break;

  case 11:

/* Line 1455 of yacc.c  */
#line 146 "bison.y"
    {  emit_store_binary((yyvsp[(2) - (7)].strval),(yyvsp[(4) - (7)].strval),0); ;}
    break;

  case 12:

/* Line 1455 of yacc.c  */
#line 148 "bison.y"
    {  emit_store_binary((yyvsp[(2) - (8)].strval),(yyvsp[(4) - (8)].strval),1); ;}
    break;

  case 13:

/* Line 1455 of yacc.c  */
#line 150 "bison.y"
    {  emit_describe_table((yyvsp[(2) - (2)].strval));;}
    break;

  case 14:

/* Line 1455 of yacc.c  */
#line 152 "bison.y"
    {  emit_insert((yyvsp[(3) - (7)].strval), (yyvsp[(7) - (7)].strval));;}
    break;

  case 15:

/* Line 1455 of yacc.c  */
#line 154 "bison.y"
    {  emit_delete((yyvsp[(3) - (5)].strval));;}
    break;

  case 16:

/* Line 1455 of yacc.c  */
#line 156 "bison.y"
    {  emit_display((yyvsp[(2) - (7)].strval), (yyvsp[(5) - (7)].strval));;}
    break;

  case 17:

/* Line 1455 of yacc.c  */
#line 158 "bison.y"
    {  emit_show_tables();;}
    break;

  case 18:

/* Line 1455 of yacc.c  */
#line 160 "bison.y"
    {  emit_drop_table((yyvsp[(3) - (3)].strval));;}
    break;

  case 19:

/* Line 1455 of yacc.c  */
#line 162 "bison.y"
    {  emit_create_bitmap_index((yyvsp[(3) - (22)].strval), (yyvsp[(5) - (22)].strval), (yyvsp[(7) - (22)].strval), (yyvsp[(9) - (22)].strval), (yyvsp[(18) - (22)].strval), (yyvsp[(22) - (22)].strval));;}
    break;

  case 20:

/* Line 1455 of yacc.c  */
#line 164 "bison.y"
    {  emit_create_index((yyvsp[(3) - (8)].strval), (yyvsp[(5) - (8)].strval), (yyvsp[(7) - (8)].strval));;}
    break;

  case 21:

/* Line 1455 of yacc.c  */
#line 166 "bison.y"
    {  emit_create_interval((yyvsp[(3) - (10)].strval), (yyvsp[(5) - (10)].strval), (yyvsp[(7) - (10)].strval), (yyvsp[(9) - (10)].strval));;}
    break;

  case 22:

/* Line 1455 of yacc.c  */
#line 171 "bison.y"
    { emit_name((yyvsp[(1) - (1)].strval)); ;}
    break;

  case 23:

/* Line 1455 of yacc.c  */
#line 172 "bison.y"
    { emit_fieldname((yyvsp[(1) - (3)].strval), (yyvsp[(3) - (3)].strval)); ;}
    break;

  case 24:

/* Line 1455 of yacc.c  */
#line 173 "bison.y"
    { emit("USERVAR %s", (yyvsp[(1) - (1)].strval)); ;}
    break;

  case 25:

/* Line 1455 of yacc.c  */
#line 174 "bison.y"
    { emit_string((yyvsp[(1) - (1)].strval)); ;}
    break;

  case 26:

/* Line 1455 of yacc.c  */
#line 175 "bison.y"
    { emit_number((yyvsp[(1) - (1)].intval)); ;}
    break;

  case 27:

/* Line 1455 of yacc.c  */
#line 176 "bison.y"
    { emit_decimal((yyvsp[(1) - (1)].strval)); ;}
    break;

  case 28:

/* Line 1455 of yacc.c  */
#line 177 "bison.y"
    { emit_float((yyvsp[(1) - (1)].floatval)); ;}
    break;

  case 29:

/* Line 1455 of yacc.c  */
#line 178 "bison.y"
    { emit("BOOL %d", (yyvsp[(1) - (1)].intval)); ;}
    break;

  case 30:

/* Line 1455 of yacc.c  */
#line 179 "bison.y"
    { emit_vardecimal((yyvsp[(1) - (11)].strval), (yyvsp[(3) - (11)].intval), (yyvsp[(6) - (11)].strval),  (yyvsp[(8) - (11)].intval), (yyvsp[(10) - (11)].intval));;}
    break;

  case 31:

/* Line 1455 of yacc.c  */
#line 180 "bison.y"
    { emit_varchar((yyvsp[(1) - (9)].strval), (yyvsp[(3) - (9)].intval), (yyvsp[(6) - (9)].strval), (yyvsp[(8) - (9)].intval), "", "");;}
    break;

  case 32:

/* Line 1455 of yacc.c  */
#line 181 "bison.y"
    { emit_var((yyvsp[(1) - (6)].strval), (yyvsp[(3) - (6)].intval), (yyvsp[(6) - (6)].strval), "", "");;}
    break;

  case 33:

/* Line 1455 of yacc.c  */
#line 182 "bison.y"
    { emit_var_asc((yyvsp[(1) - (2)].strval));;}
    break;

  case 34:

/* Line 1455 of yacc.c  */
#line 183 "bison.y"
    { emit_var_desc((yyvsp[(1) - (2)].strval));;}
    break;

  case 35:

/* Line 1455 of yacc.c  */
#line 184 "bison.y"
    { emit_count(); ;}
    break;

  case 36:

/* Line 1455 of yacc.c  */
#line 185 "bison.y"
    { emit_sum(); ;}
    break;

  case 37:

/* Line 1455 of yacc.c  */
#line 186 "bison.y"
    { emit_average(); ;}
    break;

  case 38:

/* Line 1455 of yacc.c  */
#line 187 "bison.y"
    { emit_min(); ;}
    break;

  case 39:

/* Line 1455 of yacc.c  */
#line 188 "bison.y"
    { emit_max(); ;}
    break;

  case 40:

/* Line 1455 of yacc.c  */
#line 189 "bison.y"
    { emit_distinct(); ;}
    break;

  case 41:

/* Line 1455 of yacc.c  */
#line 190 "bison.y"
    { emit_year(); ;}
    break;

  case 42:

/* Line 1455 of yacc.c  */
#line 191 "bison.y"
    { emit_month(); ;}
    break;

  case 43:

/* Line 1455 of yacc.c  */
#line 192 "bison.y"
    { emit_day(); ;}
    break;

  case 44:

/* Line 1455 of yacc.c  */
#line 193 "bison.y"
    { emit_string_grp((yyvsp[(1) - (4)].strval), (yyvsp[(3) - (4)].strval)); ;}
    break;

  case 45:

/* Line 1455 of yacc.c  */
#line 197 "bison.y"
    { emit_add(); ;}
    break;

  case 46:

/* Line 1455 of yacc.c  */
#line 198 "bison.y"
    { emit_minus(); ;}
    break;

  case 47:

/* Line 1455 of yacc.c  */
#line 199 "bison.y"
    { emit_mul(); ;}
    break;

  case 48:

/* Line 1455 of yacc.c  */
#line 200 "bison.y"
    { emit_div(); ;}
    break;

  case 49:

/* Line 1455 of yacc.c  */
#line 201 "bison.y"
    { emit("MOD"); ;}
    break;

  case 50:

/* Line 1455 of yacc.c  */
#line 202 "bison.y"
    { emit("MOD"); ;}
    break;

  case 51:

/* Line 1455 of yacc.c  */
#line 203 "bison.y"
    { emit_and(); ;}
    break;

  case 52:

/* Line 1455 of yacc.c  */
#line 204 "bison.y"
    { emit_eq(); ;}
    break;

  case 53:

/* Line 1455 of yacc.c  */
#line 205 "bison.y"
    { emit_neq(); ;}
    break;

  case 54:

/* Line 1455 of yacc.c  */
#line 206 "bison.y"
    { emit_or(); ;}
    break;

  case 55:

/* Line 1455 of yacc.c  */
#line 207 "bison.y"
    { emit("XOR"); ;}
    break;

  case 56:

/* Line 1455 of yacc.c  */
#line 208 "bison.y"
    { emit("SHIFT %s", (yyvsp[(2) - (3)].subtok)==1?"left":"right"); ;}
    break;

  case 57:

/* Line 1455 of yacc.c  */
#line 209 "bison.y"
    { emit("NOT"); ;}
    break;

  case 58:

/* Line 1455 of yacc.c  */
#line 210 "bison.y"
    { emit("NOT"); ;}
    break;

  case 59:

/* Line 1455 of yacc.c  */
#line 211 "bison.y"
    { emit_cmp((yyvsp[(2) - (3)].subtok)); ;}
    break;

  case 60:

/* Line 1455 of yacc.c  */
#line 212 "bison.y"
    { emit_cmp(7); ;}
    break;

  case 61:

/* Line 1455 of yacc.c  */
#line 214 "bison.y"
    { emit("CMPSELECT %d", (yyvsp[(2) - (5)].subtok)); ;}
    break;

  case 62:

/* Line 1455 of yacc.c  */
#line 215 "bison.y"
    {emit("EXPR");;}
    break;

  case 63:

/* Line 1455 of yacc.c  */
#line 216 "bison.y"
    { emit_case(); ;}
    break;

  case 64:

/* Line 1455 of yacc.c  */
#line 220 "bison.y"
    { emit("ISBOOL %d", (yyvsp[(3) - (3)].intval)); ;}
    break;

  case 65:

/* Line 1455 of yacc.c  */
#line 221 "bison.y"
    { emit("ISBOOL %d", (yyvsp[(4) - (4)].intval)); emit("NOT"); ;}
    break;

  case 66:

/* Line 1455 of yacc.c  */
#line 224 "bison.y"
    { /* nil */
    (yyval.intval) = 0;
;}
    break;

  case 67:

/* Line 1455 of yacc.c  */
#line 227 "bison.y"
    { (yyval.intval) = (yyvsp[(3) - (3)].intval);;}
    break;

  case 68:

/* Line 1455 of yacc.c  */
#line 231 "bison.y"
    { (yyval.intval) = 1; emit_sel_name((yyvsp[(3) - (3)].strval));;}
    break;

  case 69:

/* Line 1455 of yacc.c  */
#line 232 "bison.y"
    { (yyval.intval) = (yyvsp[(1) - (5)].intval) + 1; emit_sel_name((yyvsp[(5) - (5)].strval));;}
    break;

  case 70:

/* Line 1455 of yacc.c  */
#line 233 "bison.y"
    { emit_sel_name("*");;}
    break;

  case 71:

/* Line 1455 of yacc.c  */
#line 237 "bison.y"
    { (yyval.intval) = 1; ;}
    break;

  case 72:

/* Line 1455 of yacc.c  */
#line 238 "bison.y"
    {(yyval.intval) = (yyvsp[(1) - (3)].intval) + 1; ;}
    break;

  case 73:

/* Line 1455 of yacc.c  */
#line 242 "bison.y"
    { (yyval.intval) = 1; ;}
    break;

  case 74:

/* Line 1455 of yacc.c  */
#line 243 "bison.y"
    { (yyval.intval) = 1 + (yyvsp[(3) - (3)].intval); ;}
    break;

  case 75:

/* Line 1455 of yacc.c  */
#line 246 "bison.y"
    { /* nil */
    (yyval.intval) = 0;
;}
    break;

  case 77:

/* Line 1455 of yacc.c  */
#line 251 "bison.y"
    { emit("FILTER BY"); ;}
    break;

  case 78:

/* Line 1455 of yacc.c  */
#line 255 "bison.y"
    { (yyval.intval) = 1; emit_join_tab((yyvsp[(2) - (4)].strval), 'I');;}
    break;

  case 79:

/* Line 1455 of yacc.c  */
#line 256 "bison.y"
    { (yyval.intval) = 1; emit_join_tab((yyvsp[(4) - (6)].strval), '3');;}
    break;

  case 80:

/* Line 1455 of yacc.c  */
#line 257 "bison.y"
    { (yyval.intval) = 1; emit_join_tab((yyvsp[(4) - (6)].strval), '4');;}
    break;

  case 81:

/* Line 1455 of yacc.c  */
#line 258 "bison.y"
    { (yyval.intval) = 1; emit_join_tab((yyvsp[(4) - (6)].strval), '1');;}
    break;

  case 82:

/* Line 1455 of yacc.c  */
#line 259 "bison.y"
    { (yyval.intval) = 1; emit_join_tab((yyvsp[(3) - (5)].strval), 'S');;}
    break;

  case 83:

/* Line 1455 of yacc.c  */
#line 260 "bison.y"
    { (yyval.intval) = 1; emit_join_tab((yyvsp[(3) - (5)].strval), 'R');;}
    break;

  case 84:

/* Line 1455 of yacc.c  */
#line 261 "bison.y"
    { (yyval.intval) = 1; emit_join_tab((yyvsp[(4) - (6)].strval), '2');;}
    break;

  case 85:

/* Line 1455 of yacc.c  */
#line 262 "bison.y"
    { (yyval.intval) = 1; emit_join_tab((yyvsp[(3) - (5)].strval), 'O');;}
    break;

  case 86:

/* Line 1455 of yacc.c  */
#line 263 "bison.y"
    { (yyval.intval) = 1; emit_join_tab((yyvsp[(2) - (5)].strval), 'I'); ;}
    break;

  case 87:

/* Line 1455 of yacc.c  */
#line 264 "bison.y"
    { (yyval.intval) = 1; emit_join_tab((yyvsp[(4) - (7)].strval), '3'); ;}
    break;

  case 88:

/* Line 1455 of yacc.c  */
#line 265 "bison.y"
    { (yyval.intval) = 1; emit_join_tab((yyvsp[(4) - (7)].strval), '4'); ;}
    break;

  case 89:

/* Line 1455 of yacc.c  */
#line 266 "bison.y"
    { (yyval.intval) = 1; emit_join_tab((yyvsp[(3) - (6)].strval), 'L'); ;}
    break;

  case 90:

/* Line 1455 of yacc.c  */
#line 267 "bison.y"
    { (yyval.intval) = 1; emit_join_tab((yyvsp[(4) - (7)].strval), '1'); ;}
    break;

  case 91:

/* Line 1455 of yacc.c  */
#line 268 "bison.y"
    { (yyval.intval) = 1; emit_join_tab((yyvsp[(3) - (6)].strval), 'R'); ;}
    break;

  case 92:

/* Line 1455 of yacc.c  */
#line 269 "bison.y"
    { (yyval.intval) = 1; emit_join_tab((yyvsp[(4) - (7)].strval), 'R'); ;}
    break;

  case 93:

/* Line 1455 of yacc.c  */
#line 270 "bison.y"
    { (yyval.intval) = 1; emit_join_tab((yyvsp[(3) - (6)].strval), 'O'); ;}
    break;

  case 94:

/* Line 1455 of yacc.c  */
#line 272 "bison.y"
    { /* nil */
    (yyval.intval) = 0;
;}
    break;

  case 95:

/* Line 1455 of yacc.c  */
#line 275 "bison.y"
    { emit_limit((yyvsp[(2) - (2)].intval)); ;}
    break;

  case 96:

/* Line 1455 of yacc.c  */
#line 277 "bison.y"
    { /* nil */
    (yyval.intval) = 0;
;}
    break;

  case 97:

/* Line 1455 of yacc.c  */
#line 280 "bison.y"
    { emit_sort((yyvsp[(4) - (4)].strval), 0); ;}
    break;

  case 98:

/* Line 1455 of yacc.c  */
#line 281 "bison.y"
    { emit_sort((yyvsp[(4) - (7)].strval), (yyvsp[(7) - (7)].intval)); ;}
    break;

  case 99:

/* Line 1455 of yacc.c  */
#line 282 "bison.y"
    { emit_presort((yyvsp[(3) - (3)].strval)); ;}
    break;



/* Line 1455 of yacc.c  */
#line 2445 "bison.tab.c"
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
#line 284 "bison.y"


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



