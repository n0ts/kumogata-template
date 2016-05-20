require 'abstract_unit'

class AutoscalingLifecycleHookTest < Minitest::Test
  def test_normal
    template = <<-EOS
_autoscaling_lifecycle_hook "test", ref_autoscaling: "test", ref_topic: "test", ref_role: "test"
    EOS
    act_template = run_client_as_json(template)
    exp_template = <<-EOS
{
  "TestAutoscalingLifecycleHook": {
    "Type": "AWS::AutoScaling::LifecycleHook",
    "Properties": {
      "AutoScalingGroupName": {
        "Ref": "TestAutoscalingGroup"
      },
      "LifecycleTransition": "autoscaling::EC2_INSTANCE_TERMINATING",
      "NotificationTargetARN": {
        "Ref": "TestTopic"
      },
      "RoleARN": {
        "Fn::GetAtt": [
          "TestRole",
          "Arn"
        ]
      }
    }
  }
}
    EOS
    assert_equal exp_template.chomp, act_template
  end
end
