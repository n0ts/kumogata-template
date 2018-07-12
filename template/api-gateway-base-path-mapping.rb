#
# Api Gateway Base Path Mapping
# http://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/aws-resource-apigateway-basepathmapping.html
#
require 'kumogata/template/helper'

name = _resource_name(args[:name], "base path mapping")
base = _ref_string_default("base", args)
domain = _ref_string("domain", args, "domain")
rest = _ref_string("rest", args, "rest api")
stage = _ref_string_default("stage", args, "stage")
depends = _depends([ { ref_domain_name: "domain name" } ], args)

_(name) do
  Type "AWS::ApiGateway::BasePathMapping"
  Properties do
    BasePath base
    DomainName domain
    RestApiId rest
    Stage stage unless stage.empty?
  end
  DependsOn depends unless depends.empty?
end
