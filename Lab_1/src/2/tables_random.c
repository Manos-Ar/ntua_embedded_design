#include <stdio.h>
#include <stdlib.h>
#include <sys/time.h>

int main()
{
	int i;
	int N=100000000,time;
	double *x1, *x2, *x3, *y;
	double a1= 0.5;
	double a2= 1;
	double a3= 1.5;
  struct timeval ts,tf;

	x1 = (double*) malloc(N*sizeof(double));
	x2 = (double*) malloc(N*sizeof(double));
	x3 = (double*) malloc(N*sizeof(double));
	y = (double*) malloc(N*sizeof(double));


	//Do not modify this loop
	for (i=0; i<=N-1; i++)
	{
		x1[i] = (double) i * 0.5;
		x1[i] = (double) i * 0.4;
		x2[i] = (double) i * 0.8;
		x3[i] = (double) i * 0.2;
		y[i] = 0;
	}



	/*
	Τhis is the basic loop of tables.c. Isolate it in file tables_orio.c,
	in which all the parameters for Design Space Exploration (DSE) and loop
	transfornations should be defined.
	*/

  gettimeofday(&ts,NULL);
  for (i = 0; i <= N - 5; i = i + 5) {
    y[i] = y[i] + a1 * x1[i] + a2 * x2[i] + a3 * x3[i];
    y[(i + 1)] = y[(i + 1)] + a1 * x1[(i + 1)] + a2 * x2[(i + 1)] + a3 * x3[(i + 1)];
    y[(i + 2)] = y[(i + 2)] + a1 * x1[(i + 2)] + a2 * x2[(i + 2)] + a3 * x3[(i + 2)];
    y[(i + 3)] = y[(i + 3)] + a1 * x1[(i + 3)] + a2 * x2[(i + 3)] + a3 * x3[(i + 3)];
    y[(i + 4)] = y[(i + 4)] + a1 * x1[(i + 4)] + a2 * x2[(i + 4)] + a3 * x3[(i + 4)];
  }
  for (i = N - ((N - (0)) % 5); i <= N - 1; i = i + 1) 
    y[i] = y[i] + a1 * x1[i] + a2 * x2[i] + a3 * x3[i];
  gettimeofday(&tf,NULL);
  time=(tf.tv_sec-ts.tv_sec)*1000000+(tf.tv_usec-ts.tv_usec);
  printf("%d\n",time);

	return 0;

}
