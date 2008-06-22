module Swords
  class Grid
    attr_accessor :columns, :grid, :rows

    def initialize(columns = 15, rows = 15)
      @columns = columns
      @rows = rows
      @grid = Hash.new {|h, k| h[k] = nil }
    end

    def put(x, y, value)
      @grid[[x,y]] = value
    end

    def get(x, y)
      @grid[[x,y]]
    end
  end
end
