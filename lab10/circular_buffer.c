#include <stdio.h>
#include <string.h>

/* Note: CBUFSIZE must be a power of 2 */
#define CBUFSIZE 8
#define CBUFMASK (CBUFSIZE - 1)

void init_buffer(void);
void put(char);
char get(void);
void printbuf(void);

char cbuf[CBUFSIZE];
unsigned long int in, out, count;

int main()
{
	char c, input = 0;

	init_buffer();

	while ('q' != input)
	{
		printf("enter action (p=put,g=get,y=print,q=quit): ");
		scanf("\n%c", &input);

		switch(input)
		{
			case 'p':
				printf("  enter character to put: ");
				scanf("\n%c", &input);
				put(input);
				break;
			case 'g':
				c = get();
				if (!c)
				{
					printf("  can't get from empty buffer.\n");
				}
				else
				{
					printf("  character removed is: %c\n",c);
				}
				break;
			case 'y':
				printbuf();
				break;
			case 'q':
				break;
			default:
				printf("  unrecognized action\n");
				break;
		}
	}

	return 0;
}

void init_buffer()
{
	in = out = count = 0;
}

void printbuf()
{
	int i, j;

	if (count == 0)
	{
		printf("The buffer is empty.\n");
		return;
	}

	for (i = out, j = 0; j < count; j++)
	{
		printf("%c ", cbuf[i]);
		i = (i + 1) & CBUFMASK;
	}

	printf("\n");
}

void put(char val)
{
	// check if the buffer is full
	if (count == CBUFSIZE)
	{
		printf("Sorry: buffer is full.\n");
	}
	else
	{
		// insert value into the next available spot in the buffer
		cbuf[in] = val;

		// increment "in", the index of the next open spot, the & CBUFMASK
		// ensures that if "in" exceeds the size of the buffer, that it wraps
		// around to the beginning of the buffer again. "& CBUFMASK" is the same
		// as "% CBUFSIZE" (but quicker!)
		in = (in + 1) & CBUFMASK;

		// increment the buffer count (number of things in the buffer)
		count++;
	}
}

char get(void)
{
	register char val;

	// check if the buffer is empty
	if (count == 0)
	{
		printf("empty\n");

		// return the null character (empty string)
		return '\0';
	}
	else
	{
		// get the item from the buffer that is next in line
		val = cbuf[out];

		// increment "out" the same way we do "in", logically "and"ing with
		// CBUFMASK to wrap around the buffer once we've passed the end
		out = (out + 1) & CBUFMASK;

		// decrement the count of the number of things in the buffer
		count--;

		// return the character we just got from the buffer
		return val;
	}
}
