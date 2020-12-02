# SCP File Sharing

### Local -> arm (

From the `src` directory on local to transfer the `src` directory on remote:

Delete `src` to  remote before scp

```
scp -P 22223 -r . root@localhost:/root/src
```


### arm -> Local 
From the `src` directory on local to transfer the `src` directory on remote:

```
scp -P 22223 -r /src root@localhost:/root/src /home/manos/Desktop
```

