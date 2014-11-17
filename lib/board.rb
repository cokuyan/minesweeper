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

  BOARDS = {
    b: [10, [9, 9]],
    i: [40, [16, 16]],
    e: [99, [16, 30]]
  }

  attr_reader :bomb_count

  def initialize(difficulty)
    @bomb_count, @dimensions = BOARDS[difficulty]

    @board = make_board
    create_tiles
    assign_bombs
    assign_neighbors
  end

  def make_board
    Array.new(@dimensions.first) { Array.new(@dimensions.last) }
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
          next unless neighbor_pos.first.between?(0, @dimensions.first - 1) &&
                      neighbor_pos.last.between?(0, @dimensions.last - 1)
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
    [((0..9).to_a * 4).drop(1).take(@dimensions.last).unshift("  ").join] +
    @board.map.with_index do |row, i|
      ((i + 1) % 10).to_s + " " +
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
          " "
        else
          tile.neighbor_bomb_count.to_s
        end
      end.join + " " + ((i + 1) % 10).to_s
    end +
    [((0..9).to_a * 4).drop(1).take(@dimensions.last).unshift("  ").join]
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
