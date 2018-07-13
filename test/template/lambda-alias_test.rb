require 'abstract_unit'

class LambdaAliasTest < Minitest::Test
  def test_normal
    template = <<-EOS
_lambda_alias "test", ref_function_name: "test", ref_function_version: "test"

    EOS
    act_template = run_client_as_json(template)
    exp_template = <<-EOS
{
  "TestLambdaAlias": {
    "Type": "AWS::Lambda::Alias",
    "Properties": {
      "Description": "test lambda alias description",
      "FunctionName": {
        "Fn::GetAtt": [
          "TestLambdaFunction",
          "Arn"
        ]
      },
      "FunctionVersion": {
        "Fn::GetAtt": [
          "TestLambdaVersion",
          "Version"
        ]
      },
      "Name": {
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
