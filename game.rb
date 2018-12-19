# Get input from user and play sudoku
require_relative 'board.rb'

class Game
  def initialize(filename)
    @board = Board.new(filename)
    welcome
    play
  end

  def play
    until @board.board_solved?
      clear_screen
      show_board
      turn
    end
    show_board
    puts 'Good job! You solved the puzzle!'
  end

  private

  def show_board
    @board.render
    puts
  end

  def turn
    value, coords = get_input
    @board.update_tile(coords, value)
  end

  # First get value, then prompt for coords
  def get_input
    print 'Please enter a value from 0 to 9: '
    value = valid_value
    puts
    print 'Please enter coordinates in y, x format: '
    coords = valid_coords
    puts
    [value, coords]
  end

  def valid_value
    value = gets.chomp
    until in_range?(value)
      puts 'Please enter a number from 0-9:'
      value = gets.chomp
    end
    value
  end

  def valid_coords
    coords = input_to_coords
    until yx_in_range?(coords) && not_locked?(coords)
      puts 'Please enter valid y,x coordinates:'
      coords = input_to_coords
    end
    coords
  end

  def input_to_coords
    input = gets.chomp.gsub(/\s+/, '')
    return [nil, nil] if /^\d,\d$/.match(input).nil?
    input.split(',').map(&:to_i)
  end

  # update tile with dummy value to see if valid
  def not_locked?(coords)
    @board.update_tile(coords, '2')
  end

  def in_range?(value)
    (0..9).cover?(value) || ('0'..'9').cover?(value)
  end

  def yx_in_range?(coords)
    in_range?(coords[0]) && in_range?(coords[1])
  end

  def clear_screen
    system('clear')
  end

  def pause
    sleep(2)
  end

  def welcome
    clear_screen
    puts 'Welcome to Sudoku! Hope you know how to count...'
    pause
  end
end

if $PROGRAM_NAME == __FILE__
  Game.new('puzzles/sudoku1.txt')
end
