%{
#include <stdlib.h>
#include "practica2.tab.h"

int yyerror();

%}

encoding		(UTF-8)|(UTF-16)
letter			[a-zA-ZÑñ_]
number			[0-9]
sp_char			[\~\@\#\$\%\^\*\!\"\(\)\+\{\}\"\|\[\]\;\'\\\,\.\/\s\:\t\-]
tagContent		({letter}{number}{sp_char})*
prolog			"<?xml version=\"1.0\" encoding=\""{encoding}"\"?>"

%%

"\n"							yylineno++;
{prolog}						{return XMLPROLOG;}
"<"								{return TAG_START_OPEN;}
"</"							{return TAG_START_CLOSE;}
">"								{return TAG_END;}
"<!--".*"--".*"-->"				{printf("\n\n\e[0;31mError en la linea %d\nUn comentario no puede contener la cadena '--' \e[0m\n\n\n", yylineno);exit(0);}
"<!--".*"-->"					{return COMMENT;}
({letter})({letter}|{number})*	{yylval.string=strdup(yytext); return TAGNAME;}  /*tiene que empezar por una letra*/
{tagContent}					{return TAGCONTENT;} 		/*no nos importa el contenido*/
. 								{}		/*para evitar que printee caracteres que no entiende*/
%%


int yyerror(){
	printf("\n\n\e[0;31mEncoding invalido: ha de ser UTF-8 o UTF-16\e[0m\n\n\n");
	exit(0);
}

int yywrap(){
	printf("\n\n\e[0;32mSintaxis XML correcta.\e[0m\n\n\n");
	exit(0);
}
