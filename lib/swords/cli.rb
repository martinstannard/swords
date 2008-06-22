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
      display_clues @crossword.dictionary.used_words[:horizontal]
      puts "Down:".bold
      display_clues @crossword.dictionary.used_words[:vertical]
    end

    def display_clues(words)
      i = 1
      words.each do |word|
        clue = @crossword.dictionary.get_clue_for_word(word, 2)
        clueline = "#{clue}  (" + "#{word.length}".bold + ")"
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
