.text
.align 4
.global strlen
.type strlen, %function
.global strcmp
.type strcmp, %function
.global strcat
.type strcat, %function
.global strcpy
.type strcpy, %function

strlen:
        push {r1-r2, lr}
        mov r1, #0
strlen_loop:
        ldrb r2, [r0, r1]
        cmp r2, #0
        addne r1, #1
        bne strlen_loop 
strlen_end:
        mov r0, r1
        pop {r1-r2, pc}

strcmp:
        push {r2-r5, lr}
        mov r2, #0
strcmp_loop:
        ldrb r3, [r0, r2]
        ldrb r4, [r1, r2]
        subs r5, r3, r4
        bne strcmp_end
        cmp r3, #0
        addne r2, #1
        bne strcmp_loop
strcmp_end:
        mov r0, r5
        pop {r2-r5, pc}

strcat:
        push {r2-r4, lr}
	    mov r2, #0
iterate_first:
	    ldrb r3, [r0, r2]
	    cmp r3, #0
	    addne r2, #1
	    bne iterate_first
	    mov r3, #0
iterate_second:
	    ldrb r4, [r1, r3]
	    strb r4, [r0, r2]
	    cmp r4, #0
	    addne r2, #1
	    addne r3, #1
	    bne iterate_second
strcat_end:
	    pop {r2-r4, pc}
 
strcpy:
        push {r2-r3, lr}
        mov r2, #0
iterate:
        ldrb r3, [r1, r2]
        strb r3, [r0, r2]
        cmp r3, #0
        addne r2, #1
        bne iterate
strcpy_end:
        pop {r2-r3, pc}



