#
# EC2 Volume Attachment resource
# https://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/aws-properties-ec2-ebs-volumeattachment.html
#
require 'kumogata/template/helper'

name = _resource_name(args[:name], "volume attachment")
device = args[:device] || "/dev/sdb"
instance = _ref_string("instance", args, "instance")
volume = _ref_string("volume", args, "volume")

_(name) do
  Type "AWS::EC2::VolumeAttachment"
  Properties do
    Device device
    InstanceId instance
    VolumeId volume
  end
end
