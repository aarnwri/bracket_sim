require_relative './handler'
require_relative './parser'
require_relative '../bracket'

class HandlerExport < BracketHandler
  class OptParser < Parser
    def parser
      @parser ||= OptionParser.new do |opts|
        opts.banner = "Usage: bracket export [options]"
        opts.on('-b BRACKET_NAME', '--bracket_name BRACKET_NAME', 'name of the bracketed event')
        opts.on('-t',              '--teams',                     'export teams to a teams file')
      end
    end

    def required_options
      []
    end
  end

  def handle_argv
    @options = super(parserClass: HandlerExport::OptParser)
  end

  def handle_action
    @bracket = require_existing_bracket
    @bracket.export_teams if @options[:teams]
  end
end
