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


HP = {[0,0] => 6, [2,3] => 4, [4,0] => 4, [6,1] => 6}
VP = {[0,1] => 7, [0,5] => 7}

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
    @dict_words = Pathname.new("/usr/share/dict/words")
    @h_pattern = options[:@h_pattern] || {}
    @v_pattern = options[:v_pattern] || {}
    @grid = options[:grid] || [[nil]]
  end

  def build

    @h_pattern.each_pair do |coord, length|
      current_pattern = find_horiz_pattern(coord, length).join
      @dict_words.each_line do |l|
        line = l.strip
        next unless line.size == length
        r = Regexp.new(current_pattern)
        md = line.match(r)
        if !md.nil? && !@used_words.include?(line) && !line.match(/[A-Z]/)
          @used_words << line
          stuff_into_words_horiz(line, coord) 
          break
        end
      end  
    end


    @v_pattern.each_pair do |coord, length|
      current_pattern = find_vert_pattern(coord, length)
      @dict_words.each_line do |l|
        line = l.strip
        next unless line.size == length
        r = Regexp.new(current_pattern)
        md = line.match(r)
        if !md.nil? && !@used_words.include?(line) && !line.match(/[A-Z]/)
          @used_words << line
          stuff_into_words_vert(line, coord) 
          break
        end
      end  

    end
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
    row[coord[1]..length-1].collect {|cell| cell.nil? ? '\w' : cell}
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
      @grid[coords[0]][i] = char
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
