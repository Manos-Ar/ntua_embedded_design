.text 
    .global main
    .extern tcsetattr
    .extern printf
    .extern fncntl
    .extern open
    .extern read
    .extern write
    .extern close
    b main


main:
	//r0 = "/dev/ttyAMA0"
    ldr r0, =device
    //r1 = O_RDWR | O_NOCTTY
    ldr r1, =#258
    //r0 = open("/dev/ttyAMA0", O_RDWR | O_NOCTTY)
    bl open
    //r6 = fd
    mov r6, r0
    //apply options
    //tcsetattr(fd, 0, &options)
    mov r0, r6
    mov r1, #0
    ldr r2, =options
    bl tcsetattr
    //read host message
    //read(fd, input, 64)
    mov r0, r6
    ldr r1, =input
    mov r2, #64
    bl read
    //initialize times
    //r0 = times
    ldr r0, =times
    //index = 0
    mov r1, #0
    //r2 = 0
    mov r2, #0
init_times:
	//times[index] = 0
    strb r2, [r0, r1]
    //index++
    add r1, #1
    //if(index!=256) go to init_times
    cmp r1, #256
    bne init_times
    //r0 = input
    ldr r0, =input
    //r1 = times
    ldr r1, =times
    //index = 0
    mov r2, #0
_Iterate_input:
	//r3 = input[index]
    ldrb r3, [r0, r2]
    //if(r3=='\n') go to next 
    cmp r3, #10
    beq next
    //if(r3==' ') go to _Icrease_counter
    cmp r3, #32
    beq _Icrease_counter
    //times[r3]++
    ldrb r4, [r1, r3]
    add r4, #1
    strb r4, [r1, r3]
_Icrease_counter:
	//index++
    add r2, #1
    //go to _Iterate_input
    b _Iterate_input
next:
    mov r0, #-1  //max
    mov r2, #0  //char
    mov r3, #0  // index
_Find_max:
	//r4 = times[index]
    ldrb r4, [r1, r3]
    //if(max<r4) max=r4, char=r3
    cmp r0, r4
    movlt r0, r4
    movlt r2, r3
    //index++
    add r3, #1
    //if(index!=256) go to _Find_max
    cmp r3, #256
    bne _Find_max
    //res[0] = char
    //res[2] = max
    ldr r3, =res
    strb r2, [r3]
    strb r0, [r3, #2]
    //write(fd, res, len_res)
    mov r0, r6
    ldr r1, =res
    ldr r2, =len_res 
    bl write
    //close(fd)
    mov r0, r6
    bl close
    //return 0
    mov r0, #0
    mov r7, #1
    swi 0

.data
    options: .word 0x00000000 /* c_iflag */
             .word 0x00000004 /* c_oflag */
             .word 0x000008bd /* c_cflag */
             .word 0x00000a32 /* c_lflag */
             .byte 0x00       /* c_line */
             .word 0x00000000 /* c_cc[0-3] */
             .word 0x00000000 /* c_cc[4-7] */
             .word 0x00000000 /* c_cc[8-11] */
             .word 0x00000000 /* c_cc[12-15] */
             .word 0x00000000 /* c_cc[16-19] */
             .word 0x00000000 /* c_cc[20-23] */
             .word 0x00000000 /* c_cc[24-27] */
             .word 0x00000000 /* c_cc[28-31] */
             .byte 0x00       /* padding */
             .hword 0x0000    /* padding */
             .word 0x0000000d /* c_ispeed */
             .word 0x0000000d /* c_ospeed */
    
    device: .asciz "/dev/ttyAMA0"
    
    input: .asciz "\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0"
    
    res: .ascii "_ _\n\0"
    
    len_res = . - res

    .byte
    times: .skip 256

