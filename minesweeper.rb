require './lib/game.rb'

if __FILE__ == $PROGRAM_NAME
  if File.exists?('./save_file')
    puts "Load game? (y/n)"
    option = gets.chomp
    if option == "y"
      game = Minesweeper.load
    else
      game = Minesweeper.new
    end
  else
    game = Minesweeper.new
  end
  game.run
end
