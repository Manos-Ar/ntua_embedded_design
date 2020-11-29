#!/usr/bin/python3
import sys
import os
from os import path
import subprocess
import glob
import shutil
import filecmp

PK=[ "SLL", "DLL", "DYN_ARR" ]

if not path.isdir("metrics/"):
    os.mkdir("metrics")
else:
    shutil.rmtree("metrics/")
    os.mkdir("metrics")


for pk in PK:
    file="metrics/"+pk+".txt"
    print("gcc -o dijkstra.out dijkstra.c -D"+pk +" -pthread -lcdsl -L./../synch_implementations -I./../synch_implementations")
    subprocess.run("gcc -o dijkstra.out dijkstra.c -D"+pk +" -pthread -lcdsl -L./../synch_implementations -I./../synch_implementations",shell=True)

    # subprocess.run("./dijkstra.out input.dat >" + pk +".txt", shell=True)
    # if filecmp.cmp(pk+".txt","original_output.txt") :
    #     print ("Same")
    #     subprocess.run("rm "+pk+".txt",shell=True)
    # else:
    #     print("Different")
    #     exit()

    subprocess.run("valgrind --log-file=\"mem_accesses_log.txt\" --tool=lackey --trace-mem=yes ./dijkstra.out input.dat",shell=True)
    subprocess.run("cat mem_accesses_log.txt | grep 'I\| L' | wc -l >"+file,shell=True)

    subprocess.run("valgrind --tool=massif ./dijkstra.out input.dat", shell=True)

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
os.remove("dijkstra.out")
