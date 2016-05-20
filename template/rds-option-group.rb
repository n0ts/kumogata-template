#
# RDS OptionGroup resource
# http://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/aws-resource-rds-optiongroup.html
#
require 'kumogata/template/helper'

name = _resource_name(args[:name], "option group")
engine = args[:engine] || "mysql"
major = args[:major] || "5.7"
description = args[:description] || "#{args[:name]} option group description"
configurations = args[:configurations]
tags = _tags(args)

_(name) do
  Type "AWS::RDS::OptionGroup"
  Properties do
    EngineName engine
    MajorEngineVersion major
    OptionGroupDescription description
    OptionGroupConfigurations configurations
    Tags tags
  end
end
