#
# Helper - Events
#
require 'kumogata/template/helper'

def _events_to_schedule_expression(args)
  schedule = args || '5 minutes'
  if schedule =~ /^(\d+) (minute|minutes|hour|hours|day|days)/
    "rate(#{$1} #{$2})"
  else
    "cron(#{schedule})"
  end
end

def _events_pattern(args)
  # http://docs.aws.amazon.com/AmazonCloudWatch/latest/events/CloudWatchEventsandEventPatterns.html#CloudWatchEventsPatterns
  args[:pattern] || {}
end

def _events_targets(args)
  (args[:targets] || []).collect do |target|
    _{
      Arn _ref_attr_string("arn", "Arn", target)
      Id target[:id]
      Input target[:input] if target.key? :input
      InputPath target[:path] if target.key? :path
    }
  end
end
