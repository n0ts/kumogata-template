#
# Autoscaling ScheduledAction resource
# http://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/aws-resource-as-scheduledaction.html
#
require 'kumogata/template/helper'
require 'kumogata/template/autoscaling'

name = _resource_name(args[:name], "autoscaling scheduled action")
autoscaling = _ref_string("autoscaling", args, "autoscaling group")
desired = _integer("desired", args, -1)
end_time =
  if args.key? :end_time
    _timestamp_utc(args[:end_time])
  else
    ""
  end
max = _integer("max", args, -1)
max = desired if max < desired
min = _integer("min", args, -1)
min = desired if min < desired
recurrence =
  if args.key? :recurrence
    _autoscaling_to_schedued_recurrence(args[:recurrence])
  else
    ""
  end
start_time =
  if args.key? :start_time
    _timestamp_utc(args[:start_time])
  else
    _timestamp_utc(Time.now + 3600)
  end

_(name) do
  Type "AWS::AutoScaling::ScheduledAction"
  Properties do
    AutoScalingGroupName autoscaling
    DesiredCapacity desired if desired > -1
    EndTime end_time unless end_time.empty?
    MaxSize max if max > -1
    MinSize min if min > -1
    Recurrence recurrence unless recurrence.empty?
    StartTime start_time unless start_time.empty?
  end
end
