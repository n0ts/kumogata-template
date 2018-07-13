require 'abstract_unit'

class LogsLogGroupTest < Minitest::Test
  def test_normal
    template = <<-EOS
_logs_log_group "test"
    EOS
    act_template = run_client_as_json(template)
    exp_template = <<-EOS
{
  "TestLogsLogGroup": {
    "Type": "AWS::Logs::LogGroup",
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
      "RetentionInDays": "365"
    }
  }
}
EOS
    assert_equal exp_template.chomp, act_template
  end
end
