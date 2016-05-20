#
# EC2 Route Table resource
# https://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/aws-resource-ec2-route-table.html
#
require 'kumogata/template/helper'

name = _resource_name(args[:name], "route table")
vpc = _ref_string("vpc", args, "vpc")
tags = _tags(args)

_(name) do
  Type "AWS::EC2::RouteTable"
  Properties do
    VpcId vpc
    Tags tags
  end
end
