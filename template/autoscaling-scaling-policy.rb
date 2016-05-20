#
# Autoscaling ScalingPolicy resource
# http://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/aws-properties-as-policy.html
#
require 'kumogata/template/helper'

name = _resource_name(args[:name], "autoscaling scaling policy")
adjustment = _valid_values(args[:adjustment],
                           %w( ChangeInCapacity ExactCapacity PercentChangeInCapacity ),
                           "ChangeInCapacity")
autoscaling = _ref_string("autoscaling", args, "autoscaling group")
cooldown = args[:cooldown] || -1
estimated = args[:estimated] || ""
metric = _valid_values(args[:metric], %w( Minimum Maximum Average ), "Average")
min = args[:min] || ""
policy = _valid_values(args[:policy], %w( SimpleScaling StepScaling ), "SimpleScaling")
scaling = args[:scaling] || 1
step = args[:step] || [].collect{|v| _autoscaling_step(v) }

_(name) do
  Type "AWS::AutoScaling::ScalingPolicy"
  Properties do
    AdjustmentType adjustment
    AutoScalingGroupName autoscaling
    Cooldown cooldown unless cooldown == -1
    EstimatedInstanceWarmup estimated unless estimated.empty?
    MetricAggregationType metric unless policy == "SimpleScaling"
    MinAdjustmentMagnitude min unless min.empty?
    PolicyType policy
    ScalingAdjustment scaling
    StepAdjustments step unless step.empty?
  end
end
