require_relative '../canvas'

class Canvas::Game
  def self.size_x (len_id_col:, len_name_col:, len_score_col:)
    # NOTE: each 1 signifies the border used
    1 + len_id_col + 1 + len_name_col + 1 + len_score_col + 1
  end

  def initialize (game:, len_id_col: nil, len_name_col: nil, len_score_col: nil)
    @game          = game
    @len_id_col    = len_id_col.to_i
    @len_name_col  = len_name_col.to_i
    @len_score_col = len_score_col.to_i
    @canvas        = Canvas.new
  end

  def size_x
    @len_id_col + @len_name_col + @len_score_col
  end

  def size_y
    # TODO: Hard coding these seems kinda smelly, but I want to be able to get
    # the size without actually painting the canvas...
    4
  end

  def painted
    @canvas.insert_str_at_loc(str: border_str, loc: Canvas::Loc.new(x: 0, y: 0))
    @canvas.insert_str_at_loc(str: team_1_str, loc: Canvas::Loc.new(x: 0, y: 1))
    @canvas.insert_str_at_loc(str: team_2_str, loc: Canvas::Loc.new(x: 0, y: 2))
    @canvas.insert_str_at_loc(str: border_str, loc: Canvas::Loc.new(x: 0, y: 3))
    @canvas
  end

  def border_str
    str =  "+#{"-" * @len_id_col}"
    str << "+#{"-" * @len_name_col}"
    str << "+#{"-" * @len_score_col}"
    str << "+"
  end

  def team_1_str
    str =  "|#{@game.id.to_s.rjust(@len_id_col)}"
    str << "|#{@game.team_1.rjust(@len_name_col)}"
    str << "|#{@game.team_1_score.to_i.to_s.rjust(@len_score_col)}"
    str << "|"
  end

  def team_2_str
    str =  "|#{" " * @len_id_col}"
    str << "|#{@game.team_2.rjust(@len_name_col)}"
    str << "|#{@game.team_2_score.to_i.to_s.rjust(@len_score_col)}"
    str << "|"
  end
end
