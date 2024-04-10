FUENTE = practica2
PRUEBA = prueba.xml
PRUEBA2 = pruebaError.xml
PRUEBA3 = pruebaErrorNoCierre.xml
PRUEBA4 = pruebaErrorExt.txt
PRUEBA5 = pruebaErrorProlog.xml
PRUEBA6 = pruebaNoProlog.xml
PRUEBA7 = pruebaComentarios.xml
PRUEBA8 = pruebaComentariosError.xml
LIB = lfl

all: run1 run2 run3 run4 run5 run6 run7 run8

compile:
		flex $(FUENTE).l
		bison -o $(FUENTE).tab.c $(FUENTE).y -yd
		gcc -o $(FUENTE) lex.yy.c $(FUENTE).tab.c -$(LIB) -ly

run1:
	./$(FUENTE) $(PRUEBA)

run2:
	./$(FUENTE) $(PRUEBA2)

run3:
	./$(FUENTE) $(PRUEBA3)

run4:
	./$(FUENTE) $(PRUEBA4)

run5:
	./$(FUENTE) $(PRUEBA5)

run6:
	./$(FUENTE) $(PRUEBA6)

run7:
	./$(FUENTE) $(PRUEBA7)

run8:
	./$(FUENTE) $(PRUEBA8)

clean:
	rm $(FUENTE) lex.yy.c $(FUENTE).tab.c $(FUENTE).tab.h