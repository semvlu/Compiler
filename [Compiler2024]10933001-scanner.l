%{
#include <stdio.h>
#define YYLMAX 255
int lnnr = 1;
%}
/* regexes */
VAR var
CONST val
BOOL bool
CHAR char
INT int
REAL real
DATATYPE ({BOOL}|{CHAR}|{INT}|{REAL})

ID (VECTOR|Vector|vector)
NUMBER ([0-9]+)
OPERATOR (\+|\-|\*|\/|=|==|!=|>=|<=|>|<)
INT_NUM ([0]|[1-9]+[0-9]*)
REAL_NUM ([1-9]+[0-9]*\.[0-9]+)
TRUE true
FALSE false

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



"char"
"int"
"real"

"true"
"false"

"class"

"if"
"else"
"for"
"while"
"do"
"switch"
"case"

"fun"
"ret"

"'" {}
"\"" {}
"("
")"
"["
"]"
"{"
"}"
","
";"
":"

"+"
"-"
"*"
"/" {}
"="
"==" {}
"!=" {}
">="
"<="
">" {}
"<"

"\n" {++yylineno;}
"\t"
"\\"
"\'"
"\""
"\?"

"/*" {yycomment("*/");}

%%

int main(int argc, char* argv[])
{
    if(argc > 1) {
        FILE *fp = fopen(argv[1]. "r");
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
*/