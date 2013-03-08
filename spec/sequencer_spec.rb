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
    it "gives a valid one-move long scramble" do
      repetitions.times do
        scramble = sequencer.scramble(1)
        scramble.should be_valid_scramble
        scramble.split(" ").count.should eql 1
      end
    end

    it "gives a valid two-move long scramble" do
      repetitions.times do
        scramble = sequencer.scramble(2)
        scramble.should be_valid_scramble
        scramble.split(" ").count.should eql 2
      end
    end

    it "gives a valid three-move long scramble" do
      repetitions.times do
        scramble = sequencer.scramble(3)
        scramble.should be_valid_scramble
        scramble.split(" ").count.should eql 3
      end
    end

    it "gives valid normal length scrambles" do
      repetitions.times do
        scramble = sequencer.scramble(25)
        scramble.should be_valid_scramble
        scramble.split(" ").count.should eql 25
      end
    end
  end

  describe "#allow" do
    it "only includes the allowed moves" do
      sequencer.allow(["R","U"])
      repetitions.times do
        scramble = sequencer.scramble(10)
        scramble.should be_composed_of(%w(R U))
        scramble.split(" ").count.should eql 10
      end
    end

    it "includes all the allowed moves" do
      moves = ["R","R'","U"]
      sequencer.allow(moves)
      counts = {}
      moves.each { |move| counts[move] = 0 }

      repetitions.times do
        scramble = sequencer.scramble(10)
        scramble.split(" ").each { |move| counts[move] += 1 }
      end

      counts.values.any? { |count| count == 0 }.should eql false
    end

    it "defaults to 6 gen" do
      moves = ["R","L","F","B","U","D"].product(["'","2",""]).map(&:join)
      counts = {}
      moves.each { |move| counts[move] = 0 }

      repetitions.times do
        scramble = sequencer.scramble(10)
        scramble.split(" ").each { |move| counts[move] += 1 }
      end

      counts.each { |move,count| count.should_not(eql(0), "#{move} is 0") }
    end
  end
end
