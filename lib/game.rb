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
    turns = 0
    begin

      @board.display
      puts "Time: #{(Time.now - @start_time).to_i}" unless turns.zero?
      puts "Bombs remaining: #{@flags}"

      move = gets.chomp.split

      start_time = Time.now if turns.zero?
      turns += 1

      type = move.shift
      move.map! { |pos| pos.to_i - 1 }.reverse!

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
    end until @board.won?

    end_time = Time.now - start_time

    puts "Congratulations! You won in #{end_time} seconds!"
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
