require 'yaml'

class Board

  def inspect
  end

  NEIGHBORS = [
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
    @board = board
    @bomb_count = bomb_count

    if @board.nil?
      @board = Board.make_board
      create_tiles
      assign_bombs
      assign_neighbors
    end
  end

  def create_tiles
    @board.each do |row|
      row.map! { |tile| Tile.new }
    end
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
        neighbors = []
        NEIGHBORS.each do |neighbor|
          new_neighbor = [i + neighbor.first, j + neighbor.last]
          next unless new_neighbor.all? { |pos| pos.between?(0,SIZE - 1) }
          neighbors << self[new_neighbor]
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

class Tile
  def initialize()
    @bomb = false
    @status = :hidden
  end

  attr_accessor :status, :neighbors
  attr_writer :bomb

  def bomb?
    @bomb
  end

  def reveal
    return if flagged? || bomb?

    @status = :revealed

    neighbors.each do |neighbor|
      neighbor.reveal if neighbor_bomb_count.zero? && !neighbor.revealed?
    end

  end

  def revealed?
    @status == :revealed
  end

  def neighbor_bomb_count
    neighbors.select(&:bomb?).count
  end

  def flag
    if @status == :flagged
      @status = :hidden
    else
      @status = :flagged unless revealed?
    end
  end

  def flagged?
    @status == :flagged
  end

end

class Minesweeper

  def self.load
    file = File.open("./save_file")
    Minesweeper.new(YAML.load(file.read))
  end

  def initialize(board = Board.new)
    @board = board
  end

  def run
    until @board.won?
      @board.display
      move = gets.chomp.split
      type = move.shift
      move.map!(&:to_i)
      case type
      when "r"
        @board[move].reveal
        if @board[move].bomb?
          return game_over
        end
      when "f"
        @board[move].flag
      when "save"
        save
        return
      end
    end

    puts "Congratulations! You won!"
    @board.display
  end

  def game_over
    puts "You lost :("
    @board.reveal_bombs
    @board.display
  end

  def save
    File.open("save_file", "w") do |file|
      file.puts @board.to_yaml
    end
  end

end

if __FILE__ == $PROGRAM_NAME
  puts "Load game? (y/n)"
  option = gets.chomp
  if option == "y"
    game = Minesweeper.load
  else
    game = Minesweeper.new
  end
  game.run
end
