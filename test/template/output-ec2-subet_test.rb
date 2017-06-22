require 'abstract_unit'

class OutputAzTest < Minitest::Test
  def test_normal
    template = <<-EOS
_output_ec2_subnet "test"
    EOS
    act_template = run_client_as_json(template)
    exp_template = <<-EOS
{
  "TestSubnet": {
    "Description": "description of TestSubnet",
    "Value": {
      "Ref": "TestSubnet"
    }
  },
  "TestSubnetAz": {
    "Description": "description of TestSubnetAz",
    "Value": {
      "Fn::GetAtt": [
        "TestSubnet",
        "AvailabilityZone"
      ]
    }
  }
}
    EOS
    assert_equal exp_template.chomp, act_template
  end
end
