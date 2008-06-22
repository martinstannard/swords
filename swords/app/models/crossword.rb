require 'swords'
class Crossword < ActiveRecord::Base

  belongs_to :pattern
  has_many :words

  def self.generate
    worder = Swords::Crossworder.new
    game = worder.new_game
    cw = Crossword.new(:pattern_id => 1)
    game[:words].compact.each do |w|
      Word.create!(:crossword => cw, :answer => w.answer, :col => w.x, :row => w.y, :clue => 'clue', :direction => 'horizontal') 
    end
  end
  # @words = game[:words]
  # @grid = game[:grid]
  # @h_clues = game[:h_clues]
  # @v_clues = game[:v_clues]


end
