#
# EC2 Subnet Network Acl Association resource
# http://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/aws-resource-ec2-subnet-network-acl-assoc.html
#
require 'kumogata/template/helper'

name = _resource_name(args[:name], "subnet network acl association")
subnet = _ref_string("subnet", args, "subnet")
network_acl = _ref_string("network_acl", args, "network acl")

_(name) do
  Type "AWS::EC2::SubnetNetworkAclAssociation"
  Properties do
    SubnetId subnet
    NetworkAclId network_acl
  end
end
