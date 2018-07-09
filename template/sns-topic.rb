#
# SNS Topic resource
# http://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/aws-properties-sns-topic.html
#
require 'kumogata/template/helper'
require 'kumogata/template/sns'

name = _resource_name(args[:name], "topic")
display = _name("display", args)
subscription = _sns_subscription_list(args)
topic = _name("topic", args)

_(name) do
  Type "AWS::SNS::Topic"
  Properties do
    DisplayName display
    Subscription subscription
    TopicName topic
  end
end
