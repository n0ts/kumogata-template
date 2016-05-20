require 'abstract_unit'

class OutputTest < Minitest::Test
  def test_normal
    template = <<-EOS
_output "test"
    EOS
    act_template = run_client_as_json(template)
    exp_template = <<-EOS
{
  "Test": {
    "Description": "description of Test",
    "Value": "Test"
  }
}
    EOS
    assert_equal exp_template.chomp, act_template

    template = <<-EOS
_output "test", { value: "test1" }
    EOS
    act_template = run_client_as_json(template)
    exp_template = <<-EOS
{
  "Test": {
    "Description": "description of Test",
    "Value": "test1"
  }
}
    EOS
    assert_equal exp_template.chomp, act_template

    template = <<-EOS
_output "test", { value: [ "test1", "test2" ] }
    EOS
    act_template = run_client_as_json(template)
    exp_template = <<-EOS
{
  "Test": {
    "Description": "description of Test",
    "Value": {
      "Fn::GetAtt": [
        "Test1",
        "test2"
      ]
    }
  }
}
    EOS
    assert_equal exp_template.chomp, act_template

    template = <<-EOS
_output "test", { ref_value: [ "test1", "test2" ] }
    EOS
    act_template = run_client_as_json(template)
    exp_template = <<-EOS
{
  "Test": {
    "Description": "description of Test",
    "Value": {
      "Fn::GetAtt": [
        "Test1",
        "test2"
      ]
    }
  }
}
    EOS
    assert_equal exp_template.chomp, act_template

    template = <<-EOS
_output "test", { ref_value: "test1" }
    EOS
    act_template = run_client_as_json(template)
    exp_template = <<-EOS
{
  "Test": {
    "Description": "description of Test",
    "Value": {
      "Ref": "Test1"
    }
  }
}
    EOS
    assert_equal exp_template.chomp, act_template
  end
end
