#
# EC2 Host resource
# https://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/aws-resource-ec2-host.html
#
require 'kumogata/template/helper'
require 'kumogata/template/ec2'

name = _resource_name(args[:name], "host")
auto = _valid_values(args[:auto], %w( on off ), "")
az = _availability_zone(args)
instance_type = _ref_string("instance_type", args, "instance type")
instance_type = EMR_DEFAULT_INSTANCE_TYPE  if instance_type.empty?

_(name) do
  Type "AWS::EC2::Host"
  Properties do
    AutoPlacement auto unless auto.empty?
    AvailabilityZone az
    InstanceType instance_type
  end
end
