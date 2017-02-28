require 'abstract_unit'
require 'kumogata/template/cloudwatch'

class CloudWatchTest < Minitest::Test
  def test_cloudwatch_to_period
    template = <<-EOS
Test _cloudwatch_to_period("1m")
    EOS
    act_template = run_client_as_json(template)
    exp_template = <<-EOS
{
  "Test": "60"
}
    EOS
    assert_equal exp_template.chomp, act_template
  end

  def test_cloudwatch_to_statistic
    template = <<-EOS
Test _cloudwatch_to_statistic("avg")
    EOS
    act_template = run_client_as_json(template)
    exp_template = <<-EOS
{
  "Test": "Average"
}
    EOS
    assert_equal exp_template.chomp, act_template
  end

  def test_cloudwatch_to_metric
    template = <<-EOS
Test _cloudwatch_to_metric("ec2 cpu utilization")
    EOS
    act_template = run_client_as_json(template)
    exp_template = <<-EOS
{
  "Test": "CPUUtilization"
}
    EOS
    assert_equal exp_template.chomp, act_template
  end

  def test_cloudwatch_to_namespace
    template = <<-EOS
Test _cloudwatch_to_namespace("ec2")
    EOS
    act_template = run_client_as_json(template)
    exp_template = <<-EOS
{
  "Test": "AWS/EC2"
}
    EOS
    assert_equal exp_template.chomp, act_template
  end

  def test_cloudwatch_to_operator
    template = <<-EOS
Test _cloudwatch_to_operator(">=")
    EOS
    act_template = run_client_as_json(template)
    exp_template = <<-EOS
{
  "Test": "GreaterThanOrEqualToThreshold"
}
    EOS
    assert_equal exp_template.chomp, act_template
  end

  def test_cloudwatch_to_unit
    template = <<-EOS
Test _cloudwatch_to_unit("sec")
    EOS
    act_template = run_client_as_json(template)
    exp_template = <<-EOS
{
  "Test": "Seconds"
}
    EOS
    assert_equal exp_template.chomp, act_template
  end

  def test_cloudwatch_to_ec2_action
    template = <<-EOS
Test _cloudwatch_to_ec2_action("revoert")
    EOS
    act_template = run_client_as_json(template)
    exp_template = <<-EOS
{
  "Test": {
    "Fn::Join": [
      "",
      [
        "arn:aws:automate:",
        {
          "Ref": "AWS::Region"
        },
        ":ec2:recover"
      ]
    ]
  }
}
    EOS
    assert_equal exp_template.chomp, act_template
  end

  def test_cloudwatch_dimension
    template = <<-EOS
Test _cloudwatch_dimension({ name: "test", value: "test" })
    EOS
    act_template = run_client_as_json(template)
    exp_template = <<-EOS
{
  "Test": {
    "Name": "test",
    "Value": "test"
  }
}
    EOS
    assert_equal exp_template.chomp, act_template
  end

  def test_cloudwatch_actions
    template = <<-EOS
Test _cloudwatch_actions(ref_actions: [ "ec2 recover", "test" ])
    EOS
    act_template = run_client_as_json(template)
    exp_template = <<-EOS
{
  "Test": [
    {
      "Fn::Join": [
        "",
        [
          "arn:aws:automate:",
          {
            "Ref": "AWS::Region"
          },
          ":ec2:recover"
        ]
      ]
    },
    {
      "Ref": "Test"
    }
  ]
}
    EOS
    assert_equal exp_template.chomp, act_template
  end
end
