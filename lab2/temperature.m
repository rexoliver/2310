comment('Rex Oliver')
comment('CPSC 2310 Lab 2')
comment('Calculates fahrenheit from celcius')
comment('and prints table')


bipush(-40)
istore_1

label(loop)
iconst_1
invokevirtual(1)
iload_1
bipush(9)
imul
istore_2
iload_2
bipush(5)
idiv
istore_2
bipush(32)
iload_2
iadd
istore_2
iconst_2
invokevirtual(2)
iinc(1,10)
iload_1
bipush(120)
isub
ifle(loop)

return
