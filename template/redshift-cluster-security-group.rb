#
# Redshift ClusterSecurityGroup resource
# http://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/aws-resource-redshift-clustersecuritygroup.html
#
require 'kumogata/template/helper'

name = _resource_name(args[:name], "redshift cluster security group")
description = _ref_string_default("description", args, '', "#{args[:name]} redshift cluster security group description")
tags = _tags(args)

_(name) do
  Type "AWS::Redshift::ClusterSecurityGroup"
  Properties do
    Description description
    Tags tags
  end
end
