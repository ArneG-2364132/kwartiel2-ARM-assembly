
@void myToUpper (char*, char* );
@R0=pointer naar inputchar 1
@R1=pointer naar outputchar 1
@R4=inputchar in verwerking

@void myToUpper (char*, char* );
@working with pointers to a maximum of x chars
.text
.global myToUpper
myToUpper:


letterloop:    
    ldrb R4,[R0],#1     @load letter R1 and set pointer right
    cmp R4,#0           @end if terminating zero
    beq end             @branch aan einde van loop

    cmp R4, #'a' @ascii-waardes kleiner dan a hoeven geen uppercase
    blt  noUpper

    cmp R4,#'z'
    bgt noUpper @groter dan z -> geen uppercase  

    sub R4,#('a'-'A')    @save uppercase in R4

noUpper:
    strb R4,[R1],#1         @store uppercase letter and set pointer right

    b letterloop


end:
    @ strb R4,[R1],#1     @store terminating zero at right location
    bx LR               @exit to c




@ exit program
    @ mov R7,#1
    @ mov R0,#0
    @ svc 0
