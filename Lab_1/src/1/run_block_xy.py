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

colors = ["tab:blue", "tab:red", "tab:green", "tab:orange", "tab:purple", "tab:brown", "tab:pink", "tab:gray", "tab:olive","cyan", "yellowgreen", "cadetblue", "tan", "lightsteelblue", "black"]

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

# print(dictx)
# dictx={1: {1: 7284.3, 2: 4906.6, 4: 4208, 8: 3978.5, 11: 4577.2, 16: 4825.7, 22: 4008, 44: 4234.5, 88: 3710.3, 176: 3663.8}, 2: {1: 5891.4, 2: 4555.8, 4: 4145.8, 8: 3984, 11: 4214, 16: 4313.9, 22: 4010, 44: 4036.6, 88: 3562.4, 176: 3861}, 3: {1: 4662.1, 2: 4731.9, 4: 4375, 8: 4168.2, 11: 3778.7, 16: 3687.7, 22: 3877.4, 44: 3470.2, 88: 3562.8, 176: 3662.5}, 4: {1: 4874.7, 2: 3907.6, 4: 4049.1, 8: 4071.7, 11: 4094.1, 16: 3893.7, 22: 3873, 44: 3731, 88: 3676.3, 176: 3670.1}, 6: {1: 4593.4, 2: 4607, 4: 3395.9, 8: 4543.6, 11: 3905, 16: 3739.9, 22: 3793.7, 44: 3852.8, 88: 3382.6, 176: 3782.6}, 8: {1: 4475.4, 2: 4311.1, 4: 4703.1, 8: 3917.3, 11: 3913.1, 16: 4225.6, 22: 4118.8, 44: 4297.6, 88: 4118.7, 176: 3434.1}, 9: {1: 3943.8, 2: 3984.6, 4: 4263.3, 8: 4219, 11: 3852.1, 16: 3569.9, 22: 3670.3, 44: 3715.4, 88: 3488.8, 176: 3727.9}, 12: {1: 4391.1, 2: 4067.6, 4: 4398.8, 8: 3919.7, 11: 4055.5, 16: 3540.6, 22: 3737.1, 44: 3838.3, 88: 3515, 176: 3844.4}, 16: {1: 4015.9, 2: 4428.4, 4: 4042.8, 8: 3585.2, 11: 4340.6, 16: 3530, 22: 3471.2, 44: 3929.3, 88: 3832.2, 176: 3878.5}, 18: {1: 4505.3, 2: 4093.8, 4: 3631.5, 8: 3779.4, 11: 3811.4, 16: 3744.9, 22: 4019.9, 44: 3247.2, 88: 3441.1, 176: 3570.1}, 24: {1: 3975.9, 2: 4134, 4: 3716.1, 8: 3832.8, 11: 3760.7, 16: 3808, 22: 3784.7, 44: 4080.1, 88: 3912.2, 176: 3860.9}, 36: {1: 4424.6, 2: 3926.5, 4: 3872.8, 8: 3869.7, 11: 3421.8, 16: 3826, 22: 4036, 44: 3602.6, 88: 3518.9, 176: 3760.2}, 48: {1: 4167.2, 2: 3605.5, 4: 3742.7, 8: 3606.4, 11: 3164.1, 16: 3592, 22: 3411.2, 44: 3826.3, 88: 3805.2, 176: 4037.1}, 72: {1: 3641.8, 2: 3981.5, 4: 3638.9, 8: 3938.1, 11: 3530.2, 16: 3526, 22: 3469.2, 44: 3373.1, 88: 3634.3, 176: 3406.8}, 144: {1: 3737.6, 2: 4110.2, 4: 3800.4, 8: 4025.1, 11: 3385.4, 16: 3764.4, 22: 3789.8, 44: 4152, 88: 3934.1, 176: 3432.4}}


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

ax.set_xlabel("Bx Size",fontsize=16)
ax.set_ylabel("By Size",fontsize=16)
fig.suptitle("Average Time", fontsize=26,fontweight='bold')

i=0
for x in range(0,15):
    for y in range(0,10):
        if y==0 :
            ax.scatter(x_ticks[x], y_ticks[y], dictx[block_x[x]][block_y[y]], label="Bx:    "+str(block_x[x]) ,color=colors[i])
        else :
            ax.scatter(x_ticks[x], y_ticks[y], dictx[block_x[x]][block_y[y]],color=colors[i])
        ax.legend()
    i+=1

mng = plt.get_current_fig_manager()
mng.full_screen_toggle()

plt.show()
