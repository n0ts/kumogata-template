#
# EC2 VPN Connection Route resource
# http://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/aws-resource-ec2-vpn-connection-route.html
#
require 'kumogata/template/helper'

name = _resource_name(args[:name], "vpn connection route")
cidr = _ref_string("cidr", args, "cidr")
vpn = _ref_string("vpn", args, "vpn connection")

_(name) do
  Type "AWS::EC2::VPNConnectionRoute"
  Properties do
    DestinationCidrBlock cidr
    VpnConnectionId vpn
  end
end
