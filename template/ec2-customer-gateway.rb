#
# EC2 Customer Gateway resource
# http://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/aws-resource-ec2-customer-gateway.html
#
require 'kumogata/template/helper'

name = _resource_name(args[:name], "customer gateway")
bgp = _ref_string("bgp", args, "bgp")
ip = _ref_string("ip", args, "ip")
tags = _tags(args)
type = _ref_string("type", args)

_(name) do
  Type "AWS::EC2::CustomerGateway"
  Properties do
    BgpAsn bgp
    IpAddress ip
    Tags tags
    Type type
  end
end
