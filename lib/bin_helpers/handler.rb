class Handler
  def handle_argv(parserClass:)
    # Collect options from user
    parser = parserClass.new
    options = parser.parse(ARGV)

    # Make sure required options are present
    # NOTE: We're assuming the given parser inherits from Parser
    unless parser.missing_options(options).empty?
      fail "Missing required options: #{missing_options}"
    end

    options
  end

  def handle_action
    raise "Not Implemented"
  end
end
