#
# ALB(ElasticLoadBalancingV2) TargetGroup resource
# https://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/aws-resource-elasticloadbalancingv2-targetgroup.html
#
require 'kumogata/template/helper'
require 'kumogata/template/alb'

name = _resource_name(args[:name], "target group")
health_check = _alb_health_check(args[:health_check] || {})
matcher = _alb_matcher(args)
target = _name("target", args)
attributes = _alb_attributes(args)
full = _ref_key?("full", args) ? _name("full", args) : ""
protocol = _valid_values(args[:protocol], %w( http https ), "http")
port =
  if args.key? :port
    args[:port]
  else
    PORT[protocol.to_sym] || PORT[:http]
  end
tags = _tags(args, "target")
targets = _alb_targets(args)
vpc = _ref_string("vpc", args, "vpc")

_(name) do
  Type "AWS::ElasticLoadBalancingV2::TargetGroup"
  Properties do
    HealthCheckIntervalSeconds health_check[:interval]
    HealthCheckPath health_check[:path]
    HealthCheckPort health_check[:port]
    HealthCheckProtocol health_check[:protocol]
    HealthCheckTimeoutSeconds health_check[:timeout]
    HealthyThresholdCount health_check[:healthy]
    Matcher matcher
    Name target
    Port port
    Protocol protocol.upcase
    Tags tags
    TargetGroupAttributes attributes unless attributes.empty?
    TargetGroupFullName full unless full.empty?
    Targets targets unless targets.empty?
    UnhealthyThresholdCount health_check[:unhealthly]
    VpcId vpc
  end
end
