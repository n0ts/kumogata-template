require 'abstract_unit'

class OutputIamRoleTest < Minitest::Test
  def test_normal
    template = <<-EOS
_output_iam_role "test"
    EOS
    act_template = run_client_as_json(template)
    exp_template = <<-EOS
{
  "TestRole": {
    "Description": "description of TestRole",
    "Value": {
      "Ref": "TestRole"
    }
  },
  "TestRoleArn": {
    "Description": "description of TestRoleArn",
    "Value": {
      "Fn::GetAtt": [
        "TestRole",
        "Arn"
      ]
    }
  }
}
    EOS
    assert_equal exp_template.chomp, act_template
  end
end
