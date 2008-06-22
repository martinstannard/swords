module Swords
  class Grid
    attr_accessor :columns, :grid, :rows

    def initialize(columns = 15, rows = 15)
      @columns = columns
      @rows = rows
      @grid = Hash.new {|h, k| h[k] = nil }
    end

    def insert_word(word)
      word.answer.split(//).each_with_index do |char, i|
        case word.direction
        when :horizontal
          put(word.x + i, word.y, char)
        when :vertical
          put(word.x, word.y + i, char)
        end
      end
    end

    def find_pattern(coord, length, dir)
      pattern = ''
      0.upto(length-1) do |i|
        case dir
        when :horizontal
          cell = get(coord[0] + i, coord[1])
        when :vertical
          cell = get(coord[0], coord[1] + i)
        end
        pattern += (cell.nil? ? '\w' : cell)
      end
      pattern
    end

    def put(x, y, value)
      @grid[[x,y]] = value
    end

    def get(x, y)
      @grid[[x,y]]
    end
  end
end
