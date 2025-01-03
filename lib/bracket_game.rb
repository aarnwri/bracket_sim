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

  def scores
    [@team_1_score, @team_2_score]
  end

  def start
      @started = true
    end

    def finish
      @finished = true
    end

    def winner
      return nil unless winner?
      return @team_1 if @team_2.nil?

      winner = (@team_1_score > @team_2_score) ? @team_1 : @team_2
    end

    def simulate_with_winner
      start
      @team_1_score = 0
      @team_2_score = 0
      5.times {rand(2) < 1 ? (@team_1_score += 1) : @team_2_score += 1}
      finish
    end

    def simulate_with_tie
      start
      @team_1_score = 3
      @team_2_score = 3
      finish
    end

    def simulate_with_winner_or_tie
      start
      6.times {rand(2) < 1 ? (@team_1_score += 1) : @team_2_score += 1}
      finish
    end

    def started?
      @started
    end

    def finished?
      @finished
    end

    def winner?
      return true if @team_2.nil?
      @finished && @team_1_score != @team_2_score
    end
end
