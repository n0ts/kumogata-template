require 'abstract_unit'

class Ec2SecurityGroupEgressTest < Minitest::Test
  def test_normal
    template = <<-EOS
_ec2_security_group_egress "test", group: "test", to: 80
    EOS
    act_template = run_client_as_json(template)
    exp_template = <<-EOS
{
  "TestSecurityGroupEgress": {
    "Type": "AWS::EC2::SecurityGroupEgress",
    "Properties": {
      "CidrIp": "0.0.0.0/0",
      "FromPort": "80",
      "IpProtocol": "tcp",
      "ToPort": "80",
      "GroupId": "test"
    }
  }
}
    EOS
    assert_equal exp_template.chomp, act_template
  end
end
