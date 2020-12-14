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
init_finish:
    ldr r0, =input
    ldr r3, =times
    mov r1, #0

find_times:
    ldrb r2, [r0, r1] /* loads the character of the string with offset r1 */
    cmp r2, #10 /* since we have canonical input, the last useful char will be EOL */
    beq find_times_finish
    ldrb r4, [r3, r2] /* loads the value in the array with offset r2 (character that we read) */
    add r4, r4, #1 /* increment the times seen the character */
    strb r4, [r3, r2] /* save the value */
    add r1, r1, #1 /* move to the next char of our string */
    b find_times
find_times_finish:
    mov r1, #0
    mov r0, #0
    ldr r3, =times /* load array to r3 */
find_max:
    cmp r1, #32 /* 32 is the empty char (space), we ignore it */
    addeq r1, r1, #1
    ldrb r2, [r3, r1] /* Load value of array with offset r1*/
    cmp r0, r2 /* r0 holds the largest number seen */
    movlt r4, r1 /* if we find a char seen more times, we save the char */
    movlt r0, r2 /* and the times seen */
    add r1, r1, #1
    cmp r1, #256 /* When we reach the end of the array, exit */
    bne find_max
find_max_finish:
    mov r1, r4

    /* Now r0 holds the number of times char showed up  */
    /* r1 holds the character */
    /* r2 holds the number of bytes read (for debugging purposes) */
    /* save the values in our res array */
    /* since array is filled with the char 0, we need to find the actual number of occurances of the char so we subtract with the ASCII code */
//    sub r0, r0, #48
    ldr r3, =res
    strb r1, [r3]
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
    
    input: .asciz "\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0"

    .balign 1    
    times: .skip 255
    
    res: .ascii "a e\n\0"
    
    len_res = . - res

