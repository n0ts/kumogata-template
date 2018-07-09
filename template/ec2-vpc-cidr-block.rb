#
# EC2 VPC Cidr Block resource
# http://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/aws-resource-ec2-vpccidrblock.html
#
require 'kumogata/template/helper'

name = _resource_name(args[:name], "vpc cidr block")
cidr = _ref_string("cidr", args, false)
ipv6_cidr = _bool("ipv6_cidr", args, false)
vpc = _ref_string("vpc", args, "vpc")

_(name) do
  Type "AWS::EC2::VPCCidrBlock"
  Properties do
    AmazonProvidedIpv6CidrBlock ipv6_cidr
    CidrBlock cidr unless cidr.empty?
    VpcId vpc
  end
end
