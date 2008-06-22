class GamesController < ApplicationController
  
  include Swords
  
  def show
                
    cw = Crossworder.new
    game = cw.new_game
    @words = game[:words]
    @grid = game[:grid]
    
  end
  
end
