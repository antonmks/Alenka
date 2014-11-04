
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
     DROP = 325,
     CREATE = 326,
     BITMAP = 327,
     INDEX = 328
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
#line 202 "bison.cu"
} YYSTYPE;
# define YYSTYPE_IS_TRIVIAL 1
# define yystype YYSTYPE /* obsolescent; will be withdrawn */
# define YYSTYPE_IS_DECLARED 1
#endif


/* Copy the second part of user declarations.  */


/* Line 264 of yacc.c  */
#line 214 "bison.cu"

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
#define YYLAST   643

/* YYNTOKENS -- Number of terminals.  */
#define YYNTOKENS  91
/* YYNNTS -- Number of nonterminals.  */
#define YYNNTS  14
/* YYNRULES -- Number of rules.  */
#define YYNRULES  84
/* YYNRULES -- Number of states.  */
#define YYNSTATES  250

/* YYTRANSLATE(YYLEX) -- Bison symbol number corresponding to YYLEX.  */
#define YYUNDEFTOK  2
#define YYMAXUTOK   328

#define YYTRANSLATE(YYX)						\
  ((unsigned int) (YYX) <= YYMAXUTOK ? yytranslate[YYX] : YYUNDEFTOK)

/* YYTRANSLATE[YYLEX] -- Bison symbol number corresponding to YYLEX.  */
static const yytype_uint8 yytranslate[] =
{
       0,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,    21,     2,     2,     2,    32,    26,     2,
      84,    85,    30,    28,    87,    29,    86,    31,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,    90,    83,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,    34,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,    88,    25,    89,     2,     2,     2,     2,
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
      74,    75,    76,    77,    78,    79,    80,    81,    82
};

#if YYDEBUG
/* YYPRHS[YYN] -- Index of the first RHS symbol of rule number YYN in
   YYRHS.  */
static const yytype_uint16 yyprhs[] =
{
       0,     0,     3,     6,    10,    12,    20,    33,    39,    46,
      55,    65,    73,    76,    84,    90,    98,   101,   105,   129,
     131,   135,   137,   139,   141,   143,   145,   147,   162,   172,
     184,   191,   194,   197,   202,   207,   212,   217,   222,   225,
     229,   233,   237,   241,   245,   249,   253,   257,   261,   265,
     269,   272,   275,   279,   283,   289,   293,   302,   306,   311,
     312,   316,   320,   326,   328,   330,   334,   336,   340,   341,
     343,   346,   351,   357,   363,   369,   375,   382,   389,   396,
     397,   400,   401,   406,   414
};

/* YYRHS -- A `-1'-separated list of the rules' RHS.  */
static const yytype_int8 yyrhs[] =
{
      92,     0,    -1,    93,    83,    -1,    92,    93,    83,    -1,
      94,    -1,     4,    11,    45,    97,    35,     4,    96,    -1,
       4,    11,    38,     3,    51,    84,     3,    85,    46,    84,
      98,    85,    -1,     4,    11,    39,     4,   101,    -1,     4,
      11,    47,     4,    40,   100,    -1,     4,    11,    45,    97,
      35,     4,   102,    96,    -1,    42,     4,    43,     3,    51,
      84,     3,    85,   103,    -1,    42,     4,    43,     3,   103,
      58,   104,    -1,    78,     4,    -1,    66,    43,     4,    45,
      97,    35,     4,    -1,    37,    35,     4,    67,    95,    -1,
      68,     4,    51,    84,     3,    85,   103,    -1,    75,    76,
      -1,    79,    77,     4,    -1,    80,    81,    82,     4,    57,
       4,    84,     4,    86,     4,    85,    35,     4,    87,     4,
      67,     4,    86,     4,    12,     4,    86,     4,    -1,     4,
      -1,     4,    86,     4,    -1,    10,    -1,     5,    -1,     6,
      -1,     9,    -1,     7,    -1,     8,    -1,     4,    88,     6,
      89,    90,     4,    84,     6,    85,    74,     4,    84,     4,
      85,    -1,     4,    88,     6,    89,    90,     4,    84,     6,
      85,    -1,     4,    88,     6,    89,    90,     4,    74,     4,
      84,     4,    85,    -1,     4,    88,     6,    89,    90,     4,
      -1,     4,    48,    -1,     4,    49,    -1,    50,    84,    95,
      85,    -1,    52,    84,    95,    85,    -1,    53,    84,    95,
      85,    -1,    54,    84,    95,    85,    -1,    55,    84,    95,
      85,    -1,    16,    95,    -1,    95,    28,    95,    -1,    95,
      29,    95,    -1,    95,    30,    95,    -1,    95,    31,    95,
      -1,    95,    32,    95,    -1,    95,    33,    95,    -1,    95,
      15,    95,    -1,    95,    12,    95,    -1,    95,    13,    95,
      -1,    95,    14,    95,    -1,    95,    27,    95,    -1,    22,
      95,    -1,    21,    95,    -1,    95,    24,    95,    -1,    95,
      18,    95,    -1,    95,    24,    84,    94,    85,    -1,    84,
      95,    85,    -1,    69,    70,    95,    71,    95,    72,    95,
      73,    -1,    95,    19,     8,    -1,    95,    19,    22,     8,
      -1,    -1,    44,    40,    99,    -1,    95,    46,     4,    -1,
      97,    87,    95,    46,     4,    -1,    30,    -1,    95,    -1,
      98,    87,    95,    -1,    95,    -1,    95,    87,    99,    -1,
      -1,    99,    -1,    40,    95,    -1,    41,     4,    57,    95,
      -1,    59,    41,     4,    57,    95,    -1,    60,    41,     4,
      57,    95,    -1,    61,    41,     4,    57,    95,    -1,    41,
       4,    57,    95,   102,    -1,    59,    41,     4,    57,    95,
     102,    -1,    60,    41,     4,    57,    95,   102,    -1,    61,
      41,     4,    57,    95,   102,    -1,    -1,    56,     6,    -1,
      -1,    62,    63,    40,     4,    -1,    62,    63,    40,     4,
      65,    40,     6,    -1,    64,    40,     4,    -1
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
  "XOR", "AND", "DISTINCT", "REGEXP", "LIKE", "IS", "IN", "'!'", "NOT",
  "BETWEEN", "COMPARISON", "'|'", "'&'", "SHIFT", "'+'", "'-'", "'*'",
  "'/'", "'%'", "MOD", "'^'", "FROM", "MULITE", "DELETE", "LOAD", "FILTER",
  "BY", "JOIN", "STORE", "INTO", "GROUP", "SELECT", "AS", "ORDER", "ASC",
  "DESC", "COUNT", "USING", "SUM", "AVG", "MIN", "MAX", "LIMIT", "ON",
  "BINARY", "LEFT", "RIGHT", "OUTER", "SORT", "SEGMENTS", "PRESORTED",
  "PARTITION", "INSERT", "WHERE", "DISPLAY", "CASE", "WHEN", "THEN",
  "ELSE", "END", "REFERENCES", "SHOW", "TABLES", "TABLE", "DESCRIBE",
  "DROP", "CREATE", "BITMAP", "INDEX", "';'", "'('", "')'", "'.'", "','",
  "'{'", "'}'", "':'", "$accept", "stmt_list", "stmt", "select_stmt",
  "expr", "opt_group_list", "expr_list", "load_list", "val_list",
  "opt_val_list", "opt_where", "join_list", "opt_limit", "sort_def", 0
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
     326,   327,   328,    59,    40,    41,    46,    44,   123,   125,
      58
};
# endif

/* YYR1[YYN] -- Symbol number of symbol that rule YYN derives.  */
static const yytype_uint8 yyr1[] =
{
       0,    91,    92,    92,    93,    94,    94,    94,    94,    94,
      94,    94,    94,    94,    94,    94,    94,    94,    94,    95,
      95,    95,    95,    95,    95,    95,    95,    95,    95,    95,
      95,    95,    95,    95,    95,    95,    95,    95,    95,    95,
      95,    95,    95,    95,    95,    95,    95,    95,    95,    95,
      95,    95,    95,    95,    95,    95,    95,    95,    95,    96,
      96,    97,    97,    97,    98,    98,    99,    99,   100,   100,
     101,   102,   102,   102,   102,   102,   102,   102,   102,   103,
     103,   104,   104,   104,   104
};

/* YYR2[YYN] -- Number of symbols composing right hand side of rule YYN.  */
static const yytype_uint8 yyr2[] =
{
       0,     2,     2,     3,     1,     7,    12,     5,     6,     8,
       9,     7,     2,     7,     5,     7,     2,     3,    23,     1,
       3,     1,     1,     1,     1,     1,     1,    14,     9,    11,
       6,     2,     2,     4,     4,     4,     4,     4,     2,     3,
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
      23,    25,    26,    24,    21,     0,     0,     0,    63,     0,
       0,     0,     0,     0,     0,     0,     0,     0,     0,     0,
      79,     0,     0,     0,     0,     0,     7,    31,    32,     0,
       0,    38,    51,    50,     0,     0,     0,     0,     0,     0,
       0,     0,     0,     0,     0,     0,     0,     0,     0,     0,
       0,     0,     0,     0,     0,     0,     0,     0,    68,    14,
       0,     0,     0,     0,     0,     0,     0,    70,    20,     0,
       0,     0,     0,     0,     0,     0,    55,    46,    47,    48,
      45,    53,    57,     0,     0,    52,    49,    39,    40,    41,
      42,    43,    44,    61,    59,     0,    66,    69,     8,     0,
      80,    81,     0,    79,     0,     0,     0,    33,    34,    35,
      36,    37,     0,    58,    19,     0,     0,     0,     0,     0,
       0,     5,    59,     0,     0,     0,     0,     0,    11,    13,
      15,     0,     0,     0,     0,    54,     0,     0,     0,     0,
       0,     9,    62,    67,    79,     0,     0,     0,     0,    30,
       0,     0,    60,     0,     0,     0,    10,     0,    84,     0,
       0,     0,     0,     0,    71,     0,     0,     0,    82,     0,
      64,     0,     0,     0,    56,    75,    72,    73,    74,     0,
       0,     6,     0,     0,    28,    76,    77,    78,     0,     0,
      65,     0,     0,    83,     0,    29,     0,     0,     0,     0,
       0,     0,    27,     0,     0,     0,     0,     0,     0,    18
};

/* YYDEFGOTO[NTERM-NUM].  */
static const yytype_int16 yydefgoto[] =
{
      -1,    10,    11,    12,   136,   161,    57,   211,   137,   138,
      66,   162,   102,   168
};

/* YYPACT[STATE-NUM] -- Index in YYTABLE of the portion describing
   STATE-NUM.  */
#define YYPACT_NINF -188
static const yytype_int16 yypact[] =
{
     163,     5,     1,    23,     2,    42,    -7,    64,     8,    22,
     184,     3,  -188,    61,   101,    75,   119,    73,  -188,  -188,
     130,    55,  -188,    56,  -188,   137,   144,   122,   145,    74,
     147,   115,    77,  -188,   158,  -188,   117,   126,   -44,  -188,
    -188,  -188,  -188,  -188,  -188,   149,   149,   149,  -188,    85,
      97,    98,    99,   102,   120,   149,   515,   -34,   152,   149,
      28,   122,   182,   132,   103,   149,  -188,  -188,  -188,   189,
     188,    63,   610,   610,   149,   149,   149,   149,   149,   149,
     283,   149,   149,   149,   149,   149,     0,   203,   149,   149,
     149,   149,   149,   149,   149,   192,   193,   149,   149,   564,
     114,   208,   157,   -28,   131,   213,   217,   564,  -188,   133,
     305,   327,   351,   373,   395,   469,  -188,   564,   584,    83,
      63,   600,  -188,   215,    67,   238,   216,   -18,   -18,  -188,
    -188,  -188,  -188,  -188,   -35,   541,   261,  -188,  -188,   224,
    -188,   -29,   226,   172,   148,   150,   146,  -188,  -188,  -188,
    -188,  -188,   149,  -188,    -8,   154,   230,   197,   199,   210,
     219,  -188,   233,   250,   149,   176,   218,   242,  -188,  -188,
    -188,   274,   237,   280,   441,  -188,   229,   149,   295,   296,
     299,  -188,  -188,  -188,   172,   264,   301,   220,   225,   -63,
     149,   149,  -188,   251,   265,   268,  -188,   317,  -188,   322,
     149,   323,   324,   419,   491,   149,   149,   149,   263,   246,
     564,   -48,   259,   262,  -188,  -188,   491,   491,   491,   304,
     314,  -188,   149,   346,   278,  -188,  -188,  -188,   347,   357,
     564,   277,   363,  -188,   284,  -188,   288,   369,   370,   309,
     292,   385,  -188,   307,   390,   383,   392,   312,   407,  -188
};

/* YYPGOTO[NTERM-NUM].  */
static const yytype_int16 yypgoto[] =
{
    -188,  -188,   389,   291,   -27,   254,   356,  -188,  -154,  -188,
    -188,  -187,  -141,  -188
};

/* YYTABLE[YYPACT[STATE-NUM]].  What to do in state STATE-NUM.  If
   positive, shift that token.  If negative, reduce the rule which
   number is the opposite.  If zero, do what YYDEFACT says.
   If YYTABLE_NINF, syntax error.  */
#define YYTABLE_NINF -1
static const yytype_int16 yytable[] =
{
      56,    96,   170,    13,    67,    68,   156,   142,   122,   157,
     183,   201,    91,    92,    93,    94,    13,   215,    71,    72,
      73,   202,   123,   192,   158,   159,   160,    15,    80,   225,
     226,   227,    99,   166,    56,   167,    14,   221,   107,   222,
      67,    68,    69,   196,    70,    16,    17,   110,   111,   112,
     113,   114,   115,    97,   117,   118,   119,   120,   121,    97,
     125,   126,   127,   128,   129,   130,   131,   132,    19,    18,
     135,   154,    39,    40,    41,    42,    43,    44,    69,   100,
      70,    85,    86,    45,   101,    20,    24,    87,    46,    47,
      88,    89,    90,    91,    92,    93,    94,    80,    84,    25,
      26,    85,    86,    21,     2,    29,    27,    87,    28,     3,
      88,    89,    90,    91,    92,    93,    94,    49,    30,    50,
      51,    52,    53,    31,    32,   174,    38,    39,    40,    41,
      42,    43,    44,     4,    33,     5,    54,    34,    45,    35,
      36,    59,     6,    46,    47,     7,     8,     9,    37,    58,
      60,    55,    48,    38,    39,    40,    41,    42,    43,    44,
      61,    62,    63,   203,   204,    45,    65,     1,    64,    74,
      46,    47,    49,   210,    50,    51,    52,    53,   216,   217,
     218,    75,    76,    77,    22,   104,    78,   106,     1,   105,
      79,    54,    98,   108,   109,   230,   133,   134,   139,    49,
       2,    50,    51,    52,    53,     3,    55,    38,    39,    40,
      41,    42,    43,    44,   140,   141,   143,   144,    54,    45,
     145,     2,   146,   153,    46,    47,     3,   165,   101,     4,
     169,     5,   171,    55,   176,   172,   173,   177,     6,   175,
     178,     7,     8,     9,    89,    90,    91,    92,    93,    94,
       4,   179,     5,    49,   182,    50,    51,    52,    53,     6,
     180,   184,     7,     8,     9,    88,    89,    90,    91,    92,
      93,    94,    54,    81,    82,    83,    84,   157,   187,    85,
      86,   185,   186,   188,   189,    87,   191,   124,    88,    89,
      90,    91,    92,    93,    94,    81,    82,    83,    84,   193,
     194,    85,    86,   195,   197,   198,   199,    87,   205,   200,
      88,    89,    90,    91,    92,    93,    94,    81,    82,    83,
      84,   208,   206,    85,    86,   207,   209,   212,   219,    87,
     213,   220,    88,    89,    90,    91,    92,    93,    94,    81,
      82,    83,    84,   223,   228,    85,    86,   224,   164,   229,
     231,    87,   232,   233,    88,    89,    90,    91,    92,    93,
      94,   234,   235,    81,    82,    83,    84,   236,   116,    85,
      86,   237,   238,   239,   240,    87,   241,   242,    88,    89,
      90,    91,    92,    93,    94,    81,    82,    83,    84,   243,
     147,    85,    86,   244,   245,   246,   247,    87,   248,    23,
      88,    89,    90,    91,    92,    93,    94,    81,    82,    83,
      84,   249,   148,    85,    86,   155,   181,   103,     0,    87,
       0,     0,    88,    89,    90,    91,    92,    93,    94,     0,
       0,    81,    82,    83,    84,     0,   149,    85,    86,     0,
       0,     0,     0,    87,     0,     0,    88,    89,    90,    91,
      92,    93,    94,    81,    82,    83,    84,     0,   150,    85,
      86,     0,     0,     0,     0,    87,     0,     0,    88,    89,
      90,    91,    92,    93,    94,     0,     0,     0,     0,     0,
     151,    81,    82,    83,    84,     0,     0,    85,    86,     0,
       0,     0,   214,    87,     0,     0,    88,    89,    90,    91,
      92,    93,    94,    81,    82,    83,    84,     0,     0,    85,
      86,     0,     0,   190,     0,    87,     0,     0,    88,    89,
      90,    91,    92,    93,    94,     0,     0,    81,    82,    83,
      84,     0,   156,    85,    86,     0,     0,     0,     0,    87,
     152,     0,    88,    89,    90,    91,    92,    93,    94,     0,
     158,   159,   160,    81,    82,    83,    84,     0,     0,    85,
      86,    95,     0,     0,     0,    87,     0,     0,    88,    89,
      90,    91,    92,    93,    94,     0,    81,    82,    83,    84,
       0,     0,    85,    86,     0,     0,     0,   163,    87,     0,
       0,    88,    89,    90,    91,    92,    93,    94,    83,    84,
       0,     0,    85,    86,     0,     0,     0,     0,    87,     0,
       0,    88,    89,    90,    91,    92,    93,    94,    -1,    -1,
       0,     0,     0,     0,    87,     0,     0,    88,    89,    90,
      91,    92,    93,    94,    87,     0,     0,    88,    89,    90,
      91,    92,    93,    94
};

static const yytype_int16 yycheck[] =
{
      27,    35,   143,    11,    48,    49,    41,    35,     8,    44,
     164,    74,    30,    31,    32,    33,    11,   204,    45,    46,
      47,    84,    22,   177,    59,    60,    61,     4,    55,   216,
     217,   218,    59,    62,    61,    64,    35,    85,    65,    87,
      48,    49,    86,   184,    88,    43,     4,    74,    75,    76,
      77,    78,    79,    87,    81,    82,    83,    84,    85,    87,
      87,    88,    89,    90,    91,    92,    93,    94,     4,    76,
      97,     4,     5,     6,     7,     8,     9,    10,    86,    51,
      88,    18,    19,    16,    56,    77,    83,    24,    21,    22,
      27,    28,    29,    30,    31,    32,    33,   124,    15,    38,
      39,    18,    19,    81,    37,     4,    45,    24,    47,    42,
      27,    28,    29,    30,    31,    32,    33,    50,    43,    52,
      53,    54,    55,     4,    51,   152,     4,     5,     6,     7,
       8,     9,    10,    66,     4,    68,    69,    82,    16,    83,
       3,    67,    75,    21,    22,    78,    79,    80,     4,     4,
       3,    84,    30,     4,     5,     6,     7,     8,     9,    10,
      45,    84,     4,   190,   191,    16,    40,     4,    51,    84,
      21,    22,    50,   200,    52,    53,    54,    55,   205,   206,
     207,    84,    84,    84,     0,     3,    84,    84,     4,    57,
      70,    69,    40,     4,     6,   222,     4,     4,    84,    50,
      37,    52,    53,    54,    55,    42,    84,     4,     5,     6,
       7,     8,     9,    10,     6,    58,    85,     4,    69,    16,
       3,    37,    89,     8,    21,    22,    42,     3,    56,    66,
       4,    68,    84,    84,     4,    85,    90,    40,    75,    85,
      41,    78,    79,    80,    28,    29,    30,    31,    32,    33,
      66,    41,    68,    50,     4,    52,    53,    54,    55,    75,
      41,    85,    78,    79,    80,    27,    28,    29,    30,    31,
      32,    33,    69,    12,    13,    14,    15,    44,     4,    18,
      19,    63,    40,    46,     4,    24,    57,    84,    27,    28,
      29,    30,    31,    32,    33,    12,    13,    14,    15,     4,
       4,    18,    19,     4,    40,     4,    86,    24,    57,    84,
      27,    28,    29,    30,    31,    32,    33,    12,    13,    14,
      15,     4,    57,    18,    19,    57,     4,     4,    65,    24,
       6,    85,    27,    28,    29,    30,    31,    32,    33,    12,
      13,    14,    15,    84,    40,    18,    19,    85,    87,    35,
       4,    24,    74,     6,    27,    28,    29,    30,    31,    32,
      33,     4,    85,    12,    13,    14,    15,     4,    85,    18,
      19,    87,    84,     4,     4,    24,    67,    85,    27,    28,
      29,    30,    31,    32,    33,    12,    13,    14,    15,     4,
      85,    18,    19,    86,     4,    12,     4,    24,    86,    10,
      27,    28,    29,    30,    31,    32,    33,    12,    13,    14,
      15,     4,    85,    18,    19,   124,   162,    61,    -1,    24,
      -1,    -1,    27,    28,    29,    30,    31,    32,    33,    -1,
      -1,    12,    13,    14,    15,    -1,    85,    18,    19,    -1,
      -1,    -1,    -1,    24,    -1,    -1,    27,    28,    29,    30,
      31,    32,    33,    12,    13,    14,    15,    -1,    85,    18,
      19,    -1,    -1,    -1,    -1,    24,    -1,    -1,    27,    28,
      29,    30,    31,    32,    33,    -1,    -1,    -1,    -1,    -1,
      85,    12,    13,    14,    15,    -1,    -1,    18,    19,    -1,
      -1,    -1,    73,    24,    -1,    -1,    27,    28,    29,    30,
      31,    32,    33,    12,    13,    14,    15,    -1,    -1,    18,
      19,    -1,    -1,    72,    -1,    24,    -1,    -1,    27,    28,
      29,    30,    31,    32,    33,    -1,    -1,    12,    13,    14,
      15,    -1,    41,    18,    19,    -1,    -1,    -1,    -1,    24,
      71,    -1,    27,    28,    29,    30,    31,    32,    33,    -1,
      59,    60,    61,    12,    13,    14,    15,    -1,    -1,    18,
      19,    46,    -1,    -1,    -1,    24,    -1,    -1,    27,    28,
      29,    30,    31,    32,    33,    -1,    12,    13,    14,    15,
      -1,    -1,    18,    19,    -1,    -1,    -1,    46,    24,    -1,
      -1,    27,    28,    29,    30,    31,    32,    33,    14,    15,
      -1,    -1,    18,    19,    -1,    -1,    -1,    -1,    24,    -1,
      -1,    27,    28,    29,    30,    31,    32,    33,    18,    19,
      -1,    -1,    -1,    -1,    24,    -1,    -1,    27,    28,    29,
      30,    31,    32,    33,    24,    -1,    -1,    27,    28,    29,
      30,    31,    32,    33
};

/* YYSTOS[STATE-NUM] -- The (internal number of the) accessing
   symbol of state STATE-NUM.  */
static const yytype_uint8 yystos[] =
{
       0,     4,    37,    42,    66,    68,    75,    78,    79,    80,
      92,    93,    94,    11,    35,     4,    43,     4,    76,     4,
      77,    81,     0,    93,    83,    38,    39,    45,    47,     4,
      43,     4,    51,     4,    82,    83,     3,     4,     4,     5,
       6,     7,     8,     9,    10,    16,    21,    22,    30,    50,
      52,    53,    54,    55,    69,    84,    95,    97,     4,    67,
       3,    45,    84,     4,    51,    40,   101,    48,    49,    86,
      88,    95,    95,    95,    84,    84,    84,    84,    84,    70,
      95,    12,    13,    14,    15,    18,    19,    24,    27,    28,
      29,    30,    31,    32,    33,    46,    35,    87,    40,    95,
      51,    56,   103,    97,     3,    57,    84,    95,     4,     6,
      95,    95,    95,    95,    95,    95,    85,    95,    95,    95,
      95,    95,     8,    22,    84,    95,    95,    95,    95,    95,
      95,    95,    95,     4,     4,    95,    95,    99,   100,    84,
       6,    58,    35,    85,     4,     3,    89,    85,    85,    85,
      85,    85,    71,     8,     4,    94,    41,    44,    59,    60,
      61,    96,   102,    46,    87,     3,    62,    64,   104,     4,
     103,    84,    85,    90,    95,    85,     4,    40,    41,    41,
      41,    96,     4,    99,    85,    63,    40,     4,    46,     4,
      72,    57,    99,     4,     4,     4,   103,    40,     4,    86,
      84,    74,    84,    95,    95,    57,    57,    57,     4,     4,
      95,    98,     4,     6,    73,   102,    95,    95,    95,    65,
      85,    85,    87,    84,    85,   102,   102,   102,    40,    35,
      95,     4,    74,     6,     4,    85,     4,    87,    84,     4,
       4,    67,    85,     4,    86,     4,    12,     4,    86,     4
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
    {  emit_create_bitmap_index((yyvsp[(4) - (23)].strval), (yyvsp[(6) - (23)].strval), (yyvsp[(8) - (23)].strval), (yyvsp[(10) - (23)].strval), (yyvsp[(19) - (23)].strval), (yyvsp[(23) - (23)].strval));;}
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
    { emit_float((yyvsp[(1) - (1)].floatval)); ;}
    break;

  case 25:

/* Line 1455 of yacc.c  */
#line 165 "bison.y"
    { emit_decimal((yyvsp[(1) - (1)].intval)); ;}
    break;

  case 26:

/* Line 1455 of yacc.c  */
#line 166 "bison.y"
    { emit("BOOL %d", (yyvsp[(1) - (1)].intval)); ;}
    break;

  case 27:

/* Line 1455 of yacc.c  */
#line 167 "bison.y"
    { emit_varchar((yyvsp[(1) - (14)].strval), (yyvsp[(3) - (14)].intval), (yyvsp[(6) - (14)].strval), (yyvsp[(8) - (14)].intval), (yyvsp[(11) - (14)].strval), (yyvsp[(13) - (14)].strval));;}
    break;

  case 28:

/* Line 1455 of yacc.c  */
#line 168 "bison.y"
    { emit_varchar((yyvsp[(1) - (9)].strval), (yyvsp[(3) - (9)].intval), (yyvsp[(6) - (9)].strval), (yyvsp[(8) - (9)].intval), "", "");;}
    break;

  case 29:

/* Line 1455 of yacc.c  */
#line 169 "bison.y"
    { emit_var((yyvsp[(1) - (11)].strval), (yyvsp[(3) - (11)].intval), (yyvsp[(6) - (11)].strval), (yyvsp[(8) - (11)].strval), (yyvsp[(10) - (11)].strval));;}
    break;

  case 30:

/* Line 1455 of yacc.c  */
#line 170 "bison.y"
    { emit_var((yyvsp[(1) - (6)].strval), (yyvsp[(3) - (6)].intval), (yyvsp[(6) - (6)].strval), "", "");;}
    break;

  case 31:

/* Line 1455 of yacc.c  */
#line 171 "bison.y"
    { emit_var_asc((yyvsp[(1) - (2)].strval));;}
    break;

  case 32:

/* Line 1455 of yacc.c  */
#line 172 "bison.y"
    { emit_var_desc((yyvsp[(1) - (2)].strval));;}
    break;

  case 33:

/* Line 1455 of yacc.c  */
#line 173 "bison.y"
    { emit_count(); ;}
    break;

  case 34:

/* Line 1455 of yacc.c  */
#line 174 "bison.y"
    { emit_sum(); ;}
    break;

  case 35:

/* Line 1455 of yacc.c  */
#line 175 "bison.y"
    { emit_average(); ;}
    break;

  case 36:

/* Line 1455 of yacc.c  */
#line 176 "bison.y"
    { emit_min(); ;}
    break;

  case 37:

/* Line 1455 of yacc.c  */
#line 177 "bison.y"
    { emit_max(); ;}
    break;

  case 38:

/* Line 1455 of yacc.c  */
#line 178 "bison.y"
    { emit_distinct(); ;}
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
#line 2262 "bison.cu"
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

    process_count = 6200000;
    verbose = 0;
	ssd = 0;
	delta = 0;
    total_buffer_size = 0;
	hash_seed = 100;

    for (int i = 1; i < ac; i++) {
        if(strcmp(av[i],"-l") == 0) {
            process_count = atoff(av[i+1]);
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
            delete [] buffers[buffer_names.front()];
            buffer_sizes.erase(buffer_names.front());
            buffers.erase(buffer_names.front());
            buffer_names.pop();
        };
		for(auto it = index_buffers.begin(); it != index_buffers.end();it++) {
			cudaFreeHost(it->second);
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



