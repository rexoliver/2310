/* This program executes a DO loop that computes the triangular number for 4
 *
 * The C code looks like this:
 *
 * main()
 * {
 *		int sum, n;
 *		sum = 0;
 * 	   	n = 4;
 *
 *		do {
 *			sum = sum + n;
 *			n--;
 *		} while (n >= 0);

 *	    printf("The triangular number for %d is %d\n", 4, sum)
 * }
 */

	.global main

main:
	push 	{lr}
    
	mov	r2, #0		/* sum = zero */
	mov	r3, #4		/* n = 4      */

do_top:
	add	r2, r2, r3	/* sum = sum + n */
    sub r3, r3, #1			/* n--           */

	cmp r3, #0				/* compare n to zero */
	bne	do_top			/* branch if not zero to "do_top" */

    ldr r0, =out_line   /* pseudo-op to put addr of out_line in r0  */
	mov	r1, #4
	bl	printf          /* call printf            */

 	mov	r3, #0
	mov	r0, r3
	pop	{pc}


	.section  .rodata	
out_line: .asciz "The triangular number for %d is %d\n"
