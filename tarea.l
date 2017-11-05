%{ 
    #include <stdio.h> 
    #include "y.tab.h" /* GENERADO AUTOMÁTICAMENTE POR BISON */ 
%} 

NUM         [0-9]
STRING_N    [a-zA-Z0-9.-_]
SPACE       [" "]+
PA          [(]
PC          [)]
COMMA       [,]

%%

inicia      {return(INICIA);};
termina     {return(TERMINA);};
crea        {return(CREA);};
abre        {return(ABRE);};
cierra      {return(CIERRA);};
ingresa     {return(INGRESA);};
lista       {return(LISTA);};
muestra     {return(MUESTRA);};
{NUM}+      {yylval.ival = atoi(yytext); return(NUM);};
{STRING_N}+ {yylval.sval = strdup(yytext); return(STRING_N);};
{SPACE}     { /* do nothing */};
\n          { /* do nothing */};
{PA}        {return(PA);};
{PC}        {return(PC);};
{COMMA}     {return(COMMA);};
