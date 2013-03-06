module Ramsdel
  class Sequencer
    def initialize(puzzle_definition)
      @axes = make_move_list(puzzle_definition)
    end

    def make_move_list(puzzle_definition)
      axes = puzzle_definition[:axes]
      suffixes = puzzle_definition[:suffixes]
      axes.map { |axis| axis.map { |move| [move].product(suffixes) } }
    end
    private :make_move_list
    
    def same_axis?(*moves)
      @axes.any? do |axis|
        moves.all? do |move|
          axis.map { |face| face.map(&:join) }.inject(:+).include? move
        end
      end
    end

    def same_face?(*moves)
      moves.all? { |move| prefix(move) == prefix(moves.first) }
    end

    def prefix(move)
      #this is probably ugly but I'm tired and I can't tell
      move.each_char.take([1,move.length-1].max).join
    end
  end 
end
