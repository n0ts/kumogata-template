#
# Helper - AutoScaling
#
require 'kumogata/template/helper'

def _autoscaling_to_adjustment(value)
  return value if value.nil?
  case value.downcase
  when "change"
    "ChangeInCapacity"
  when "exact"
    "ExactCapacity"
  when "percent"
    "PercentChangeInCapacity"
  else
    value
  end
end

def _autoscaling_to_metric(value)
  return value if value.nil?
  case value.downcase
  when "min"
    "Minimum"
  when "max"
    "Maximum"
  when "avg"
    "Average"
  else
    value
  end
end

def _autoscaling_to_policy(value)
  return value if value.nil?
  case value.downcase
  when "simple"
    "SimpleScaling"
  when "step"
    "StepScaling"
  else
    value
  end
end

def _autoscaling_to_schedued_recurrence(value)
  case value
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
    value
  else
    _timestamp_utc(value, "cron")
  end
end

def _autoscaling_metrics
  _{
    Granularity "1Minute"
    Metrics %w( GroupMinSize
                GroupMaxSize
                GroupDesiredCapacity
                GroupInServiceInstances
                GroupPendingInstances
                GroupStandbyInstances
                GroupTerminatingInstances
                GroupTotalInstances )
  }
end

def _autoscaling_notification(args)
  types = args[:types] || []
  %w(
    EC2_INSTANCE_LAUNCH
    EC2_INSTANCE_LAUNCH_ERROR
    EC2_INSTANCE_TERMINATE
    EC2_INSTANCE_TERMINATE_ERROR
    TEST_NOTIFICATION
  ).collect{|v| types << "autoscaling:#{v}" } if types.empty?

  topic = _ref_attr_string("topic", "Arn", args, "topic")
  topic = _ref_string("topic_arn", args) if topic.empty?

  _{
    NotificationTypes types
    TopicARN topic
  }
end

def _autoscaling_step(args)
  lower = args[:lower] || ""
  upper = args[:upper] || ""
  scaling = args[:scaling] || 1

  _{
    MetricIntervalLowerBound lower unless lower.to_s.empty?
    MetricIntervalUpperBound upper unless upper.to_s.empty?
    ScalingAdjustment scaling
  }
end

def _autoscaling_tags(args, tag_name = "tag_name")
  _tags(args, tag_name).collect do |tag|
    tag["PropagateAtLaunch"] = _bool("#{tag["Key"].downcase}_launch", args, true).to_s
    tag
  end
end

def _autoscaling_terminations(args)
  (args[:terminations] || []).collect do |termination|
    case termination.downcase
    when "old instance"
      "OldestInstance"
    when "new instance"
      "NewestInstance"
    when "old launch"
      "OldestLaunchConfiguration"
    when "close"
      "ClosestToNextInstanceHour"
    else
      "Default"
    end
  end
end
