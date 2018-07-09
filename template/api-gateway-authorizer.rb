#
# Api Gateway Authorizer resource
# http://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/aws-resource-apigateway-authorizer.html
#
require 'kumogata/template/helper'

name = _resource_name(args[:name], "authorizer")
role = _ref_attr_string("role", "Arn", args, "role")
result_ttl = _ref_string_default("result_ttl", args, "", 300)
type = _valid_values(args[:type], %w( token cognito_user_pools ), "token")
uri =
  if type == "token"
    _join([ "arn:aws:apigateway:", _region(),
            ":lambda:path/2015-03-31/functions/",
            _ref_attr_string("uri", "Arn", args, "lambda function"), "/invocations" ], "")
  else
    ""
  end
source = _ref_string_default("source", args, "", "method.request.header.Auth")
validation = _ref_string_default("validation", args)
authorizer_name = _name("authorizer", args)
providers = _ref_array("providers", args, "user pool")
rest = _ref_string("rest", args, "rest api")

_(name) do
  Type "AWS::ApiGateway::Authorizer"
  Properties do
    AuthorizerCredentials role unless role.empty?
    AuthorizerResultTtlInSeconds result_ttl
    AuthorizerUri uri if type == "token"
    IdentitySource source if type == "token"
    IdentityValidationExpression validation unless validation.empty?
    Name authorizer_name
    ProviderARNs providers unless providers.empty?
    RestApiId rest
    Type type.upcase
  end
end
