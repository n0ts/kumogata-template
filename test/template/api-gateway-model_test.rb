require 'abstract_unit'

class ApiGatewayModelTest < Minitest::Test
  def test_normal
    template = <<-EOS
_api_gateway_model "test", ref_rest: "test"
    EOS
    act_template = run_client_as_json(template)
    exp_template = <<-EOS
{
  "TestModel": {
    "Type": "AWS::ApiGateway::Model",
    "Properties": {
      "ContentType": "application/json",
      "Description": "test model description",
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
      "Schema": ""
    }
  }
}
    EOS
    assert_equal exp_template.chomp, act_template
  end
end
