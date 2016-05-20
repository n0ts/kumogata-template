require 'abstract_unit'

class LambdaPermissionTest < Minitest::Test
  def test_normal
    template = <<-EOS
_lambda_permission "test", action: "test", ref_function_name: "test", ref_source_arn: "test"

    EOS
    act_template = run_client_as_json(template)
    exp_template = <<-EOS
{
  "TestLambdaPermission": {
    "Type": "AWS::Lambda::Permission",
    "Properties": {
      "Action": "test",
      "FunctionName": {
        "Fn::GetAtt": [
          "TestLambdaFunction",
          "Arn"
        ]
      },
      "Principal": "sns.amazonaws.com",
      "SourceArn": {
        "Ref": "TestTopic"
      }
    }
  }
}
    EOS
    assert_equal exp_template.chomp, act_template
  end
end
