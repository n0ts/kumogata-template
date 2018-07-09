require 'abstract_unit'

class ApiGatewayMethodTest < Minitest::Test
  def test_normal
    template = <<-EOS
_api_gateway_method "test", ref_resource: "test", ref_rest: "test"
    EOS
    act_template = run_client_as_json(template)
    exp_template = <<-EOS
{
  "TestMethod": {
    "Type": "AWS::ApiGateway::Method",
    "Properties": {
      "ApiKeyRequired": "false",
      "AuthorizationType": "NONE",
      "HttpMethod": "ANY",
      "ResourceId": {
        "Ref": "TestResource"
      },
      "RestApiId": {
        "Ref": "TestRestApi"
      }
    }
  }
}
    EOS
    assert_equal exp_template.chomp, act_template
  end
end
