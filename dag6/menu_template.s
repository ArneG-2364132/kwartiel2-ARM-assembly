@ ARM asm program using menu to manipulate
@ a static data structure
@
@ R4: aantal rijen
@ R0: address format string printf() & scanf()
@ R1: address command & commmand
@
@ aantal_rijen = -1
@ repeat
@   print (menu)
@   lees (command)
@   if command == 0
@     break
@   elif command == 1
@     voegtoe_rij ()
@   elif command == 2
@     print_rij ()
@   elif command == 3
@     wijzig_rij ()
@   else
@     printf ('fout commando')

.extern printf
.extern scanf

.macro	debug 	Ri
	push	{R0-R3,R12,LR}	@ save Regs to stack
	ldr	R0, =debugmsg	@ address debugmsg
	mov	R1, \Ri		@ register to printf
	bl	printf		@ call printf()
	pop	{R0-R3,R12,LR}	@ restor Regs from stack
.endm

.text
.global main
main:
	mov	R4, #-1		@ aantal_rijen = -1
				@ (= no rijen in use)
repeat:
	ldr	R0, =menu	@ load address menu
	bl	printf		@ printf (menu)

	ldr	R0, =f_str_i	@ load address format string
	ldr	R1, =command	@ load address command number
	bl 	scanf		@ input command number

	ldr	R1, =command	@ load address command
	ldr	R1, [R1]	@ load command

	cmp	R1, #0		@ command cmp 0 ?
	beq	end_prog	@ program done
	cmp	R1, #1		@ command cmp 1 ?
	bne	elif1		@ command != 1 -> elif1
	bl	voegtoe_rij	@ voegtoe_rij()
	b	end_if
elif1:	cmp	R1, #2		@ command cmp 2 ?
	bne	elif2		@ command != 2 -> elif2
	bl	print_rij	@ print_rij()
	b	end_if
elif2:	cmp	R1, #3		@ command cmp 3 ?
	bne	elif3		@ command != 3 -> elif3
	bl	wijzig_rij	@ wijzig_rij()
	b	end_if
elif3:	ldr	R0, =fout	@ load address fout
	bl	printf		@ printf (fout)

end_if:
	b 	repeat		@ next repeat

end_prog:
@ parameters to exit the program
	mov 	R0, #0		@ exit code 0
	mov 	R7, #1		@ Linux terminate system call
	svc 	0		@ call Linux


@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@ voegtoe_rij()
@ pseudo code & register use
@ struct array{
@ 	naam (32)
@ 	leeftijd (4)
@ 	stad (28)}
@scanf(%s,&naam)
@array.naam[i]=naam

@scanf(%d,&leeftijd)
@array.leeftijd[i]=leeftijd
@scanf(%s,&stad)
@array.stad[i]=stad
@i++


@R0=format strings
@R1=waarde
@R4 blijft aantal rijen
@R5=adres van rijen
@R6= adres and value of 'stad'

voegtoe_rij:
	push	{R5-R6,LR}

	ldr R5,=rijen

	ldr R0,=naam_vraag
	bl printf @vraag naar naam

	ldr R0,=f_str_string
	ldr R1,=naam
	bl scanf
	ldr R1,=naam
	ldr R1,[R1]
	str R1,[R5],#4

	ldr R0,=leeftijd_vraag
	bl printf @vraag naar leeftijd
	ldr R0,=f_str_i
	ldr R1,=leeftijd
	bl scanf
	
	ldr R1,=leeftijd
	ldr R6,[R1]
	

	ldr R0,=stad_vraag
	bl printf @vraag naar stad
	ldr R0,=f_str_string
	ldr R1,=stad
	bl scanf

	ldr R1,=stad
	ldr R1,[R1]

	@Shift the word to the left by 4 bits and OR with the age
	lsl R6, R6,#28 @(enkel 4 kleinste bits behouden)
	ror R6,R6,#28 @ 4 bits terug rechts zetten

    lsl R1, R1, #8 @opschuiven naar links met 4 bits + 4 bits 0 maken (onbruikbaar)
	 
    orr R1, R1,R6 	@ orr instruction doet bitwise or -> combinatie van leeftijd met stad
	@ links stad, 4 nullen, rechts leeftijd
	str R1,[R5],#4


	ldr	R0, =dummy1	@ address dummy1
	bl	printf		@ call printf()
	pop	{R5-R6,LR}
	bx	LR

@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@ print_rij()
@ pseudo code & register use
@printf("geef rij (0-4)")
@scanf (%d,&rtoprint)
@
@printf(row,%d >> name: %s\tage: %d\tcity: %s,rtoprint,rijen.naam[rtoprint],rijen.leeftijd[rtoprint],rijen.stad[rtoprint])

@R0=f_string
@R1=rijen.naam[rtoprint]
@R2=rijen.leeftijd[rtoprint]
@R3=rijen.stad[rtoprint]
@R4=rtoprint /memory offset
@R5=memory adres van rijen
@R6=grootte van 1 array = 64

print_rij:
	push	{R5-R6,LR}
	ldr R0,=print_vraag
	bl printf
	
	ldr R0,=f_str_i
	ldr R1,=rowtoprint
	bl scanf

	ldr R4,=rowtoprint
	ldr R4,[R4] @R4=rowtoprint
	mov R6,#64 @size of row in array
	@ debug R4 -> right
	mul R4,R4,R6 @calculate offset on address "rijen"
	@debug R4 -> right
	
	ldr R5,=rijen
	add R5,R4		@ R5 must point to right address

	ldr R1,[R5],#4 @load rij.naam

	ldr R2,[R5],#4 @ load rij.leeftijd en rij.stad
	lsr R3,R2,#8 @load rij.stad (omgekeerde van lsl 8)
	@'[Stad-byte]' '[Stad-byte]' '[Stad-byte]' '0000 [][][][]' rechtse 4 weg
	lsl R2,R2,#28 @shift away all the city bits 
	@so you have '[][][][] 0000' '0000 0000' '0000 0000' '0000 0000'
	ror R2,R2,#28 @ shift back to right
	debug R1
	debug R2
	debug R3

	ldr R0,=print_row_str


	bl printf
	



	ldr	R0, =dummy2	@ address dummy2
	bl	printf		@ call printf()
	pop	{R5,R6,LR}
	bx	LR

@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@ wijzig_rij ()
@ pseudo code & register use
@
wijzig_rij:
	push	{LR}
	ldr	R0, =dummy3	@ address dummy3
	bl	printf		@ call printf()
	pop	{LR}
	bx	LR


.data
print_row_str:	.asciz "row >> name: %s\tage: %d\tcity: %s\n"

rijen:	  .space 320	@ 0..31: 32-byte naam
			@ 32..35: 4-byte leeftijd
			@ 36..63: 28-byte stad
command:  .space 4	@ 4 bytes for command int
menu:
   .ascii "[1] Nieuwe rij toevoegen\n[2] Rij printen\n"
   .asciz "[3] Rij wijzigen\n[0] Programma stoppen\n\n >> "
f_str_i:  .asciz "%d"
f_str_string:	.asciz "%s"

fout:	  .asciz "Deze keuze is niet correct\n\n"
debugmsg: .asciz "debug... %d\n"
dummy1:	  .asciz "Rij toegevoegd\n"
dummy2:	  .asciz "Rij geprint\n"
dummy3:	  .asciz "Rij aangepast\n"

naam_vraag:		.asciz "Wat is de naam? (max 3 karakters)\n>> "
leeftijd_vraag:	.asciz "Wat is de leeftijd?  (max 15 jaar)\n>> "
stad_vraag:		.asciz "Wat is de stad? (max 2 karakters)\n>> "
naam:			.space 32
leeftijd:		.space 4
stad: 			.space 28

print_vraag:	.asciz "Welke rij moet ik printen (0-4)\n>>"
rowtoprint:		.word
