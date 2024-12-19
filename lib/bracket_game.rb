class Bracket; end
class Bracket::Game

  def initialize (
    id:,
    round_id:,
    team_1:,
    team_2: nil,
    team_1_prev_game_id: nil,
    team_2_prev_game_id: nil
    )
    @id                  = id
    @round_id            = round_id
    @team_1              = team_1
    @team_2              = team_2
    @team_1_prev_game_id = team_1_prev_game_id
    @team_2_prev_game_id = team_2_prev_game_id

    @started      = false
    @finished     = false
    @team_1_score = nil
    @team_2_score = nil
  end

  attr_reader :id, :round_id, :team_1, :team_2, :team_1_prev_game_id,
              :team_2_prev_game_id, :started, :finished, :team_1_score, :team_2_score

  def to_hash
    hash = {
      :id                  => id,
      :round_id            => round_id,
      :team_1              => team_1,
      :team_2              => team_2,
      :team_1_prev_game_id => team_1_prev_game_id,
      :team_2_prev_game_id => team_2_prev_game_id,
      :started             => started,
      :finished            => finished,
      :team_1_score        => team_1_score,
      :team_2_score        => team_2_score,
    }
  end
end
