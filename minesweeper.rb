require './lib/game.rb'

def choose_difficulty
  puts "Choose difficulty"
  puts "b: beginner"
  puts "i: intermediate"
  puts "e: expert"

  case gets.chomp
  when "b" then Board.new(:b)
  when "i" then Board.new(:i)
  when "e" then Board.new(:e)
  end
end


if __FILE__ == $PROGRAM_NAME
  if File.exists?('./save_file')
    puts "Load game? (y/n)"
    option = gets.chomp
    if option == "y"
      game = Minesweeper.load
    else
      game = Minesweeper.new(choose_difficulty)
    end
  else
    game = Minesweeper.new(choose_difficulty)
  end
  game.run
end
