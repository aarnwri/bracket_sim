require_relative './meta'

require 'yaml'

class Bracket
  def self.create (name:, folder: Meta.brackets_dir)
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

  def initialize (name:, folder: Meta.brackets_dir)
    @bracket_file = File.join(folder, name)
    unless File.exist?(@bracket_file)
      raise MissingBracketError.new(bracket: name)
    end
    @bracket_data = load_bracket_data
  end

  def load_bracket_data
    YAML.load_file(@bracket_file)
  end

  def save_bracket_data
    File.open(@bracket_file, 'w') {|file| file.write(@bracket_data.to_yaml)}
  end

  ### ERRORS

  class BracketExistsError < StandardError
    DEFAULT_MSG = "Bracket already exists"
    def initialize(msg: DEFAULT_MSG, bracket: nil)
      msg = "Bracket '#{bracket}' already exists" if bracket
      super(msg)
    end
  end

  class MissingBracketError < StandardError
    DEFAULT_MSG = "Bracket not found"
    def initialize(msg: DEFAULT_MSG, bracket: nil)
      msg = "Bracket '#{bracket}' not found" if bracket
      super(msg)
    end
  end

end
