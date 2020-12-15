# SCP File Sharing

### Local -> arm (

From the `src` directory on local to transfer the `src` directory on remote:


```
rsync -vr -e "ssh -p 22223" . root@localhost:/root/
```

### Delete option
--delete 

### arm -> Local 
From the `src` directory on local to transfer the `src` directory on remote:

```
rsync -vr -e "ssh -p 22223" root@localhost:/root/ .
```

To connect without root password (host):
```
ssh-copy-id -p 22223 root@localhost
```