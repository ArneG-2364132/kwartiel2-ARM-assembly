.extern printf


.text
is_equal:
@uitvoer gelijk of ongelijk in string
 





change_matrix:
@input:
    @R0=startadres matrix
    @R1=rij (R1*(5*4=20)) +startadres
    @R2=kolom (R2*4)+startadres
    @R3=waarde voor kolom
@aangepast
    @R4=alle offsets
    @R5=20
    mov R5,#20
    @R6=4
    mov R6,#4

    
    @bepaal adres om te overschrijven
    mul    R1,R5   @rij offsett van startadres
    mul    R2,R6   @bepaal element offset van startadres
    add    R4,R1,R2 @tel beide offsets op
    add    R0,R4    @voeg beide offsets toe aan startadres
    str    R3,[R0]    @sla waarde op in startadres+offset
    bx LR

@for (i=0;i<20;i+4)
@   for (j=0,j<20;j+4)
@       printf(%d,print_matrix[j][i])

print_matrix:
push {R4-R6, LR}

mov R6,#0       @initialize i counter
mov R5,#0       @initialize j counter
ldr R4,=matrix  @adres van 1ste element matrix laden

rijloop:        @i loop die over de rijen itereert  
    
    cmp R6,#5   @loop over i
    beq end     @op einde van matrix stoppen

        elloop:         @loop over j
            cmp R5,#5   @als j gelijk aan 5 dan is rij overlopen
            beq endrow  @naar volgende rij gaan
            
            ldr R0,=string  @string om uit te printen
            ldr R1,[R4]     @ waarde van matrix om uit te printen
            bl printf       @

            add R4,#4       @ adres van volgend element in R4
            add R5,#1       @j+1

            b elloop        @ volgend element in rij


endrow:
    add R6,#1   @ i +1
    mov R5,#0   @rijcounter gelijk aan nul
    ldr R0,=string2
    bl printf
    b rijloop
end:

pop {R4-R6, LR}
bx LR @back to main function


.global main
main:
bl print_matrix

ldr R0,=matrix
mov R1,#4
mov R2,#4
mov R3,#69
bl change_matrix

bl print_matrix


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
string: .asciz "%d\t"
string2: .asciz "\n"
gelijk: .space 64



