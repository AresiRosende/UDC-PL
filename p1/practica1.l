%{
unsigned charCounter = 0, wordCounter = 0,
	uppCaseWordCounter = 0, lowCaseWordCounter = 0,
	numWordCounter = 0, phraseCounter = 0;
%}

word [^ \t\n]+

phrase [^ \t\n]+\.	

%%

[A-Z]+ 		{wordCounter++; uppCaseWordCounter++; charCounter+=yyleng;}

[a-z]+ 		{wordCounter++; lowCaseWordCounter++; charCounter+=yyleng;}

[0-9]+ 		{wordCounter++; numWordCounter++; charCounter+=yyleng;}

{phrase}	{wordCounter++; phraseCounter++; charCounter+=yyleng;}

{word}		{wordCounter++; charCounter+=yyleng;}

%%

int main(){

	yylex();

	printf("\n----------------------\n| Caracteres	     | %d\n----------------------\n| Palabras           | %d\n----------------------\n	| Mayúsculas | %d\n	--------------\n	| Minúsculas | %d\n	--------------\n	| Numéricas  | %d\n----------------------\n| Frases             | %d\n----------------------\n",
		charCounter,
		wordCounter,
		uppCaseWordCounter,
		lowCaseWordCounter,
		numWordCounter,
		phraseCounter);

	return 0;
}