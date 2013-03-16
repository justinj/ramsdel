require_relative "spec_helper"

module Ramsdel
  describe Term do
    def from(definition)
      Term::create(definition)
    end

    it "creates constants if what was provided was not a term" do
      from("x y").generate.should == "x y"
      from("y2").generate.should == "y2"
    end

    it "creates them with the given length" do
      from("<R,U>*10").length.should eql 10
    end

    it "uses a length of 1 if none was given" do
      from("<R,U>").length.should eql 1
    end

    it "creates implicit terms with the right moves" do
      from("<R,U>*10").allowed_moves.should =~ ["R","R'","R2","U","U'","U2"]
    end

    it "creates explicit terms with the right moves" do
      from("[R,U]*10").allowed_moves.should =~ ["R","U"]
    end

    it "ignores whitespace in the moves" do
      from("[R, U]*10").allowed_moves.should =~ ["R","U"]
    end

    it "doesn't care about ordering" do
      from("10*<R,U>").length.should eql 10
    end

    it "doesn't care about ordering" do
      from("10*<R,U>").length.should eql 10
    end
  end
end
