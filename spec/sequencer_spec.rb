require_relative "spec_helper"

describe Ramsdel::Sequencer do
  let(:sequencer) { Ramsdel::Sequencer.new(Ramsdel::Puzzles::TWO_BY_TWO) }

  describe "#opposites?" do
    it "is true if two moves are opposites" do
      sequencer.opposites?("F","B").should eql true 
      sequencer.opposites?("F","B'").should eql true 
    end

    it "is false if two moves are not opposites" do
      sequencer.opposites?("F","R").should eql false
    end
  end
end
