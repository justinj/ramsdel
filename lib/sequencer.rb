module Ramsdel
  class Sequencer
    def initialize(puzzle_definition)
      @axes = make_move_list(puzzle_definition)
      @suffixes = puzzle_definition[:suffixes]
      @allowed_moves = puzzle_definition.fetch(:default_allowed, @axes.flatten)
    end

    def allow(moves)
      @allowed_moves = moves
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
      return false unless @allowed_moves.include?(move)
      return true if scramble.empty?
      return false if same_face?(scramble.last, move)
      return true if scramble.count == 1
      true
    end

    def random_move
      @allowed_moves.sample
    end

    def make_move_list(puzzle_definition)
      axes = puzzle_definition[:axes]
      suffixes = puzzle_definition[:suffixes]
      axes.map { |axis| axis.map { |move| suffixes.map { |suffix| move + suffix } } }
    end
    private :make_move_list
    
    def same_axis?(*moves)
      @axes.any? do |axis|
        moves.all? do |move|
          axis.inject(:+).include? move
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
