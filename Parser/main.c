#include <stdio.h>
#include "parser.tab.h"

extern int yyparse();
extern FILE *yyin;
extern FILE *yyout;

int main(int argc, char *argv[])
{
    if(argc > 1)
        yyin = fopen(argv[1], "r");
    yyout = fopen("output.txt", "w");
    if(!yyout) {
        fprintf(stderr, "Error: output could not be opened!");
        return 1;
    }
    yyparse();
    fclose(yyout);
    return 0;
}