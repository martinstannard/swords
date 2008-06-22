class GameController < ApplicationController
  
  include Swords
  
  def show
                
    cw = Crossworder.new
    @game = cw.new_game
    
  end
  
end
