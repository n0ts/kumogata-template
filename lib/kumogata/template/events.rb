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
  ## FIXME
  ## https://docs.aws.amazon.com/AmazonCloudWatchEvents/latest/APIReference/API_PutTargets.html
  (args[:targets] || []).collect do |target|
    role = _ref_attr_string("role", "Arn", target, "role")
    _{
      Arn _ref_attr_string("arn", "Arn", target)
      Id target[:id]
      Input target[:input] if target.key? :input
      InputPath target[:path] if target.key? :path
      RoleArn role unless role.empty?
      EcsParameters _{
        TaskCount target[:ecs_parameters][:task_count] if target[:ecs_parameters].key? :task_count
        TaskDefinitionArn _ref_string("task_definition", target[:ecs_parameters], "ecs task definition", "arn")
      } if target.key? :ecs_parameters
    }
  end
end
