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
    /* now r0 has the fd */
    mov r6, r0 /* save for later */

    mov r0, r6 /* call tclsetattr to set the settings for our port */
    mov r1, #0
    ldr r2, =options
    bl tcsetattr

    mov r0, r6
    ldr r1, =input
    mov r2, #64
    bl read

    ldr r0, =times
    mov r1, #0
init_times:
    mov r2, #0
    strb r2, [r0, r1]
    add r1, #1
    cmp r1, #256
    bne init_times

    ldr r0, =input
    ldr r1, =times
    mov r2, #0
    
_Iterate_input:    
    ldrb r3, [r0, r2] //r3 = character input

    cmp r3, #10
    beq next

    cmp r3, #32
    beq _Icrease_counter

    ldrb r4, [r1, r3]
    add r4, #1
    strb r4, [r1, r3]

_Icrease_counter:
    add r2, #1
    b _Iterate_input
next:
    mov r0, #-1  //max
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
    ldr r3, =res
    strb r2, [r3]
    strb r0, [r3, #2]
    
    mov r0, r6
    ldr r1, =res
    ldr r2, =len_res 
    bl write
    mov r0, r6
    bl close
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

