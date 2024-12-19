# require_relative './meta'

require 'yaml'

class Bracket
  def self.create(name:, folder:)
    bracket_file = File.join(folder, name)
    if File.exist?(bracket_file)
      raise BracketExistsError.new(bracket: name)
    end

    data = {
      :name    => name,
      :teams   => [],
      :rounds  => [],
      :started => false
    }

    File.open(bracket_file, 'w') {|f| f.write(data.to_yaml)}
  end


  ### ERRORS

  class BracketExistsError < StandardError
    DEFAULT_MSG = "Bracket already exists"
    def initialize(msg: DEFAULT_MSG, bracket: nil)
      msg = "Bracket '#{bracket}' already exists" if bracket
      super(msg)
    end
  end

end
