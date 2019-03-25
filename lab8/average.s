    .file "sum.s"
    .text
    .align  2
    .global main
    .type   main, %function

/* main() sums 10 values from stdin and prints the sum */
main:
    push {lr}    // save lr
    
    //Code goes here

    pop {pc}         // put lr in pc    

.section    .rodata
    rdfmt:        .asciz "%d"
    prtfmt:       .asciz "sum is %d\n"
