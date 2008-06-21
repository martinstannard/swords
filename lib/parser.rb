require 'strscan'

class Parser
  class WordVector < Struct.new(:direction, :x_pos, :y_pos, :length)
    
  end
  
  def initialize(grid)
    @grid = grid
  end
  
  def horizontal_words
    word_vectors = []
    
    @grid.each_with_index do |line, index|
      words = discover_words(line)
      words.each do |word|
        word.direction = :horizontal
        word.y_pos = index
      end
      word_vectors << words
    end
    
    word_vectors.flatten
  end
  
  def discover_words(line)
    word_vectors = []
    s = StringScanner.new(line)
    while word = (s.scan_until /\S{2,}/)
      word = word.match(/\S{2,}$/)[0]
      word_vectors << WordVector.new(nil, s.pos - word.length, nil, word.length)
    end
    word_vectors
  end

end

grid = [  'xxx xxx',
          ' x   x ',
          ' x xxxx',
          ' x   x ',
          'xxxx x ',
          ' x   x ',
          ' xxxxxx']
          
parser = Parser.new(grid)
raise parser.horizontal_words.inspect
