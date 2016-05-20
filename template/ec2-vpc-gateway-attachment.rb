#
# EC2 VPCGatewayAttachment resource
# https://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/aws-resource-ec2-vpc-gateway-attachment.html
#
require 'kumogata/template/helper'

name = _resource_name(args[:name], "vpc gateway attachment")
internet_gateway = _ref_string("internet_gateway", args, "internet gateway")
vpc = _ref_string("vpc", args, "vpc")
vpc_gateway = _ref_string("vpc_gateway", args, "vpc gateway")

_(name) do
  Type "AWS::EC2::VPCGatewayAttachment"
  Properties do
    InternetGatewayId internet_gateway
    VpcId vpc
    VpnGatewayId vpc_gateway unless vpc_gateway.empty?
  end
end
