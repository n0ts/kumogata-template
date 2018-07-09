#
# ElastiCache ParameterGroup resource
# http://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/aws-properties-elasticache-parameter-group.html
#
require 'kumogata/template/helper'

name = _resource_name(args[:name], "cache parameter group")
family = _ref_string("family", args)
family = "redis2.8" if family.empty?
description = _ref_string_default("description", args, '', "#{args[:name]} cache parameter group description")
properties = args[:properties] || []

_(name) do
  Type "AWS::ElastiCache::ParameterGroup"
  Properties do
    CacheParameterGroupFamily family
    Description description
    Properties properties
  end
end
