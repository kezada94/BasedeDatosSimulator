%{ /* fichero instrucciones.y */ 
	#include <stdio.h>
%}

%token INICIA TERMINA CREA CIERRA ABRE INGRESA NUM STRING STRING_N LISTA MUESTRA PA PC COMMA
%start S

%%

S 	: INICIA {printf("se inicia el prog");} inst_n TERMINA; 
inst_n 	: CREA PA STRING_N PC inst CIERRA {printf("se crea un archivo");}| ABRE inst CIERRA {printf("se abre un archivo");}| ; 
inst 	: INGRESA PA NUM COMMA STRING COMMA NUM COMMA STRING COMMA STRING_N PC inst {printf("se ingresa un dato");}| LISTA inst {printf("se listan los datos");}| MUESTRA PA NUM PC inst {printf("se muestra algo");}| /* epsilon */;

%%
int main(){
        printf("Comienza el analisis\n");
	// PREGUNTAR SOBRE ACCIONES SEMANTCAS Y END OF FILE
	yyparse();   

        printf("Analisis finalizado\n");
} 