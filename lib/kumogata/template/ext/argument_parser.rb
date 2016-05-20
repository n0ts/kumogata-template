class Kumogata::ArgumentParser
  Kumogata::ArgumentParser::COMMANDS.merge!(
    init: {
      :description => 'Generate basic template',
      :arguments   => [:stack_name],
    }
  )
end
