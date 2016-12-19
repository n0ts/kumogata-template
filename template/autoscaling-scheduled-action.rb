#
# Autoscaling ScheduledAction resource
# http://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/aws-resource-as-scheduledaction.html
#
require 'kumogata/template/helper'

name = _resource_name(args[:name], "autoscaling scheduled action")
autoscaling =
  if args.key? :autoscaling
    _ref_string("autoscaling", args, "autoscaling group")
  else
    _ref_resource_name(args, "autoscaling group")
  end
desired = args[:desired].to_s || ""
end_time =
  if args.key? :end_time
    _timestamp_utc(args[:end_time])
  else
    ""
  end
max = args[:max].to_s || ""
min = args[:min].to_s || ""
min = desired.to_s if args.key? :desired and desired.to_i < min.to_i
recurrence =
  if args.key? :recurrence
    case args[:recurrence]
    when "every 5 min"
      "*/5 * * * *"
    when "every 30 min"
      "0,30 * * * *"
    when "every 1 hour"
      "0 * * * *"
    when "every day"
      "0 0 * * *"
    when "every week"
      "0 0 * * Tue"
    when /\*/
      args[:recurrence]
    else
      _timestamp_utc(args[:recurrence], "cron")
    end
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
    DesiredCapacity desired unless desired.empty?
    EndTime end_time unless end_time.empty?
    MaxSize max unless max.empty?
    MinSize min unless min.empty?
    Recurrence recurrence unless recurrence.empty?
    StartTime start_time unless start_time.empty?
  end
end
