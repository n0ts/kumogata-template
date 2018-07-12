#
# RDS DBClusterParameterGroup resource
# http://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/aws-resource-rds-dbclusterparametergroup.html
#
require 'kumogata/template/helper'
require 'kumogata/template/rds'

engine = _valid_values(args[:engine], %w( aurora aurora-mysql aurora-postgresql ), 'aurora-mysql')
default_family =
  case engine
  when 'aurora'
    'aurora5.6'
  when 'aurora-mysql'
    'aurora-mysql5.7'
  when 'aurora-postgresql'
    'aurora-postgresql9.6'
  end

name = _resource_name(args[:name], "db cluster parameter group")
description = _ref_string_default("description", args, '',
                                  "#{args[:name]} db cluster parameter group description")
family = _ref_string("family", args, "db parameter group", default_family)
parameters = args[:parameters] || {}
tags = _tags(args)

parameters = parameters.merge(_rds_to_parameter_charset(args[:charset])) if args.key? :charset

_(name) do
  Type "AWS::RDS::DBClusterParameterGroup"
  Properties do
    Description description
    Family family
    Parameters parameters
    Tags tags
  end
end
