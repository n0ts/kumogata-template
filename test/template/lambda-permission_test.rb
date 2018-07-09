require 'abstract_unit'

class LambdaPermissionTest < Minitest::Test
  def test_normal
    template = <<-EOS
_lambda_permission "test", principal: 'sns', ref_function: "test", ref_source_arn: "test"

    EOS
    act_template = run_client_as_json(template)
    exp_template = <<-EOS
{
  "TestLambdaPermission": {
    "Type": "AWS::Lambda::Permission",
    "Properties": {
      "Action": "lambda:InvokeFunction",
      "FunctionName": {
        "Fn::GetAtt": [
          "TestLambdaFunction",
          "Arn"
        ]
      },
      "Principal": "sns.#{DOMAIN}",
      "SourceArn": {
        "Ref": "TestTopic"
      }
    },
    "DependsOn": [
      "TestLambdaFunction"
    ]
  }
}
    EOS
    assert_equal exp_template.chomp, act_template
  end
end
