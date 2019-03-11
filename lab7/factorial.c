#include <stdio.h>

int fact(int register value)
{
	if (value == 1)
	{
		return 1;
	}
	else
	{
		return value * fact(value - 1);
	}
}

int main(void)
{
	register unsigned int i, j;

	i = 10;
	j = fact(i);

	printf("The factorial of %d is %d\n", i, j);

	return 0;
}
