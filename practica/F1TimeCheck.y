%{

#include <string.h>
#include <stdio.h>
#include <stdlib.h>

void yyerror (char const *);
extern int yylineno;
extern int yylex();

int usedTyres = 1, pitStop = 0, currentLap = 1, invalidTime = 0, currentTyreLife = 0, notCompleted = 0;
int totallaps, driverNumber;
int no_time = 0;
int compound1 = 0, compound2 = 0, compound3 = 0;
char circuitName[80];
char currentTyre[2];
char driverName[80];
char stringAux[80];
char times[4][9];
char tyres[4][2];
int laps[4];
int tyrelife[4];


void check_compounds() {
	if (currentTyre != "FW" && currentTyre != "IM"){
		int tyre = currentTyre[(strlen(currentTyre)-1)];
		if (compound1 == 0)
			compound1 = tyre;
		else if (compound2 == 0)
				compound2 = tyre;
			else if (compound3 == 0)
					compound3 = tyre;
				else if (compound1 != tyre && compound2 != tyre && compound3 != tyre) {
					printf("\n\n");
					printf("\e[0;31mError: There cannot be more than 3 different compounds for a race\e[0m\n");
					printf("\n\n");
					exit(0);
				}	
	}				
}

int calc_complete_time() {
	return 0;
}


void yywrap() {
	printf("\e[0;32mCircuit: %s\n", circuitName);
	printf("Laps: %d\n", totallaps);
	if (notCompleted)
		printf("Completed laps: %d\n", currentLap);
	printf("Fastest sector 1 : %s in lap %d with %s tyres on %d laps\n", times[0], laps[0], tyres[0], tyrelife[0]);
	printf("Fastest sector 2 : %s in lap %d with %s tyres on %d laps\n", times[1], laps[1], tyres[1], tyrelife[1]);
	printf("Fastest sector 3 : %s in lap %d with %s tyres on %d laps\n", times[2], laps[2], tyres[2], tyrelife[2]);
	printf("Fastest lap : %s in lap %d with %s tyres on %d laps\n", times[3], laps[3], tyres[3], tyrelife[3]);
	printf("\n\e[0m");
}


%}

%union{
	char* string;
}

%token <string> XMLPROLOG
%token <string> RED_FLAG YELLOW_FLAG BNW_FLAG PIT_STOP LAPPED DNF DSQ
%token <string> OPEN_RACE CLOSE_RACE OPEN_CIRCUIT CLOSE_CIRCUIT OPEN_DORSAL CLOSE_DORSAL OPEN_NAME CLOSE_NAME
%token <string> OPEN_LAPS CLOSE_LAPS OPEN_LAP CLOSE_LAP OPEN_LAPTIME CLOSE_LAPTIME OPEN_TOTALLAPS CLOSE_TOTALLAPS
%token <string> OPEN_LAPNUMBER CLOSE_LAPNUMBER OPEN_INCIDENCIES CLOSE_INCIDENCIES
%token <string> OPEN_LAPINFO CLOSE_LAPINFO OPEN_TYRE CLOSE_TYRE OPEN_TYRELIFE CLOSE_TYRELIFE
%token <string> OPEN_SECTOR1 CLOSE_SECTOR1 OPEN_SECTOR2 CLOSE_SECTOR2 OPEN_SECTOR3 CLOSE_SECTOR3
%token <string> NUM TEXT TYRE TIME NOTIME TRACKLIMITS

%start S

%%

S
	: XMLPROLOG race
	| race
	| race XMLPROLOG {
		printf("\n\n");
		printf("\e[0;31mError: xml prolog tag has to be the first element of the file\e[0m\n");
		printf("\n\n");
		exit(0);
		}
race 
	: OPEN_RACE circuit totallaps dorsal nombre lapsBody CLOSE_RACE
;
circuit
	: OPEN_CIRCUIT multiword CLOSE_CIRCUIT {strcpy(circuitName, stringAux); strcpy(stringAux, "");}
	| OPEN_CIRCUIT CLOSE_CIRCUIT {
		printf("\n\n");
		printf("\e[0;31mError: Circuit name not declared (line %d)\e[0m\n", yylineno);
		printf("\n\n");
		exit(0);	
		}
;

totallaps
	: OPEN_TOTALLAPS NUM CLOSE_TOTALLAPS {totallaps = atoi($2);}
	| OPEN_TOTALLAPS CLOSE_TOTALLAPS {
		printf("\n\n");
		printf("\e[0;31mError: Number of laps on this circuit not declared (line %d)\e[0m\n", yylineno);
		printf("\n\n");
		exit(0);	
		}
;

dorsal
	: OPEN_DORSAL NUM CLOSE_DORSAL {driverNumber = atoi($2);}
	| OPEN_DORSAL CLOSE_DORSAL {
		printf("\n\n");
		printf("\e[0;31mError: Driver's number not declared (line %d)\e[0m\n", yylineno);
		printf("\n\n");
		exit(0);	
		}
;

nombre
	: OPEN_NAME multiword CLOSE_NAME {strcpy(driverName, stringAux); strcpy(stringAux, "");}
	| OPEN_NAME CLOSE_NAME {
		printf("\n\n");
		printf("\e[0;31mError: Driver's name not declared (line %d)\e[0m\n", yylineno);
		printf("\n\n");
		exit(0);	
		}
;

lapsBody
	: OPEN_LAPS laps CLOSE_LAPS
	| OPEN_LAPS CLOSE_LAPS {
		printf("\n\n");
		printf("\e[0;31mError: No register found for any lap (line %d)\e[0m\n", yylineno);
		printf("\n\n");
		exit(0);	
		}
;

laps  
	: lap laps
	| lap 
;

lap
	: OPEN_LAP data CLOSE_LAP
	| OPEN_LAP CLOSE_LAP {
		printf("\n\n");
		printf("\e[0;31mError: No register found for lap %d (line %d)\e[0m\n", currentLap,yylineno);
		printf("\n\n");
		exit(0);	
		}
;

data
	: lapNumber incidencies lapinfo
;

lapNumber  
	: OPEN_LAPNUMBER NUM CLOSE_LAPNUMBER {
		if (atoi($2) > totallaps) {
			printf("\n\n");
			printf("\e[0;31mError: Lap number is higher than total laps in this circuit. Lap %d/%d (line %d)\e[0m\n", currentLap, totallaps,yylineno);
			printf("\n\n");
			exit(0);	
			}
		else if (atoi($2) != currentLap++){
				printf("\n\n");
				printf("\e[0;31mError: Expected lap: %d and found lap: %s (line %d)\e[0m\n", currentLap, $2 ,yylineno);
				printf("\n\n");
				exit(0);	
				}
			else {
				currentLap = currentLap++;
				}
		}
	| OPEN_LAPNUMBER CLOSE_LAPNUMBER {
		printf("\n\n");
		printf("\e[0;31mError: Lap number not declared (line %d)\e[0m\n",yylineno);
		printf("\n\n");
		exit(0);	
		}
;

incidencies
	: OPEN_INCIDENCIES incidency CLOSE_INCIDENCIES
;

incidency
	: RED_FLAG 		{invalidTime = 0; pitStop = 0;}
	| YELLOW_FLAG  	{invalidTime = 0; pitStop = 0;}
	| TRACKLIMITS  	{invalidTime = 1; pitStop = 0;}
	| PIT_STOP 		{invalidTime = 0; pitStop = 1;}
	| DNF 			{notCompleted = 1; yywrap();}
	| DSQ 			{notCompleted = 1; yywrap();}
	| LAPPED 		{notCompleted = 1; yywrap();}
	| /*empty*/ 	{invalidTime = 0; pitStop = 0;}
;

lapinfo
	: OPEN_LAPINFO info CLOSE_LAPINFO
	| OPEN_LAPINFO CLOSE_LAPINFO {
		printf("\n\n");
		printf("\e[0;31mError: No info found about lap %d (line %d)\e[0m\n", currentLap,yylineno);
		printf("\n\n");
		exit(0);	
	}
;

info
	: tyre tyrelife sector1 sector2 sector3 laptime
;

tyre
	: OPEN_TYRE TYRE CLOSE_TYRE {
		if (currentLap == 1 || pitStop == 1){
			strcpy(currentTyre, $2);
			check_compounds();}
		}
	| OPEN_TYRE CLOSE_TYRE {
		printf("\n\n");
		printf("\e[0;31mError: No info found about tyre compound on lap %d (line %d)\e[0m\n", currentLap,yylineno);
		printf("\n\n");
		exit(0);	
	}
;

tyrelife
	: OPEN_TYRELIFE NUM CLOSE_TYRELIFE {
		if (pitStop == 1) {
			currentTyreLife = 0;
		} else if (atoi($2) != currentTyreLife){
				printf("\n\n");
				printf("\e[0;31mError: Expected tyre life: %d and found: %s (line %d)\e[0m\n", currentTyreLife, $2 ,yylineno);
				printf("\n\n");
				exit(0);	
		}
		currentTyreLife++;
	}
	| OPEN_TYRELIFE CLOSE_TYRELIFE {
		printf("\n\n");
		printf("\e[0;31mError: No info found about tyre life on lap %d (line %d)\e[0m\n", currentLap,yylineno);
		printf("\n\n");
		exit(0);	
	}
;

sector1
	: OPEN_SECTOR1 TIME CLOSE_SECTOR1 {
		if (currentLap == 1 || ((strcmp(times[0], $2)) < 0 && (invalidTime != 1)) ) {
			strcpy(times[0], $2);
			strcpy(tyres[0], currentTyre);
			laps[0] = currentLap;
			tyrelife[0] = currentTyreLife;
		}
	}
	| OPEN_SECTOR1 NOTIME CLOSE_SECTOR1 {no_time = 1;}
	| OPEN_SECTOR1 CLOSE_SECTOR1 {
		printf("\n\n");
		printf("\e[0;31mError: No info found about sector 1 time on lap %d (line %d)\e[0m\n", currentLap,yylineno);
		printf("\n\n");
		exit(0);	
	}
;

sector2
	: OPEN_SECTOR2 TIME CLOSE_SECTOR2 {
		if (currentLap == 1 || ((strcmp(times[1], $2)) < 0 && (invalidTime != 1)) ) {
			strcpy(times[1], $2);
			strcpy(tyres[1], currentTyre);
			laps[1] = currentLap;
			tyrelife[1] = currentTyreLife;
		}
	}
	| OPEN_SECTOR2 NOTIME CLOSE_SECTOR2 {no_time = 1;}
	| OPEN_SECTOR2 CLOSE_SECTOR2 {
		printf("\n\n");
		printf("\e[0;31mError: No info found about sector 2 time on lap %d (line %d)\e[0m\n", currentLap,yylineno);
		printf("\n\n");
		exit(0);	
	}
;

sector3
	: OPEN_SECTOR3 TIME CLOSE_SECTOR3 {
		if (currentLap == 1 || ((strcmp(times[2], $2)) < 0 && (invalidTime != 1))) {
			strcpy(times[2], $2);
			strcpy(tyres[2], currentTyre);
			laps[2] = currentLap;
			tyrelife[2] = currentTyreLife;
		}
	}
	| OPEN_SECTOR3 NOTIME CLOSE_SECTOR3 {no_time = 1;}
	| OPEN_SECTOR3 CLOSE_SECTOR3 {
		printf("\n\n");
		printf("\e[0;31mError: No info found about sector 3 time on lap %d (line %d)\e[0m\n", currentLap,yylineno);
		printf("\n\n");
		exit(0);	
	}
;

laptime
	: OPEN_LAPTIME TIME CLOSE_LAPTIME  {
		if (currentLap == 1 || ((strcmp(times[3], $2)) < 0 && (invalidTime != 1)) ) {
			strcpy(times[3], $2);
			strcpy(tyres[3], currentTyre);
			laps[3] = currentLap;
			tyrelife[3] = currentTyreLife;
		}
		if (!no_time)
			if (calc_complete_time() == 1) {
				printf("\n\n");
				printf("\e[0;31mError: The sum of the sectors doesnt amount to the full lap time on lap %d (line %d)\e[0m\n", currentLap,yylineno);
				printf("\n\n");
				exit(0);	
			}
		no_time = 0;
	}
	| OPEN_SECTOR1 NOTIME CLOSE_SECTOR1 {no_time = 0;}
	| OPEN_LAPTIME CLOSE_LAPTIME {
		printf("\n\n");
		printf("\e[0;31mError: No info found about lap time on lap %d (line %d)\e[0m\n", currentLap,yylineno);
		printf("\n\n");
		exit(0);	
	}
;

multiword
	: TEXT multiword {strcat(stringAux, $1);}
	| TEXT {strcat(stringAux, $1);}
;
%%

int main(int argc, char *argv[]) {
	extern FILE *yyin;

#ifdef YYDEBUG
  yydebug = 1;
#endif


	char *ext = strrchr(argv[1], '.');
	if (strcmp(ext, ".xml") != 0) {
		printf("\n\n\e[0;33mNot a XML file\e[0m\n\n\n");
		exit(0);
	}

	yyin = fopen(argv[1], "r");
	if (yyin == NULL) {
		printf("\n\e[0;31mError: could not open file\e[0m\n\n");
	} else {
		yyparse();
		fclose(yyin);
	}
	return 0;
}