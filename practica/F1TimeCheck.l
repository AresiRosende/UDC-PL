%{
#include <stdlib.h>
#include "F1TimeCheck.tab.h"

int yyerror();
int yylineno;

%}

prolog 			"<?xml version=\"1.0\" encoding=\"UTF-8\"?>"
text			[a-zA-Z\s]+
im 				"IM"
fw 				"FW"
normal			C[1-5]
time 			[0-9][0-9]\:[0-9][0-9]\.[0-9][0-9][0-9]
num				[0-9]{1,3}

%%

"\n"							{yylineno++;}
{prolog}						{return XMLPROLOG;}

"RedFlag"						{return RED_FLAG;}
"YellowFlag"					{return YELLOW_FLAG;}
"PitStop"						{return PIT_STOP;}
"DNF"							{return DNF;}
"DSQ"							{return DSQ;}
"Lapped"						{return LAPPED;}
"BnWFlag"						{return BNW_FLAG;}
"NoTime"						{return NOTIME;}
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
"</lapNumber>"					{return CLOSE_LAPNUMBER;}
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

{im}							{yylval.string=strdup(yytext); return TYRE;}
{fw}							{yylval.string=strdup(yytext); return TYRE;}
{normal}						{yylval.string=strdup(yytext); return TYRE;}

{num}							{yylval.string=strdup(yytext); return NUM;}
{text}							{yylval.string=strdup(yytext); return TEXT;}
{time} 							{yylval.string=strdup(yytext); return TIME;}

.								{} /*so as not to print character it doesnt*/
%%

int yyerror() {
	printf("\e[0;31mError: file structure is different from expected (line %d)\n", yylineno);
	printf("Last string of text read: '%s'\e[0m\n", yytext);
	printf("\e[0;33m\nShould be like this:\n");
	printf("<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n"
		   "<race>\n"
		   "  <circuit></circuit>                   *string of text*\n"
		   "  <totalLaps></totalLaps>               *number of 1 to 3 digits*\n"				
		   "  <driverNum></driverNum>               *number of 1 to 3 digits*\n"
		   "  <driverName></driverName>             *string of text*\n"
		   "  <laps>\n"
		   "    <lap>\n"
		   "      <lapNumber></lapNumber>           *number of 1 to 3 digits*\n"
		   "      <incidencies></incidencies>\n"
		   "      <lapInfo>\n"
		   "        <tyre></tyre>	 		*C1, C2, C3, C4, C5, FW or IM*\n"
		   "        <tyreLife></tyreLife>		*number of 1 to 3 digits*\n"
		   "        <sector1></sector1>		*format mm:ss.xxx*\n"
		   "        <sector2></sector2>		*format mm:ss.xxx*\n"
		   "        <sector3></sector3>		*format mm:ss.xxx*\n"
		   "        <lapTime></lapTime>		*format mm:ss.xxx*\n"
		   "      </lapInfo>\n"
		   "    </lap>\n"
		   "  </laps>\n"
		   "</race>\n\n"
		   "For more information, please consult the README.md file\e[0m\n"
	);
	exit(0);
}
