require_relative '../canvas'
require_relative './game'

class Canvas::Round
  def initialize (round:, prev_round: nil)
    @round      = round
    @prev_round = prev_round

    @canvas = Canvas.new
  end

  def size_x
    Canvas::Game.size_x(
      len_id_col:    max_len_id_col,
      len_name_col:  max_len_name_col,
      len_score_col: max_len_score_col
    )
  end

  def size_y
    # TODO: This is only going to be true for the initial round...
    # NOTE: We probably don't care about size in the y dir
    @round.games.count * 4 + (@round.games.count - 1) * 2
  end

  def painted
    if @prev_round
      paint_next_round
    else
      paint_init_round
    end
  end

  # TODO: Change the location based on the location of the parent games of the
  # previous round
  def paint_next_round
    game_loc = Canvas::Loc.new(x: 0, y: 0)

    @round.games.each do |game|
      game_canvas = Canvas::Game.new(
        game:          game,
        len_id_col:    max_len_id_col,
        len_name_col:  max_len_name_col,
        len_score_col: max_len_score_col
      )
      @canvas.layer_canvas(canvas: game_canvas.painted, loc: game_loc)
      game_loc.move(delta_y: game_canvas.size_y + 2)
    end

    @canvas
  end

  def paint_init_round
    game_loc = Canvas::Loc.new(x: 0, y: 0)

    @round.games.each do |game|
      game_canvas = Canvas::Game.new(
        game:          game,
        len_id_col:    max_len_id_col,
        len_name_col:  max_len_name_col,
        len_score_col: max_len_score_col
      )
      @canvas.layer_canvas(canvas: game_canvas.painted, loc: game_loc)
      game_loc.move(delta_y: game_canvas.size_y + 2)
    end

    @canvas
  end

  def max_len_id_col
    @max_len_id_col ||= @round.games.last.id.to_s.length
    @max_len_id_col
  end

  def max_len_name_col
    @max_len_name_col ||= calc_max_len_name
    @max_len_name_col
  end

  def calc_max_len_name
    teams   = @round.games.map {|game| [game.team_1, game.team_2]}.flatten
    sorted  = teams.sort_by {|team| team.length}
    max_len = sorted.last.length
  end

  def max_len_score_col
    @max_len_score_col ||= calc_max_len_score
    @max_len_score_col
  end

  def calc_max_len_score
    scores  = @round.games.map {|game| game.scores}.flatten
    sorted  = scores.sort_by {|score| score.to_s.length}
    max_len = sorted.last.to_s.length
    max_len = 1 if max_len == 0 # Default to "0" for nil scores
    max_len
  end
end
