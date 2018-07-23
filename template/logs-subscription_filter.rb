#
# Logs subscription filter resource
# http://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/aws-resource-logs-subscriptionfilter.html
#
require 'kumogata/template/helper'
require 'kumogata/template/logs'

name = _resource_name(args[:name], "logs subscription filter")
dest = _ref_attr_string("dest", "Arn", args, "role")
# Filter and Pattern Syntax
# http://docs.aws.amazon.com/AmazonCloudWatch/latest/logs/FilterAndPatternSyntax.html
pattern = args[:pattern]
group = _name("group", args)
role = _ref_attr_string("role", "Arn", args, "role")

_(name) do
  Type "AWS::Logs::SubscriptionFilter"
  Properties do
    DestinationArn dest
    FilterPattern pattern
    LogGroupName group
    RoleArn role
  end
end
