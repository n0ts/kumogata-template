#
# EC2 VPN Gateway resource
# http://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/aws-resource-ec2-vpn-gateway.html
#
require 'kumogata/template/helper'

name = _resource_name(args[:name], "vpn gateway")
type = _ref_string("type", args)
tags = _tags(args)

_(name) do
  Type "AWS::EC2::VPNGateway"
  Properties do
    Type type
    Tags tags
  end
end
