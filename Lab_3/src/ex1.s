.text
        .global main
        .extern printf
        .extern scanf

main:
        ldr r0, =prompt
        bl printf
        ldr r0, =format_input
        ldr r1, =user_input
        bl scanf
get_full_input:
        ldr r0, =format_char
        ldr r1, =tmp
        bl scanf
        ldr r0, =tmp
        ldrb r1, [r0, #0]
        cmp r1, #10
        bne get_full_input
        ldr r0, =user_input
        ldrb r1, [r0, #0]
        cmp r1, #81
        beq check_end
        cmp r1, #113
        beq check_end
transform:
        ldr r0, =user_input
transform_begin:
        ldrb r1, [r0, #0]
        cmp r1, #0
        beq transform_end
        cmp r1, #122
        bgt incr_counter
        cmp r1, #97
        subge r1, r1, #32
        bge substitute
        cmp r1, #90
        bgt incr_counter
        cmp r1, #65
        addge r1, r1, #32
        bge substitute
        cmp r1, #57
        bgt incr_counter
        cmp r1, #48
        blt incr_counter
        add r1, r1, #5
        cmp r1, #57
        subgt r1, r1, #10
substitute:
        strb r1, [r0, #0]
incr_counter:
        add r0, r0, #1
        b transform_begin
transform_end:
        ldr r0, =result
        bl printf
        ldr r0, =format_string
        ldr r1, =user_input
        bl printf
        b main
check_end:
        ldrb r1, [r0, #1]
        cmp r1, #0
        bne transform
end:
        ldr r0, = exit_msg
        bl printf
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