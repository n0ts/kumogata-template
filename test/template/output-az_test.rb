require 'abstract_unit'

class OutputAzTest < Minitest::Test
  # FIXME?
  def test_normal
    template = <<-EOS
_output_az "test"
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
