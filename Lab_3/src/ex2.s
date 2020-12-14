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
    ldr r0, =device /* device to open */
    ldr r1, =#258 /* permissions blocking */
    bl open

    ldr r1, =fd
    str r0, [r1]

    mov r1, #0
    ldr r2, =options
    bl tcsetattr

    cmp r0, #0
    bge _Read

    ldr r0, =error_msg
    bl printf
    mov r0, #0
    mov r7, #1
    swi 0

_Read:
    ldr r0, =fd
    ldr r0, [r0]
    ldr r1, =input
    mov r2, #64
    bl read

    cmp r0 , #0
    blt _Read

 //   ldr r0, =rd
 //   mov r1, r0
 //   bl printf

    ldr r0, =input_str
    ldr r1, =input
    bl printf


    ldr r0, =times
    mov r1, #0
    mov r2, #0
_Init_times:
    strb r2, [r0, r1]
    add r1, #1
    cmp r1, #256
    bne _Init_times

    ldr r0, =input
    ldr r1, =times
    mov r2, #0
    
_Iterate_input:    
    ldrb r3, [r0, r2] //r3 = character input

    cmp r3, #10
    beq _Init_max

    cmp r3, #32
    beq _Icrease_counter

    ldrb r4, [r1, r3]
    add r4, #1
    strb r4, [r1, r3]

_Icrease_counter:
    add r2, #1
    b _Iterate_input

_Init_max:
    mov r0, #0  //max
    mov r2, #0  //char
    mov r3, #0  // index
    //r4 = tmp

_Find_max:
    ldrb r4, [r1, r3]

    cmp r0, r4
    movlt r0, r4
    movlt r2, r3
    add r3, #1
    cmp r3, #256
    bne _Find_max

    mov r1, r0
_Output:
    ldr r0, =output_str
    bl printf
    mov r0, #0
    mov r7, #1
    swi 0



.data
    options: .word 0x00000000 /* c_iflag */
             .word 0x00000004 /* c_oflag */
             .word 0x000008bd /* c_cflag */
             .word 0x00000a22 /* c_lflag */
             .byte 0x00       /* c_line */
             .word 0x00000000 /* c_cc[0-3] */
             .word 0x0064ff00 /* c_cc[4-7] */
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
    
    input_str: .string "input: %s"
    
    output_str: .string "output: max: %d char: %d\n"
    
//    times_str: .string "value: %d char: %d\n"
    

    fd: .word 0
    
    error_msg: .string "Error. Didnt config\n"

    .balign 1
    output: .skip 2
    .balign 1 
    input: .skip 64

    .byte    
    times: .skip 256
    
//    res: .ascii "a e\n\0"
    
//    len_res = . - res

