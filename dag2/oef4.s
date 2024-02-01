@lees 2 integers met scanf
@geef som met printf
.extern	printf

.text
.global	main

main:
ldr	R0,=string 	@first parameter from printf
mov	R1,#1024	@second parameter from printf
bl	printf		@printf call via c runtime


@exit program:
mov	R0,#0	@0as return code
mov	R7,#1	@sys_exit call
svc	0	@call linux

.data
string: .asciz "Het getal is: %d\n"


