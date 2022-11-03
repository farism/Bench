# Bench - Benchmark your code

[Reference Docs](https://farism.github.io/Bench/html/)

`Bench` is a simple benchmarking library for Beef lang. It provides a single function: `TimeIt`.

This library is heavily inspired by [Benchy](https://github.com/treeform/benchy)

Example output:

```
 >    min time       avg time         std dv     runs    name
 >    1.000 ms       1.427 ms         ±0.495    x1000    Sleep 1ms
 >  200.000 ms     200.000 ms         ±0.000      x25    Sleep 200ms
 >    0.000 ms      73.912 ms        ±43.243      x68    Sleep Random
 >   25.000 ms      25.760 ms         ±1.100     x193    Number Counter
 >   72.000 ms      72.939 ms         ±1.477      x68    String Append
```

# Installing

1. Clone this repo somewhere to your system.
2. In the Beef IDE, right-click workspace panel select "Add Existing Project". Locate the directory you cloned earlier.
3. For each project that will use `Bench`, right-click > Properties > Dependencies and select `Bench`.

# Usage

```bf
using System;
using System.Threading;
using Bench;

TimeIt("Sleep 1000ms", () => Thread.Sleep(1000));

// OR specify number of iterations

TimeIt("Sleep 5ms x100", 100, () => Thread.Sleep(5));
```

If no `iterations` are specified, `Bench` will run the code up to `x1000` times or for `5000ms`, whichever comes first.

# Note

It is recommended to use a release configuration with optimizations turned on when running benchmarking. Beef workspaces make this fairly easy to do.

# License

MIT