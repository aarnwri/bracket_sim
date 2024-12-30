require_relative './bracket'
require_relative './canvas'

class Bracket::Canvas < Canvas

  def initialize (bracket:)
    super(x: nil, y: nil)
    @bracket  = bracket
    @loc_data = []

    populate_grid
  end

  def populate_grid
    @bracket.bracket_data[:rounds].each {|round| add_round(round:)}
  end

  def add_round (round:)
    if @loc_data.empty?
      start_loc = Canvas::Loc.new(x: 0, y: 0)
      end_loc   = Canvas::Loc.new(x: game_length(round:) - 1, y: 0)
    else
      start_loc = end_loc.add(delta_x: 2, delta_y: 0)
      end_loc   = start_loc.add(delta_x: game_length(round:) - 1, delta_y: 0)
    end

    @loc_data << {
      :round_id  => round.id,
      :start_loc => start_loc,
      :end_loc   => end_loc
    }

    game_loc = start_loc
    round.games.each do |game|
      add_game(round:, game:, grid_loc: game_loc)
      game_loc = game_loc.add(delta_x: 0, delta_y: 5)
    end
  end

  def add_game (round:, game:, grid_loc:)
    line_1_str = game_border_str(round:)
    line_2_str = team_1_str(round:, game:)
    line_3_str = team_2_str(round:, game:)
    line_4_str = game_border_str(round:)

    line_1_loc = grid_loc
    line_2_loc = grid_loc.add(delta_x: 0, delta_y: 1)
    line_3_loc = grid_loc.add(delta_x: 0, delta_y: 2)
    line_4_loc = grid_loc.add(delta_x: 0, delta_y: 3)

    insert_str_at_loc(str: line_1_str, loc: line_1_loc)
    insert_str_at_loc(str: line_2_str, loc: line_2_loc)
    insert_str_at_loc(str: line_3_str, loc: line_3_loc)
    insert_str_at_loc(str: line_4_str, loc: line_4_loc)
  end

  def max_len_game_id_var (round:)
    "@max_len_game_id_#{round.id}"
  end

  def max_len_team_name_var (round:)
    "@max_len_team_name_#{round.id}"
  end

  def max_len_score_var (round:)
    "@max_len_score_#{round.id}"
  end

  def max_len_game_id (round:)
    var_name = max_len_game_id_var(round:)
    if instance_variable_defined?(var_name)
      return instance_variable_get(var_name)
    end

    max_len = round.games.last.id.to_s.length
    instance_variable_set(var_name, max_len)
    max_len
  end

  def max_len_team_name (round:)
    var_name = max_len_team_name_var(round:)
    if instance_variable_defined?(var_name)
      return instance_variable_get(var_name)
    end

    teams   = round.games.map {|game| [game.team_1, game.team_2]}.flatten
    sorted  = teams.sort_by {|team| team.length}
    max_len = sorted.last.length
    instance_variable_set(var_name, max_len)
    max_len
  end

  def max_len_score (round:)
    var_name = max_len_score_var(round:)
    if instance_variable_defined?(var_name)
      return instance_variable_get(var_name)
    end

    scores  = round.games.map {|game| game.scores}.flatten
    sorted  = scores.sort_by {|score| score.to_s.length}
    max_len = sorted.last.to_s.length
    max_len = 1 if max_len == 0 # Default to "0" for nil scores
    instance_variable_set(var_name, max_len)
    max_len
  end

  def game_border_str (round:)
    str =  "+#{"-" * max_len_game_id(round:)}"
    str << "+#{"-" * max_len_team_name(round:)}"
    str << "+#{"-" * max_len_score(round:)}"
    str << "+"
  end

  def team_1_str (round:, game:)
    str =  "|#{game.id.to_s.rjust(max_len_game_id(round:))}"
    str << "|#{game.team_1.rjust(max_len_team_name(round:))}"
    str << "|#{game.team_1_score.to_i.to_s.rjust(max_len_score(round:))}"
    str << "|"
  end

  def team_2_str (round:, game:)
    str =  "|#{" " * max_len_game_id(round:)}"
    str << "|#{game.team_2.rjust(max_len_team_name(round:))}"
    str << "|#{game.team_2_score.to_i.to_s.rjust(max_len_score(round:))}"
    str << "|"
  end

  def game_length (round:)
    game_border_str(round:).length
  end
end
