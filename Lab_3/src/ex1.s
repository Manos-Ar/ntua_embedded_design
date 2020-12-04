.text
        .global main
        .extern printf
        .extern scanf
        b main

transform:
        //save register state
        push {r0-r7, lr}
transform_begin:
        //r1 = user_input[0]
        ldrb r1, [r0, #0]
        //if(r1=='\0') go to transform end 
        cmp r1, #0
        beq transform_end
        //if(r1>'z') go to increase_counter
        cmp r1, #122
        bgt incr_counter
        //if(r1>='a') r1-=32, go to substitute
        cmp r1, #97
        subge r1, r1, #32
        bge substitute
        //if(r1>'Z') go to increase_counter
        cmp r1, #90
        bgt incr_counter
        //if(r1>='A') r1+=32, go to substitute
        cmp r1, #65
        addge r1, r1, #32
        bge substitute
        //if(r1>'9') go to increase_counter
        cmp r1, #57
        bgt incr_counter
        //if(r1<'0') go to increase_counter
        cmp r1, #48
        blt incr_counter
        //r1+=5
        add r1, r1, #5
        //if(r1>'9') r1-=10
        cmp r1, #57
        subgt r1, r1, #10
substitute:
        //user_input[0]=r1
        strb r1, [r0, #0]
incr_counter:
        //user_input++
        add r0, r0, #1
        //continue transformation
        b transform_begin
transform_end:
        //printf("Result is: ")
        ldr r0, =result
        bl printf
        //printf("%s\n\n", user_input)
        ldr r0, =format_string
        ldr r1, =user_input
        bl printf
        //retrive registers and update program counter
        pop {r0-r7, pc}


main:
        //printf("Input a string of up to 32 chars long: ")
        ldr r0, =prompt
        bl printf
        //scanf("%32[^\n]", user_input) read up to 32 characters until new line is read
        ldr r0, =format_input
        ldr r1, =user_input
        bl scanf
        //do {
        //      scanf("%c", tmp);
        //} while(tmp[0]!='\n');
        //get rid of left over characters until we reach new line
get_full_input:
        ldr r0, =format_char
        ldr r1, =tmp
        bl scanf
        ldr r0, =tmp
        ldrb r1, [r0, #0]
        cmp r1, #10
        bne get_full_input
        //if(user_input[0]=='Q' || user_input[0]=='q') go to check_end
        //check termination condition
        ldr r0, =user_input
        ldrb r1, [r0, #0]
        cmp r1, #81
        beq check_end
        cmp r1, #113
        beq check_end
        //r0 = user_input, call transform
        ldr r0, =user_input
        bl transform
        //start again from the beginning
        b main
check_end:
        //if(user_input[1]=='\0') go to end
        //if user gave only Q or q finish else transform
        ldrb r1, [r0, #1]
        cmp r1, #0
        beq end
        //r0 = user_input, call transform
        ldr r0, =user_input
        bl transform
        //start again from the beginning
        b main
end:
        //printf("Exiting....\n\n")
        ldr r0, = exit_msg
        bl printf
        //exit(0)
        mov r0, #0
        mov r7, #1
        swi 0

.data
        format_string: .string "%s\n\n"
        format_input: .string "%32[^\n]"
        format_char: .string "%c"
        prompt: .string "Input a string of up to 32 chars long: "
        result: .string "Result is: "
        exit_msg: .string "Exiting....\n\n"
        tmp: .asciz "7"
        user_input: .word 33