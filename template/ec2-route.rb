#
# EC2 Route resource
# https://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/aws-resource-ec2-route.html
#
require 'kumogata/template/helper'

name = _resource_name(args[:name], "route")
destination_cidr = args[:destination_cidr] || "0.0.0.0/0"
destination_cidr_ipv6 = args[:destination_cidr_ipv6] || ""
egress_only = _ref_string("engress_only", args)
gateway = _ref_string("gateway", args, "internet gateway")
instance = _ref_string("instance", args, "intance")
nat_gateway = _ref_string("nat_gateway", args, "nat gateway")
network_interface = _ref_string("network_interface", args)
route_table = _ref_string("route_table", args, "route table")
vpc_peering_connection = _ref_string("vpc_peering_connection", args)
depends = _depends([ { ref_nat_gateway: 'nat gateway' } ], args)

_(name) do
  Type "AWS::EC2::Route"
  Properties do
    DestinationCidrBlock destination_cidr if destination_cidr_ipv6.empty?
    DestinationIpv6CidrBlock destination_cidr_ipv6 if destination_cidr.empty?
    EgressOnlyInternetGatewayId egress_only unless destination_cidr_ipv6.empty?
    GatewayId gateway unless gateway.empty?
    InstanceId instance unless instance.empty?
    NatGatewayId nat_gateway unless nat_gateway.empty?
    NetworkInterfaceId network_interface unless network_interface.empty?
    RouteTableId route_table unless route_table.empty?
    VpcPeeringConnectionId vpc_peering_connection unless vpc_peering_connection.empty?
  end
  DependsOn depends unless depends.empty?
end
