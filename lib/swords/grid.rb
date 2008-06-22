module Swords
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
end
