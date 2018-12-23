# Solve a Sudoku puzzle
require_relative 'board.rb'
# require_relative 'game.rb'

class Solver < Board
  RANGE = ('1'..'9').to_a

  def initialize(filename)
    @sudoku = Board.new(filename)
    @board = @sudoku.board
    @possibilities = empty_hash_of_arrays
  end

  def empty_hash_of_arrays
    Hash.new { |h, k| h[k] = [] }
  end

  def populate_possibilities
    @board.each_with_index do |row, y_idx|
      row.each_with_index do |space, x_idx|
        next if space.locked
        @possibilities[[y_idx, x_idx]].concat(add_possibility(y_idx, x_idx))
      end
    end
  end

  def add_possibility(y_idx, x_idx)
    all_values = values_from_row(y_idx)
                 .concat(values_from_col(x_idx))
                 .concat(values_from_box(y_idx, x_idx))
                 .concat(RANGE)
    all_values.select { |val| all_values.count(val) == 1 }
  end

  def values_from_row(y_idx)
    @board[y_idx].each_with_object([]) do |tile, accum|
      accum << tile.value unless tile.value == '0'
    end
  end

  def values_from_col(x_idx)
    vals_from_col = []
    (0..8).each do |y_idx|
      tile = @board[y_idx][x_idx]
      vals_from_col << tile.value unless tile.value == '0'
    end
    vals_from_col
  end

  def find_box(y_idx, x_idx)
    BOX_ARRAYS.each { |arr| return arr if arr.include?([y_idx, x_idx]) }
  end

  def values_from_box(y_idx, x_idx)
    box_arr = find_box(y_idx, x_idx)
    vals_from_box = []
    box_arr.each do |y, x|
      tile = @board[y][x]
      vals_from_box << tile.value unless tile.value == '0'
    end
    vals_from_box
  end
end

if $PROGRAM_NAME == __FILE__
  solver = Solver.new('puzzles/sudoku1_almost.txt')
  solver.populate_possibilities
  # p solver.add_possibility(0, 0)
end
