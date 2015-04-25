/* A Bison parser, made by GNU Bison 3.0.4.  */

/* Bison implementation for Yacc-like parsers in C

   Copyright (C) 1984, 1989-1990, 2000-2015 Free Software Foundation, Inc.

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
#define YYBISON_VERSION "3.0.4"

/* Skeleton name.  */
#define YYSKELETON_NAME "yacc.c"

/* Pure parsers.  */
#define YYPURE 0

/* Push parsers.  */
#define YYPUSH 0

/* Pull parsers.  */
#define YYPULL 1




/* Copy the first part of user declarations.  */
#line 15 "bison.y" /* yacc.c:339  */



#include "lex.yy.c"
#include "cm.h"
#include "operators.h"



#line 76 "bison.tab.c" /* yacc.c:339  */

# ifndef YY_NULLPTR
#  if defined __cplusplus && 201103L <= __cplusplus
#   define YY_NULLPTR nullptr
#  else
#   define YY_NULLPTR 0
#  endif
# endif

/* Enabling verbose error messages.  */
#ifdef YYERROR_VERBOSE
# undef YYERROR_VERBOSE
# define YYERROR_VERBOSE 1
#else
# define YYERROR_VERBOSE 0
#endif

/* In a future release of Bison, this section will be replaced
   by #include "bison.tab.h".  */
#ifndef YY_YY_BISON_TAB_H_INCLUDED
# define YY_YY_BISON_TAB_H_INCLUDED
/* Debug traces.  */
#ifndef YYDEBUG
# define YYDEBUG 0
#endif
#if YYDEBUG
extern int yydebug;
#endif

/* Token type.  */
#ifndef YYTOKENTYPE
# define YYTOKENTYPE
  enum yytokentype
  {
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
    IN = 272,
    IS = 273,
    LIKE = 274,
    REGEXP = 275,
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
    INDEX = 327
  };
#endif

/* Value type.  */
#if ! defined YYSTYPE && ! defined YYSTYPE_IS_DECLARED

union YYSTYPE
{
#line 25 "bison.y" /* yacc.c:355  */

    long long int intval;
    double floatval;
    char *strval;
    int subtok;

#line 196 "bison.tab.c" /* yacc.c:355  */
};

typedef union YYSTYPE YYSTYPE;
# define YYSTYPE_IS_TRIVIAL 1
# define YYSTYPE_IS_DECLARED 1
#endif


extern YYSTYPE yylval;

int yyparse (void);

#endif /* !YY_YY_BISON_TAB_H_INCLUDED  */

/* Copy the second part of user declarations.  */

#line 213 "bison.tab.c" /* yacc.c:358  */

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
#else
typedef signed char yytype_int8;
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
# elif ! defined YYSIZE_T
#  include <stddef.h> /* INFRINGES ON USER NAME SPACE */
#  define YYSIZE_T size_t
# else
#  define YYSIZE_T unsigned int
# endif
#endif

#define YYSIZE_MAXIMUM ((YYSIZE_T) -1)

#ifndef YY_
# if defined YYENABLE_NLS && YYENABLE_NLS
#  if ENABLE_NLS
#   include <libintl.h> /* INFRINGES ON USER NAME SPACE */
#   define YY_(Msgid) dgettext ("bison-runtime", Msgid)
#  endif
# endif
# ifndef YY_
#  define YY_(Msgid) Msgid
# endif
#endif

#ifndef YY_ATTRIBUTE
# if (defined __GNUC__                                               \
      && (2 < __GNUC__ || (__GNUC__ == 2 && 96 <= __GNUC_MINOR__)))  \
     || defined __SUNPRO_C && 0x5110 <= __SUNPRO_C
#  define YY_ATTRIBUTE(Spec) __attribute__(Spec)
# else
#  define YY_ATTRIBUTE(Spec) /* empty */
# endif
#endif

#ifndef YY_ATTRIBUTE_PURE
# define YY_ATTRIBUTE_PURE   YY_ATTRIBUTE ((__pure__))
#endif

#ifndef YY_ATTRIBUTE_UNUSED
# define YY_ATTRIBUTE_UNUSED YY_ATTRIBUTE ((__unused__))
#endif

#if !defined _Noreturn \
     && (!defined __STDC_VERSION__ || __STDC_VERSION__ < 201112)
# if defined _MSC_VER && 1200 <= _MSC_VER
#  define _Noreturn __declspec (noreturn)
# else
#  define _Noreturn YY_ATTRIBUTE ((__noreturn__))
# endif
#endif

/* Suppress unused-variable warnings by "using" E.  */
#if ! defined lint || defined __GNUC__
# define YYUSE(E) ((void) (E))
#else
# define YYUSE(E) /* empty */
#endif

#if defined __GNUC__ && 407 <= __GNUC__ * 100 + __GNUC_MINOR__
/* Suppress an incorrect diagnostic about yylval being uninitialized.  */
# define YY_IGNORE_MAYBE_UNINITIALIZED_BEGIN \
    _Pragma ("GCC diagnostic push") \
    _Pragma ("GCC diagnostic ignored \"-Wuninitialized\"")\
    _Pragma ("GCC diagnostic ignored \"-Wmaybe-uninitialized\"")
# define YY_IGNORE_MAYBE_UNINITIALIZED_END \
    _Pragma ("GCC diagnostic pop")
#else
# define YY_INITIAL_VALUE(Value) Value
#endif
#ifndef YY_IGNORE_MAYBE_UNINITIALIZED_BEGIN
# define YY_IGNORE_MAYBE_UNINITIALIZED_BEGIN
# define YY_IGNORE_MAYBE_UNINITIALIZED_END
#endif
#ifndef YY_INITIAL_VALUE
# define YY_INITIAL_VALUE(Value) /* Nothing. */
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
#    if ! defined _ALLOCA_H && ! defined EXIT_SUCCESS
#     include <stdlib.h> /* INFRINGES ON USER NAME SPACE */
      /* Use EXIT_SUCCESS as a witness for stdlib.h.  */
#     ifndef EXIT_SUCCESS
#      define EXIT_SUCCESS 0
#     endif
#    endif
#   endif
#  endif
# endif

# ifdef YYSTACK_ALLOC
   /* Pacify GCC's 'empty if-body' warning.  */
#  define YYSTACK_FREE(Ptr) do { /* empty */; } while (0)
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
#  if (defined __cplusplus && ! defined EXIT_SUCCESS \
       && ! ((defined YYMALLOC || defined malloc) \
             && (defined YYFREE || defined free)))
#   include <stdlib.h> /* INFRINGES ON USER NAME SPACE */
#   ifndef EXIT_SUCCESS
#    define EXIT_SUCCESS 0
#   endif
#  endif
#  ifndef YYMALLOC
#   define YYMALLOC malloc
#   if ! defined malloc && ! defined EXIT_SUCCESS
void *malloc (YYSIZE_T); /* INFRINGES ON USER NAME SPACE */
#   endif
#  endif
#  ifndef YYFREE
#   define YYFREE free
#   if ! defined free && ! defined EXIT_SUCCESS
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

# define YYCOPY_NEEDED 1

/* Relocate STACK from its old location to the new one.  The
   local variables YYSIZE and YYSTACKSIZE give the old and new number of
   elements in the stack, and YYPTR gives the new location of the
   stack.  Advance YYPTR to a properly aligned location for the next
   stack.  */
# define YYSTACK_RELOCATE(Stack_alloc, Stack)                           \
    do                                                                  \
      {                                                                 \
        YYSIZE_T yynewbytes;                                            \
        YYCOPY (&yyptr->Stack_alloc, Stack, yysize);                    \
        Stack = &yyptr->Stack_alloc;                                    \
        yynewbytes = yystacksize * sizeof (*Stack) + YYSTACK_GAP_MAXIMUM; \
        yyptr += yynewbytes / sizeof (*yyptr);                          \
      }                                                                 \
    while (0)

#endif

#if defined YYCOPY_NEEDED && YYCOPY_NEEDED
/* Copy COUNT objects from SRC to DST.  The source and destination do
   not overlap.  */
# ifndef YYCOPY
#  if defined __GNUC__ && 1 < __GNUC__
#   define YYCOPY(Dst, Src, Count) \
      __builtin_memcpy (Dst, Src, (Count) * sizeof (*(Src)))
#  else
#   define YYCOPY(Dst, Src, Count)              \
      do                                        \
        {                                       \
          YYSIZE_T yyi;                         \
          for (yyi = 0; yyi < (Count); yyi++)   \
            (Dst)[yyi] = (Src)[yyi];            \
        }                                       \
      while (0)
#  endif
# endif
#endif /* !YYCOPY_NEEDED */

/* YYFINAL -- State number of the termination state.  */
#define YYFINAL  22
/* YYLAST -- Last index in YYTABLE.  */
#define YYLAST   679

/* YYNTOKENS -- Number of terminals.  */
#define YYNTOKENS  90
/* YYNNTS -- Number of nonterminals.  */
#define YYNNTS  14
/* YYNRULES -- Number of rules.  */
#define YYNRULES  84
/* YYNSTATES -- Number of states.  */
#define YYNSTATES  249

/* YYTRANSLATE[YYX] -- Symbol number corresponding to YYX as returned
   by yylex, with out-of-bounds checking.  */
#define YYUNDEFTOK  2
#define YYMAXUTOK   327

#define YYTRANSLATE(YYX)                                                \
  ((unsigned int) (YYX) <= YYMAXUTOK ? yytranslate[YYX] : YYUNDEFTOK)

/* YYTRANSLATE[TOKEN-NUM] -- Symbol number corresponding to TOKEN-NUM
   as returned by yylex, without out-of-bounds checking.  */
static const yytype_uint8 yytranslate[] =
{
       0,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,    22,     2,     2,     2,    32,    26,     2,
      83,    84,    30,    28,    86,    29,    85,    31,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,    89,    82,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,    34,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,    87,    25,    88,     2,     2,     2,     2,
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
      15,    16,    17,    18,    19,    20,    21,    23,    24,    27,
      33,    35,    36,    37,    38,    39,    40,    41,    42,    43,
      44,    45,    46,    47,    48,    49,    50,    51,    52,    53,
      54,    55,    56,    57,    58,    59,    60,    61,    62,    63,
      64,    65,    66,    67,    68,    69,    70,    71,    72,    73,
      74,    75,    76,    77,    78,    79,    80,    81
};

#if YYDEBUG
  /* YYRLINE[YYN] -- Source line where rule number YYN was defined.  */
static const yytype_uint16 yyrline[] =
{
       0,   119,   119,   120,   124,   127,   129,   131,   133,   135,
     137,   139,   141,   143,   145,   147,   149,   151,   153,   158,
     159,   160,   161,   162,   163,   164,   165,   166,   167,   168,
     169,   170,   171,   172,   173,   174,   175,   176,   177,   181,
     182,   183,   184,   185,   186,   188,   189,   190,   191,   192,
     193,   194,   195,   196,   198,   199,   200,   204,   205,   208,
     211,   215,   216,   217,   221,   222,   226,   227,   230,   232,
     235,   239,   240,   241,   242,   243,   244,   245,   246,   248,
     251,   253,   256,   257,   258
};
#endif

#if YYDEBUG || YYERROR_VERBOSE || 0
/* YYTNAME[SYMBOL-NUM] -- String name of the symbol SYMBOL-NUM.
   First, the terminals, then, starting at YYNTOKENS, nonterminals.  */
static const char *const yytname[] =
{
  "$end", "error", "$undefined", "FILENAME", "NAME", "STRING", "INTNUM",
  "DECIMAL1", "BOOL1", "APPROXNUM", "USERVAR", "ASSIGN", "EQUAL", "OR",
  "XOR", "AND", "DISTINCT", "IN", "IS", "LIKE", "REGEXP", "NOT", "'!'",
  "BETWEEN", "COMPARISON", "'|'", "'&'", "SHIFT", "'+'", "'-'", "'*'",
  "'/'", "'%'", "MOD", "'^'", "FROM", "MULITE", "DELETE", "LOAD", "FILTER",
  "BY", "JOIN", "STORE", "INTO", "GROUP", "SELECT", "AS", "ORDER", "ASC",
  "DESC", "COUNT", "USING", "SUM", "AVG", "MIN", "MAX", "LIMIT", "ON",
  "BINARY", "LEFT", "RIGHT", "OUTER", "SORT", "SEGMENTS", "PRESORTED",
  "PARTITION", "INSERT", "WHERE", "DISPLAY", "CASE", "WHEN", "THEN",
  "ELSE", "END", "REFERENCES", "SHOW", "TABLES", "TABLE", "DESCRIBE",
  "DROP", "CREATE", "INDEX", "';'", "'('", "')'", "'.'", "','", "'{'",
  "'}'", "':'", "$accept", "stmt_list", "stmt", "select_stmt", "expr",
  "opt_group_list", "expr_list", "load_list", "val_list", "opt_val_list",
  "opt_where", "join_list", "opt_limit", "sort_def", YY_NULLPTR
};
#endif

# ifdef YYPRINT
/* YYTOKNUM[NUM] -- (External) token number corresponding to the
   (internal) symbol number NUM (which must be that of a token).  */
static const yytype_uint16 yytoknum[] =
{
       0,   256,   257,   258,   259,   260,   261,   262,   263,   264,
     265,   266,   267,   268,   269,   270,   271,   272,   273,   274,
     275,   276,    33,   277,   278,   124,    38,   279,    43,    45,
      42,    47,    37,   280,    94,   281,   282,   283,   284,   285,
     286,   287,   288,   289,   290,   291,   292,   293,   294,   295,
     296,   297,   298,   299,   300,   301,   302,   303,   304,   305,
     306,   307,   308,   309,   310,   311,   312,   313,   314,   315,
     316,   317,   318,   319,   320,   321,   322,   323,   324,   325,
     326,   327,    59,    40,    41,    46,    44,   123,   125,    58
};
# endif

#define YYPACT_NINF -155

#define yypact_value_is_default(Yystate) \
  (!!((Yystate) == (-155)))

#define YYTABLE_NINF -1

#define yytable_value_is_error(Yytable_value) \
  (!!((Yytable_value) == (-1)))

  /* YYPACT[STATE-NUM] -- Index in YYTABLE of the portion describing
     STATE-NUM.  */
static const yytype_int16 yypact[] =
{
      42,     4,    -2,    32,     1,    54,     9,    76,    17,    14,
       3,    18,  -155,    -8,    92,    56,    97,    51,  -155,  -155,
     108,   109,  -155,    33,  -155,   111,   112,   137,   114,    66,
     120,    93,    57,  -155,    95,  -155,    88,   115,   -44,  -155,
    -155,  -155,  -155,  -155,  -155,   192,   192,   192,  -155,    71,
      73,    83,    85,    86,    79,   192,   519,   -33,   130,   192,
     -40,   137,   168,   170,    89,   192,  -155,  -155,  -155,   171,
     175,   623,   224,   224,   192,   192,   192,   192,   192,   192,
     289,   192,   192,   192,   192,     0,   192,   217,   192,   192,
     192,   192,   192,   192,   192,   172,   173,   192,   192,   568,
      99,   177,   126,   -18,   101,   103,   185,   568,  -155,   105,
     311,   333,   356,   378,   400,   473,  -155,   568,   588,   607,
     623,  -155,   186,   639,    82,   646,    98,    44,    44,  -155,
    -155,  -155,  -155,  -155,   -35,   545,   264,  -155,  -155,   200,
    -155,   -50,   201,   148,   203,   125,   121,  -155,  -155,  -155,
    -155,  -155,   192,  -155,    24,   127,   208,   176,   174,   178,
     187,  -155,   188,   213,   192,   134,   166,   190,  -155,  -155,
    -155,   146,   189,   230,   445,  -155,   179,   192,   233,   236,
     237,  -155,  -155,  -155,   148,   209,   239,   246,   180,   -61,
     192,   192,  -155,   202,   205,   207,  -155,   254,  -155,   181,
     192,   256,   260,   423,   495,   192,   192,   192,   215,   238,
     568,   -57,   191,   184,  -155,  -155,   495,   495,   495,   241,
     280,  -155,   192,   281,   216,  -155,  -155,  -155,   283,   212,
     568,   221,   295,  -155,   302,  -155,   204,   242,   306,   307,
     228,   229,  -155,   323,   303,   324,   247,   327,  -155
};

  /* YYDEFACT[STATE-NUM] -- Default reduction number in state STATE-NUM.
     Performed when YYTABLE does not specify something else to do.  Zero
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
       0,    38,    50,    51,     0,     0,     0,     0,     0,     0,
       0,     0,     0,     0,     0,     0,     0,     0,     0,     0,
       0,     0,     0,     0,     0,     0,     0,     0,    68,    14,
       0,     0,     0,     0,     0,     0,     0,    70,    20,     0,
       0,     0,     0,     0,     0,     0,    55,    46,    47,    48,
      45,    57,     0,    53,     0,    52,    49,    39,    40,    41,
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
       0,     0,    27,     0,     0,     0,     0,     0,    18
};

  /* YYPGOTO[NTERM-NUM].  */
static const yytype_int16 yypgoto[] =
{
    -155,  -155,   326,   210,   -27,   193,   272,  -155,  -154,  -155,
    -155,  -111,  -142,  -155
};

  /* YYDEFGOTO[NTERM-NUM].  */
static const yytype_int16 yydefgoto[] =
{
      -1,    10,    11,    12,   136,   161,    57,   211,   137,   138,
      66,   162,   102,   168
};

  /* YYTABLE[YYPACT[STATE-NUM]] -- What to do in state STATE-NUM.  If
     positive, shift that token.  If negative, reduce the rule whose
     number is the opposite.  If YYTABLE_NINF, syntax error.  */
static const yytype_int16 yytable[] =
{
      56,   170,    96,    22,    67,    68,   156,     1,   121,   157,
     183,   100,   166,   201,   167,    13,   101,   142,    71,    72,
      73,   122,   202,   192,   158,   159,   160,   221,    80,   222,
      25,    26,    99,    14,    56,    13,    15,    27,   107,    28,
       2,    69,   196,    70,    16,     3,     1,   110,   111,   112,
     113,   114,   115,    97,   117,   118,   119,   120,    17,   123,
     125,   126,   127,   128,   129,   130,   131,   132,    97,     4,
     135,     5,    67,    68,    91,    92,    93,    94,     6,     2,
      19,     7,     8,     9,     3,    18,   154,    39,    40,    41,
      42,    43,    44,   215,    20,    21,    29,    80,    45,    30,
      24,    31,    32,    46,    47,   225,   226,   227,     4,    69,
       5,    70,    33,    34,    36,    35,    37,     6,    58,     2,
       7,     8,     9,    60,     3,   174,    89,    90,    91,    92,
      93,    94,    49,    59,    50,    51,    52,    53,    61,    64,
      62,    38,    39,    40,    41,    42,    43,    44,     4,    79,
       5,    54,    63,    45,    74,    65,    75,     6,    46,    47,
       7,     8,     9,   203,   204,    55,    76,    48,    77,    78,
      98,   104,   106,   210,   105,   108,   133,   134,   216,   217,
     218,   109,   139,   140,   141,   143,   144,    49,   145,    50,
      51,    52,    53,   146,   153,   230,    38,    39,    40,    41,
      42,    43,    44,   165,   101,   169,    54,   171,    45,   172,
     173,   175,   176,    46,    47,   178,   177,   182,   184,   179,
      55,    38,    39,    40,    41,    42,    43,    44,   180,   185,
     186,   187,   157,    45,   189,   188,   191,   193,    46,    47,
     194,   195,    49,   198,    50,    51,    52,    53,    87,   197,
     199,    88,    89,    90,    91,    92,    93,    94,   208,   205,
     212,    54,   206,   200,   207,   209,   213,    49,   224,    50,
      51,    52,    53,   220,   223,    55,    81,    82,    83,    84,
     219,   228,    85,    86,   229,   231,    54,   238,    87,   233,
     232,    88,    89,    90,    91,    92,    93,    94,   234,   236,
     124,    81,    82,    83,    84,   235,   237,    85,    86,   239,
     240,   241,   242,    87,   243,   245,    88,    89,    90,    91,
      92,    93,    94,    81,    82,    83,    84,   244,   246,    85,
      86,   248,   247,   103,   155,    87,    23,     0,    88,    89,
      90,    91,    92,    93,    94,    81,    82,    83,    84,     0,
     164,    85,    86,     0,     0,   181,     0,    87,     0,     0,
      88,    89,    90,    91,    92,    93,    94,     0,    81,    82,
      83,    84,     0,   116,    85,    86,     0,     0,     0,     0,
      87,     0,     0,    88,    89,    90,    91,    92,    93,    94,
      81,    82,    83,    84,     0,   147,    85,    86,     0,     0,
       0,     0,    87,     0,     0,    88,    89,    90,    91,    92,
      93,    94,    81,    82,    83,    84,     0,   148,    85,    86,
       0,     0,     0,     0,    87,     0,     0,    88,    89,    90,
      91,    92,    93,    94,     0,    81,    82,    83,    84,     0,
     149,    85,    86,     0,     0,     0,     0,    87,     0,     0,
      88,    89,    90,    91,    92,    93,    94,    81,    82,    83,
      84,     0,   150,    85,    86,     0,     0,     0,     0,    87,
       0,     0,    88,    89,    90,    91,    92,    93,    94,     0,
       0,     0,     0,     0,   151,    81,    82,    83,    84,     0,
       0,    85,    86,     0,     0,     0,   214,    87,     0,     0,
      88,    89,    90,    91,    92,    93,    94,    81,    82,    83,
      84,     0,     0,    85,    86,     0,     0,   190,     0,    87,
       0,     0,    88,    89,    90,    91,    92,    93,    94,     0,
       0,    81,    82,    83,    84,     0,   156,    85,    86,     0,
       0,     0,     0,    87,   152,     0,    88,    89,    90,    91,
      92,    93,    94,     0,   158,   159,   160,    81,    82,    83,
      84,     0,     0,    85,    86,    95,     0,     0,     0,    87,
       0,     0,    88,    89,    90,    91,    92,    93,    94,     0,
      81,    82,    83,    84,     0,     0,    85,    86,     0,     0,
       0,   163,    87,     0,     0,    88,    89,    90,    91,    92,
      93,    94,    83,    84,     0,     0,    85,    86,     0,     0,
       0,     0,    87,     0,     0,    88,    89,    90,    91,    92,
      93,    94,    84,     0,     0,    85,    86,     0,     0,     0,
       0,    87,     0,     0,    88,    89,    90,    91,    92,    93,
      94,    85,    86,     0,     0,     0,     0,    87,     0,     0,
      88,    89,    90,    91,    92,    93,    94,    -1,    -1,     0,
       0,     0,     0,    87,     0,     0,    88,    89,    90,    91,
      92,    93,    94,    88,    89,    90,    91,    92,    93,    94
};

static const yytype_int16 yycheck[] =
{
      27,   143,    35,     0,    48,    49,    41,     4,     8,    44,
     164,    51,    62,    74,    64,    11,    56,    35,    45,    46,
      47,    21,    83,   177,    59,    60,    61,    84,    55,    86,
      38,    39,    59,    35,    61,    11,     4,    45,    65,    47,
      37,    85,   184,    87,    43,    42,     4,    74,    75,    76,
      77,    78,    79,    86,    81,    82,    83,    84,     4,    86,
      87,    88,    89,    90,    91,    92,    93,    94,    86,    66,
      97,    68,    48,    49,    30,    31,    32,    33,    75,    37,
       4,    78,    79,    80,    42,    76,     4,     5,     6,     7,
       8,     9,    10,   204,    77,    81,     4,   124,    16,    43,
      82,     4,    51,    21,    22,   216,   217,   218,    66,    85,
      68,    87,     4,     4,     3,    82,     4,    75,     4,    37,
      78,    79,    80,     3,    42,   152,    28,    29,    30,    31,
      32,    33,    50,    67,    52,    53,    54,    55,    45,    51,
      83,     4,     5,     6,     7,     8,     9,    10,    66,    70,
      68,    69,    57,    16,    83,    40,    83,    75,    21,    22,
      78,    79,    80,   190,   191,    83,    83,    30,    83,    83,
      40,     3,    83,   200,     4,     4,     4,     4,   205,   206,
     207,     6,    83,     6,    58,    84,    83,    50,     3,    52,
      53,    54,    55,    88,     8,   222,     4,     5,     6,     7,
       8,     9,    10,     3,    56,     4,    69,     4,    16,    84,
      89,    84,     4,    21,    22,    41,    40,     4,    84,    41,
      83,     4,     5,     6,     7,     8,     9,    10,    41,    63,
      40,    85,    44,    16,     4,    46,    57,     4,    21,    22,
       4,     4,    50,     4,    52,    53,    54,    55,    24,    40,
       4,    27,    28,    29,    30,    31,    32,    33,     4,    57,
       4,    69,    57,    83,    57,    84,     6,    50,    84,    52,
      53,    54,    55,    35,    83,    83,    12,    13,    14,    15,
      65,    40,    18,    19,     4,     4,    69,    83,    24,     6,
      74,    27,    28,    29,    30,    31,    32,    33,    86,     4,
      83,    12,    13,    14,    15,    84,     4,    18,    19,    67,
       4,     4,    84,    24,    85,    12,    27,    28,    29,    30,
      31,    32,    33,    12,    13,    14,    15,     4,     4,    18,
      19,     4,    85,    61,   124,    24,    10,    -1,    27,    28,
      29,    30,    31,    32,    33,    12,    13,    14,    15,    -1,
      86,    18,    19,    -1,    -1,   162,    -1,    24,    -1,    -1,
      27,    28,    29,    30,    31,    32,    33,    -1,    12,    13,
      14,    15,    -1,    84,    18,    19,    -1,    -1,    -1,    -1,
      24,    -1,    -1,    27,    28,    29,    30,    31,    32,    33,
      12,    13,    14,    15,    -1,    84,    18,    19,    -1,    -1,
      -1,    -1,    24,    -1,    -1,    27,    28,    29,    30,    31,
      32,    33,    12,    13,    14,    15,    -1,    84,    18,    19,
      -1,    -1,    -1,    -1,    24,    -1,    -1,    27,    28,    29,
      30,    31,    32,    33,    -1,    12,    13,    14,    15,    -1,
      84,    18,    19,    -1,    -1,    -1,    -1,    24,    -1,    -1,
      27,    28,    29,    30,    31,    32,    33,    12,    13,    14,
      15,    -1,    84,    18,    19,    -1,    -1,    -1,    -1,    24,
      -1,    -1,    27,    28,    29,    30,    31,    32,    33,    -1,
      -1,    -1,    -1,    -1,    84,    12,    13,    14,    15,    -1,
      -1,    18,    19,    -1,    -1,    -1,    73,    24,    -1,    -1,
      27,    28,    29,    30,    31,    32,    33,    12,    13,    14,
      15,    -1,    -1,    18,    19,    -1,    -1,    72,    -1,    24,
      -1,    -1,    27,    28,    29,    30,    31,    32,    33,    -1,
      -1,    12,    13,    14,    15,    -1,    41,    18,    19,    -1,
      -1,    -1,    -1,    24,    71,    -1,    27,    28,    29,    30,
      31,    32,    33,    -1,    59,    60,    61,    12,    13,    14,
      15,    -1,    -1,    18,    19,    46,    -1,    -1,    -1,    24,
      -1,    -1,    27,    28,    29,    30,    31,    32,    33,    -1,
      12,    13,    14,    15,    -1,    -1,    18,    19,    -1,    -1,
      -1,    46,    24,    -1,    -1,    27,    28,    29,    30,    31,
      32,    33,    14,    15,    -1,    -1,    18,    19,    -1,    -1,
      -1,    -1,    24,    -1,    -1,    27,    28,    29,    30,    31,
      32,    33,    15,    -1,    -1,    18,    19,    -1,    -1,    -1,
      -1,    24,    -1,    -1,    27,    28,    29,    30,    31,    32,
      33,    18,    19,    -1,    -1,    -1,    -1,    24,    -1,    -1,
      27,    28,    29,    30,    31,    32,    33,    18,    19,    -1,
      -1,    -1,    -1,    24,    -1,    -1,    27,    28,    29,    30,
      31,    32,    33,    27,    28,    29,    30,    31,    32,    33
};

  /* YYSTOS[STATE-NUM] -- The (internal number of the) accessing
     symbol of state STATE-NUM.  */
static const yytype_uint8 yystos[] =
{
       0,     4,    37,    42,    66,    68,    75,    78,    79,    80,
      91,    92,    93,    11,    35,     4,    43,     4,    76,     4,
      77,    81,     0,    92,    82,    38,    39,    45,    47,     4,
      43,     4,    51,     4,     4,    82,     3,     4,     4,     5,
       6,     7,     8,     9,    10,    16,    21,    22,    30,    50,
      52,    53,    54,    55,    69,    83,    94,    96,     4,    67,
       3,    45,    83,    57,    51,    40,   100,    48,    49,    85,
      87,    94,    94,    94,    83,    83,    83,    83,    83,    70,
      94,    12,    13,    14,    15,    18,    19,    24,    27,    28,
      29,    30,    31,    32,    33,    46,    35,    86,    40,    94,
      51,    56,   102,    96,     3,     4,    83,    94,     4,     6,
      94,    94,    94,    94,    94,    94,    84,    94,    94,    94,
      94,     8,    21,    94,    83,    94,    94,    94,    94,    94,
      94,    94,    94,     4,     4,    94,    94,    98,    99,    83,
       6,    58,    35,    84,    83,     3,    88,    84,    84,    84,
      84,    84,    71,     8,     4,    93,    41,    44,    59,    60,
      61,    95,   101,    46,    86,     3,    62,    64,   103,     4,
     102,     4,    84,    89,    94,    84,     4,    40,    41,    41,
      41,    95,     4,    98,    84,    63,    40,    85,    46,     4,
      72,    57,    98,     4,     4,     4,   102,    40,     4,     4,
      83,    74,    83,    94,    94,    57,    57,    57,     4,    84,
      94,    97,     4,     6,    73,   101,    94,    94,    94,    65,
      35,    84,    86,    83,    84,   101,   101,   101,    40,     4,
      94,     4,    74,     6,    86,    84,     4,     4,    83,    67,
       4,     4,    84,    85,     4,    12,     4,    85,     4
};

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

  /* YYR2[YYN] -- Number of symbols on the right hand side of rule YYN.  */
static const yytype_uint8 yyr2[] =
{
       0,     2,     2,     3,     1,     7,    12,     5,     6,     8,
       9,     7,     2,     7,     5,     7,     2,     3,    22,     1,
       3,     1,     1,     1,     1,     1,     1,    14,     9,    11,
       6,     2,     2,     4,     4,     4,     4,     4,     2,     3,
       3,     3,     3,     3,     3,     3,     3,     3,     3,     3,
       2,     2,     3,     3,     5,     3,     8,     3,     4,     0,
       3,     3,     5,     1,     1,     3,     1,     3,     0,     1,
       2,     4,     5,     5,     5,     5,     6,     6,     6,     0,
       2,     0,     4,     7,     3
};


#define yyerrok         (yyerrstatus = 0)
#define yyclearin       (yychar = YYEMPTY)
#define YYEMPTY         (-2)
#define YYEOF           0

#define YYACCEPT        goto yyacceptlab
#define YYABORT         goto yyabortlab
#define YYERROR         goto yyerrorlab


#define YYRECOVERING()  (!!yyerrstatus)

#define YYBACKUP(Token, Value)                                  \
do                                                              \
  if (yychar == YYEMPTY)                                        \
    {                                                           \
      yychar = (Token);                                         \
      yylval = (Value);                                         \
      YYPOPSTACK (yylen);                                       \
      yystate = *yyssp;                                         \
      goto yybackup;                                            \
    }                                                           \
  else                                                          \
    {                                                           \
      yyerror (YY_("syntax error: cannot back up")); \
      YYERROR;                                                  \
    }                                                           \
while (0)

/* Error token number */
#define YYTERROR        1
#define YYERRCODE       256



/* Enable debugging if requested.  */
#if YYDEBUG

# ifndef YYFPRINTF
#  include <stdio.h> /* INFRINGES ON USER NAME SPACE */
#  define YYFPRINTF fprintf
# endif

# define YYDPRINTF(Args)                        \
do {                                            \
  if (yydebug)                                  \
    YYFPRINTF Args;                             \
} while (0)

/* This macro is provided for backward compatibility. */
#ifndef YY_LOCATION_PRINT
# define YY_LOCATION_PRINT(File, Loc) ((void) 0)
#endif


# define YY_SYMBOL_PRINT(Title, Type, Value, Location)                    \
do {                                                                      \
  if (yydebug)                                                            \
    {                                                                     \
      YYFPRINTF (stderr, "%s ", Title);                                   \
      yy_symbol_print (stderr,                                            \
                  Type, Value); \
      YYFPRINTF (stderr, "\n");                                           \
    }                                                                     \
} while (0)


/*----------------------------------------.
| Print this symbol's value on YYOUTPUT.  |
`----------------------------------------*/

static void
yy_symbol_value_print (FILE *yyoutput, int yytype, YYSTYPE const * const yyvaluep)
{
  FILE *yyo = yyoutput;
  YYUSE (yyo);
  if (!yyvaluep)
    return;
# ifdef YYPRINT
  if (yytype < YYNTOKENS)
    YYPRINT (yyoutput, yytoknum[yytype], *yyvaluep);
# endif
  YYUSE (yytype);
}


/*--------------------------------.
| Print this symbol on YYOUTPUT.  |
`--------------------------------*/

static void
yy_symbol_print (FILE *yyoutput, int yytype, YYSTYPE const * const yyvaluep)
{
  YYFPRINTF (yyoutput, "%s %s (",
             yytype < YYNTOKENS ? "token" : "nterm", yytname[yytype]);

  yy_symbol_value_print (yyoutput, yytype, yyvaluep);
  YYFPRINTF (yyoutput, ")");
}

/*------------------------------------------------------------------.
| yy_stack_print -- Print the state stack from its BOTTOM up to its |
| TOP (included).                                                   |
`------------------------------------------------------------------*/

static void
yy_stack_print (yytype_int16 *yybottom, yytype_int16 *yytop)
{
  YYFPRINTF (stderr, "Stack now");
  for (; yybottom <= yytop; yybottom++)
    {
      int yybot = *yybottom;
      YYFPRINTF (stderr, " %d", yybot);
    }
  YYFPRINTF (stderr, "\n");
}

# define YY_STACK_PRINT(Bottom, Top)                            \
do {                                                            \
  if (yydebug)                                                  \
    yy_stack_print ((Bottom), (Top));                           \
} while (0)


/*------------------------------------------------.
| Report that the YYRULE is going to be reduced.  |
`------------------------------------------------*/

static void
yy_reduce_print (yytype_int16 *yyssp, YYSTYPE *yyvsp, int yyrule)
{
  unsigned long int yylno = yyrline[yyrule];
  int yynrhs = yyr2[yyrule];
  int yyi;
  YYFPRINTF (stderr, "Reducing stack by rule %d (line %lu):\n",
             yyrule - 1, yylno);
  /* The symbols being reduced.  */
  for (yyi = 0; yyi < yynrhs; yyi++)
    {
      YYFPRINTF (stderr, "   $%d = ", yyi + 1);
      yy_symbol_print (stderr,
                       yystos[yyssp[yyi + 1 - yynrhs]],
                       &(yyvsp[(yyi + 1) - (yynrhs)])
                                              );
      YYFPRINTF (stderr, "\n");
    }
}

# define YY_REDUCE_PRINT(Rule)          \
do {                                    \
  if (yydebug)                          \
    yy_reduce_print (yyssp, yyvsp, Rule); \
} while (0)

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
#ifndef YYINITDEPTH
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
static YYSIZE_T
yystrlen (const char *yystr)
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
static char *
yystpcpy (char *yydest, const char *yysrc)
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

/* Copy into *YYMSG, which is of size *YYMSG_ALLOC, an error message
   about the unexpected token YYTOKEN for the state stack whose top is
   YYSSP.

   Return 0 if *YYMSG was successfully written.  Return 1 if *YYMSG is
   not large enough to hold the message.  In that case, also set
   *YYMSG_ALLOC to the required number of bytes.  Return 2 if the
   required number of bytes is too large to store.  */
static int
yysyntax_error (YYSIZE_T *yymsg_alloc, char **yymsg,
                yytype_int16 *yyssp, int yytoken)
{
  YYSIZE_T yysize0 = yytnamerr (YY_NULLPTR, yytname[yytoken]);
  YYSIZE_T yysize = yysize0;
  enum { YYERROR_VERBOSE_ARGS_MAXIMUM = 5 };
  /* Internationalized format string. */
  const char *yyformat = YY_NULLPTR;
  /* Arguments of yyformat. */
  char const *yyarg[YYERROR_VERBOSE_ARGS_MAXIMUM];
  /* Number of reported tokens (one for the "unexpected", one per
     "expected"). */
  int yycount = 0;

  /* There are many possibilities here to consider:
     - If this state is a consistent state with a default action, then
       the only way this function was invoked is if the default action
       is an error action.  In that case, don't check for expected
       tokens because there are none.
     - The only way there can be no lookahead present (in yychar) is if
       this state is a consistent state with a default action.  Thus,
       detecting the absence of a lookahead is sufficient to determine
       that there is no unexpected or expected token to report.  In that
       case, just report a simple "syntax error".
     - Don't assume there isn't a lookahead just because this state is a
       consistent state with a default action.  There might have been a
       previous inconsistent state, consistent state with a non-default
       action, or user semantic action that manipulated yychar.
     - Of course, the expected token list depends on states to have
       correct lookahead information, and it depends on the parser not
       to perform extra reductions after fetching a lookahead from the
       scanner and before detecting a syntax error.  Thus, state merging
       (from LALR or IELR) and default reductions corrupt the expected
       token list.  However, the list is correct for canonical LR with
       one exception: it will still contain any token that will not be
       accepted due to an error action in a later state.
  */
  if (yytoken != YYEMPTY)
    {
      int yyn = yypact[*yyssp];
      yyarg[yycount++] = yytname[yytoken];
      if (!yypact_value_is_default (yyn))
        {
          /* Start YYX at -YYN if negative to avoid negative indexes in
             YYCHECK.  In other words, skip the first -YYN actions for
             this state because they are default actions.  */
          int yyxbegin = yyn < 0 ? -yyn : 0;
          /* Stay within bounds of both yycheck and yytname.  */
          int yychecklim = YYLAST - yyn + 1;
          int yyxend = yychecklim < YYNTOKENS ? yychecklim : YYNTOKENS;
          int yyx;

          for (yyx = yyxbegin; yyx < yyxend; ++yyx)
            if (yycheck[yyx + yyn] == yyx && yyx != YYTERROR
                && !yytable_value_is_error (yytable[yyx + yyn]))
              {
                if (yycount == YYERROR_VERBOSE_ARGS_MAXIMUM)
                  {
                    yycount = 1;
                    yysize = yysize0;
                    break;
                  }
                yyarg[yycount++] = yytname[yyx];
                {
                  YYSIZE_T yysize1 = yysize + yytnamerr (YY_NULLPTR, yytname[yyx]);
                  if (! (yysize <= yysize1
                         && yysize1 <= YYSTACK_ALLOC_MAXIMUM))
                    return 2;
                  yysize = yysize1;
                }
              }
        }
    }

  switch (yycount)
    {
# define YYCASE_(N, S)                      \
      case N:                               \
        yyformat = S;                       \
      break
      YYCASE_(0, YY_("syntax error"));
      YYCASE_(1, YY_("syntax error, unexpected %s"));
      YYCASE_(2, YY_("syntax error, unexpected %s, expecting %s"));
      YYCASE_(3, YY_("syntax error, unexpected %s, expecting %s or %s"));
      YYCASE_(4, YY_("syntax error, unexpected %s, expecting %s or %s or %s"));
      YYCASE_(5, YY_("syntax error, unexpected %s, expecting %s or %s or %s or %s"));
# undef YYCASE_
    }

  {
    YYSIZE_T yysize1 = yysize + yystrlen (yyformat);
    if (! (yysize <= yysize1 && yysize1 <= YYSTACK_ALLOC_MAXIMUM))
      return 2;
    yysize = yysize1;
  }

  if (*yymsg_alloc < yysize)
    {
      *yymsg_alloc = 2 * yysize;
      if (! (yysize <= *yymsg_alloc
             && *yymsg_alloc <= YYSTACK_ALLOC_MAXIMUM))
        *yymsg_alloc = YYSTACK_ALLOC_MAXIMUM;
      return 1;
    }

  /* Avoid sprintf, as that infringes on the user's name space.
     Don't have undefined behavior even if the translation
     produced a string with the wrong number of "%s"s.  */
  {
    char *yyp = *yymsg;
    int yyi = 0;
    while ((*yyp = *yyformat) != '\0')
      if (*yyp == '%' && yyformat[1] == 's' && yyi < yycount)
        {
          yyp += yytnamerr (yyp, yyarg[yyi++]);
          yyformat += 2;
        }
      else
        {
          yyp++;
          yyformat++;
        }
  }
  return 0;
}
#endif /* YYERROR_VERBOSE */

/*-----------------------------------------------.
| Release the memory associated to this symbol.  |
`-----------------------------------------------*/

static void
yydestruct (const char *yymsg, int yytype, YYSTYPE *yyvaluep)
{
  YYUSE (yyvaluep);
  if (!yymsg)
    yymsg = "Deleting";
  YY_SYMBOL_PRINT (yymsg, yytype, yyvaluep, yylocationp);

  YY_IGNORE_MAYBE_UNINITIALIZED_BEGIN
  YYUSE (yytype);
  YY_IGNORE_MAYBE_UNINITIALIZED_END
}




/* The lookahead symbol.  */
int yychar;

/* The semantic value of the lookahead symbol.  */
YYSTYPE yylval;
/* Number of syntax errors so far.  */
int yynerrs;


/*----------.
| yyparse.  |
`----------*/

int
yyparse (void)
{
    int yystate;
    /* Number of tokens to shift before error messages enabled.  */
    int yyerrstatus;

    /* The stacks and their tools:
       'yyss': related to states.
       'yyvs': related to semantic values.

       Refer to the stacks through separate pointers, to allow yyoverflow
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
  int yytoken = 0;
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

  yyssp = yyss = yyssa;
  yyvsp = yyvs = yyvsa;
  yystacksize = YYINITDEPTH;

  YYDPRINTF ((stderr, "Starting parse\n"));

  yystate = 0;
  yyerrstatus = 0;
  yynerrs = 0;
  yychar = YYEMPTY; /* Cause a token to be read.  */
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
  if (yypact_value_is_default (yyn))
    goto yydefault;

  /* Not known => get a lookahead token if don't already have one.  */

  /* YYCHAR is either YYEMPTY or YYEOF or a valid lookahead symbol.  */
  if (yychar == YYEMPTY)
    {
      YYDPRINTF ((stderr, "Reading a token: "));
      yychar = yylex ();
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
      if (yytable_value_is_error (yyn))
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
  YY_IGNORE_MAYBE_UNINITIALIZED_BEGIN
  *++yyvsp = yylval;
  YY_IGNORE_MAYBE_UNINITIALIZED_END

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
     '$$ = $1'.

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
#line 124 "bison.y" /* yacc.c:1646  */
    { emit("STMT"); }
#line 1537 "bison.tab.c" /* yacc.c:1646  */
    break;

  case 5:
#line 128 "bison.y" /* yacc.c:1646  */
    { emit_select((yyvsp[-6].strval), (yyvsp[-1].strval), (yyvsp[0].intval)); }
#line 1543 "bison.tab.c" /* yacc.c:1646  */
    break;

  case 6:
#line 130 "bison.y" /* yacc.c:1646  */
    {  emit_load((yyvsp[-11].strval), (yyvsp[-8].strval), (yyvsp[-1].intval), (yyvsp[-5].strval)); }
#line 1549 "bison.tab.c" /* yacc.c:1646  */
    break;

  case 7:
#line 132 "bison.y" /* yacc.c:1646  */
    {  emit_filter((yyvsp[-4].strval), (yyvsp[-1].strval));}
#line 1555 "bison.tab.c" /* yacc.c:1646  */
    break;

  case 8:
#line 134 "bison.y" /* yacc.c:1646  */
    {  emit_order((yyvsp[-5].strval), (yyvsp[-2].strval), (yyvsp[0].intval));}
#line 1561 "bison.tab.c" /* yacc.c:1646  */
    break;

  case 9:
#line 136 "bison.y" /* yacc.c:1646  */
    {  emit_join((yyvsp[-7].strval),(yyvsp[-2].strval),(yyvsp[-1].intval),0,-1); }
#line 1567 "bison.tab.c" /* yacc.c:1646  */
    break;

  case 10:
#line 138 "bison.y" /* yacc.c:1646  */
    {  emit_store((yyvsp[-7].strval),(yyvsp[-5].strval),(yyvsp[-2].strval)); }
#line 1573 "bison.tab.c" /* yacc.c:1646  */
    break;

  case 11:
#line 140 "bison.y" /* yacc.c:1646  */
    {  emit_store_binary((yyvsp[-5].strval),(yyvsp[-3].strval)); }
#line 1579 "bison.tab.c" /* yacc.c:1646  */
    break;

  case 12:
#line 142 "bison.y" /* yacc.c:1646  */
    {  emit_describe_table((yyvsp[0].strval));}
#line 1585 "bison.tab.c" /* yacc.c:1646  */
    break;

  case 13:
#line 144 "bison.y" /* yacc.c:1646  */
    {  emit_insert((yyvsp[-4].strval), (yyvsp[0].strval));}
#line 1591 "bison.tab.c" /* yacc.c:1646  */
    break;

  case 14:
#line 146 "bison.y" /* yacc.c:1646  */
    {  emit_delete((yyvsp[-2].strval));}
#line 1597 "bison.tab.c" /* yacc.c:1646  */
    break;

  case 15:
#line 148 "bison.y" /* yacc.c:1646  */
    {  emit_display((yyvsp[-5].strval), (yyvsp[-2].strval));}
#line 1603 "bison.tab.c" /* yacc.c:1646  */
    break;

  case 16:
#line 150 "bison.y" /* yacc.c:1646  */
    {  emit_show_tables();}
#line 1609 "bison.tab.c" /* yacc.c:1646  */
    break;

  case 17:
#line 152 "bison.y" /* yacc.c:1646  */
    {  emit_drop_table((yyvsp[0].strval));}
#line 1615 "bison.tab.c" /* yacc.c:1646  */
    break;

  case 18:
#line 154 "bison.y" /* yacc.c:1646  */
    {  emit_create_bitmap_index((yyvsp[-19].strval), (yyvsp[-17].strval), (yyvsp[-15].strval), (yyvsp[-13].strval), (yyvsp[-4].strval), (yyvsp[0].strval));}
#line 1621 "bison.tab.c" /* yacc.c:1646  */
    break;

  case 19:
#line 158 "bison.y" /* yacc.c:1646  */
    { emit_name((yyvsp[0].strval)); }
#line 1627 "bison.tab.c" /* yacc.c:1646  */
    break;

  case 20:
#line 159 "bison.y" /* yacc.c:1646  */
    { emit_fieldname((yyvsp[-2].strval), (yyvsp[0].strval)); }
#line 1633 "bison.tab.c" /* yacc.c:1646  */
    break;

  case 21:
#line 160 "bison.y" /* yacc.c:1646  */
    { emit("USERVAR %s", (yyvsp[0].strval)); }
#line 1639 "bison.tab.c" /* yacc.c:1646  */
    break;

  case 22:
#line 161 "bison.y" /* yacc.c:1646  */
    { emit_string((yyvsp[0].strval)); }
#line 1645 "bison.tab.c" /* yacc.c:1646  */
    break;

  case 23:
#line 162 "bison.y" /* yacc.c:1646  */
    { emit_number((yyvsp[0].intval)); }
#line 1651 "bison.tab.c" /* yacc.c:1646  */
    break;

  case 24:
#line 163 "bison.y" /* yacc.c:1646  */
    { emit_float((yyvsp[0].floatval)); }
#line 1657 "bison.tab.c" /* yacc.c:1646  */
    break;

  case 25:
#line 164 "bison.y" /* yacc.c:1646  */
    { emit_decimal((yyvsp[0].intval)); }
#line 1663 "bison.tab.c" /* yacc.c:1646  */
    break;

  case 26:
#line 165 "bison.y" /* yacc.c:1646  */
    { emit("BOOL %d", (yyvsp[0].intval)); }
#line 1669 "bison.tab.c" /* yacc.c:1646  */
    break;

  case 27:
#line 166 "bison.y" /* yacc.c:1646  */
    { emit_varchar((yyvsp[-13].strval), (yyvsp[-11].intval), (yyvsp[-8].strval), (yyvsp[-6].intval), (yyvsp[-3].strval), (yyvsp[-1].strval));}
#line 1675 "bison.tab.c" /* yacc.c:1646  */
    break;

  case 28:
#line 167 "bison.y" /* yacc.c:1646  */
    { emit_varchar((yyvsp[-8].strval), (yyvsp[-6].intval), (yyvsp[-3].strval), (yyvsp[-1].intval), "", "");}
#line 1681 "bison.tab.c" /* yacc.c:1646  */
    break;

  case 29:
#line 168 "bison.y" /* yacc.c:1646  */
    { emit_var((yyvsp[-10].strval), (yyvsp[-8].intval), (yyvsp[-5].strval), (yyvsp[-3].strval), (yyvsp[-1].strval));}
#line 1687 "bison.tab.c" /* yacc.c:1646  */
    break;

  case 30:
#line 169 "bison.y" /* yacc.c:1646  */
    { emit_var((yyvsp[-5].strval), (yyvsp[-3].intval), (yyvsp[0].strval), "", "");}
#line 1693 "bison.tab.c" /* yacc.c:1646  */
    break;

  case 31:
#line 170 "bison.y" /* yacc.c:1646  */
    { emit_var_asc((yyvsp[-1].strval));}
#line 1699 "bison.tab.c" /* yacc.c:1646  */
    break;

  case 32:
#line 171 "bison.y" /* yacc.c:1646  */
    { emit_var_desc((yyvsp[-1].strval));}
#line 1705 "bison.tab.c" /* yacc.c:1646  */
    break;

  case 33:
#line 172 "bison.y" /* yacc.c:1646  */
    { emit_count(); }
#line 1711 "bison.tab.c" /* yacc.c:1646  */
    break;

  case 34:
#line 173 "bison.y" /* yacc.c:1646  */
    { emit_sum(); }
#line 1717 "bison.tab.c" /* yacc.c:1646  */
    break;

  case 35:
#line 174 "bison.y" /* yacc.c:1646  */
    { emit_average(); }
#line 1723 "bison.tab.c" /* yacc.c:1646  */
    break;

  case 36:
#line 175 "bison.y" /* yacc.c:1646  */
    { emit_min(); }
#line 1729 "bison.tab.c" /* yacc.c:1646  */
    break;

  case 37:
#line 176 "bison.y" /* yacc.c:1646  */
    { emit_max(); }
#line 1735 "bison.tab.c" /* yacc.c:1646  */
    break;

  case 38:
#line 177 "bison.y" /* yacc.c:1646  */
    { emit_distinct(); }
#line 1741 "bison.tab.c" /* yacc.c:1646  */
    break;

  case 39:
#line 181 "bison.y" /* yacc.c:1646  */
    { emit_add(); }
#line 1747 "bison.tab.c" /* yacc.c:1646  */
    break;

  case 40:
#line 182 "bison.y" /* yacc.c:1646  */
    { emit_minus(); }
#line 1753 "bison.tab.c" /* yacc.c:1646  */
    break;

  case 41:
#line 183 "bison.y" /* yacc.c:1646  */
    { emit_mul(); }
#line 1759 "bison.tab.c" /* yacc.c:1646  */
    break;

  case 42:
#line 184 "bison.y" /* yacc.c:1646  */
    { emit_div(); }
#line 1765 "bison.tab.c" /* yacc.c:1646  */
    break;

  case 43:
#line 185 "bison.y" /* yacc.c:1646  */
    { emit("MOD"); }
#line 1771 "bison.tab.c" /* yacc.c:1646  */
    break;

  case 44:
#line 186 "bison.y" /* yacc.c:1646  */
    { emit("MOD"); }
#line 1777 "bison.tab.c" /* yacc.c:1646  */
    break;

  case 45:
#line 188 "bison.y" /* yacc.c:1646  */
    { emit_and(); }
#line 1783 "bison.tab.c" /* yacc.c:1646  */
    break;

  case 46:
#line 189 "bison.y" /* yacc.c:1646  */
    { emit_eq(); }
#line 1789 "bison.tab.c" /* yacc.c:1646  */
    break;

  case 47:
#line 190 "bison.y" /* yacc.c:1646  */
    { emit_or(); }
#line 1795 "bison.tab.c" /* yacc.c:1646  */
    break;

  case 48:
#line 191 "bison.y" /* yacc.c:1646  */
    { emit("XOR"); }
#line 1801 "bison.tab.c" /* yacc.c:1646  */
    break;

  case 49:
#line 192 "bison.y" /* yacc.c:1646  */
    { emit("SHIFT %s", (yyvsp[-1].subtok)==1?"left":"right"); }
#line 1807 "bison.tab.c" /* yacc.c:1646  */
    break;

  case 50:
#line 193 "bison.y" /* yacc.c:1646  */
    { emit("NOT"); }
#line 1813 "bison.tab.c" /* yacc.c:1646  */
    break;

  case 51:
#line 194 "bison.y" /* yacc.c:1646  */
    { emit("NOT"); }
#line 1819 "bison.tab.c" /* yacc.c:1646  */
    break;

  case 52:
#line 195 "bison.y" /* yacc.c:1646  */
    { emit_cmp((yyvsp[-1].subtok)); }
#line 1825 "bison.tab.c" /* yacc.c:1646  */
    break;

  case 53:
#line 196 "bison.y" /* yacc.c:1646  */
    { emit_cmp(7); }
#line 1831 "bison.tab.c" /* yacc.c:1646  */
    break;

  case 54:
#line 198 "bison.y" /* yacc.c:1646  */
    { emit("CMPSELECT %d", (yyvsp[-3].subtok)); }
#line 1837 "bison.tab.c" /* yacc.c:1646  */
    break;

  case 55:
#line 199 "bison.y" /* yacc.c:1646  */
    {emit("EXPR");}
#line 1843 "bison.tab.c" /* yacc.c:1646  */
    break;

  case 56:
#line 200 "bison.y" /* yacc.c:1646  */
    { emit_case(); }
#line 1849 "bison.tab.c" /* yacc.c:1646  */
    break;

  case 57:
#line 204 "bison.y" /* yacc.c:1646  */
    { emit("ISBOOL %d", (yyvsp[0].intval)); }
#line 1855 "bison.tab.c" /* yacc.c:1646  */
    break;

  case 58:
#line 205 "bison.y" /* yacc.c:1646  */
    { emit("ISBOOL %d", (yyvsp[0].intval)); emit("NOT"); }
#line 1861 "bison.tab.c" /* yacc.c:1646  */
    break;

  case 59:
#line 208 "bison.y" /* yacc.c:1646  */
    { /* nil */
    (yyval.intval) = 0;
}
#line 1869 "bison.tab.c" /* yacc.c:1646  */
    break;

  case 60:
#line 211 "bison.y" /* yacc.c:1646  */
    { (yyval.intval) = (yyvsp[0].intval);}
#line 1875 "bison.tab.c" /* yacc.c:1646  */
    break;

  case 61:
#line 215 "bison.y" /* yacc.c:1646  */
    { (yyval.intval) = 1; emit_sel_name((yyvsp[0].strval));}
#line 1881 "bison.tab.c" /* yacc.c:1646  */
    break;

  case 62:
#line 216 "bison.y" /* yacc.c:1646  */
    { (yyval.intval) = (yyvsp[-4].intval) + 1; emit_sel_name((yyvsp[0].strval));}
#line 1887 "bison.tab.c" /* yacc.c:1646  */
    break;

  case 63:
#line 217 "bison.y" /* yacc.c:1646  */
    { emit_sel_name("*");}
#line 1893 "bison.tab.c" /* yacc.c:1646  */
    break;

  case 64:
#line 221 "bison.y" /* yacc.c:1646  */
    { (yyval.intval) = 1; }
#line 1899 "bison.tab.c" /* yacc.c:1646  */
    break;

  case 65:
#line 222 "bison.y" /* yacc.c:1646  */
    {(yyval.intval) = (yyvsp[-2].intval) + 1; }
#line 1905 "bison.tab.c" /* yacc.c:1646  */
    break;

  case 66:
#line 226 "bison.y" /* yacc.c:1646  */
    { (yyval.intval) = 1; }
#line 1911 "bison.tab.c" /* yacc.c:1646  */
    break;

  case 67:
#line 227 "bison.y" /* yacc.c:1646  */
    { (yyval.intval) = 1 + (yyvsp[0].intval); }
#line 1917 "bison.tab.c" /* yacc.c:1646  */
    break;

  case 68:
#line 230 "bison.y" /* yacc.c:1646  */
    { /* nil */
    (yyval.intval) = 0;
}
#line 1925 "bison.tab.c" /* yacc.c:1646  */
    break;

  case 70:
#line 235 "bison.y" /* yacc.c:1646  */
    { emit("FILTER BY"); }
#line 1931 "bison.tab.c" /* yacc.c:1646  */
    break;

  case 71:
#line 239 "bison.y" /* yacc.c:1646  */
    { (yyval.intval) = 1; emit_join_tab((yyvsp[-2].strval), 'I');}
#line 1937 "bison.tab.c" /* yacc.c:1646  */
    break;

  case 72:
#line 240 "bison.y" /* yacc.c:1646  */
    { (yyval.intval) = 1; emit_join_tab((yyvsp[-2].strval), 'L');}
#line 1943 "bison.tab.c" /* yacc.c:1646  */
    break;

  case 73:
#line 241 "bison.y" /* yacc.c:1646  */
    { (yyval.intval) = 1; emit_join_tab((yyvsp[-2].strval), 'R');}
#line 1949 "bison.tab.c" /* yacc.c:1646  */
    break;

  case 74:
#line 242 "bison.y" /* yacc.c:1646  */
    { (yyval.intval) = 1; emit_join_tab((yyvsp[-2].strval), 'O');}
#line 1955 "bison.tab.c" /* yacc.c:1646  */
    break;

  case 75:
#line 243 "bison.y" /* yacc.c:1646  */
    { (yyval.intval) = 1; emit_join_tab((yyvsp[-3].strval), 'I'); }
#line 1961 "bison.tab.c" /* yacc.c:1646  */
    break;

  case 76:
#line 244 "bison.y" /* yacc.c:1646  */
    { (yyval.intval) = 1; emit_join_tab((yyvsp[-3].strval), 'L'); }
#line 1967 "bison.tab.c" /* yacc.c:1646  */
    break;

  case 77:
#line 245 "bison.y" /* yacc.c:1646  */
    { (yyval.intval) = 1; emit_join_tab((yyvsp[-3].strval), 'R'); }
#line 1973 "bison.tab.c" /* yacc.c:1646  */
    break;

  case 78:
#line 246 "bison.y" /* yacc.c:1646  */
    { (yyval.intval) = 1; emit_join_tab((yyvsp[-3].strval), 'O'); }
#line 1979 "bison.tab.c" /* yacc.c:1646  */
    break;

  case 79:
#line 248 "bison.y" /* yacc.c:1646  */
    { /* nil */
    (yyval.intval) = 0;
}
#line 1987 "bison.tab.c" /* yacc.c:1646  */
    break;

  case 80:
#line 251 "bison.y" /* yacc.c:1646  */
    { emit_limit((yyvsp[0].intval)); }
#line 1993 "bison.tab.c" /* yacc.c:1646  */
    break;

  case 81:
#line 253 "bison.y" /* yacc.c:1646  */
    { /* nil */
    (yyval.intval) = 0;
}
#line 2001 "bison.tab.c" /* yacc.c:1646  */
    break;

  case 82:
#line 256 "bison.y" /* yacc.c:1646  */
    { emit_sort((yyvsp[0].strval), 0); }
#line 2007 "bison.tab.c" /* yacc.c:1646  */
    break;

  case 83:
#line 257 "bison.y" /* yacc.c:1646  */
    { emit_sort((yyvsp[-3].strval), (yyvsp[0].intval)); }
#line 2013 "bison.tab.c" /* yacc.c:1646  */
    break;

  case 84:
#line 258 "bison.y" /* yacc.c:1646  */
    { emit_presort((yyvsp[0].strval)); }
#line 2019 "bison.tab.c" /* yacc.c:1646  */
    break;


#line 2023 "bison.tab.c" /* yacc.c:1646  */
      default: break;
    }
  /* User semantic actions sometimes alter yychar, and that requires
     that yytoken be updated with the new translation.  We take the
     approach of translating immediately before every use of yytoken.
     One alternative is translating here after every semantic action,
     but that translation would be missed if the semantic action invokes
     YYABORT, YYACCEPT, or YYERROR immediately after altering yychar or
     if it invokes YYBACKUP.  In the case of YYABORT or YYACCEPT, an
     incorrect destructor might then be invoked immediately.  In the
     case of YYERROR or YYBACKUP, subsequent parser actions might lead
     to an incorrect destructor call or verbose syntax error message
     before the lookahead is translated.  */
  YY_SYMBOL_PRINT ("-> $$ =", yyr1[yyn], &yyval, &yyloc);

  YYPOPSTACK (yylen);
  yylen = 0;
  YY_STACK_PRINT (yyss, yyssp);

  *++yyvsp = yyval;

  /* Now 'shift' the result of the reduction.  Determine what state
     that goes to, based on the state we popped back to and the rule
     number reduced by.  */

  yyn = yyr1[yyn];

  yystate = yypgoto[yyn - YYNTOKENS] + *yyssp;
  if (0 <= yystate && yystate <= YYLAST && yycheck[yystate] == *yyssp)
    yystate = yytable[yystate];
  else
    yystate = yydefgoto[yyn - YYNTOKENS];

  goto yynewstate;


/*--------------------------------------.
| yyerrlab -- here on detecting error.  |
`--------------------------------------*/
yyerrlab:
  /* Make sure we have latest lookahead translation.  See comments at
     user semantic actions for why this is necessary.  */
  yytoken = yychar == YYEMPTY ? YYEMPTY : YYTRANSLATE (yychar);

  /* If not already recovering from an error, report this error.  */
  if (!yyerrstatus)
    {
      ++yynerrs;
#if ! YYERROR_VERBOSE
      yyerror (YY_("syntax error"));
#else
# define YYSYNTAX_ERROR yysyntax_error (&yymsg_alloc, &yymsg, \
                                        yyssp, yytoken)
      {
        char const *yymsgp = YY_("syntax error");
        int yysyntax_error_status;
        yysyntax_error_status = YYSYNTAX_ERROR;
        if (yysyntax_error_status == 0)
          yymsgp = yymsg;
        else if (yysyntax_error_status == 1)
          {
            if (yymsg != yymsgbuf)
              YYSTACK_FREE (yymsg);
            yymsg = (char *) YYSTACK_ALLOC (yymsg_alloc);
            if (!yymsg)
              {
                yymsg = yymsgbuf;
                yymsg_alloc = sizeof yymsgbuf;
                yysyntax_error_status = 2;
              }
            else
              {
                yysyntax_error_status = YYSYNTAX_ERROR;
                yymsgp = yymsg;
              }
          }
        yyerror (yymsgp);
        if (yysyntax_error_status == 2)
          goto yyexhaustedlab;
      }
# undef YYSYNTAX_ERROR
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

  /* Do not reclaim the symbols of the rule whose action triggered
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
  yyerrstatus = 3;      /* Each real token shifted decrements this.  */

  for (;;)
    {
      yyn = yypact[yystate];
      if (!yypact_value_is_default (yyn))
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

  YY_IGNORE_MAYBE_UNINITIALIZED_BEGIN
  *++yyvsp = yylval;
  YY_IGNORE_MAYBE_UNINITIALIZED_END


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

#if !defined yyoverflow || YYERROR_VERBOSE
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
    {
      /* Make sure we have latest lookahead translation.  See comments at
         user semantic actions for why this is necessary.  */
      yytoken = YYTRANSLATE (yychar);
      yydestruct ("Cleanup: discarding lookahead",
                  yytoken, &yylval);
    }
  /* Do not reclaim the symbols of the rule whose action triggered
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
  return yyresult;
}
#line 260 "bison.y" /* yacc.c:1906  */


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


