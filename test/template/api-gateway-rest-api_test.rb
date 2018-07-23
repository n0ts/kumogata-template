require 'abstract_unit'

class ApiGatewayRestApiTest < Minitest::Test
  def test_normal
    template = <<-EOS
_api_gateway_rest_api "test"
    EOS
    act_template = run_client_as_json(template)
    exp_template = <<-EOS
{
  "TestRestApi": {
    "Type": "AWS::ApiGateway::RestApi",
    "Properties": {
      "Description": "test rest api description",
      "FailOnWarnings": "true",
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
