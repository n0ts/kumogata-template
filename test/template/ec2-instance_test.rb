require 'abstract_unit'

class Ec2InstanceTest < Minitest::Test
  def test_normal
    template = <<-EOS
_ec2_instance "test", key_name: "test", ref_instance_type: "test", ref_iam_instance: "test", user_data: "test data"
    EOS
    act_template = run_client_as_json(template)
    exp_template = <<-EOS
{
  "TestInstance": {
    "Type": "AWS::EC2::Instance",
    "Properties": {
      "BlockDeviceMappings": [

      ],
      "DisableApiTermination": "false",
      "IamInstanceProfile": {
        "Ref": "TestIamInstanceProfile"
      },
      "ImageId": {
        "Fn::FindInMap": [
          "AWSRegionArch2AMIAmazonLinuxOfficial",
          {
            "Ref": "AWS::Region"
          },
          {
            "Fn::FindInMap": [
              "AWSInstanceType2Arch",
              {
                "Ref": "TestInstanceType"
              },
              "Arch"
            ]
          }
        ]
      },
      "InstanceInitiatedShutdownBehavior": "stop",
      "InstanceType": {
        "Ref": "TestInstanceType"
      },
      "KeyName": "test",
      "Monitoring": "true",
      "SourceDestCheck": "true",
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
        },
        {
          "Key": "Domain",
          "Value": {
            "Ref": "Domain"
          }
        },
        {
          "Key": "Role",
          "Value": {
            "Ref": "Role"
          }
        }
      ],
      "Tenancy": "default",
      "UserData": {
        "Fn::Base64": "#!/bin/bash\\ntest data\\n"
      }
    }
  }
}
    EOS
    assert_equal exp_template.chomp, act_template
  end
end
