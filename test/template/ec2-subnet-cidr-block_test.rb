require 'abstract_unit'

class Ec2SubnetCidrBlockTest < Minitest::Test
  def test_normal
    template = <<-EOS
_ec2_subnet_cidr_block "test", ref_cidr: "test", ref_subnet: "test"
    EOS
    act_template = run_client_as_json(template)
    exp_template = <<-EOS
{
  "TestSubnetCidrBlock": {
    "Type": "AWS::EC2::SubnetCidrBlock",
    "Properties": {
      "Ipv6CidrBlock": {
        "Ref": "TestCidr"
      },
      "SubnetId": {
        "Ref": "TestSubnet"
      }
    }
  }
}
    EOS
    assert_equal exp_template.chomp, act_template
  end
end
