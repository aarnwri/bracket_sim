require_relative './game'

class Bracket; end
class Bracket::Round

  # If we're using teams, it means there is no previous round
  def self.create_via_teams (teams:)
    round = Bracket::Round.new(id: 1, prev_round: nil, games: [])

    teams.each_slice(2).with_index do |(team_1, team_2), i|
      game = Bracket::Game.new(id: (i + 1), round:, team_1:, team_2:)
      round.add_game(game:)
    end

    round
  end

  def self.create_via_prev_round (prev_round:)
    round = Bracket::Round.new(id: prev_round.id + 1, prev_round:, games: [])


    last_game_id = prev_round.games.last.id
    teams        = prev_round.winning_teams # Assumes order is preserved so that brackets line up

    teams.each_slice(2).with_index do |(team_1, team_2), i|
      game = Bracket::Game.new(
        id: (i + 1 + last_game_id), round:, team_1:, team_2:
      )
      round.add_game(game:)
    end

    round
  end

  def initialize (id:, prev_round: nil, games: [])
    @id         = id
    @prev_round = prev_round
    @games      = games
  end

  attr_reader :id, :prev_round, :games

  def add_game (game:)
    @games << game
  end

  def report (game_id:, team:, score:, started:, finished:)
    game = @games.select {|game| game.id == game_id.to_i}.first
    raise GameNotFoundError.new(game_id:) unless game

    game.report(team:, score:, started:, finished:)
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

  class GameNotFoundError < StandardError
    DEFAULT_MSG = "Game not found"
    def initialize(msg: DEFAULT_MSG, game_id: nil)
      msg = "Game '#{game_id}' not found" if game_id
      super(msg)
    end
  end
end
