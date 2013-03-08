#!/usr/bin/env ruby

require_relative "parser"
require_relative "move_term"

definition = ARGF.read

parser = Ramsdel::Parser.new

parser.tokenize(definition).map { |definition| Ramsdel::Term::create(definition) }
