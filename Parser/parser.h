extern int yylineno; // from lex
extern int yylex();
extern int yyparse();

void yyerror(const char *s);
/*
struct ast {
    int nodeType;
    struct ast *l;
    struct ast *r;
};
struct numVal {
    int nodeType;
    double number;
};

struct ast *newast(int nodeType, struct ast *l, struct ast *r);
struct ast *newnum(double d);
double eval(struct ast *);
void free(struct ast *);
*/