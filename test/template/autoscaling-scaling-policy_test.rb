require 'abstract_unit'

class AutoscalingScalingPolicyTest < Minitest::Test
  def test_normal
    template = <<-EOS
_autoscaling_scaling_policy "test", ref_autoscaling: "test"
    EOS
    act_template = run_client_as_json(template)
    exp_template = <<-EOS
{
  "TestAutoscalingScalingPolicy": {
    "Type": "AWS::AutoScaling::ScalingPolicy",
    "Properties": {
      "AdjustmentType": "ChangeInCapacity",
      "AutoScalingGroupName": {
        "Ref": "TestAutoscalingGroup"
      },
      "Cooldown": "60",
      "PolicyType": "SimpleScaling",
      "ScalingAdjustment": "1"
    }
  }
}
    EOS
    assert_equal exp_template.chomp, act_template
  end
end
