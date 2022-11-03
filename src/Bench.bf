using System;
using System.Diagnostics;
using System.Threading;
using System.Collections;
using System.Globalization;

namespace Bench;

static
{
	static bool headerShown = false;

	// Computes total of a delta list.
	static double Total(List<double> deltas)
	{
		double result = 0;
		for (let v in deltas)
			result += v;
		return result;
	}

	// Computes mean (average) of a delta list.
	static double Min(List<double> d)
	{
		if (d.Count == 0)
			return 0;

		var result = double.MaxValue;

		for (let i in d)
			result = Math.Min(result, i);

		return result;
	}

	// Gets the min value of a delta list.
	static double Mean(List<double> d)
	{
		if (d.Count == 0)
			return 0;

		return Total(d) / (float)d.Count;
	}

	// Gets median (middle number) of a delta list.
	static double Median(List<double> d)
	{
		if (d.Count == 0)
			return 0;

		return d[(int)Math.Round(d.Count / 2)];
	}

	// Computes the sample variance of a delta list.
	static double Variance(List<double> d)
	{
		var result = 0.0;

		if (d.Count <= 1)
			return 0;

		let a = Mean(d);

		for (let v in d)
			result += Math.Pow((v - a), 2);

		return result / float(d.Count - 1);
	}

	// Computes the sample standard deviation of a delta list.
	static double StdDev(List<double> d)
	{
		return Math.Sqrt(Variance(d));
	}

	static void RemoveOutliers(ref List<double> d, double p = 3.0)
	{
		let avg = Mean(d),
			std = StdDev(d);

		for (let i in (0 ..< d.Count).Reversed)
		{
			if (Math.Abs(d[i] - avg) > std * p)
				d.RemoveAt(i);
		}
	}

	static void FormatNumber(double n, String str)
	{
		NumberFormatter.NumberToString("0.000", n, scope NumberFormatInfo(), .. str);
	}

	public static void TimeIt(StringView tag, function void() fn)
	{
		TimeIt(tag, 0, fn);
	}

	public static void TimeIt(StringView tag, int iterations, function void() fn)
	{
		if (!headerShown)
		{
			headerShown = true;
			Console.WriteLine("    min time       avg time         std dv     runs    name");
		}

		var
			i = 0,
			total = 0.0,
			deltas = new List<double>();

		defer
		{
			delete deltas;
		}

		// warm up
		/*for (let j in 0 ..< 15)
			fn();*/

		while (true)
		{
			i++;

			let stopwatch = scope Stopwatch()..Start();

			fn();

			total += stopwatch.ElapsedMilliseconds;

			deltas.Add(stopwatch.ElapsedMilliseconds);

			if (iterations != 0 && i >= iterations)
				break;

			if (total >= 5000 || i >= 1000)
				break;
		}

		let min = FormatNumber(Min(deltas), .. scope $"")..Append(" ms")..PadLeft(12, ' ');

		RemoveOutliers(ref deltas);

		let mean = FormatNumber(Mean(deltas), .. scope $"")..Append(" ms")..PadLeft(14, ' '),
			stdDev = FormatNumber(StdDev(deltas), .. scope $"±")..PadLeft(15, ' '),
			runs = scope $"x{i}"..PadLeft(8, ' ');

		Console.WriteLine(scope $"{min} {mean} {stdDev} {runs}    {tag}");
	}

	[Test]
	static void Default()
	{
		TimeIt("Sleep 1ms", () => Thread.Sleep(1));

		TimeIt("Sleep 200ms", () => Thread.Sleep(200));

		TimeIt("Sleep Random", () => Thread.Sleep(scope Random().Next(0, 150)));

		TimeIt("Number Counter", () =>
			{
				var s = 0;
				for (let i in 0 ... 100000000)
					s++;
			});

		TimeIt("String Append", () =>
			{
				var s = new $"?";
				for (let i in 0 ... 26)
					s.Append(s);
				delete s;
			});
	}

	[Test]
	static void Iterations()
	{
		TimeIt("Sleep 1ms x5", 5, () => Thread.Sleep(1));

		TimeIt("Sleep 200ms x5", 5, () => Thread.Sleep(200));

		TimeIt("Sleep Random x20", 20, () => Thread.Sleep(scope Random().Next(0, 150)));

		TimeIt("Number Counter x20", 20, () =>
			{
				var s = 0;
				for (let i in 0 ... 100000000)
					s++;
			});

		TimeIt("String Append x20", 20, () =>
			{
				var s = new $"?";
				for (let i in 0 ... 26)
					s.Append(s);
				delete s;
			});
	}
}