require 'abstract_unit'

class SqsQueueTest < Minitest::Test
  def test_normal
    template = <<-EOS
_sqs_queue "test", queue: "test"
    EOS
    act_template = run_client_as_json(template)
    exp_template = <<-EOS
{
  "TestQueue": {
    "Type": "AWS::SQS::Queue",
    "Properties": {
      "DelaySeconds": "0",
      "MaximumMessageSize": "262144",
      "MessageRetentionPeriod": "345600",
      "QueueName": "test",
      "VisibilityTimeout": "30"
    }
  }
}
    EOS
    assert_equal exp_template.chomp, act_template
  end
end
