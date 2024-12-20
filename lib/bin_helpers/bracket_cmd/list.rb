class BracketCmd::List < BracketCmd
  def initialize
    @options = {}
    @parser  = OptionParser.new do |opts|
      opts.banner = "Usage: bracket list [options]"
    end

    @parser.parse!(into: @options)
  end

  def run
    puts "Brackets:"
    puts ""
    puts Bracket.list_all
  end
end
