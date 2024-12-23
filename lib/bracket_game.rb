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

  def report (team:, score:, started:, finished:)
    # TODO: Require started be either true or false
    # TODO: Require finished be either true or false
    # TODO: Require team be either team_1 or team_2
    # TODO: Require score be more than 0
    @started  = true if started == 'true'
    @finished = true if finished == 'true'

    if team == @team_1
      @team_1_score = score
    elsif team == @team_2
      @team_2_score = score
    end
  end
end
