class Canvas; end
class Canvas::Loc

  def initialize (x:, y:)
    @x = x
    @y = y
  end

  attr_accessor :x, :y

  def add (delta_x:, delta_y:)
    Canvas::Loc.new(
      x: x + delta_x,
      y: y + delta_y
    )
  end

  def move (delta_x: nil, delta_y: nil)
    @x += delta_x.to_i
    @y += delta_y.to_i
  end
end
