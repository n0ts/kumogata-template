#
# Output elb
#
require 'kumogata/template/helper'

_output "#{args[:name]} load balancer",
        ref_value: "#{args[:name]} load balancer",
        export: _export_string(args, "#{args[:name]} load balancer")
_output "#{args[:name]} load balancer canonical hosted zone name",
        ref_value: [ "#{args[:name]} load balancer", "CanonicalHostedZoneName" ],
        export: _export_string(args, "#{args[:name]} load balancer canonical hosted zone name") if args.key? :route53
_output "#{args[:name]} load balancer canonical hosted zone id",
        ref_value: [ "#{args[:name]} load balancer", "CanonicalHostedZoneID" ],
        export: _export_string(args, "#{args[:name]} load balancer canonical hosted zone id") if args.key? :route53
_output "#{args[:name]} load balancer dns name",
        ref_value: [ "#{args[:name]} load balancer", "DNSName" ],
        export: _export_string(args, "#{args[:name]} load balancer dns name")
_output "#{args[:name]} load balancer security group name",
        ref_value: [ "#{args[:name]} load balancer", "SourceSecurityGroup.GroupName" ],
        export: _export_string(args, "#{args[:name]} load balancer source security group group name")
_output "#{args[:name]} load balancer security group owner",
        ref_value: [ "#{args[:name]} load balancer", "SourceSecurityGroup.OwnerAlias" ],
        export: _export_string(args, "#{args[:name]} load balancer source security group owner alias")
