require 'abstract_unit'

class Ec2SubnetNetworkAclAssociationTest < Minitest::Test
  def test_normal
    template = <<-EOS
_ec2_subnet_network_acl_association "test", ref_subnet: "test", ref_network_acl: "test"
    EOS
    act_template = run_client_as_json(template)
    exp_template = <<-EOS
{
  "TestSubnetNetworkAclAssociation": {
    "Type": "AWS::EC2::SubnetNetworkAclAssociation",
    "Properties": {
      "SubnetId": {
        "Ref": "TestSubnet"
      },
      "NetworkAclId": {
        "Ref": "TestNetworkAcl"
      }
    }
  }
}
    EOS
    assert_equal exp_template.chomp, act_template
  end
end
