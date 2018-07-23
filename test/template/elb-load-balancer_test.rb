require 'abstract_unit'

class ElbLoadbalancerTest < Minitest::Test
  def test_normal
    template = <<-EOS
_elb_load_balancer "test", ref_security_groups: [ "test" ], listeners: [ protocol: "http" ]
    EOS
    act_template = run_client_as_json(template)
    exp_template = <<-EOS
{
  "TestLoadBalancer": {
    "Type": "AWS::ElasticLoadBalancing::LoadBalancer",
    "Properties": {
      "AvailabilityZones": {
        "Fn::GetAZs": {
          "Ref": "AWS::Region"
        }
      },
      "ConnectionDrainingPolicy": {
        "Enabled": "true",
        "Timeout": "60"
      },
      "ConnectionSettings": {
        "IdleTimeout": "60"
      },
      "CrossZone": "true",
      "HealthCheck": {
        "HealthyThreshold": "10",
        "Interval": "30",
        "Target": "HTTP:80/index.html",
        "Timeout": "5",
        "UnhealthyThreshold": "2"
      },
      "LoadBalancerName": {
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
      "Listeners": [
        {
          "InstancePort": "80",
          "InstanceProtocol": "HTTP",
          "LoadBalancerPort": "80",
          "Protocol": "HTTP"
        }
      ],
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
