/* A Bison parser, made by GNU Bison 3.8.2.  */

/* Bison interface for Yacc-like parsers in C

   Copyright (C) 1984, 1989-1990, 2000-2015, 2018-2021 Free Software Foundation,
   Inc.

   This program is free software: you can redistribute it and/or modify
   it under the terms of the GNU General Public License as published by
   the Free Software Foundation, either version 3 of the License, or
   (at your option) any later version.

   This program is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
   GNU General Public License for more details.

   You should have received a copy of the GNU General Public License
   along with this program.  If not, see <https://www.gnu.org/licenses/>.  */

/* As a special exception, you may create a larger work that contains
   part or all of the Bison parser skeleton and distribute that work
   under terms of your choice, so long as that work isn't itself a
   parser generator using the skeleton or a modified version thereof
   as a parser skeleton.  Alternatively, if you modify or redistribute
   the parser skeleton itself, you may (at your option) remove this
   special exception, which will cause the skeleton and the resulting
   Bison output files to be licensed under the GNU General Public
   License without this special exception.

   This special exception was added by the Free Software Foundation in
   version 2.2 of Bison.  */

/* DO NOT RELY ON FEATURES THAT ARE NOT DOCUMENTED in the manual,
   especially those whose name start with YY_ or yy_.  They are
   private implementation details that can be changed or removed.  */

#ifndef YY_YY_PARSER_TAB_H_INCLUDED
# define YY_YY_PARSER_TAB_H_INCLUDED
/* Debug traces.  */
#ifndef YYDEBUG
# define YYDEBUG 0
#endif
#if YYDEBUG
extern int yydebug;
#endif

/* Token kinds.  */
#ifndef YYTOKENTYPE
# define YYTOKENTYPE
  enum yytokentype
  {
    YYEMPTY = -2,
    YYEOF = 0,                     /* "end of file"  */
    YYerror = 256,                 /* error  */
    YYUNDEF = 257,                 /* "invalid token"  */
    VAR = 258,                     /* VAR  */
    VAL = 259,                     /* VAL  */
    BOOL = 260,                    /* BOOL  */
    INT = 261,                     /* INT  */
    REAL = 262,                    /* REAL  */
    CHAR = 263,                    /* CHAR  */
    ID = 264,                      /* ID  */
    CLASS = 265,                   /* CLASS  */
    IF = 266,                      /* IF  */
    ELSE = 267,                    /* ELSE  */
    FOR = 268,                     /* FOR  */
    WHILE = 269,                   /* WHILE  */
    DO = 270,                      /* DO  */
    SWITCH = 271,                  /* SWITCH  */
    CASE = 272,                    /* CASE  */
    FUNCTION = 273,                /* FUNCTION  */
    RETURN = 274,                  /* RETURN  */
    COMMA = 275,                   /* COMMA  */
    SEMICOLON = 276,               /* SEMICOLON  */
    COLON = 277,                   /* COLON  */
    PRINTL = 278,                  /* PRINTL  */
    PLUS = 279,                    /* PLUS  */
    MINUS = 280,                   /* MINUS  */
    MULT = 281,                    /* MULT  */
    DIV = 282,                     /* DIV  */
    ASSIGN = 283,                  /* ASSIGN  */
    OPERATOR = 284,                /* OPERATOR  */
    LETTER = 285,                  /* LETTER  */
    DIGIT = 286,                   /* DIGIT  */
    LRB = 287,                     /* LRB  */
    RRB = 288,                     /* RRB  */
    LSB = 289,                     /* LSB  */
    RSB = 290,                     /* RSB  */
    LCB = 291,                     /* LCB  */
    RCB = 292,                     /* RCB  */
    BSLASH = 293,                  /* BSLASH  */
    SQUOTE = 294,                  /* SQUOTE  */
    DQUOTE = 295,                  /* DQUOTE  */
    QUESTION = 296,                /* QUESTION  */
    BOOL_VAL = 297,                /* BOOL_VAL  */
    CHAR_VAL = 298,                /* CHAR_VAL  */
    STRING = 299,                  /* STRING  */
    INT_NUM = 300,                 /* INT_NUM  */
    REAL_NUM = 301,                /* REAL_NUM  */
    EQ = 302,                      /* EQ  */
    NEQ = 303,                     /* NEQ  */
    GEQ = 304,                     /* GEQ  */
    LEQ = 305,                     /* LEQ  */
    GT = 306,                      /* GT  */
    LT = 307,                      /* LT  */
    UMINUS = 308,                  /* UMINUS  */
    IFX = 309                      /* IFX  */
  };
  typedef enum yytokentype yytoken_kind_t;
#endif

/* Value type.  */
#if ! defined YYSTYPE && ! defined YYSTYPE_IS_DECLARED
union YYSTYPE
{
#line 12 "parser.y"

    int intVal;
    double reVal;
    char *str;

#line 124 "parser.tab.h"

};
typedef union YYSTYPE YYSTYPE;
# define YYSTYPE_IS_TRIVIAL 1
# define YYSTYPE_IS_DECLARED 1
#endif


extern YYSTYPE yylval;


int yyparse (void);


#endif /* !YY_YY_PARSER_TAB_H_INCLUDED  */
