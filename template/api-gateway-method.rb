#
# Api Gateway Method
# http://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/aws-resource-apigateway-method.html
#
require 'kumogata/template/helper'
require 'kumogata/template/api-gateway'

proxy = _bool("proxy", args, false)
args[:parameters] = [] unless args.key? :parameters
args[:parameters] << { type: "method", location: "path", name: "proxy", value: true } if proxy

cognito = _bool("cognito", args, false)
if cognito
  args[:integration] = {} unless args.key? :integration
  args[:integration][:parameters] = [] unless args[:integration][:parameters]
  _api_gateway_to_parameter_headers("aws").collect{|v| args[:integration][:parameters] << v }
  _api_gateway_to_parameter_headers("cognito").collect{|v| args[:integration][:parameters] << v }
end

cors = _bool("cors", args, false)
if cors
  args[:http] = "options"
  args[:responses] = [] unless args.key? :responses
  responses_parameters = {}
  _api_gateway_to_parameter_response_headers().keys().collect{|v| responses_parameters[v] = false }
  args[:responses] << { parameters: responses_parameters, models: { "application/json": "Empty" } }

  args[:integration] = {} unless args.key? :integration
  args[:integration][:type] = "mock"
  args[:integration][:pass] = "when_no_match"
  args[:integration][:templates] = {} unless args[:integration].key? :templates
  args[:integration][:templates]["application/json"] = '{"statusCode": 200}'
  args[:integration][:responses] = [] unless args[:integration].key? :responses
  args[:integration][:responses] << {
    parameter: _api_gateway_to_parameter_response_headers({ allow_headers: args[:allow_headers] || [] }),
    template: { "application/json": "" }
  }
end

name = _resource_name(args[:name], "method")
required = _bool("required", args, false)
auth_type = _valid_values(args[:auth_type], %w( none custom aws_iam iam ), "none")
auth_type = "aws_iam" if auth_type == "iam"
auth_id = _ref_string_default("auth", args, "authorizer")
http = _valid_values(args[:http], %w( delete get head options patch post put any ), "any")
integration = _api_gateway_integration(args)
responses = _api_gateway_responses(args)
# RequestModels
# - key: The content type
# - value: A Model resource name
models = args[:models] || {}
parameters = {}
args[:parameters].collect{|v| parameters[_api_gateway_to_parameter(v)] = v[:value] }
resource = _ref_string("resource", args, "resource")
rest = _ref_string("rest", args, "rest api")

_(name) do
  Type "AWS::ApiGateway::Method"
  Properties do
    ApiKeyRequired required
    AuthorizationType auth_type.upcase
    AuthorizerId auth_id if auth_type == "custom"
    HttpMethod http.upcase
    Integration integration unless integration.empty?
    MethodResponses responses unless responses.empty?
    RequestModels models unless models.empty?
    RequestParameters parameters unless parameters.empty?
    ResourceId resource
    RestApiId rest
  end
end
