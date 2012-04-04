/*
 *  Licensed under the Apache License, Version 2.0 (the "License");
 *  you may not use this file except in compliance with the License.
 *  You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 *  Unless required by applicable law or agreed to in writing, software
 *  distributed under the License is distributed on an "AS IS" BASIS,
 *  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 *  See the License for the specific language governing permissions and
 *  limitations under the License.
 */


%{
#include "bison.tab.h"
#include <stdarg.h>
#include <string.h>

void yyerror(char *s, ...);
int oldstate;
#define YY_NEVER_INTERACTIVE 1

%}
%option noyywrap nodefault yylineno case-insensitive

%x COMMENT
%s BTWMODE

%%

AND {return AND; };
OR {return OR; };
LOAD { return LOAD; }
FILTER { return FILTER; }
DESC { return DESC; }
ASC { return ASC; }
ORDER { return ORDER; }
BY { return BY; }
JOIN { return JOIN; }
STORE { return STORE; }
INTO { return INTO; }
GROUP { return GROUP; }
AS { return AS; }
SELECT { return SELECT; }
FROM { return FROM; }
USING { return USING; }
COUNT { return COUNT; }
SUM { return SUM; }
AVG { return AVG; }
MIN { return MIN; }
MAX { return MAX; }
LIMIT { return LIMIT; }
ON { return ON; }
STREAM { return STREAM; }
BINARY { return BINARY; }


[0-9]+ { yylval.intval = atoi(yytext);  return INTNUM; }
-?[0-9]+"."[0-9]* |
-?"."[0-9]+ |
-?[0-9]+E[-+]?[0-9]+ |
-?[0-9]+"."[0-9]*E[-+]?[0-9]+ |
-?"."[0-9]+E[-+]?[0-9]+ { yylval.floatval = atof(yytext) ;
return APPROXNUM; }

TRUE { yylval.intval = 1; return BOOL; }
UNKNOWN { yylval.intval = -1; return BOOL; }
FALSE { yylval.intval = 0; return BOOL; }

\"(\\.|\"\"|[^"\n])*\" { yylval.strval = strdup(yytext); return STRING; }
'(\\.|[^'\n])*$ { yyerror("Unterminated string %s", yytext); }
\"(\\.|[^"\n])*$ { yyerror("Unterminated string %s", yytext); }


[-+&~|^/%*(),.;:!{}] { return yytext[0]; }
"&&" { return AND; }
"||" { return OR; }
":=" { return ASSIGN; }
"=" { return EQUAL; }
"==" { yylval.subtok = 4; return COMPARISON; }
"<=>" { yylval.subtok = 12; return COMPARISON; }
">=" { yylval.subtok = 6; return COMPARISON; }
">" { yylval.subtok = 2; return COMPARISON; }
"<=" { yylval.subtok = 5; return COMPARISON; }
"<" { yylval.subtok = 1; return COMPARISON; }
"!=" |
"<>" { yylval.subtok = 3; return COMPARISON; }

'[A-Za-z0-9_:\\\.|;]*' { yylval.strval = strdup(yytext+1);
yylval.strval[yyleng-2] = 0; 
return FILENAME; }

[A-Za-z][A-Za-z0-9_]* { yylval.strval = strdup(yytext);
return NAME; }
'[^'/\\.\n]+' { yylval.strval = strdup(yytext+1);
yylval.strval[yyleng-2] = 0; 
return FILENAME; }
'[^'\n]*$ { printf("unterminated quoted name %s", yytext); }


[ \t\n] 
. { printf("mystery character '%c'", *yytext); }
%%

void PROC_FLUSH_BUF ( FILE * xFile )
{
        yy_delete_buffer ( YY_CURRENT_BUFFER );
        yy_switch_to_buffer ( yy_create_buffer ( xFile, YY_BUF_SIZE ) ); 
}


