require 'abstract_unit'

class ApiGatewayApiKeyTest < Minitest::Test
  def test_normal
    template = <<-EOS
_api_gateway_api_key "test"
    EOS
    act_template = run_client_as_json(template)
    exp_template = <<-EOS
{
  "TestApiKey": {
    "Type": "AWS::ApiGateway::ApiKey",
    "Properties": {
      "Description": "test api key description",
      "Enabled": "true",
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
      }
    }
  }
}
    EOS
    assert_equal exp_template.chomp, act_template
  end
end
