#
# Api Gateway Stage resource
# http://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/aws-resource-apigateway-stage.html
#
require 'kumogata/template/helper'
require 'kumogata/template/api-gateway'

name = _resource_name(args[:name], "stage")
cache_cluster = _ref_string_default("cache_cluster", args)
certificate = _ref_string_default("certificate", args, "certificate")
deployment = _ref_string("deployment", args, "deployment")
description = _ref_string_default("description", args, '', "#{args[:name]} stage description")
settings = _api_gateway_method_settings(args)
rest = _ref_string("rest", args, "rest api")
stage = _name("stage", args, "_")
variables = args[:variables] || {}
depends = _depends([ { ref_account: "account" } ], args)

_(name) do
  Type "AWS::ApiGateway::Stage"
  Properties do
    CacheClusterEnabled cache_cluster.empty? ? false : true
    CacheClusterSize cache_cluster unless cache_cluster.empty?
    ClientCertificateId certificate unless certificate.empty?
    DeploymentId deployment
    Description description unless description.empty?
    MethodSettings settings unless settings.empty?
    RestApiId rest
    StageName stage
    Variables variables unless variables.empty?
  end
  DependsOn depends unless depends.empty?
end
