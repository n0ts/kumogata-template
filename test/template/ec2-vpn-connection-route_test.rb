require 'abstract_unit'

class Ec2VpnConnectionRouteTest < Minitest::Test
  def test_normal
    template = <<-EOS
_ec2_vpn_connection_route "test", ref_cidr: "test", ref_vpn: "test"
    EOS
    act_template = run_client_as_json(template)
    exp_template = <<-EOS
{
  "TestVpnConnectionRoute": {
    "Type": "AWS::EC2::VPNConnectionRoute",
    "Properties": {
      "DestinationCidrBlock": {
        "Ref": "TestCidr"
      },
      "VpnConnectionId": {
        "Ref": "TestVpnConnection"
      }
    }
  }
}
    EOS
    assert_equal exp_template.chomp, act_template
  end
end
