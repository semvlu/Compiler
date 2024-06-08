#include <stdio.h>
#include "parser.tab.h"

extern int yyparse();

int main()
{
    yyparse();
    return 0;
}