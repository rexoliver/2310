comment('Rex Oliver')
comment('CPSC 2311 Lab 1')
comment('myloop.m')

comment(' code that implements the loop ')
comment(' sum = 0; ')
comment(' for(i = 1; i <=10; i++)')
comment(' { ')
comment('     sum = sum + i; ')
comment(' } ')


       word(sum,0)
       word(i,0)       
       word(zero,0)   
       word(one,1)
       word(ten,10)

label(start)

       load(zero) comment(' sum = 0    ACC<- memory[zero] ')
       store(sum) comment('      memory[sum] <- ACC ')
       load(one)  comment(' i = 1 ')
       store(i)

label(loop)

       load(sum)  comment('sum = sum + i ')
       add(i)
       store(sum)

       load(i)    comment(' i = i + 1 ')
       add(one)
       store(i)

       load(i)
       sub(ten)
       
       ble0(loop)

label(done)
       
       print(sum)
       halt

end(start)
