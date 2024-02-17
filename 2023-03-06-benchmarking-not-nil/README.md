# Perf difference of nil comparisons

There's a measurable/consistent difference between:

```ruby
value != nil
```

```ruby
nil != value
```

```ruby
!value.nil?
```

## Ruby 3.3

[instructions](./disasm_3_3.txt)

```
ruby 3.3.0 (2023-12-25 revision 5124f9ac75) [x86_64-linux]
Warming up --------------------------------------
        value != nil   214.821k i/100ms
        nil != value   755.403k i/100ms
         !value.nil?   762.571k i/100ms
Calculating -------------------------------------
        value != nil      2.112M (±10.0%) i/s -     10.526M in   5.040928s
        nil != value      7.107M (± 9.1%) i/s -     35.504M in   5.042381s
         !value.nil?      7.168M (± 8.2%) i/s -     35.841M in   5.037293s
```

## Ruby 3.2

[instructions](./disasm_3_2.txt)

```
ruby 3.2.2 (2023-03-30 revision e51014f9c0) [x86_64-linux]
Warming up --------------------------------------
        value != nil   225.814k i/100ms
        nil != value   726.538k i/100ms
         !value.nil?   962.237k i/100ms
Calculating -------------------------------------
        value != nil      2.430M (± 4.7%) i/s -     12.194M in   5.029254s
        nil != value      8.280M (±12.2%) i/s -     40.686M in   5.014189s
         !value.nil?      9.552M (±12.2%) i/s -     47.150M in   5.036877s
```

## Ruby 3.1

[instructions](./disasm_3_1.txt)

```
ruby 3.1.4p223 (2023-03-30 revision 957bb7cb81) [x86_64-linux]
Warming up --------------------------------------
        value != nil   188.883k i/100ms
        nil != value   821.963k i/100ms
         !value.nil?   848.066k i/100ms
Calculating -------------------------------------
        value != nil      2.274M (±10.0%) i/s -     11.333M in   5.037605s
        nil != value      7.702M (±11.4%) i/s -     38.632M in   5.090334s
         !value.nil?      8.381M (± 6.6%) i/s -     42.403M in   5.084587s
```

## Notes

I can't claim credit for finding this one, I think saw it on StackOverflow / as
a Rubocop performance rule and just wanted to independently reproduce it/figure
it out. I can't find the original post after casual googling tho.

The instruction sequences for the first two seem really similar, so the
difference probably lies in the way they are executed/implemented in the VM.

## Tools

[./bench.rb](benchmark)
[./disasm.rb](utility to dump instruction sequences)
