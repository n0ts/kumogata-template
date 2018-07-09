#
# Autoscaling AutoScalingGroup resource
# https://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/aws-properties-as-group.html
#
require 'kumogata/template/helper'
require 'kumogata/template/autoscaling'

name = _resource_name(args[:name], "autoscaling group")
azs = _availability_zones(args)
cooldown = args[:cooldown] || -1
desired = args[:desired] || ""
health_check_grace = args[:health_check_grace] || -1
health_check_type = _valid_values(args[:helath_check_type], %w( ec2 elb ), "ec2")
instance = _ref_string("instance", args)
launch = _ref_string("launch", args, "autoscaling launch configuration")
load_balancers = _ref_array("load_balancers", args)
max = (args[:max] || 1).to_i
metrics = [ _autoscaling_metrics ]
min = (args[:min] || 0).to_i
max = min if max < min
notifications = (args[:notifications] || []).collect{|v| _autoscaling_notification(v) }
placement = args[:placement] || ""
tags = _autoscaling_tags(args)
target_groups = args[:target_groups] || []
terminations = _autoscaling_terminations(args)
vpc_zones = _ref_array("vpc_zones", args, "subnet")

_(name) do
  Type "AWS::AutoScaling::AutoScalingGroup"
  Properties do
    AvailabilityZones azs if vpc_zones.empty?
    Cooldown cooldown unless cooldown == -1
    DesiredCapacity desired unless desired.empty?
    HealthCheckGracePeriod health_check_grace unless health_check_grace == -1
    HealthCheckType health_check_type.upcase
    InstanceId instance unless instance.empty?
    LaunchConfigurationName launch if instance.empty?
    LoadBalancerNames load_balancers unless load_balancers.empty?
    MaxSize max
    MetricsCollection metrics
    MinSize min
    NotificationConfigurations notifications
    PlacementGroup placement unless placement.empty?
    Tags tags
    TargetGroupARNs target_groups unless target_groups.empty?
    TerminationPolicies terminations unless terminations.empty?
    VPCZoneIdentifier vpc_zones unless vpc_zones.empty?
  end
end
