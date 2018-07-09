require 'abstract_unit'

class LambdaEventSourceMappingTest < Minitest::Test
  def test_normal
    template = <<-EOS
_lambda_event_source_mapping "test", ref_function: "test", ref_event: "test", event_prefix: "test"

    EOS
    act_template = run_client_as_json(template)
    exp_template = <<-EOS
{
  "TestLambdaEventSourceMapping": {
    "Type": "AWS::Lambda::EventSourceMapping",
    "Properties": {
      "BatchSize": "100",
      "Enabled": "true",
      "EventSourceArn": {
        "Fn::GetAtt": [
          "TestTest",
          "Arn"
        ]
      },
      "FunctionName": {
        "Fn::GetAtt": [
          "TestLambdaFunction",
          "Arn"
        ]
      },
      "StartingPosition": "LATEST"
    }
  }
}
    EOS
    assert_equal exp_template.chomp, act_template
  end
end
