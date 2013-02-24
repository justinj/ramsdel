require_relative "spec_helper.rb"

describe Scramblang::Scrambler do
  def given_def definition
    @scrambler = Scramblang::Scrambler.new definition
  end

  def result
    @scrambler.next
  end

  it "generates scrambles for single move definitions" do
    given_def "R"
    result.should == "R"
  end

  describe "#+" do
    it "can concat with nothing" do
      given_def "(+ R)"
      result.should == "R"
    end

    it "can concat two moves" do
      given_def "(+ R R)"
      result.should == "R R"
    end

    it "can be nested" do
      given_def "(+ R (+ R R))"
      result.should == "R R R"
    end
  end

  describe "#*" do
    it "can multiply once" do
      given_def "(* R 1)" 
      result.should == "R"
    end

    it "can multiply multiple times" do
      given_def "(* R 2)" 
      result.should == "R R"
    end

    it "can be nested" do
      given_def "(* (* R 3) 2)"
      result.should == "R R R R R R"
    end
  end

  describe "#<...>" do
    it "returns a single move if it's alone" do
      given_def "<R>1"
      result[0].should == "R"
    end

    it "returns one of the moves inside" do
      10.times do
        given_def "<R,U>1"
        res = result
        fail if (res[0] != "R" && res[0] != "U")
      end
    end
  end
end
