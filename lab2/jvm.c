/* integer java virtual machine */
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <ctype.h>

#define TRUE 1
#define FALSE 0

#define ICONST_M1 2             /* push -1 onto stack */
#define ICONST_0 3              /* push 0 onto stack */
#define ICONST_1 4              /* push 1 onto stack */
#define ICONST_2 5              /* push 2 onto stack */
#define ICONST_3 6              /* push 3 onto stack */
#define ICONST_4 7              /* push 4 onto stack */
#define ICONST_5 8              /* push 5 onto stack */
#define BIPUSH 16               /* bipush <value>, push <byte value> */

#define ILOAD_0 26              /* iload_0 push local variable 0 */
#define ILOAD_1 27              /* iload_1 push local variable 1 */
#define ILOAD_2 28              /* iload_2 push local variable 2 */
#define ILOAD_3 29              /* iload_3 push local variable 3 */
#define ILOAD 21                /* iload <varnum>, push <varnum> */

#define ISTORE_0 59             /* pop stack to local variable 0 */
#define ISTORE_1 60             /* pop stack to local variable 1 */
#define ISTORE_2 61             /* pop stack to local variable 2 */
#define ISTORE_3 62             /* pop stack to local variable 3 */
#define ISTORE 54               /* istore <varnum>, pop to <varnum> */

#define POP 87                  /* discard top of stack */
#define SWAP 95                 /* swap top two items of stack */
#define DUP 89                  /* duplicate top of stack */

#define IADD 96                 /* add */
#define ISUB 100                /* subtract */
#define IMUL 104                /* mul */
#define IDIV 108                /* div */
#define IREM 112                /* remainder */
#define INEG 116                /* negate */
#define IINC 132                /* iinc <varnum> <n>, add <n> to <varnum> */

#define IFEQ 153                /* ifeq <label>, if == 0, goto <label> */
#define IFGE 156                /* ifge <label>, if >= 0, goto <label> */
#define IFGT 157                /* ifgt <label>, if >  0, goto <label> */
#define IFLE 158                /* ifle <label>, if <= 0, goto <label> */
#define IFLT 155                /* iflt <label>, if <  0, goto <label> */
#define IFNE 154                /* ifne <label>, if != 0, goto <label> */
#define GOTO 167                /* goto <label> */

#define JSR 168			/* jump to subroutine <label> */
#define RET 169			/* return from subroutine */

#define INVOKEVIRTUAL 182       /* method call specialized to call */
                                /* System.out.println with a local */
                                /* variable as argument */
#define PRINT 1                 /* argument for System.out.print */
#define PRINTLN 2               /* argument for System.out.println */
#define RETURN 177              /* return from method */

#define MEMORY_SIZE 1000
#define STACK_SIZE 10
#define LOCAL_VARIABLE_SIZE 10

signed char memory[MEMORY_SIZE]; /* program memory */
int pc;                         /* program counter */
int stack[STACK_SIZE];          /* the stack */
int locals[LOCAL_VARIABLE_SIZE];                /* the stack */
int sp = -1;                    /* stack pointer */

void decode_inst(int loc, char instr[])
{

  switch ((unsigned char) memory[loc])
  {
    case ICONST_M1:             /* push -1 onto stack */
      strcpy(instr,"ICONST_M1");
      break;
    case ICONST_0:              /* push 0 onto stack */
      strcpy(instr,"ICONST_0");
      break;
    case ICONST_1:              /* push 1 onto stack */
      strcpy(instr,"ICONST_1");
      break;
    case ICONST_2:              /* push 2 onto stack */
      strcpy(instr,"ICONST_2");
      break;
    case ICONST_3:              /* push 3 onto stack */
      strcpy(instr,"ICONST_3");
      break;
    case ICONST_4:              /* push 4 onto stack */
      strcpy(instr,"ICONST_4");
      break;
    case ICONST_5:              /* push 5 onto stack */
      strcpy(instr,"ICONST_5");
      break;
    case BIPUSH:                /* bipush <value>, push <byte value> */
      sprintf(instr, "BIPUSH(%d)", memory[loc + 1]);
      break;
    case ILOAD_0:               /* iload_0 push local variable 0 */
      strcpy(instr,"ILOAD_0");
      break;
    case ILOAD_1:               /* iload_1 push local variable 1 */
      strcpy(instr,"ILOAD_1");
      break;
    case ILOAD_2:               /* iload_2 push local variable 2 */
      strcpy(instr,"ILOAD_2");
      break;
    case ILOAD_3:               /* iload_3 push local variable 3 */
      strcpy(instr,"ILOAD_3");
      break;
    case ILOAD:                 /* iload <varnum>, push <varnum> */
      sprintf(instr, "ILOAD(%d)", memory[loc + 1]);
      break;
    case ISTORE_0:              /* pop stack to local variable 0 */
      strcpy(instr,"ISTORE_0");
      break;
    case ISTORE_1:              /* pop stack to local variable 1 */
      strcpy(instr,"ISTORE_1");
      break;
    case ISTORE_2:              /* pop stack to local variable 2 */
      strcpy(instr,"ISTORE_2");
      break;
    case ISTORE_3:              /* pop stack to local variable 3 */
      strcpy(instr,"ISTORE_3");
      break;
    case ISTORE:                /* istore <varnum>, pop to <varnum */
      sprintf(instr,"ISTORE(%d)", memory[loc + 1]);
      break;
    case POP:                   /* pop */
      strcpy(instr,"POP");
      break;
    case SWAP:                  /* swap top two items of stack */
      strcpy(instr,"SWAP");
      break;
    case DUP:                   /* copy */
      strcpy(instr,"DUP");
      break;
    case IADD:                  /* add */
      strcpy(instr,"IADD");
      break;
    case ISUB:                  /* sub */
      strcpy(instr,"ISUB");
      break;
    case IMUL:                  /* mul */
      strcpy(instr,"IMUL");
      break;
    case IDIV:                  /* idiv */
      strcpy(instr,"IDIV");
      break;
    case IREM:                  /* mod */
      strcpy(instr,"IREM");
      break;
    case INEG:                  /* negate */
      strcpy(instr,"INEG");
      break;
    case IINC:                  /* iinc <varnum> <n>, add <n> to <varnum> */
      sprintf(instr,"IINC %d by %d", memory[loc + 1], memory[loc + 2] );
      break;
    case IFEQ:                  /* be */
      sprintf(instr,"IFEQ %d",  memory[loc + 1]);
      break;
    case IFGE:                  /* bge */
      sprintf(instr,"IFGE %d",  memory[loc + 1]);
      break;
    case IFGT:                  /* bg */
      sprintf(instr,"IFGT %d",  memory[loc + 1]);
      break;
    case IFLE:                  /* ble */
      sprintf(instr,"IFLE %d", memory[loc + 1]);
      break;
    case IFLT:                  /* bl */
      sprintf(instr,"IFLT %d",  memory[loc + 1]);
      break;
    case IFNE:                  /* bne */
      sprintf(instr,"IFNE %d",  memory[loc + 1]);
      break;
    case GOTO:                  /* goto */
      sprintf(instr,"GOTO %d", memory[loc + 1]);
      break;
    case JSR: /* Debug Information needed */

      break;
    case RET: /* Debug Information needed */

      break;
    case RETURN:                /* halt */
      strcpy(instr,"RETURN");
      break;
    case INVOKEVIRTUAL:         /* method call, one arg follows */
                                /* memory[pc] ==1, print; == 2 println. */
                                /* stack[sp] local variable number to */
      if (memory[loc + 1] == 1)      /* print */
        strcpy(instr,"INVOKEVIRTUAL (print)");
      else if (memory[loc + 1] == 2) /* println */
        strcpy(instr,"INVOKEVIRTUAL (println)");
      break;
    default:
      strcpy(instr, "BAD INSTRUCTION");
      break;
  } /* end case */

} /* end decode_inst() */

void print_state(void)
{
int i;
char instr[40];

   decode_inst(pc, instr);
   printf("\n\n\n--------> pc is %d   %s\n", pc, instr);

   printf("local vars:\n");
   for (i = 0; i < 4; i++)
   {
      printf("lv(%2d) = %-6d ", i, locals[i]);
   }
   printf("\n");
   if ( -1 == sp)
   {
      printf("PC=%d: Stack is empty\n", pc);
      return;
   }
   printf("Stack Contents (top on right):\n ");
   for (i = 0 ; i <= sp; i++)
   {
      printf(" %3d ", stack[i]);
   }
   printf("\n");

}

int main(int argc, char **argv) {
  //int number;                   /* number argument */
  int run = 1;                  /* run flag */
  int sym;                      /* value read in */
  int varnum;
  char debug;
  int i;
  FILE *fp;
 
  if (argc < 2)
  {
     fprintf(stderr, "Improper usage!!  Exitting\n");
     exit(-1);
  } 
 
  if (NULL == (fp = fopen(argv[1], "r") ))
  {
     fprintf(stderr, "Error opening file: %s \n", argv[1]);
     exit(-2);
  } 
  if (2 == argc)
  {
     debug = FALSE;
  }
  else
  {
     for (i = 0; i < strlen(argv[2]); i++) argv[2][i] = tolower(argv[2][i]);
     if (0 == strcmp(argv[2], "debug") )
     {
        debug = 1;
     } 
  }

  while (fscanf(fp,"%d", &sym) != EOF) /* read in program */
    if (getc(fp) == ':') {
      if (sym != pc)
        printf("loader error, loc %d\n", pc), exit(-3);
    }
    else
      memory[pc++] = sym;
  pc = 0;                       /* starting address */
  for (i = 0; i < LOCAL_VARIABLE_SIZE; i++ ) {
     locals[i] = -97823;
  }
 
 while (run) 
 {
    if (debug) print_state();

    switch ((unsigned char) memory[pc++]) {
    case ICONST_M1:             /* push -1 onto stack */
      stack[++sp] = -1;
      break;
    case ICONST_0:              /* push 0 onto stack */
      stack[++sp] = 0;
      break;
    case ICONST_1:              /* push 1 onto stack */
      stack[++sp] = 1;
      break;
    case ICONST_2:              /* push 2 onto stack */
      stack[++sp] = 2;
      break;
    case ICONST_3:              /* push 3 onto stack */
      stack[++sp] = 3;
      break;
    case ICONST_4:              /* push 4 onto stack */
      stack[++sp] = 4;
      break;
    case ICONST_5:              /* push 5 onto stack */
      stack[++sp] = 5;
      break;
    case BIPUSH:                /* bipush <value>, push <byte value> */
      stack[++sp] = memory[pc++];
      break;
    case ILOAD_0:               /* iload_0 push local variable 0 */
      stack[++sp] = locals[0];
      break;
    case ILOAD_1:               /* iload_1 push local variable 1 */
      stack[++sp] = locals[1];
      break;
    case ILOAD_2:               /* iload_2 push local variable 2 */
      stack[++sp] = locals[2];
      break;
    case ILOAD_3:               /* iload_3 push local variable 3 */
      stack[++sp] = locals[3];
      break;
    case ILOAD:                 /* iload <varnum>, push <varnum> */
      stack[++sp] = locals[memory[pc++]];
      break;
    case ISTORE_0:              /* pop stack to local variable 0 */
      locals[0] = stack[sp--];
      break;
    case ISTORE_1:              /* pop stack to local variable 1 */
      locals[1] = stack[sp--];
      break;
    case ISTORE_2:              /* pop stack to local variable 2 */
      locals[2] = stack[sp--];
      break;
    case ISTORE_3:              /* pop stack to local variable 3 */
      locals[3] = stack[sp--];
      break;
    case ISTORE:                /* istore <varnum>, pop to <varnum */
      locals[memory[pc++]] = stack[sp--];
      break;
    case POP:                   /* pop */
      --sp; break;
    case SWAP:                  /* swap top two items of stack */
      { int temp = stack[sp];
        stack[sp] = stack[sp -1];
        stack[sp - 1] = temp; }
      break;
    case DUP:                   /* copy */
      stack[sp + 1] = stack[sp];
      sp++; break;
    case IADD:                  /* add */
      stack[sp -1] = stack[sp - 1] + stack[sp];
      --sp; break;
    case ISUB:                  /* sub */
      stack[sp -1] = stack[sp - 1] - stack[sp];
      --sp; break;
    case IMUL:                  /* mul */
      stack[sp -1] = stack[sp - 1] * stack[sp];
      --sp; break;
    case IDIV:                  /* idiv */
      stack[sp - 1] = stack[sp - 1] / stack[sp];
      --sp; break;
    case IREM:                  /* mod */
      stack[sp -1] = stack[sp - 1] % stack[sp];
      --sp; break;
    case INEG:                  /* negate */
      stack[sp] = - stack[sp];
      break;
    case IINC:                  /* iinc <varnum> <n>, add <n> to <varnum> */
      varnum = memory[pc++];
      locals[varnum] += memory[pc++];
      break;
    case IFEQ:                  /* be */
      if (stack[sp--] == 0)
        pc += memory[pc];
      else
        pc++;
      break;
    case IFGE:                  /* bge */
      if (stack[sp--] >= 0)
        pc += memory[pc];
      else
        pc++;
      break;
    case IFGT:                  /* bg */
      if (stack[sp--] > 0)
        pc += memory[pc];
      else
        pc++;
      break;
    case IFLE:                  /* ble */
      if (stack[sp--] <= 0)
        pc += memory[pc];
      else
        pc++;
      break;
    case IFLT:                  /* bl */
      if (stack[sp--] < 0)
        pc += memory[pc];
      else
        pc++;
      break;
    case IFNE:                  /* bne */
      if (stack[sp--] != 0)
        pc += memory[pc];
      else
        pc++;
      break;
    case GOTO:                  /* goto */
      pc += memory[pc]; break;
    case JSR:  /* Need to implement jump to sub-routine */

      break;
    case RET: /* Need to implement return from sub-routine*/

      break;
    case RETURN:                /* halt */
      run = 0; break;
    case INVOKEVIRTUAL:         /* method call, one arg follows */
                                /* memory[pc] ==1, print; == 2 println. */
                                /* stack[sp] local variable number to */
      if (memory[pc] == 1)      /* print */
        printf("Local_%d: %d\t", stack[sp], locals[stack[sp]]);
      else if (memory[pc] == 2) /* println */
        printf("Local_%d: %d\n", stack[sp], locals[stack[sp]]);
      sp--, pc++;               /* pop arg from stack */
      break;
    default:
      printf("instruction at memory[%d]: %d, bad, bad, bad\n",
             pc - 1, (unsigned char)memory[pc - 1]);
      exit(-4); break;
    }
  } /* endwhile */
  return 0;
}

