#
# EC2 VPN Connection resource
# http://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/aws-resource-ec2-vpn-connection.html
#
require 'kumogata/template/helper'

name = _resource_name(args[:name], "vpn connection")
type = _ref_string("type", args)
customer = _ref_string("customer", args, "customer gateway")
static = true
tags = _tags(args)
vpn = _ref_string("vpn", args, "vpn gateway")

_(name) do
  Type "AWS::EC2::VPNConnection"
  Properties do
    Type type
    CustomerGatewayId customer
    StaticRoutesOnly static
    Tags tags
    VpnGatewayId vpn
  end
end
