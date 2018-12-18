# Each tile is locked or not and has a value

class Tile
  attr_reader :locked, :value

  def initialize(value, locked)
    @value = value
    @locked = locked
  end

  def set_value(value)
    return false if locked
    @value = value
    true
  end
end

if $PROGRAM_NAME == __FILE__
  tile = Tile.new(9, true)
  tile.set_value(10)
  p tile.value
  tile2 = Tile.new(3, false)
  tile2.set_value(5)
  p tile2.value
end