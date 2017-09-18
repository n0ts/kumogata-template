require 'abstract_unit'

class OutputAccessKeyTest < Minitest::Test
  def test_normal
    template = <<-EOS
_output_access_key "test"
    EOS
    act_template = run_client_as_json(template)
    exp_template = <<-EOS
{
  "TestAccessKey": {
    "Description": "description of TestAccessKey",
    "Value": {
      "Ref": "TestAccessKey"
    }
  },
  "TestSecretAccessKey": {
    "Description": "description of TestSecretAccessKey",
    "Value": {
      "Fn::GetAtt": [
        "TestAccessKey",
        "SecretAccessKey"
      ]
    }
  }
}
    EOS
    assert_equal exp_template.chomp, act_template
  end
end
