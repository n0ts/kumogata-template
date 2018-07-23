#
# Api Gateway Usage Plan resource
# http://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/aws-resource-apigateway-usageplan.html
#
require 'kumogata/template/helper'
require 'kumogata/template/api-gateway'

name = _resource_name(args[:name], "usage plan")
stages = _api_gateway_stages(args)
description = _ref_string_default("description", args, '', "#{args[:name]} usage plan description")
quota = _api_gateway_quota(args)
throttle = _api_gateway_throttle(args)
plan = _name("plan", args)

_(name) do
  Type "AWS::ApiGateway::UsagePlan"
  Properties do
    ApiStages stages
    Description description unless description.empty?
    Quota quota unless quota.empty?
    Throttle throttle unless throttle.empty?
    UsagePlanName plan
  end
end
