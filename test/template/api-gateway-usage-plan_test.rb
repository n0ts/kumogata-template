require 'abstract_unit'

class ApiGatewayUsagePlanTest < Minitest::Test
  def test_normal
    template = <<-EOS
_api_gateway_usage_plan "test", stages: [ { ref_rest: "test", ref_stage: "test" } ]
    EOS
    act_template = run_client_as_json(template)
    exp_template = <<-EOS
{
  "TestUsagePlan": {
    "Type": "AWS::ApiGateway::UsagePlan",
    "Properties": {
      "ApiStages": [
        {
          "ApiId": {
            "Ref": "TestRestApi"
          },
          "Stage": {
            "Ref": "TestStage"
          }
        }
      ],
      "Description": "test usage plan description",
      "UsagePlanName": {
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
