class Parser
  def required_options
    []
  end

  def missing_options(options)
    required_options - options.keys
  end

  def parser
    raise "Not Implemented"
  end

  def parse(args)
    @options = {}
    self.parser.parse!(into: @options)
    @options
  end
end
