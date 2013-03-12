module Ramsdel
  class MoveProvider
    include Enumerable
    def initialize(moves)
      @moves = moves 
      @enum = to_enum
    end

    def next
      @enum.next
    end
    
    def each
      return to_enum unless block_given?
      
      loop { yield @moves.sample }
    end
  end
  class Sequencer
    def initialize(puzzle_definition)
      @axes = make_move_list(puzzle_definition)
      @suffixes = puzzle_definition[:suffixes]
      allow puzzle_definition.fetch(:default_allowed, @axes.flatten)
    end

    def allow(moves)
      @provider = MoveProvider.new(moves)
    end

    def scramble(length)
      scramble = []
      until scramble.count == length
        new_move = random_move
        scramble << new_move if valid_move?(scramble, new_move)
      end
      scramble.join(" ")
    end

    def random_move
      @provider.next
    end

    def valid_move?(scramble, move)
      return true if scramble.count == 0
      return false if same_face?(scramble.last, move)
      return true if scramble.count == 1
      return false if same_axis?(scramble[-1], scramble[-2], move)
      return true
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
          axis.flatten.include? move
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
      suffix or raise("#{move} does not end with a valid suffix")
    end
  end 
end
