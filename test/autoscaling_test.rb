require 'abstract_unit'
require 'kumogata/template/autoscaling'

class AutoscalingTest < Minitest::Test
  def test_autoscaling_metrics
    template = <<-EOS
Test _autoscaling_metrics
    EOS
    act_template = run_client_as_json(template)
    exp_template = <<-EOS
{
  "Test": {
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
}
    EOS
    assert_equal exp_template.chomp, act_template
  end

  def test_autoscaling_notification
    template = <<-EOS
Test _autoscaling_notification(topic_arn: "test")
    EOS
    act_template = run_client_as_json(template)
    exp_template = <<-EOS
{
  "Test": {
    "NotificationTypes": [
      "autoscaling:EC2_INSTANCE_LAUNCH",
      "autoscaling:EC2_INSTANCE_LAUNCH_ERROR",
      "autoscaling:EC2_INSTANCE_TERMINATE",
      "autoscaling:EC2_INSTANCE_TERMINATE_ERROR",
      "autoscaling:TEST_NOTIFICATION"
    ],
    "TopicARN": "test"
  }
}
    EOS
    assert_equal exp_template.chomp, act_template
  end

  def test_autoscaling_step
    template = <<-EOS
Test _autoscaling_step(scaling: 10, lower: 0, upper: 20)
    EOS
    act_template = run_client_as_json(template)
    exp_template = <<-EOS
{
  "Test": {
    "MetricIntervalLowerBound": "0",
    "MetricIntervalUpperBound": "20",
    "ScalingAdjustment": "10"
  }
}
    EOS
    assert_equal exp_template.chomp, act_template
  end

  def test_autoscaling_tags
    template = <<-EOS
Test _autoscaling_tags(name: "test")
    EOS
    act_template = run_client_as_json(template)
    exp_template = <<-EOS
{
  "Test": [
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
    EOS
    assert_equal exp_template.chomp, act_template
  end
end
