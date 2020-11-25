all: tables.out tables_exhaustive.out tables_random.out tables_simplex.out

tables.out: tables.c
	gcc -O0 -Wall -o tables.out tables.c

tables_exhaustive.out: tables_exhaustive.c
	gcc -O0 -Wall -o tables_exhaustive.out tables_exhaustive.c

tables_random.out: tables_random.c
	gcc -O0 -Wall -o tables_random.out tables_random.c

tables_simplex.out: tables_simplex.c
	gcc -O0 -Wall -o tables_simplex.out tables_simplex.c


orio: _exhaustive.c _random.c _simplex.c

_exhaustive.c: exhaustive.c
	orcc exhaustive.c

_random.c: random.c
	orcc random.c

_simplex.c: simplex.c
	orcc simplex.c



clean:
	rm -f *.log *.o *.json *.out
