require 'abstract_unit'

class Ec2VpnGatewayRoutePropagationTest < Minitest::Test
  def test_normal
    template = <<-EOS
_ec2_vpn_gateway_route_propagation "test", ref_routes: [ "test" ], ref_vpn: "test"
    EOS
    act_template = run_client_as_json(template)
    exp_template = <<-EOS
{
  "TestVpnGatewayRoutePropagation": {
    "Type": "AWS::EC2::VPNGatewayRoutePropagation",
    "Properties": {
      "RouteTableIds": [
        {
          "Ref": "TestRouteTable"
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
