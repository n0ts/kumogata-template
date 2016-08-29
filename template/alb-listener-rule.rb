#
# ALB(ElasticLoadBalancingV2) ListenerRule resource
# https://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/aws-resource-elasticloadbalancingv2-listenerrule.html
#
require 'kumogata/template/helper'
require 'kumogata/template/alb'

name = _resource_name(args[:name], "load balancer listener rule")
actions = _alb_actions(args)
conditions = _alb_conditions(args)
listener = _ref_string("listener", args, "load balancer listener")
priority = args[:priority] || 1

_(name) do
  Type "AWS::ElasticLoadBalancingV2::ListenerRule"
  Properties do
    Actions actions
    Conditions conditions
    ListenerArn listener
    Priority priority
  end
end
