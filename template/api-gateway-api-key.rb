#
# Api Gateway Api Key resource
# http://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/aws-resource-apigateway-apikey.html
#
require 'kumogata/template/helper'
require 'kumogata/template/api-gateway'

name = _resource_name(args[:name], "api key")
description = _ref_string_default("description", args, '', "#{args[:name]} api key description")
enabled = _bool("enabled", args, true)
key = _name("key", args)
stage_keys = _api_gateway_stage_keys(args)

_(name) do
  Type "AWS::ApiGateway::ApiKey"
  Properties do
    Description description unless description.empty?
    Enabled enabled
    Name key
    StageKeys stage_keys unless stage_keys.empty?
  end
end
