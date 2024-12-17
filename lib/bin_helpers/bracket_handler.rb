require_relative './handler'
require_relative '../meta'
require_relative '../bracket'

class BracketHandler < Handler
  def require_existing_bracket
    begin
      @bracket = Bracket.new(
        name:         @options[:bracket_name],
        brackets_dir: Meta.brackets_dir
      )
    rescue Bracket::BracketNotFoundError => error
      puts "\n#{error.message}"
      puts "Please choose the name of an existing bracket.\n\n"
      exit(1)
    end
  end
end
