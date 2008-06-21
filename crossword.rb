#!/usr/bin/ruby
require 'pathname'
require 'pp'

#Not used yet
pattern = [
            [:x,:x,:x,:x,:x,:x],
            [:x,:o,:x,:o,:o],
            [:x,:x,:x,:x],
            [:x,:o,:x,:o],
            [:x],
            [:x]
          ]
          
          
h_pattern = {[0,0] => 6, [2,3] => 4, [4,0] => 4, [6,1] => 6}
v_pattern = {[0,1] => 7, [0,5] => 7}

Words = [
          [nil,nil,nil,nil,nil,nil,nil],
          [nil,nil,nil,nil,nil,nil,nil],
          [nil,nil,nil,nil,nil,nil,nil],
          [nil,nil,nil,nil,nil,nil,nil],
          [nil,nil,nil,nil,nil,nil,nil],
          [nil,nil,nil,nil,nil,nil,nil],
          [nil,nil,nil,nil,nil,nil,nil],
        ]


def find_horiz_pattern(coord, length)
  row = Words[coord[0]]
  row[coord[1]..length-1].collect {|cell| cell.nil? ? '\w' : cell}
end

def find_vert_pattern(coord, length)
  re = ''
  0.upto(length-1) do |offset|
    cell = Words[coord[0] + offset][coord[1]]
    re += cell.nil? ? '\w' : cell
  end
  re
end

def stuff_into_words_horiz(line, coords)
  line.split(//).each_with_index do |char, i|
    Words[coords[0]][i] = char
  end
end

def stuff_into_words_vert(line, coords)
  line.split(//).each_with_index do |char, i|
    Words[i][coords[1]] = char
  end
end


used = []
p = Pathname.new("/usr/share/dict/words")

h_pattern.each_pair do |coord, length|
  current_pattern = find_horiz_pattern(coord, length).join
  p.each_line do |l|
    line = l.strip
    next unless line.size == length
    r = Regexp.new(current_pattern)
    md = line.match(r)
    if !md.nil? && !used.include?(line) && !line.match(/[A-Z]/)
      used << line
      stuff_into_words_horiz(line, coord) 
      break
    end
  end  
end


v_pattern.each_pair do |coord, length|
  current_pattern = find_vert_pattern(coord, length)
  p.each_line do |l|
    line = l.strip
    next unless line.size == length
    r = Regexp.new(current_pattern)
    md = line.match(r)
    if !md.nil? && !used.include?(line) && !line.match(/[A-Z]/)
      used << line
      stuff_into_words_vert(line, coord) 
      break
    end
  end  

end

def display(words)
  words.each do |line|
    line.each do |c|
      print(c.nil? ? "*" : c)
    end
    puts
  end
end

display Words