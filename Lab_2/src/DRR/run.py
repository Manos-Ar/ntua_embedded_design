#!/usr/bin/python3
import sys
import os
from os import path
import subprocess
import glob
import shutil

CL=[ "SLL_CL", "DLL_CL", "DYN_ARR_CL" ]
PK=[ "SLL_PK", "DLL_PK", "DYN_ARR_PK" ]

if not path.isdir("metrics/"):
    os.mkdir("metrics")
else:
    shutil.rmtree("metrics/")
    os.mkdir("metrics")


for cl in CL:
    for pk in PK:
        file="metrics/"+cl+"-"+pk+".txt"
        print("gcc -o drr.out drr.c -D"+cl+ " -D" + pk +" -pthread -lcdsl -L./../synch_implementations -I./../synch_implementations")
        subprocess.run("gcc -o drr.out drr.c -D"+cl+ " -D" + pk +" -pthread -lcdsl -L./../synch_implementations -I./../synch_implementations",shell=True)
        subprocess.run("./drr.out")
        subprocess.run("valgrind --log-file=\"mem_accesses_log.txt\" --tool=lackey --trace-mem=yes ./drr.out",shell=True)
        subprocess.run("cat mem_accesses_log.txt | grep 'I\| L' | wc -l >"+file,shell=True)

        subprocess.run("valgrind --tool=massif ./drr.out", shell=True)

        l=glob.glob("massif.out.*")

        subprocess.run("ms_print " +l[0]+ "> mem_footprint_log.txt", shell=True)

        f=open("mem_footprint_log.txt","r")
        for i, line in enumerate(f):
            if i == 7:
                unit=line.split()
                unit=unit[0]
            elif i == 8:
                tokens=line.split("^")
                footprint=tokens[0]
                break

        f.close()

        footprint+=" "+unit
        subprocess.run("echo \""+footprint+"\">>"+file, shell=True)


        os.remove(l[0])
        os.remove("mem_accesses_log.txt")
        os.remove("mem_footprint_log.txt")
os.remove("drr.out")


    # f=open("metrics/"+e+".txt",'w')
    # f.write("max: " + str(mx) +"\n")
    # f.write("min: " + str(mn) +"\n")
    # f.write("avg: " + str(avg) +"\n")
    # f.close()
