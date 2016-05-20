require 'abstract_unit'

class CloudtrailTest < Minitest::Test
  def test_normal
    template = <<-EOS
_cloudtrail "test", depends: %w( test ), s3_bucket: "test"
    EOS
    act_template = run_client_as_json(template)
    exp_template = <<-EOS
{
  "TestTrail": {
    "DependsOn": [
      "test"
    ],
    "Type": "AWS::CloudTrail::Trail",
    "Properties": {
      "EnableLogFileValidation": "false",
      "IncludeGlobalServiceEvents": "false",
      "IsLogging": "true",
      "S3BucketName": "test",
      "Tags": [
        {
          "Key": "Name",
          "Value": {
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
