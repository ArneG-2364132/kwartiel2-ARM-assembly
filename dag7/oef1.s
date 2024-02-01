
.extern printf
.extern malloc
.extern scanf
.text

.global main
main:
@ typedef struct node {
@ char naam[32]; int leeftijd [4]; char stad[28];
@ struct node *next; /* next pointer */
@ } node;

mov R0,#68 @number of bytes (ook next-pointer)
bl malloc
@R0=pointer naar blok geheugen
@R4 is startadres van lijst
@lege lijst initialiseren op null
mov R4,R0

mov R5,R4
ldr R5,[R5,#64] @R5 is pointer naar volgende element


@menuloop

menuloop:
    ldr R0,=prompt
    bl printf

    ldr R0,=scanf_str
    ldr R1,=choice
    bl scanf

    ldr R4,=choice @ load selected option in R4
    ldr R4,[R4]

    cmp R4,#0    @end program
    beq end

    cmp R4,#1 @rij toevoegen
    bne skip1 @ branch with link bij eq
    bl addrow
    b menuloop

skip1: @printen
    cmp R4,#2   
    bne skip2
    bl printrows
    b menuloop

skip2: @leeftijd zoeken
    cmp R4,#3   
    bne wrong
    bl search_age
    b menuloop

wrong: @ verkeerde input
    
    ldr R0,=verkeerd
    bl printf
    b menuloop

end: @exit to linux
    mov R7,#1
    mov R0,#0
    svc 0


addrow:
    push {LR}
    mov R0,#68
    bl malloc



    pop {LR}
    bx LR


printrows:
bx LR
search_age:
bx LR

.data
verkeerd:   .asciz   "Verkeerde invoer, enkel 0-3 toegelaten\n"
prompt:     .asciz   "[1] een nieuwe rij toevoegen\n[2] alle rijen printen op stdout\n[3] een leeftijd zoeken\n[0] programma stoppen\n>> "
scanf_str:  .asciz   "%d"
choice:     .word   0