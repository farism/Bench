using System;
using System.Diagnostics;
using System.Threading;
using Bench;

namespace Example;

class Program
{
	static int Fib(int n)
	{
		if (n <= 1)
			return n;

		return Fib(n - 1) + Fib(n - 2);
	}

	public static int Main(String[] args)
	{
		TimeIt("Fib(40)", () => Fib(40));

		while (true)
			continue;
	}
}