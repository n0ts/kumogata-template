require 'abstract_unit'

class Test < Minitest::Test
  def test_normal
    template = <<-EOS
_ "test", { }
    EOS
    act_template = run_client_as_json(template)
    exp_template = <<-EOS
{
  "Test": {
    "Type": "AWS::::",
    "Properties": {
      "": "",
      "": [
        {
          "": ""
        }
      ]
    }
  }
}
    EOS
    assert_equal exp_template.chomp, act_template
  end
end
