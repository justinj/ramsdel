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
    it "gives valid scrambles" do
      repetitions.times do
        scramble = sequencer.scramble(25)
        scramble.should be_valid_scramble
        scramble.split(" ").should have(25).moves
      end
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

    context "counting" do
      def count_for moves
        sequencer.allow(moves)
        repetitions.times do
          scramble = sequencer.scramble(10)
          scramble.split(" ").each { |move| counts[move] += 1 }
        end
      end

      it "includes all the allowed moves" do
        count_for ["R","R'","U"]
        counts.values.any? { |count| count == 0 }.should eql false
      end

      it "defaults to 6 gen" do
        count_for ["R","L","F","B","U","D"].product(["'","2",""]).map(&:join)
        counts.each { |move,count| count.should_not(eql(0), "#{move} is 0") }
      end
    end
  end
end
