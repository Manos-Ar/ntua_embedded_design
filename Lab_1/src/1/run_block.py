#!/usr/bin/python3
import sys
import os
from os import path
import subprocess
import statistics
import shutil
import numpy as np
import pandas as pd
import matplotlib.pyplot as plt
import seaborn as sns

exec=["phods_data_reuse"]
block=[1,2,4,8,16]
if not(path.isdir("metrics/")):
    exit()
if not path.isdir("plots/"):
    os.mkdir("plots")

data = []
bl = []

for e in exec:
    f=open("metrics/"+e+".txt",'a')
    for b in block:
        times=[]
        tmp = ([])
        for i in range(0,10):
            p = subprocess.Popen("./"+e+".out "+str(b), stdout=subprocess.PIPE, shell=True)
            (output, err) = p.communicate()
            p_status = p.wait()
            output = int(output)
            times.append(output)
            data.append([output])
            bl.append(b)

        mx=max(times)
        mn=min(times)
        avg=statistics.mean(times)


        f.write("\n")
        f.write("For block size: " + str(b) +"\n")
        f.write("max: " + str(mx) +"\n")
        f.write("min: " + str(mn) +"\n")
        f.write("avg: " + str(avg) +"\n")
    f.close()

data = tuple(data)
data = np.array(data)
data = pd.DataFrame(data, columns=["time(us)"])
data['block size'] = bl
pl = sns.catplot(x="block size", y="time(us)", kind="box", data=data)
pl.savefig("plots/3.png")
