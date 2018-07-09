require 'abstract_unit'

class ApiGatewayAuthorizerTest < Minitest::Test
  def test_normal
    template = <<-EOS
_api_gateway_authorizer "test", ref_rest: "test", ref_role: "test", ref_uri: "test"
    EOS
    act_template = run_client_as_json(template)
    exp_template = <<-EOS
{
  "TestAuthorizer": {
    "Type": "AWS::ApiGateway::Authorizer",
    "Properties": {
      "AuthorizerCredentials": {
        "Fn::GetAtt": [
          "TestRole",
          "Arn"
        ]
      },
      "AuthorizerResultTtlInSeconds": "300",
      "AuthorizerUri": {
        "Fn::Join": [
          "",
          [
            "arn:aws:apigateway:",
            {
              "Ref": "AWS::Region"
            },
            ":lambda:path/2015-03-31/functions/",
            {
              "Fn::GetAtt": [
                "TestLambdaFunction",
                "Arn"
              ]
            },
            "/invocations"
          ]
        ]
      },
      "IdentitySource": "method.request.header.Auth",
      "Name": {
        "Fn::Join": [
          "-",
          [
            {
              "Ref": "Service"
            },
            "test"
          ]
        ]
      },
      "RestApiId": {
        "Ref": "TestRestApi"
      },
      "Type": "TOKEN"
    }
  }
}
    EOS
    assert_equal exp_template.chomp, act_template
  end
end
