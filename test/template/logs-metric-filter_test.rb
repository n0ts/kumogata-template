require 'abstract_unit'

class LogsMetricFilterTest < Minitest::Test
  def test_normal
    template = <<-EOS
_logs_metric_filter "test", { pattern: "test", transformations: [ { name: "test", ns: "test", value: "test" }] }
    EOS
    act_template = run_client_as_json(template)
    exp_template = <<-EOS
{
  "TestLogsMetricFilter": {
    "Type": "AWS::Logs::MetricFilter",
    "Properties": {
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
      "MetricTransformations": [
        {
          "MetricName": "test",
          "MetricNamespace": "test",
          "MetricValue": "test"
        }
      ]
    }
  }
}
EOS
    assert_equal exp_template.chomp, act_template
  end
end
