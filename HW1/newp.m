comment('Rex Oliver (rexroao)')
comment('CPSC 2310-002')
comment('Programming Assignment 1 - Conversion from Binary to Decimal')
comment('Due: Feb 15, 2019 at 11:59pm')

comment('Description: converts an input from Binary to decimal')

  word(N, 10110101)
  word(count, 1)
  word(two, 2)
  word(fin, 0)
  word(ten, 10)
  word(nine, 9)
  word(eight, 8)
  word(n_add_9, 0)
  word(n_add_8, 0)

label(start)

label(loop) comment('loop of entire program')

  load(N) comment(' (n + 9) / 10 = n_add_9')
  add(nine)
  div(ten)
  store(n_add_9)

  load(N)  comment('(n + 8) / 10 = n_sub_8')
  add(eight)
  div(ten)
  store(n_add_8)

  load(n_add_9) comment('n_add_9 - n_sub_8')
  sub(n_add_8)

  beq0(skip_to) comment('if n_add_9 == n_sub_8')
            comment('then it is a zero, so do not do anything')

  load(fin) comment('add the multiplied last digit to the sum')
  add(count)
  store(fin)

label(skip_to) comment(' if zero is digit, skip here')

  load(count) comment('counter * 2')
  mul(two)
  store(count)

  load(N) comment('if n is not zero, restart loop')
  div(ten)
  store(N)
  load(N)
  bgt0(loop)

label(done)

  print(fin) comment('Prints and halts')
  halt

comment('  start execution at label start  ')

end(start)
