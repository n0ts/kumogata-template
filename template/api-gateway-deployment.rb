#
# Api Gateway Deployment
# http://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/aws-resource-apigateway-deployment.html
#
require 'kumogata/template/helper'
require 'kumogata/template/api-gateway'

name = _resource_name(args[:name], "deployment")
description = _ref_string_default("description", args, '', "#{args[:name]} deployment description")
rest = _ref_string("rest", args, "rest api")
stage_description = _api_gateway_stage_description(args)
stage_name = _name("stage", args)
depends = _depends([ { ref_method: "method", ref_method_option: "method" } ], args)

_(name) do
  Type "AWS::ApiGateway::Deployment"
  Properties do
    Description description unless description.empty?
    RestApiId rest
    StageDescription stage_description unless stage_description.empty?
    StageName stage_name
  end
  DependsOn depends unless depends.empty?
end
