require 'abstract_unit'

class LambdaVersionTest < Minitest::Test
  def test_normal
    template = <<-EOS
_lambda_version "test", ref_function: "test", ref_source_arn: "test"

    EOS
    act_template = run_client_as_json(template)
    exp_template = <<-EOS
{
  "TestLambdaVersion": {
    "Type": "AWS::Lambda::Version",
    "Properties": {
      "FunctionName": {
        "Fn::GetAtt": [
          "TestLambdaFunction",
          "Arn"
        ]
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
