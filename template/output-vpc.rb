#
# Output VPC
#
require 'kumogata/template/helper'

vpc = "#{args[:name]} vpc"
ipv6 = _bool("ipv6", args, false)

_output "#{args[:name]} vpc",
        ref_value: vpc,
        export: _export_string(args, "vpc")
_output "#{args[:name]} vpc cidr block",
        ref_value: [ vpc, "CidrBlock" ],
        export: _export_string(args, "vpc cidr block")
args[:cidr_block_assoc].times do |i|
  _output "#{args[:name]} #{i + 1} vpc cidr block association",
          ref_value: [ vpc, "CidrBlockAssociations" ],
          select: i,
          export: _export_string(args, "vpc cidr block association")
end if args.key? :cidr_block_assoc
_output "#{args[:name]} vpc network acl",
        ref_value: [ vpc, "DefaultNetworkAcl" ],
        export: _export_string(args, "vpc default nework acl")
_output "#{args[:name]} vpc security group",
        ref_value: [ vpc, "DefaultSecurityGroup" ],
        export: _export_string(args, "vpc default security group")
args[:ipv6].times do |i|
  _output "#{args[:name]} #{i+1} vpc ipv6 cidr block",
          ref_value: [ vpc, "Ipv6CidrBlocks" ],
          select: i,
          export: _export_string(args, "vpc ipv6 cidr block")
end if ipv6
