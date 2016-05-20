#
# EC2 Subnet resource
# https://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/aws-resource-ec2-subnet.html
#
require 'kumogata/template/helper'

name = _resource_name(args[:name], "subnet")
az = _availability_zone(args, false)
cidr = args[:cidr] || "10.1.0.0/24"
map_public_ip_on_launch = _bool("map_public_ip_on_launch", args, true)
tags = _tags(args)
vpc = _ref_string("vpc", args, "vpc")

_(name) do
  Type "AWS::EC2::Subnet"
  Properties do
    AvailabilityZone az unless az.empty?
    CidrBlock cidr
    MapPublicIpOnLaunch map_public_ip_on_launch
    Tags tags
    VpcId vpc
  end
end
