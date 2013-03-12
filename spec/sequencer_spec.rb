require_relative "spec_helper"
require_relative "scramble_matchers.rb"

describe Ramsdel::Sequencer do
  let(:repetitions) { 500 }
  let(:sequencer) { Ramsdel::Sequencer.new(Ramsdel::Puzzles::THREE_BY_THREE) }
  def be_valid_scramble 
    BeValidScramble.new
  end

  def be_composed_of(moves)
    BeComposedOf.new(moves)
  end

  describe "#valid_move?" do
    context "empty scramble" do
      it "allows anything" do
        sequencer.valid_move?([], "R").should be_true
        sequencer.valid_move?([], "F'").should be_true
        sequencer.valid_move?([], "Uw").should be_true
      end
    end

    context "1 move scramble" do
      it "allows unrelated moves" do
        sequencer.valid_move?(["R"], "F").should be_true
      end

      it "allows moves on the same axis" do
        sequencer.valid_move?(["R"], "L")
      end

      it "doesn't allow moves on the same face" do
        sequencer.valid_move?(["R"], "R").should be_false
      end
    end

    context "longer than 1 move scramble" do
      it "allows unrelated moves to the last one" do
        sequencer.valid_move?(["L", "R"], "F").should be_true
      end

      it "allows moves on the same axis as the last" do
        sequencer.valid_move?(["D", "R"], "L")
      end

      it "doesn't allow moves on the same face" do
        sequencer.valid_move?(["F", "R"], "R").should be_false
      end

      it "doesn't allow moves on the same axis as the last two" do
        sequencer.valid_move?(["R", "L"], "R").should be_false
      end
    end
  end

  describe "#same_axis?" do
    it "is true if two moves are on the same axis" do
      pairs = [["F", "B"], ["F", "F"], ["F", "B'"]]
      pairs.each do |pair|
        sequencer.same_axis?(*pair).should be_true
      end
    end

    it "is false if two moves are not on the same axis" do
      sequencer.same_axis?("F","R").should be_false
    end
  end

  describe "#same_face?" do
    it "is true if two moves are on the same face" do
      sequencer.same_face?("F", "F").should be_true
    end

    it "is false if two moves are not on the same face" do
      sequencer.same_face?("F","R").should be_false
      sequencer.same_face?("F","B").should be_false
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
    it "ignores moves that would make the scramble invalid" do
      Ramsdel::MoveProvider.any_instance.stub(:next).and_return("R","L","R","F")
      sequencer.scramble(3).should == "R L F"
    end
  end

  describe "#allow" do
    let(:counts) { Hash.new(0) }
    it "only includes the allowed moves" do
      sequencer.allow(["R","U"])
      repetitions.times do
        scramble = sequencer.scramble(10)
        scramble.should be_composed_of(%w(R U))
        scramble.split(" ").should have(10).moves
      end
    end

    it "includes all the allowed moves" do
      sequencer.allow(["R","R'","U"])
      not_found = ["R","R'","U"]
      repetitions.times do
        scramble = sequencer.scramble(10)
        scramble.split(" ").each { |move| not_found.delete(move) }
        break if not_found.empty?
      end
      not_found.should be_empty
    end
  end
end
