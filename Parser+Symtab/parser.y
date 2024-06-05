// Symbol table & AST TBD

%{
#include <stdio.h>
#include <stdlib.h>
#include "parser.tab.h"
#include "parser.h"
#include "symTabAlt.c"


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
%type <intVal> intExpr, dims
%type <reVal> reExpr
%type <a> prog block decl arrDecl
%type <reVal> double_coercion

%type <a> matched_stmt

%%
prog: FUNCTION ID block;
block: '{' stmts '}';

decl: VAR ID COLON type SEMICOLON { 
        switch ($4) {
            case BOOL:
                Symbol sym = { $2, $4, true, {.bool_val = NULL}};
                break;
            case INT: 
                Symbol sym = { $2, $4, true, {.int_val = NULL}};
                break;
            case REAL: 
                Symbol sym = { $2, $4, true, {.real_val = NULL}};
                break;
            case CHAR:
                Symbol sym = { $2, $4, true {.char_val = NULL}};
                break;
        }
        insert(&sym);
    }
    | VAL ID COLON type SEMICOLON {
        switch ($4) {
            case BOOL:
                Symbol sym = { $2, $4, false, {.bool_val = NULL}};
                break;
            case INT: 
                Symbol sym = { $2, $4, false, {.int_val = NULL}};
                break;
            case REAL: 
                Symbol sym = { $2, $4, false, {.real_val = NULL}};
                break;
            case CHAR:
                Symbol sym = { $2, $4, false, {.char_val = NULL}};
                break;
        }
        insert(&sym);
    }
    | VAR ID COLON type '=' literal SEMICOLON { 
        switch ($4) {
            case BOOL:
                Symbol sym = { $2, $4, true, {.bool_val = $6}};
                break;
            case INT: 
                Symbol sym = { $2, $4, true, {.int_val = $6}};
                break;
            case REAL: 
                Symbol sym = { $2, $4, true, {.real_val = $6}};
                break;
            case CHAR:
                Symbol sym = { $2, $4, true, {.char_val = $6}};
                break;
        }
        insert(&sym);
    }
    | VAL ID COLON type '=' literal  SEMICOLON {
        switch ($4) {
            case BOOL:
                Symbol sym = { $2, $4, false, {.bool_val = $6}};
                break;
            case INT: 
                Symbol sym = { $2, $4, false, {.int_val = $6}};
                break;
            case REAL: 
                Symbol sym = { $2, $4, false, {.real_val = $6}};
                break;
            case CHAR:
                Symbol sym = { $2, $4, false, {.char_val = $6}};
                break;
        }
        insert(&sym);
    }
    ;

arrDecl: VAR ID COLON type dims SEMICOLON {
        switch($4) {
            case BOOL:
                for (int i = 0; i < $5; i++) {
                    Symbol sym = {$2, $4, true, {.bool_val = NULL}};
                    insert(&sym);
                }               
                break;
            case INT: 
                for (int i = 0; i < $5; i++) {
                    Symbol sym = {$2, $4, true, {.int_val = 0}};
                    insert(&sym);
                }               
                break;
            case REAL: 
                for (int i = 0; i < $5; i++) {
                    Symbol sym = {$2, $4, true, {.real_val = 0.0}};
                    insert(&sym);
                } 
                break;
            case CHAR:
                for (int i = 0; i < $5; i++) {
                    Symbol sym = {$2, $4, true, {.char_val = NULL}};
                    insert(&sym);
                } 
                break;
        }
    }
    |  VAR ID COLON type dims '=' '{' arrAssign '}' SEMICOLON {
        switch($4) {
            case BOOL:
                for (int i = 0; i < $5; i++) {
                    Symbol sym = {$2, $4, true, {.bool_val = NULL}};
                    insert(&sym);
                }               
                break;
            case INT: 
                for (int i = 0; i < $5; i++) {
                    Symbol sym = {$2, $4, true, {.int_val = NULL}};
                    insert(&sym);
                }               
                break;
            case REAL: 
                for (int i = 0; i < $5; i++) {
                    Symbol sym = {$2, $4, true, {.real_val = NULL}};
                    insert(&sym);
                } 
                break;
            case CHAR:
                for (int i = 0; i < $5; i++) {
                    Symbol sym = {$2, $4, true, {.char_val = NULL}};
                    insert(&sym);
                } 
                break;
        }
    }
    ;
dims: dims '[' intExpr ']' { $$ = $3; }
    | %empty
    ;

arrAssign: arrAssign ',' literal
    | literal
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
    | %empty
    ;
stmt: matched_stmt
    | open_stmt
    ;
matched_stmt: IF '(' expr ')' matched_stmt ELSE matched_stmt 
        // { $$ = newflow(pp,'I', $3, $5, $7); }
    | expr
    | ID '=' expr {
        Symbol *mod = lookup($1);
        if (mod != NULL) { // ID found in symbol table
            printf("Found: %s\n", mod->name);
            if (mod->var == true) { // ID is a variable
                if (mod->type == $3.type) { // ID.type = expr.type
                    switch (mod->type) {
                        case BOOL: mod->{.bool_val = $3};
                        case INT: mod->{.char_val = $3};
                        case REAL: mod->{.real_val = $3};
                        case CHAR: mod->{.char_val = $3};
                    }
                } else yyerror("Error: type of %s does not match!", mod->name);
            } else yyerror("Error: VAL: %s is a constant, cannot be modified!", mod->name);
        }
        else yyerror("Error: %s not found!", mod->name);
    }
    | ID '[' intExpr ']' '=' expr {
        Symbol *mod = lookup($1);
        if (mod != NULL) { // ID found in symbol table
            printf("Found: %s\n", mod->name);
            if (mod->type == $6.type) { // ID.type = expr.type
                if ($3 < mod->capacity) {
                    switch (mod->type) {
                        case BOOL: mod->{.bool_val = $6};
                        case INT: mod->{.char_val = $6};
                        case REAL: mod->{.real_val = $6};
                        case CHAR: mod->{.CHAR_val = $6};
                    }
                } else yyerror("Error: Assignment out of array index!", mod->name);

            } else yyerror("Error: type of %s does not match!", mod->name);
        }
        else yyerror("Error: %s not found!", mod->name);
    }
    | PRINTL '(' expr ')' SEMICOLON {
        char buf[1024];
        int n;
        if ($3.type == str)
            n = sprintf(buf, "%s\n", $3);
        else if ($3.type == intVal)
            n = sprintf(buf, "%d\n", $3);
        else if ($3.type == reVal)
            n = sprintf(buf, "%f\n", $3);
        printf("%s", buf);
    }
    | WHILE '(' expr ')' stmt { $$ = newflow(pp, 'W', $3, $5, NULL); }
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
    | '(' intExpr ')' SEMICOLON {$$ = $2}
    | '-' intExpr %prec UMINUS {$$ = - $2; }
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
    | '(' reExpr ')' SEMICOLON { $$ = $2}
    | '-' reExpr %prec UMINUS { $$ = - $2; }
    | double_coercion SEMICOLON { $$ = $1; }
    ;
double_coercion: REAL_NUM { $$ = $1; }
    | INT_NUM { $$ = (double)$1; }
    ;

// BOOL, CHAR, STRING
strExpr: BOOL_VAL SEMICOLON { $$ = $1; }
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