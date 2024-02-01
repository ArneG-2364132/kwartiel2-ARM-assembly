.data
str: .asciz "%d\t%d\t%d\t%d\t%d\n" @5 elementen tonen
.text
.extern printf
.global main
main:

ldr R0,=str
mov R1,#1
mov R2,#2
mov R3,#3
mov R4,#4
mov R5,#5

@ sub SP,#8

@ str R4,[SP]
@ str R5,[SP,#4]
push {R4,R5}
bl printf

@ add SP,#8
pop {R4,R5}

mov R7,#1
mov R0,#0
svc 0
