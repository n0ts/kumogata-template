require 'abstract_unit'

class ParameterTest < Minitest::Test
  def test_normal
    template = <<-EOS
_parameter "test"
    EOS
    act_template = run_client_as_json(template)
    exp_template = <<-EOS
{
  "Test": {
    "Type": "String",
    "Default": "",
    "Description": ""
  }
}
    EOS
    assert_equal exp_template.chomp, act_template

    template = <<-EOS
_parameter "test", { type: "type", default: "default", description: "desc", allowed_values: [ "1", "2" ], no_echo: true }
    EOS
    act_template = run_client_as_json(template)
    exp_template = <<-EOS
{
  "Test": {
    "Type": "type",
    "Default": "default",
    "AllowedValues": [
      "1",
      "2"
    ],
    "Description": "desc",
    "NoEcho": "true"
  }
}
    EOS
    assert_equal exp_template.chomp, act_template
  end
end
