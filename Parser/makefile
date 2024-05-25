LEX=flex
YACC=bison
CC=gcc
OBJECT=main

$(OBJECT): lex.yy.o yacc.tab.o main.o
		$(CC) main.o lex.yy.o yacc.tab.o -o $(OBJECT)

lex.yy.o: lex.yy.c yacc.tab.h parser.h
		$(CC) -c lex.yy.c

yacc.tab.o: yacc.tab.c parser.h
		$(CC) -c yacc.tab.c

yacc.tab.c yacc.tab.h: parser.y
		$(YACC) -d parser.y

lex.yy.c: scanner.l
		$(LEX) scanner.l

main.o: main.c
		$(CC) -c main.c

clean:
		@del -f $(OBJECT) *.o lex.yy.c yacc.tab.h yacc.tab.c main.exe

