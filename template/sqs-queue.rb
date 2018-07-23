#
# SQS Queue resource
# http://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/aws-properties-sqs-queues.html
#
require 'kumogata/template/helper'

name = _resource_name(args[:name], "queue")
content =
  if args.key? :content
    _bool("content", args, true)
  else
    ""
  end
deplay = args[:deplay] || 0
fifo =
  if args.key? :fifo
    _bool("fifo", args, true)
  else
    ""
  end
max = args[:max] || 262144   # default 256KiB
retention = args[:retention] || 345600   # default 4 days
queue = _name("queue", args)
receive = args[:receive] || 0
redrive = args[:redrive] || ""
visibility = args[:visibility] || 30   # default 30 seconds

_(name) do
  Type "AWS::SQS::Queue"
  Properties do
    ContentBasedDeduplication content unless content.empty?
    DelaySeconds deplay
    FifoQueue fio unless fifo.empty?
    MaximumMessageSize max
    MessageRetentionPeriod retention
    QueueName queue
    ReceiveMessageWaitTimeSeconds receive if 1 <= receive.to_i and receive.to_i <= 20
    RedrivePolicy redrive unless redrive.empty?
    VisibilityTimeout visibility
  end
end
