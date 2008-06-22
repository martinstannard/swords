module Swords
  class Grid
    def initialize(columns = 15, rows = 15)
      @columns = columns
      @rows = rows
      @grid = Hash.new {|h, k| h[k] = nil }
    end

    def insert_word(word,coord, dir)
      word.split(//).each_with_index do |char, i|
        case dir
        when :horizontal
          put(coord[0] + i, coord[1], char)
        when :vertical
          put(coord[0], coord[1] + i, char)
        end
      end
    end

    def put(x, y, value)
      coord = [x,y]
      @grid[coord] = value
    end

    def get(x, y)
      coord = [x,y]
      @grid[coord]
    end
    
    def content
      { :grid => @grid, :rows => @rows, :columns => @columns,  }
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
end
