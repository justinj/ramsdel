require_relative "spec_helper"

describe Scramblang::Sequencer do
  before :all do
    @seq = Scramblang::Sequencer.new ["R","U"], 10
  end

  it "can tell if things are on the same axis" do
    @seq.same_axis?("R", "R").should == true
    @seq.same_axis?("R2", "R").should == true
    @seq.same_axis?("R'", "R").should == true
    @seq.same_axis?("U2", "R").should == false
  end

  it "can tell if things are the same face" do
    @seq.same_face?("R","R'").should == true
    @seq.same_face?("R","R2").should == true
  end
end
