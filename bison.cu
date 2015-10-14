
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
     OR = 268,
     XOR = 269,
     AND = 270,
     DISTINCT = 271,
     YEAR = 272,
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
     MULITE = 283,
     DELETE = 284,
     LOAD = 285,
     FILTER = 286,
     BY = 287,
     JOIN = 288,
     STORE = 289,
     INTO = 290,
     GROUP = 291,
     SELECT = 292,
     AS = 293,
     ORDER = 294,
     ASC = 295,
     DESC = 296,
     COUNT = 297,
     USING = 298,
     SUM = 299,
     AVG = 300,
     MIN = 301,
     MAX = 302,
     LIMIT = 303,
     ON = 304,
     BINARY = 305,
     LEFT = 306,
     RIGHT = 307,
     OUTER = 308,
     SORT = 309,
     SEGMENTS = 310,
     PRESORTED = 311,
     PARTITION = 312,
     INSERT = 313,
     WHERE = 314,
     DISPLAY = 315,
     CASE = 316,
     WHEN = 317,
     THEN = 318,
     ELSE = 319,
     END = 320,
     SHOW = 321,
     TABLES = 322,
     TABLE = 323,
     DESCRIBE = 324,
     DROP = 325,
     CREATE = 326,
     INDEX = 327
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
#line 201 "bison.cu"
} YYSTYPE;
# define YYSTYPE_IS_TRIVIAL 1
# define yystype YYSTYPE /* obsolescent; will be withdrawn */
# define YYSTYPE_IS_DECLARED 1
#endif


/* Copy the second part of user declarations.  */


/* Line 264 of yacc.c  */
#line 213 "bison.cu"

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
#define YYLAST   755

/* YYNTOKENS -- Number of terminals.  */
#define YYNTOKENS  90
/* YYNNTS -- Number of nonterminals.  */
#define YYNNTS  14
/* YYNRULES -- Number of rules.  */
#define YYNRULES  84
/* YYNRULES -- Number of states.  */
#define YYNSTATES  246

/* YYTRANSLATE(YYLEX) -- Bison symbol number corresponding to YYLEX.  */
#define YYUNDEFTOK  2
#define YYMAXUTOK   327

#define YYTRANSLATE(YYX)						\
  ((unsigned int) (YYX) <= YYMAXUTOK ? yytranslate[YYX] : YYUNDEFTOK)

/* YYTRANSLATE[YYLEX] -- Bison symbol number corresponding to YYLEX.  */
static const yytype_uint8 yytranslate[] =
{
       0,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,    22,     2,     2,     2,    33,    27,     2,
      83,    84,    31,    29,    86,    30,    85,    32,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,    89,    82,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,    35,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,    87,    26,    88,     2,     2,     2,     2,
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
      74,    75,    76,    77,    78,    79,    80,    81
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
     258,   261,   264,   268,   272,   278,   282,   291,   295,   300,
     301,   305,   309,   315,   317,   319,   323,   325,   329,   330,
     332,   335,   340,   346,   352,   358,   364,   371,   378,   385,
     386,   389,   390,   395,   403
};

/* YYRHS -- A `-1'-separated list of the rules' RHS.  */
static const yytype_int8 yyrhs[] =
{
      91,     0,    -1,    92,    82,    -1,    91,    92,    82,    -1,
      93,    -1,     4,    11,    46,    96,    36,     4,    95,    -1,
       4,    11,    39,     3,    52,    83,     3,    84,    47,    83,
      97,    84,    -1,     4,    11,    40,     4,   100,    -1,     4,
      11,    48,     4,    41,    99,    -1,     4,    11,    46,    96,
      36,     4,   101,    95,    -1,    43,     4,    44,     3,    52,
      83,     3,    84,   102,    -1,    43,     4,    44,     3,   102,
      59,   103,    -1,    78,     4,    -1,    67,    44,     4,    46,
      96,    36,     4,    -1,    38,    36,     4,    68,    94,    -1,
      69,     4,    52,    83,     3,    84,   102,    -1,    75,    76,
      -1,    79,    77,     4,    -1,    80,    81,     4,    58,     4,
      83,     4,    85,     4,    84,    36,     4,    86,     4,    68,
       4,    85,     4,    12,     4,    85,     4,    -1,     4,    -1,
       4,    85,     4,    -1,    10,    -1,     5,    -1,     6,    -1,
       7,    -1,     9,    -1,     8,    -1,     4,    87,     6,    88,
      89,     4,    83,     6,    86,     6,    84,    -1,     4,    87,
       6,    88,    89,     4,    83,     6,    84,    -1,     4,    87,
       6,    88,    89,     4,    -1,     4,    49,    -1,     4,    50,
      -1,    51,    83,    94,    84,    -1,    53,    83,    94,    84,
      -1,    54,    83,    94,    84,    -1,    55,    83,    94,    84,
      -1,    56,    83,    94,    84,    -1,    16,    94,    -1,    17,
      83,    94,    84,    -1,    94,    29,    94,    -1,    94,    30,
      94,    -1,    94,    31,    94,    -1,    94,    32,    94,    -1,
      94,    33,    94,    -1,    94,    34,    94,    -1,    94,    15,
      94,    -1,    94,    12,    94,    -1,    94,    13,    94,    -1,
      94,    14,    94,    -1,    94,    28,    94,    -1,    23,    94,
      -1,    22,    94,    -1,    94,    25,    94,    -1,    94,    19,
      94,    -1,    94,    25,    83,    93,    84,    -1,    83,    94,
      84,    -1,    70,    71,    94,    72,    94,    73,    94,    74,
      -1,    94,    20,     8,    -1,    94,    20,    23,     8,    -1,
      -1,    45,    41,    98,    -1,    94,    47,     4,    -1,    96,
      86,    94,    47,     4,    -1,    31,    -1,    94,    -1,    97,
      86,    94,    -1,    94,    -1,    94,    86,    98,    -1,    -1,
      98,    -1,    41,    94,    -1,    42,     4,    58,    94,    -1,
      60,    42,     4,    58,    94,    -1,    61,    42,     4,    58,
      94,    -1,    62,    42,     4,    58,    94,    -1,    42,     4,
      58,    94,   101,    -1,    60,    42,     4,    58,    94,   101,
      -1,    61,    42,     4,    58,    94,   101,    -1,    62,    42,
       4,    58,    94,   101,    -1,    -1,    57,     6,    -1,    -1,
      63,    64,    41,     4,    -1,    63,    64,    41,     4,    66,
      41,     6,    -1,    65,    41,     4,    -1
};

/* YYRLINE[YYN] -- source line where rule number YYN was defined.  */
static const yytype_uint16 yyrline[] =
{
       0,   120,   120,   121,   125,   128,   130,   132,   134,   136,
     138,   140,   142,   144,   146,   148,   150,   152,   154,   159,
     160,   161,   162,   163,   164,   165,   166,   167,   168,   169,
     170,   171,   172,   173,   174,   175,   176,   177,   178,   182,
     183,   184,   185,   186,   187,   189,   190,   191,   192,   193,
     194,   195,   196,   197,   199,   200,   201,   205,   206,   209,
     212,   216,   217,   218,   222,   223,   227,   228,   231,   233,
     236,   240,   241,   242,   243,   244,   245,   246,   247,   249,
     252,   254,   257,   258,   259
};
#endif

#if YYDEBUG || YYERROR_VERBOSE || YYTOKEN_TABLE
/* YYTNAME[SYMBOL-NUM] -- String name of the symbol SYMBOL-NUM.
   First, the terminals, then, starting at YYNTOKENS, nonterminals.  */
static const char *const yytname[] =
{
  "$end", "error", "$undefined", "FILENAME", "NAME", "STRING", "INTNUM",
  "DECIMAL1", "BOOL1", "APPROXNUM", "USERVAR", "ASSIGN", "EQUAL", "OR",
  "XOR", "AND", "DISTINCT", "YEAR", "REGEXP", "LIKE", "IS", "IN", "'!'",
  "NOT", "BETWEEN", "COMPARISON", "'|'", "'&'", "SHIFT", "'+'", "'-'",
  "'*'", "'/'", "'%'", "MOD", "'^'", "FROM", "MULITE", "DELETE", "LOAD",
  "FILTER", "BY", "JOIN", "STORE", "INTO", "GROUP", "SELECT", "AS",
  "ORDER", "ASC", "DESC", "COUNT", "USING", "SUM", "AVG", "MIN", "MAX",
  "LIMIT", "ON", "BINARY", "LEFT", "RIGHT", "OUTER", "SORT", "SEGMENTS",
  "PRESORTED", "PARTITION", "INSERT", "WHERE", "DISPLAY", "CASE", "WHEN",
  "THEN", "ELSE", "END", "SHOW", "TABLES", "TABLE", "DESCRIBE", "DROP",
  "CREATE", "INDEX", "';'", "'('", "')'", "'.'", "','", "'{'", "'}'",
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
     326,   327,    59,    40,    41,    46,    44,   123,   125,    58
};
# endif

/* YYR1[YYN] -- Symbol number of symbol that rule YYN derives.  */
static const yytype_uint8 yyr1[] =
{
       0,    90,    91,    91,    92,    93,    93,    93,    93,    93,
      93,    93,    93,    93,    93,    93,    93,    93,    93,    94,
      94,    94,    94,    94,    94,    94,    94,    94,    94,    94,
      94,    94,    94,    94,    94,    94,    94,    94,    94,    94,
      94,    94,    94,    94,    94,    94,    94,    94,    94,    94,
      94,    94,    94,    94,    94,    94,    94,    94,    94,    95,
      95,    96,    96,    96,    97,    97,    98,    98,    99,    99,
     100,   101,   101,   101,   101,   101,   101,   101,   101,   102,
     102,   103,   103,   103,   103
};

/* YYR2[YYN] -- Number of symbols composing right hand side of rule YYN.  */
static const yytype_uint8 yyr2[] =
{
       0,     2,     2,     3,     1,     7,    12,     5,     6,     8,
       9,     7,     2,     7,     5,     7,     2,     3,    22,     1,
       3,     1,     1,     1,     1,     1,     1,    11,     9,     6,
       2,     2,     4,     4,     4,     4,     4,     2,     4,     3,
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
       0,     0,     4,     0,     0,     0,     0,     0,    16,    12,
       0,     0,     1,     0,     2,     0,     0,     0,     0,     0,
       0,     0,     0,    17,     0,     3,     0,     0,    19,    22,
      23,    24,    26,    25,    21,     0,     0,     0,     0,    63,
       0,     0,     0,     0,     0,     0,     0,     0,     0,     0,
       0,    79,     0,     0,     0,     0,     0,     7,    30,    31,
       0,     0,    37,     0,    51,    50,     0,     0,     0,     0,
       0,     0,     0,     0,     0,     0,     0,     0,     0,     0,
       0,     0,     0,     0,     0,     0,     0,     0,     0,     0,
      68,    14,     0,     0,     0,     0,     0,     0,     0,    70,
      20,     0,     0,     0,     0,     0,     0,     0,     0,    55,
      46,    47,    48,    45,    53,    57,     0,     0,    52,    49,
      39,    40,    41,    42,    43,    44,    61,    59,     0,    66,
      69,     8,     0,    80,    81,     0,    79,     0,     0,     0,
      38,    32,    33,    34,    35,    36,     0,    58,    19,     0,
       0,     0,     0,     0,     0,     5,    59,     0,     0,     0,
       0,     0,    11,    13,    15,     0,     0,     0,     0,    54,
       0,     0,     0,     0,     0,     9,    62,    67,    79,     0,
       0,     0,     0,    29,     0,     0,    60,     0,     0,     0,
      10,     0,    84,     0,     0,     0,     0,    71,     0,     0,
       0,    82,     0,    64,     0,     0,    56,    75,    72,    73,
      74,     0,     0,     6,     0,    28,     0,    76,    77,    78,
       0,     0,    65,     0,    83,     0,    27,     0,     0,     0,
       0,     0,     0,     0,     0,    18
};

/* YYDEFGOTO[NTERM-NUM].  */
static const yytype_int16 yydefgoto[] =
{
      -1,    10,    11,    12,   139,   165,    58,   214,   140,   141,
      67,   166,   104,   172
};

/* YYPACT[STATE-NUM] -- Index in YYTABLE of the portion describing
   STATE-NUM.  */
#define YYPACT_NINF -205
static const yytype_int16 yypact[] =
{
      32,     2,   -17,    23,   -13,    33,   -38,    40,   -32,   -33,
       4,    -8,  -205,    69,    73,    52,    98,    53,  -205,  -205,
     102,   109,  -205,    39,  -205,   111,   119,   182,   121,    58,
     124,    82,    47,  -205,    75,  -205,    79,    99,    31,  -205,
    -205,  -205,  -205,  -205,  -205,   202,    56,   202,   202,  -205,
      66,    70,    71,    72,    74,    87,   202,   615,   -31,   122,
     202,   -40,   182,   149,   158,    83,   202,  -205,  -205,  -205,
     161,   170,   285,   202,   113,   113,   202,   202,   202,   202,
     202,   202,   316,   202,   202,   202,   202,   202,    -1,   270,
     202,   202,   202,   202,   202,   202,   202,   174,   175,   202,
     202,   664,    97,   178,   126,   -25,   110,   112,   190,   664,
    -205,   108,   344,   373,   401,   430,   458,   487,   567,  -205,
     664,   685,   705,   285,   721,  -205,   192,    81,   141,   197,
      61,    61,  -205,  -205,  -205,  -205,  -205,   -36,   641,   269,
    -205,  -205,   198,  -205,   -35,   199,   145,   210,   131,   127,
    -205,  -205,  -205,  -205,  -205,  -205,   202,  -205,    -9,   133,
     216,   180,   181,   200,   201,  -205,   177,   228,   202,   150,
     176,   203,  -205,  -205,  -205,   154,   194,   241,   544,  -205,
     188,   202,   243,   244,   245,  -205,  -205,  -205,   145,   209,
     247,   250,   179,   183,   202,   202,  -205,   205,   206,   211,
    -205,   255,  -205,   184,   202,   254,   515,   590,   202,   202,
     202,   195,   231,   664,   -52,    36,  -205,  -205,   590,   590,
     590,   229,   267,  -205,   202,  -205,   284,  -205,  -205,  -205,
     289,   187,   664,   207,  -205,   292,  -205,   238,   303,   223,
     305,   299,   308,   235,   318,  -205
};

/* YYPGOTO[NTERM-NUM].  */
static const yytype_int16 yypgoto[] =
{
    -205,  -205,   317,   212,   -27,   166,   271,  -205,  -158,  -205,
    -205,  -204,  -145,  -205
};

/* YYTABLE[YYPACT[STATE-NUM]].  What to do in state STATE-NUM.  If
   positive, shift that token.  If negative, reduce the rule which
   number is the opposite.  If zero, do what YYDEFACT says.
   If YYTABLE_NINF, syntax error.  */
#define YYTABLE_NINF -1
static const yytype_int16 yytable[] =
{
      57,   174,    13,   217,    22,    98,   160,   125,     1,   161,
     187,   145,   102,    13,   227,   228,   229,   103,    72,    14,
      74,    75,   126,   196,   162,   163,   164,    15,   170,    82,
     171,    16,   223,   101,   224,    57,     1,    17,    18,   109,
      68,    69,     2,   200,    19,    20,   112,     3,    21,   113,
     114,   115,   116,   117,   118,    99,   120,   121,   122,   123,
     124,    99,   128,   129,   130,   131,   132,   133,   134,   135,
       2,     4,   138,     5,    24,     3,    70,    29,    71,     6,
      68,    69,     7,     8,     9,   158,    39,    40,    41,    42,
      43,    44,    93,    94,    95,    96,    30,    45,    46,     4,
      82,     5,    31,    47,    48,    32,    33,     6,    25,    26,
       7,     8,     9,    34,    36,    27,    70,    28,    71,     2,
     225,    35,   226,    37,     3,    59,    60,    61,    62,   178,
      63,    65,    50,    64,    51,    52,    53,    54,    89,    73,
      66,    90,    91,    92,    93,    94,    95,    96,     4,    76,
       5,    55,   106,    77,    78,    79,     6,    80,    81,     7,
       8,     9,   107,   100,    56,   110,   108,   206,   207,    90,
      91,    92,    93,    94,    95,    96,   111,   213,   136,   137,
     142,   218,   219,   220,   143,   144,    38,    39,    40,    41,
      42,    43,    44,   148,   146,   147,   149,   232,    45,    46,
     157,   169,   103,   173,    47,    48,    38,    39,    40,    41,
      42,    43,    44,    49,   175,   176,   177,   179,    45,    46,
     180,   181,   161,   182,    47,    48,    91,    92,    93,    94,
      95,    96,   186,    50,   188,    51,    52,    53,    54,   191,
     189,   192,   183,   184,   190,   193,   195,   197,   198,   199,
     201,   202,    55,    50,   203,    51,    52,    53,    54,   211,
     215,   221,   204,   208,   209,    56,   205,   222,   212,   210,
     230,   231,    55,   235,    38,    39,    40,    41,    42,    43,
      44,    83,    84,    85,    86,    56,    45,    46,    87,    88,
     233,   236,    47,    48,    89,   234,   237,    90,    91,    92,
      93,    94,    95,    96,    87,    88,   238,   239,   240,   241,
      89,   242,   243,    90,    91,    92,    93,    94,    95,    96,
     244,    50,   245,    51,    52,    53,    54,    23,    83,    84,
      85,    86,   185,   105,     0,    87,    88,     0,     0,   159,
      55,    89,     0,     0,    90,    91,    92,    93,    94,    95,
      96,     0,     0,   127,     0,   168,    83,    84,    85,    86,
       0,     0,     0,    87,    88,     0,     0,     0,     0,    89,
       0,     0,    90,    91,    92,    93,    94,    95,    96,     0,
       0,     0,     0,     0,     0,    83,    84,    85,    86,     0,
       0,     0,    87,    88,     0,     0,     0,     0,    89,     0,
     119,    90,    91,    92,    93,    94,    95,    96,     0,     0,
       0,     0,     0,    83,    84,    85,    86,     0,     0,     0,
      87,    88,     0,     0,     0,     0,    89,     0,   150,    90,
      91,    92,    93,    94,    95,    96,     0,     0,     0,     0,
       0,     0,    83,    84,    85,    86,     0,     0,     0,    87,
      88,     0,     0,     0,     0,    89,     0,   151,    90,    91,
      92,    93,    94,    95,    96,     0,     0,     0,     0,     0,
      83,    84,    85,    86,     0,     0,     0,    87,    88,     0,
       0,     0,     0,    89,     0,   152,    90,    91,    92,    93,
      94,    95,    96,     0,     0,     0,     0,     0,     0,    83,
      84,    85,    86,     0,     0,     0,    87,    88,     0,     0,
       0,     0,    89,     0,   153,    90,    91,    92,    93,    94,
      95,    96,     0,     0,     0,     0,     0,    83,    84,    85,
      86,     0,     0,     0,    87,    88,     0,     0,     0,     0,
      89,     0,   154,    90,    91,    92,    93,    94,    95,    96,
       0,     0,     0,     0,     0,     0,    83,    84,    85,    86,
       0,     0,     0,    87,    88,     0,     0,     0,     0,    89,
       0,   155,    90,    91,    92,    93,    94,    95,    96,    83,
      84,    85,    86,     0,     0,     0,    87,    88,     0,   216,
       0,     0,    89,     0,     0,    90,    91,    92,    93,    94,
      95,    96,    83,    84,    85,    86,     0,     0,     0,    87,
      88,     0,     0,     0,     0,    89,     0,   194,    90,    91,
      92,    93,    94,    95,    96,     0,     0,    83,    84,    85,
      86,     0,   160,     0,    87,    88,     0,     0,     0,   156,
      89,     0,     0,    90,    91,    92,    93,    94,    95,    96,
     162,   163,   164,    83,    84,    85,    86,     0,     0,     0,
      87,    88,    97,     0,     0,     0,    89,     0,     0,    90,
      91,    92,    93,    94,    95,    96,    83,    84,    85,    86,
       0,     0,     0,    87,    88,     0,     0,     0,   167,    89,
       0,     0,    90,    91,    92,    93,    94,    95,    96,    85,
      86,     0,     0,     0,    87,    88,     0,     0,     0,     0,
      89,     0,     0,    90,    91,    92,    93,    94,    95,    96,
      86,     0,     0,     0,    87,    88,     0,     0,     0,     0,
      89,     0,     0,    90,    91,    92,    93,    94,    95,    96,
      -1,    -1,     0,     0,     0,     0,    89,     0,     0,    90,
      91,    92,    93,    94,    95,    96
};

static const yytype_int16 yycheck[] =
{
      27,   146,    11,   207,     0,    36,    42,     8,     4,    45,
     168,    36,    52,    11,   218,   219,   220,    57,    45,    36,
      47,    48,    23,   181,    60,    61,    62,     4,    63,    56,
      65,    44,    84,    60,    86,    62,     4,     4,    76,    66,
      49,    50,    38,   188,     4,    77,    73,    43,    81,    76,
      77,    78,    79,    80,    81,    86,    83,    84,    85,    86,
      87,    86,    89,    90,    91,    92,    93,    94,    95,    96,
      38,    67,    99,    69,    82,    43,    85,     4,    87,    75,
      49,    50,    78,    79,    80,     4,     5,     6,     7,     8,
       9,    10,    31,    32,    33,    34,    44,    16,    17,    67,
     127,    69,     4,    22,    23,    52,     4,    75,    39,    40,
      78,    79,    80,     4,     3,    46,    85,    48,    87,    38,
      84,    82,    86,     4,    43,     4,    68,     3,    46,   156,
      83,    52,    51,    58,    53,    54,    55,    56,    25,    83,
      41,    28,    29,    30,    31,    32,    33,    34,    67,    83,
      69,    70,     3,    83,    83,    83,    75,    83,    71,    78,
      79,    80,     4,    41,    83,     4,    83,   194,   195,    28,
      29,    30,    31,    32,    33,    34,     6,   204,     4,     4,
      83,   208,   209,   210,     6,    59,     4,     5,     6,     7,
       8,     9,    10,     3,    84,    83,    88,   224,    16,    17,
       8,     3,    57,     4,    22,    23,     4,     5,     6,     7,
       8,     9,    10,    31,     4,    84,    89,    84,    16,    17,
       4,    41,    45,    42,    22,    23,    29,    30,    31,    32,
      33,    34,     4,    51,    84,    53,    54,    55,    56,    85,
      64,    47,    42,    42,    41,     4,    58,     4,     4,     4,
      41,     4,    70,    51,     4,    53,    54,    55,    56,     4,
       6,    66,    83,    58,    58,    83,    83,    36,    84,    58,
      41,     4,    70,    86,     4,     5,     6,     7,     8,     9,
      10,    12,    13,    14,    15,    83,    16,    17,    19,    20,
       6,    84,    22,    23,    25,     6,     4,    28,    29,    30,
      31,    32,    33,    34,    19,    20,    68,     4,    85,     4,
      25,    12,     4,    28,    29,    30,    31,    32,    33,    34,
      85,    51,     4,    53,    54,    55,    56,    10,    12,    13,
      14,    15,   166,    62,    -1,    19,    20,    -1,    -1,   127,
      70,    25,    -1,    -1,    28,    29,    30,    31,    32,    33,
      34,    -1,    -1,    83,    -1,    86,    12,    13,    14,    15,
      -1,    -1,    -1,    19,    20,    -1,    -1,    -1,    -1,    25,
      -1,    -1,    28,    29,    30,    31,    32,    33,    34,    -1,
      -1,    -1,    -1,    -1,    -1,    12,    13,    14,    15,    -1,
      -1,    -1,    19,    20,    -1,    -1,    -1,    -1,    25,    -1,
      84,    28,    29,    30,    31,    32,    33,    34,    -1,    -1,
      -1,    -1,    -1,    12,    13,    14,    15,    -1,    -1,    -1,
      19,    20,    -1,    -1,    -1,    -1,    25,    -1,    84,    28,
      29,    30,    31,    32,    33,    34,    -1,    -1,    -1,    -1,
      -1,    -1,    12,    13,    14,    15,    -1,    -1,    -1,    19,
      20,    -1,    -1,    -1,    -1,    25,    -1,    84,    28,    29,
      30,    31,    32,    33,    34,    -1,    -1,    -1,    -1,    -1,
      12,    13,    14,    15,    -1,    -1,    -1,    19,    20,    -1,
      -1,    -1,    -1,    25,    -1,    84,    28,    29,    30,    31,
      32,    33,    34,    -1,    -1,    -1,    -1,    -1,    -1,    12,
      13,    14,    15,    -1,    -1,    -1,    19,    20,    -1,    -1,
      -1,    -1,    25,    -1,    84,    28,    29,    30,    31,    32,
      33,    34,    -1,    -1,    -1,    -1,    -1,    12,    13,    14,
      15,    -1,    -1,    -1,    19,    20,    -1,    -1,    -1,    -1,
      25,    -1,    84,    28,    29,    30,    31,    32,    33,    34,
      -1,    -1,    -1,    -1,    -1,    -1,    12,    13,    14,    15,
      -1,    -1,    -1,    19,    20,    -1,    -1,    -1,    -1,    25,
      -1,    84,    28,    29,    30,    31,    32,    33,    34,    12,
      13,    14,    15,    -1,    -1,    -1,    19,    20,    -1,    74,
      -1,    -1,    25,    -1,    -1,    28,    29,    30,    31,    32,
      33,    34,    12,    13,    14,    15,    -1,    -1,    -1,    19,
      20,    -1,    -1,    -1,    -1,    25,    -1,    73,    28,    29,
      30,    31,    32,    33,    34,    -1,    -1,    12,    13,    14,
      15,    -1,    42,    -1,    19,    20,    -1,    -1,    -1,    72,
      25,    -1,    -1,    28,    29,    30,    31,    32,    33,    34,
      60,    61,    62,    12,    13,    14,    15,    -1,    -1,    -1,
      19,    20,    47,    -1,    -1,    -1,    25,    -1,    -1,    28,
      29,    30,    31,    32,    33,    34,    12,    13,    14,    15,
      -1,    -1,    -1,    19,    20,    -1,    -1,    -1,    47,    25,
      -1,    -1,    28,    29,    30,    31,    32,    33,    34,    14,
      15,    -1,    -1,    -1,    19,    20,    -1,    -1,    -1,    -1,
      25,    -1,    -1,    28,    29,    30,    31,    32,    33,    34,
      15,    -1,    -1,    -1,    19,    20,    -1,    -1,    -1,    -1,
      25,    -1,    -1,    28,    29,    30,    31,    32,    33,    34,
      19,    20,    -1,    -1,    -1,    -1,    25,    -1,    -1,    28,
      29,    30,    31,    32,    33,    34
};

/* YYSTOS[STATE-NUM] -- The (internal number of the) accessing
   symbol of state STATE-NUM.  */
static const yytype_uint8 yystos[] =
{
       0,     4,    38,    43,    67,    69,    75,    78,    79,    80,
      91,    92,    93,    11,    36,     4,    44,     4,    76,     4,
      77,    81,     0,    92,    82,    39,    40,    46,    48,     4,
      44,     4,    52,     4,     4,    82,     3,     4,     4,     5,
       6,     7,     8,     9,    10,    16,    17,    22,    23,    31,
      51,    53,    54,    55,    56,    70,    83,    94,    96,     4,
      68,     3,    46,    83,    58,    52,    41,   100,    49,    50,
      85,    87,    94,    83,    94,    94,    83,    83,    83,    83,
      83,    71,    94,    12,    13,    14,    15,    19,    20,    25,
      28,    29,    30,    31,    32,    33,    34,    47,    36,    86,
      41,    94,    52,    57,   102,    96,     3,     4,    83,    94,
       4,     6,    94,    94,    94,    94,    94,    94,    94,    84,
      94,    94,    94,    94,    94,     8,    23,    83,    94,    94,
      94,    94,    94,    94,    94,    94,     4,     4,    94,    94,
      98,    99,    83,     6,    59,    36,    84,    83,     3,    88,
      84,    84,    84,    84,    84,    84,    72,     8,     4,    93,
      42,    45,    60,    61,    62,    95,   101,    47,    86,     3,
      63,    65,   103,     4,   102,     4,    84,    89,    94,    84,
       4,    41,    42,    42,    42,    95,     4,    98,    84,    64,
      41,    85,    47,     4,    73,    58,    98,     4,     4,     4,
     102,    41,     4,     4,    83,    83,    94,    94,    58,    58,
      58,     4,    84,    94,    97,     6,    74,   101,    94,    94,
      94,    66,    36,    84,    86,    84,    86,   101,   101,   101,
      41,     4,    94,     6,     6,    86,    84,     4,    68,     4,
      85,     4,    12,     4,    85,     4
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
#line 125 "bison.y"
    { emit("STMT"); ;}
    break;

  case 5:

/* Line 1455 of yacc.c  */
#line 129 "bison.y"
    { emit_select((yyvsp[(1) - (7)].strval), (yyvsp[(6) - (7)].strval), (yyvsp[(7) - (7)].intval)); ;}
    break;

  case 6:

/* Line 1455 of yacc.c  */
#line 131 "bison.y"
    {  emit_load((yyvsp[(1) - (12)].strval), (yyvsp[(4) - (12)].strval), (yyvsp[(11) - (12)].intval), (yyvsp[(7) - (12)].strval)); ;}
    break;

  case 7:

/* Line 1455 of yacc.c  */
#line 133 "bison.y"
    {  emit_filter((yyvsp[(1) - (5)].strval), (yyvsp[(4) - (5)].strval));;}
    break;

  case 8:

/* Line 1455 of yacc.c  */
#line 135 "bison.y"
    {  emit_order((yyvsp[(1) - (6)].strval), (yyvsp[(4) - (6)].strval), (yyvsp[(6) - (6)].intval));;}
    break;

  case 9:

/* Line 1455 of yacc.c  */
#line 137 "bison.y"
    {  emit_join((yyvsp[(1) - (8)].strval),(yyvsp[(6) - (8)].strval),(yyvsp[(7) - (8)].intval),0,-1); ;}
    break;

  case 10:

/* Line 1455 of yacc.c  */
#line 139 "bison.y"
    {  emit_store((yyvsp[(2) - (9)].strval),(yyvsp[(4) - (9)].strval),(yyvsp[(7) - (9)].strval)); ;}
    break;

  case 11:

/* Line 1455 of yacc.c  */
#line 141 "bison.y"
    {  emit_store_binary((yyvsp[(2) - (7)].strval),(yyvsp[(4) - (7)].strval)); ;}
    break;

  case 12:

/* Line 1455 of yacc.c  */
#line 143 "bison.y"
    {  emit_describe_table((yyvsp[(2) - (2)].strval));;}
    break;

  case 13:

/* Line 1455 of yacc.c  */
#line 145 "bison.y"
    {  emit_insert((yyvsp[(3) - (7)].strval), (yyvsp[(7) - (7)].strval));;}
    break;

  case 14:

/* Line 1455 of yacc.c  */
#line 147 "bison.y"
    {  emit_delete((yyvsp[(3) - (5)].strval));;}
    break;

  case 15:

/* Line 1455 of yacc.c  */
#line 149 "bison.y"
    {  emit_display((yyvsp[(2) - (7)].strval), (yyvsp[(5) - (7)].strval));;}
    break;

  case 16:

/* Line 1455 of yacc.c  */
#line 151 "bison.y"
    {  emit_show_tables();;}
    break;

  case 17:

/* Line 1455 of yacc.c  */
#line 153 "bison.y"
    {  emit_drop_table((yyvsp[(3) - (3)].strval));;}
    break;

  case 18:

/* Line 1455 of yacc.c  */
#line 155 "bison.y"
    {  emit_create_bitmap_index((yyvsp[(3) - (22)].strval), (yyvsp[(5) - (22)].strval), (yyvsp[(7) - (22)].strval), (yyvsp[(9) - (22)].strval), (yyvsp[(18) - (22)].strval), (yyvsp[(22) - (22)].strval));;}
    break;

  case 19:

/* Line 1455 of yacc.c  */
#line 159 "bison.y"
    { emit_name((yyvsp[(1) - (1)].strval)); ;}
    break;

  case 20:

/* Line 1455 of yacc.c  */
#line 160 "bison.y"
    { emit_fieldname((yyvsp[(1) - (3)].strval), (yyvsp[(3) - (3)].strval)); ;}
    break;

  case 21:

/* Line 1455 of yacc.c  */
#line 161 "bison.y"
    { emit("USERVAR %s", (yyvsp[(1) - (1)].strval)); ;}
    break;

  case 22:

/* Line 1455 of yacc.c  */
#line 162 "bison.y"
    { emit_string((yyvsp[(1) - (1)].strval)); ;}
    break;

  case 23:

/* Line 1455 of yacc.c  */
#line 163 "bison.y"
    { emit_number((yyvsp[(1) - (1)].intval)); ;}
    break;

  case 24:

/* Line 1455 of yacc.c  */
#line 164 "bison.y"
    { emit_decimal((yyvsp[(1) - (1)].strval)); ;}
    break;

  case 25:

/* Line 1455 of yacc.c  */
#line 165 "bison.y"
    { emit_float((yyvsp[(1) - (1)].floatval)); ;}
    break;

  case 26:

/* Line 1455 of yacc.c  */
#line 166 "bison.y"
    { emit("BOOL %d", (yyvsp[(1) - (1)].intval)); ;}
    break;

  case 27:

/* Line 1455 of yacc.c  */
#line 167 "bison.y"
    { emit_vardecimal((yyvsp[(1) - (11)].strval), (yyvsp[(3) - (11)].intval), (yyvsp[(6) - (11)].strval),  (yyvsp[(8) - (11)].intval), (yyvsp[(10) - (11)].intval));;}
    break;

  case 28:

/* Line 1455 of yacc.c  */
#line 168 "bison.y"
    { emit_varchar((yyvsp[(1) - (9)].strval), (yyvsp[(3) - (9)].intval), (yyvsp[(6) - (9)].strval), (yyvsp[(8) - (9)].intval), "", "");;}
    break;

  case 29:

/* Line 1455 of yacc.c  */
#line 169 "bison.y"
    { emit_var((yyvsp[(1) - (6)].strval), (yyvsp[(3) - (6)].intval), (yyvsp[(6) - (6)].strval), "", "");;}
    break;

  case 30:

/* Line 1455 of yacc.c  */
#line 170 "bison.y"
    { emit_var_asc((yyvsp[(1) - (2)].strval));;}
    break;

  case 31:

/* Line 1455 of yacc.c  */
#line 171 "bison.y"
    { emit_var_desc((yyvsp[(1) - (2)].strval));;}
    break;

  case 32:

/* Line 1455 of yacc.c  */
#line 172 "bison.y"
    { emit_count(); ;}
    break;

  case 33:

/* Line 1455 of yacc.c  */
#line 173 "bison.y"
    { emit_sum(); ;}
    break;

  case 34:

/* Line 1455 of yacc.c  */
#line 174 "bison.y"
    { emit_average(); ;}
    break;

  case 35:

/* Line 1455 of yacc.c  */
#line 175 "bison.y"
    { emit_min(); ;}
    break;

  case 36:

/* Line 1455 of yacc.c  */
#line 176 "bison.y"
    { emit_max(); ;}
    break;

  case 37:

/* Line 1455 of yacc.c  */
#line 177 "bison.y"
    { emit_distinct(); ;}
    break;

  case 38:

/* Line 1455 of yacc.c  */
#line 178 "bison.y"
    { emit_year(); ;}
    break;

  case 39:

/* Line 1455 of yacc.c  */
#line 182 "bison.y"
    { emit_add(); ;}
    break;

  case 40:

/* Line 1455 of yacc.c  */
#line 183 "bison.y"
    { emit_minus(); ;}
    break;

  case 41:

/* Line 1455 of yacc.c  */
#line 184 "bison.y"
    { emit_mul(); ;}
    break;

  case 42:

/* Line 1455 of yacc.c  */
#line 185 "bison.y"
    { emit_div(); ;}
    break;

  case 43:

/* Line 1455 of yacc.c  */
#line 186 "bison.y"
    { emit("MOD"); ;}
    break;

  case 44:

/* Line 1455 of yacc.c  */
#line 187 "bison.y"
    { emit("MOD"); ;}
    break;

  case 45:

/* Line 1455 of yacc.c  */
#line 189 "bison.y"
    { emit_and(); ;}
    break;

  case 46:

/* Line 1455 of yacc.c  */
#line 190 "bison.y"
    { emit_eq(); ;}
    break;

  case 47:

/* Line 1455 of yacc.c  */
#line 191 "bison.y"
    { emit_or(); ;}
    break;

  case 48:

/* Line 1455 of yacc.c  */
#line 192 "bison.y"
    { emit("XOR"); ;}
    break;

  case 49:

/* Line 1455 of yacc.c  */
#line 193 "bison.y"
    { emit("SHIFT %s", (yyvsp[(2) - (3)].subtok)==1?"left":"right"); ;}
    break;

  case 50:

/* Line 1455 of yacc.c  */
#line 194 "bison.y"
    { emit("NOT"); ;}
    break;

  case 51:

/* Line 1455 of yacc.c  */
#line 195 "bison.y"
    { emit("NOT"); ;}
    break;

  case 52:

/* Line 1455 of yacc.c  */
#line 196 "bison.y"
    { emit_cmp((yyvsp[(2) - (3)].subtok)); ;}
    break;

  case 53:

/* Line 1455 of yacc.c  */
#line 197 "bison.y"
    { emit_cmp(7); ;}
    break;

  case 54:

/* Line 1455 of yacc.c  */
#line 199 "bison.y"
    { emit("CMPSELECT %d", (yyvsp[(2) - (5)].subtok)); ;}
    break;

  case 55:

/* Line 1455 of yacc.c  */
#line 200 "bison.y"
    {emit("EXPR");;}
    break;

  case 56:

/* Line 1455 of yacc.c  */
#line 201 "bison.y"
    { emit_case(); ;}
    break;

  case 57:

/* Line 1455 of yacc.c  */
#line 205 "bison.y"
    { emit("ISBOOL %d", (yyvsp[(3) - (3)].intval)); ;}
    break;

  case 58:

/* Line 1455 of yacc.c  */
#line 206 "bison.y"
    { emit("ISBOOL %d", (yyvsp[(4) - (4)].intval)); emit("NOT"); ;}
    break;

  case 59:

/* Line 1455 of yacc.c  */
#line 209 "bison.y"
    { /* nil */
    (yyval.intval) = 0;
;}
    break;

  case 60:

/* Line 1455 of yacc.c  */
#line 212 "bison.y"
    { (yyval.intval) = (yyvsp[(3) - (3)].intval);;}
    break;

  case 61:

/* Line 1455 of yacc.c  */
#line 216 "bison.y"
    { (yyval.intval) = 1; emit_sel_name((yyvsp[(3) - (3)].strval));;}
    break;

  case 62:

/* Line 1455 of yacc.c  */
#line 217 "bison.y"
    { (yyval.intval) = (yyvsp[(1) - (5)].intval) + 1; emit_sel_name((yyvsp[(5) - (5)].strval));;}
    break;

  case 63:

/* Line 1455 of yacc.c  */
#line 218 "bison.y"
    { emit_sel_name("*");;}
    break;

  case 64:

/* Line 1455 of yacc.c  */
#line 222 "bison.y"
    { (yyval.intval) = 1; ;}
    break;

  case 65:

/* Line 1455 of yacc.c  */
#line 223 "bison.y"
    {(yyval.intval) = (yyvsp[(1) - (3)].intval) + 1; ;}
    break;

  case 66:

/* Line 1455 of yacc.c  */
#line 227 "bison.y"
    { (yyval.intval) = 1; ;}
    break;

  case 67:

/* Line 1455 of yacc.c  */
#line 228 "bison.y"
    { (yyval.intval) = 1 + (yyvsp[(3) - (3)].intval); ;}
    break;

  case 68:

/* Line 1455 of yacc.c  */
#line 231 "bison.y"
    { /* nil */
    (yyval.intval) = 0;
;}
    break;

  case 70:

/* Line 1455 of yacc.c  */
#line 236 "bison.y"
    { emit("FILTER BY"); ;}
    break;

  case 71:

/* Line 1455 of yacc.c  */
#line 240 "bison.y"
    { (yyval.intval) = 1; emit_join_tab((yyvsp[(2) - (4)].strval), 'I');;}
    break;

  case 72:

/* Line 1455 of yacc.c  */
#line 241 "bison.y"
    { (yyval.intval) = 1; emit_join_tab((yyvsp[(3) - (5)].strval), 'L');;}
    break;

  case 73:

/* Line 1455 of yacc.c  */
#line 242 "bison.y"
    { (yyval.intval) = 1; emit_join_tab((yyvsp[(3) - (5)].strval), 'R');;}
    break;

  case 74:

/* Line 1455 of yacc.c  */
#line 243 "bison.y"
    { (yyval.intval) = 1; emit_join_tab((yyvsp[(3) - (5)].strval), 'O');;}
    break;

  case 75:

/* Line 1455 of yacc.c  */
#line 244 "bison.y"
    { (yyval.intval) = 1; emit_join_tab((yyvsp[(2) - (5)].strval), 'I'); ;}
    break;

  case 76:

/* Line 1455 of yacc.c  */
#line 245 "bison.y"
    { (yyval.intval) = 1; emit_join_tab((yyvsp[(3) - (6)].strval), 'L'); ;}
    break;

  case 77:

/* Line 1455 of yacc.c  */
#line 246 "bison.y"
    { (yyval.intval) = 1; emit_join_tab((yyvsp[(3) - (6)].strval), 'R'); ;}
    break;

  case 78:

/* Line 1455 of yacc.c  */
#line 247 "bison.y"
    { (yyval.intval) = 1; emit_join_tab((yyvsp[(3) - (6)].strval), 'O'); ;}
    break;

  case 79:

/* Line 1455 of yacc.c  */
#line 249 "bison.y"
    { /* nil */
    (yyval.intval) = 0;
;}
    break;

  case 80:

/* Line 1455 of yacc.c  */
#line 252 "bison.y"
    { emit_limit((yyvsp[(2) - (2)].intval)); ;}
    break;

  case 81:

/* Line 1455 of yacc.c  */
#line 254 "bison.y"
    { /* nil */
    (yyval.intval) = 0;
;}
    break;

  case 82:

/* Line 1455 of yacc.c  */
#line 257 "bison.y"
    { emit_sort((yyvsp[(4) - (4)].strval), 0); ;}
    break;

  case 83:

/* Line 1455 of yacc.c  */
#line 258 "bison.y"
    { emit_sort((yyvsp[(4) - (7)].strval), (yyvsp[(7) - (7)].intval)); ;}
    break;

  case 84:

/* Line 1455 of yacc.c  */
#line 259 "bison.y"
    { emit_presort((yyvsp[(3) - (3)].strval)); ;}
    break;



/* Line 1455 of yacc.c  */
#line 2281 "bison.cu"
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
#line 261 "bison.y"


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



