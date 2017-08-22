#
# EC2 Placement Group resource
# http://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/aws-resource-ec2-placementgroup.html
#
require 'kumogata/template/helper'

name = _resource_name(args[:name], "placement group")
strategy = args[:strategy] || "cluster"

_(name) do
  Type "AWS::EC2::PlacementGroup"
  Properties do
    Strategy strategy
  end
end


