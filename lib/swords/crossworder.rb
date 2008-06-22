
module Swords
  class Crossworder
    attr_accessor :dictionary, :grid, :requested_words, :h_words, :v_words

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
      puts "Starting render #{count}"
      while filled_all_slots == false && count < iterations do
        @grid = Swords::Grid.new(@pattern[0].size, @pattern.size)
        @dictionary.reset
        horiz_words
        vert_words
        count += 1
        puts "Retrying....#{count}"
      end
    end

    def filled_all_slots
      @horizontal_vectors.compact.size + @vertical_vectors.compact.size == @h_words.compact.size + @v_words.compact.size
    end

    def process_vectors(vectors, direction)
      words = vectors.collect do |word_vector|
        len = word_vector.length
        coord = [word_vector.x_pos,word_vector.y_pos]
        pattern = @grid.find_pattern(coord, len, direction)
        @dictionary.find_word(pattern, coord, len, direction, @requested_words)
      end
      words.each { |word| @grid.insert_word(word) if word && word.answer}
    end

    def horiz_words
      @h_words = process_vectors(@parser.horizontal_words, :horizontal)
    end

    def vert_words
      @v_words = process_vectors(@parser.vertical_words, :vertical)
    end
    
    def clues(words)
      words.collect do |w|
        { :length => w.answer.size, :clue => w.clue}
      end
    end

    def new_game
      build
      { :words => @h_words + @v_words, :grid => @grid,
        :h_clues => clues(@h_words), :v_clues => clues(@v_words)}
    end

  end
end
