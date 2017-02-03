require 'abstract_unit'
require 'kumogata/template/logs'

class LogsTest < Minitest::Test
  def test_logs_metric_filter_transformations
    template = <<-EOS
Test _logs_metric_filter_transformations(transformations: [ { name: "test", ns: "test", value: "test" } ])
    EOS
    act_template = run_client_as_json(template)
    exp_template = <<-EOS
{
  "Test": [
    {
      "MetricName": "test",
      "MetricNamespace": "test",
      "MetricValue": "test"
    }
  ]
}
    EOS
    assert_equal exp_template.chomp, act_template
  end
end
