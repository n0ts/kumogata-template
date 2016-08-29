#
# ALB(ElasticLoadBalancingV2) Listener resource
# https://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/aws-resource-elasticloadbalancingv2-listener.html
#
require 'kumogata/template/helper'
require 'kumogata/template/alb'

name = _resource_name(args[:name], "load balancer listener")
certificates = _alb_certificates(args)
defaults = _alb_actions(args)
lb = _ref_string("lb", args, "load balancer")
port = args[:port] || 80
protocol = _valid_values("protocol", %w( http https ), "http")
ssl = args[:ssl] || ""

_(name) do
  Type "AWS::ElasticLoadBalancingV2::Listener"
  Properties do
    Certificates certificates unless certificates.empty?
    DefaultActions defaults
    LoadBalancerArn lb
    Port port
    Protocol protocol.upcase
    SslPolicy ssl unless ssl.empty?
  end
end
