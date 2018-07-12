#
# EC2 Subnet resource
# https://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/aws-resource-ec2-subnet.html
#
require 'kumogata/template/helper'

name = _resource_name(args[:name], "subnet")
az = _availability_zone(args, false)
cidr = _ref_string_default("cidr", args, "", "10.1.0.0/24")
ipv6_cidr = _ref_string_default("ipv6_cidr", args)
public_ip = _bool("public_ip", args, true)
tags = _tags(args)
vpc = _ref_string("vpc", args, "vpc")

public_ip = "" unless ipv6_cidr.empty?

_(name) do
  Type "AWS::EC2::Subnet"
  Properties do
    AssignIPv6AddressOnCreation true unless ipv6_cidr.empty?
    AvailabilityZone az unless az.empty?
    CidrBlock cidr
    Ipv6CidrBlock ipv6_cidr unless ipv6_cidr.empty?
    MapPublicIpOnLaunch public_ip unless ipv6_cidr.empty?
    Tags tags
    VpcId vpc
  end
end
