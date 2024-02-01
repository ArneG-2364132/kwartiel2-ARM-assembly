.extern printf

.data
string: .asciz "Aantal getallen: %d. Aantal oneven getallen: %d\n"
array:
        .word 1,2,3,4,5,6,7,8,9, 10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,0
.text

count:
        mov     R1,#0   @initialiseer counter
        mov     R2,#0   @initialiseer oneven counter
        ldr     R6,[R0],#4  @laad in R6 de waarde van het eerste element

vergelijk:  cmp     R6,#0   @check of element van array gelijk is aan 0 ->eindigen
            beq     end
            add     R1,#1
            @pariteit van het getal checken door -2 te doen todat we -1 (= oneven) 0 (= even) bekomt
            mov     R7,R6               @R7 is hulp var
            while:  cmp     R7,#1       @R7 vergelijken met 0
                    beq     oneven        @R7 == 0    => branchen naar even (even coutnter++)
                    cmp     R7,#0
                    beq     rijschuiven
                    sub     R7,#2       @R7 > 0     => R7 -= 2 
                    b       while       @R7 > 0     => terug de while loop uitvoeren
        
            oneven: add     R2,#1       @oneven_teller++
                    b       rijschuiven

            rijschuiven:    
                            ldr     R6,[R0],#4
                            b       vergelijk

end:    bx      LR      @link register program counter terug naar waar je bl hebt opgeroept


.global main
main:
ldr     R0,=array @laad het adres van 1ste element in array in R0
bl      count     @R1 = even, R2 = oneven (counters)

ldr     R0,=string
bl      printf


@exit program:
mov	R0,#0	@0 as return code
mov	R7,#1	@sys_exit call
svc	0		@call linux
