require 'abstract_unit'

class Ec2EgressOnlyInternetGatewayTest < Minitest::Test
  def test_normal
    template = <<-EOS
_ec2_egress_only_internet_gateway "test", ref_vpc: "test"
    EOS
    act_template = run_client_as_json(template)
    exp_template = <<-EOS
{
  "TestEgressOnlyInternetGateway": {
    "Type": "AWS::EC2::EgressOnlyInternetGateway",
    "Properties": {
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
