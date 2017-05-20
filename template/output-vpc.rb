#
# Output VPC
#
require 'kumogata/template/helper'

vpc = "#{args[:name]} vpc"

_output "#{args[:name]} vpc",
        ref_value: vpc,
        export: _export_string(args, "#{args[:name]} vpc")
_output "#{args[:name]} vpc cidr block",
        ref_value: [ vpc, "CidrBlock" ],
        export: _export_string(args, "vpc cidr block")
_output "#{args[:name]} vpc network acl",
        ref_value: [ vpc, "DefaultNetworkAcl" ],
        export: _export_string(args, "vpc default nework acl")
_output "#{args[:name]} vpc security group",
        ref_value: [ vpc, "DefaultSecurityGroup" ],
        export: _export_string(args, "vpc default security group")
_output "#{args[:name]} vpc ipv6 cidr blocks",
        ref_value: [ vpc, "Ipv6CidrBlocks" ],
        export: _export_string(args, "vpc ipv6 cidr bocks") if args.key? :ipv6
