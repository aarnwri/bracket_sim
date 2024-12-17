require_relative './bracket_handler'
require_relative './parser'

class HandlerUpdate < BracketHandler
  class OptParser < Parser
    def parser
      @parser ||= OptionParser.new do |opts|
        opts.banner = "Usage: bracket update [options]"
        opts.on('-b BRACKET_NAME', '--bracket_name BRACKET_NAME', 'name of the bracketed event')
        opts.on('-a TEAM_NAME', '--add TEAM_NAME', 'name of the team to add to the bracket')
        opts.on('-d TEAM_NAME', '--delete TEAM_NAME', 'name of the team to delete from the bracket')
        opts.on('-r [GAME_NUM, POINTS_TEAM1, POINTS_TEAM2]', '--report [GAME_NUM, POINTS_TEAM1, POINTS_TEAM2]')
        opts.on('-s', '--start', 'starts the bracket, indicates all teams have been added, and scores are now reportable')
      end
    end

    def required_options
      [:bracket_name]
    end
  end

  def handle_argv
    @options = super(parserClass: HandlerUpdate::OptParser)
  end

  def handle_action
    @bracket = require_existing_bracket

    add_team      if @options[:add]
    remove_team   if @options[:delete]
    start_bracket if @options[:start]
    report_score  if @options[:report]
  end

  def add_team
    begin
      @bracket.add_team(team_name: @options[:add])
      puts "\nThe team #{@options[:add]} has been successfully added to the list"
      @bracket.display_teams
      puts "\n"

    rescue Bracket::BracketAlreadyStartedError => error
      puts "\n#{error.message}"
      puts "Please choose a bracket that's not already started.\n\n"
      exit(1)
    rescue Bracket::TeamAlreadyAddedError => error
      puts "\n#{error.message}"
      puts "Please choose a team not already on the list for this event.\n\n"
      exit(1)
    end
  end

  def remove_team
    begin
      @bracket.delete_team(team_name: @options[:delete])
      puts "\nThe team #{@options[:delete]} has been successfully removed from the list"
      @bracket.display_teams
      puts "\n"

    rescue Bracket::BracketAlreadyStartedError => error
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
    @bracket.start
    puts "\nThe bracket has been successfully started. No more changes may be made"
    puts "\nYou may now start reporting scores as they come in"
  end

  def report_score
    # TODO: Make this work
    #2.) Make sure the bracket has been started already
    #3.) Make sure the referenced game exists
    #4.) Make sure the input has a valid format
  end
end
