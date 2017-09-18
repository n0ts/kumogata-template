require 'abstract_unit'

class Ec2SecurityGroupIngressTest < Minitest::Test
  def test_normal
    template = <<-EOS
_ec2_security_group_ingress "test", from: 80
    EOS
    act_template = run_client_as_json(template)
    exp_template = <<-EOS
{
  "TestSecurityGroupIngress": {
    "Type": "AWS::EC2::SecurityGroupIngress",
    "Properties": {
      "CidrIp": "0.0.0.0/0",
      "FromPort": "80",
      "IpProtocol": "tcp",
      "ToPort": "80",
      "GroupName": "test"
    }
  }
}
    EOS
    assert_equal exp_template.chomp, act_template
  end
end
