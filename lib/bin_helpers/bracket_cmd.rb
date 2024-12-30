require_relative '../bracket'
require_relative '../bracket_canvas'

class BracketCmd

  def require_opts (*opts)
    missing_opts = opts - @options.keys
    unless missing_opts.empty?
      str_options = missing_opts.map {|str| "'#{str.to_s}'"}
      puts "Error: Missing required option(s): #{str_options.join(', ')}"
      exit(1)
    end
  end

  def require_existing_bracket
    begin
      bracket = Bracket.new(name: @options[:bracket_name])
    rescue Bracket::BracketNotFoundError => error
      puts "\n#{error.message}"
      puts "Please choose the name of an existing bracket.\n\n"
      exit(1)
    end
  end

  def run
    raise NotImplementedError
  end
end

# Require all bracket_cmd helpers
bin_helpers       = File.dirname(__FILE__)
bracket_cmd_files = Dir.glob(File.join(bin_helpers, 'bracket_cmd', '*'))
bracket_cmd_files.each {|f| require_relative f}
