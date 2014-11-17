require 'yaml'
require_relative 'board.rb'

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

    begin

      @board.display

      move = gets.chomp.split
      type = move.shift
      move.map! { |pos| pos.to_i - 1 }

      case type
      when "r"
        @board[move].reveal
        return game_over if @board[move].bomb?
      when "f"
        @board[move].flag
      when "save"
        save
        return
      end
      
    rescue NoMethodError
      puts "Invalid Position"
      retry
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
