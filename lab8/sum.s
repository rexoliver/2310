/*
* Rex Oliver
* CPSC 2311 Section 001
*/
    .file "sum.s"
    .text
    .align  2
    .global main
    .type   main, %function

/* main() sums 10 values from stdin and prints the sum */

main:
    push {r4-r5, lr}
    
    // adds space to stack
    sub sp, sp, #40 
    
    // initialization of registers
    mov r4, sp
    mov r1, r4
    mov r5, #0
    mov r6, #0
    mov r7, #0
    
    
// scan loop
scan:
    // reads in the data
    ldr r0, =rdfmt
    mov r1, r4
    bl scanf
    
    // accesses the individual item on the stack and 
    // puts it in the r5 register to later be printed
    ldr r7, [r4]
    add r5, r5, r7
    add r4, #4    

    // checks if the loop has gone enough times yet or not
    add r6, r6, #1
    cmp r6, #10
    blt scan
    
    // prints the r5 register
    ldr r0, =prtfmt
    mov r1, r5
    bl printf
    

done:     
    // cleans up stack and pops the registers that were in use
    add sp, sp, #40
    pop {r4-r5, pc}
 
.section    .rodata
    rdfmt:        .asciz "%d"
    prtfmt:       .asciz "sum is %d\n"
