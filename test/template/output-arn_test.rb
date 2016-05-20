require 'abstract_unit'

class OutputUserTest < Minitest::Test
  def test_normal
    template = <<-EOS
_output_arn "test"
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
  "TestArn": {
    "Description": "description of TestArn",
    "Value": {
      "Fn::GetAtt": [
        "Test",
        "Arn"
      ]
    }
  }
}
    EOS
    assert_equal exp_template.chomp, act_template
  end
end
