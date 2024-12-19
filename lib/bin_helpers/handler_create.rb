require_relative './handler'
require_relative './parser'
require_relative '../bracket'

class HandlerCreate < Handler
  class OptParser < Parser
    def parser
      @parser ||= OptionParser.new do |opts|
        opts.banner = "Usage: bracket create [options]"
        opts.on('-b BRACKET_NAME', '--bracket_name BRACKET_NAME', 'name of the bracketed event')
        opts.on('-t TEAMS_FILE',   '--teams TEAMS_FILE',          'name of yaml file with list of teams')
      end
    end

    def required_options
      [:bracket_name]
    end
  end

  def handle_argv
    @options = super(parserClass: HandlerCreate::OptParser)
  end

  def handle_action
    begin
      Bracket.create(name: @options[:bracket_name])
    rescue Bracket::BracketExistsError => error
      puts "\n#{error.message}"
      puts "Please choose a unique bracket name.\n\n"
      exit(1)
    end

    if @options[:teams]
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
end
