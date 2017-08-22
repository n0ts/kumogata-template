#
# EC2 VPN Gateway Route Propagation resource
# http://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/aws-resource-ec2-vpn-gatewayrouteprop.html
#
require 'kumogata/template/helper'

name = _resource_name(args[:name], "vpn gateway route propagation")
routes = _ref_array("routes", args, "route table")
vpn = _ref_string("vpn", args, "vpn gateway")

_(name) do
  Type "AWS::EC2::VPNGatewayRoutePropagation"
  Properties do
    RouteTableIds routes
    VpnGatewayId vpn
  end
end
