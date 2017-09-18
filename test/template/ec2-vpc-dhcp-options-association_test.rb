require 'abstract_unit'

class Ec2VpcDhcpOptionsAssociationTest < Minitest::Test
  def test_normal
    template = <<-EOS
_ec2_vpc_dhcp_options_association "test", ref_dhcp: "test", ref_vpc: "test"
    EOS
    act_template = run_client_as_json(template)
    exp_template = <<-EOS
{
  "TestVpcDhcpOptionsAssociation": {
    "Type": "AWS::EC2::VPCDHCPOptionsAssociation",
    "Properties": {
      "DhcpOptionsId": {
        "Ref": "TestDhcpOptions"
      },
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
