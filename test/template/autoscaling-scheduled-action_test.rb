require 'abstract_unit'

class AutoscalingScheduledActionTest < Minitest::Test
  def test_normal
    template = <<-EOS
_autoscaling_scheduled_action "test", ref_autoscaling: "test", max: "1", min: "1", recurrence: Time.local(2016, 3, 31, 15)
    EOS
    act_template = run_client_as_json(template)
    start_time = _timestamp_utc(Time.now + 3600)
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
      "Recurrence": "00 06 31 03 4",
      "StartTime": "#{start_time}"
    }
  }
}
    EOS
    assert_equal exp_template.chomp, act_template
  end
end
