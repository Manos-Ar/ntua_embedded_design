#!/bin/python3
import sys
import os
from os import path
import subprocess
import statistics
import shutil

exec=["phods", "phods_fusion", "phods_unroll", "phods_data_reuse"]

block_x=[1, 2, 3, 4, 6, 8, 9, 12, 16, 18, 24, 36, 48, 72, 144]
block_y=[1, 2, 4, 8, 11, 16, 22, 44, 88, 176]
if not(path.isdir("metrics/")):
    exit()
#
# os.mkdir("metrics")
for e in exec:
    f=open("metrics/"+e+".txt",'a')
    for bx in block_x:
        for by in block_y:
            times=[]
            for i in range(0,10):
                p = subprocess.Popen(["./"+e+".out",str(bx),str(by)], stdout=subprocess.PIPE, shell=True)
                (output, err) = p.communicate()
                p_status = p.wait()
                output = int(output)
                times.append(output)

            mx=max(times)
            mn=min(times)
            avg=statistics.mean(times)


            f.write("\n")
            f.write("For block size x: " + str(bx) +" block size y: "+str(by)+"\n")
            f.write("max: " + str(mx) +"\n")
            f.write("min: " + str(mn) +"\n")
            f.write("avg: " + str(avg) +"\n")
    f.close()
