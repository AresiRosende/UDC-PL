%{

#include <string.h>
#include <stdio.h>
#include <stdlib.h>

void yyerror (char const *);
extern int yylineno;
extern int yylex();


int numberOfTyres = 0, numberOfBNWFlags = 0;
int is_dnf = 0, is_dsq = 0;
char* circuitName;
char times[4][9];

%}

%union{
	char* string;
}

%token <string> RED_FLAG YELLOW_FLAG BNW_FLAG PIT_STOP WARMING_LAP DNF DSQ
%token <string> OPEN_RACE CLOSE_RACE OPEN_CIRCUIT CLOSE_CIRCUIT OPEN_DORSAL CLOSE_DORSAL OPEN_NAME CLOSE_NAME
%token <string> OPEN_LAPS CLOSE_LAPS OPEN_LAP CLOSE_LAP OPEN_LAPTIME CLOSE_LAPTIME OPEN_TOTALLAPS CLOSE_TOTALLAPS
%token <string> OPEN_LAPNUMBER CLOSE_LAPNUMBER OPEN_INCIDENCIES CLOSE_INCIDENCIES
%token <string> OPEN_LAPINFO CLOSE_LAPINFO OPEN_TYRE CLOSE_TYRE OPEN_TYRELIFE CLOSE_TYRELIFE
%token <string> OPEN_SECTOR1 CLOSE_SECTOR1 OPEN_SECTOR2 CLOSE_SECTOR2 OPEN_SECTOR3 CLOSE_SECTOR3
%token <string> NUM NAME CIRCUIT TYRE TIME

%start S

%%

S
	: XMLPROLOG race
	| race
	| race XMLPROLOG {
		printf("\n\n");
		printf("\e[0;31mError: la etiqueta del prólogo ha de ser el primer elemento del archivo\e[0m\n");
		printf("\n\n");
		exit(0);
		}
race 
	: OPEN_RACE circuit totallaps dorsal nombre lapsBody CLOSE_RACE
	//probar aqui que falten diferentes cosas
;

circuit
	: OPEN_CIRCUIT CIRCUIT CLOSE_CIRCUIT	
	| OPEN_CIRCUIT NAME CLOSE_CIRCUIT
	| OPEN_CIRCUIT CLOSE_CIRCUIT {
		error;
	}
;

totallaps
	: OPEN_TOTALLAPS NUM CLOSE_TOTALLAPS
	| OPEN_TOTALLAPS CLOSE_TOTALLAPS
;

dorsal
	: OPEN_DORSAL NUM CLOSE_DORSAL
;

nombre
	: OPEN_NAME NAME CLOSE_NAME
;

lapsBody
	: OPEN_LAPS laps CLOSE_LAPS
;

laps  
	: lap laps  
	| lap
;

lap
	: OPEN_LAP data CLOSE_LAP
;

data
	: lapNumber incidencies lapinfo
;

lapnumber  
	: OPEN_LAPNUMBER NUM CLOSE_LAPNUMBER
;

incidencies
	: OPEN_INCIDENCIES incidency CLOSE_INCIDENCIES
;

incidency
	: RED_FLAG
	| YELLOW_FLAG
	| BNW_FLAG
	| PIT_STOP
	| WARMING_LAP
	| DNF
	| DSQ
;

lapinfo
	: OPEN_LAPINFO info CLOSE_LAPINFO
;

info
	: tyre tyrelife sector1 sector2 sector3 laptime
;

tyre
	: OPEN_TYRE TYRE CLOSE_TYRE
;

tyrelife
	: OPEN_TYRELIFE NUM CLOSE_TYRELIFE
;

sector1
	: OPEN_SECTOR1 TIME CLOSE_SECTOR1
;

sector2
	: OPEN_SECTOR2 TIME CLOSE_SECTOR2
;

sector3
	: OPEN_SECTOR3 TIME CLOSE_SECTOR3
;

laptime
	: OPEN_LAPTIME TIME CLOSE_LAPTIME
;

%%

int main(int argc, char *argv[]) {
	extern FILE *yyin;



	char *ext = strrchr(argv[1], '.');
	if (strcmp(ext, ".xml") != 0) {
		printf("\n\n\e[0;33mNo es un archivo XML\e[0m\n\n\n");
		exit(0);
	}

	yyin = fopen(argv[1], "r");
	if (yyin == NULL) {
		printf("\n\e[0;31mError: no se pudo abrir el archivo\e[0m\n\n");
	} else {
		yyparse();
		fclose(yyin);
	}
	return 0;
}