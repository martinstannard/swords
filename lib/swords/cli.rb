require 'choice'
require 'colored'

module Swords
  class CLI
    def self.execute
      cli = new
      cli.display
    end

    def initialize
      @crossword = Swords::Crossworder.new
      @crossword.build
    end

    def display
      display_grid(@crossword.grid)
      puts "Across:".bold
      display_clues @crossword.h_words
      puts "Down:".bold
      display_clues @crossword.v_words
    end

    def display_clues(words)
      i = 1
      words.each do |word|
        next unless word
        clue = word.clue
        clueline = "#{clue}  (" + "#{word.answer.length}".bold + ")"
        puts "#{i}. " + clueline
        i = i + 1
      end
    end

    def display_grid(grid)
      grid.rows.times do |y|
        grid.columns.times do |x|
          cell = grid.grid[[x,y]]
          print(cell.nil? ? " " : cell)
        end
        puts
      end
    end

  end
end
