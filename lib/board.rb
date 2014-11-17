require_relative 'tile.rb'

class Board

  def inspect
  end

  CALC_NEIGHBORS = [
               [0,1],
               [1,0],
               [1,1],
               [0,-1],
               [1,-1],
               [-1,1],
               [-1,0],
               [-1,-1]
               ]

  SIZE = 9
  BOMBS = 9

  def self.make_board
    Array.new(SIZE) { Array.new(SIZE) }
  end

  def initialize(board = nil, bomb_count = BOMBS)
    @board, @bomb_count = board, bomb_count

    if @board.nil?
      @board = Board.make_board
      create_tiles
      assign_bombs
      assign_neighbors
    end
  end

  def create_tiles
    @board.each { |row| row.map! { |tile| Tile.new } }
  end

  def tiles
    @board.flatten
  end

  def assign_bombs
    @bomb_count.times do |i|
      tile = tiles.sample
      redo if tile.bomb?
      tile.bomb = true
    end
  end

  def assign_neighbors
    @board.each_with_index do |row, i|
      row.each_with_index do |tile, j|

        CALC_NEIGHBORS.each do |calc|
          neighbor_pos = [i + calc.first, j + calc.last]
          next unless neighbor_pos.all? { |pos| pos.between?(0,SIZE - 1) }
          tile.neighbors << self[neighbor_pos]
        end

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
        when tile.status == :correct
          "O"
        when tile.flagged?
          "F"
        when !tile.revealed?
          "*"
        when tile.bomb?
          "X"
        when tile.neighbor_bomb_count.zero?
          "_"
        else
          tile.neighbor_bomb_count.to_s
        end
      end.join
    end
  end

  def display
    puts render
  end

  def won?
    tiles.each do |tile|
      return false if tile.bomb? && tile.revealed?
      return false unless tile.revealed?
    end

    true
  end

  def reveal_bombs
    tiles.each do |tile|
      next unless tile.bomb?
      tile.status = (tile.flagged? ? :correct : :revealed)
    end
  end

end
