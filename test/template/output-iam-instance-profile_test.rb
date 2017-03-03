require 'abstract_unit'

class OutputIamInstancerProfileTest < Minitest::Test
  def test_normal
    template = <<-EOS
_output_iam_instance_profile "test"
    EOS
    act_template = run_client_as_json(template)
    exp_template = <<-EOS
{
  "TestInstanceProfile": {
    "Description": "description of TestInstanceProfile",
    "Value": {
      "Ref": "TestInstanceProfile"
    }
  },
  "TestInstanceProfileArn": {
    "Description": "description of TestInstanceProfileArn",
    "Value": {
      "Fn::GetAtt": [
        "TestInstanceProfile",
        "Arn"
      ]
    }
  }
}
    EOS
    assert_equal exp_template.chomp, act_template
  end
end
