#
# Kinesis stream resource
# http://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/aws-resource-kinesis-stream.html
#
require 'kumogata/template/helper'

name = _resource_name(args[:name], 'kinesis stream')
stream = _name('stream', args)
rentention = args[:rentention] || 24
shard = args[:shard] || 1
tags = _tags(args, 'stream')

_(name) do
  Type 'AWS::Kinesis::Stream'
  Properties do
    Name stream
    RetentionPeriodHours rentention
    ShardCount shard
    Tags tags
  end
end
