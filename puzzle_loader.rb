# Load and generate Sudoku board

class PuzzleLoader
  private_class_method :new

  def initialize(filename)
    @filename = filename
    file_exists?
  end

  def self.from_file(filename)
    # read and parse file into 2D array
    puzzle = new(filename)
    filetype = puzzle.filetype_to_s

    case filetype
    when '.txt'
      puzzle.check_txt
      puzzle.process_txt
    else
      p filetype
      raise 'Unsupported file.'
    end
  end

  def check_txt
    correct_number_of_lines?
    valid_contents?
  end

  def process_txt
    puzzle_arr = []
    File.foreach(@filename) do |line|
      puzzle_arr << line.chomp.split('')
    end
    puzzle_arr
  end

  def filetype_to_s
    /\.\w+$/.match(@filename)[0]
  end

  def file_exists?
    raise 'File does not exist. Byee.' unless File.file?(@filename)
  end

  def correct_number_of_lines?
    line_count = %x(sed -n '=' #{@filename} | wc -l).to_i
    raise 'Rows must be equal to 9.' unless line_count == 9
  end

  def valid_contents?
    # row & col divisible by 9
    # only consists of 0 to 9 (0 is empty space)
    range = (0..9).to_a.join
    File.foreach(@filename) do |line|
      just_text = line.chomp
      raise 'Invalid file content.' unless just_text.count(range) == just_text.length && \
        just_text.length == 9
    end
    true
  end
end

if $PROGRAM_NAME == __FILE__
  p PuzzleLoader.from_file('puzzles/sudoku1_almost.txt')
end
