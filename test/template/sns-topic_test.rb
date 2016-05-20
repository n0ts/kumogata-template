require 'abstract_unit'

class SnsTopicTest < Minitest::Test
  def test_normal
    template = <<-EOS
_sns_topic "test", display: "test", subscription: [ { protocol: "sqs", endpoint: "test" }, { protocol: "lambda", endpoint: "test" } ], topic: "test"
    EOS
    act_template = run_client_as_json(template)
    exp_template = <<-EOS
{
  "TestTopic": {
    "Type": "AWS::SNS::Topic",
    "Properties": {
      "DisplayName": "test",
      "Subscription": [
        {
          "Endpoint": {
            "Fn::GetAtt": [
              "Test",
              "Arn"
            ]
          },
          "Protocol": "sqs"
        },
        {
          "Endpoint": {
            "Fn::GetAtt": [
              "Test",
              "Arn"
            ]
          },
          "Protocol": "lambda"
        }
      ],
      "TopicName": "test"
    }
  }
}
    EOS
    assert_equal exp_template.chomp, act_template
  end
end
