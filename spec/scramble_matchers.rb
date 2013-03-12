class BeValidScramble
  
  def initialize
    @sequencer = Ramsdel::Sequencer.new(Ramsdel::Puzzles::THREE_BY_THREE)
  end

  def matches?(scramble)
    @scramble = scramble
    matches_format or @failure = "does not match the format of a scramble"
    no_subsequent_same_face or @failure = "contains the same face twice in a row"
    no_same_axis_three_times or @failure = "has redundant moves"

    @failure.nil?
  end

  def matches_format
    @scramble =~ /^((U|D|L|R|F|B)('|2)?\ ?)*$/
  end

  def no_subsequent_same_face
    @scramble.split(" ").each_cons(2).all? { |(a,b)| @sequencer.prefix(a) != @sequencer.prefix(b) }
  end

  def no_same_axis_three_times
    !@scramble.split(" ").each_cons(3).any? { |moves| @sequencer.same_axis?(*moves) }
  end

  def failure_message
    "\"#@scramble\" #@failure"
  end
end

class BeComposedOf
  def initialize(moves)
    @moves = moves
    @sequencer = Ramsdel::Sequencer.new(Ramsdel::Puzzles::THREE_BY_THREE)
  end

  def prefix(move)
    @sequencer.prefix(move)
  end

  def matches?(scramble)
    @scramble = scramble
    @scramble.split(" ").map { |move| prefix(move) }.all? { |face| @moves.include?(face) }
  end

  def failure_message
    "#@scramble contains moves not in #{@moves.inspect}"
  end
end
