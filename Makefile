FUENTE = practica2
PRUEBA = prueba.xml
PRUEBA2 = prueba2.xml
LIB = lfl

all: compile run

compile:
		flex $(FUENTE).l
		bison -o $(FUENTE).tab.c $(FUENTE).y -yd
		gcc -o $(FUENTE) lex.yy.c $(FUENTE).tab.c -$(LIB) -ly

run:
	./$(FUENTE) $(PRUEBA)

run2:
	./$(FUENTE) $(PRUEBA2)

clean:
	rm $(FUENTE) lex.yy.c $(FUENTE).tab.c $(FUENTE).tab.h