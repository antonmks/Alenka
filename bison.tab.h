
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

/* Line 1676 of yacc.c  */
#line 25 "bison.y"

    long long int intval;
    double floatval;
    char *strval;
    int subtok;



/* Line 1676 of yacc.c  */
#line 133 "bison.tab.h"
} YYSTYPE;
# define YYSTYPE_IS_TRIVIAL 1
# define yystype YYSTYPE /* obsolescent; will be withdrawn */
# define YYSTYPE_IS_DECLARED 1
#endif

extern YYSTYPE yylval;


