FUENTE = practica1
PRUEBA1 = prueba1.txt
PRUEBA2 = prueba2.txt
PRUEBA3 = prueba3.txt
LIB = lfl

all: compile

compile:
	flex $(FUENTE).l
	gcc -o $(FUENTE) lex.yy.c -$(LIB)

clean:
	rm $(FUENTE) lex.yy.c 

run1:
	./$(FUENTE) < $(PRUEBA1)
run2:
	./$(FUENTE) < $(PRUEBA2)
run3:
	./$(FUENTE) < $(PRUEBA3)