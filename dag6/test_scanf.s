.extern scanf
.extern printf
.text
.global main

main:
    @ Allocate space for the integer variable
    ldr R0, =input_str

    @ Call scanf to read an integer from the user
    ldr R1, =integer_var
    bl scanf

    @ Call printf to print the entered integer
    ldr R0, =format_str
    ldr R1, =integer_var
    ldr R1,[R1]
    bl printf

    @ Exit program
    mov R0, #0       @ Exit code 0
    mov R7, #1       @ Linux terminate system call
    svc 0            @ Call Linux

.data
    integer_var: .space 4  @ Variable to store the entered integer
    format_str: .asciz "%d\n"  @ Format string for printing an integer
    input_str: .asciz "%d"
