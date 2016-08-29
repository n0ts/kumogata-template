require 'abstract_unit'

class AlbListenerRuleTest < Minitest::Test
  def test_normal
    template = <<-EOS
_alb_listener_rule "test", actions: [ { ref_target: "test" } ], ref_listener: "test", conditions: [ [ "/img/*" ] ]
    EOS
    act_template = run_client_as_json(template)
    exp_template = <<-EOS
{
  "TestLoadBalancerListenerRule": {
    "Type": "AWS::ElasticLoadBalancingV2::ListenerRule",
    "Properties": {
      "Actions": [
        {
          "TargetGroupArn": {
            "Ref": "TestTargetGroup"
          },
          "Type": "forward"
        }
      ],
      "Conditions": [
        {
          "Field": "path-pattern",
          "Values": [
            "/img/*"
          ]
        }
      ],
      "ListenerArn": {
        "Ref": "TestLoadBalancerListener"
      },
      "Priority": "1"
    }
  }
}
    EOS
    assert_equal exp_template.chomp, act_template
  end
end
