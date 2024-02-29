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
Time.now.to_f - float, epoch:                                  1259839.3 i/s
Time.now.to_f.to_s - float + string, epoch:                     262387.3 i/s - 4.80x  slower
Time.now.utc.to_s - string, UTC:                                211925.7 i/s - 5.94x  slower
Time.now.to_s - string, localtime:                              171308.2 i/s - 7.35x  slower
Time.now.strftime('%FT%T.%9N%:z') - activesupport equivalent:   144008.6 i/s - 8.75x  slower
Time.now.iso8601(9) - activesupport shim:                       108559.0 i/s - 11.61x  slower
DateTime.now.strftime('%FT%T.%9N%:z') - iso8601 equivalent:      86853.7 i/s - 14.51x  slower
DateTime.now.iso8601(9) - baseline:                              81973.9 i/s - 15.37x  slower
```
