#!/usr/bin/python3
import glob
import matplotlib.pyplot as plt
from matplotlib.colors import ListedColormap



files=glob.glob("metrics/*")
# print(files)

configuration = list(map(lambda x: x.split(".")[0],list(map(lambda x: x.split("/")[1] ,files))))

# print(configuration)

x=[]
y=[]

for f in files:
    fp = open(f,"r")
    for i, line in enumerate(fp):
        # print(line)
        if i==0 :
            x.append(int(line))
        else:
            tokens = line.split()
            # print(tokens)
            if tokens[1]=="KB":
                y.append(float(tokens[0]))
            else :
                y.append(float(tokens[0])*1024)
            break
    fp.close()

# print(configuration)
# print(x)
# print(y)

colours = ListedColormap(["blue", "red", "green", "orange", "purple", "brown", "pink", "gray", "olive"])
values = list(range(0,9))

# colours = ["tab:blue", "tab:red", "tab:green", "tab:orange", "tab:purple", "tab:brown", "tab:pink", "tab:gray", "tab:olive"]


fig = plt.figure()
ax = fig.gca()

ax.set_xlabel("Memory accesses")
ax.set_ylabel("Memory footprint (KB)")
p=plt.scatter(x,y,c=values,cmap=colours)
plt.grid()
plt.legend(handles=p.legend_elements()[0], labels=configuration)


# mng = plt.get_current_fig_manager()
# mng.full_screen_toggle()
plt.show()

# plt.savefig("plot.png")
