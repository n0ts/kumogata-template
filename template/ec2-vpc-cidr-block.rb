#
# EC2 VPC Cidr Block resource
# http://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/aws-resource-ec2-vpccidrblock.html
#
require 'kumogata/template/helper'

name = _resource_name(args[:name], "vpc cidr block")
cidr = true
vpc = _ref_string("vpc", args, "vpc")

_(name) do
  Type "AWS::EC2::VPCCidrBlock"
  Properties do
    AmazonProvidedIpv6CidrBlock cidr
    VpcId vpc
  end
end
