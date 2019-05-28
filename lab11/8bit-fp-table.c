#include <stdio.h>
#include <math.h>

int main()
{
  int sign, exp, fraction, significand;
  int i;
  float f;
  float prev = 0;

  for (i = 0; i < 256; i++)
  {
    /* begin your code */
    sign = (i >> 7) & 1; // shift by 7 and by 1
    exp = (i >> 3) & 15; // shift by 3 and by 15
    fraction = i & 7;
    
    int denormal = 0;
    
    // check denormal, adjust it
    if(exp == 0)
    {
        denormal = 1;
        exp = -7;
    } 
    
    // convering exponent
    else exp = exp - 8;
    
    if(denormal == 0)
        significand = 8 | fraction;
    //       significand = significand | 0;
    else significand = fraction;
 

    f = significand;
    while(exp > 0)
    {
        f *= 2;
        exp--;
    }
    while(exp < 0)
    {
        f/=2;
        exp++;
    }
    


    if(sign == 1)
        f *= -1;
    

    /* end your code */

    printf ("%02x => %08x = %+11.6f (spacing = %+11.6f)\n",
            i, *(int*) &f, f, prev-f);
    prev = f;
  }
  
  return 0;
}
