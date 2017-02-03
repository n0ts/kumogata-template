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
  subscription= args[:subscription] || []

  array = []
  subscription.each do |v|
    protocol = _sns_to_protocol(v[:protocol])
    endpoint = _sns_to_endpoint(protocol, v[:endpoint])
    array << _{
      Endpoint endpoint
      Protocol protocol
    }
  end
  array
end
