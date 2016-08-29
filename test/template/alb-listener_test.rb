require 'abstract_unit'

class AlbListenerTest < Minitest::Test
  def test_normal
    template = <<-EOS
_alb_listener "test", actions: [ { ref_target: "test" } ], ref_lb: "test"
    EOS
    act_template = run_client_as_json(template)
    exp_template = <<-EOS
{
  "TestLoadBalancerListener": {
    "Type": "AWS::ElasticLoadBalancingV2::Listener",
    "Properties": {
      "DefaultActions": [
        {
          "TargetGroupArn": {
            "Ref": "TestTargetGroup"
          },
          "Type": "forward"
        }
      ],
      "LoadBalancerArn": {
        "Ref": "TestLoadBalancer"
      },
      "Port": "80",
      "Protocol": "HTTP"
    }
  }
}
    EOS
    assert_equal exp_template.chomp, act_template
  end
end
