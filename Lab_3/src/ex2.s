.text
        .global main
        .extern printf
        .extern open
        .extern read
        .extern write
        .extern close
        b main

main:


    mov r0 , #02     //O_RDWR
    mov r1 , #0400   //O_NOCTTY
    orr r0, r0, r1   
    mov r1, #04000   //O_NONBLOCK
    orr r0, r0, r1
    
    mov r1, r0     //r1 = O_RDWR | O_NOCTTY | O_NONBLOCK
    ldr r0, =device //r0 = "/dev/pts/0"
    bl open
    //r0 = fd
    ldr r1, =fd  
    str r0, [r1]

    ldr r0, =fd_str
    ldr r1, =fd
    ldr r1, [r1]
    bl printf


read:
    ldr r0, =fd
    ldr r0, [r0]
    ldr r1, =input
    mov r2, #64
    bl read
    //read(fd,input,64)
    cmp r0, #0
    blt read //rd=-1 => didnt read
    
    mov r1, r0
    ldr r0, =fd_str
    bl printf

    mov r0, #0
    mov r7, #1
    swi 0

.data
        fd_str: .string "fd: %d\n" 
        rd: .string "read %d values\n"
        device: .string "/dev/pts/0"
        fd : .word 0
        .balign 1
        input: .skip 64
        


        options:
            .word 0x00000000 /* c_iflag */
            .word 0x00000000 /* c_oflag */
            .word 0x00000000 /* c_cflag */
            .word 0x00000000 /* c_lflag */
            .byte 0x00
            /* c_line */
            .word 0x00000000 /* c_cc[0-3] */
            .word 0x00000000 /* c_cc[4-7] */
            .word 0x00000000 /* c_cc[8-11] */
            .word 0x00000000 /* c_cc[12-15] */
            .word 0x00000000 /* c_cc[16-19] */
            .word 0x00000000 /* c_cc[20-23] */
            .word 0x00000000 /* c_cc[24-27] */
            .word 0x00000000 /* c_cc[28-31] */
            .byte 0x00
            /* padding */
            .hword 0x0000 /* padding */
            .word 0x00000000 /* c_ispeed */
            .word 0x00000000 /* c_ospeed */
