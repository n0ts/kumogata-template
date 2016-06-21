#
# Autoscaling ScalingPolicy resource
# http://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/aws-properties-as-policy.html
#
require 'kumogata/template/helper'
require 'kumogata/template/autoscaling'

name = _resource_name(args[:name], "autoscaling scaling policy")
adjustment = _valid_values(_autoscaling_to_adjustment(args[:adjustment]),
                           %w( ChangeInCapacity ExactCapacity PercentChangeInCapacity ),
                           "ChangeInCapacity")
autoscaling = _ref_string("autoscaling", args, "autoscaling group")
cooldown = args[:cooldown] || "60"
estimated = args[:estimated] || ""
metric = _valid_values(_autoscaling_to_metric(args[:metric]), %w( Minimum Maximum Average ), "Average")
min = args[:min] || ""
policy = _valid_values(_autoscaling_to_policy(args[:policy]), %w( SimpleScaling StepScaling ), "SimpleScaling")
scaling = args[:scaling] || 1
steps = (args[:steps] || []).collect{|v| _autoscaling_step(v) }

_(name) do
  Type "AWS::AutoScaling::ScalingPolicy"
  Properties do
    AdjustmentType adjustment
    AutoScalingGroupName autoscaling
    Cooldown cooldown unless policy == "StepScaling"
    EstimatedInstanceWarmup estimated unless estimated.empty?
    MetricAggregationType metric unless policy == "SimpleScaling"
    MinAdjustmentMagnitude min if policy == "PercentChangeInCapacity"
    PolicyType policy
    ScalingAdjustment scaling if policy == "SimpleScaling"
    StepAdjustments steps unless steps.empty?
  end
end
