#include <stdio.h>

struct point
{
	int x,y;
};

struct point init(int x_arg, int y_arg)
{
	struct point local;

	local.x = x_arg;
	local.y = y_arg;

	return local;
}


struct point zero()
{
	struct point local;

	local.x = 0;
	local.y = 0;

	return local;
}

int main()
{
	struct point dot;

	dot = init(34, -3);
	printf("The members of the structure dot are %d,%d\n",dot.x,dot.y);

	dot = zero();
	printf("The members of the structure dot are %d,%d\n",dot.x,dot.y);

	return 0;
}
