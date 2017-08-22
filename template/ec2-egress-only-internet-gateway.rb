#
# EC2 Egress Only Internet Gateway resource
# http://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/aws-resource-ec2-egressonlyinternetgateway.html
#
require 'kumogata/template/helper'

name = _resource_name(args[:name], "egress only internet gateway")
vpc = _ref_string("vpc", args, "vpc")

_(name) do
  Type "AWS::EC2::EgressOnlyInternetGateway"
  Properties do
    VpcId vpc
  end
end
