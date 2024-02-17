#!/usr/bin/env ruby

puts RUBY_DESCRIPTION
puts RubyVM::InstructionSequence.new(File.read(ARGV.shift)).disassemble
