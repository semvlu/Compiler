%{
#include <stdio.h>
#include <stdbool.h>
#include <stdlib.h>
#include <y.tab.h>
#define YYLMAX 256
extern int lnnr = 1;
extern char idTBD[256];
void yyerror(const char *s)

#ifndef YYSTYPE
#define YYSTYPE int
#endif
#define INTEGER 258
extern YYSTYPE yylval; 
%}

%union {
    bool boolVal;
    char cVal;
    int intVal;
    double reVal;
    char *strVal;
}
%token <boolVal> BOOL
%token <cVal> CHAR
%token <intVal> INT
%token <reVal> REAL
%token <strVal> STRING

%left '+' '-'
%left '*' '/'
%right UMINUS
%start /* non terminal */
%type /* non terminal type */

%%

type: 
    BOOL {}
    | CHAR {}
    | INT {}
    | REAL {}
    ;

%%