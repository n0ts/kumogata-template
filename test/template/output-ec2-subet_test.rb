require 'abstract_unit'

class OutputAzTest < Minitest::Test
  def test_normal
    template = <<-EOS
_output_ec2_subnet "test"
    EOS
    act_template = run_client_as_json(template)
    exp_template = <<-EOS
{
  "TestName": {
    "Description": "description of TestName",
    "Value": {
      "Ref": "Test"
    }
  },
  "TestCidr": {
    "Description": "description of TestCidr",
    "Value": {
      "Fn::GetAtt": [
        "Test",
        "AvailabilityZone"
      ]
    }
  }
}
    EOS
    assert_equal exp_template.chomp, act_template
  end
end
