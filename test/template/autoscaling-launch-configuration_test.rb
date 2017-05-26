require 'abstract_unit'

class AutoscalingLaunchConfigurationTest < Minitest::Test
  def test_normal
    template = <<-EOS
_autoscaling_launch_configuration "test", image: "test", ref_instance_type: "test", key_name: "test", instance_monitoring: false
    EOS
    act_template = run_client_as_json(template)
    exp_template = <<-EOS
{
  "TestAutoscalingLaunchConfiguration": {
    "Type": "AWS::AutoScaling::LaunchConfiguration",
    "Properties": {
      "AssociatePublicIpAddress": "false",
      "ImageId": {
        "Fn::FindInMap": [
          "AWSRegionArch2AMITest",
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
      "InstanceMonitoring": "false",
      "InstanceType": {
        "Ref": "TestInstanceType"
      },
      "KeyName": "test"
    }
  }
}
    EOS
    assert_equal exp_template.chomp, act_template
  end

  def test_aws
    template = <<-EOS
_autoscaling_launch_configuration "test", ref_key_name: "test", ref_security_groups: %w( test ), ref_instance_type: "test", block_device: [ { device: "/dev/sda1", size: 50, type: "io1", iops: 200 }, { device: "/dev/sdm", size: 100, delete: true } ], ref_user_data: "web server port"
    EOS
    act_template = run_client_as_json(template)
    exp_template = <<-EOS
{
  "TestAutoscalingLaunchConfiguration": {
    "Type": "AWS::AutoScaling::LaunchConfiguration",
    "Properties": {
      "AssociatePublicIpAddress": "false",
      "BlockDeviceMappings": [
        {
          "DeviceName": "/dev/sda1",
          "Ebs": {
            "DeleteOnTermination": "true",
            "Iops": "200",
            "VolumeSize": "50",
            "VolumeType": "io1"
          }
        },
        {
          "DeviceName": "/dev/sdm",
          "Ebs": {
            "DeleteOnTermination": "true",
            "VolumeSize": "100",
            "VolumeType": "gp2"
          }
        }
      ],
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
      "InstanceMonitoring": "true",
      "InstanceType": {
        "Ref": "TestInstanceType"
      },
      "KeyName": {
        "Ref": "TestKeyName"
      },
      "SecurityGroups": [
        {
          "Ref": "TestSecurityGroup"
        }
      ],
      "UserData": {
        "Fn::Base64": {
          "Ref": "WebServerPortUserData"
        }
      }
    }
  }
}
    EOS
    assert_equal exp_template.chomp, act_template
  end
end
