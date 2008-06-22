
module Swords
  class Crossworder
    attr_accessor :dictionary, :grid, :requested_words, :h_words, :v_words

    def initialize    
      @pattern = Swords::Pattern.random
      @dictionary = Swords::Dictionary.new
      @grid = Swords::Grid.new(@pattern[0].size, @pattern.size)
      @parser = Swords::Parser.new(@pattern)
      @requested_words = [] #options[:requested_words] || ['rails','ruby','beer','jour']
      @pattern_word_count = @parser.horizontal_words.size + @parser.vertical_words.size
      @h_words = []
      @v_words = []
    end

    def build(iterations = 20)
      fill_words
      count = 0
      while filled_all_slots == false && count < iterations do
        fill_words
        count += 1
        puts "Retrying....#{count}"
      end
    end

    def filled_all_slots
      @pattern_word_count == @h_words.compact.size + @v_words.compact.size
    end

    def process_vectors(vectors, direction)
      words = vectors.collect do |word_vector|
        len = word_vector.length
        pattern = @grid.find_pattern(word_vector, direction)
        @dictionary.find_word(pattern, word_vector, direction, @requested_words)
      end
      words.each { |word| @grid.insert_word(word) if word && word.answer}
    end

    def fill_words
      @grid = Swords::Grid.new(@pattern[0].size, @pattern.size)
      @dictionary.reset
      @h_words = process_vectors(@parser.horizontal_words, :horizontal)
      @v_words = process_vectors(@parser.vertical_words, :vertical)
    end

    def clues(words)
      words.compact.collect do |w|
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
