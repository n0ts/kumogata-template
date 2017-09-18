#
# EC2 Subnet Cidr Block resource
# http://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/aws-resource-ec2-subnetcidrblock.html
#
require 'kumogata/template/helper'

name = _resource_name(args[:name], "subnet cidr block")
cidr = _ref_string("cidr", args, "cidr")
subnet = _ref_string("subnet", args, "subnet")

_(name) do
  Type "AWS::EC2::SubnetCidrBlock"
  Properties do
    Ipv6CidrBlock cidr
    SubnetId subnet
  end
end
