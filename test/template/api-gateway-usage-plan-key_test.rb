require 'abstract_unit'

class ApiGatewayUsagePlanKeyTest < Minitest::Test
  def test_normal
    template = <<-EOS
_api_gateway_usage_plan_key "test", key: "test", ref_usage_plan: "test"
    EOS
    act_template = run_client_as_json(template)
    exp_template = <<-EOS
{
  "TestUsagePlanKey": {
    "Type": "AWS::ApiGateway::UsagePlanKey",
    "Properties": {
      "KeyId": "test",
      "KeyType": "API_KEY",
      "UsagePlanId": {
        "Ref": "TestUsagePlan"
      }
    }
  }
}
    EOS
    assert_equal exp_template.chomp, act_template
  end
end
