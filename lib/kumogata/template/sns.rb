#
# Helper - SNS
#
require 'kumogata/template/helper'

def _sns_to_protocol(value)
  _valid_values(value,
                %w( http https email email-json sms sqs application lambda ),
                "email")
end

def _sns_to_endpoint(protocol, value)
  case protocol
  when "lambda", "sqs"
    _attr_string(value, "Arn")
  else
    value
  end
end

def _sns_subscription_list(args)
  (args[:subscription] || []).collect do |v|
    if v.is_a? String
      protocol = "email"
      endpoint = v
    else
      protocol = _sns_to_protocol(v[:protocol])
      endpoint = _sns_to_endpoint(protocol, v[:endpoint])
    end
    _{
      Endpoint endpoint
      Protocol protocol
    }
  end
end
