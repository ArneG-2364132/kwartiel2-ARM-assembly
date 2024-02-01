.extern printf
.text
.global main

main:
    @ Filling of array
    mov R5, #0
    ldr R6, =array

writeloop:
    cmp R5, #3
    bge endwriteloop

    add R7, R5, #250
    str R7, [R6], #4   @ Store numeric value in address (increment by 4 bytes)
    
    ldr R7, =invoer
    str R7, [R6], #16  @ Store string value in address (increment by 16 bytes)

    add R5, R5, #1
    b writeloop

endwriteloop:

    @ For printing
    ldr R5, =array
    mov R6, #0

printloop:
    cmp R6, #3
    bge endprintloop

    ldr R0, =f_str
    mov R1, R6
    ldr R2, [R5], #4    @ Load numeric value
    ldr R3, [R5], #16   @ Load address of string
    bl printf

    add R6, R6, #1
    b printloop

endprintloop:

    @ Exit program
    mov R0, #0       @ Exit code 0
    mov R7, #1       @ Linux terminate system call
    svc 0            @ Call Linux

.data
array:
    .word 0              @ array[0].a
    .word 0              @ Padding for alignment
    .asciz "invoer1"      @ array[0].b
    .word 0              @ array[1].a
    .word 0              @ Padding for alignment
    .asciz "invoer2"      @ array[1].b
    .word 0              @ array[2].a
    .word 0              @ Padding for alignment
    .asciz "invoer3"      @ array[2].b

f_str:  .asciz "element %d, a: %d, b: %s\n"

invoer: .asciz "               "  @ Padding for the maximum length of b
