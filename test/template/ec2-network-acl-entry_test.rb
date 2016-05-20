require 'abstract_unit'

class Ec2NetworkAclEntryTest < Minitest::Test
  def test_normal
    template = <<-EOS
_ec2_network_acl_entry "test", ref_network_acl: "test"
    EOS
    act_template = run_client_as_json(template)
    exp_template = <<-EOS
{
  "TestNetworkAclEntry": {
    "Type": "AWS::EC2::NetworkAclEntry",
    "Properties": {
      "CidrBlock": "0.0.0.0/0",
      "Egress": "false",
      "NetworkAclId": {
        "Ref": "TestNetworkAcl"
      },
      "PortRange\": {
        "From": "0",
        "To": "65535"
      },
      "Protocol": "-1",
      "RuleAction": "allow",
      "RuleNumber": "100"
    }
  }
}
    EOS
    assert_equal exp_template.chomp, act_template
  end

  def test_aws
    template = <<-EOS
_ec2_network_acl_entry "test", ref_network_acl: "my", action: "allow", number: 100, cidr: "172.16.0.0/24", egress: true, from: 53
    EOS
    act_template = run_client_as_json(template)
    exp_template = <<-EOS
{
  "TestNetworkAclEntry": {
    "Type": "AWS::EC2::NetworkAclEntry",
    "Properties": {
      "CidrBlock": "172.16.0.0/24",
      "Egress": "true",
      "NetworkAclId": {
        "Ref": "MyNetworkAcl"
      },
      "PortRange\": {
        "From": "53",
        "To": "53"
      },
      "Protocol": "-1",
      "RuleAction": "allow",
      "RuleNumber": "100"
    }
  }
}
    EOS
    assert_equal exp_template.chomp, act_template
  end
end
