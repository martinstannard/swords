#!/usr/bin/ruby
require 'lib/parser'
require 'pathname'
require "yaml"
require 'pp'

Patterns = [
  [
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
]

requested_words = ['rails','ruby','beer','jour']

HP = {[0,0] =>  6, [2,3]  =>  4, [4,0] =>  4, [6,1] => 6 }
VP = {[0,1] =>  7, [0,5]  =>  7}


GRID = [
  [nil,nil,nil,nil,nil,nil,nil],
  [nil,nil,nil,nil,nil,nil,nil],
  [nil,nil,nil,nil,nil,nil,nil],
  [nil,nil,nil,nil,nil,nil,nil],
  [nil,nil,nil,nil,nil,nil,nil],
  [nil,nil,nil,nil,nil,nil,nil],
  [nil,nil,nil,nil,nil,nil,nil]
]



class Crossworder

  def initialize(options = {})
    @used_words = {
                    'across'  =>  [],
                    'down'  =>  []
                  }
    @dict = File.open( 'dictionary.yml' ) { |yf| YAML::load( yf ) }

    @dict_words = @dict.keys.sort_by {rand}
    @h_pattern = options[:h_pattern] || {}
    @v_pattern = options[:v_pattern] || {}
    @requested_words = options[:requested_words] || []
    @grid = options[:grid] || [[nil]]
    @parser = Parser.new(Patterns)
    @h_words = []
    @v_words = []

  end

  def read_q_and_a
    @q_and_a = YAML.load(open('lib/q_and_a.yml'))
  end

  def build

    incomplete = true
    while incomplete == true do
      @h_pattern.each_pair do |coord, length|
        word = find_word(find_horiz_pattern(coord, length).join, coord, length, 'across')
        incomplete = false if word 
        @h_words << [word, coord]
      end

      @h_words.each { |word| stuff_into_words_horiz(*word) if word[0]}

      @v_pattern.each_pair do |coord, length|
        word = find_word(find_vert_pattern(coord, length), coord, length, 'down')
        incomplete = false if word 
        @v_words << [word, coord]
      end
    end

    @v_words.each { |word| stuff_into_words_vert(*word) if word[0] }
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
    @grid.each do |line|
      line.each do |c|
        print(c.nil? ? "*" : c)
      end
      puts
    end
    puts "Across:"
    display_clues @used_words['across']
    puts "Down:"
    display_clues @used_words['down']
  end

  def display_clues(words)
    i = 1
    words.each do |word|
      clues = @dict[word]["si"].split ", "
      clue = clues[rand*10 % clues.length]
      puts "#{i}. " + clue
      i = i + 1
    end
  end

  def find_horiz_pattern(coord, length)
    row = @grid[coord[0]]
    pattern = row[coord[1]..length-1].collect {|cell| cell.nil? ? '\w' : cell}
    pattern
  end

  def find_vert_pattern(coord, length)
    re = ''
    0.upto(length-1) do |offset|
      cell = @grid[coord[0] + offset][coord[1]]
      re += cell.nil? ? '\w' : cell
    end
    re
  end

  def stuff_into_words_horiz(line, coords)
    line.split(//).each_with_index do |char, i|
      @grid[coords[0]][i + coords[1]] = char
    end
  end

  def stuff_into_words_vert(line, coords)
    line.split(//).each_with_index do |char, i|
      @grid[i][coords[1]] = char
    end
  end


end

if __FILE__ == $0

  cw = Crossworder.new({:h_pattern => HP, :v_pattern => VP, :grid => GRID})

  cw.build

  cw.display

end
