require './lib/game.rb'

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
