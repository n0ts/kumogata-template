#
# Logs destination resource
# http://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/aws-resource-logs-destination.html
#
require 'kumogata/template/helper'
require 'kumogata/template/iam'
require 'kumogata/template/logs'

name = _resource_name(args[:name], "logs destination")
dest = _ref_name("dest", args)
policy = _iam_policy_document("policy", args)
role = _ref_attr_string("role", "Arn", args, "role")
target = _iam_arn("kinesis", args[:target].merge(type: "stream"))

_(name) do
  Type "AWS::Logs::Destination"
  Properties do
    DestinationName dest
    DestinationPolicy do
      Version "2012-10-17"
      Statement policy
    end
    RoleArn role
    TargetArn target
  end
end
