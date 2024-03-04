#!/usr/bin/env ruby

require 'date'
require 'benchmark/ips'

require 'active_support'
require 'active_support/core_ext/time'

Benchmark.ips do |x|
  x.report("DateTime.now.iso8601(9) - baseline") { DateTime.now.iso8601(9) }
  x.report("DateTime.now.strftime('%FT%T.%9N%:z') - iso8601 equivalent") { DateTime.now.strftime('%FT%T.%9N%:z') }
  x.report("Time.now.iso8601(9) - activesupport shim") { Time.now.iso8601(9) }
  x.report("Time.now.strftime('%FT%T.%9N%:z') - activesupport equivalent") { Time.now.strftime('%FT%T.%9N%:z') }
  x.report("Time.now.to_s - string, localtime") { Time.now.to_s }
  x.report("Time.now.to_r.to_s - rational + string, epoch") { Time.now.to_r.to_s }
  x.report("Time.now.to_r - rational, epoch") { Time.now.to_r }
  x.report("Time.now.utc.to_s - string, UTC") { Time.now.utc.to_s }
  x.report("Time.now.to_f.to_s - float + string, epoch") { Time.now.to_f.to_s }
  x.report("Time.now.to_f - float, epoch") { Time.now.to_f }
  x.report("Process.clock_gettime - monotonic") { Process.clock_gettime(Process::CLOCK_MONOTONIC) }

  x.compare!
end
