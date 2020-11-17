#include <string.h>
#include <stdlib.h>
#include <stdio.h>

void print_table(char *name,int argc, int Bx, int By, int N, int M, int current[N][M], int previous[N][M]){
  FILE *output;
  char Bx_s[10], By_s[10], file[200],argc_s[20];
  sprintf(Bx_s,"%d",Bx);
  sprintf(By_s,"%d",By);
  sprintf(argc_s,"%d",argc-1);

  // strcpy(file,"outputs/");
  strcpy(file,name);
  // printf("%s\n",file);
  strcat(file,argc_s);
  // printf("%s\n",file);
  strcat(file,"_");
  // printf("%s\n",file);
  strcat(file,Bx_s);
  // printf("%s\n",file);
  strcat(file,"_");
  // printf("%s\n",file);
  strcat(file,By_s);
  // printf("%s\n",file);
  strcat(file,".txt");
  // printf("%s\n",file);
  output=fopen(file,"w");
  for(int i=0; i<N; i++){
     for(int j=0; j<M; j++)
       fprintf(output,"%d %d ", previous[i][j],current[i][j]);
     fprintf(output,"\n");
   }
  fclose(output);
}
