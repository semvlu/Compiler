// Symbol table & AST TBD

%{
#include <stdio.h>
#include <stdbool.h>
#include <stdlib.h>
#include "y.tab.h"
#include "parser.h"


#ifndef YYSTYPE
#define YYSTYPE int
#endif
#define INTEGER 258
%}

%union {
    struct ast *a;
    bool boolVal;
    int intVal;
    double reVal;
    char *string;
}
%token VAR VAL
%token BOOL INT REAL CHAR
%token PLUS MINUS MULT DIV
%token ASSIGN EQ NEQ GEQ LEQ GT LT OPERATOR
LETTER DIGIT
%token ID
%token CLASS
%token IF ELSE FOR WHILE DO SWITCH CASE
%token FUNCTION RETURN
%token LRB RRB LSB RSB LCB RCB
%token COMMA SEMICOLON COLON
%token BSLASH SQUOTE DQUOTE QUESTION
%token PRINTL


%token <boolVal> BOOL_VAL
%token <cVal> CHAR_VAL
%token <intVal> INT_NUM
%token <reVal> REAL_NUM
%token <string> CHAR_VAL STRING


%left EQ NEQ GEQ LEQ GT LT
%left '+' '-'
%left '*' '/'
%right UMINUS
%start /* non terminal */
%type <reVal> value

%%
prog: FUNCTION ID block {};
block: LCB stmts RCB {}

stmts: stmts stmt {}
    | %empty
    ;
stmt: expr
    | ID '=' expr {}
    | ID '[' expr ']' '=' expr {}
    | PRINTL '(' expr ')' {}
    | matched_stmt
    | open_stmt
    | WHILE '(' expr ')' stmt
    | DO stmt WHILE '(' expr ')'
    | block 
    ;

expr: ID {}
    | expr '+' expr {$$ = $1 + $3; }
    | expr '-' expr {$$ = $1 - $3; }
    | expr '*' expr {$$ = $1 * $3; }
    | expr '/' expr {
        if($3 == 0.0) {
            yyerror("Error: Divisor cannot be zero!");
            YYABORT;
        } else $$ = $1 / $3; 
        }
    | '(' expr ')' {$$ = $2}
    | '-' expr %prec UMINUS {$$ = - $2; }
    | CHAR_VAL {$$ = $1; }
    | BOOL_VAL {$$ = $1; }
    | INT_NUM {$$ = $1; }
    | REAL_NUM {$$ = $1; }
    ;

value: REAL {$$ = $1; }
    | INT {$$ = (float)$1; }

type: 
    BOOL { printf("BOOL type\n"); }
    | CHAR { printf("CHAR type\n"); }
    | INT { printf("INT type\n");}
    | REAL { printf("REALtype\n");}
    ;

condition: 

matched_stmt: IF '(' expr ')' matched_stmt ELSE matched_stmt;
open_stmt: IF '(' expr ')' condition
    | IF '(' expr ')' matched_stmt ELSE open_stmt
    ;    

return: RETURN expr COMMA;
%%

void yyerror(const char *s) { fprintf(stderr, "%s\n", s); return 0;}

int main(){
    yyparse();
    return 0;
}