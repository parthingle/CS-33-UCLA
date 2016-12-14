int main()
{

	int result;
	__builtin_add_overflow(int x, int y, &result);

	return result;
}

