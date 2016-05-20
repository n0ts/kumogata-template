require 'abstract_unit'

class Ec2EipAssociationTest < Minitest::Test
  def test_normal
    template = <<-EOS
_ec2_eip_association "test", allocation: "test", eip: "0.0.0.0"
    EOS
    act_template = run_client_as_json(template)
    exp_template = <<-EOS
{
  "TestEipAssociation": {
    "Type": "AWS::EC2::EIPAssociation",
    "Properties": {
      "AllocationId": "test",
      "EIP": "0.0.0.0"
    }
  }
}
    EOS
    assert_equal exp_template.chomp, act_template
  end
end
