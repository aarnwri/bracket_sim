class Canvas; end
class Canvas::Loc

  def initialize (x:, y:)
    @x = x
    @y = y
  end

  attr_reader :x, :y

  def add (delta_x:, delta_y:)
    Canvas::Loc.new(
      x: x + delta_x,
      y: y + delta_y
    )
  end
end
