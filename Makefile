all:
	bison -yd --report=all tarea.y
	flex tarea.l
	gcc lex.yy.c y.tab.c -L/usr/local/Cellar/flex/2.6.4/lib -lfl -ly -o prog
