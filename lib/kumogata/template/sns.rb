#
# Helper - SNS
#
require 'kumogata/template/helper'

def _sns_subscription(args)
  array = []
  types = args[:subscription] || []
  types.each do |v|
    protocol = _valid_values(v[:protocol],
                             [ "http", "https", "email", "email-json", "sms", "sqs", "application", "lambda" ],
                             "email")
    case protocol
    when "lambda", "sqs"
      endpoint = _attr_string(v[:endpoint], "Arn")
    else
      endpoint = v[:endpoint]
    end
    array << _{
      Endpoint endpoint
      Protocol protocol
    }
  end
  array
end
