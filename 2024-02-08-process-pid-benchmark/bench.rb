#!/usr/bin/env ruby

require 'benchmark/ips'
require 'pid_cache' if ENV["PID_CACHE"] == "1"

Benchmark.ips do |x|
  x.report("$$") { $$ }
  x.report("Process.pid") { Process.pid }
  x.compare!
end
