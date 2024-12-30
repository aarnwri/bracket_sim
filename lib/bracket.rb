require_relative './meta'
require_relative './bracket_round'

require 'yaml'

class Bracket

  ### CLASS METHODS

  def self.list_all
    regex = File.join(Meta.brackets_dir, "*")
    Dir.glob(regex).map {|f| File.basename(f).gsub(".yaml", "")}
  end

  def self.create (name:, folder: Meta.brackets_dir)
    bracket_file = bracket_file_name(name:, folder:)
    if File.exist?(bracket_file)
      raise BracketExistsError.new(bracket: name)
    end

    data = {
      :name    => name,
      :teams   => [],
      :rounds  => [],
      :started => false
    }

    File.open(bracket_file, 'w') {|f| f.write(data.to_yaml)}
  end

  def self.delete (name:, folder: Meta.brackets_dir)
    bracket_file = bracket_file_name(name:, folder:)
    unless File.exist?(bracket_file)
      raise BracketNotFoundError.new(bracket: name)
    end

    File.delete(bracket_file)
  end

  def self.bracket_file_name (name:, folder: Meta.brackets_dir)
    File.join(folder, "#{name}.yaml")
  end

  def self.team_file_name (name:, folder: Meta.teams_dir)
    File.join(Meta.teams_dir, "#{name}_teams.yaml")
  end

  ### INSTANCE METHODS

  def initialize (name:, folder: Meta.brackets_dir)
    @name         = name
    @bracket_file = Bracket.bracket_file_name(name:, folder:)
    unless File.exist?(@bracket_file)
      raise BracketNotFoundError.new(bracket: name)
    end
    @bracket_data = load_bracket_data
  end

  attr_reader :name, :bracket_file, :bracket_data

  def delete
    Bracket.delete(name: @name)
  end

  def load_bracket_data
    YAML.load_file(
      @bracket_file,
      permitted_classes: [Bracket::Round, Bracket::Game, Symbol],
      aliases: true
    )
  end

  def save_bracket_data
    File.open(@bracket_file, 'w') {|file| file.write(YAML::dump(@bracket_data))}
  end

  def add_team (name:)
    raise AlreadyStartedError.new          if started?
    raise TeamAlreadyAddedError.new(name:) if team_present?(name:)

    @bracket_data[:teams] << name
    save_bracket_data
  end

  def remove_team (name:)
    raise AlreadyStartedError.new      if started?
    raise TeamNotFoundError.new(name:) unless team_present?(name:)

    @bracket_data[:teams].delete(name)
    save_bracket_data
  end

  def import_teams (file:)
    unless File.exist?(file)
      raise TeamsFileNotFoundError.new(file:)
    end

    begin
      content = YAML.load_file(file)
      unless content.is_a?(Hash) &&
             content.has_key?('teams') &&
             content['teams'].is_a?(Array)
        raise TeamsFileParsingError.new(file:)
      end
    rescue Psych::SyntaxError => e
      raise TeamsFileParsingError.new(file:)
    end

    @bracket_data[:teams] = content['teams']
    save_bracket_data
  end

  def export_teams
    team_file = Bracket.team_file_name(name: @name)
    team_data = {
      'teams' => @bracket_data[:teams]
    }

    File.open(team_file, 'w') {|file| file.write(team_data.to_yaml)}
  end

  def start
    raise AlreadyStartedError.new if started?

    @bracket_data[:started] = true
    populate_first_round
    save_bracket_data
  end

  def populate_first_round
    round = Bracket::Round.create_via_teams(teams: @bracket_data[:teams])
    @bracket_data[:rounds] << round
    save_bracket_data
  end

  def populate_next_round
    round = Bracket::Round.create_via_prev_round(round: @bracket_data[:rounds].last)
    @bracket_data[:rounds] << round
    save_bracket_data
  end

  def report (round_id:, game_id:, team:, score:, started:, finished:)
    round = round_by_id(id: round_id)
    raise RoundNotFoundError.new(round_id:) unless round

    round.report(game_id:, team:, score:, started:, finished:)
    save_bracket_data
  end

  def round_by_id (id:)
    round_idx = id.to_i - 1
    round     = @bracket_data[:rounds][round_idx]
  end

  def started?
    @bracket_data[:started]
  end

  def team_present? (name:)
    @bracket_data[:teams].include?(name)
  end

  ### ERRORS

  class BracketExistsError < StandardError
    DEFAULT_MSG = "Bracket already exists"
    def initialize(msg: DEFAULT_MSG, bracket: nil)
      msg = "Bracket '#{bracket}' already exists" if bracket
      super(msg)
    end
  end

  class BracketNotFoundError < StandardError
    DEFAULT_MSG = "Bracket not found"
    def initialize(msg: DEFAULT_MSG, bracket: nil)
      msg = "Bracket '#{bracket}' not found" if bracket
      super(msg)
    end
  end

  class TeamsFileNotFoundError < StandardError
    DEFAULT_MSG = "Teams file not found"
    def initialize(msg: DEFAULT_MSG, file: nil)
      msg = "Teams file '#{file}' not found" if file
      super(msg)
    end
  end

  class TeamsFileParsingError < StandardError
    DEFAULT_MSG = "Teams file not parsable"
    def initialize(msg: DEFAULT_MSG, file: nil)
      msg = "Teams file '#{file}' not parsable" if file
      super(msg)
    end
  end

  class AlreadyStartedError < StandardError
    DEFAULT_MSG = "Bracket is already started"
    def initialize(msg: DEFAULT_MSG)
      super(msg)
    end
  end

  class TeamAlreadyAddedError < StandardError
    DEFAULT_MSG = "Team is already added"
    def initialize(msg: DEFAULT_MSG, name: nil)
      msg = "Team '#{name}' was already added to the bracket" if name
      super(msg)
    end
  end

  class TeamNotFoundError < StandardError
    DEFAULT_MSG = "Team not found"
    def initialize(msg: DEFAULT_MSG, name: nil)
      msg = "Team '#{name}' could not be found in the bracket" if name
      super(msg)
    end
  end

  class RoundNotFoundError < StandardError
    DEFAULT_MSG = "Round not found"
    def initialize(msg: DEFAULT_MSG, round_id: nil)
      msg = "Round '#{round_id}' not found" if round_id
      super(msg)
    end
  end
end
