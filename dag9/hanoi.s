.extern printf
.extern scanf

.data
f_str:  .asciz "Verplaats schijf %d van stok %d naar stok %d\n"
schijven:   .word   0
scanf_str:  .asciz "%d"
prompt: .asciz "geef aantal schijven\n>> "


.macro print_hanoi
    ldr R0,=f_str
    mov R1,R4   @1ste param
    mov R2,R5   @2de param
    mov R3,R6  @3de param
    bl printf
.endm

.text
.global main
main:

    ldr R0,=prompt
    bl printf

    ldr R0,=scanf_str @ vraag naar aantal schijven
    ldr R1,=schijven
    bl scanf

    ldr R1,=schijven @laad adres van schijven opnieuw in R1

    @roep hanoi-functie aan
    ldr R0,[R1] @ sla aantal schijven op in R0
    mov R1,#1
    mov R2,#3
    bl hanoi

    @exit to linux
    mov R7,#1
    mov R0,#0
    svc 0

hanoi:
    push {R4-R9,LR}
    @input:
    @R0=aantal schijven
    @R1=bron
    @R2=bestemming
    @
    @output:

    @R9=inbetween=6-source-destination

    @R4=kopie aantal schijven
    mov R4,R0
    @R5=kopie bron
    mov R5,R1
    @R6=kopie bestemming
    mov R6,R2
    @R7 = source + destination

    @R8 = 6
    mov R8,#6

    @check voor basecase
    cmp R0,#1
    beq basecase

    @R9=inbetween=6-source-destination
    add R7,R5,R6 @dont change R1 and R2
    sub R9,R8,R7 @ 6-(source+destination)

    @hanoi (n-1,source,inbetween)
    sub R0,#1
    @R1 blijf source
    mov R1,R5
    mov R2,R9   @destination wordt inbetween
    bl hanoi 

    @ PRINTF (F_STR,N,SOURCE,DEST) (R4,R5,R6)
    print_hanoi


    @hanoi (n-1,source,inbetween)
    sub R0,#1
    mov R1,R9
    mov R2,R6
    bl hanoi
    
    pop {R4-R9,LR}
    bx LR

basecase:

    print_hanoi @(R4,R5,R6)
    pop {R4-R9,LR}
    bx LR
