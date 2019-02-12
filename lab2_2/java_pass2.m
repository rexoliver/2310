divert(-1)
include(symbols.m)
define(comment)
define(loc, 0) comment(`location counter')
define(iconst_m1, `loc: 2 define(`loc', eval(loc + 1))') comment(`push -1')
define(iconst_0, `loc:  3 define(`loc', eval(loc + 1))') comment(`push 0')
define(iconst_1, `loc:  4 define(`loc', eval(loc + 1))') comment(`push 1')
define(iconst_2, `loc:  5 define(`loc', eval(loc + 1))') comment(`etc.')
define(iconst_3, `loc:  6 define(`loc', eval(loc + 1))')
define(iconst_4, `loc:  7 define(`loc', eval(loc + 1))')
define(iconst_5, `loc:  8 define(`loc', eval(loc + 1))')
comment(`push signed byte arg following in instruction stream')
define(bipush, `loc:    16 $1 define(`loc', eval(loc + 2))')

define(iload_0, `loc:   26 define(`loc', eval(loc + 1))') comment(`push loc 0')
define(iload_1, `loc:   27 define(`loc', eval(loc + 1))') comment(`push loc 1')
define(iload_2, `loc:   28 define(`loc', eval(loc + 1))') comment(`etc.')
define(iload_3, `loc:   29 define(`loc', eval(loc + 1))')
comment(`push variable stored in loc following in instruction stream')
define(iload, `loc:     21 $1 define(`loc', eval(loc + 2))')

define(istore_0, `loc:  59 define(`loc', eval(loc + 1))') comment(`pop> loc 0')
define(istore_1, `loc:  60 define(`loc', eval(loc + 1))') comment(`pop> loc 1')
define(istore_2, `loc:  61 define(`loc', eval(loc + 1))') comment(`etc.')
define(istore_3, `loc:  62 define(`loc', eval(loc + 1))')
comment(`pop variable and store in loc following in instruction stream')
define(istore, `loc:    54 $1 define(`loc', eval(loc + 2))')

define(pop, `loc:       87 define(`loc', eval(loc + 1))') comment(`pop stack')
define(swap, `loc:      95 define(`loc', eval(loc + 1))') comment(`swap')
define(dup, `loc:       89 define(`loc', eval(loc + 1))') comment(`duplicate')

define(iadd, `loc:      96  define(`loc', eval(loc + 1))') comment(`+')
define(isub, `loc:      100 define(`loc', eval(loc + 1))') comment(`-')
define(imul, `loc:      104 define(`loc', eval(loc + 1))') comment(`*')
define(idiv, `loc:      108 define(`loc', eval(loc + 1))') comment(`/')
define(irem, `loc:      112 define(`loc', eval(loc + 1))') comment(`%')
define(ineg, `loc:      116 define(`loc', eval(loc + 1))') comment(`negate')
comment(`increment variable at loc, by const, args following in instr. stream')
define(iinc, `loc:      132 $1 $2 define(`loc', eval(loc + 3))')

define(jsr, `loc:      168 eval($1 - (loc + 1)) define(`loc', eval(loc + 2))')
define(ret, `loc:      169 define(`loc', eval(loc + 1))')

(`if ==, >=, >, <=, <, != and goto') 
define(ifeq, `loc:      153 eval($1 - (loc + 1)) define(`loc', 
                                                eval(loc + 2))')
define(ifge, `loc:      156 eval($1 - (loc + 1)) define(`loc', 
                                                eval(loc + 2))')
define(ifgt, `loc:      157 eval($1 - (loc + 1)) define(`loc', 
                                                eval(loc + 2))')
define(ifle, `loc:      158 eval($1 - (loc + 1)) define(`loc', 
                                                eval(loc + 2))')
define(iflt, `loc:      155 eval($1 - (loc + 1)) define(`loc', 
                                                eval(loc + 2))')
define(ifne, `loc:      154 eval($1 - (loc + 1)) define(`loc', 
                                                eval(loc + 2))')
define(goto, `loc:      167 eval($1 - (loc + 1)) define(`loc', 
                                                eval(loc + 2))')


comment(`method call, index to name follows in instr. stream: 1 ==
print, 2 == println.  Variable number to print on stack')
define(invokevirtual, `loc:     182 $1 define(`loc', eval(loc + 2))')
comment(`end of program, halt')
define(return, `loc:    177 define(`loc', eval(loc + 1))')
define(label, `')
divert
include(java_input.m)
