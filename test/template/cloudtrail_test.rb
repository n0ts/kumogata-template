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
    "Type": "AWS::CloudTrail::Trail",
    "Properties": {
      "EnableLogFileValidation": "false",
      "IncludeGlobalServiceEvents": "false",
      "IsLogging": "true",
      "IsMultiRegionTrail": "false",
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
      ],
      "TrailName": {
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
    "DependsOn": [
      "Test"
    ]
  }
}
    EOS
    assert_equal exp_template.chomp, act_template
  end
end
