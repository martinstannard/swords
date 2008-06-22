class GameController < ApplicationController
  
  include Swords
  
  def show
                
    cw = Crossworder.new
    game = cw.new_game
    @words = game[:words]
    @grid = game[:grid].content
    
  end
  
end
