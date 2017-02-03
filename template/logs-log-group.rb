#
# Logs log group resource
# http://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/aws-resource-logs-loggroup.html
#
require 'kumogata/template/helper'
require 'kumogata/template/logs'

name = _resource_name(args[:name], "logs log group")
group = _ref_name("group", args)
rentention = args[:rentention] || 365

_(name) do
  Type "AWS::Logs::LogGroup"
  Properties do
    LogGroupName group
    RetentionInDays rentention
  end
end
