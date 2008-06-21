#!/usr/bin/ruby
require 'lib/parser'
require 'pathname'
require 'pp'

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

requested_words = ['rails','ruby','beer','jour']

HP = {[0,0] =>  6, [2,3]  =>  4, [4,0] =>  4, [6,1] => 6 }
VP = {[0,1] =>  7, [0,5]  =>  7}


GRID = [
  [nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil],
  [nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil],
  [nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil],
  [nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil],
  [nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil],
  [nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil],
  [nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil],
  [nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil],
  [nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil],
  [nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil],
  [nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil],
  [nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil],
  [nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil],
  [nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil],
  [nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil],
  [nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil],
  [nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil],
  [nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil],
  [nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil],
  [nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil],
  [nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil]
]



class Crossworder

  
  def initialize(options = {})
    @used_words = []
    @used_words = []
    @dict_words = File.readlines("/usr/share/dict/words").sort_by { rand }
    @v_pattern = options[:v_pattern] || {}
    @requested_words = options[:requested_words] || []
    @grid = options[:grid] || GRID
    @parser = Parser.new(Patterns)
    @h_pattern = @parser.horizontal_words
  end

  def read_q_and_a
    @q_and_a = YAML.load(open('lib/q_and_a.yml'))
  end

  def build
    h_words = []
    v_words = []
    incomplete = true
    while incomplete == true do
      @h_pattern.each do |h_pat|
        coord = [h_pat.x_pos, h_pat.y_pos]
        puts coord
        length = h_pat.length
        word = find_word(find_horiz_pattern(coord, length).join, coord, length)
        puts word
        incomplete = false if word 
        h_words << [word, coord]
      end

      h_words.each { |word| stuff_into_words_horiz(*word) if word[0]}

 #     @v_pattern.each_pair do |coord, length|
 #       word = find_word(find_vert_pattern(coord, length), coord, length)
 #       incomplete = false if word 
 #       v_words << [word, coord]
 #     end
    end

#    v_words.each { |word| stuff_into_words_vert(*word) if word[0] }
  end

  def find_word(pattern, coord, length)
    word = find_word_from_dict(pattern, coord, length, @requested_words)
    find_word_from_dict(pattern, coord, length, @dict_words) unless word
  end

  def find_word_from_dict(pattern, coord, length, word_list)
    word_list.each do |l|
      line = l.strip
      next unless line.size == length
      r = Regexp.new(pattern)
      md = line.match(r)
      if !md.nil? && !@used_words.include?(line) && !line.match(/[A-Z]/)
        @used_words << line
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

  cw = Crossworder.new({:h_pattern => HP, :v_pattern => VP})#, :grid => GRID})

  cw.build

  cw.display

end
