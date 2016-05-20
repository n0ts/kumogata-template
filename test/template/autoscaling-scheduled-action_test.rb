require 'abstract_unit'

class AutoscalingScheduledActionTest < Minitest::Test
  def test_normal
    template = <<-EOS
_autoscaling_scheduled_action "test", ref_autoscaling: "test", max: "1", min: "1", recurrence: "0 19 * * *"
    EOS
    act_template = run_client_as_json(template)
    exp_template = <<-EOS
{
  "TestAutoscalingScheduledAction": {
    "Type": "AWS::AutoScaling::ScheduledAction",
    "Properties": {
      "AutoScalingGroupName": {
        "Ref": "TestAutoscalingGroup"
      },
      "MaxSize": "1",
      "MinSize": "1",
      "Recurrence": "0 19 * * *"
    }
  }
}
    EOS
    assert_equal exp_template.chomp, act_template
  end
end
