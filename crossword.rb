#!/usr/bin/ruby
require 'lib/parser'
require 'pathname'
require 'pp'
require 'yaml'

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


class Grid

  def initialize(columns = 15, rows = 15)
    @columns = columns
    @rows = rows
    @grid = Hash.new {|h, k| h[k] = nil }
  end

  def put(x, y, value)
    coord = [x,y]
    @grid[coord] = value
  end

  def get(x, y)
    coord = [x,y]
    @grid[coord]
  end

  def display
    @rows.times do |y|
      @columns.times do |x|
        coord = [x,y]
        cell = @grid[coord]
        print(cell.nil? ? " " : cell)
      end
      puts
    end
  end

end

class Crossworder

  def initialize(options = {})
    @used_words = []
    @used_words = []
    @x_size = options[:x_size] || 15
    @y_size = options[:x_size] || 15
    @dict_words = File.readlines("/usr/share/dict/words").sort_by { rand }
    @requested_words = options[:requested_words] || []
    @parser = Parser.new(Patterns)
    @h_pattern = @parser.horizontal_words
    @v_pattern = options[:v_pattern] || {}
    @grid = Grid.new
  end

  def build
    h_words = []
    v_words = []
    incomplete = true
    while incomplete == true do
      @h_pattern.each do |h_pat|
        #h_pat = @h_pattern[0]
        coord = [h_pat.x_pos, h_pat.y_pos]
        length = h_pat.length
        word = find_word(find_horiz_pattern(coord, length), coord, length)
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

  def display
    @grid.display
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
      @grid.put(coord[0], coord[1] + 1, char)
    end
  end


end

if __FILE__ == $0

  cw = Crossworder.new({:h_pattern => HP, :v_pattern => VP})

  cw.build

  cw.display

end
