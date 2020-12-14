# SCP File Sharing


### Start qemu
```
alias start-arm="qemu-system-arm -M versatilepb -kernel vmlinuz-3.2.0-4-versatile -initrd initrd.img-3.2.0-4-versatile -hda  debian_wheezy_armel_standard.qcow2 -append "root=/dev/sda1" -net nic -net user,hostfwd=tcp:127.0.0.1:22223-:22"
```

serial port option
```
-serial pty
```

### Local -> arm (

From the `src` directory on local to transfer the `src` directory on remote:


```
rsync -vr -e "ssh -p 22223" . root@localhost:/root/src
```
To delete target files before sent
```
--delete
```

### arm -> Local 
From the `src` directory on local to transfer the `src` directory on remote:

```
rsync -vr -e "ssh -p 22223" root@localhost:/root/src/ .
```

To connect without root password (host):
```
ssh-copy-id -p 22223 root@localhost
```

