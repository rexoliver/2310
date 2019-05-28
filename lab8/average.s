/*
* Rex Oliver
* CPSC 2311 Section 001
*/
    .file "average.s"
    .text
    .align  2
    .global main
    .type   main, %function

/* main() sums 10 values from stdin and prints the sum */

main:
    push {r4-r5, lr}
    
    // adds space to stack
    sub sp, sp, #64
    // initializes the registers 
    mov r4, sp
    mov r1, r4
    mov r5, #0
    mov r6, #0
    mov r7, #0
    
    
        
scan:
    // reads in the variable
    ldr r0, =rdfmt
    mov r1, r4
    bl scanf
    
    // stores the variable in r5
    ldr r7, [r4]
    add r5, r5, r7
    add r4, #4    
    
    // decides whether or not to loop 
    add r6, r6, #1
    cmp r6, #16
    blt scan
    
    // divides and prints the total value
    ldr r0, =prtfmt
    lsr r1, r5, #4
    bl printf
    
done:     
    // cleans up stack and pops the registers that were in use
    add sp, sp, #64
    pop {r4-r5, pc}
 
.section    .rodata
    rdfmt:        .asciz "%d"
    prtfmt:       .asciz "average is %d\n"
