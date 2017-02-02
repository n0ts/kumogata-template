class Kumogata2::CLI::OptionParser
  Kumogata2::CLI::OptionParser::DEFAULT_OPTIONS.merge!(
    {
      :output_format => 'yaml',
    }
  )

  Kumogata2::CLI::OptionParser::COMMANDS.merge!(
    init: {
      :description => 'Generate basic template',
      :arguments   => [:stack_name],
    }
  )
end
