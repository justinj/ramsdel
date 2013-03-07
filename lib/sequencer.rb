module Ramsdel
  class Sequencer
    def initialize(puzzle_definition)
      @axes = make_move_list(puzzle_definition)
      @suffixes = puzzle_definition[:suffixes]
    end

    def scramble(length)
      scramble = []
      until scramble.count == length
        new_move = random_move
        scramble << new_move if valid_move?(scramble, new_move)
      end
      scramble.join(" ")
    end

    def valid_move?(scramble, move)
      return true if scramble.empty?
      return false if same_face?(scramble.last, move)
      return true if scramble.count == 1
      true
    end

    def random_move
      @axes.sample.sample.sample.join
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
      @suffixes.inject(move) { |move, suffix| move.chomp suffix }
    end

    def suffix(move)
      suffix = @suffixes.sort_by { |s| -s.length }.find { |suffix| move.end_with?(suffix) }
      suffix || raise("#{move} does not end with a valid suffix")
    end
  end 
end
