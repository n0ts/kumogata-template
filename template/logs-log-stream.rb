#
# Logs log stream resource
# http://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/aws-resource-logs-logstream.html
#
require 'kumogata/template/helper'
require 'kumogata/template/logs'

name = _resource_name(args[:name], "logs log stream")
group = _name("group", args)
stream = _name("stream", args)
depends = _depends([ { ref_log_group: 'logs log group' } ], args)

_(name) do
  Type "AWS::Logs::LogStream"
  Properties do
    LogGroupName group
    LogStreamName stream
  end
  DependsOn depends unless depends.empty?
end
