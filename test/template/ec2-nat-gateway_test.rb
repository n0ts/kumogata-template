require 'abstract_unit'

class EC2NatGatewayTest < Minitest::Test
  def test_normal
    template = <<-EOS
_ec2_nat_gateway "test", allocation: "test", subnet: "test"
    EOS
    act_template = run_client_as_json(template)
    exp_template = <<-EOS
{
  "TestNatGateway": {
    "Type": "AWS::EC2::NatGateway",
    "Properties": {
      "AllocationId": "test",
      "SubnetId": "test"
    }
  }
}
    EOS
    assert_equal exp_template.chomp, act_template
  end
end
