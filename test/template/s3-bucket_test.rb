require 'abstract_unit'

class S3BucketTest < Minitest::Test
  def test_normal
    template = <<-EOS
_s3_bucket "test"
    EOS
    act_template = run_client_as_json(template)
    exp_template = <<-EOS
{
  "TestBucket": {
    "Type": "AWS::S3::Bucket",
    "Properties": {
      "AccessControl": "Private",
      "BucketName": {
        "Fn::Join": [
          "-",
          [
            {
              "Ref": "Service"
            },
            "test"
          ]
        ]
      },
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
    },
    "DeletionPolicy": "Retain"
  }
}
    EOS
    assert_equal exp_template.chomp, act_template
  end

  def test_aws_website
    template = <<-EOS
_s3_bucket "test", bucket: "bucket", website: { error: "error.html", index: "index.html", routing: [ routing: { http: "404", key_prefix: "out1/" }, redirect: { host: "ec2-11-22-333-44.compute-1.amazonaws.com", replace_key_prefix: "report-404/" } ] }
    EOS
    act_template = run_client_as_json(template)
    exp_template = <<-EOS
{
  "TestBucket": {
    "Type": "AWS::S3::Bucket",
    "Properties": {
      "AccessControl": "PublicRead",
      "BucketName": "bucket",
      "Tags": [
        {
          "Key": "Name",
          "Value": "bucket"
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
      "WebsiteConfiguration": {
        "ErrorDocument": "error.html",
        "IndexDocument": "index.html",
        "RoutingRules": [
          {
            "RedirectRule": {
              "HostName": "ec2-11-22-333-44.compute-1.amazonaws.com",
              "ReplaceKeyPrefixWith": "report-404/"
            },
            "RoutingRuleCondition": {
              "HttpErrorCodeReturnedEquals": "404",
              "KeyPrefixEquals": "out1/"
            }
          }
        ]
      }
    },
    "DeletionPolicy": "Retain"
  }
}
    EOS
    assert_equal exp_template.chomp, act_template
  end

  def test_bucket_name
    template = <<-EOS
_s3_bucket "test"
    EOS
    act_template = run_client_as_json(template)
    exp_template = <<-EOS
{
  "TestBucket": {
    "Type": "AWS::S3::Bucket",
    "Properties": {
      "AccessControl": "Private",
      "BucketName": {
        "Fn::Join": [
          "-",
          [
            {
              "Ref": "Service"
            },
            {
              "Ref": "Name"
            }
          ]
        ]
      },
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
    },
    "DeletionPolicy": "Retain"
  }
}
    EOS
    assert_equal exp_template.chomp, act_template
  end
end
