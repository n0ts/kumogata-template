#
# EC2 SubnetRouteTableAssociation
# https://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/aws-resource-ec2-subnet-route-table-assoc.html
#
require 'kumogata/template/helper'

name = _resource_name(args[:name], "subnet route table association")
route_table = _ref_string("route_table", args, "route table")
subnet = _ref_string("subnet", args, "subnet")

_(name) do
  Type "AWS::EC2::SubnetRouteTableAssociation"
  Properties do
    RouteTableId route_table
    SubnetId subnet
  end
end
