@ Schrijf een ARM programma met declaraties in het .data
@ segment die overeenkomen met:
@ typedef struct{
@ int a;
@ char b[16];
@ } S;
@ S arr[3];
@ ... en vul deze datastructuur in het hoofdprogramma met
@ inhoud naar keuze. Voor de char velden gebruik je best extra
@ declaraties van strings, bijv.:
@ text_i: .asciz “aaa”
@ (enz.)
@ Print de gegevens naar stdout.


.extern printf
.extern scanf
.text
.global main
main:
@filling of array
@for (int i = 0;i<3;i++)
@   array[i].a=250+i
@   array[i].b=invoer

@R5=i
@R6=base adress of array
@R7=value to save in adress
mov R5,#0
ldr R6,=array

writeloop:
    cmp R5,#3
    bge endwriteloop

    add R7,R5,#250
    str R7,[R6],#4 @sla numerieke waarde op in adres (R6) en increment met 4
    
    ldr R0,=scanstring
    ldr R1,=invoer
    bl scanf



    ldr R7,=invoer
    ldr R7,[R7]
    str R7,[R6], #16 @ string waarde in adres opslaan

    add R5,#1
    b writeloop

endwriteloop:



@for (int i = 0;i<3;i++)
@   printf(f_str,i,arr[i].a,arr[i].b)
@R0=f_str
@R1=i (counter)
@R2=arr[i].a
@R3=arr[i].b
@R5=base adress of array
@R6 = counter i
ldr R5,=array

mov     R6,#0
printloop:
    cmp R6,#3
    bge endprintloop
    ldr R0,=f_str
    mov R1,R6
    ldr R2,[R5],#4  @ #4 does a post increment of the adress
    mov R3,R5       @load memory value of asciz (same as ldr R3,=memadress)
    add R5,#16    @increment memory adress sixteen characters
    bl printf
    add R6,#1
    b printloop


endprintloop:


@exit program
    mov R0,#0 @exit code 0
    mov R7,#1 @linux terminate system call
    svc 0 @call linux

.data
array:
    .word 0              @ array[0].a
    .space 16      @ array[0].b
    .word 0              @ array[1].a
    .space 16      @ array[0].b
    .word 0              @ array[2].a
    .space 16      @ array[0].b

f_str:  .asciz "element %d, a: %d, b: %s\n"
invoer: .space 16  @ Padding for the maximum length of b
scanstring: .asciz "%s"

