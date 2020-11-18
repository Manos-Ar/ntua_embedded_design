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

exec=["phods", "phods_fusion", "phods_unroll", "phods_data_reuse"]

if path.isdir("metrics/"):
    shutil.rmtree("metrics/")
os.mkdir("metrics")

if not path.isdir("plots/"):
    os.mkdir("plots")

data = []

for e in exec:
    times = []
    tmp = ([])
    for i in range(0,10):
        p = subprocess.Popen("./"+e+".out", stdout=subprocess.PIPE, shell=True)

        (output, err) = p.communicate()
        p_status = p.wait()
        output = int(output)
        times.append(output)
        data.append([output])

    mx=max(times)
    mn=min(times)
    avg=statistics.mean(times)

    f=open("metrics/"+e+".txt",'w')
    f.write("max: " + str(mx) +"\n")
    f.write("min: " + str(mn) +"\n")
    f.write("avg: " + str(avg) +"\n")
    f.close()

transf = []
for i in range(10):
    transf.append("no transformation")
for i in range(10):
    transf.append("fusion")
for i in range(10):
    transf.append("unroll")
for i in range(10):
    transf.append("data reuse")

data = tuple(data)
data = np.array(data)
data = pd.DataFrame(data, columns=["time(us)"])
data['transformation'] = transf
pl = sns.catplot(x="transformation", y="time(us)", kind="box", data=data)
pl.savefig("plots/2.png")
