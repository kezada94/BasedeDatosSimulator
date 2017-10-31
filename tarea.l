%{ 
    #include <stdio.h> 
    #include "y.tab.h" /* GENERADO AUTOMÁTICAMENTE POR BISON */ 
%} 

NUM         [0-9]
STRING      [a-zA-Z]
STRING_N    [a-zA-Z0-9.-_]
SPACE       [" "]+

%%

inicia      {return(INICIA);};
termina     {return(TERMINA);};
crea        {return(CREA);};
abre        {return(ABRE);};
cierra      {return(CIERRA);};
ingresa     {return(INGRESA);};
lista       {return(LISTA);};
muestra     {return(MUESTRA);};
{NUM}+      {return(NUM);};
{STRING}+   {return(STRING);};
{STRING_N}+ {return(STRING_N);};
{SPACE}     { /* do nothing */};
\n          { /* do nothing */};
"("         {return(PA);};
")"         {return(PC);};
","         {return(COMMA);};
