# UDC-PL
Repositorio con las practicas de Procesamento de Linguaxes

## P2 Peculiaridades
- No verifica que el nombre de una etiqueta no pueda empezar por 'xml'
- En el prologo solo admite la version 1.0 de XML (no encontre que hubiera diferentes)
- Los encodings disponibles son UTF-8 y UTF-16 (no se que sucede si pones otra cosa la verdad
- No he probado a ver como de bien va el tener comentarios por el medio


## Report

Aresio Rosende Coto

Para esta practica hice uso de 7 tokens
Uno para el prólogo o cabecera de los archivos XML (XMLPROLOG), los de inicio de etiquetas (TAG_START_OPEN y TAG_START_CLOSE respectivamente para las etiquetas de apertura y de cierre), el de fin de etiqueta (TAG_END), el de los comentarios (COMMENT) y uno para el nombre de la etiqueta (TAGNAME) y otro para el contenido (TAGCONTENT)
En el archivo practica2.y explico las normas tal que:
	- El prologo puede o no aparecer, pero siempre que aparezca tiene que ser el primer elemento
	- Despues del prologo viene el cuerpo, donde pueden aparecer comentarios y etiquetas
	- Las etiquetas pueden tener contenido, contener otras etiquetas o estar vacias

Peculiaridades
	- En el archivo .l añado la regla " . {} " para que lex no printee los caracteres que no reconozca y los obvie, ya que este tipo de caracteres solo pueden aparecer en el contenido de una etiqueta y eso nos es irrelevante
	- El prólogo solo permite la version 1.0 de XML (no encontre que hubiera otra diferente) y en cuanto al encoding solo acepta UTF-8 y UTF-16 (defino la funcion yyerror para que explique que es un error de encoding, ya que el resto de errores estan encapsulados en sus propias reglas y el analizador no deberia llamar a esta función en ningún otro caso)
	- El programa printea un error en caso de que el archivo a analizar no tenga extension .xml
	- El contenido de una etiqueta puede ser un TAGNAME o un TAGCONTENT por la manera de definir el TAGNAME
	- El nombre de una etiqueta tiene que empezar por una letra, acorde a lo que dice XML (sin embargo no comprueba que no empiece por la cadena "xml")
	- Los comentarios pueden aparecer en cualquier punto del archivo
	- Se utiliza la variable yylineno para especificar la linea donde hay un error


Pruebas
	Se aportan 8 archivos de pruebas
	- prueba.xml es un archivo con una sintaxis correcta
	- pruebaError.xml es un archivo con una etiqueta mal cerrada
	- pruebaErrorNoCierre.xml es un archivo con una etiqueta sin cerrar
	- pruebaErrorExt.txt es un archivo con una extensión errónea
	- pruebaErrorProlog.xml es un archivo donde el prólogo no es el primer elemento
	- pruebaNoProlog.xml es un archivo con una sintaxis correcta sin el prólogo
	- pruebaComentarios.xml es un archivo con una sintaxis correcta donde el comentario aparece en medio de las etiquetas
	- pruebaComentariosError.xml es un archivo donde el comentario tiene dentro una cadena ilegal "--"

	Con el comando 'make compile' se podra compilar el programa
	Con el comando 'make all' se ejecutaran todas las pruebas
	Para ejecutar una prueba concreta, usar el comando 'make runx', siendo x el numero de la prueba a ejecutar segun el orden anterior