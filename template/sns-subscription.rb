#
# SNS Subscription resource
# http://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/aws-resource-sns-subscription.html
#
require 'kumogata/template/helper'
require 'kumogata/template/sns'

name = _resource_name(args[:name], "sns subscription")
protocol = _sns_to_protocol(args[:protocol])
endpoint = _sns_to_endpoint(protocol, args[:endpoint])
topic = _ref_attr_string("topic", "Arn", args, "topic")

_(name) do
  Type "AWS::SNS::Subscription"
  Properties do
    Endpoint endpoint
    Protocol protocol
    TopicArn topic
  end
end
