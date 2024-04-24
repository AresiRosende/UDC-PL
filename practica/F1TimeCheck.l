%{
#include <stdlib.h>
#include "practica2.tab.h"

int yyerror();

%}

driverName		([A-Z][A-Za-z]+\s[A-Z][A-Za-z]+)
circuit			[A-Za-z\s\'\,\.]+
tyre			(IM|FW|C[1-5])
time 			[0-9][0-9]\:[0-9][0-9]\.[0-9][0-9][0-9]
num				[0-9]{1,3}
prolog			("<?xml").*("?>")

%%

"\n"							{yylineno++;}
{prolog}						{;}

"RedFlag"						{return RED_FLAG;}
"YellowFlag"					{return YELLOW_FLAG;}
"PitStop"						{return PIT_STOP;}
"DNF"							{return DNF;}
"DSQ"							{return DSQ;}
"WarmingLap"					{return WARMING_LAP;}
"BnWFlag"						{return BNW_FLAG;}
"<race>"						{return OPEN_RACE;}
"</race>"						{return CLOSE_RACE;}
"<circuit>"						{return OPEN_CIRCUIT;}
"</circuit>"					{return CLOSE_CIRCUIT;}
"<totalLaps>"					{return OPEN_TOTALLAPS;}
"</totalLaps>"					{return CLOSE_TOTALLAPS;}
"<driverNum>"					{return OPEN_DORSAL;}
"</driverNum>"					{return CLOSE_DORSAL;}
"<driverName>"					{return OPEN_NAME;}
"</driverName>"					{return CLOSE_NAME;}
"<laps>"						{return OPEN_LAPS;}
"</laps>"						{return CLOSE_LAPS;}
"<lap>"							{return OPEN_LAP;}
"</lap>"						{return CLOSE_LAP;}
"<lapNumber>"					{return OPEN_LAPNUMBER;}
"</lapNumber>					{return CLOSE_LAPNUMBER;}
"<incidencies>"					{return OPEN_INCIDENCIES;}
"</incidencies>"				{return CLOSE_INCIDENCIES;}
"<lapInfo>"						{return OPEN_LAPINFO;}
"</lapInfo>"					{return CLOSE_LAPINFO;}
"<tyre>"						{return OPEN_TYRE;}
"</tyre>"						{return CLOSE_TYRE;}
"<tyreLife>"					{return OPEN_TYRELIFE;}
"</tyreLife>"					{return CLOSE_TYRELIFE;}
"<sector1>"						{return OPEN_SECTOR1;}
"</sector1>"					{return CLOSE_SECTOR1;}
"<sector2>"						{return OPEN_SECTOR2;}
"</sector2>"					{return CLOSE_SECTOR2;}
"<sector3>"						{return OPEN_SECTOR3;}
"</sector3>"					{return CLOSE_SECTOR3;}
"<lapTime>"						{return OPEN_LAPTIME;}
"</lapTime>"					{return CLOSE_LAPTIME;}


num								{yylval.valInt=atoi(yytext); return NUM}
driverName						{yylval.string=strdup(yytext); return NAME}
circuit							{yylval.string=strdup(yytext); return CIRCUIT}
tyre 							{yylval.string=strdup(yytext); return TYRE}
time 							{yylval.string=strdup(yytext); return TIME}


. 								{}		/*para evitar que printee caracteres que no entiende*/
%%


int yyerror(){
	printf("\n\n\e[0;31mError en la linea: %d\e[0m\n\n\n", yylineno);
	exit(0);
}
