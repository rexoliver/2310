.text
.align 2
.global main
.global offset
.type offset, %function	
/*
Rex Oliver
CPSC 2310-001 Programming Assignment 3
04/10/2019
offset.s
*/
/*
function name: offset

description: calculates the memory offset required for a 2D Array when given
an i, j, and n

input parameters
r2 - n
r1 - j
r0 - i

effect: 
stores the offset in r0

typical calling sequence: 
Called after an i, j, and n are put in registers

local register usage:
r0 - i and later where offset is stored
r1 - j
r2 - n, the number of columns 
*/

offset: 			//(i * n + j)*4
	mul r2, r0, r2  // i * n
	add r2, r2, r1  // (i*n)+j
	lsl r2, r2, #2  //  * 4	
	mov r0, r2
	bx lr	// gives control back to main.s

