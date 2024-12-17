require_relative './bracket_handler'
require_relative './parser'

class HandlerDelete < BracketHandler
  class OptParser < Parser
    def parser
      @parser ||= OptionParser.new do |opts|
        opts.banner = "Usage: bracket delete [options]"
        opts.on('-b BRACKET_NAME', '--bracket_name BRACKET_NAME', 'name of the bracketed event')
      end
    end

    def required_options
      [:bracket_name]
    end
  end

  def handle_argv
    @options = super(parserClass: HandlerDelete::OptParser)
  end

  def handle_action
    @bracket = require_existing_bracket

    # TODO: Make delete actually work...
  end
end
