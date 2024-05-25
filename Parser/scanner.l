%{
#include <stdio.h>
#include <stdbool.h>
#include <stdlib.h>
#include "y.tab.h"
#define YYLMAX 100
int lnnr = 1;
char idTBD[256];
enum TOKEN {VAR, VAL, BOOL, CHAR, INT, REAL, 
BOOL_VAL, INT_NUM, REAL_NUM, CHAR_VAL, STRING
PLUS, MINUS, MULT, DIV,
ASSIGN, EQ, NEQ, GEQ, LEQ, GT, LT, OPERATOR,
LETTER, DIGIT,
ID,
CLASS,
IF, ELSE, FOR, WHILE, DO, SWITCH, CASE,
FUNCTION, RETURN,
LRB, RRB, LSB, RSB, LCB, RCB,
COMMA, SEMICOLON, COLON,
BSLASH, SQUOTE, DQUOTE, QUESTION,
PRINTL};
%}

/* regexes */

/* states */
/* %x <state-name>: set a state, default 0/INITIAL
goto a state using: BEGIN <state-name> */
/* need to set up rules for a state in %% %% */
%x SCMNT
%x MULCMNT

/* var/const */
VAR var
VAL val

/* data type */
BOOL bool
CHAR char
INT int
REAL real

/* literal constants */
BOOL_VAL ("true"|"false")
REAL_NUM ((\-)?([0]|[1-9]+[0-9]*)\.[0-9]+)
INT_NUM ((\-)?([0]|[1-9])+[0-9]*)
/* might not need '-' for now */

/* Operators */
PLUS \+
MINUS \-
MULT \*
DIV \/
ASSIGN "="
EQ "=="
NEQ "!="
GEQ ">="
LEQ "<="
GT ">"
LT "<"
OPERATOR ({PLUS}|{MINUS}|{MULT}|{DIV}|{ASSIGN}|{EQ}|{NEQ}|{GEQ}|{LEQ}|{GT}|{LT})

/* id */
LETTER [_a-zA-Z]
DIGIT [0-9]
ID {LETTER}({LETTER}|{DIGIT})*



CLASS class

IF if
ELSE else
FOR for
WHILE while
DO do
SWITCH switch
CASE case

FUNCTION fun
RETURN ret
PRINTL println


%% 

"/*" {BEGIN MULCMNT;}
<MULCMNT>"*/" {BEGIN 0;}
<MULCMNT>.|\n {;}
"//" {BEGIN SCMNT;}
<SCMNT>\n {BEGIN 0;}
<SCMNT>. {;}


{VAR} {ECHO; return VAR;}
{VAL} {ECHO; return VAL;}

{BOOL} {ECHO; return BOOL;}
{CHAR} {ECHO; return CHAR;}
{INT} {ECHO; return INT;}
{REAL} {ECHO; return REAL;}

{BOOL_VAL} {yylval.str = strsave(yytext); return BOOL_VAL;}
{INT_NUM} {sscanf(yytext, "%d", &(yylval.intVal)); return INT_NUM;}
{REAL_NUM} {sscanf(yytext, "%lf", &(yylval.reVal)); return REAL_NUM;}
"'" (\w|\W) "'" { yylval.string = strsave(yytext + 1); return CHAR_VAL; }
"\"" (\w|\W)* "\""  { yylval.string = strsave(yytext + 1); return STRING; }
{ID} { yylval.str = strsave(yytext); return ID; }

{OPERATOR} {ECHO; return OPERATOR;}



{CLASS} {ECHO; return CLASS;}

{IF} {ECHO; return IF;}
{ELSE} {ECHO; return ELSE;}
{FOR} {ECHO; return FOR;}
{WHILE} {ECHO; return WHILE;}
{DO} {ECHO; return DO;}
{SWITCH} {ECHO; return SWITCH;}
{CASE} {ECHO; return CASE;}

{FUNCTION} {ECHO; return FUNCTION;}
{RETURN} {ECHO; return RETURN;}
{PRINTL} {ECHO; return PRINTL;}


"(" {ECHO; return LRB;}
")" {ECHO; return RRB;}
"[" {ECHO; return LSB;}
"]" {ECHO; return RSB;}
"{" {ECHO; return LCB;}
"}" {ECHO; return RCB;}
"," {ECHO; return COMMA;}
";" {ECHO; return SEMICOLON;}
":" {ECHO; return COLON;}


"\\n" {ECHO; yylineno++;}
"\\t" {;}
"'" {ECHO; return SQUOTE;}
"\"" {ECHO; return DQUOTE;}
"\\?" {ECHO; return QUESTION;}
"\\\\" {ECHO; return BSLASH;}

%%
/* %x ID_IDENTIFICATIO: TBD
 * Rules incl.
<ID_IDENTIFICATIO>":" {printf("%s: ID init", idTBD); BEGIN 0;}
<ID_IDENTIFICATIO>{ASSIGN} {printf("%s: ID assignation", idTBD); BEGIN 0;}
<ID_IDENTIFICATIO>{OPERATOR} {printf("%s: ID as operand", idTBD); BEGIN 0;} 
<ID_IDENTIFICATIO>"" {BEGIN 0;} 
*/


/* TB Modify
{BOOL_VAL} {sscanf(yytext, "%d", &(yylval.boolVal)); ECHO; return BOOL_VAL;}
{INT_NUM} {sscanf(yytext, "%d", &(yylval.intVal)); ECHO; return INT_NUM;}
{REAL_NUM} {sscanf(yytext, "%lf", &(yylval.reVal)); ECHO; return REAL_NUM;}
{CHAR_VAL} {sscanf(yytext, "%c", &(yylval.cVal)); ECHO; return CHAR_VAL;}
*/

/* TB Modify
{ID} {
    strcpy(idTBD, yytext);
    BEGIN ID_IDENTIFICATIO;
    }
*/

/* Not able to use rn: Undefined reference to yycomment
 * "/*" yycomment("\*\/");
 * "//" yycomment("\n");
*/
int main(int argc, char* argv[])
{
    if(argc > 1) {
        FILE *fp = fopen(argv[1], "r");
        if (fp)
            yyin = fp;
    }
    int tk;
    while (true)
        tk = yylex();
    yywrap();
}

/*
yytext: cur input tk recog by lex
yyleng: yytext.len
yyin: det input stream for yylex()
yyout: det output stream for output macro
yylineno: cur. input line nr
yymore()
yyless(n)
unput(char)
*/