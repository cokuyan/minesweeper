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

  def initialize(board = nil, bombs = 9)
    @board = board
    @bombs = bombs

    if @board.nil?
      @board = self.make_board
      create_tiles
      assign_bombs
      assign_neighbors
    end
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

  def [](pos)
    @board[pos.first][pos.last]
  end

  def []=(pos,value)
    self[pos] = value
  end

  def render
    @board.map do |row|
      row.map do |tile|
        case
        when tile.flagged?
          "F"
        when !tile.revealed?
          "*"
        when tile.bombed?
          "X"
        when tile.neighbor_bomb_count.zero?
          "_"
        else
          neighbor_bomb_count.to_s
        end
      end.join
    end
  end

  def display
    puts render
  end

  def won?
    @board.flatten.each do |tile|
      next if tile.bomb
      return false unless tile.revealed?
    end
    true
  end

end

class Tile
  def initialize()
    @bomb = false
    @status = :hidden
  end

  attr_accessor :status, :neighbors, :bomb

  def reveal
    return if flagged?


    if @bomb
      @status = :bombed
      return
    end

    @status = :revealed

    neighbors.each do |neighbor|
      neighbor.reveal if neighbor_bomb_count.zero?
    end

  end

  def bombed?
    @status == :bombed
  end

  def revealed?
    @status == :revealed
  end

  def neighbor_bomb_count
    neighbors.select {|neighbor| neighbor.bomb}.count
  end

  def flag
    @status = :flagged
  end

  def flagged?
    @status == :flagged
  end

end

class Minesweeper

  def initialize(board = Board.new)
    @board = board
  end

  def run
    until @board.won?
      @board.display
      move = gets.chomp.split
      type = move.shift
      case type
      when "r"
        @board[move].reveal
        if @board[move].bombed?
          return game_over
        end
      when "f"
        @board[move].flag
      end
    end
    @board.display
  end

  def game_over
    puts "You lost :("
    @board.display
  end

end
