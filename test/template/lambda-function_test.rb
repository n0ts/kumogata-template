require 'abstract_unit'

class LambdaFunctionTest < Minitest::Test
  def test_normal
    template = <<-EOS
_lambda_function "test", code: { s3_bucket: "test", s3_key: "test" }, function: "test", ref_role: "test"
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
      "Description": "test lambda function description",
      "FunctionName": "test",
      "Handler": "test.handler",
      "MemorySize": "128",
      "Role": {
        "Fn::GetAtt": [
          "TestRole",
          "Arn"
        ]
      },
      "Runtime": "nodejs",
      "Timeout": "3",
      "Tags": [
        {
          "Key": "Name",
          "Value": "test"
        },
        {
          "Key": "Service",
          "Value": {
            "Ref": "Service"
          }
        },
        {
          "Key": "Version",
          "Value": {
            "Ref": "Version"
          }
        }
      ]
    }
  }
}
    EOS
    assert_equal exp_template.chomp, act_template

    template = <<-EOS
_lambda_function "test", code: { zip_file: "test/data/lambda_function.py" }, function: "test", ref_role: "test", runtime: "python2.7"
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
      "Description": "test lambda function description",
      "FunctionName": "test",
      "Handler": "test.lambda_handler",
      "MemorySize": "128",
      "Role": {
        "Fn::GetAtt": [
          "TestRole",
          "Arn"
        ]
      },
      "Runtime": "python2.7",
      "Timeout": "3",
      "Tags": [
        {
          "Key": "Name",
          "Value": "test"
        },
        {
          "Key": "Service",
          "Value": {
            "Ref": "Service"
          }
        },
        {
          "Key": "Version",
          "Value": {
            "Ref": "Version"
          }
        }
      ]
    }
  }
}
    EOS
    assert_equal exp_template.chomp, act_template
  end
end
