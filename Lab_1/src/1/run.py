#!/bin/python3
import sys
import os
from os import path
import subprocess
import statistics
import shutil

exec=["phods", "phods_fusion", "phods_unroll", "phods_data_reuse"]

if path.isdir("metrics/"):
    shutil.rmtree("metrics/")
os.mkdir("metrics")

# if path.isdir("outputs/"):
#     shutil.rmtree("outputs/")
#     os.mkdir("outputs")


for e in exec:
    times=[]
    for i in range(0,10):
        p = subprocess.Popen("./"+e+".out", stdout=subprocess.PIPE, shell=True)

        (output, err) = p.communicate()
        p_status = p.wait()
        output = int(output)
        times.append(output)

    mx=max(times)
    mn=min(times)
    avg=statistics.mean(times)

    f=open("metrics/"+e+".txt",'w')
    f.write("max: " + str(mx) +"\n")
    f.write("min: " + str(mn) +"\n")
    f.write("avg: " + str(avg) +"\n")
    f.close()
