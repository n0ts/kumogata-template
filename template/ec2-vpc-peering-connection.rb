#
# EC2 VPC Peerning Connection resource
# http://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/aws-resource-ec2-vpcpeeringconnection.html
#
require 'kumogata/template/helper'

name = _resource_name(args[:name], "vpc peering connection")
peer_vpc = _ref_string("peer_vpc", args, "vpc")
tags = _tags(args)
vpc = _ref_string("vpc", args, "vpc")
peer_owner = _ref_string("peer_owner", args, "peer owner")
peer_role = _ref_attr_string("peer_role", "Arn", args, "role")

_(name) do
  Type "AWS::EC2::VPCPeeringConnection"
  Properties do
    PeerVpcId peer_vpc
    Tags tags
    VpcId vpc
    PeerOwnerId peer_owner unless peer_owner.empty?
    PeerRoleArn peer_role unless peer_role.empty?
  end
end
