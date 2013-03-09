require_relative "sequencer"
require_relative "puzzles"

module Ramsdel
  module Term
    def self.create(definition)
      parts = definition.split(/\s*\*\s*/)
      length = 1
      movelist = ""
      parts.each do |part|
        case part
        when /\d+/; length = part.to_i
        else; movelist = part
        end
      end

      make_term(movelist,length)
    end

    private 

    def self.make_term(movelist, length)
      case movelist
      when /\[(?<moves>.*?)\]/
        ExplicitMoveTerm.new($~[:moves].split(","),length)
      when /<(?<moves>.*?)>/
        ImplicitMoveTerm.new($~[:moves].split(","),length)
      else
        raise "Unrecognized term #{definition}"
      end
    end


    class MoveTerm

      attr_reader :length
      attr_reader :allowed_moves

      def initialize(allowed_moves, length)
        @length = length 
        @sequencer = Sequencer.new(Ramsdel::Puzzles::THREE_BY_THREE)
        @allowed_moves = allowed_moves
        @sequencer.allow(allowed_moves)
      end

      def generate
        @sequencer.scramble(@length)
      end

    end

    class ExplicitMoveTerm < MoveTerm
    end

    class ImplicitMoveTerm < MoveTerm
      def initialize(allowed_moves, length)
        moves = allowed_moves.product(["2","'",""]).map(&:join)
        super(moves,length)
      end
    end

  end
end
