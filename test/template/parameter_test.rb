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
    "Description": "test parameter description"
  }
}
    EOS
    assert_equal exp_template.chomp, act_template

    template = <<-EOS
_parameter "test", { default: "default", description: "desc", values: %w( 1 2 ) }
    EOS
    act_template = run_client_as_json(template)
    exp_template = <<-EOS
{
  "Test": {
    "Type": "String",
    "Default": "default",
    "Description": "desc",
    "AllowedValues": [
      "1",
      "2"
    ]
  }
}
    EOS
    assert_equal exp_template.chomp, act_template

    template = <<-EOS
_parameter "test password", { default: "default" }
    EOS
    act_template = run_client_as_json(template)
    exp_template = <<-EOS
{
  "TestPassword": {
    "Type": "String",
    "Default": "default",
    "Description": "test password parameter description",
    "NoEcho": "true"
  }
}
    EOS
    assert_equal exp_template.chomp, act_template

    template = <<-EOS
_parameter "test", { default: "default", type: "instance id" }
    EOS
    act_template = run_client_as_json(template)
    exp_template = <<-EOS
{
  "Test": {
    "Type": "AWS::EC2::Instance::Id",
    "Default": "default",
    "Description": "test parameter description"
  }
}
    EOS
    assert_equal exp_template.chomp, act_template
  end
end
