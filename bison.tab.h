/* A Bison parser, made by GNU Bison 3.0.4.  */

/* Bison interface for Yacc-like parsers in C

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
    NONEQUAL = 268,
    OR = 269,
    XOR = 270,
    AND = 271,
    DISTINCT = 272,
    IN = 273,
    IS = 274,
    LIKE = 275,
    REGEXP = 276,
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
    APPEND = 334,
    NO = 335,
    ENCODING = 336
  };
#endif

/* Value type.  */
#if ! defined YYSTYPE && ! defined YYSTYPE_IS_DECLARED

union YYSTYPE
{
#line 25 "bison.y" /* yacc.c:1909  */

    long long int intval;
    double floatval;
    char *strval;
    int subtok;

#line 143 "bison.tab.h" /* yacc.c:1909  */
};

typedef union YYSTYPE YYSTYPE;
# define YYSTYPE_IS_TRIVIAL 1
# define YYSTYPE_IS_DECLARED 1
#endif


extern YYSTYPE yylval;

int yyparse (void);

#endif /* !YY_YY_BISON_TAB_H_INCLUDED  */
