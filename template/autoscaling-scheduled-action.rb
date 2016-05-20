#
# Autoscaling ScheduledAction resource
# http://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/aws-resource-as-scheduledaction.html
#
require 'kumogata/template/helper'

name = _resource_name(args[:name], "autoscaling scheduled action")
autoscaling = _ref_string("autoscaling", args, "autoscaling group")
desired = args[:desired] || ""
end_time =
  if args.key? :end_time
    _timestamp_utc_from_string("2016-03-18 00:00")
  else
    ""
  end
min = args[:min] || ""
max = args[:max] || ""
recurrence = args[:recurrence] || ""
start_time =
  if args.key? :start_time
    _timestamp_utc_from_string("2016-03-18 00:00")
  else
    ""
  end

_(name) do
  Type "AWS::AutoScaling::ScheduledAction"
  Properties do
    AutoScalingGroupName autoscaling
    DesiredCapacity desired unless desired.empty?
    EndTime end_time unless end_time.empty?
    MaxSize max unless max.empty?
    MinSize min unless min.empty?
    Recurrence recurrence unless recurrence.empty?
    StartTime start_time unless start_time.empty?
  end
end
