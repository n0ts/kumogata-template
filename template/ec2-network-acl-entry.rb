#
# EC2 Network ACL Entry resource
# http://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/aws-resource-ec2-network-acl-entry.html
#
require 'kumogata/template/helper'
require 'kumogata/template/ec2'

name = _resource_name(args[:name], "network acl entry")
cidr = args[:cidr] || "0.0.0.0/0"
egress = _bool("egress", args, false)
icmp = args[:icmp] || ""
network_acl = _ref_string("network_acl", args, "network acl")
port_range = _ec2_port_range(args)
protocol = _ec2_protocol_number(args[:protocol])
rule_action = _valid_values(args[:action], %w( allow deny ), "allow")
rule_number = _valid_numbers(args[:number], 1, 32766, 100)

_(name) do
  Type "AWS::EC2::NetworkAclEntry"
  Properties do
    CidrBlock cidr
    Egress egress
    Icmp icmp if protocol == 1
    NetworkAclId network_acl
    PortRange port_range if protocol == -1 or protocol == 6 or protocol == 17
    Protocol protocol
    RuleAction rule_action
    RuleNumber rule_number
  end
end
