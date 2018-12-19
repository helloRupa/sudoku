# Load and generate Sudoku board
require_relative 'puzzle_loader.rb'
require_relative 'tile.rb'
require 'colorize'
require 'set'

class Board
  BOX_ARRAYS = []
  attr_accessor :board

  def initialize(filename)
    puzzle_arr = PuzzleLoader.from_file(filename)
    @board = populate(puzzle_arr)
    fill_box_arrays
    render
  end

  def render
    print_header_row
    @board.each_with_index do |row, idx|
      print "#{idx} ".colorize(:yellow)
      row.each_with_index do |space, idx2|
        print_value(space)
        print ' '
        add_space_around_boxes(idx2) { print ' ' }
      end
      puts
      add_space_around_boxes(idx) { puts }
    end
  end

  def update_tile(pos, value)
    x, y = pos
    @board[y][x].set_value(value)
  end

  def board_solved?
    rows_solved? && cols_solved? && boxes_solved?
  end

  private

  def fill_box_arrays
    seeds = [[0, 1, 2], [3, 4, 5], [6, 7, 8]]
    seeds.each do |outer|
      seeds.each do |inner|
        BOX_ARRAYS << outer.product(inner)
      end
    end
    BOX_ARRAYS.freeze
  end

  def add_space_around_boxes(idx, &block)
    yield if '25'.include?(idx.to_s)
  end

  def populate(puzzle_arr)
    board = []
    puzzle_arr.each do |row|
      final_row = []
      row.each do |value|
        final_row << (value == '0' ? Tile.new(value, false) : Tile.new(value, true))
      end
      board << final_row
    end
    board
  end

  def print_header_row
    print '  '
    9.times do |num|
      print "#{num} ".colorize(:yellow)
      add_space_around_boxes(num) { print ' ' }
    end
    puts
  end

  def print_value(space)
    if space.locked
      print space.value.colorize(:light_green)
    else
      print space.value.colorize(:white)
    end
  end

  def set_of_nine?(arr)
    arr_set = arr.map(&:value).to_set
    return false if arr_set.include?('0')
    arr_set.length == 9
  end

  def rows_solved?
    @board.each do |row|
      return false unless set_of_nine?(row)
    end
    true
  end

  def cols_solved?
    rows = @board.length
    cols = @board[0].length
    (0...rows).each do |x|
      column = []
      (0...cols).each do |y|
        column << @board[y][x]
      end
      return false unless set_of_nine?(column)
    end
    true
  end

  def boxes_solved?
    BOX_ARRAYS.each do |boxes|
      box = []
      boxes.each do |y, x|
        box << @board[y][x]
      end
      return false unless set_of_nine?(box)
    end
    true
  end
end

if $PROGRAM_NAME == __FILE__
  board = Board.new('puzzles/sudoku1_almost.txt')
  p board.board_solved?
  board.update_tile([0, 0], '4')
  board.render
  p board.board_solved?
end
