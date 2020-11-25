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
from mpl_toolkits import mplot3d

if not path.isdir("metrics/"):
    os.mkdir("metrics")

if not path.isdir("plots/"):
    os.mkdir("plots")


#erotima 2
data2 = []
executable2 = []
times = []
for i in range(10):
    p = subprocess.Popen("./phods.out", stdout=subprocess.PIPE, shell=True)

    (output, err) = p.communicate()
    p_status = p.wait()
    output = int(output)
    times.append(output)
    data2.append([output])
    executable2.append("phods")

mx=max(times)
mn=min(times)
avg=statistics.mean(times)

f=open("metrics/phods.txt",'w')
f.write("max: " + str(mx) +"\n")
f.write("min: " + str(mn) +"\n")
f.write("avg: " + str(avg) +"\n")
f.close()

best_data = data2.copy()
best_executable = executable2.copy()
data2 = tuple(data2)
data2 = np.array(data2)
data2 = pd.DataFrame(data2, columns=["time(us)"])
data2['executable'] = executable2
pl = sns.catplot(x="executable", y="time(us)", kind="box", data=data2)
pl.savefig("plots/2.png")


#erotima 3
data3 = []
executable3 = []
best3 = " "
tmp_data = []
best_avg = 100000
for e in "fusion", "unroll", "data_reuse":
    times = []
    tmp = []
    for i in range(10):
        p = subprocess.Popen("./phods_"+e+".out", stdout=subprocess.PIPE, shell=True)

        (output, err) = p.communicate()
        p_status = p.wait()
        output = int(output)
        times.append(output)
        data3.append([output])
        tmp.append([output])

    mx=max(times)
    mn=min(times)
    avg=statistics.mean(times)

    if avg<best_avg:
    	best_avg = avg
    	tmp_data = tmp.copy()
    	best3 = e


    f=open("metrics/"+e+".txt",'w')
    f.write("max: " + str(mx) +"\n")
    f.write("min: " + str(mn) +"\n")
    f.write("avg: " + str(avg) +"\n")
    f.close()

best_data = best_data + tmp_data.copy()
best_executable = best_executable + [best3]*10

executable3 = []
for i in range(10):
    executable3.append("phods_fusion")
for i in range(10):
    executable3.append("phods_unroll")
for i in range(10):
    executable3.append("phods_data_reuse")

data3 = tuple(data3)
data3 = np.array(data3)
data3 = pd.DataFrame(data3, columns=["time(us)"])
data3['executable'] = executable3
pl = sns.catplot(x="executable", y="time(us)", kind="box", data=data3)
pl.savefig("plots/3.png")


#erotima 4
data4 = []
bl = []
best4 = 0
tmp_data = []
best_avg = 100000
f=open("metrics/"+best3+".txt",'a')
for b in 1, 2, 4, 8, 16:
    times = []
    tmp = []
    for i in range(10):
        p = subprocess.Popen("./phods_"+best3+".out "+str(b), stdout=subprocess.PIPE, shell=True)
        (output, err) = p.communicate()
        p_status = p.wait()
        output = int(output)
        times.append(output)
        data4.append([output])
        bl.append(b)
        tmp.append([output])

    mx=max(times)
    mn=min(times)
    avg=statistics.mean(times)

    if avg<best_avg:
    	best_avg = avg
    	tmp_data = tmp.copy()
    	best4 = b

    f.write("\n")
    f.write("For block size: " + str(b) +"\n")
    f.write("max: " + str(mx) +"\n")
    f.write("min: " + str(mn) +"\n")
    f.write("avg: " + str(avg) +"\n")
f.close()

best_data = best_data + tmp_data.copy()
best_executable = best_executable + [best3+str(best4)]*10

data4 = tuple(data4)
data4 = np.array(data4)
data4 = pd.DataFrame(data4, columns=["time(us)"])
data4['block size'] = bl
pl = sns.catplot(x="block size", y="time(us)", kind="box", data=data4)
pl.savefig("plots/4.png")


#erotima 5
dictx=dict()
colors = ["tab:blue", "tab:red", "tab:green", "tab:orange", "tab:purple", "tab:brown", "tab:pink", "tab:gray", "tab:olive","cyan", "yellowgreen", "cadetblue", "tan", "lightsteelblue", "black"]
block_x=[1, 2, 3, 4, 6, 8, 9, 12, 16, 18, 24, 36, 48, 72, 144]
block_y=[1, 2, 4, 8, 11, 16, 22, 44, 88, 176]

data5 = []
best5 = (0, 0)
tmp_data = []
best_avg = 100000
f=open("metrics/"+best3+".txt",'a')
for bx in block_x:
    dictx[bx]={}
    for by in block_y:
        times=[]
        tmp=[]
        for i in range(10):
            p = subprocess.Popen("./phods_"+best3+".out "+str(bx)+" "+str(by), stdout=subprocess.PIPE, shell=True)
            (output, err) = p.communicate()
            p_status = p.wait()
            output = int(output)
            times.append(output)
            data5.append([output])
            tmp.append([output])

        mx=max(times)
        mn=min(times)
        avg=statistics.mean(times)

        if avg<best_avg:
            best_avg = avg
            tmp_data = tmp.copy()
            best5 = (bx, by)

        dictx[bx].update({by:avg})

        f.write("\n")
        f.write("For block size x: " + str(bx) +" block size y: "+str(by)+"\n")
        f.write("max: " + str(mx) +"\n")
        f.write("min: " + str(mn) +"\n")
        f.write("avg: " + str(avg) +"\n")
f.close()

best_data = best_data + tmp_data.copy()
best_executable = best_executable + [best3+str(best5[0])+","+str(best5[1])]*10

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
ax.set_zlabel("Time(us)",fontsize=16)
fig.suptitle("Average Time", fontsize=26,fontweight='bold')

i=0
for x in range(0,15):
    for y in range(0,10):
        if y==0 :
            ax.scatter(x_ticks[x], y_ticks[y], dictx[block_x[x]][block_y[y]], label=str(block_x[x]) ,color=colors[i])
        else :
            ax.scatter(x_ticks[x], y_ticks[y], dictx[block_x[x]][block_y[y]],color=colors[i])
        ax.legend(bbox_to_anchor=(1.1, 0.9))
    i+=1

mng = plt.get_current_fig_manager()
mng.full_screen_toggle()

plt.savefig("plots/5.png")


#erotima 6
best_data = tuple(best_data)
best_data = np.array(best_data)
best_data = pd.DataFrame(best_data, columns=["time(us)"])
best_data['executable'] = best_executable
pl = sns.catplot(x="executable", y="time(us)", kind="box", data=best_data)
pl.savefig("plots/6.png")