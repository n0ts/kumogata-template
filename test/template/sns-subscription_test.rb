require 'abstract_unit'

class SnsSubscriptionTest < Minitest::Test
  def test_normal
    template = <<-EOS
_sns_subscription "test", { protocol: "lambda", endpoint: "test", topic: "test" }
    EOS
    act_template = run_client_as_json(template)
    exp_template = <<-EOS
{
  "TestSnsSubscription": {
    "Type": "AWS::SNS::Subscription",
    "Properties": {
      "Endpoint": {
        "Fn::GetAtt": [
          "Test",
          "Arn"
        ]
      },
      "Protocol": "lambda",
      "TopicArn": "test"
    }
  }
}
    EOS
    assert_equal exp_template.chomp, act_template
  end
end
