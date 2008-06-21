#!/usr/bin/ruby
require 'pathname'
require 'pp'

#Not @used_words yet
pattern = [
  [:x,:x,:x,:x,:x,:x],
  [:x,:o,:x,:o,:o],
  [:x,:x,:x,:x],
  [:x,:o,:x,:o],
  [:x],
  [:x]
]


HP = {[0,0] => 3, [2,0] => 3, [6,3] => 3}
VP = {[0,0] => 3}

GRID = [
  [nil,nil,nil,nil,nil,nil,nil],
  [nil,nil,nil,nil,nil,nil,nil],
  [nil,nil,nil,nil,nil,nil,nil],
  [nil,nil,nil,nil,nil,nil,nil],
  [nil,nil,nil,nil,nil,nil,nil],
  [nil,nil,nil,nil,nil,nil,nil],
  [nil,nil,nil,nil,nil,nil,nil],
]



class Crossworder

  def initialize(options = {})
    @used_words = []
    @dict_words = File.readlines("/usr/share/dict/words").sort_by { rand }
    @h_pattern = options[:h_pattern] || {}
    @v_pattern = options[:v_pattern] || {}
    @requested_words = options[:requested_words] || []
    @grid = options[:grid] || [[nil]]
  end

  def build

    @h_pattern.each_pair do |coord, length|
      pattern = find_horiz_pattern(coord, length).join
      word = find_word(pattern, coord, length, @requested_words)
      word = find_word(pattern, coord, length, @dict_words) unless word
      stuff_into_words_horiz(word, coord)
    end

    @v_pattern.each_pair do |coord, length|
      pattern = find_vert_pattern(coord, length)
      word = find_word(pattern, coord, length, @requested_words)
      word = find_word(pattern, coord, length, @dict_words) unless word
      stuff_into_words_vert(word, coord)
    end

  end

  def find_word(pattern, coord, length, word_list)
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

  cw = Crossworder.new({:h_pattern => HP, :v_pattern => VP, :grid => GRID})

  cw.build

  cw.display

end
