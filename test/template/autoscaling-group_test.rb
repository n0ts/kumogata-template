require 'abstract_unit'

class AutoscalingGroupTest < Minitest::Test
  def test_normal
    template = <<-EOS
_autoscaling_group "test", ref_launch: "test", ref_vpc_zones: %w( test ), notifications: [ ref_topic_arn: "test" ]
    EOS
    act_template = run_client_as_json(template)
    exp_template = <<-EOS
{
  "TestAutoscalingGroup": {
    "Type": "AWS::AutoScaling::AutoScalingGroup",
    "Properties": {
      "HealthCheckType": "EC2",
      "LaunchConfigurationName": {
        "Ref": "TestAutoscalingLaunchConfiguration"
      },
      "MaxSize": "1",
      "MetricsCollection": [
        {
          "Granularity": "1Minute",
          "Metrics": [
            "GroupMinSize",
            "GroupMaxSize",
            "GroupDesiredCapacity",
            "GroupInServiceInstances",
            "GroupPendingInstances",
            "GroupStandbyInstances",
            "GroupTerminatingInstances",
            "GroupTotalInstances"
          ]
        }
      ],
      "MinSize": "0",
      "NotificationConfigurations": [
        {
          "NotificationTypes": [
            "autoscaling:EC2_INSTANCE_LAUNCH",
            "autoscaling:EC2_INSTANCE_LAUNCH_ERROR",
            "autoscaling:EC2_INSTANCE_TERMINATE",
            "autoscaling:EC2_INSTANCE_TERMINATE_ERROR",
            "autoscaling:TEST_NOTIFICATION"
          ],
          "TopicARN": {
            "Ref": "Test"
          }
        }
      ],
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
          },
          "PropagateAtLaunch": "true"
        },
        {
          "Key": "Service",
          "Value": {
            "Ref": "Service"
          },
          "PropagateAtLaunch": "true"
        },
        {
          "Key": "Version",
          "Value": {
            "Ref": "Version"
          },
          "PropagateAtLaunch": "true"
        }
      ],
      "VPCZoneIdentifier": [
        {
          "Ref": "TestSubnet"
        }
      ]
    }
  }
}
    EOS
    assert_equal exp_template.chomp, act_template
  end

  def test_aws
    template = <<-EOS
_autoscaling_group "test", ref_launch: "test", ref_azs: %w( test ), notifications: [ topic: "test" ], max: 2, min: 2
    EOS
    act_template = run_client_as_json(template)
    exp_template = <<-EOS
{
  "TestAutoscalingGroup": {
    "Type": "AWS::AutoScaling::AutoScalingGroup",
    "Properties": {
      "AvailabilityZones": [
        {
          "Ref": "TestZone"
        }
      ],
      "HealthCheckType": "EC2",
      "LaunchConfigurationName": {
        "Ref": "TestAutoscalingLaunchConfiguration"
      },
      "MaxSize": "2",
      "MetricsCollection": [
        {
          "Granularity": "1Minute",
          "Metrics": [
            "GroupMinSize",
            "GroupMaxSize",
            "GroupDesiredCapacity",
            "GroupInServiceInstances",
            "GroupPendingInstances",
            "GroupStandbyInstances",
            "GroupTerminatingInstances",
            "GroupTotalInstances"
          ]
        }
      ],
      "MinSize": "2",
      "NotificationConfigurations": [
        {
          "NotificationTypes": [
            "autoscaling:EC2_INSTANCE_LAUNCH",
            "autoscaling:EC2_INSTANCE_LAUNCH_ERROR",
            "autoscaling:EC2_INSTANCE_TERMINATE",
            "autoscaling:EC2_INSTANCE_TERMINATE_ERROR",
            "autoscaling:TEST_NOTIFICATION"
          ],
          "TopicARN": "test"
        }
      ],
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
          },
          "PropagateAtLaunch": "true"
        },
        {
          "Key": "Service",
          "Value": {
            "Ref": "Service"
          },
          "PropagateAtLaunch": "true"
        },
        {
          "Key": "Version",
          "Value": {
            "Ref": "Version"
          },
          "PropagateAtLaunch": "true"
        }
      ]
    }
  }
}
    EOS
    assert_equal exp_template.chomp, act_template
  end
end
