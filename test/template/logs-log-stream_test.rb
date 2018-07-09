require 'abstract_unit'

class LogsLogStreamTest < Minitest::Test
  def test_normal
    template = <<-EOS
_logs_log_stream "test"
    EOS
    act_template = run_client_as_json(template)
    exp_template = <<-EOS
{
  "TestLogsLogStream": {
    "Type": "AWS::Logs::LogStream",
    "Properties": {
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
      "LogStreamName": {
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
