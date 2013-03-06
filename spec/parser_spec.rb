require_relative "spec_helper"

describe Ramsdel::Parser do
  let(:parser){ Ramsdel::Parser.new }
  describe "#tokenize" do
    it "parses the empty definition" do
      parser.tokenize("").should eql [] 
    end

    it "parses a single token into its own token" do
      parser.tokenize("<R,U>*1").should eql ["<R,U>*1"]
    end

    it "parses multiple tokens into their own places" do
      parser.tokenize("<R,U>*1 + <R,U>*1").should eql ["<R,U>*1", "<R,U>*1"]
    end

    it "ignores whitespace within a token" do
      parser.tokenize("<R, U> * 1 + <R, U> * 1").should 
        eql ["<R,U>*1", "<R,U>*1"]
    end
  end
end
