#
# ElastiCache SubnetGroup resource
# http://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/aws-properties-elasticache-subnetgroup.html
#
require 'kumogata/template/helper'

name = _resource_name(args[:name], "cache subnet group")
description = args[:description] || "#{args[:name]} cache subnet group description"
subnets = _ref_array("subnets", args, "subnet")

_(name) do
  Type "AWS::ElastiCache::SubnetGroup"
  Properties do
    Description description
    SubnetIds subnets
  end
end
