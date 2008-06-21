require 'crossword'

describe "crosswords" do
  
  it "should have a grid" do
    cw = Crossworder.new
    cw.grid.should_not be_nil?
  end

end
