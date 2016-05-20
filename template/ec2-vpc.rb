#
# EC2 VPC resource
# https://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/aws-resource-ec2-vpc.html
#
require 'kumogata/template/helper'

name = _resource_name(args[:name], "vpc")
cidr = args[:cidr] || "191.168.1.0/16"
dns_support = _bool("dns_support", args, true)
dns_hostnames = args[:dns_hostnames] || dns_support
instance_tenancy = _valid_values(args[:instance_tenancy],
                                 %w( default dedicated ), "default")
tags = _tags(args)

_(name) do
  Type "AWS::EC2::VPC"
  Properties do
    CidrBlock cidr
    EnableDnsSupport dns_support
    EnableDnsHostnames dns_hostnames
    InstanceTenancy instance_tenancy
    Tags tags
  end
end
