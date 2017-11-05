%{ /* fichero instrucciones.y */ 
	#include <stdio.h>
    #include <string.h> 
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

S 	    : INICIA {printf("BDS> ");} inst_n TERMINA; 
inst_n 	: CREA PA STRING_N { creaArchivo($3);} PC {printf("BDS> ");} inst CIERRA {cierraArchivo();}{printf("BDS> ");} inst_n| ABRE PA STRING_N { abreArchivo($3); }PC {printf("BDS> ");}inst CIERRA inst_n| ; 
inst 	: INGRESA PA NUM COMMA STRING_N COMMA NUM COMMA STRING_N COMMA STRING_N {ingresaDato($3,$5,$7,$9,$11);} PC {printf("BDS> ");}inst | LISTA { listarDatos(); }{printf("BDS> ");}inst| MUESTRA PA NUM { muestraDato($3);}PC {printf("BDS> ");}inst | /* epsilon */;

%%

void creaArchivo(char* finelame){
	archivo = fopen(finelame, "w+");
	if (archivo == NULL) {
	    fputs ("No se pudo crear el archivo\n",stderr); 
        exit (1);
	}
}
void cierraArchivo(){
	int res = fclose(archivo);
    if(res){
        printf("Error al guardar el archivo\n");
    }
}

void abreArchivo(char* filename){
    archivo = fopen(filename, "r+");
	if (archivo == NULL) {
	    fputs ("No se encontro el archivo\n",stderr); 
        exit (1);
	}
}

void ingresaDato(int n, char* nombre, int edad, char* ocu, char* dir){
    char line[256];                     //buffer
    rewind(archivo);                    //get to the start to reset the pointer and avoid wrong appending
    while (fgets(line, 256, archivo)){} //get to the end of the file for appending.

    fprintf(archivo, "%i,", n);
    fprintf(archivo, "%s,", nombre);
    fprintf(archivo, "%i,", edad);
    fprintf(archivo, "%s,", ocu);
    fprintf(archivo, "%s\n", dir);
    
    free(nombre);
    free(ocu);
    free(dir);
}

void listarDatos(){
    rewind(archivo);
    char line[256];
    char* id;
    char* nombre;
    char* edad;
    char* ocu;
    char* dir;

    printHeader();
    while(fgets(line, 256, archivo)){
        id = strtok(line, ",");
        nombre = strtok(NULL, ",");
        edad = strtok(NULL, ",");
        ocu = strtok(NULL, ",");
        dir = strtok(NULL, "\n");

        printQuery(atoi(id), nombre, atoi(edad), ocu, dir);
    }
    printFooter();

}

void muestraDato(int n){
    rewind(archivo);
    char line[256];
    char buff[256];
    int id;
    char* nombre;
    char* edad;
    char* ocu;
    char* dir;
    int found = 0;

    while(!found && fgets(line, 256, archivo)){
        strcpy(buff, line);
        id = atoi(strtok(buff, ","));
        if (id == n){
            found = 1;
        }
    }
    if(found){
        printHeader();
        strtok(line, ",");
        nombre = strtok(NULL, ",");
        edad = strtok(NULL, ",");
        ocu = strtok(NULL, ",");
        dir = strtok(NULL, "\n");

        printQuery(id, nombre, atoi(edad), ocu, dir);
        printFooter();
    }else
        printf("No se encontro el registro\n");
}

void printQuery(int ID, char* nombre, int edad, char* ocupacion, char* direccion){
    printf("|%3.3i|%-25.25s|%4.4i|%-15.15s|%-26.26s|\n",ID, nombre, edad, ocupacion, direccion);
}
void printHeader(){
    printf("+---+-------------------------+----+---------------+--------------------------+\n");
    printf("|ID | Nombre                  |Edad| Ocupacion     | Direccion                |\n");
    printf("+---+-------------------------+----+---------------+--------------------------+\n");
}
void printFooter(){
    printf("+---+-------------------------+----+---------------+--------------------------+\n");
}

int main(){
    printf("Bienvenido/a a Base de Datos Simulator\n");
    printf("BDS> ");
	yyparse();   
    printf("Adios :)\n");
} 