module Ramsdel
  class MoveTerm

    def initialize(length)
      @length = length 
      @sequencer = Sequencer.new(Ramsdel::Puzzles::THREE_BY_THREE)
    end

    def generate
      @sequencer.scramble(@length)
    end

  end

  class ImplicitMoveTerm
    def initialize(allowed_moves, length)
      super
      @sequencer.allow(allowed_moves)
    end
  end

  class ExplicitMoveTerm
    def initialize(allowed_moves, length)
      super
      @sequencer.allow(allowed_moves.product(["2","'",""]).map(&:join)
    end
  end
end
