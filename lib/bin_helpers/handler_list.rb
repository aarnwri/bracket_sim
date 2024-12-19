require_relative './handler'
require_relative './parser'
require_relative '../bracket'

class HandlerList < Handler
  class OptParser < Parser
    def parser
      @parser ||= OptionParser.new do |opts|
        opts.banner = "Usage: bracket list [options]"
      end
    end

    def required_options
      []
    end
  end

  def handle_argv
    @options = super(parserClass: HandlerList::OptParser)
  end

  def handle_action
    puts "Brackets:"
    puts ""
    puts Bracket.list_all
  end
end
