#!/usr/bin/ruby
require 'pathname'
require "yaml"
require 'pp'
require 'crossword/grid'
require 'crossword/parser'

Patterns = [
              'xxxxxxx xxxxxxx',
              ' x x x x x x x ',
              'xxxxxxxxxx xxxx',
              ' x x x x x x x ',
              'xxxxxxxxxxxxxxx',
              ' x   x x x x x ',
              'xxxxxxxxx xxxxx',
              '   x x x x x   ',
              'xxxxx xxxxxxxxx',
              ' x x x x x   x ',
              'xxxxxxxxxxxxxxx',
              ' x x x x x x x ',
              'xxxx xxxxxxxxxx',
              ' x x x x x x x ',
              'xxxxxxx xxxxxxx'
            ]

class Crossworder
  def initialize(options = {})
    @used_words = {
                    :horizontal  =>  [],
                    :vertical  =>  []
                  }
    @dict = YAML.load_file(File.dirname(__FILE__) + '/../yaml/dictionary.yml')
    @dict_words = @dict.keys.sort_by {rand}
    @requested_words = [] #options[:requested_words] || ['rails','ruby','beer','jour']
    @parser = Parser.new(Patterns)
    @h_pattern = @parser.horizontal_words
    @v_pattern = @parser.vertical_words
    @grid = Grid.new
    @h_words = []
    @v_words = []

  end

  def build
  
    @h_pattern.each do |word_vector|
      
      dir = :horizontal
      len = word_vector.length
      coord = [word_vector.x_pos,word_vector.y_pos]
      pattern = find_horiz_pattern(coord,len)
      word = find_word(pattern, coord, len, dir)
      @h_words << [word, coord]
      @h_words.each { |word| stuff_into_words_horiz(*word) if word[0]}
    end
    
    all_is_well = true
      
    while all_is_well == true do
      @v_pattern.each do |word_vector|
        dir = :vertical
        len = word_vector.length
        coord = [word_vector.x_pos,word_vector.y_pos]
        pattern = find_vert_pattern(coord,len)
        word = find_word(pattern, coord, len, dir)
        all_is_well = false if word.nil?
        @v_words << [word, coord]
        @v_words.each { |word| stuff_into_words_vert(*word) if word[0]}
      end
      
    end
    #The vertical words aren't being filled in completely. It's probably hard to find words fitting the requirements. If we do the loop we need to make it fill it could end up taking a very long time, I suppose.
    #Either we don't care, or we rethink this... If we didn't care we can put it into the rails app and the UI can be sorted and the caring can happen later!
    
  end

  def find_word(pattern, coord, length, dir)
    word = find_word_from_dict(pattern, coord, length, @requested_words, dir)
    find_word_from_dict(pattern, coord, length, @dict_words, dir) unless word
  end

  def find_word_from_dict(pattern, coord, length, word_list, dir)
    word_list.each do |l|
      line = l.to_s.strip
      next unless line.size == length
      r = Regexp.new(pattern)
      md = line.match(r)
      if !md.nil? && !@used_words[dir].include?(line) && !line.match(/[A-Z]/)
        @used_words[dir] << line
        return line
      end
    end 
    nil
  end

  def display
    @grid.display
    puts "Across:"
    display_clues @used_words[:horizontal]
    puts "Down:"
    display_clues @used_words[:vertical]
  end

  def display_clues(words)
    i = 1
    puts words.inspect
    words.each do |word|
      clues = @dict[word]["si"].split ", "
      clue = clues[rand*10 % clues.length]
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

  def stuff_into_words_horiz(line, coord)
    line.split(//).each_with_index do |char, i|
      @grid.put(coord[0] + i, coord[1], char)
    end
  end

  def stuff_into_words_vert(line, coord)
    line.split(//).each_with_index do |char, i|
      @grid.put(coord[0], coord[1] + i, char)
    end
  end
end
