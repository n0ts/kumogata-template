#
# EC2 Network ACL resource
# http://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/aws-resource-ec2-network-acl.html
#
require 'kumogata/template/helper'

name = _resource_name(args[:name], "network acl")
tags = _tags(args)
vpc = _ref_string("vpc", args, "vpc")

_(name) do
  Type "AWS::EC2::NetworkAcl"
  Properties do
    Tags tags
    VpcId vpc
  end
end
