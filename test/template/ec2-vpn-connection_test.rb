require 'abstract_unit'

class Ec2VpnConnectionTest < Minitest::Test
  def test_normal
    template = <<-EOS
_ec2_vpn_connection "test", type: "test", ref_customer: "test", ref_vpn: "test"
    EOS
    act_template = run_client_as_json(template)
    exp_template = <<-EOS
{
  "TestVpnConnection": {
    "Type": "AWS::EC2::VPNConnection",
    "Properties": {
      "Type": "test",
      "CustomerGatewayId": {
        "Ref": "TestCustomerGateway"
      },
      "StaticRoutesOnly": "true",
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
      "VpnGatewayId": {
        "Ref": "TestVpnGateway"
      }
    }
  }
}
    EOS
    assert_equal exp_template.chomp, act_template
  end
end
