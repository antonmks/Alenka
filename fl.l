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
#include "atof.h"

#ifdef _WIN64
#define atoll(S) _atoi64(S)
#else
#include <unistd.h>
#endif

void yyerror(char *s, ...);
#define YY_NEVER_INTERACTIVE 1
#define YY_NO_UNISTD_H

%}
%option noyywrap nodefault yylineno case-insensitive never-interactive

%x COMMENT
%s BTWMODE

%%

AND {return AND; }
OR {return OR; }
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
USING { return USING; }
COUNT { return COUNT; }
SUM { return SUM; }
AVG { return AVG; }
MIN { return MIN; }
MAX { return MAX; }
LIMIT { return LIMIT; }
ON { return ON; }
BINARY { return BINARY; }
DISTINCT { return DISTINCT; }
LEFT { return LEFT; }
RIGHT { return RIGHT; }
OUTER { return OUTER; }
SEMI { return SEMI; }
ANTI { return ANTI; }
SORT {return SORT; }
SEGMENTS {return SEGMENTS; }
PRESORTED {return PRESORTED; }
INSERT {return INSERT; }
WHERE {return WHERE; }
DISPLAY {return DISPLAY; }
CASE {return CASE; }
WHEN {return WHEN; }
THEN {return THEN; }
ELSE {return ELSE; }
END {return END; }
SHOW {return SHOW; }
TABLES {return TABLES; }
TABLE {return TABLE; }
DESCRIBE {return DESCRIBE; }
DROP {return DROP; }
DELETE {return DELETE; }
FROM {return FROM; }
LIKE {return LIKE; }
CREATE {return CREATE; }
INDEX {return INDEX; }
YEAR {return YEAR; }
MONTH {return MONTH; }
DAY {return DAY; }
CAST_TO_INT {return CAST_TO_INT; }
APPEND {return APPEND; }

-?[0-9]+ { yylval.intval = atoll(yytext);  return INTNUM; }
-?[0-9]+"."[0-9]* |
-?[0-9]+"."[0-9]* |
-?"."[0-9]+ { yylval.strval = strdup(yytext); return DECIMAL1; }
-?[0-9]+E[-+]?[0-9]+ |
-?[0-9]+"."[0-9]*E[-+]?[0-9]+ |
-?"."[0-9]+E[-+]?[0-9]+ { yylval.floatval = atoff(yytext) ;return APPROXNUM; }
[0-9]+(HOUR|MINUTE|SECOND|MSECOND|DAY|MONTH|YEAR) { yylval.strval = strdup(yytext); return STRING; }
date\(\) { yylval.strval = strdup(yytext); return STRING;}

TRUE { yylval.intval = 1; return BOOL1; }
UNKNOWN { yylval.intval = -1; return BOOL1; }
FALSE { yylval.intval = 0; return BOOL1; }

\"(\\.|\"\"|[^"\n])*\" { yylval.strval = strdup(yytext); return STRING; }
'(\\.|[^'\n])*$ { yyerror("Unterminated string %s", yytext); break;}
\"(\\.|[^"\n])*$ { yyerror("Unterminated string %s", yytext); break;}


[-+&~|^/%*(),.;:!{}] { return yytext[0]; }
"&&" { return AND; }
"||" { return OR; }
":=" { return ASSIGN; }
"=" { return EQUAL; }
"<>" { return NONEQUAL; }
"==" { yylval.subtok = 4; return COMPARISON; }
"<=>" { yylval.subtok = 12; return COMPARISON; }
">=" { yylval.subtok = 6; return COMPARISON; }
">" { yylval.subtok = 2; return COMPARISON; }
"<=" { yylval.subtok = 5; return COMPARISON; }
"<" { yylval.subtok = 1; return COMPARISON; }
"!=" { yylval.subtok = 3; return COMPARISON; }

'[A-Za-z0-9_:\\\.|;]*' { yylval.strval = strdup(yytext+1);
yylval.strval[yyleng-2] = 0; return FILENAME; }

[A-Za-z][A-Za-z0-9_]* { yylval.strval = strdup(yytext);return NAME; }
'[^'/\\.\n]+' { yylval.strval = strdup(yytext+1);yylval.strval[yyleng-2] = 0; return FILENAME; }


[ \t\n] 
. {  }
%%

void PROC_FLUSH_BUF ( FILE * xFile )
{
        yy_delete_buffer ( YY_CURRENT_BUFFER );
        yy_switch_to_buffer ( yy_create_buffer ( xFile, YY_BUF_SIZE ) ); 
}



