require_relative "parser"

module Ramsdel
  class Interpreter
    def initialize(definition)
      parser = Parser.new
      puts parser.tokenize(definition)
    end
  end
end
