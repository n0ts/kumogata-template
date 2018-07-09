#
# RDS OptionGroup resource
# http://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/aws-resource-rds-optiongroup.html
#
require 'kumogata/template/helper'
require 'kumogata/template/rds'

name = _resource_name(args[:name], "option group")
engine = _valid_values(args[:engine],
                       %w( mysql mariadb
                           oracle-se1 oracle-se oracle-ee
                           sqlserver-ee sqlserver-se sqlserver-ex sqlserver-web
                           postgres aurora aurora-mysql aurora-postgresql ),
                       RDS_DEFAULT_ENGINE)
major =
  case engine
  when 'mysql'
    '5.7'
  when 'mariadb'
    '10.0'
  when 'postgres'
    '9.6'
  when 'aurora'
    '5.6'
  when 'aurora-mysql'
    '5.7'
  when 'aurora-postgresql'
    '9.6'
  else
    args[:major] || ""
  end
description = _ref_string_default("description", args, '',
                                  "#{args[:name]} option group description")
configurations = _rds_option_group_configurations(args)
tags = _tags(args)

_(name) do
  Type "AWS::RDS::OptionGroup"
  Properties do
    EngineName engine
    MajorEngineVersion major
    OptionGroupDescription description
    OptionConfigurations configurations
    Tags tags
  end
end
