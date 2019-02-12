comment('  code that implements the loop with bgt0 at bottom of loop  ')

comment('  code that implements the loop                       ')
comment('    sum = 0;                                          ')
comment('    for( i = 10; i > 0; i-- ) {                       ')
comment('       sum = sum + i;                                 ')
comment('    }                                                 ')

   word(sum,0)
   word(i,0)
   word(zero,0)
   word(one,1)
   word(ten,10)

label(start)

   load(zero)  comment('  sum = 0         ACC <- memory[zero]  ')
   store(sum)  comment('                  memory[sum] <- ACC   ')
   load(ten)   comment('  i = 10                               ')
   store(i)

label(loop)

   load(sum)   comment('  sum = sum + i                        ')
   add(i)
   store(sum)

   load(i)     comment('  i = i - 1                            ')
   sub(one)
   store(i)

   bgt0(loop)  comment('  conditionally branch back to loop    ')

label(done)

   print(sum)
   halt

comment('  start execution at label start  ')

   end(start)
