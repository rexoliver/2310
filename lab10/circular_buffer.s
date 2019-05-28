	.syntax unified
	.arch armv7-a
	.eabi_attribute 27, 3
	.fpu vfpv3-d16
	.eabi_attribute 20, 1
	.eabi_attribute 21, 1
	.eabi_attribute 23, 3
	.eabi_attribute 24, 1
	.eabi_attribute 25, 1
	.eabi_attribute 26, 2
	.eabi_attribute 30, 4
	.eabi_attribute 34, 1
	.eabi_attribute 18, 4
	.thumb
	.file	"circular_buffer.c"
	.text
	.align	1
	.global	init_buffer
	.thumb
	.thumb_func
	.type	init_buffer, %function

init_buffer:
	ldr	r2, .L2       @ load address of "count" into r2
	mov	r3, #0        @ initialize r3 to 0
	str	r3, [r2]      @ store the value of r3 into "count"

	@ initialize "out"
	ldr	r2, .L2+4
	str	r3, [r2]

	@ initialize "in"
	ldr	r2, .L2+8
	str	r3, [r2]

	bx	lr

.L3:
	.align	2

.L2:
	.word	count
	.word	out
	.word	in
	.size	init_buffer, .-init_buffer
	.align	1
	.global	printbuf
	.thumb
	.thumb_func
	.type	printbuf, %function

printbuf:
	push	{r3, r4, r5, r6, r7, r8, lr} @ save registers

	ldr	r4, .L8             @ load the address of "count" into r4
	ldr	r3, [r4]            @ load the value of "count" into r3
	cbnz	r3, not_empty   @ this is a "compare and branch" statement
	                        @ it compares r3 to .L5 and branches if the result is not zero (nz)

	@ at this point, the buffer must be empty
	ldr	r0, .L8+4           @ load the address of ".LC0", the print string for buffer empty, into r0

	pop	{r3, r4, r5, r6, r7, r8, lr} @ restore registers

	b	puts                @ use puts to print the message rather than printf because
	                        @ we're not printing any variables. puts will return to
	                        @ the lr which has just been restored so it will not return
	                        @ to this function again but return straight to main

not_empty:

	mov r8, r3              @ r3 still has the value of "count", move it to r8
	ldr	r4, .L8+8           @ load the address of "out" into r4
	ldr r4, [r4]            @ load the value of "out" into r4, r4 is now "i"
	mov r5, #7              @ set r5 equal to CBUFMASK which is (8 - 1) = 7
	                        @ since "#define"s are evaluated at compile time
	                        @ there is no variable for CBUFMASK, just a value

	ldr	r6, .L8+12          @ load the address of "cbuf" into r6
	mov r7, #0              @ initialize r7 to 0, r7 will be "j"

print_loop:
	cmp r7, r8              @ compare "j" to "count"
	bge end_print_loop      @ if the difference is 0 or positive, j is bigger an
	                        @ we stop looping

	ldr r0, =.LC1           @ load the address of the print string "%c " into r0
	ldrb r1, [r6, r4]       @ load (a single byte) from r6 offset by r4 (cbuf[i]), into r1
	bl  printf              @ branch to printf (call it)

	add r4, r4, #1          @ increment "i"
	and r4, r4, r5          @ logically and "i" with CBUFMASK and store it back to "i"
	add r7, r7, #1          @ increment "j"

	b   print_loop          @ continue looping

end_print_loop:

	mov	r0, #10             @ set r0 to 10, the ASCII code for a new line ("\n")
	pop	{r3, r4, r5, r6, r7, r8, lr} @ restore registers
	b	putchar             @ call putchar to print the new line we stored in r0
	                        @ again since we restored lr first, putchar will return
	                        @ straight to main

.L9:
	.align	2
.L8:
	.word	count
	.word	.LC0
	.word	out
	.word	cbuf
	.word	.LC1
	.size	printbuf, .-printbuf
	.align	1
	.global	put
	.thumb
	.thumb_func
	.type	put, %function

put:
	push	{r4, r5, lr} @ save registers
    
	@ CODE HERE

    ldr r1, .L12
    ldr r2, [r1]   
    
    cmp r5, #8      @ if count == cbufsize
    bne otherwise2

    ldr r0, .L12 + 4 @ print buffer is full
    bl printf

    b done2

otherwise2: 
    ldr r3, .L12 + 8    @ changes pos of in and out
    ldr r4, [r3]
    ldr r5, .L12 + 12
    
    str r0, [r5, r4] @ gets value from cbuf, puts it in r0 for return

    add r4, r4, #1  @ changes pos of out
    and r4, r4, #7  @ applies CBUFMASK
    str r4, [r3]    
    
    add r2, r2, #1  @ Count++
    str r2, [r1]

done2:     
	pop	{r4, r5, pc}    @ restore registers (pop to pc also returns to calling function)

.L13:
	.align	2
.L12:
	.word	count
	.word	.LC2
	.word	in
	.word	cbuf
	.size	put, .-put
	.align	1
	.global	get
	.thumb
	.thumb_func
	.type	get, %function
get:
	push {r4, lr}

    @ CODE HERE
    ldr r0, .L17    @ Load count in 
    ldr r1, [r0]
 
    cmp r1, #0      @ if (count == 0)
    bne otherwise 
    
    ldr r0, .L17+4       @ printf("empty\n";
    bl printf             
    mov r0, #0
    b done 
otherwise:              @ Other conditional branch
    ldr r2, .L17 + 8    @ inserts value into cbuffer
    ldr r3, [r2]
    ldr r4, .L17 + 12
    ldr r0, [r4, r3]

    add r3, r3, #1      @ changes position of in
    and r3, r3, #7      @ ands CBUFMASK
    str r3, [r2]

    ldr r2, .L17
    sub r1, r1, #1      @ Count++
    str r1, [r2]
done: 
	pop	{r4, pc}
.L18:
	.align	2
.L17:
	.word	count
	.word	.LC3
	.word	out
	.word	cbuf
	.size	get, .-get
	.section	.text.startup,"ax",%progbits
	.align	1
	.global	main
	.thumb
	.thumb_func
	.type	main, %function
main:
	@ args = 0, pretend = 0, frame = 8
	@ frame_needed = 0, uses_anonymous_args = 0
	push	{r0, r1, r4, lr}
	add	r4, sp, #8
	movs	r3, #0
	strb	r3, [r4, #-1]!
	bl	init_buffer
	b	.L32
.L29:
	movs	r0, #1
	ldr	r1, .L36
	bl	__printf_chk
	ldr	r0, .L36+4
	mov	r1, r4
	bl	__isoc99_scanf
	ldrb	r3, [sp, #7]	@ zero_extendqisi2
	cmp	r3, #112
	beq	.L23
	bhi	.L26
	cmp	r3, #103
	bne	.L21
	b	.L34
.L26:
	cmp	r3, #113
	beq	.L32
	cmp	r3, #121
	bne	.L21
	b	.L35
.L23:
	movs	r0, #1
	ldr	r1, .L36+8
	bl	__printf_chk
	mov	r1, r4
	ldr	r0, .L36+4
	bl	__isoc99_scanf
	ldrb	r0, [sp, #7]	@ zero_extendqisi2
	bl	put
	b	.L32
.L34:
	bl	get
	mov	r2, r0
	cbnz	r0, .L28
	ldr	r0, .L36+12
	b	.L33
.L28:
	movs	r0, #1
	ldr	r1, .L36+16
	bl	__printf_chk
	b	.L32
.L35:
	bl	printbuf
	b	.L32
.L21:
	ldr	r0, .L36+20
.L33:
	bl	puts
.L32:
	ldrb	r3, [sp, #7]	@ zero_extendqisi2
	cmp	r3, #113
	bne	.L29
	movs	r0, #0
	pop	{r2, r3, r4, pc}
.L37:
	.align	2
.L36:
	.word	.LC4
	.word	.LC5
	.word	.LC6
	.word	.LC7
	.word	.LC8
	.word	.LC9
	.size	main, .-main
	.comm	count,4,4
	.comm	out,4,4
	.comm	in,4,4
	.comm	cbuf,8,1
	.section	.rodata.str1.1,"aMS",%progbits,1
.LC0:
	.ascii	"The buffer is empty.\000"
.LC1:
	.ascii	"%c \000"
.LC2:
	.ascii	"Sorry: buffer is full.\000"
.LC3:
	.ascii	"empty\000"
.LC4:
	.ascii	"enter action (p=put,g=get,y=print,q=quit): \000"
.LC5:
	.ascii	"\012%c\000"
.LC20:
	.ascii	"\012j:%d count:%d\012\000"
.LC6:
	.ascii	"  enter character to put: \000"
.LC7:
	.ascii	"  can't get from empty buffer.\000"
.LC8:
	.ascii	"  character removed is: %c\012\000"
.LC9:
	.ascii	"  unrecognized action\000"
	.ident	"GCC: (Ubuntu/Linaro 4.6.3-1ubuntu5) 4.6.3"
	.section	.note.GNU-stack,"",%progbits
