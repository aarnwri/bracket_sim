class Bracket; end
class Bracket::Game

  def initialize (
      id:,
      round:,
      team_1:,
      team_2: nil,
      started: false,
      finished: false,
      team_1_score: nil,
      team_2_score: nil
    )
    @id           = id
    @round        = round
    @team_1       = team_1
    @team_2       = team_2
    @started      = started
    @finished     = finished
    @team_1_score = team_1_score
    @team_2_score = team_2_score
  end

  attr_reader :id, :round, :team_1, :team_2, :started, :finished, :team_1_score,
              :team_2_score

  
end
