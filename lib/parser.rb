# Cross Words Parser
#
# Michael Koukoullis (mkoukoullis@gmail.com)
#
# Parses a crossword grid.  Well what is crossword grid?
#
# Example grid = [  'xxx xxx',
#                   ' x   x ',
#                   ' x xxxx',
#                   ' x   x ',
#                   'xxxx x ',
#                   ' x   x ',
#                   ' xxxxxx']
#
#  - An array of strings (of equal length)
#  - Each string represents a positional horizontal line in the crossword
#  - An 'x' in the string represents positional word character availability
#  - A space in the string indicates a character cannot be used at that position in the crossword
#
# Return an array of word vectors, 
#  = direction [horizontal | vertical]
#  - x_pos, integer horizontal co-ordinate from the top left of the grid
#  - y_pos, integer vertical co-ordinate from the top let o the grid
#
# Usage
# =====
# parser = Parser.new(grid)
# word_vectors = parser.generate
    

require 'strscan'
require 'Matrix'

class Parser
  class WordVector < Struct.new(:direction, :x_pos, :y_pos, :length)
    
  end
  
  def initialize(grid)
    @grid = grid
  end
  
  # Main method to discover all horizontal and vertical word vectors
  def generate
    horizontal_words + vertical_words
  end
  
  # Discover horizontal words for a grid
  def horizontal_words
    word_vectors = []
    
    @grid.each_with_index do |line, index|
      words = discover_words(line)
      words.each do |word|
        #Set the direction as 'discover_words' is direction agnostic
        word.direction = :horizontal
        word.y_pos = index
      end
      word_vectors << words
    end
    
    word_vectors.flatten
  end
  
  # Discover vertical words for a grid
  def vertical_words
    word_vectors = []
    inverted_grid = Matrix.rows(@grid.map { |line| line.split('') }).transpose.to_a.map {|line| line.join}
    
    inverted_grid.each_with_index do |line, index|
      words = discover_words(line)
      words.each do |word|
        #Set the direction as 'discover_words' is direction agnostic
        word.direction = :vertical
        #Need to set the y_pos to the x_pos as the grid is inverted
        word.y_pos = word.x_pos
        word.x_pos = index
      end
      word_vectors << words
    end
    
    word_vectors.flatten
  end
  
  # Create word vectors for a line in the grid. 
  # ==========================================
  # This method is sort of 'direction' agnostic, assumes we are always 
  # a horizontal line, storing the starting position of the word in the '
  # x_pos' of the word_vector
  
  def discover_words(line)
    word_vectors = []
    s = StringScanner.new(line)
    
    # Iterate, scanning for two or more 'x' characters
    while word = (s.scan_until /\S{2,}/)
      # Extract the sequence of 'x' characters from the end of the scan
      word = word.match(/\S{2,}$/)[0]
      # Create a new word vector, 
      word_vectors << WordVector.new(nil, s.pos - word.length, nil, word.length)
    end
    word_vectors
  end

end

# grid = [  'xxx xxx',
#           ' x   x ',
#           ' x xxxx',
#           ' x   x ',
#           'xxxx x ',
#           ' x   x ',
#           ' xxxxxx']
#           
# parser = Parser.new(grid)
# raise parser.generate.inspect
