%{
#include <stdio.h>
#include <stdbool.h>
#include <stdlib.h>
#define YYLMAX 100
int lnnr = 1;
char idTBD[256];
enum TOKEN {VAR, VAL, BOOL, CHAR, INT, REAL, 
BOOL_VAL, INT_NUM, REAL_NUM, CHAR_VAL,
PLUS, MINUS, MULT, DIV,
ASSIGN, EQ, NEQ, GEQ, LEQ, GT, LT, OPERATOR,
LETTER, DIGIT,
ID,
CLASS,
IF, ELSE, FOR, WHILE, DO, SWITCH, CASE,
FUNCTION, RETURN,
LRB, RRB, LSB, RSB, LCB, RCB,
COMMA, SEMICOLON, COLON,
SQUOTE, DQUOTE, QUESTION, BSLASH,
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

CHAR_VAL [!#$%&@^_`~ÀÁÂÃÄÅÆÇÈÉÊËÌÍÎÏÐÑÒÓÔÕÖ×ØÙÚÛÜÝÞàáâãäåæçèéêëìíîïðñòóôõö÷øùúûüýþÿ]

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


{VAR} {ECHO; printf(" VAR\n");}
{VAL} {ECHO; printf(" VAL\n");}

{BOOL} {ECHO; printf(" BOOL\n");}
{CHAR} {ECHO; printf(" CHAR\n");}
{INT} {ECHO; printf(" INT\n");}
{REAL} {ECHO; printf(" REAL\n");}

{BOOL_VAL} {ECHO; printf(" BOOL_VAL\n");}
{INT_NUM} {ECHO; printf(" INT_NUM\n");}
{REAL_NUM} {ECHO; printf(" REAL_NUM\n");}
{CHAR_VAL} {ECHO; printf(" CHAR_VAL\n");}

{OPERATOR} {ECHO; printf(" OPERATOR\n"); }

{CLASS} {ECHO; printf(" CLASS\n");}

{IF} {ECHO; printf(" IF\n");}
{ELSE} {ECHO; printf(" ELSE\n");}
{FOR} {ECHO; printf(" FOR\n");}
{WHILE} {ECHO; printf(" WHILE\n"); }
{DO} {ECHO; printf(" DO\n");}
{SWITCH} {ECHO; printf(" SWITCH\n");}
{CASE} {ECHO; printf(" CASE\n");}

{FUNCTION} {ECHO; printf(" FUNCTION\n");}
{RETURN} {ECHO; printf(" RETURN\n");}
{PRINTL} {ECHO; printf(" Print Line func\n");}

{ID} {ECHO; printf(" ID\n");}


"(" {ECHO;printf(" LRB\n");}
")" {ECHO;printf(" RRB\n");}
"[" {ECHO;printf(" LSB\n");}
"]" {ECHO;printf(" RSB\n");}
"{" {ECHO;printf(" LCB\n");}
"}" {ECHO;printf(" RCB\n");}
"," {ECHO; printf(" COMMA\n");}
";" {ECHO; printf(" SEMICOLON\n");}
":" {ECHO; printf(" COLON\n");}

"\\n" {yylineno++;}
[ \t]+ {;}
"'" {ECHO; printf(" SQUOTE\n");}
"\"" {ECHO; printf(" DQUOTE\n");}
"\\?" {ECHO; printf(" QUESTION\n");}
"\\\\" {ECHO; printf(" BSLASH\n");}


%%
/*
\n:check
': check
": check
\?: check
\\: check
*/

int main(int argc, char* argv[])
{
    if(argc > 1) {
        FILE *fp = fopen(argv[1], "r");
        if (fp)
            yyin = fp;
    }
    yylex();

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