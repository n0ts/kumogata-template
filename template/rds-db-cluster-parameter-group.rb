#
# RDS DBClusterParameterGroup resource
# http://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/aws-resource-rds-dbclusterparametergroup.html
#
require 'kumogata/template/helper'

name = _resource_name(args[:name], "db cluster parameter group")
description = args[:description] || "#{args[:name]} db cluster parameter group description"
family = _ref_string("family", args, "db parameter group")
family = "aurora5.6" if family.empty?
parameters = args[:parameters]
tags = _tags(args)

_(name) do
  Type "AWS::RDS::DBClusterParameterGroup"
  Properties do
    Description description
    Family family
    Parameters parameters
    Tags tags
  end
end
