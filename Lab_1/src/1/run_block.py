#!/bin/python3
import sys
import os
from os import path
import subprocess
import statistics
import shutil

exec=["phods_data_reuse"]
block=[1,2,4,8,16]
if not(path.isdir("metrics/")):
    exit()
#
# os.mkdir("metrics")
for e in exec:
    f=open("metrics/"+e+".txt",'a')
    for b in block:
        times=[]
        for i in range(0,10):
            p = subprocess.Popen("./"+e+".out "+str(b), stdout=subprocess.PIPE, shell=True)
            (output, err) = p.communicate()
            p_status = p.wait()
            output = int(output)
            times.append(output)

        mx=max(times)
        mn=min(times)
        avg=statistics.mean(times)


        f.write("\n")
        f.write("For block size: " + str(b) +"\n")
        f.write("max: " + str(mx) +"\n")
        f.write("min: " + str(mn) +"\n")
        f.write("avg: " + str(avg) +"\n")
    f.close()
