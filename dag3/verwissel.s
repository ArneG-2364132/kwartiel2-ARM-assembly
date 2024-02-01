.extern printf

.data
string: .asciz "a = %d, b = %d\n"


.text

foute_verwissel:
    mov     R7,R5       @stop a in hulp
    mov     R5,R6       @stop b in a
    mov     R6,R7       @stop hulp in b
    bx      LR          @exit subroutine

juiste_verwissel:
    mov     R4,R0       @R4 (hulp) = R0 (a)
    mov     R0,R1       @R0 (a) = R1 (b)
    mov     R1,R4       @R1 (b) = R4 (hulp)
    bx      LR

.global main
main:

@ int a = 5;
@ int b = 10;


@R5 = int a = 5
mov     R5, #5
@R6 = int b = 10
mov     R6, #10

@ printf (“a = %d, b = %d\n”, a, b)
ldr     R0,=string
mov     R1,R5
mov     R2,R6
bl      printf
@ foute_verwissel (a, b)
bl      foute_verwissel

@ printf (“a = %d, b = %d\n”, a, b)
ldr     R0,=string
mov     R1,R5
mov     R2,R6
bl      printf

@ verwissel (&a, &b)
mov     R0,R5
mov     R1,R6  
bl      juiste_verwissel

@ printf (“a = %d, b = %d\n”, a, b)
@ R0 = a
@ R1 = b

mov     R4,R0
mov     R5,R1

ldr     R0,=string
mov     R1,R4
mov     R2,R5
bl      printf


@exit program:
mov	R0,#0	@0 as return code
mov	R7,#1	@sys_exit call
svc	0		@call linux
