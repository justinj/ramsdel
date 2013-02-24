module Scramblang
  class Sequencer
    def initialize(moves, length)
      moves = moves.split(",").product(["'","2",""]).map { |move| move.join }
      @moves = parse_moves moves
      @length = length.to_i

    end

    def opposite face
      {"U"=>"D","D"=>"U","L"=>"R","R"=>"L","F"=>"B","B"=>"F"}[face] 
    end

    def face move
      if move[1] == "w"
        opposite move[0]
      else
        move[0]
      end
    end

    def parse_moves moves
      default_axes = [[suf("U"), suf("D")], [suf("L"), suf("R")], [suf("F"), suf("B")]]
      filtered = default_axes.map do |axis|
        axis.map do |face|
          face.select { |move| moves.include? move }
        end
      end
      remove_empty(filtered)
    end

    def remove_empty(axes)
      axes.map do |axis|
        axis.reject { |face| face.empty? }
      end.reject { |axis| axis.empty? }
    end

    def suf move
      ["'","2",""].map { |suffix| move + suffix } | ["w","w2","w'"].map { |suffix| opposite(move) + suffix }
    end

    #[cube [axis [face]]]
    def same_axis?(*moves)
      @moves.any? do |axis|
        moves.all? do |move| 
          axis.any? { |face| face.include? move }
        end
      end
    end

    def same_face?(*moves)
      @moves.any? do |axis|
        axis.any? do |face| 
          moves.all? do |move| 
            face.include? move
          end
        end
      end
    end

    def prefix(move)
      move[0..-2]
    end

    def valid_move?(scramble, move)
      last = scramble[-1]
      second_last = scramble[-2]
      return true if last.nil?
      return false if same_face?(last, move)
      return true if second_last.nil?
      return false if same_axis?(move, last, second_last)
      true
    end

    def create
      scramble = []
      until scramble.count >= @length
        move = @moves.sample.sample.sample
        if valid_move?(scramble, move)
          scramble << move
        end
      end
      scramble.join(" ")
    end
  end 
end
