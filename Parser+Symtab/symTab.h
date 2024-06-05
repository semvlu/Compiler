#include <stdio.h>
#include <stdlib.h>
#include <stdbool.h>
#include <string.h>

#define SIZE 256
void yyerror(const char *s);

typedef enum {
    INT,
    REAL,
    CHAR,
    BOOL
} Type;

typedef struct symbol_t {
    char *name;
    bool var;
    Type type;
    int capacity;
    union {
        int int_val;
        double real_val;
        char *char_val;
        int bool_val; // 0 for false, 1 for true
    } value;
    struct symbol_t *next;
} Symbol;

Symbol *hash_table[SIZE];

void symTabInit() { for (int i = 0; i < SIZE; i++) hash_table[i] = NULL; }

unsigned int hash(char *str)
{
    unsigned int hash = 5381;
    int c;

    while ((c = *str++))
        hash = ((hash << 5) + hash) + c; /* hash * 33 + c */

    return hash % SIZE;
}

void insert(Symbol *symbol)
{
    unsigned int index = hash(symbol->name);

    Symbol *new_node = (Symbol *)malloc(sizeof(Symbol));
    *new_node = *symbol;
    new_node->next = hash_table[index];
    hash_table[index] = new_node;
}

Symbol* lookup(char *name)
{
    unsigned int index = hash(name);

    Symbol *current = hash_table[index];

    while (current != NULL) {
        if (strcmp(current->name, name) == 0)
            return current;
        current = current->next;
    }

    return NULL;
}

void print_symbol_table()
{
    for (int i = 0; i < SIZE; i++) {
        Symbol *current = hash_table[i];
        while (current != NULL) {
            printf("%s: ", current->name);
            switch (current->type) {
                case INT:
                    printf("int = %d\n", current->value.int_val);
                    break;
                case REAL:
                    printf("real = %f\n", current->value.real_val);
                    break;
                case CHAR:
                    printf("char = '%s'\n", current->value.char_val);
                    break;
                case BOOL:
                    printf("bool = %s\n", current->value.bool_val ? "true" : "false");
                    break;
            }
            current = current->next;
        }
    }
}
