require_relative '../../canvas/bracket'

class BracketCmd::Show < BracketCmd
  def initialize
    @options = {}
    @parser  = OptionParser.new do |opts|
      opts.banner = "Usage: bracket show [options]"
      opts.on('-b BRACKET_NAME', '--bracket_name BRACKET_NAME', 'name of the bracketed event')
    end
    @parser.parse!(into: @options)
  end

  def run
    @bracket = require_existing_bracket
    # @canvas  = Bracket::Canvas.new(bracket: @bracket)
    @canvas  = Canvas::Bracket.new(bracket: @bracket).painted

    @canvas.render
  end
end
