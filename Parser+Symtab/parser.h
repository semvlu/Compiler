extern int yylineno; // from lex
extern int yylex();
extern int yyparse();

void yyerror(const char *s);
