    .file "sum.s"
    .text
    .align  2
    .global main
    .type   main, %function
/*
* Rex Oliver
* CPSC 2311 Section 001
*/

/* main() sums 10 values from stdin and prints the sum */
main:
    push {lr}    // save lr
    
    //Code goes here
    // initialize base variables
    
    sub sp, sp, #4
    // scanf("%d", &var)
scan:
    ldr r0, =rafmt
    mov r1, sp
    bl scan
    
    
        
    pop {pc}         // put lr in pc    

.section    .rodata
    rdfmt:        .asciz "%d"
    prtfmt:       .asciz "sum is %d\n"
