# Solve a Sudoku puzzle
require_relative 'board.rb'
require 'set'

class Solver < Board
  RANGE = ('1'..'9').to_a

  private_class_method :new

  def initialize(filename)
    @sudoku = Board.new(filename)
    @board = @sudoku.board
    @possibilities = {}
  end

  def self.solve(filename)
    puzzle = new(filename)
    puzzle.render
    puts
    puzzle.populate_possibilities
    puzzle.fill_board
    puzzle.render
  end

  def populate_possibilities
    lock_flag = false
    @board.each_with_index do |row, y_idx|
      row.each_with_index do |space, x_idx|
        next if space.locked
        possibles = possibilities(y_idx, x_idx)
        if possibles.length == 1
          update_tile([y_idx, x_idx], possibles[0])
          lock_flag = true
        else
          @possibilities[[y_idx, x_idx]] = possibles
        end
      end
    end
    populate_possibilities if lock_flag
  end

  def fill_board
    all_coords = @possibilities.keys
    coord_idx = 0
    until board_solved?
      y, x = all_coords[coord_idx]
      tile = tile(y, x)
      val_idx = @possibilities[[y, x]].index(tile.value) || -1
      if end_of_array(val_idx, y, x, coord_idx)
        coord_idx -= 1
        next
      end
      update_tile([y, x], @possibilities[[y, x]][val_idx + 1])
      coord_idx += 1 if valid_value?(y, x)
    end
  end

  def end_of_array(val_idx, y, x, coord_idx)
    if val_idx == @possibilities[[y, x]].length - 1
      update_tile([y, x], '0')
      raise 'Unsolveable puzzle' if coord_idx.zero?
      return true
    end
    false
  end

  def valid_value?(y, x)
    row_values = values_from_row(y)
    col_values = values_from_col(x)
    box_values = values_from_box(y, x)
    if row_values.length == row_values.to_set.length && \
       col_values.length == col_values.to_set.length && \
       box_values.length == box_values.to_set.length
      return true
    end
    false
  end

  def tile(y_idx, x_idx)
    @board[y_idx][x_idx]
  end

  def possibilities(y_idx, x_idx)
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

Solver.solve('puzzles/sudoku3.txt') if $PROGRAM_NAME == __FILE__
