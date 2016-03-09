
/* A Bison parser, made by GNU Bison 2.4.1.  */

/* Skeleton interface for Bison's Yacc-like parsers in C
   
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

/* Line 1676 of yacc.c  */
#line 25 "bison.y"

    long long int intval;
    double floatval;
    char *strval;
    int subtok;



/* Line 1676 of yacc.c  */
#line 139 "bison.tab.h"
} YYSTYPE;
# define YYSTYPE_IS_TRIVIAL 1
# define yystype YYSTYPE /* obsolescent; will be withdrawn */
# define YYSTYPE_IS_DECLARED 1
#endif

extern YYSTYPE yylval;


