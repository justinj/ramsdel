require "pp"
require_relative "sequencer"

module Scramblang
  class Scrambler
    def initialize(definition)
      @library = {
        "+" => lambda { |args| args.map {|expr| run expr }.join(" ") },
        "*" => lambda do |args| 
          (args.take(args.count - 1) * args.last.to_i).map { |expr| run expr }.join(" ") 
        end
      }
      @tokens = tokenize definition
      @tree = parse_tokens
    end

    def next
      run @tree
    end

    def run node
      if node.is_a? String
        literal node
      elsif node.is_a? Array
        @library[node.first].call(node.drop 1)
      end
    end

    def literal node
      if /<(?<moves>.*)>(?<times>\d+)/ =~ node
        create_sequence(moves, times)
      else
        node
      end
    end

    def create_sequence(moves, length)
      sequencer = Sequencer.new(moves, length)      
      sequencer.create
    end

    def tokenize s
      s.gsub(/([\(\)])/,' \1 ').split
    end

    def parse_tokens
      token = @tokens.shift
      if token == "("
        branch = []
        branch << parse_tokens until @tokens.first == ")"
        @tokens.shift
        branch
      else
        token
      end
    end
  end
end
