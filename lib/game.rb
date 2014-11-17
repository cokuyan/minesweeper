require 'yaml'
require_relative 'board.rb'

class Minesweeper

  def self.load
    file = File.open("./save_file")
    Minesweeper.new(YAML.load(file.read))
  end

  def initialize(board)
    @board = board
    @flags = @board.bomb_count
  end

  def run

    until @board.won?

    begin

      @board.display
      puts "Bombs remaining: #{@flags}"

      move = gets.chomp.split
      type = move.shift
      move.map! { |pos| pos.to_i - 1 }

      case type
      when "r"
        return game_over if @board[move].bomb?
        @board[move].reveal
      when "f"
        @board[move].flag
        if @board[move].flagged?
          @flags -= 1
        else
          @flags += 1
        end
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
