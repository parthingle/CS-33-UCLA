double fpwr2 (int x)
{
	/* Result exponent and fraction */

	unsigned long exp, frac;
	unsigned long u;

	/*
		The Bias value is calculated using the formula 2^(k-1) - 1; k, in a 64 bit machine is 11. ==> Bias =1023
	*/

	if(x< -1073)
	{
		
		//Smallest denormalized fractional number
		//when x is < -1073 (51 subtracted from -1022), 2^x cannot be accurately measured by a 64 bit computer, and hence outputs 0

		exp = 0;
		frac = 0;
	}
	else if(x< -1022)
	{

	//Denormalized result
	//x is big enough to be accurately depicted by a 64 bit nummber, but it is too small for 2^x to be a number >1, hence the 11 bits that represent the exponent will be 0
		//By the structure of the 'if' blocks, x lies between -1073 and -1023. The value of the fraction can be found by right-shifting 1 by the difference in 52 and the difference between x and -1022
		exp = 0;
		frac = 1<<(52 -(-x-1022));
		
	}
	else if(x< 1024)
	{
	//Normalized result
	//In this 'if' block, x ranges from -1022 to 1024.
	//In the normalized range, the fractional part is 0, and the power of 2 lies between 1 and 2046
		exp = x+1023;
		frac = 0;
	}
	else
	// A 64 bit machine cannot handle an exponent of 2 greater than 2046, and it causes the double to overflow to +ve infinity
	{
		exp = 2047;
		frac = 0;
	}
}

int main()
{;}
