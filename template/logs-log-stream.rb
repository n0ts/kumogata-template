#
# Logs log stream resource
# http://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/aws-resource-logs-logstream.html
#
require 'kumogata/template/helper'
require 'kumogata/template/logs'

name = _resource_name(args[:name], "logs log stream")
group = _ref_name("group", args)
stream = _ref_name("stream", args)

_(name) do
  Type "AWS::Logs::LogStream"
  Properties do
    LogGroupName group
    LogStreamName stream
  end
end
