OBJ=main.adb

all:
	gnatmake $(OBJ)

debug:
	gnatmake -g main -bargs -E

clean:
	rm -f *.ali
	rm -f *.o
	rm -f main
