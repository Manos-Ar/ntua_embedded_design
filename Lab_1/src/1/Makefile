all: phods.out phods_fusion.out phods_unroll.out phods_data_reuse.out

phods.out: phods.c
	gcc -O0 -Wall -o phods.out phods.c

phods_fusion.out: phods_fusion.c
	gcc -O0 -Wall -o phods_fusion.out phods_fusion.c

phods_unroll.out: phods_unroll.c
	gcc -O0 -Wall -o phods_unroll.out phods_unroll.c

phods_data_reuse.out: phods_unroll.c
	gcc -O0 -Wall -o phods_data_reuse.out phods_data_reuse.c

clean:
	rm *.out
