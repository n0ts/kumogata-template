require 'abstract_unit'

class AlbTargetGroupTest < Minitest::Test
  def test_normal
    template = <<-EOS
_alb_target_group "test", attributes: [ { key: "value" } ], targets: [ { ref_instance: "test" } ], ref_vpc: "test"
    EOS
    act_template = run_client_as_json(template)
    exp_template = <<-EOS
{
  "TestTargetGroup": {
    "Type": "AWS::ElasticLoadBalancingV2::TargetGroup",
    "Properties": {
      "HealthCheckIntervalSeconds": "30",
      "HealthCheckPath": "/",
      "HealthCheckPort": "80",
      "HealthCheckProtocol": "HTTP",
      "HealthCheckTimeoutSeconds": "5",
      "HealthyThresholdCount": "10",
      "Matcher": {
        "HttpCode": "200"
      },
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
      "Port": "80",
      "Protocol": "HTTP",
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
      ],
      "TargetGroupAttributes": [
        {
          "Key": "key",
          "Value": "value"
        }
      ],
      "Targets": [
        {
          "Id": {
            "Ref": "TestInstance"
          }
        }
      ],
      "UnhealthyThresholdCount": "2",
      "VpcId": {
        "Ref": "TestVpc"
      }
    }
  }
}
    EOS
    assert_equal exp_template.chomp, act_template
  end
end
