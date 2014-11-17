class Board
  def self.make_board
    Array.new(9) {Array.new(9,Tile.new)}
  end

  def initialize(board = self.make_board)
    @board = board
  end
end

class Tile
  
end
