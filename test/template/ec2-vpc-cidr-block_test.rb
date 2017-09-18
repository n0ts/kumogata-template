require 'abstract_unit'

class Ec2VpcCidrBlockTest < Minitest::Test
  def test_normal
    template = <<-EOS
_ec2_vpc_cidr_block "test", ref_vpc: "test"
    EOS
    act_template = run_client_as_json(template)
    exp_template = <<-EOS
{
  "TestVpcCidrBlock": {
    "Type": "AWS::EC2::VPCCidrBlock",
    "Properties": {
      "AmazonProvidedIpv6CidrBlock": "true",
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
