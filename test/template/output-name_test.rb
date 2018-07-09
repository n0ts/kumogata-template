require 'abstract_unit'

class OutputNameTest < Minitest::Test
  def test_normal
    template = <<-EOS
_output_name "test"
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
  "TestNameName": {
    "Description": "description of TestNameName",
    "Value": {
      "Fn::GetAtt": [
        "Test",
        "Name"
      ]
    }
  }
}
    EOS
    assert_equal exp_template.chomp, act_template
  end
end
