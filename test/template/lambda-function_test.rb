require 'abstract_unit'

class LambdaFunctionTest < Minitest::Test
  def test_normal
    template = <<-EOS
_lambda_function "test", code: { s3_bucket: "test", s3_key: "test" }, handler: "test", ref_role: "test", runtime: "nodejs4.3"
    EOS
    act_template = run_client_as_json(template)
    exp_template = <<-EOS
{
  "TestLambdaFunction": {
    "Type": "AWS::Lambda::Function",
    "Properties": {
      "Code": {
        "S3Bucket": "test",
        "S3Key": "test"
      },
      "Handler": "test",
      "MemorySize": "128",
      "Role": {
        "Fn::GetAtt": [
          "TestRole",
          "Arn"
        ]
      },
      "Runtime": "nodejs4.3",
      "Timeout": "3"
    }
  }
}
    EOS
    assert_equal exp_template.chomp, act_template

    template = <<-EOS
_lambda_function "test", code: { zip_file: "test/data/lambda_function.py" }, handler: "test", ref_role: "test", runtime: "python2.7"
    EOS
    act_template = run_client_as_json(template)
    exp_template = <<-EOS
{
  "TestLambdaFunction": {
    "Type": "AWS::Lambda::Function",
    "Properties": {
      "Code": {
        "ZipFile": {
          "Fn::Join": [
            "\\\\n",
            [
              "import boto3",
              "",
              "def lambda_handler(event, context):",
              "    print('hello lambda')"
            ]
          ]
        }
      },
      "Handler": "test",
      "MemorySize": "128",
      "Role": {
        "Fn::GetAtt": [
          "TestRole",
          "Arn"
        ]
      },
      "Runtime": "python2.7",
      "Timeout": "3"
    }
  }
}
    EOS
    assert_equal exp_template.chomp, act_template
  end
end
