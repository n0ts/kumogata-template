#
# EC2 EIP resource
# https://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/aws-properties-ec2-eip.html
#
require 'kumogata/template/helper'

name = _resource_name(args[:name], "eip")
instance = _ref_string("instance", args, "instance")
domain = args[:domain] || ""

_(name) do
  Type "AWS::EC2::EIP"
  Properties do
    InstanceId instance unless instance.empty?
    Domain domain unless domain.empty?
  end
end
