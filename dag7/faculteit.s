.extern printf

.data
vraag_str:  .asciz "Van welk positief getal moet ik de faculteit berekenen\n>> "
scanf_str:  .asciz "%d"
getal:      .word   0
fac_str:    .asciz "De faculteit van %d is %d\n"
.text
.global main

main:
    ldr R0,=vraag_str
    bl printf

    ldr R0,=scanf_str
    ldr R1,=getal @ sla gevraagd getal op in "getal"
    bl scanf


    ldr R1,=getal @dit is nodig om segm. fault te vermijden
    ldr R0,[R1] @ laad getal in R0

    bl faculteit @input (getal R0) output (faculteit in R0)

    mov R2,R0
    ldr R0,=fac_str
    ldr R1,=getal
    ldr R1,[R1]
    bl printf

    mov R7,#1
    mov R0,#0
    svc 0


faculteit:
@recursieve functie die fac berekent 
@input: R0=getal
@ output: faculteit van getal -1

@ R4=kopie van R0

@if R0==1
    @return R0
@ else:
@     R1=faculteit(R0)
@     return (R0*R1)
    push {R4,LR}

    cmp R0,#1
    beq basecase

    mov R4,R0
    sub R0,#1 @n-1=R0
    bl faculteit @recursief
    mul R0,R4,R0 @ n * (n-1)!

    pop {R4,LR}
    bx LR

basecase:
    mov R0,#1
    pop {R4,LR}
    bx LR

