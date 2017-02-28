#
# Cloudwatch alarm resource
# http://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/aws-properties-cw-alarm.html
#
require 'kumogata/template/helper'
require 'kumogata/template/cloudwatch'

name = _resource_name(args[:name], "alarm")
enabled = _bool("enabled", args, true)
actions = _cloudwatch_actions(args)
description = args[:description] || ""
alarm_name = _ref_name("alarm_name", args)
operator = _cloudwatch_to_operator(args[:operator])
dimensions = (args[:dimensions] || []).collect{|v| _cloudwatch_dimension(v) }
evaluation = args[:evaluation] || 3
insufficients = args[:insufficients] || []
metric = _cloudwatch_to_metric(args[:metric])
namespace = _cloudwatch_to_namespace(args[:namespace])
ok_actions = args[:ok_actions] || []
period = _cloudwatch_to_period(args[:period] || "5m")
statistic = _valid_values(_cloudwatch_to_statistic(args[:statistic]),
                          %w(SampleCount Average Sum Minimum Maximum), "Average")
threshold = args[:threshold] || 60
unit = _cloudwatch_to_unit(args[:unit])

_(name) do
  Type "AWS::CloudWatch::Alarm"
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
