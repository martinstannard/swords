require File.dirname(__FILE__) + "/../../spec_helper"


describe Swords::Dictionary, ".get_clue_for_word"  do
  it "should return an empty string when word is nil." do
    dict = Swords::Dictionary.new 
    dict.get_clue_for_word(nil, 1).should == ""
  end

  it "should return no more than n clues" do
    dict = Swords::Dictionary.new 
    assert_clue(dict, 2)
    assert_clue(dict, 50)
    assert_clue(dict, 0)
  end
  
  it "should not die when it has no clue" do
    dict = Swords::Dictionary.new
    assert_clue(dict, 2, "thisworddoesnotexist")
  end
  
  def  assert_clue(dict, n, word="test")
    dict.get_clue_for_word(word, n).split(",").length.should <= n
  end 
end

describe Swords::Dictionary, ".find_word"  do
 
end