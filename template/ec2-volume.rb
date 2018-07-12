#
# EC2 Volume resource
# https://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/aws-properties-ec2-ebs-volume.html
#
require 'kumogata/template/helper'

name = _resource_name(args[:name], "volume")
auto_enable = _bool("auto_enable", args, false)
az = _availability_zone(args)
encrypted = _bool("encrypted", args, false)
iops = args[:iops] || 300
size = _ref_string_default("size", args, "", 10)
snapshot = args[:snapshot] || ""
tags = _tags(args)
type = _valid_values(args[:type], %w( io1 gp2 sc1 st1 ), "gp2")

_(name) do
  Type "AWS::EC2::Volume"
  Properties do
    AutoEnableIO auto_enable
    AvailabilityZone az
    Encrypted encrypted if encrypted == true
    Iops iops if type == "io1"
    #KmsKeyId
    Size size if snapshot.empty?
    SnapshotId snapshot unless snapshot.empty?
    Tags tags
    VolumeType type
  end
end
