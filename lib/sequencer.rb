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
    
    def opposites?(*moves)
      @axes.any? do |axis|
        moves.all? do |move|
          axis.map { |face| face.map(&:join) }.inject(:+).include? move
        end
      end
    end
  end 
end
