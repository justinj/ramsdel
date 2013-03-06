require_relative "spec_helper"

describe Ramsdel::Sequencer do
  let(:sequencer) { Ramsdel::Sequencer.new(Ramsdel::Puzzles::TWO_BY_TWO) }

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
end
