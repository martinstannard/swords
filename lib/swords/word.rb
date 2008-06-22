require 'yaml'
module Swords
  class Word
    attr_accessor :answer, :x, :y, :direction, :clue
    
    def initialize(answer, x = 0, y = 0, direction = :horizontal, clue = '')
      @answer = answer
      @x = x
      @y = y
      @direction = direction
      @clue = clue
    end
    
  end
end
