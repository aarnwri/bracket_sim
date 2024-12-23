class BracketCmd::Update < BracketCmd
  def initialize
    @options = {}
    @parser  = OptionParser.new do |opts|
      opts.banner = "Usage: bracket update [options]"
      opts.on('-b BRACKET_NAME', '--bracket_name BRACKET_NAME', 'name of the bracketed event')
      opts.on('-a TEAM_NAME', '--add TEAM_NAME', 'name of the team to add to the bracket')
      opts.on('-t TEAMS_FILE', '--teams TEAMS_FILE', 'name of yaml file with list of teams')
      opts.on('-d TEAM_NAME', '--delete TEAM_NAME', 'name of the team to delete from the bracket')
      opts.on('-s', '--start', 'starts the bracket, indicates all teams have been added, and scores are now reportable')
      opts.on('-r', '--report', 'report game status')
      opts.on('--round ROUND_ID', 'id of the round for the game being reported')
      opts.on('--game GAME_ID', 'id of the game for the game being reported')
      opts.on('--team TEAM_NAME', 'name of the team for the game being reported')
      opts.on('--score SCORE', 'score for the provided team for the game being reported')
      opts.on('--started STARTED', 'whether or not the game is started for the game being reported')
      opts.on('--finished FINISHED', 'whether or not the game is finished for the game being reported')
    end
    @parser.parse!(into: @options)
    require_opts(:bracket_name)
    require_opts(:round, :game) if @options[:report]
    require_opts(:score) if @options[:team]
  end

  def run
    @bracket = require_existing_bracket
    add_team      if @options[:add]
    import_teams  if @options[:teams]
    remove_team   if @options[:delete]
    start_bracket if @options[:start]
    report        if @options[:report]
  end

  def add_team
    begin
      @bracket.add_team(name: @options[:add])
      puts "\nThe team #{@options[:add]} has been successfully added to the list"
      display_teams
      puts "\n"
    rescue Bracket::AlreadyStartedError => error
      puts "\n#{error.message}"
      puts "Please choose a bracket that's not already started.\n\n"
      exit(1)
    rescue Bracket::TeamAlreadyAddedError => error
      puts "\n#{error.message}"
      puts "Please choose a team not already on the list for this event.\n\n"
      exit(1)
    end
  end

  def import_teams
    begin
      @bracket.import_teams(file: @options[:file])
      puts "\nThe teams from #{@options[:file]} have been successfully added to the list"
      display_teams
      puts "\n"
    rescue Bracket::TeamsFileNotFoundError => error
      puts "\n#{error.message}"
      puts "Please make sure the teams file exists if you're going to specify one.\n\n"
      exit(1)
    rescue Bracket::TeamsFileParsingError => error
      puts "\n#{error.message}"
      puts "Make sure the file is a valid YAML file with the required 'teams' key.\n\n"
      exit(1)
    end
  end

  def remove_team
    begin
      @bracket.remove_team(name: @options[:delete])
      puts "\nThe team #{@options[:delete]} has been successfully removed from the list"
      display_teams
      puts "\n"
    rescue Bracket::AlreadyStartedError => error
      puts "\n#{error.message}"
      puts "Please choose a bracket that's not already started.\n\n"
      exit(1)
    rescue Bracket::TeamNotFoundError => error
      puts "\n#{error.message}"
      puts "Please choose a team that is on the list for this event.\n\n"
      exit(1)
    end
  end

  def start_bracket
    begin
      @bracket.start
      puts "\nThe bracket has been successfully started. No more changes may be made"
      puts "\nYou may now start reporting scores as they come in"
    rescue Bracket::AlreadyStartedError => error
      puts "\n#{error.message}"
      puts "Please choose a bracket that's not already started.\n\n"
      exit(1)
    end
  end

  def report
    # TODO: rescue anticipated errors from this...
    # begin
      @bracket.report(
        :round_id => @options[:round],
        :game_id  => @options[:game],
        :team     => @options[:team],
        :score    => @options[:score],
        :started  => @options[:started],
        :finished => @options[:finished]
      )
    # rescue
    #
    # end
  end

  def display_teams
    puts "Current Teams:"
    @bracket.bracket_data[:teams].each do |team|
      puts "\t- #{team}"
    end
  end
end
