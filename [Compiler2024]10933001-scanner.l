%{
#include <stdio.h>
#include <stdbool.h>
#include <stdlib.h>
#define YYLMAX 256
int lnnr = 1;
char idTBD[256];
%}



/* regexes */

/* states */
/* %x <state-name>: set a state, default 0/INITIAL, goto a state using: BEGIN <state-name> */
/* need to set up rules for a state */
%x ID_IDENTIFICATIO

/* var/const */
VAR var
VAL val

/* data type */
BOOL bool
CHAR char
INT int
REAL real
VECTOR (VECTOR|Vector|vector) 
/* prod rule NOT yet def */
DATATYPE ({BOOL}|{CHAR}|{INT}|{REAL})

/* literal constants */
BOOL_VAL ("true"|"false")
INT_NUM ((\-)?[0]|[1-9]+\d*)
REAL_NUM ((\-)?[1-9]+[0-9]*\.[0-9]+)
/* might not need '-' for now */

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

%%
<ID_IDENTIFICATIO>":" {printf("%s: ID init", idTBD); BEGIN 0;}
<ID_IDENTIFICATIO>{ASSIGN} {printf("%s: ID assignation", idTBD); BEGIN 0;}
<ID_IDENTIFICATIO>{OPERATOR} {printf("%s: ID as operand", idTBD); BEGIN 0;} /*ASSIGN still included*/
<ID_IDENTIFICATIO>"" {BEGIN 0;} ;

{VAR} {ECHO; return VAR;}
{VAL} {ECHO; return VAL;}

{BOOL} {ECHO; return BOOL;}
{CHAR} {ECHO; return CHAR;}
{INT} {ECHO; return INT;}
{REAL} {ECHO; return REAL;}

{BOOL_VAL} {sscanf(yytext, "%d", &(yylval.boolVal)); ECHO; return BOOL_VAL;}
{INT_NUM} {sscanf(yytext, "%d", &(yylval.intVal)); ECHO; return INT_NUM;}
{REAL_NUM} {sscanf(yytext, "%lf", &(yylval.reVal)); ECHO; return REAL_NUM;}
{OPERATOR} {ECHO; return OPERATOR;}
{ID} {
    strcpy(idTBD, yytext);
    BEGIN ID_IDENTIFICATIO;
    }


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


\( {ECHO; return LRB;}
\) {ECHO; return RRB;}
\[ {ECHO; return LSB;}
\] {ECHO; return RSB;}
\{ {ECHO; return LCB;}
\} {ECHO; return RCB;}
\, {ECHO; return COMMA;}
\; {ECHO; return SEMICOLON;}
\: {ECHO; return COLON;}


"\n" {yylineno++;}
[ \t]+ {}
"\\" {return BSLASH;}
"'" {return SQUOTE;}
"\"" {return DQUOTE;}
"\?" {return QUESTION;}

"/*" {yycomment("*/");}
"//" {yycomment("\n");}

[^ ;\t\n\"\^|]+ {ECHO; return STRING;}

"println" {return PRINTL;}

%%

int main(int argc, char* argv[])
{
    if(argc > 1) {
        FILE *fp = fopen(argv[1]. "r");
        if (fp)
            yyin = fp;
    }
    yylex();
    if (yyleng > YYLMAX)
        yyerror("Exceed maximum token length!");
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
