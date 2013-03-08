require_relative "spec_helper"

module Ramsdel
  describe Term do
    def of(definition)
      Term::create(definition)
    end
    it "creates an explicit move term for []" do
      of("[R,U]10").should be_an_instance_of Term::ExplicitMoveTerm
    end

    it "creates an implicit move term for <>" do
      of("<R,U>10").should be_an_instance_of Term::ImplicitMoveTerm
    end

    it "creates them with the given length" do
      of("<R,U>10").length.should eql 10
    end

    it "creates implicit terms with the right moves" do
      of("<R,U>10").allowed_moves.should =~ ["R","R'","R2","U","U'","U2"]
    end

    it "creates explicit terms with the right moves" do
      of("[R,U]10").allowed_moves.should =~ ["R","U"]
    end
  end
end
