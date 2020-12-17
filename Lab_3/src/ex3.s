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


//strlen(s)
//r0 holds the address of s
strlen:
		//save registers
        push {r1-r2, lr}
        //index=0
        mov r1, #0
strlen_loop:
		//r2 = s[index]
        ldrb r2, [r0, r1]
        //if(r2!=0) index++, go to strlen_loop
        cmp r2, #0
        addne r1, #1
        bne strlen_loop 
strlen_end:
		//r0 = index, index is equal to length
        mov r0, r1
        //retrieve registers and return
        pop {r1-r2, pc}


//strcmp(s1, s2)
//r0 holds the address of s1, r1 holds the address of s2
strcmp:
		//save registers
        push {r2-r5, lr}
        //index=0
        mov r2, #0
strcmp_loop:
		//r3 = s1[index]
		//r4 = s2[index]
        ldrb r3, [r0, r2]
        ldrb r4, [r1, r2]
        //r5 = r3 - r4
        subs r5, r3, r4
        //if(r5!=0) go to strcmp_end
        bne strcmp_end
        //if(r3!=0) index++, go to strcmp_loop
        cmp r3, #0
        addne r2, #1
        bne strcmp_loop
strcmp_end:
		//r0 = r5
        mov r0, r5
        //retrieve registers and return
        pop {r2-r5, pc}



//strcat(s1, s2)
//r0 holds the address of s1, r1 holds the address of s2
strcat:
		//save registers
        push {r2-r4, lr}
        //index1=0
	    mov r2, #0
iterate_first:
		//r3 = s1[index1]
	    ldrb r3, [r0, r2]
	    //if(r3!=0) index1++, go to iterate_first
	    cmp r3, #0
	    addne r2, #1
	    bne iterate_first
	    //index2 = 0
	    mov r3, #0
iterate_second:
		//r4 = s2[index2]
	    ldrb r4, [r1, r3]
	    //s1[index1] = r4
	    strb r4, [r0, r2]
	    //if(r4!=0) index1++, index2++, go to iterate_second
	    cmp r4, #0
	    addne r2, #1
	    addne r3, #1
	    bne iterate_second
strcat_end:
		//s1 is already in s0
		//retrieve registers and return
	    pop {r2-r4, pc}



//strcpy(s1, s2)
//r0 holds the address of s1, r1 holds the address of s2
strcpy:
		//save registers
        push {r2-r3, lr}
        //index=0
        mov r2, #0
iterate:
		//r3 = s2[index]
        ldrb r3, [r1, r2]
        //s1[index] = r3
        strb r3, [r0, r2]
        //if(r3!=0) index++, go to iterate
        cmp r3, #0
        addne r2, #1
        bne iterate
strcpy_end:
		//s1 is already in s0
		//retrieve registers and return
        pop {r2-r3, pc}



