%{

#include <string.h>
#include <stdio.h>
#include <stdlib.h>

void yyerror (char const *);
extern int yylineno;
extern int yylex();

int usedTyres = 1, pitStop = 0, currentLap = 1, invalidTime = 0, currentTyreLife = 0;
int totallaps, driverNumber;
int no_time = 0;
int compound1 = 0, compound2 = 0, compound3 = 0;
char notCompleted[10] = "";
char circuitName[80];
char currentS1[20], currentS2[20], currentS3[20], currentLapTime[20];
char currentTyre[2];
char driverName[80];
char stringAux[256];
char temp[64];
char times[4][20];
char tyres[4][10];
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
					printf("\e[0;31mError: There cannot be more than 3 different compounds for a race\e[0m\n");
					exit(0);
				}	
	}				
}

int calc_complete_time() {
	char aux[6];
	int min1, min2, min3, mint;
	int s1, s2, s3, st;
	int ms1, ms2, ms3, mst;
	int pluss;
	char compare[20];

	sprintf(aux, "%c%c", currentS1[0], currentS1[1]);
	min1 = atoi(aux);
	sprintf(aux, "%c%c", currentS2[0], currentS2[1]);
	min2 = atoi(aux);
	sprintf(aux, "%c%c", currentS3[0], currentS3[1]);
	min3 = atoi(aux);

	sprintf(aux, "%c%c", currentS1[3], currentS1[4]);
	s1 = atoi(aux);
	sprintf(aux, "%c%c", currentS2[3], currentS2[4]);
	s2 = atoi(aux);
	sprintf(aux, "%c%c", currentS3[3], currentS3[4]);
	s3 = atoi(aux);

	sprintf(aux, "%c%c%c", currentS1[6], currentS1[7], currentS1[8]);
	ms1 = atoi(aux);
	sprintf(aux, "%c%c%c", currentS2[6], currentS2[7], currentS2[8]);
	ms2 = atoi(aux);
	sprintf(aux, "%c%c%c", currentS3[6], currentS3[7], currentS3[8]);
	ms3 = atoi(aux);


	mst = ms1 + ms2 + ms3;
	pluss = mst / 1000;
	mst = mst % 1000;

	st = s1 + s2 + s3 + pluss;
	pluss = st / 60;
	st = st % 60;

	mint = min1 + min2 + min3 + pluss;

	sprintf(compare, "%02d:%02d.%03d", mint, st, mst);

	return strcmp(compare, currentLapTime);

}


void yywrap() {

	if (totallaps != --currentLap && !strcmp(notCompleted,"")) {
		printf("\e[0;31mError: Lap number is lower than total laps in this circuit. Expected: %d, found: %d\e[0m\n", totallaps, currentLap);
		exit(0);
	}

	printf("-----------\n");
	printf(" Circuit: \e[0;32m%s\e[0m\n", circuitName);
	printf(" Laps: \e[0;32m%d\e[0m\n", totallaps);
	if (strcmp(notCompleted, ""))
		printf(" Completed laps: \e[0;32m%d\e[0m (\e[0;32m%s\e[0m at lap \e[0;32m%d\e[0m)\n", (currentLap-1), notCompleted, currentLap);
	printf(" Driver: \e[0;32m%s\e[0m| \e[0;32m%d\e[0m\n\n",driverName, driverNumber);
	if (!strcmp(times[0], ""))
		printf("\e[0;33mNo time found for any sector 1\e[0m\n");
	else
		printf("Fastest sector 1 : \e[0;32m%s\e[0m at lap \e[0;32m%02d\e[0m with \e[0;32m%s\e[0m tyres on \e[0;32m%02d\e[0m laps\n", times[0], laps[0], tyres[0], tyrelife[0]);
	if (!strcmp(times[1], ""))
		printf("\e[0;33mNo time found for any sector 2\e[0m\n");
	else
		printf("Fastest sector 2 : \e[0;32m%s\e[0m at lap \e[0;32m%02d\e[0m with \e[0;32m%s\e[0m tyres on \e[0;32m%02d\e[0m laps\n", times[1], laps[1], tyres[1], tyrelife[1]);
	if (!strcmp(times[2], ""))
		printf("\e[0;33mNo time found for any sector 3\e[0m\n");
	else
		printf("Fastest sector 3 : \e[0;32m%s\e[0m at lap \e[0;32m%02d\e[0m with \e[0;32m%s\e[0m tyres on \e[0;32m%02d\e[0m laps\n", times[2], laps[2], tyres[2], tyrelife[2]);
	if (!strcmp(times[3], ""))
		printf("\e[0;33mNo time found for any lap\e[0m\n");
	else
		printf("Fastest lap      : \e[0;32m%s\e[0m at lap \e[0;32m%02d\e[0m with \e[0;32m%s\e[0m tyres on \e[0;32m%02d\e[0m laps\n", times[3], laps[3], tyres[3], tyrelife[3]);
	exit(0);
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
		printf("\e[0;31mError: xml prolog tag has to be the first element of the file\e[0m\n");
		exit(0);
		}
race 
	: OPEN_RACE circuit totallaps dorsal nombre lapsBody CLOSE_RACE
;
circuit
	: OPEN_CIRCUIT multiword CLOSE_CIRCUIT {strcpy(circuitName, stringAux); strcpy(stringAux, ""); strcpy(temp, "");}
	| OPEN_CIRCUIT CLOSE_CIRCUIT {
		printf("\e[0;31mError: Circuit name not declared (line %d)\e[0m\n", yylineno);
		exit(0);	
		}
;

totallaps
	: OPEN_TOTALLAPS NUM CLOSE_TOTALLAPS {totallaps = atoi($2);}
	| OPEN_TOTALLAPS CLOSE_TOTALLAPS {
		printf("\e[0;31mError: Number of laps on this circuit not declared (line %d)\e[0m\n", yylineno);
		exit(0);	
		}
;

dorsal
	: OPEN_DORSAL NUM CLOSE_DORSAL {driverNumber = atoi($2);}
	| OPEN_DORSAL CLOSE_DORSAL {
		printf("\e[0;31mError: Driver's number not declared (line %d)\e[0m\n", yylineno);
 		exit(0);	
		}
;

nombre
	: OPEN_NAME multiword CLOSE_NAME {strcpy(driverName, stringAux); strcpy(stringAux, ""); strcpy(temp, "");}
	| OPEN_NAME CLOSE_NAME {
		printf("\e[0;31mError: Driver's name not declared (line %d)\e[0m\n", yylineno);
		exit(0);	
		}
;

lapsBody
	: OPEN_LAPS laps CLOSE_LAPS
	| OPEN_LAPS CLOSE_LAPS {
		printf("\e[0;31mError: No register found for any lap (line %d)\e[0m\n", yylineno);
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
		printf("\e[0;31mError: No register found for lap %d (line %d)\e[0m\n", currentLap,yylineno);
		exit(0);	
		}
;

data
	: lapNumber incidencies lapinfo
;

lapNumber  
	: OPEN_LAPNUMBER NUM CLOSE_LAPNUMBER {
		if (atoi($2) > totallaps) {
			printf("\e[0;31mError: Lap number is higher than total laps in this circuit. Expected: %d, found: %d (line %d)\e[0m\n", totallaps, currentLap ,yylineno);
			exit(0);	
			}
		else if (atoi($2) != currentLap){
				printf("\e[0;31mError: Expected lap: %d and found lap: %s (line %d)\e[0m\n", currentLap, $2 ,yylineno);
				exit(0);	
				}
		}
	| OPEN_LAPNUMBER CLOSE_LAPNUMBER {
		printf("\e[0;31mError: Lap number not declared (line %d)\e[0m\n",yylineno);
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
	| DNF 			{strcpy(notCompleted,"DNF");}
	| DSQ 			{strcpy(notCompleted,"DSQ");}
	| LAPPED 		{strcpy(notCompleted,"LAPPED");}
	| /*empty*/ 	{invalidTime = 0; pitStop = 0;}
;

lapinfo
	: OPEN_LAPINFO info CLOSE_LAPINFO
	| OPEN_LAPINFO CLOSE_LAPINFO {
		printf("\e[0;31mError: No info found about lap %d (line %d)\e[0m\n", currentLap,yylineno);
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
		printf("\e[0;31mError: No info found about tyre compound on lap %d (line %d)\e[0m\n", currentLap,yylineno);
		exit(0);	
	}
;

tyrelife
	: OPEN_TYRELIFE NUM CLOSE_TYRELIFE {
		if (pitStop == 1) {
			currentTyreLife = 0;
		} else if (atoi($2) != currentTyreLife){
				printf("\e[0;31mError: Tyre change without pitstop. Expected tyre life: %d and found: %s (line %d)\e[0m\n", currentTyreLife, $2 ,yylineno);
				exit(0);	
		}
	}
	| OPEN_TYRELIFE CLOSE_TYRELIFE {
		printf("\e[0;31mError: No info found about tyre life on lap %d (line %d)\e[0m\n", currentLap,yylineno);
		exit(0);	
	}
;

sector1
	: OPEN_SECTOR1 TIME CLOSE_SECTOR1 {
		strcpy(currentS1, $2);
		if (!invalidTime && (!strcmp(times[0], "") || (strcmp(times[0], $2)) > 0)) {
			strcpy(times[0], $2);
			strcpy(tyres[0], currentTyre);
			laps[0] = currentLap;
			tyrelife[0] = currentTyreLife;
		}
	}
	| OPEN_SECTOR1 NOTIME CLOSE_SECTOR1 {no_time = 1;}
	| OPEN_SECTOR1 CLOSE_SECTOR1 {
		printf("\e[0;31mError: No info found about sector 1 time on lap %d (line %d)\e[0m\n", currentLap,yylineno);
		exit(0);	
	}
;

sector2
	: OPEN_SECTOR2 TIME CLOSE_SECTOR2 {
		strcpy(currentS2, $2);
		if (!invalidTime && (!strcmp(times[1], "") || (strcmp(times[1], $2)) > 0)) {
			strcpy(times[1], $2);
			strcpy(tyres[1], currentTyre);
			laps[1] = currentLap;
			tyrelife[1] = currentTyreLife;
		}
	}
	| OPEN_SECTOR2 NOTIME CLOSE_SECTOR2 {no_time = 1;}
	| OPEN_SECTOR2 CLOSE_SECTOR2 {
		printf("\e[0;31mError: No info found about sector 2 time on lap %d (line %d)\e[0m\n", currentLap,yylineno);
		exit(0);	
	}
;

sector3
	: OPEN_SECTOR3 TIME CLOSE_SECTOR3 {
		strcpy(currentS3, $2);
		if (!invalidTime && (!strcmp(times[2], "") || (strcmp(times[2], $2)) > 0)) {
			strcpy(times[2], $2);
			strcpy(tyres[2], currentTyre);
			laps[2] = currentLap;
			tyrelife[2] = currentTyreLife;
		}
	}
	| OPEN_SECTOR3 NOTIME CLOSE_SECTOR3 {no_time = 1;}
	| OPEN_SECTOR3 CLOSE_SECTOR3 {
		printf("\e[0;31mError: No info found about sector 3 time on lap %d (line %d)\e[0m\n", currentLap,yylineno);
		exit(0);	
	}
;

laptime
	: OPEN_LAPTIME TIME CLOSE_LAPTIME  {
		if (!strcmp(notCompleted, ""))
			yywrap;;
		strcpy(currentLapTime, $2);
		if (!invalidTime && (!strcmp(times[3], "") || (strcmp(times[3], $2)) > 0)) {
			strcpy(times[3], $2);
			strcpy(tyres[3], currentTyre);
			laps[3] = currentLap;
			tyrelife[3] = currentTyreLife;
		}
		if (!no_time)
			if (calc_complete_time()) {
				printf("\e[0;31mError: The sum of the sectors doesnt amount to the full lap time on lap %d (line %d)\e[0m\n", currentLap,yylineno);
				exit(0);	
			}
		no_time = 0;
		currentLap++;
		currentTyreLife++;
	}
	| OPEN_LAPTIME NOTIME CLOSE_LAPTIME {no_time = 0;currentLap++;currentTyreLife++;}
	| OPEN_LAPTIME CLOSE_LAPTIME {
		printf("\e[0;31mError: No info found about lap time on lap %d (line %d)\e[0m\n", currentLap,yylineno);
		exit(0);	
	}
;

multiword
	: TEXT multiword {
		strcpy(temp, $1);
		strcat(temp, " ");
		strcat(temp, stringAux);
		strcpy(stringAux, temp);
	}
	| TYRE multiword { 		/* very specific, but possible */
		strcpy(temp, $1);
		strcat(temp, " ");
		strcat(temp, stringAux);
		strcpy(stringAux, temp);
	}
	| TEXT {
		strcpy(temp, $1);
		strcat(temp, " ");
		strcat(temp, stringAux);
		strcpy(stringAux, temp);
	}
	| TYRE { 				/* very specific, but possible */
		strcpy(temp, $1);
		strcat(temp, " ");
		strcat(temp, stringAux);
		strcpy(stringAux, temp);
	}		
;
%%

int main(int argc, char *argv[]) {
	extern FILE *yyin;

	char *ext = strrchr(argv[1], '.');
	if (strcmp(ext, ".xml") != 0) {
		printf("\n\e[0;33mNot a XML file\e[0m\n");
		exit(0);
	}

	yyin = fopen(argv[1], "r");
	if (yyin == NULL) {
		printf("\n\e[0;31mError: could not open file\e[0m\n");
	} else {
		yyparse();
		fclose(yyin);
	}
	return 0;
}