/* This program (is supposed to) compute the expression
*
*    y = (x - 1) * (x - 7) - (x * x)
*
*  for x = 0 to x = 10.
*
*/

/* Variables x and y are stored in r5 and r3 respectively */

	.text
	.align 2
	.global main

main:	
	push {r7, lr}
	sub  sp, sp, #16
	add  r7, sp, #0

	mov  r5, #0		       @ initialize x 

loop:
	sub  r0, r5, #1	    @ (x - 1) into r0               
	sub  r1, r5, #7	    @ (x - 7) into r1
	mul  r0, r0, r1

	mul  r1, r5, r5       @ store (x * x) into r1

	sub  r0, r0, r1       @ subtract r1 from r0 

	mov  r3, r0           @ move the value to r3 (y)                  

	ldr  r0, =out_line    @ put print string in r0
	mov  r1, r3           @ put value to print in r1
	bl   printf           @ call print routine

	add  r5, r5, #1       @ increment counter

	cmp  r5, #10          @ perform r5 - 10, result is used by blt

	blt  loop

	mov  r3, #0
	mov  r0, r3
	add  r7, r7, #16
	mov  sp, r7
	pop  {r7, pc}

	.size main, .-main
	.section .rodata

out_line: .asciz "\nvalue = %d\n"
