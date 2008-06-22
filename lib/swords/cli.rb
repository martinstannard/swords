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
      @crossword.grid.display
      puts "Across:".bold
      display_clues @crossword.dictionary.used_words[:horizontal]
      puts "Down:".bold
      display_clues @crossword.dictionary.used_words[:vertical]
    end

    def display_clues(words)
      i = 1
      words.each do |word|
        clues = @crossword.dictionary.dict[word]["si"].split ", "
        clue1 = clues[rand*10 % clues.length]
        clue2 = clues[rand*10 % clues.length]
        clue = "#{clue1}, #{clue2}  (" + "#{word.length}".bold + ")"
        puts "#{i}. " + clue
        i = i + 1
      end
    end
  end
end
