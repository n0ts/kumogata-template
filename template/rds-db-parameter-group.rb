#
# RDS DBParameterGroup resource
# http://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/aws-properties-rds-dbparametergroup.html
#
require 'kumogata/template/helper'
require 'kumogata/template/rds'

engine = _valid_values(args[:engine],
                       %w( mysql mariadb
                           oracle-se1 oracle-se oracle-ee
                           sqlserver-ee sqlserver-se sqlserver-ex sqlserver-web
                           postgresql aurora aurora-mysql aurora-postgresql ),
                       'mysql')
default_family =
  case engine
  when 'mysql'
    'mysql.5.7'
  when 'mariadb'
    'mariadb10.2'
  when 'postgresql'
    'postgres9.6'
  when 'aurora'
    'aurora5.6'
  when 'aurora-mysql'
    'aurora-mysql5.7'
  when 'aurora-postgresql'
    'aurora-postgresql9.6'
  end

name = _resource_name(args[:name], "db parameter group")
description = _ref_string_default("description", args, '',
                                  "#{args[:name]} db parameter group description")
family = _ref_string("family", args, "db parameter group", default_family)
parameters = args[:parameters] || {}
tags = _tags(args)

parameters = parameters.merge(_rds_to_parameter_charset(args[:charset])) if args.key? :charset

_(name) do
  Type "AWS::RDS::DBParameterGroup"
  Properties do
    Description description
    Family family
    Parameters parameters
    Tags tags
  end
end
