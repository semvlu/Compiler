// Symbol table & AST TBD

%{
#include <stdio.h>
#include <stdlib.h>
#include <iostream>
#include "y.tab.h"
#include "ASTSymTab.h"
void yyerror(const char *s);
extern int yylineno; // from lex
extern int yylex();
extern int yyparse();
%}

%union {
    struct ast *a;
    int intVal;
    double reVal;
    char *str;
    struct symbol *s;		/* which symbol */
    struct symlist *sl;
    int fn;
}
%token VAR VAL // Declaration
%token BOOL INT REAL CHAR // Type
%token ID 
%token CLASS
%token IF ELSE FOR WHILE DO SWITCH CASE
%token FUNCTION RETURN
%token COMMA SEMICOLON COLON
%token PRINTL


%token <str> BOOL_VAL CHAR_VAL STRING
%token <intVal> INT_NUM
%token <reVal> REAL_NUM


%left EQ NEQ GEQ LEQ GT LT
%left '+' '-'
%left '*' '/'
%right UMINUS

// %start /* non terminal */
%type <str> strExpr
%type <intVal> intExpr
%type <reVal> reExpr
%type <a> prog block decl arrDecl
%type <reVal> double_coercion

%%
prog: FUNCTION ID block;
block: '{' stmts '}';

decl: VAR ID COLON type SEMICOLON {}
    | VAL ID COLON type SEMICOLON {}
    | VAR ID COLON type '=' literal SEMICOLON { $$ = newast }
    | VAL ID COLON type '=' literal  SEMICOLON { $$ = $6; }
    ;

arrDecl: VAR ID COLON type dims SEMICOLON {} 
dims: dims '[' intExpr ']'
    | %empty
    ;

literal: BOOL_VAL 
    | CHAR_VAL 
    | STRING
    | INT_NUM
    | REAL_NUM
    ;

type: BOOL { printf("BOOL type\n"); }
    | CHAR { printf("CHAR type\n"); }
    | INT { printf("INT type\n");}
    | REAL { printf("REALtype\n");}
    ;

stmts: stmts stmt {}
    | %empty
    ;
stmt: matched_stmt
    | open_stmt
    ;
matched_stmt: IF '(' expr ')' matched_stmt ELSE matched_stmt 
        // { $$ = newflow(pp,'I', $3, $5, $7); }
    | expr
    | ID '=' expr {}
    | ID '[' expr ']' '=' expr {}
    | PRINTL '(' expr ')' SEMICOLON {}
    | WHILE '(' expr ')' stmt // { $$ = newflow(pp, 'W', $3, $5, NULL); }
    | DO stmt WHILE '(' expr ')' SEMICOLON // { $$ = newflow(pp, 'W', $5, $2, NULL);}
    | block 
    ;
open_stmt: IF '(' expr ')' stmt
    |IF '(' expr ')' matched_stmt ELSE open_stmt
     // { $$ = newflow(pp, 'I', $3, $5, NULL); }
    ;    

expr: intExpr
    | reExpr
    | strExpr
    ;

intExpr: ID SEMICOLON { $$ = $1; }
    | intExpr '+' intExpr { $$ = $1 + $3; }
    | intExpr '-' intExpr { $$ = $1 - $3; }
    | intExpr '*' intExpr { $$ = $1 * $3; }
    | intExpr '/' intExpr {
        if($3 == 0) {
            yyerror("Error: Divisor cannot be zero!");
            YYABORT;
        } else $$ = $1 / $3; 
        }
    | '(' intExpr ')' SEMICOLON {$$ = $2}
    | '-' intExpr %prec UMINUS {$$ = - $2; }
    | INT_NUM SEMICOLON { $$ = $1; }
    ;


reExpr: ID SEMICOLON { $$ = $1; }
    | reExpr '+' reExpr { $$ = $1 + $3; }
    | reExpr '-' reExpr { $$ = $1 - $3; }
    | reExpr '*' reExpr { $$ = $1 * $3; }
    | reExpr '/' reExpr {
        if($3 == 0.0) {
            yyerror("Error: Divisor cannot be zero!");
            YYABORT;
        } else $$ = $1 / $3; 
        }
    | '(' reExpr ')' SEMICOLON { $$ = $2}
    | '-' reExpr %prec UMINUS { $$ = - $2; }
    | double_coercion SEMICOLON { $$ = $1; }
    ;
double_coercion: REAL_NUM { $$ = $1; }
    | INT_NUM { $$ = (double)$1; }
    ;

// BOOL, CHAR, STRING
strExpr: ID SEMICOLON { $$ = $1; }
    | BOOL_VAL SEMICOLON { $$ = $1; }
    | CHAR_VAL SEMICOLON { $$ = $1; }
    | STRING SEMICOLON { $$ = $1; }
    ;
return: RETURN expr SEMICOLON
    | RETURN SEMICOLON;
%%

void yyerror(const char *s) { fprintf(stderr, "%s\n", s); return 0;}

int main(){
    yyparse();
    return 0;
}