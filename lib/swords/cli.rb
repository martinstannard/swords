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
      words.each_with_index do |word, index|
        clues = @crossword.dictionary.dict[word]["si"].split ", "
        clue1 = clues[rand*10 % clues.length]
        clue2 = clues[rand*10 % clues.length]
        clue = "#{clue1}, #{clue2}  (" + "#{word.length}".bold + ")"
        puts "#{index}. " + clue
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
