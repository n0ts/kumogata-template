require 'abstract_unit'

class CloudWatchAlarmTest < Minitest::Test
  def test_normal
    template = <<-EOS
_cloudwatch_alarm "test", actions: [ "test" ], alarm_name: "test", namespace: "ec2", operator: "<", metric: "test", dimensions: [ { name: "test", value: "test" } ]
    EOS
    act_template = run_client_as_json(template)
    exp_template = <<-EOS
{
  "TestAlarm": {
    "Type": "AWS::CloudWatch::Alarm",
    "Properties": {
      "ActionsEnabled": "true",
      "AlarmActions": [
        "test"
      ],
      "AlarmDescription": "test alarm description",
      "AlarmName": {
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
      "ComparisonOperator": "LessThanThreshold",
      "Dimensions": [
        {
          "Name": "test",
          "Value": "test"
        }
      ],
      "EvaluationPeriods": "3",
      "MetricName": "test",
      "Namespace": "AWS/EC2",
      "Period": "300",
      "Statistic": "Average",
      "Threshold": "60",
      "TreatMissingData": "missing"
    }
  }
}
    EOS
    assert_equal exp_template.chomp, act_template
  end
end
