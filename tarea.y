%{ /* fichero instrucciones.y */ 
	#include <stdio.h>
	FILE* archivo;
%}

%token INICIA TERMINA CREA CIERRA ABRE INGRESA LISTA MUESTRA PA PC COMMA
%token <sval> STRING_N
%token <ival> NUM

%start S
%union {
	char *sval;
	int ival;
}
%%

S 	    : INICIA inst_n TERMINA; 
inst_n 	: CREA PA STRING_N { creaArchivo($3);} PC inst CIERRA {cierraArchivo();}| ABRE PA STRING_N { abreArchivo($3); }PC inst CIERRA | ; 
inst 	: INGRESA PA NUM COMMA STRING_N COMMA NUM COMMA STRING_N COMMA STRING_N {ingresaDato($3,$5,$7,$9,$11);} PC inst | LISTA { listarDatos(); }inst| MUESTRA PA NUM { muestraDato($3);}PC inst | /* epsilon */;

%%

void creaArchivo(char* finelame){
	archivo = fopen(finelame, "w+");
	if (archivo==NULL) {
	    fputs ("File error",stderr); 
        exit (1);
	}
	printf("hele archivo %s\n", finelame);
}
void cierraArchivo(){
	int res = fclose(archivo);
    if(!res){
        printf("Error al guardar el filo hermanito\n");
    }
}

void abreArchivo(char* filename){
    archivo = fopen(filename, "r+");
	if (archivo==NULL) {
	    fputs ("File error",stderr); 
        exit (1);
	}
	printf("abre archivo %s\n", filename);
}

void ingresaDato(int n, char* nombre, int edad, char* ocu, char* dir){
    printf("se ingresara algo %i\n", n);
    printf("se ingresara algo %s\n", nombre);
    printf("se ingresara algo %i\n", edad);
    printf("se ingresara algo %s\n", ocu);
    printf("se ingresara algo %s\n", dir);
    
    fputs(n, archivo);

    //fputs('\t', archivo);    
    fputs(nombre, archivo);
    fputs(edad, archivo);
    fputs(ocu, archivo);
    fputs(dir, archivo);
    //fputs('\n', archivo);
}

void listarDatos(){

}

void muestraDato(int n){

}
int main(){
        printf("Comienza el analisis\n");
	//WAIT PROCEDURE PRINT MAUAL

	yyparse();   

        printf("Analisis finalizado\n");
} 