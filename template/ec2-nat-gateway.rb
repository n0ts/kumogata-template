#
# EC2 NATGateway resource
# http://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/aws-resource-ec2-natgateway.html
#
require 'kumogata/template/helper'

name = _resource_name(args[:name], "nat gateway")
allocation = _ref_attr_string("allocation", "AllocationId", args, "eip")
subnet = _ref_string("subnet", args, "subnet")

_(name) do
  Type "AWS::EC2::NatGateway"
  Properties do
    AllocationId allocation
    SubnetId subnet
  end
end
