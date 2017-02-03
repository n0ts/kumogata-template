require 'abstract_unit'

class LogsDestinationTest < Minitest::Test
  def test_normal
    template = <<-EOS
_logs_destination "test", { dest: "test", policy: [ { service: "s3" } ], role: "test", target: { account_id: "test", region: "test", name: "test" } }
    EOS
    act_template = run_client_as_json(template)
    exp_template = <<-EOS
{
  "TestLogsDestination": {
    "Type": "AWS::Logs::Destination",
    "Properties": {
      "DestinationName": "test",
      "DestinationPolicy": {
        "Version": "2012-10-17",
        "Statement": [
          {
            "Effect": "Allow",
            "Action": [
              "s3:*"
            ],
            "Resource": [
              "*"
            ]
          }
        ]
      },
      "RoleArn": "test",
      "TargetArn": "arn:aws:kinesis:test:test:stream/test"
    }
  }
}
EOS
    assert_equal exp_template.chomp, act_template
  end
end
