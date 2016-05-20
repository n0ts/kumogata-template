#
# RDS DBParameterGroup resource
# http://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/aws-properties-rds-dbparametergroup.html
#
require 'kumogata/template/helper'

name = _resource_name(args[:name], "db parameter group")
description = args[:description] || "#{args[:name]} db parameter group description"
family = args[:family] || "mysql5.7"
parameters = args[:parameters]
tags = _tags(args)

_(name) do
  Type "AWS::RDS::DBParameterGroup"
  Properties do
    Description description
    Family family
    Parameters parameters
    Tags tags
  end
end
