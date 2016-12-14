#
# Cloudwatch alarm resource
# http://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/aws-properties-cw-alarm.html
#
require 'kumogata/template/helper'
require 'kumogata/template/cloudwatch'

name = _resource_name(args[:name], "alarm")
enabled = _bool("enabled", args, true)
actions = _ref_array("actions", args)
description = args[:description] || ""
alarm_name = _ref_name("alarm_name", args)
operator = _cloudwatch_convert_operator(args[:operator])
dimensions = (args[:dimensions] || []).collect{|v| _cloudwatch_dimension(v) }
evaluation = args[:evaluation] || 3
insufficients = args[:insufficients] || []
metric = args[:metric]
namespace = args[:namespace]
ok_actions = args[:ok_actions] || []
period = _cloudwatch_to_period(args[:period] || '5m')
statistic = _valid_values(_cloudwatch_to_statistic(args[:statistic]),
                          %w(SampleCount Average Sum Minimum Maximum), "Average")
threshold = args[:threshold] || 60
unit = _valid_values(args[:unit], %w(Seconds Microseconds Milliseconds Bytes Kilobytes Megabytes Gigabytes Terabytes Bits Kilobits Megabits Gigabits Terabits Percent Count Bytes/Second Kilobytes/Second Megabytes/Second Gigabytes/Second Terabytes/Second Bits/Second Kilobits/Second Megabits/Second Gigabits/Second Terabits/Second Count/Second None), "")

_(name) do
  Type AWS::CloudWatch::Alarm
  Properties do
    ActionsEnabled enabled
    AlarmActions actions
    AlarmDescription description unless description.empty?
    AlarmName alarm_name
    ComparisonOperator operator
    Dimensions dimensions
    EvaluationPeriods evaluation
    InsufficientDataActions insufficients unless insufficients.empty?
    MetricName metric
    Namespace namespace
    OKActions ok_actions unless ok_actions.empty?
    Period period
    Statistic statistic
    Threshold threshold
    Unit unit unless unit.empty?
  end
end
