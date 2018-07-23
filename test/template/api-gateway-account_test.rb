require 'abstract_unit'

class ApiGatewayAccountTest < Minitest::Test
  def test_normal
    template = <<-EOS
_api_gateway_account "test", ref_cloudwatch: "test"
    EOS
    act_template = run_client_as_json(template)
    exp_template = <<-EOS
{
  "TestAccount": {
    "Type": "AWS::ApiGateway::Account",
    "Properties": {
      "CloudWatchRoleArn": {
        "Fn::GetAtt": [
          "TestRole",
          "Arn"
        ]
      }
    }
  }
}
    EOS
    assert_equal exp_template.chomp, act_template
  end
end
