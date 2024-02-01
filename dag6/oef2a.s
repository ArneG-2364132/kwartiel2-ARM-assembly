 .extern printf
.text

@ (a) Schrijf een ARM programma waar je in het .data segment
@ een vrije ruimte van 320 bytes reserveert. Hier gaan we 5 data
@ rijen van personen in opslaan van elk 64 bytes: 32 bytes voor
@ de naam, 4 bytes voor de leeftijd en 28 bytes voor de stad.
.text
.global main @menugebaseerde interface in main
main:


.data
command: .asciz"command:\n"
rijen: .space 320
@32 bytes voor naam
@4 bytes voor leeftijd
@28 bytes voor stad

