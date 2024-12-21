class BracketCmd::Create < BracketCmd
  def initialize
    @options = {}
    @parser  = OptionParser.new do |opts|
      opts.banner = "Usage: bracket create [options]"
      opts.on('-b BRACKET_NAME', '--bracket_name BRACKET_NAME', 'name of the bracketed event')
      opts.on('-t TEAMS_FILE',   '--teams TEAMS_FILE',          'name of yaml file with list of teams')
    end
    @parser.parse!(into: @options)
    require_opts(:bracket_name)
  end

  def run
    create_bracket
    import_teams if @options[:teams]
  end

  def create_bracket
    begin
      Bracket.create(name: @options[:bracket_name])
    rescue Bracket::BracketExistsError => error
      puts "\n#{error.message}"
      puts "Please choose a unique bracket name.\n\n"
      exit(1)
    end
  end

  def import_teams
    @bracket = Bracket.new(name: @options[:bracket_name])
    begin
      @bracket.import_teams(file: @options[:teams])
    rescue Bracket::TeamsFileNotFoundError => error
      puts "\n#{error.message}"
      puts "Please choose an existing teams file.\n\n"
      @bracket.delete
      exit(1)
    rescue Bracket::TeamsFileParsingError => error
      puts "\n#{error.message}"
      puts "Please make sure the teams file is parsable.\n\n"
      @bracket.delete
      exit(1)
    end
  end
end
