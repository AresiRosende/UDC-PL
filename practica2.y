%{

#include <string.h>
#include <stdio.h>
#include <stdlib.h>

void yyerror (char const *);
extern int yylineno;
extern int yylex();




%}

%union{
	char* string;
}

%token <string> XMLPROLOG TAG_START_OPEN TAG_START_CLOSE TAG_END TAGNAME TAGCONTENT COMMENT

%start S

%%

S
	: XMLPROLOG body
	| body XMLPROLOG {
		printf("Error: la etiqueta del prólogo ha de ser el primer elemento del archivo\e[0m");
		exit(0);
		}			
;

body
	: COMMENT body
	| tags body
	| COMMENT
	| tags
;

tags	
	: TAG_START_OPEN TAGNAME TAG_END content body TAG_START_CLOSE TAGNAME TAG_END
		{
		if(strcmp($2, $7)!=0)
			{
				printf("\n\n");
				printf("\e[0;31mError sintáctico en la línea %d\e[0m\n", yylineno);
				printf("\e[0;31mLa etiqueta de cierre no se corresponde con la de apertura\e[0m\n");
				printf("\e[0;31mSe esperaba \"%s\" y se encontró \"%s\"\e[0m\n",$2,$7);
				printf("\n\n");
				exit(0);
			}
		}
	| TAG_START_OPEN TAGNAME TAG_END body TAG_START_CLOSE TAGNAME TAG_END
		{
		if(strcmp($2, $6)!=0)
			{
				printf("\n\n");
				printf("\e[0;31mError sintáctico en la línea %d\e[0m\n", yylineno);
				printf("\e[0;31mLa etiqueta de cierre no se corresponde con la de apertura\e[0m\n");
				printf("\e[0;31mSe esperaba \"%s\" y se encontró \"%s\"\e[0m\n",$2,$6);
				printf("\n\n");
				exit(0);
			}
		}
	| TAG_START_OPEN TAGNAME TAG_END content TAG_START_CLOSE TAGNAME TAG_END
		{
		if(strcmp($2, $6)!=0)
			{
				printf("\n\n");
				printf("\e[0;31mError sintáctico en la línea %d\e[0m\n", yylineno);
				printf("\e[0;31mLa etiqueta de cierre no se corresponde con la de apertura\e[0m\n");
				printf("\e[0;31mSe esperaba \"%s\" y se encontró \"%s\"\e[0m\n",$2,$6);
				printf("\n\n");
				exit(0);
			}
		}
	| TAG_START_OPEN TAGNAME TAG_END TAG_START_CLOSE TAGNAME TAG_END
		{
		if(strcmp($2, $5)!=0)
			{
				printf("\n\n");
				printf("\e[0;31mError sintáctico en la línea %d\e[0m\n", yylineno);
				printf("\e[0;31mLa etiqueta de cierre no se corresponde con la de apertura\e[0m\n");
				printf("\e[0;31mSe esperaba \"%s\" y se encontró \"%s\"\e[0m\n",$2,$5);
				printf("\n\n");
				exit(0);
			}
		}
;

content
	: TAGCONTENT content
	| TAGNAME content
	| TAGNAME
	| TAGCONTENT
;					


%%

int main(int argc, char *argv[]) {
	extern FILE *yyin;

	yyin = fopen(argv[1], "r");
	if (yyin == NULL) {
		printf("Error: no se pudo abrir el archivo\n");
	} else {
		yyparse();
		fclose(yyin);
	}
	return 0;
}