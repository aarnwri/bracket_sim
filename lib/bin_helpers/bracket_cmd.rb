require_relative '../bracket'

# Require all bracket_cmd helpers
bin_helpers       = File.dirname(__FILE__)
bracket_cmd_files = Dir.glob(File.join(bin_helpers, 'bracket_cmd', '*'))
bracket_cmd_files.each {|f| require_relative f}

class BracketCmd
  def run
    raise NotImplementedError
  end
end
