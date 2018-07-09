#
# Redshift ClusterSubnetGroup resource
# http://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/aws-resource-redshift-clustersubnetgroup.html
#
require 'kumogata/template/helper'

name = _resource_name(args[:name], "redshift cluster subnet group")
description = _ref_string_default("description", args, '', "#{args[:name]} redshift cluster subnet group description")
subnets = _ref_array("subnets", args, "subnet")
tags = _tags(args)

_(name) do
  Type "AWS::Redshift::ClusterSubnetGroup"
  Properties do
    Description description
    SubnetIds subnets
    Tags tags
  end
end
