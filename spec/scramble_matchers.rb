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
