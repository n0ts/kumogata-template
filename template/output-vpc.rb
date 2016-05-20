#
# Output VPC
#

vpc = "#{args[:name]} vpc"

_output "#{args[:name]} vpc", ref_value: vpc
_output "#{args[:name]} vpc cidr block", ref_value: [ vpc, "CidrBlock" ]
_output "#{args[:name]} vpc network acl", ref_value: [ vpc, "DefaultNetworkAcl" ]
_output "#{args[:name]} vpc security group", ref_value: [ vpc, "DefaultSecurityGroup" ]
