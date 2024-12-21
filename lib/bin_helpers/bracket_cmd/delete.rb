class BracketCmd::Delete < BracketCmd
  def initialize
    @options = {}
    @parser  = OptionParser.new do |opts|
      opts.banner = "Usage: bracket delete [options]"
      opts.on('-b BRACKET_NAME', '--bracket_name BRACKET_NAME', 'name of the bracketed event')
    end
    @parser.parse!(into: @options)
    require_opts(:bracket_name)
  end

  def run
    @bracket = require_existing_bracket
    @bracket.delete
  end
end
