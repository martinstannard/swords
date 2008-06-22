require File.dirname(__FILE__) + "/../../spec_helper"
DICT = Swords::Dictionary.new 

describe Swords::Dictionary do
  
  before :all do ||
    @dict = DICT
  end
 
  describe Swords::Dictionary, ".get_clue_for_word"  do

   
    it "should return an empty string when word is nil." do
      @dict.get_clue_for_word(nil, 1).should == ""
    end

    it "should return no more than n clues" do
      @dict = Swords::Dictionary.new 
      assert_clue(2)
      assert_clue(50)
      assert_clue(0)
    end

    it "should not die when it has no clue" do
      assert_clue(2, "thisworddoesnotexist")
    end

    def  assert_clue(n, word="test")
      @dict.get_clue_for_word(word, n).split(",").length.should <= n
    end
  end

  describe Swords::Dictionary, ".find_word"  do

    it "should find a word matching pattern and length" do
      len = 4
      pattern = "test"
      vector = Swords::Parser::WordVector.new :horizontal , 0,  0, len
      assert_find_word pattern, vector
    end

    def assert_find_word pattern, vector
      @dict.find_word(pattern, vector, :horizontal, []).answer.should == "test"
    end

  end
end