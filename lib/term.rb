module Ramsdel
  module Term

    def self.create(definition)
      case definition
      when /\[(?<moves>.*?)\](?<length>\d+)/
        ExplicitMoveTerm.new($~[:moves].split(","),$~[:length].to_i)
      when /<(?<moves>.*?)>(?<length>\d+)/
        ImplicitMoveTerm.new($~[:moves].split(","),$~[:length].to_i)
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
