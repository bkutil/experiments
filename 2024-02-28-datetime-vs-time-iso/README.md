# Querying for current time

It turns out that frequent calls to (Date)Time#iso8601 are quite slow.

Here's a [micro-benchmark](./bench.rb) with
`active_support/core_ext/time`, which adds `Time#iso8601`.

I've added other methods into the mix, just to see how they compare,
even though they might have a different use case.

My hunch is that the slow-down is due to the string
[allocation/formatting](https://github.com/ruby/ruby/blob/eb6eb1d4e8572fffd7bce6789eb8e87669293eef/ext/date/date_core.c#L8762)
, and taking time zones into account.

```ruby
Process.clock_gettime - monotonic:                             5129510.3 i/s
Time.now.to_f - float, epoch:                                  2190267.0 i/s - 2.34x  slower
Time.now.to_r - rational, epoch:                               1028269.1 i/s - 4.99x  slower
Time.now.to_r.to_s - rational + string, epoch:                  549787.2 i/s - 9.33x  slower
Time.now.to_f.to_s - float + string, epoch:                     471081.9 i/s - 10.89x  slower
Time.now.utc.to_s - string, UTC:                                383069.4 i/s - 13.39x  slower
Time.now.to_s - string, localtime:                              309252.1 i/s - 16.59x  slower
Time.now.strftime('%FT%T.%9N%:z') - activesupport equivalent:   257407.9 i/s - 19.93x  slower
Time.now.iso8601(9) - activesupport shim:                       195736.0 i/s - 26.21x  slower
DateTime.now.iso8601(9) - baseline:                             147530.0 i/s - 34.77x  slower
DateTime.now.strftime('%FT%T.%9N%:z') - iso8601 equivalent:     122722.3 i/s - 41.80x  slower
```
