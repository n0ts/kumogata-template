#
# EC2 EIP Association resource
# https://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/aws-properties-ec2-eip-association.html
#
require 'kumogata/template/helper'

name = _resource_name(args[:name], "eip association")
allocation = _ref_string("allocation", args, "eip")
eip = args[:eip] || ""
instance = _ref_string("instance", args, "instance")
network = args[:network] || ""
private_ip = args[:private_ip] || ""

_(name) do
  Type "AWS::EC2::EIPAssociation"
  Properties do
    AllocationId allocation
    EIP eip unless eip.empty?
    InstanceId instance unless instance.empty?
    NetworkInterfaceId network unless network.empty?
    PrivateIpAddress private_ip unless private_ip.empty?
  end
end
