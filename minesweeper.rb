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
      redo if tile.bomb
      tile.bomb = true
    end
  end

  def assign_neighbors
    @board.each_with_index do |row,i|
      row.each_with_index do |tile,j|
        neighbors = []
        NEIGHBORS.each do |neighbor|
          new_neighbor = [i+neighbor.first,j+neighbor.last]
          next unless new_neighbor.all? {|pos| pos.between?(0,8)}
          neighbors << @board[new_neighbor.first][new_neighbor.last]
        end
        tile.neighbors = neighbors
      end
    end
  end

end

class Tile
  def initialize()
    @bomb = false
    @status = :hidden
  end

  attr_accessor :status, :neighbors, :bomb

  def reveal
    @status = :revealed
    @bomb
  end

  def neighbor_bomb_count
    neighbors.select {|neighbor| neighbor.bomb}.count
  end

  def flag

  end
end
