guest: ex1 ex2 ex3 string_manipulation
ex1: ex1.s
	gcc -Wall -o ex1.out ex1.s

ex2: ex2.s
	gcc -Wall -o ex2.out ex2.s

ex3: ex3.s
	gcc -Wall -c -g ex3.s -o ex3.o
	gcc -Wall -O3 -c -g string_manipulation.c 
	gcc -Wall -O3 -o string_manipulation.out string_manipulation.o ex3.o

string_manipulation: string_manipulation.c ex3.o 
	gcc -Wall -O3 -c -g string_manipulation.c 
	gcc -Wall -O3 -o string_manipulation.out string_manipulation.o ex3.o

host: ex2_c
ex2_c : ex2.c
	gcc -Wall -O3 -o ex2_c.out ex2.c

clean:
	rm -f *.out *.o *_out
