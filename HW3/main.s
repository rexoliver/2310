	.file "main.s"
	.text
	.align 2
	.global main
	.type main, %function
/*
Rex Oliver
CPSC 2310i-001 Programming Assignment 3
04/10/2019
main.s
*/
/*
function name: main

description: this function reads in the arguments of the command line and gives
us the offset required for a 2D array when given an i, j, and n

input parameters: 
i - one of the dimensions of the array - arg1
j - the other dimension of the array - arg2
N - the number of columns per row - arg3

Effect: Prints the offset required for a 2D Array based on the passed 
in commandline arguments
*/
main:
    push {r4-r8, lr}
    mov r4, r0                // save argc
    mov r5, r1                // save argv
       
    add  r5, r5, #4    // Add to skip the "./a.out"        

    ldr  r0, [r5] 	   //Put the first arg into r0 so that we can atoi it
	bl   atoi
	mov  r6, r0	   // put the result in r6
    add  r5, r5, #4    // go to next value in arguments        
		
    ldr  r0, [r5]	   // Put the first arg into r0 so we can atoi it
	bl   atoi
	mov  r7, r0             
    add  r5, r5, #4   // go to next value in arguments        

    ldr r0, [r5]	  // Put the first arg into r0 so that we can atoi it
	bl atoi
	mov r8, r0	  // Put result in r8 to later use in subroutine
	
	mov r2, r8    // Write the variables to the first three registers 
	mov r1, r7    // to later use in the subroutine
	mov r0, r6

	bl offset	  // call subroutine
	mov r3, r0
	sub r5, r5, #12   // put r5 back to its original value

	ldr r0, =fmt1	  // register we call print from
	mov r1, r6
	mov r2, r7	
		
	bl printf	  // print statement

    mov  r0, #0
    pop {r4-r8, pc}

        .section ".rodata"
fmt1:    .asciz "the offset for a[%d][%d] is %d\n"
