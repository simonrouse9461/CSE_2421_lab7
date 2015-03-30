#include <stdio.h>

static int some_static_int = 0;

int complex_function(int arg1, int arg2)
{

	int temp1 = arg1 - 7;
	int temp2 = arg2;
	int temp3 = arg1 * arg2;
	int retval = temp1;

	if (temp2 >= 0) goto else_0;
	retval += 17;
	goto done_0;

else_0:
	retval -= 13;

done_0:
	if (arg1 == 0) goto case_0;
	if (arg1 == 1) goto case_1;
	if (arg1 == 2) goto case_2;
	if (arg1 == 3) goto case_3;
	goto case_default;

case_0:
	retval = retval + temp2 + some_static_int + 4;

case_1:
	retval = retval - temp2 + 5;
	goto done_1;

case_2:
	retval = retval - 13 - some_static_int;
	goto done_1;

case_3:
	retval = retval + (temp3 * 7) - temp2;

case_default:
	retval += 1;

done_1:
	some_static_int = some_static_int - arg1 + retval;
	return retval;
}

int main(int argc, char **argv)
{

	int outer_limit = atoi(argv[1]);
	int inner_limit = atoi(argv[2]);
	int counter1;
	int counter2;

	counter1 = 0;

loop_0:
	if (counter1 >= outer_limit) goto done_loop_0;
		counter2 = 2;

loop_1:
	if (counter2 <= inner_limit) goto done_loop_1;
	int temp = complex_function(counter1, counter2);
	printf("(%d, %d): %d\n", counter1, counter2, temp);
	counter2--;
	goto loop_1;

done_loop_1:
	counter1++;
	goto loop_0;

done_loop_0:
	return 0;

}
