LEX=flex
YACC=bison
CC=gcc
OBJECT=main

$(OBJECT): lex.yy.o parser.tab.o main.o
		$(CC) main.o lex.yy.o parser.tab.o -o $(OBJECT)

lex.yy.o: lex.yy.c parser.tab.h parser.h
		$(CC) -c lex.yy.c

parser.tab.o: parser.tab.c parser.h
		$(CC) -c parser.tab.c

parser.tab.c parser.tab.h: parser.y
		$(YACC) -d parser.y

lex.yy.c: scanner.l
		$(LEX) scanner.l

main.o: main.c
		$(CC) -c main.c

clean:
		@del -f $(OBJECT) *.o lex.yy.c parser.tab.h parser.tab.c main.exe

