// C program to illustrate calling a function myToUpper ()
// in ARM assembly from a C program
#include <stdio.h>
extern void myToUpper (char*, char* );
#define MAX_BUFFERSIZE 255
int main()
{
    char * inputStr = "Hallo Dit is een groote test";
    char outputStr[MAX_BUFFERSIZE];
    myToUpper (inputStr, outputStr);
    printf ("input string: %s\n", inputStr);
    printf ("output string: %s\n", outputStr);
}