int saturating_add (int x, int y)
{
	int sum = x+y;
	int n = ( sizeof (int) <<3 ) -1;
	int xneg = x >> n;
	int yneg = y >> n;
	int sum_neg = sum>> n;
	int pos_over = ~xneg&~yneg&sum_neg;
	int neg_over = xneg & yneg & ~sum_neg;
	int over = pos_over|neg_over;
	
	int result = (pos_over&INT_MAX) | (neg_over& INT_MIN);
		
	return result;

}
