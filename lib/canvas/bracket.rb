require_relative '../canvas'
require_relative './round'

class Canvas::Bracket

  def initialize (bracket:)
    @bracket  = bracket
    # TODO: Should this be an array?
    @loc_data = []
    @canvas   = Canvas.new
  end

  def painted
    round_loc = Canvas::Loc.new(x: 0, y: 0)

    @bracket.bracket_data[:rounds].each do |round|
      canvas_round = Canvas::Round.new(round:)

      @canvas.layer_canvas(
        canvas: canvas_round.painted,
        loc: round_loc
      )
      round_loc.move(delta_x: canvas_round.size_x + 2)
    end

    @canvas
  end
end
