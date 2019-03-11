	.global main

main:
	push {r7, lr}
	sub sp, sp, #16
	add r7, sp, #0

	ldr r0, =0x12345678       /* put the source value in r0 */
	ldr r2, =0x7              /* put the location of the field*/
	ldr r3, =0x8              /* put the size of field in r3 */
	
/* Beginning of your code */
           
    lsr r0, r0, r2
    mov r1, #1
    lsl r1, r1, r3
    sub r1, r1, #1
    and r1, r0, r1    
    
/* End of your code */

/* show output on screen */
    ldr r0, =prt_line	
	bl printf
	add r7, r7, #16
	mov sp, r7
	pop {r7, pc}

	.size main, .-main
	.section .rodata

prt_line: .asciz "0x%X\n"
