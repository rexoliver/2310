                 comment(`this program prints out the 2nd - 10th fibonacci')
                 comment(`numbers where 0, 1 are the 0th and 1st elements')
                 comment(`of the sequence respectively.')

                 comment(`here are our starting fibonnici numbers')
iconst_0         comment(`push zero onto stack')
iconst_1         comment(`push one onto stack')

iconst_2         comment(`push 2 onto the stack to be used as our counter')
                 comment(`since we already have the 0th and 1st element of')
                 comment(`the fib sequence calculated, we will start at 2')

istore_1         comment(`store the counter that was at top of stack into')
                 comment(`local register 1 for safe keeping, this pops it at')
                 comment(`the same time.')


label(loop)      comment(`beginning of the loop')


istore_2         comment(`store the top of the stack (one of our fib numbers) in local register 2')
iload_2          comment(`load it back since it was popped off during the store')

iadd             comment(`adding the last two fib numbers calculates the next one,')
                 comment(`but also erases them from the stack, which is why we saved')
                 comment(`just the top one into a register')

istore_3         comment(`store the fib number we just calculated')

iload_2          comment(`put the old fib number back on the stack for next time')
iload_3          comment(`put the fib number we just calculated on the stack')

iconst_1         comment(`set the print statement to print local register 1, the loop count')
invokevirtual(1) comment(`1 == print with no new line') 

iconst_3         comment(`set the print statement to print local register 3, the fib number just calculated')
invokevirtual(2) comment(`2 == print with a new line at the end') 

iinc(1, 1)       comment(`increment local register 1 (our counter) by 1')

iload_1          comment(`push the loop count onto the stack')
bipush(10)       comment(`push the loop limit onto the stack')

isub             comment(`pop top two numbers and subtract the 2nd from the 1st (loop count - 10)')

ifle(loop)       comment(`if top of stack <= 0 (our loop count is <= 10) goto loop, this also pops')
                 comment(`the result of the subtraction so it doesn't mess up our fib numbers!')

return
