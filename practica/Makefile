FUENTE = F1TimeCheck
ALONSO = Suzuka-ALO14.xml
SAINZ = Suzuka-SAI55.xml
ERROR = error.xml
LIB = lfl

all: compile alo sai

compile:
		flex $(FUENTE).l
		bison -o $(FUENTE).tab.c $(FUENTE).y -yd --debug
		gcc -o $(FUENTE) lex.yy.c $(FUENTE).tab.c -$(LIB) -ly

alo:
	./$(FUENTE) $(ALONSO)

sai:
	./$(FUENTE) $(SAINZ)

error:
	./$(FUENTE) $(ERROR)

clean:
	rm $(FUENTE) lex.yy.c $(FUENTE).tab.c $(FUENTE).tab.h