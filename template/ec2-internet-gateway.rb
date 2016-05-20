#
# EC2 InternetGateway resource
# https://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/aws-resource-ec2-internet-gateway.html
#
require 'kumogata/template/helper'

name = _resource_name(args[:name], "internet gateway")
tags = _tags(args)

_(name) do
  Type "AWS::EC2::InternetGateway"
  Properties do
    Tags tags
  end
end
