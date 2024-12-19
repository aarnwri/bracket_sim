class Handler
  def handle_argv (parserClass:)
    # Collect options from user
    parser  = parserClass.new
    options = parser.parse(ARGV)

    # Make sure required options are present
    # NOTE: We're assuming the given parser inherits from Parser
    missing_options = parser.missing_options(options)
    unless missing_options.empty?
      str_options = missing_options.map {|str| "'#{str.to_s}'"}
      puts "Error: Missing required option(s): #{str_options.join(', ')}"
      exit(1)
    end

    options
  end

  def handle_action
    raise "Not Implemented"
  end
end
