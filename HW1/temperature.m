comment('Rex Oliver')
comment('CPSC 2310 Lab 2')
comment('temperature.m')
comment('This program prints out a table of celcius')
comment('from -40 to 120 into fahrenheit' )



bipush(-40)    comment('Push first number onto the stack')           
istore_1       comment('Store the counter that was at the top of')
               comment('The stack into local register 1 for safe-')
               comment('keeping and modification later')
	       
label(loop)    comment('loop where celcius is put throught fahrenheit equation')

iload_1        comment('put the original number onto the stack')
bipush(9)      comment('Push 9 onto the stack for the first part of the equation')

imul           comment('Multiply the two on the stack')

istore_2       comment('Store them in the second register')
iload_2        comment('Put them back in the stack')
bipush(5)

idiv

istore_2
iload_2
bipush(32)

iadd

istore_2
iload_2

iconst_1       comment('set the print statement to print local register 1, the Celcius')
invokevirtual(1) comment('print first register, the Celcius')

iconst_2       comment('set the print statemtnt to print local register 3, the Fahrenheit')
invokevirtual(2) comment('print second register, the Celcius')

iinc(1,10)     comment('increments the local register 1 (our celcius and counter) by 10')

iload_1        comment('push register 1 onto stack')
bipush(120)    comment('push max temperature onto stack')

isub           comment('pop both nums and subtract the 2nd from first( loop count -120 ')

ifle(loop)     comment('if top of stack <= 0 then ends, otherwise loops')

return
