require_relative "spec_helper"


describe Ramsdel::Sequencer do
  class BeValidScramble
    def matches?(scramble)
      @scramble = scramble
      matches_format || @failure = "does not match the format of a scramble"
      no_subsequent_same_face || @failure = "contains the same face twice in a row"

      @failure.nil?
    end

    def matches_format
      @scramble =~ /^((U|D|L|R|F|B)('|2)?\ ?)*$/
    end

    def no_subsequent_same_face
      @scramble.split(" ").each_cons(2).all? { |(a,b)| a[0] != b[0] }
    end

    def failure_message
      "\"#@scramble\" #@failure"
    end
  end
  let(:sequencer) { Ramsdel::Sequencer.new(Ramsdel::Puzzles::THREE_BY_THREE) }
  let(:be_valid_scramble) { BeValidScramble.new }

  describe "#same_axis?" do
    it "is true if two moves are on the same axis" do
      sequencer.same_axis?("F","B").should eql true 
      sequencer.same_axis?("F","F").should eql true 
      sequencer.same_axis?("F","B'").should eql true 
    end

    it "is false if two moves are not on the same axis" do
      sequencer.same_axis?("F","R").should eql false
    end
  end

  describe "#same_face?" do
    it "is true if two moves are on the same face" do
      sequencer.same_face?("F", "F").should eql true
    end

    it "is false if two moves are not on the same face" do
      sequencer.same_face?("F","R").should eql false
      sequencer.same_face?("F","B").should eql false
    end
  end

  describe "#prefix" do
    it "gets the prefix of a move" do
      sequencer.prefix("F2").should eql "F"
      sequencer.prefix("F'").should eql "F"
      sequencer.prefix("F").should eql "F"
      sequencer.prefix("Fw2").should eql "Fw"
      sequencer.prefix("Fw'").should eql "Fw"
      sequencer.prefix("Fw").should eql "Fw"
    end
  end

  describe "#suffix" do
    it "gets the suffix of a move" do
      sequencer.suffix("F2").should eql "2"
      sequencer.suffix("F'").should eql "'"
      sequencer.suffix("F").should eql ""
      sequencer.suffix("Fw2").should eql "2"
      sequencer.suffix("Fw'").should eql "'"
      sequencer.suffix("Fw").should eql ""
    end
  end

  describe "#scramble" do
    # due to the randomness, we should repeat multiple times
    # to avoid false positives
    REPETITIONS = 1000
    it "gives a valid one-move long scramble" do
      REPETITIONS.times do
        scramble = sequencer.scramble(1)
        scramble.should be_valid_scramble
        scramble.split(" ").count.should eql 1
      end
    end

    it "gives a valid two-move long scramble" do
      REPETITIONS.times do
        scramble = sequencer.scramble(2)
        scramble.should be_valid_scramble
        scramble.split(" ").count.should eql 2
      end
    end
  end

end
