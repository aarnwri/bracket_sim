require_relative './handler'
require_relative './parser'
require_relative '../meta'
require_relative '../bracket'

class HandlerCreate < Handler
  class OptParser < Parser
    def parser
      @parser ||= OptionParser.new do |opts|
        opts.banner = "Usage: bracket create [options]"
        opts.on('-b BRACKET_NAME', '--bracket_name BRACKET_NAME', 'name of the bracketed event')
        opts.on('-t FILE', '--teams_file FILE', 'teams file for importing a list of team names')
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
      Bracket.create(
        name:         @options[:bracket_name],
        teams_file:   @options[:teams_file],
        brackets_dir: Meta.brackets_dir
      )
    rescue Bracket::BracketExistsError => error
      puts "\n#{error.message}"
      puts "Please choose a unique bracket name.\n\n"
    rescue Bracket::TeamsFileMissingError => error
      puts "\n#{error.message}"
      puts "Please make sure the teams file exists if you're going to specify one.\n\n"
    rescue Bracket::TeamsFileParsingError => error
      puts "\n#{error.message}"
      puts "Make sure the file is a valid YAML file with the required 'teams' key.\n\n"
    end
  end
end
