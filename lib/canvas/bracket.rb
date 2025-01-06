require_relative '../canvas'
require_relative './round'

class Canvas::Bracket

  def initialize (bracket:)
    @bracket  = bracket
    @canvas   = Canvas.new

    @canvas_rounds     = []
    @canvas_round_locs = []
  end

  def painted
    place_rounds_on_canvas
    connect_games_on_canvas

    @canvas
  end

  private

  def place_rounds_on_canvas
    round_loc = Canvas::Loc.new(x: 0, y: 0)

    prev_round = nil
    @bracket.bracket_data[:rounds].each_with_index do |round, idx|
      canvas_round = Canvas::Round.new(round:, prev_round:)

      @canvas.layer_canvas(
        canvas: canvas_round.painted,
        loc: round_loc
      )

      @canvas_rounds     << canvas_round
      @canvas_round_locs << round_loc.dup

      round_loc.move(delta_x: canvas_round.size_x + 5)
      prev_round = canvas_round
    end
  end

  def connect_games_on_canvas
    @canvas_rounds.each_with_index do |round, idx|
      next if idx == 0

      prev_round     = @canvas_rounds[idx - 1]
      prev_round_loc = @canvas_round_locs[idx - 1]
      prev_round.game_locs.each do |game_loc|
        line_loc = game_loc.add(delta_x: prev_round_loc.x + prev_round.size_x, delta_y: 1)
        @canvas.insert_str_at_loc(str: "__", loc: line_loc)
      end

      round.game_locs.each_with_index do |game_loc, game_loc_idx|
        line_loc = game_loc.add(delta_x: @canvas_round_locs[idx].x - 2, delta_y: 1)
        @canvas.insert_str_at_loc(str: "__", loc: line_loc)

        prev_upper_game_loc = prev_round.game_locs[game_loc_idx * 2]
        prev_lower_game_loc = prev_round.game_locs[game_loc_idx * 2 + 1]

        prev_upper_game_loc_line_start = prev_upper_game_loc.add(delta_x: prev_round_loc.x + prev_round.size_x + 2, delta_y: 2)
        prev_lower_game_loc_line_start = prev_lower_game_loc.add(delta_x: prev_round_loc.x + prev_round.size_x + 2, delta_y: 1)

        prev_upper_game_loc_line_end = game_loc.add(delta_x: @canvas_round_locs[idx].x - 3, delta_y: 2)
        prev_lower_game_loc_line_end = game_loc.add(delta_x: @canvas_round_locs[idx].x - 3, delta_y: 1)

        current_line_loc = prev_upper_game_loc_line_start
        until current_line_loc.same_as?(loc: prev_upper_game_loc_line_end)
          @canvas.insert_str_at_loc(str: "|", loc: current_line_loc)
          current_line_loc.move(delta_y: 1)
        end

        current_line_loc = prev_lower_game_loc_line_start
        until current_line_loc.same_as?(loc: prev_lower_game_loc_line_end)
          @canvas.insert_str_at_loc(str: "|", loc: current_line_loc)
          current_line_loc.move(delta_y: -1)
        end
      end
    end
  end
end
