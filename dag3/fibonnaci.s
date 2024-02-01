@
.extern	printf
.text
testfunctie:

.global	main

main:
@R4=1ste fibonacci-getal
@R5=2de fibonacci-getal
@R6 = x kleiner dan 20
@R7 = array
mov R6,#1
ldr	R7,=arr

loop:	cmp	R6,#21
	beq		end


	ldr	R0,=string 	@first parameter from printf
	mov	R1,R6		@second parameter from printf
	ldr	R2,[R7]
	bl	printf		@printf call via c runtime a


	ldr		R4,	[R7]		@R4 krijgt huidig fib getal (in rij)
	ldr		R5,	[R7, #4]	@R5 krijgt vorig fib getal (in rij)

	add		R8, R4, R5		@nieuw fib getal in R8
	str		R8, [R7, #8]	@nieuw fib getal in array schrijven
	add		R7, #4			@adres van volgend adres in R7
	add		R6,#1			@counter + 1

	b	loop				@terug springen naar loop

end:



@printf ("Fib %d: %d\n", i, arr[i])
ldr	R0,=string 	@first parameter from printf
mov	R1,R6		@second parameter from printf
ldr	R2,[R7]
bl	printf		@printf call via c runtime a

ldr	R0,=string 	@first parameter from printf
add	R1,R6,#1		@second parameter from printf
ldr	R2,[R7,#4]	@third parameter from printf
bl	printf		@printf call via c runtime a


@exit program:
mov	R0,#0	@0 as return code
mov	R7,#1	@sys_exit call
svc	0		@call linux

.data
string: .asciz "Fib %d: %d\n"
arr:	.word 1, 1, 0, 0, 0
		.word 0, 0, 0, 0, 0
		.word 0, 0, 0, 0, 0
		.word 0, 0, 0, 0, 0, 0, 0
