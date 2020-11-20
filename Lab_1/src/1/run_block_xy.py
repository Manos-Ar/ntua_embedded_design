#!/bin/python3
import sys
import os
from os import path
import subprocess
import statistics
import shutil

from mpl_toolkits import mplot3d
import numpy as np
import matplotlib.pyplot as plt


exec=["phods_data_reuse"]

block_x=[1, 2, 3, 4, 6, 8, 9, 12, 16, 18, 24, 36, 48, 72, 144]
block_y=[1, 2, 4, 8, 11, 16, 22, 44, 88, 176]

dictx=dict()


if not(path.isdir("metrics/")):
    exit()

# os.mkdir("metrics")
for e in exec:
    f=open("metrics/"+e+".txt",'a')
    for bx in block_x:
        dictx[bx]={}
        for by in block_y:
            times=[]
            for i in range(0,10):
                # print(i,bx,by,str(e))
                p = subprocess.Popen("./"+e+".out "+str(bx)+" "+str(by), stdout=subprocess.PIPE, shell=True)
                (output, err) = p.communicate()
                p_status = p.wait()
                # print(output)
                output = int(output)
                times.append(output)

            mx=max(times)
            mn=min(times)
            avg=statistics.mean(times)

            dictx[bx].update({by:avg})

            f.write("\n")
            f.write("For block size x: " + str(bx) +" block size y: "+str(by)+"\n")
            f.write("max: " + str(mx) +"\n")
            f.write("min: " + str(mn) +"\n")
            f.write("avg: " + str(avg) +"\n")
    f.close()


fig = plt.figure()
ax = plt.axes(projection='3d')

x_ticks=np.arange(0,len(block_x),1)
y_ticks=np.arange(0,len(block_y),1)


ax.set_xlim(0, len(x_ticks)-0.5)
ax.set_ylim(0, len(y_ticks)-0.5)
ax.xaxis.set_ticks(x_ticks)
ax.set_xticklabels(block_x, rotation=0)
ax.yaxis.set_ticks(y_ticks)
ax.set_yticklabels(block_y, rotation=0)

ax.set_xlabel("Bx Size",fontsize=12)
ax.set_ylabel("By Size",fontsize=12)
fig.suptitle("Average Time", fontsize=16,fontweight='bold')

for x in range(0,15):
    for y in range(0,10):
        ax.scatter(x_ticks[x], y_ticks[y], dictx[block_x[x]][block_y[y]], color='red')

# plt.savefig("test.png",bbox_inches="tight")
plt.show()
