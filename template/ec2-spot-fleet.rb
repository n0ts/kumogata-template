#
# EC2 Spot Fleet resource
# https://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/aws-properties-ec2-instance.html
#
require 'kumogata/template/helper'
require 'kumogata/template/ec2'

name = _resource_name(args[:name], "spot fleet")
data = _ec2_spot_fleet_request(args)

_(name) do
  Type "AWS::EC2::SpotFleet"
  Properties do
    SpotFleetRequestConfigData data
  end
end
