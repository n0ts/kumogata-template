#
# Output alb
#
require 'kumogata/template/helper'

_output "#{args[:name]} load balancer",
        ref_value: "#{args[:name]} load balancer",
        export: _export_string(args, "#{args[:name]} load balancer")
_output "#{args[:name]} load balancer dns name",
        ref_value: [ "#{args[:name]} load balancer", "DNSName" ],
        export: _export_string(args, "#{args[:name]} load balancer dns name")
_output "#{args[:name]} load balancer canonical hosted zone id",
        ref_value: [ "#{args[:name]} load balancer", "CanonicalHostedZoneID" ],
        export: _export_string(args, "#{args[:name]} load balancer canonical hosted zone id") if args.key? :route53
_output "#{args[:name]} load balancer full name",
        ref_value: [ "#{args[:name]} load balancer", "LoadBalancerFullName" ],
        export: _export_string(args, "#{args[:name]} load balancer full name")
_output "#{args[:name]} load balancer name",
        ref_value: [ "#{args[:name]} load balancer", "LoadBalancerName" ],
        export: _export_string(args, "#{args[:name]} load balancer name")

args[:security_groups].times do |i|
  _output "#{args[:name]} load balancer security group #{i}",
          value: _select(i, _attr_string(args[:name], "SecurityGroups", "load balancer")),
          export: _export_string(args, "#{args[:name]} load balancer security group #{i}")
end if args.key? :security_groups
