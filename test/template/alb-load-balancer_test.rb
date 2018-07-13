require 'abstract_unit'

class AlbLoadbalancerTest < Minitest::Test
  def test_normal
    template = <<-EOS
_alb_load_balancer "test", attributes: [ { test: "test" } ], ref_security_groups: [ "test" ]
    EOS
    act_template = run_client_as_json(template)
    exp_template = <<-EOS
{
  "TestLoadBalancer": {
    "Type": "AWS::ElasticLoadBalancingV2::LoadBalancer",
    "Properties": {
      "LoadBalancerAttributes": [
        {
          "Key": "test",
          "Value": "test"
        }
      ],
      "Name": {
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
      "SecurityGroups": [
        {
          "Ref": "TestSecurityGroup"
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
          }
        },
        {
          "Key": "Service",
          "Value": {
            "Ref": "Service"
          }
        },
        {
          "Key": "Version",
          "Value": {
            "Ref": "Version"
          }
        }
      ]
    }
  }
}
    EOS
    assert_equal exp_template.chomp, act_template
  end
end
