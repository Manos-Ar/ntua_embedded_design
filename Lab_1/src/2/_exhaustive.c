/*@ begin PerfTuning (
 def build {
   arg build_command = 'gcc -O0 -mcmodel=large';
 }
 def performance_params {
   param UF[] = range(1,33);
 }
 def performance_counter {
  arg method = 'basic timer';
  arg repetitions = 10;
 }
 def input_params {
   param N[] = [100000000];
 }
 def input_vars {
   decl static double y[N] = random;
   decl double a1 = random;
   decl double a2 = random;
   decl double a3 = random;
   decl static double x1[N] = random;
   decl static double x2[N] = random;
   decl static double x3[N] = random;
 }

 def search {
  arg algorithm = 'Exhaustive';
 }
) @*/
/**-- (Generated by Orio) 
Best performance cost: 
  [0.387001, 0.384948, 0.382184, 0.385056, 0.382496, 0.385409, 0.384572, 0.380457, 0.385091, 0.386207] 
Tuned for specific problem sizes: 
  N = 100000000 
Best performance parameters: 
  UF = 8 
--**/

int i;
/*@ begin Loop (
    transform Unroll(ufactor=UF)
    for (i=0; i<=N-1; i++)
      y[i] = y[i] + a1*x1[i] + a2*x2[i] + a3*x3[i];
) @*/
for (int loop_loop_32=0; loop_loop_32 < 1; loop_loop_32++)  {
    int i;
    for (i = 0; i <= N - 8; i = i + 8) {
      y[i] = y[i] + a1 * x1[i] + a2 * x2[i] + a3 * x3[i];
      y[(i + 1)] = y[(i + 1)] + a1 * x1[(i + 1)] + a2 * x2[(i + 1)] + a3 * x3[(i + 1)];
      y[(i + 2)] = y[(i + 2)] + a1 * x1[(i + 2)] + a2 * x2[(i + 2)] + a3 * x3[(i + 2)];
      y[(i + 3)] = y[(i + 3)] + a1 * x1[(i + 3)] + a2 * x2[(i + 3)] + a3 * x3[(i + 3)];
      y[(i + 4)] = y[(i + 4)] + a1 * x1[(i + 4)] + a2 * x2[(i + 4)] + a3 * x3[(i + 4)];
      y[(i + 5)] = y[(i + 5)] + a1 * x1[(i + 5)] + a2 * x2[(i + 5)] + a3 * x3[(i + 5)];
      y[(i + 6)] = y[(i + 6)] + a1 * x1[(i + 6)] + a2 * x2[(i + 6)] + a3 * x3[(i + 6)];
      y[(i + 7)] = y[(i + 7)] + a1 * x1[(i + 7)] + a2 * x2[(i + 7)] + a3 * x3[(i + 7)];
    }
    for (i = N - ((N - (0)) % 8); i <= N - 1; i = i + 1) 
      y[i] = y[i] + a1 * x1[i] + a2 * x2[i] + a3 * x3[i];
  }
/*@ end @*/
/*@ end @*/
