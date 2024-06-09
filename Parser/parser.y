// Symbol table & AST TBD

%{
#include <stdio.h>
#include <stdlib.h>
#include "parser.tab.h"
#include "parser.h"


%}

%union {
    int intVal;
    double reVal;
    char *str;
}
%token VAR VAL // Declaration
%token BOOL INT REAL CHAR // Type
%token ID 
%token CLASS
%token IF ELSE FOR WHILE DO SWITCH CASE
%token FUNCTION RETURN
%token COMMA SEMICOLON COLON
%token PRINTL
%token PLUS, MINUS, MULT, DIV,
ASSIGN, OPERATOR,
LETTER, DIGIT,
LRB, RRB, LSB, RSB, LCB, RCB,
BSLASH, SQUOTE, DQUOTE, QUESTION

%token <str> BOOL_VAL CHAR_VAL STRING
%token <intVal> INT_NUM
%token <reVal> REAL_NUM


%left EQ NEQ GEQ LEQ GT LT
%left '+' '-'
%left '*' '/'
%right UMINUS

// %start /* non terminal */
%type <str> strExpr
%type <intVal> intExpr dims
%type <reVal> reExpr
%type prog block decl arrDecl
%type <reVal> double_coercion
%nonassoc IFX ELSE
%%
prog: FUNCTION ID LRB RRB block;
block: LCB stmts RCB;

decl: VAR ID COLON type SEMICOLON {}
    | VAL ID COLON type SEMICOLON {}
    | VAR ID COLON type ASSIGN literal SEMICOLON {}
    | VAL ID COLON type ASSIGN literal  SEMICOLON {}
    ;

arrDecl: VAR ID COLON type dims SEMICOLON {} 
dims: dims '[' intExpr ']' {$$ = $3;}
    | %empty {}
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
    | REAL { printf("REAL type\n");}
    ;

stmts: stmts stmt {}
    | stmt
    ;
stmt: IF '(' expr ')' stmt %prec IFX 
    | IF '(' expr ')' stmt ELSE stmt 
        // { $$ = newflow(pp,'I', $3, $5, $7); }
    | expr
    | ID ASSIGN expr {}
    | ID '[' expr ']' ASSIGN expr {}
    | PRINTL '(' expr ')' SEMICOLON {}
    | WHILE '(' expr ')' stmt // { $$ = newflow(pp, 'W', $3, $5, NULL); }
    | DO stmt WHILE '(' expr ')' SEMICOLON // { $$ = newflow(pp, 'W', $5, $2, NULL);}
    | block 
    | decl 

    ;

expr: intExpr
    | reExpr
    | strExpr
    | ID SEMICOLON {}
    ;

intExpr: intExpr '+' intExpr { $$ = $1 + $3; }
    | intExpr '-' intExpr { $$ = $1 - $3; }
    | intExpr '*' intExpr { $$ = $1 * $3; }
    | intExpr '/' intExpr {
        if($3 == 0) {
            yyerror("Error: Divisor cannot be zero!");
            YYABORT;
        } else $$ = $1 / $3; 
        }
    | '(' intExpr ')' SEMICOLON {$$ = $2; }
    //| '-' intExpr %prec UMINUS {$$ = - $2; }
    | INT_NUM SEMICOLON { $$ = $1; }
    ;


reExpr: reExpr '+' reExpr { $$ = $1 + $3; }
    | reExpr '-' reExpr { $$ = $1 - $3; }
    | reExpr '*' reExpr { $$ = $1 * $3; }
    | reExpr '/' reExpr {
        if($3 == 0.0) {
            yyerror("Error: Divisor cannot be zero!");
            YYABORT;
        } else $$ = $1 / $3; 
        }
    | '(' reExpr ')' SEMICOLON { $$ = $2; }
    //| '-' reExpr %prec UMINUS { $$ = - $2; }
    //| double_coercion SEMICOLON { $$ = $1; }
    ;
//double_coercion: REAL_NUM { $$ = $1; }
//    | INT_NUM { $$ = (double)$1; }
//    ;

// BOOL, CHAR, STRING
strExpr: BOOL_VAL SEMICOLON { $$ = $1; }
    | STRING SEMICOLON { $$ = $1; }
    ;
return: RETURN expr SEMICOLON
    | RETURN SEMICOLON;
%%

void yyerror(const char *s) { fprintf(stderr, "%s\n", s); }
