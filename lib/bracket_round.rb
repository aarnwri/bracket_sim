require_relative './bracket_game'

class Bracket; end
class Bracket::Round

  # If we're using teams, it means there is no previous round
  def self.create_via_teams (teams:)
    round_id = 1
    games    = []

    teams.each_slice(2).with_index do |(team_1, team_2), i|
      games << Bracket::Game.new(id: (i + 1), round_id:, team_1:, team_2:)
    end

    Bracket::Round.new(id: round_id, games:)
  end

  def self.create_via_prev_round (round:)
    round_id = round.id + 1
    games    = []

    last_game_id = round.games.last.id
    teams        = round.winning_teams # Assumes order is preserved so that brackets line up

    teams.each_slice(2).with_index do |(team_1, team_2), i|
      games << Bracket::Game.new(id: (i + 1 + last_game_id), round_id:, team_1:, team_2:)
    end

    Bracket::Round.new(id: round_id, games:)
  end

  def initialize (id:, games:)
    @id    = id
    @games = games
  end

  attr_reader :id, :games

  def to_hash
    hash = {
      :id    => id,
      :games => games.map(&:to_hash)
    }
  end

  def winning_teams
    @games.map(&:winner)
  end

  def simulate_with_winners
    @games.each {|game| game.simulate_with_winner}
  end

  # Without a @finished var, we can assume that if every game is scored, the
  # round is finished.
  def all_games_scored?
    @games.all? {|game| game.team_1_score && game.team_2_score}
  end
end
