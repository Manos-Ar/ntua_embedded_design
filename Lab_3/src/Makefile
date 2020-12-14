guest: ex1 ex2
ex1: ex1.s
	gcc -Wall -o ex1.out ex1.s

ex2: ex2.s
	gcc -Wall -o ex2.out ex2.s

host: ex2_c
ex2_c : ex2.c
	gcc -Wall -O3 -o ex2_c.out ex2.c

clean:
	rm -f *.out