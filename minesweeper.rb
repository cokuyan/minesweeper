class Board
  NEIGHBORS = [
               [0,1],
               [1,0],
               [1,1],
               [0,-1],
               [1,-1],
               [-1,1],
               [-1,0],
               [-1,-1]]

  def self.make_board
    Array.new(9) {Array.new(9)}
  end

  def initialize(board = self.make_board, bombs = 9)
    @board = board
    @bombs = bombs
  end

  def create_tiles
    @board.each do |row|
      row.map! {|tile| Tile.new}
    end
  end

  def assign_bombs
    @bombs.times do |i|
      tile = @board.sample.sample
      redo if tile.status == :bomb
      tile.status = :bomb
    end
  end

  def assign_neighbors
    @board.each_with_index do |row,i|
      row.each_with_index do |tile,j|
        neighbors = []
        NEIGHBORS.each do |neighbor|
          new_neighbor = [i+neighbor.first,j+neighbor.last]
          next unless new_neighbor.all? {|pos| pos.between?(0,8)}
          neighbors << new_neighbor
        end
        tile.neighbors = neighbors
      end
    end

  end

end

class Tile
  # def initialize(status)
  #   @status = status
  # end

  attr_accessor :status, :neighbors
end
