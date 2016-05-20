#
# Helper - Elasticbeanstalk
#
require 'kumogata/template/helper'

def _elasticbeanstalk_option(options)
  array = []
  options.each do |option|
    array << _{
      Namespace option[:namespace]
      OptionName option[:option]
      Value option[:value]
    }
  end
  array
end

def _elasticbeanstalk_configuration(configuration)
  _{
    ApplicationName configuration[:application]
    TemplateName configuration[:template]
  }
end

def _elasticbeanstalk_tier(tier)
  name = _valid_values(tier[:name], %w( WebServer Worker ), "WebServer")

  _{
    Name name
    Type (name == "WebServer") ? "Standard" : "SQS/HTTP"
    Version tier[:version] || "1.0"
  }
end
