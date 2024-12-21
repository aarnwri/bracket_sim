class BracketCmd::Export < BracketCmd
  def initialize
    @options = {}
    @parser  = OptionParser.new do |opts|
      opts.banner = "Usage: bracket export [options]"
      opts.on('-b BRACKET_NAME', '--bracket_name BRACKET_NAME', 'name of the bracketed event')
      opts.on('-t',              '--teams',                     'export teams to a teams file')
    end
    @parser.parse!(into: @options)
    require_opts(:bracket_name)
  end

  def run
    @bracket = require_existing_bracket
    @bracket.export_teams if @options[:teams]
  end
end
