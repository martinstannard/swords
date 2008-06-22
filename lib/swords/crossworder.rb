
module Swords
  class Crossworder
    attr_accessor :dictionary, :grid, :requested_words

    def initialize    
      @pattern = Swords::Pattern.random
      @dimensions = { :width => @pattern[0].size, :height => @pattern.size}
      @dictionary = Swords::Dictionary.new
      @grid = Swords::Grid.new(@dimensions[:width], @dimensions[:height])
      @parser = Swords::Parser.new(@pattern)
      @requested_words = [] #options[:requested_words] || ['rails','ruby','beer','jour']
      @horizontal_vectors = @parser.horizontal_words
      @vertical_vectors = @parser.vertical_words
      @h_words = []
      @v_words = []
    end

    def build(iterations = 20)
      @grid = Swords::Grid.new(@pattern[0].size, @pattern.size)
      horiz_words
      count = 0
      until vert_words == true || count == iterations do
        @grid = Swords::Grid.new(@pattern[0].size, @pattern.size)
        @dictionary.reset
        horiz_words
        count += 1
        puts "Retrying....#{count}"
      end
    end

    def process_vectors(vectors, direction)
      words = vectors.collect do |word_vector|
        len = word_vector.length
        coord = [word_vector.x_pos,word_vector.y_pos]
        pattern = @grid.find_pattern(coord, len, direction)
        word = @dictionary.find_word(pattern, coord, len, direction, @requested_words)
        clue = @dictionary.get_clue_for_word(word, 2)
        [word, coord, direction, clue]
      end
      words.each { |word| @grid.insert_word(*word) if word[0]}
    end

    def horiz_words
      @h_words = process_vectors(@parser.horizontal_words, :horizontal)
    end

    def vert_words
      @v_words = process_vectors(@parser.vertical_words, :vertical)
      @v_words.detect(nil) { |w| w[0].nil? }.nil?
    end
    
    def new_game
      build
      { :words => @h_words + @v_words, :grid => @grid }
    end

  end
end
