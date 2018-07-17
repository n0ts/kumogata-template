require 'abstract_unit'
require 'kumogata/template/lambda'

class LambdaTest < Minitest::Test
  def test_lambda_function_code
    template = <<-EOS
Test _lambda_function_code(code: { s3_bucket: "test", s3_key: "test" })
    EOS
    act_template = run_client_as_json(template)
    exp_template = <<-EOS
{
  "Test": {
    "S3Bucket": "test",
    "S3Key": "test"
  }
}
    EOS
    assert_equal exp_template.chomp, act_template

      template = <<-EOS
Test _lambda_function_code(code: { zip_file: "test/data/lambda_function.py" })
    EOS
    act_template = run_client_as_json(template)
    exp_template = <<-EOS
{
  "Test": {
    "ZipFile": {
      "Fn::Join": [
        "\\n",
        [
          "import boto3",
          "",
          "def lambda_handler(event, context):",
          "    print('hello lambda')"
        ]
      ]
    }
  }
}
    EOS
    assert_equal exp_template.chomp, act_template
  end

  def test_lambda_vpc_config
    template = <<-EOS
Test _lambda_vpc_config(vpc: { security_groups: [ "test" ], subnets: [ "test" ] })
    EOS
    act_template = run_client_as_json(template)
    exp_template = <<-EOS
{
  "Test": {
    "SecurityGroupIds": [
      "test"
    ],
    "SubnetIds": [
      "test"
    ]
  }
}
    EOS
    assert_equal exp_template.chomp, act_template
  end
end
