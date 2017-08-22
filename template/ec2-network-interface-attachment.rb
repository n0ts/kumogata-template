#
# EC2 Network Interface Attachment resource
# http://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/aws-resource-ec2-network-interface-attachment.html
#
require 'kumogata/template/helper'

name = _resource_name(args[:name], "network interface attachment")
delete = _bool("delete", args, true)
index = args[:index] || 0
instance = _ref_string("instance", args, "instance")
network = _ref_string("network", args, "network interface")

_(name) do
  Type "AWS::EC2::NetworkInterfaceAttachment"
  Properties do
    DeleteOnTermination delete
    DeviceIndex index
    InstanceId instance
    NetworkInterfaceId network
  end
end

