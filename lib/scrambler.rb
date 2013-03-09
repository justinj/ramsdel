#!/usr/bin/env ruby

require_relative "parser"
require_relative "term"

module Ramsdel
  class Scrambler
    def initialize definition
      parser = Ramsdel::Parser.new
      @terms = parser.tokenize(definition).map { |definition| Ramsdel::Term::create(definition) }
    end

    def next
      @terms.map { |term| term.generate }.join(" ") 
    end
  end
end
