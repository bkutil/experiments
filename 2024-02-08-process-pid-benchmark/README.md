# Performance of fetching a PID

The need to detect process ID changes arises in code mixing
threads/forking, as only the main thread gets copied over to the child
process, and the other need to be re-started.

There's a performance loss b/c an internal glibc pid cache got removed
in [libc 2.25](https://sourceware.org/glibc/wiki/Release/2.25#pid_cache_removal).

A [pid_cache gem](https://github.com/Shopify/pid_cache)
mitigates this for older Rubies, on Ruby 3.3+ this has been fixed in the
VM directly.

```
dpkg -s libc6 | grep Version:
Version: 2.31-13+deb11u7
```

## Ruby 3.3

(Issue fixed in MRI).

```
ruby 3.3.0 (2023-12-25 revision 5124f9ac75) [x86_64-linux]
Warming up --------------------------------------
                  $$     1.027M i/100ms
         Process.pid   770.879k i/100ms
Calculating -------------------------------------
                  $$     10.785M (± 6.6%) i/s -     54.450M in   5.071929s
         Process.pid      7.653M (± 5.9%) i/s -     38.544M in   5.056729s

Comparison:
                  $$: 10784576.3 i/s
         Process.pid:  7653482.9 i/s - 1.41x  slower
```

## Ruby 3.2

```
ruby 3.2.2 (2023-03-30 revision e51014f9c0) [x86_64-linux]
Warming up --------------------------------------
                  $$   162.670k i/100ms
         Process.pid   150.169k i/100ms
Calculating -------------------------------------
                  $$      1.527M (±14.5%) i/s -      7.483M in   5.076198s
         Process.pid      1.538M (± 6.2%) i/s -      7.659M in   4.999731s

Comparison:
         Process.pid:  1538337.7 i/s
                  $$:  1527259.8 i/s - same-ish: difference falls within error
```

## Ruby 3.2 with pid_cache

Using the `pid_cache` gem, only `Process.pid` was fixed.

```
ruby 3.2.2 (2023-03-30 revision e51014f9c0) [x86_64-linux]
Warming up --------------------------------------
                  $$   167.073k i/100ms
         Process.pid   493.054k i/100ms
Calculating -------------------------------------
                  $$      1.629M (± 4.6%) i/s -      8.187M in   5.036055s
         Process.pid      5.046M (± 6.7%) i/s -     25.146M in   5.009096s

Comparison:
         Process.pid:  5045774.2 i/s
                  $$:  1629039.3 i/s - 3.10x  slower
```
