.extern printf


.text
transponatie:


@ for (i=0;i<3;i++)
@     for (j=0;j<3)
@         m1[i][j]=m2[j][i]

push {R4-R10,LR}
@R0=bronmatrix
@R1=bestemmingsmatrix
@R4=i=rijaanduiding van 4 naar 0
mov R4,#4
@R5=j=kolomaanduiding van 4 naar 0
mov R5,#4
@R6=element van matrix
@R7=20=offsett per rij
mov R7,#20
@R8 = 4 = ofset per element
mov R8,#4
@R9= rijoffset
@R10=kolomoffset (+ rijoffset=totale offset)


rijlooptrans:
    cmp R4,#0
    blt endtrans

kolomlooptrans:
    cmp R5,#0
    blt endkolomtrans
    
    ldr R6,[R0],#4 @ laad element matrix + icrement met 4 bytes

    @rijoffset bepalen
    mul R9,R4,R7

    @kolomoffset bepalen
    mul R10,R5,R8
    @totale offset
    add R10,R9
    
    str R6,[R1,R10]     @ sla element op op juiste plaats in nieuwe matrix
                        @ basisadres + offset
    sub R5,#1
    b   kolomlooptrans


endkolomtrans:
    mov R5,#4
    sub R4,#1
    bl rijlooptrans

endtrans:
    pop {R4-R10,LR}
    bx LR

is_equal:
@uitvoer gelijk of ongelijk in string
@ for (int i = 0;i<5;i++)
    @for (int j=0;j<5;j++)
        @ if matrix1[j][i] != matrix2[j][i]
        @     printf("ongelijk")


@R0 = * naar matrix 1
@R1= * naar matrix2

@R6=element 1ste matrix
@R7=element 2de matrix
push {R4-R7,LR}
@R4=i
mov R4,#0
@R5=j
mov R5,#0

rijloopeq:
    cmp R4,#5
    beq gelijkeq

kolomloopeq:
    cmp R5,#5
    beq endkolomeq
    
    ldr R6,[R0],#4 @ laad element 1ste matrix + icrement met 4 bytes
    ldr R7,[R1],#4 @ laad element 2de matrix + increment met 4 bytes

    cmp R6,R7
    bne nietgelijk

    add R5,#1
    b   kolomloopeq


endkolomeq:
    mov R5,#0
    add R4,#1
    bl rijloopeq

gelijkeq:
    ldr R0,=str_gelijk
    bl printf
    pop {R4-R7,LR}
    bx LR

nietgelijk:
    ldr R0,=str_ongelijk
    bl printf
    pop {R4-R7,LR}
    bx LR

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
@R0=adres van 1ste element matrix
push {R4-R6, LR}

mov R6,#0       @initialize i counter
mov R5,#0       @initialize j counter
mov R4,R0 @laad adres in R4

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
ldr R0,=matrix
bl print_matrix

@roep vergelijking van matrixen
ldr R0,=matrix
ldr R1,=matrix2
bl is_equal


ldr R0,=matrix
mov R1,#4
mov R2,#4
mov R3,#69
bl change_matrix

ldr R0,=matrix
bl print_matrix

ldr R0,=matrix
ldr R1,=matrix2
bl is_equal


@transponatie
ldr R0,=matrix
ldr R1,=matrix3
bl transponatie

@print matrix 3
ldr R0,=matrix3
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



matrix2:        @5 by 5 matrix of 32-bit integers
    .word 1, 2, 3, 4, 5
    .word 6, 7, 8, 9, 10
    .word 11, 12, 13, 14, 15
    .word 16, 17, 18, 19, 20
    .word 21, 22, 23, 24, 25
string: .asciz "%d\t"
string2: .asciz "\n"
gelijk: .space 64
str_gelijk: .asciz "Matrix 1 en 2 zijn gelijk aan elkaar.\n"
str_ongelijk: .asciz "Matrix 1 en 2 zijn niet gelijk aan elkaar.\n"

matrix3:     
    .word 1, 2, 3, 4, 5
    .word 6, 7, 8, 9, 10
    .word 11, 12, 13, 14, 15
    .word 16, 17, 18, 19, 20
    .word 21, 22, 23, 24, 25
