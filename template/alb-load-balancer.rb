#
# ALB(ElasticLoadBalancingV2) loadbalancer resource
# https://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/aws-resource-elasticloadbalancingv2-loadbalancer.html
#
require 'kumogata/template/helper'
require 'kumogata/template/alb'

name = _resource_name(args[:name], "load balancer")
lb_attributes = _alb_attributes(args)
lb_name = _name("lb_name", args)
scheme = _valid_values("scheme", %w( internal internal-facing ), "")
security_groups = _ref_array("security_groups", args, "security group")
subnets = _ref_array("subnets", args, "subnet")
tags = _tags(args, "lb_name")
type = _valid_values(args[:type], %w( application network ), 'application')
ip_address =
  if args.key? :ip_address
    _valid_values("ip_address", %w( ipv4 dualstack ), "dualstack")
  else
    ""
  end

_(name) do
  Type "AWS::ElasticLoadBalancingV2::LoadBalancer"
  Properties do
    LoadBalancerAttributes lb_attributes
    Name lb_name
    Scheme scheme unless scheme.empty?
    SecurityGroups security_groups
    Subnets subnets unless subnets.empty?
    Tags tags
    Type type
    IpAddressType ip_address unless ip_address.empty?
  end
end
