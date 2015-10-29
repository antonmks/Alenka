
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

/* Line 1676 of yacc.c  */
#line 25 "bison.y"

    long long int intval;
    double floatval;
    char *strval;
    int subtok;



/* Line 1676 of yacc.c  */
#line 136 "bison.tab.h"
} YYSTYPE;
# define YYSTYPE_IS_TRIVIAL 1
# define yystype YYSTYPE /* obsolescent; will be withdrawn */
# define YYSTYPE_IS_DECLARED 1
#endif

extern YYSTYPE yylval;


