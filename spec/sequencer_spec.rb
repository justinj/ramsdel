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
end
