require 'abstract_unit'

class LogsSubscriptionTest < Minitest::Test
  def test_normal
    template = <<-EOS
_logs_subscription_filter "test", dest: "test", pattern: "test", role: "test"
    EOS
    act_template = run_client_as_json(template)
    exp_template = <<-EOS
{
  "TestLogsSubscriptionFilter": {
    "Type": "AWS::Logs::SubscriptionFilter",
    "Properties": {
      "DestinationArn": "test",
      "FilterPattern": "test",
      "LogGroupName": {
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
      "RoleArn": "test"
    }
  }
}
EOS
    assert_equal exp_template.chomp, act_template
  end
end
