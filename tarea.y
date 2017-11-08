%{ /* fichero instrucciones.y */ 
	#include <stdio.h>
    #include <string.h> 
	FILE* archivo;
%}

// tokens que ocuparemos
%token INICIA TERMINA CREA CIERRA ABRE INGRESA LISTA MUESTRA PA PC COMMA
%token <sval> STRING_N
%token <ival> NUM

//Produccion inicial de la gramatica
%start S
%union {
	char *sval;
	int ival;
}

//Declaramos la gramatica con sus respectivas acciones semanticas

%%

S 	    : INICIA {prompt(1);} inst_n TERMINA; 
inst_n 	: CREA PA STRING_N { creaArchivo($3);} PC {printf("Archivo creado. ");prompt(2);} 
            inst CIERRA {cierraArchivo();}{prompt(1);} inst_n
        | ABRE PA STRING_N { abreArchivo($3); }PC {printf("Archivo abierto. "); prompt(2);}
            inst CIERRA {prompt(1);}inst_n| ; 
inst 	: INGRESA PA NUM COMMA STRING_N COMMA NUM COMMA STRING_N COMMA STRING_N 
            {ingresaDato($3,$5,$7,$9,$11);} PC {printf("Dato ingresado. "); prompt(2);}inst 
        | LISTA { listarDatos(); }{prompt(2);}inst
        | MUESTRA PA NUM { muestraDato($3);}PC {prompt(2);}inst 
        | /* epsilon */;

%%

//funcion creada para guiar al usuario
void prompt(int opc){
    if (opc == 1){ 
        printf("Ahora, los comandos posibles son:\n");
        printf("'abre(nombre_archivo)'         para abrir y usar un archivo existente\n");
        printf("'crea(nombre_archivo)'         para crear un archivo nuevo\n");
        printf("'termina'                      para finalizar.\n");
        printf("BDS> ");
    }
    else if (opc == 2) {
        printf("Los comandos posibles son:\n");
        printf("'ingresa()'      para agregar datos [ver orden de parametros]\n");
        printf("'lista'          para desplegar en pantalla el contenido del archivo.\n");
        printf("'muestra(id)'    para mostrar los datos de ID\n");
        printf("'cierra'         para cerrar el archivo en uso\n");
        printf("BDS> ");
    }
}

//Crea un archivo con un nombre especificado en la entrada
void creaArchivo(char* finelame){
	archivo = fopen(finelame, "w+");
	if (archivo == NULL) {
	    fputs ("No se pudo crear el archivo\n",stderr); 
        exit (1);
	}
}

//Cierra un archivo que haya estado abierto anteriormente
void cierraArchivo(){
	int res = fclose(archivo);
    if(res){
        printf("Error al guardar el archivo\n");
    }
}

//Abre un archivo que este creado con anterioridad
void abreArchivo(char* filename){
    archivo = fopen(filename, "r+");
	if (archivo == NULL) {
	    fputs ("No se encontro el archivo\n",stderr); 
        exit (1);
	}
}

//Escribe un dato aceptado por la gramatica al archivo abierto
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


//muestra en pantalla todos los datos que posee el archivo en uso
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

//muestra un el dato que corresponda segun el ID seleccionado por el usuario
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

//Imprime un dato leido en el archivo
void printQuery(int ID, char* nombre, int edad, char* ocupacion, char* direccion){
    printf("|%3.3i|%-25.25s|%4.4i|%-15.15s|%-26.26s|\n",ID, nombre, edad, ocupacion, direccion);
}

//Cabecera que se ocupa al mostrar o listar un dato
void printHeader(){
    printf("+---+-------------------------+----+---------------+--------------------------+\n");
    printf("|ID | Nombre                  |Edad| Ocupacion     | Direccion                |\n");
    printf("+---+-------------------------+----+---------------+--------------------------+\n");
}

//Se imprime al final desues de mostar o listar los datos solicitados
void printFooter(){
    printf("+---+-------------------------+----+---------------+--------------------------+\n");
}

//Funcion principal
int main(){
    printf("Bienvenido/a a Base de Datos Simulator\nPara comenzar, escriba 'inicia'\n");
    printf("BDS> ");
	yyparse();   
    printf("Adios :)\n");
} 