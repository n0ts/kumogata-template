require 'abstract_unit'

class Ec2VpnGatewayTest < Minitest::Test
  def test_normal
    template = <<-EOS
_ec2_vpn_gateway "test", type: "test"
    EOS
    act_template = run_client_as_json(template)
    exp_template = <<-EOS
{
  "TestVpnGateway": {
    "Type": "AWS::EC2::VPNGateway",
    "Properties": {
      "Type": "test",
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
