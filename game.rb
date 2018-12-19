# Get input from user and play sudoku
require_relative 'board.rb'

class Game
  def initialize(filename)
    @board = Board.new(filename)
    # play
  end

  def play
    until @board.board_solved?
      # play game
    end
    puts 'Good job! You solved the puzzle!'
  end

  # First get value, then prompt for coords
  def get_input
    print 'Please enter a value from 1 to 9: '
    value = valid_value
    puts
    print 'Please enter coordinates in y, x format: '
    coords = valid_coords
    puts
    [value, coords]
  end

  def valid_value
    value = gets.chomp.to_i
    until in_range?(value)
      puts 'Please enter a number from 1-9:'
      value = gets.chomp.to_i
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

  def not_locked?(coords)
    @board.update_tile(coords, 2)
  end

  def in_range?(value)
    (0..9).cover?(value)
  end

  def yx_in_range?(coords)
    in_range?(coords[0]) && in_range?(coords[1])
  end
end

if $PROGRAM_NAME == __FILE__
  test = Game.new('puzzles/sudoku1_almost.txt')
  puts 'Provide coords'
  test.valid_coords
end
