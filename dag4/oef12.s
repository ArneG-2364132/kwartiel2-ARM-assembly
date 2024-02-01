.extern printf


.text
@for (i=0;i<20;i+4)
@   for (j=0,j<20;j+4)
@       printf(%d,print_matrix[j][i])


.global main
main:
push {R4-R6, LR}

mov R6,#0       @initialize i counter
mov R5,#0       @initialize j counter
ldr R4,=matrix  @adres van 1ste element matrix laden


rijloop:        @i loop die over de rijen itereert  
    cmp R6,#5   @loop over i
    beq end     @op einde van matrix stoppen
    @printf("\n")
    add R6,#1   @ i +1
    mov R5,#0   @rijcounter gelijk aan nul

        elloop:         @loop over j
            cmp R5,#5   @als j gelijk aan 5 dan is rij overlopen
            beq rijloop @naar volgende rij gaan
            ldr R0,[R7] @string om uit te printen
            ldr R1,[R4] @ waarde van matrix om uit te printen
            bl printf   @
            add R4,#4   @ adres van volgend element in R4
            add R5,#1   @j+1

            b elloop @ volgend element in rij

end:

pop {R4-R6, LR}


@exit program:
mov	R0,#0	@0as return code
mov	R7,#1	@sys_exit call
svc	0	    @call linux

.data
matrix:    @5 by 5 matrix of 32-bit integers
    .word 1, 2, 3, 4, 5
    .word 6, 7, 8, 9, 10
    .word 11, 12, 13, 14, 15
    .word 16, 17, 18, 19, 20
    .word 21, 22, 23, 24, 25
string: .asciz "%d\n"



