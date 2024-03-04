# Querying for current time

It turns out that frequent calls to (Date)Time#iso8601 are quite slow.

I've added other methods into the mix, just to see how they compare,
even though they might have a different use case.

My hunch is that the slow-down is due to the string
[allocation/formatting](https://github.com/ruby/ruby/blob/eb6eb1d4e8572fffd7bce6789eb8e87669293eef/ext/date/date_core.c#L8762)
, and taking time zones into account.

```ruby
Process.clock_gettime - monotonic:                           4377583.9 i/s
Time.now.to_f - float, epoch:                                2454758.5 i/s -  1.78x  slower
Time.now.to_r - rational, epoch:                              995037.5 i/s -  4.40x  slower
Time.now.to_r.to_s - rational + string, epoch:                497177.3 i/s -  8.80x  slower
Time.now.to_f.to_s - float + string, epoch:                   397097.4 i/s - 11.02x  slower
Time.now.utc.to_s - string, UTC:                              368614.8 i/s - 11.88x  slower
Time.now.to_s - string, localtime:                            265995.5 i/s - 16.46x  slower
Time.now.strftime('%FT%T.%9N%:z') - time iso8601 equivalent:  216731.3 i/s - 20.20x  slower
Time.now.iso8601(9) - time:                                   171045.8 i/s - 25.59x  slower
DateTime.now.strftime('%FT%T.%9N%:z') - iso8601 equivalent:   157344.3 i/s - 27.82x  slower
DateTime.now.iso8601(9) - baseline:                           132501.8 i/s - 33.04x  slower
```
