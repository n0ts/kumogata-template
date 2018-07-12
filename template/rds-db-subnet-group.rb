#
# RDS DBSubnetGroup resource
# http://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/aws-resource-rds-dbsubnet-group.html
#
require 'kumogata/template/helper'

name = _resource_name(args[:name], "db subnet group")
description = _ref_string_default("description", args, '', "#{args[:name]} db subnet group description")
subnets = _ref_array("subnets", args, "subnet")
tags = _tags(args)

_(name) do
  Type "AWS::RDS::DBSubnetGroup"
  Properties do
    DBSubnetGroupDescription description
    SubnetIds subnets
    Tags tags
  end
end
