#!/usr/bin/env ruby

require_relative "scramblang"
ARGV[0].to_i.times do
  @scrambler = Scramblang::Scrambler.new(File.read(ARGV[1]))
  puts @scrambler.next
end
