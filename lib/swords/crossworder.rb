module Swords
  class Crossworder
    attr_accessor :dictionary, :grid, :requested_words

    def initialize    
      @pattern = Swords::Pattern.random
      @dictionary = Swords::Dictionary.new
      @grid = Swords::Grid.new(@pattern[0].size, @pattern.size)
      @parser = Swords::Parser.new(@pattern)
      @requested_words = [] #options[:requested_words] || ['rails','ruby','beer','jour']
      @h_pattern = @parser.horizontal_words
      @v_pattern = @parser.vertical_words
      @h_words = []
      @v_words = []
    end

    def build(iterations = 20)
      @grid = Swords::Grid.new
      horiz_words
      count = 0
      until vert_words == true || count == iterations do
        @grid = Swords::Grid.new(@pattern[0].size, @pattern.size)
        @dictionary.reset
        horiz_words
        count += 1
        puts "Retrying....#{count}"
      end
      #The vertical words aren't being filled in completely. It's probably hard to find words fitting the requirements. If we do the loop we need to make it fill it could end up taking a very long time, I suppose.
      #Either we don't care, or we rethink this... If we didn't care we can put it into the rails app and the UI can be sorted and the caring can happen later!
    end

    def horiz_words
      @h_words = []
      @h_pattern.each do |word_vector|
        dir = :horizontal
        len = word_vector.length
        coord = [word_vector.x_pos,word_vector.y_pos]
        pattern = find_horiz_pattern(coord,len)
        word = @dictionary.find_word(pattern, coord, len, dir, @requested_words)
        @h_words << [word, coord, dir]
        @h_words.each { |word| stuff_into_words_horiz(*word) if word[0]}
      end
    end

    def vert_words
      @v_words = []
      @v_pattern.each do |word_vector|
        dir = :vertical
        len = word_vector.length
        coord = [word_vector.x_pos,word_vector.y_pos]
        pattern = find_vert_pattern(coord,len)
        word = @dictionary.find_word(pattern, coord, len, dir, @requested_words)
        @v_words << [word, coord, dir]
        @v_words.each { |word| stuff_into_words_vert(*word) if word[0]}
        end
      @v_words.detect(nil) { |w| w[0].nil? }.nil?
    end
    
    def new_game
      build
      @h_words + @v_words    
    end

    def display
      @grid.display
      puts "Across:"
      display_clues @dictionary.used_words[:horizontal]
      puts "Down:"
      display_clues @dictionary.used_words[:vertical]
    end

    def display_clues(words)
      i = 1
      words.each do |word|
        if @dictionary.dict[word]["si"].nil?
          clue = "No clue"
        else
          clues = @dictionary.dict[word]["si"].split ", "
          clue = clues[rand*10 % clues.length]
        end
        puts "#{i}. " + clue
        i = i + 1
      end
    end

    def find_horiz_pattern(coord, length)
      pattern = ''
      0.upto(length-1) do |i|
        cell = @grid.get(coord[0] + i, coord[1])
        pattern += (cell.nil? ? '\w' : cell)
      end
      pattern
    end

    def find_vert_pattern(coord, length)
      pattern = ''
      0.upto(length-1) do |i|
        cell = @grid.get(coord[0], coord[1] + i)
        pattern += (cell.nil? ? '\w' : cell)
      end
      pattern
    end

    def stuff_into_words_horiz(line, coord, dir)
      line.split(//).each_with_index do |char, i|
        @grid.put(coord[0] + i, coord[1], char)
      end
    end

    def stuff_into_words_vert(line, coord, dir)
      line.split(//).each_with_index do |char, i|
        @grid.put(coord[0], coord[1] + i, char)
      end
    end
  end
end
