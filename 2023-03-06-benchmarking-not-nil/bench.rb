#!/usr/bin/env ruby

require "benchmark/ips"

value1 = 1
value2 = nil

Benchmark.ips do |x|
  x.report("nil != value") do
    nil != value1
    nil != value2
  end
  x.report("!value.nil?") do
    !value1.nil?
    !value2.nil?
  end
  x.report("value != nil") do
    value1 != nil
    value2 != nil
  end
end

