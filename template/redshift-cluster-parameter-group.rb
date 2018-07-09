#
# Redshift ClusterParameterGroup resource
# http://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/aws-resource-redshift-clusterparametergroup.html
#
require 'kumogata/template/helper'
require 'kumogata/template/redshift'

name = _resource_name(args[:name], "redshift cluster parameter group")
description = _ref_string_default("description", args, '', "#{args[:name]} redshift cluster parameter group description")
family = args[:family] || "redshift-1.0"
parameters = _redshift_parameters(args)
tags = _tags(args)

_(name) do
  Type "AWS::Redshift::ClusterParameterGroup"
  Properties do
    Description description
    ParameterGroupFamily family
    Parameters parameters
    Tags tags
  end
end
