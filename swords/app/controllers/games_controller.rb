class GamesController < ApplicationController
  
  include Swords
  
  def show
                
    cw = Crossworder.new
    game = cw.new_game
    @words = game[:words]
    @grid = game[:grid]
    @h_clues = game[:h_clues]
    @v_clues = game[:v_clues]

  end
  
end
