#
# ELB(ElasticLoadBalancing) LoadBalancer resource
# http://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/aws-properties-ec2-elb.html
#
require 'kumogata/template/helper'
require 'kumogata/template/elb'

name = _resource_name(args[:name], "load balancer")
access_log = _elb_access_logging_policy(args)
app_cookie = _elb_app_cookie_stickiness_policy(args)
azs = _availability_zones(args, false)
connection_draining = _elb_connection_draining_policy(args)
connection_setting = _elb_connection_settings(args)
cross = _bool("cross", args, true)
health = _elb_health_check(args)
instances = _ref_array("instances", args, "instance")
cookie = _elb_cookie_stickiness_policy(args)
lb_name = _name("lb_name", args)
listeners = _elb_listeners(args)
policies = _elb_policy_types(args)
scheme = _valid_values("scheme", %w( internal internal-facing ), "")
security_groups = _ref_array("security_groups", args, "security group")
subnets = _ref_array("subnets", args, "subnet")
tags = _tags(args, "lb_name")

_(name) do
  Type "AWS::ElasticLoadBalancing::LoadBalancer"
  Properties do
    AccessLoggingPolicy access_log unless access_log.empty?
    AppCookieStickinessPolicy app_cookie unless app_cookie.empty?
    AvailabilityZones azs if subnets.empty?
    ConnectionDrainingPolicy connection_draining
    ConnectionSettings connection_setting
    CrossZone cross
    HealthCheck health
    Instances instances unless instances.empty?
    LBCookieStickinessPolicy cookie unless cookie.empty?
    LoadBalancerName lb_name
    Listeners listeners
    Policies policies unless policies.empty?
    Scheme scheme unless scheme.empty?
    SecurityGroups security_groups
    Subnets subnets unless subnets.empty?
    Tags tags
  end
end
