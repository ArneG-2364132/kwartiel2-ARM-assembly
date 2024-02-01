@this program writes out hello world
@using the sys_print linux call function
.text
.global	_start

_start:
	mov	R0,#1	@1=stdout (terminal) (1ste argument sys_print
	ldr	R1,=wor	@laad helloWorld string in R1(2de arg)
	mov	R2,#13	@3de arg, size van waardes
	mov	R7,#4	@R7 altijd linux call 4=write linux call
	svc	0	@linux call

@exit parameters
	mov	R0,#0	@return code
	mov	R7,#1	@ specify sys_exit call 1
	svc	0	@linux call
.data
wor: .asciz "Hello World!\n"
