require_relative './canvas_loc'

require 'io/console'

class Canvas
  MAX_WIDTH    = IO.console.winsize[1]
  DEFAULT_CHAR = " "

  def initialize (x: nil, y: nil)
    # TODO: Make sure x is an integer
    # TODO: Make sure y is an integer

    @grid = Array.new(y.to_i) {Array.new(x.to_i)}
  end

  def size_x
    @grid.count > 0 ? @grid[0].count : 0
  end

  def size_y
    @grid.count
  end

  def add_n_empty_rows (n: 1)
    n.times {@grid << Array.new(size_x) { DEFAULT_CHAR }}
  end

  def add_n_empty_cols (n: 1)
    @grid.map! {|row| row += Array.new(n) { DEFAULT_CHAR }}
  end

  def empty?
    @grid.count == 0 || (@grid.count == 1 && @grid[0].count == 0)
  end

  def loc_off_screen? (loc:)
    count_at_loc = loc.x + 1
    count_at_loc > Canvas::MAX_WIDTH
  end

  def size_sufficient_for_str_at_loc? (str:, loc:)
    return false if empty?

    start_loc = Canvas::Loc.new(x: loc.x, y: loc.y)
    end_loc   = Canvas::Loc.new(x: start_loc.x + str.length - 1, y: loc.y)

    return false unless size_y > end_loc.y
    return false unless size_x > end_loc.x
    return true
  end

  def expand_size_for_str_at_loc (str:, loc:)
    start_loc = Canvas::Loc.new(x: loc.x, y: loc.y)
    end_loc   = Canvas::Loc.new(x: start_loc.x + str.length - 1, y: loc.y)

    # Make sure end_loc is still on screen
    raise LocationOffScreenError if loc_off_screen?(loc: end_loc)

    if end_loc.y >= size_y
      diff   = end_loc.y - size_y
      needed = diff + 1
      add_n_empty_rows(n: needed)
    end

    if end_loc.x >= size_x
      diff   = end_loc.x - size_x
      needed = diff + 1
      add_n_empty_cols(n: needed)
    end
  end

  def insert_str_at_loc (str:, loc:)
    # Expand the grid as necessary to accomodate str
    unless size_sufficient_for_str_at_loc?(str: str, loc: loc)
      expand_size_for_str_at_loc(str: str, loc: loc)
    end

    # Replace grid content with str
    @grid[loc.y][loc.x, str.length] = str.chars
  end

  def render
    @grid.each {|row| puts row.join("")}
  end

  class LocationOffScreenError < StandardError
    def initialize(msg: "Error: Canvas location can't be drawn on screen")
      super(msg)
    end
  end
end
