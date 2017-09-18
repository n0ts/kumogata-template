#
# EC2 VPC DHCP Options Association resource
# http://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/aws-resource-ec2-vpc-dhcp-options-assoc.html
#
require 'kumogata/template/helper'

name = _resource_name(args[:name], "vpc dhcp options association")
dhcp = _ref_string("dhcp", args, "dhcp options")
vpc = _ref_string("vpc", args, "vpc")

_(name) do
  Type "AWS::EC2::VPCDHCPOptionsAssociation"
  Properties do
    DhcpOptionsId dhcp
    VpcId vpc
  end
end
